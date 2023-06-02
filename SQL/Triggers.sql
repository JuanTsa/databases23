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
CREATE TRIGGER update_user_reserved
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


---- DELETE Reservation WHEN 7 days are past
DELIMITER $$
CREATE TRIGGER delete_expired_reservation
BEFORE INSERT ON `Reservation`
FOR EACH ROW
BEGIN
    IF NEW.`request_date` < DATE_SUB(CURDATE(), INTERVAL 7 DAY) THEN
        DELETE FROM `Reservation` WHERE `Reservation_ID` = NEW.`Reservation_ID`;
    END IF;
END$$

---- NOT NEW BORROW IF DELAYED

---- reservation/borrowing cannot be done if you have the same copy
---- reservation/borrowing cannot be done from another school
---- reservation/borrowing cannot be done if available_copies = 0

---- New_Book to School_Unit with != ISBN
---- Το ισβν δεν χρειάζεται να είναι unique, αρκεί να μην βάλει στο ίδιο σχολείο το ίδιο βιβλίο
---- σε διαφορετικά σχολεία το ίδιο βιβλίο είναι κομπλέ
---- βγάλε το unique

---- trigger review, check for status=approved?
---- check isbn if it is 13-digit

