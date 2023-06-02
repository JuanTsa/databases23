---- View triggers
SELECT TRIGGER_SCHEMA, TRIGGER_NAME, EVENT_OBJECT_TABLE, ACTION_TIMING, ACTION_STATEMENT
FROM information_schema.TRIGGERS
WHERE TRIGGER_SCHEMA = 'asd';

---- CHANGE Copies_Borrowed/Reserved WHEN New_Borrowing/Reservation
DELIMITER $$
CREATE TRIGGER update_user_borrowing
AFTER INSERT ON `Borrowing`
FOR EACH ROW
BEGIN
    UPDATE `User`
    SET `Copies_Borrowed` = `Copies_Borrowed` + 1
    WHERE `User_ID` = NEW.`User_ID`;
END$$

DELIMITER $$
CREATE TRIGGER update_user_borrowing
AFTER INSERT ON `Reservation`
FOR EACH ROW
BEGIN
    UPDATE `User`
    SET `Copies_Reserved` = `Copies_Reserved` + 1
    WHERE `User_ID` = NEW.`User_ID`;
END$$


---- CHANGE Available_Copies WHEN New_Borrowing
DELIMITER $$
CREATE TRIGGER update_book_borrowing
AFTER INSERT ON `Borrowing`
FOR EACH ROW
BEGIN
    UPDATE `Book`
    SET `Available_Copies` = `Available_Copies` - 1
    WHERE `Book_ID` = NEW.`Book_ID`;
END$$


---- CHANGE Available_Copies WHEN Completed_Borrowing
DELIMITER $$
CREATE TRIGGER update_book_returning
AFTER UPDATE ON `Borrowing`
FOR EACH ROW
BEGIN
    IF NEW.`Returning_Date` IS NOT NULL AND NEW.`Returning_Date` != '' THEN
        UPDATE `Book`
        SET `Available_Copies` = `Available_Copies` + 1
        WHERE `Book_ID` = OLD.`Book_ID`;
    END IF;
END$$


---- WHEN Duplicate_Review
DELIMITER $$
CREATE TRIGGER prevent_duplicate_reviews
BEFORE INSERT ON `Review`
FOR EACH ROW
BEGIN
    DECLARE review_count INT;
    SET review_count = (SELECT COUNT(*) FROM `Review` WHERE `Book_ID` = NEW.`Book_ID` AND `User_ID` = NEW.`User_ID`);
    IF review_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Duplicate review not allowed.';
    END IF;
END$$


---- ENFORCE max_copies_borrowed WHEN New_Borrowing
DELIMITER $$
CREATE TRIGGER enforce_max_borrowed_copies
BEFORE INSERT ON `Borrowing`
FOR EACH ROW
BEGIN
    DECLARE borrowed_count INT;
    SET borrowed_count = (SELECT COUNT(*) FROM `Borrowing` WHERE `User_ID` = NEW.`User_ID` AND `Status` = 'Approved');
    IF borrowed_count >= (SELECT `Max_Copies_Borrowed` FROM `User` WHERE `User_ID` = NEW.`User_ID`) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Maximum borrowed copies reached.';
    END IF;
END$$


---- ENFORCE max_copies_reserved WHEN New_Reservation
DELIMITER $$
CREATE TRIGGER enforce_max_reserved_copies
BEFORE INSERT ON `Reservation`
FOR EACH ROW
BEGIN
    DECLARE reserved_count INT;
    SET reserved_count = (SELECT COUNT(*) FROM `Reservation` WHERE `User_ID` = NEW.`User_ID` AND `Status` = 'Approved');
    IF reserved_count >= (SELECT `Max_Copies_Reserved` FROM `User` WHERE `User_ID` = NEW.`User_ID`) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Maximum reserved copies reached.';
    END IF;
END$$


