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

---- ENFORCE not new_borrow WHEN delayed_book
DELIMITER $$
CREATE TRIGGER prevent_borrowing_due_to_delay
BEFORE INSERT ON `Borrowing`
FOR EACH ROW
BEGIN
    DECLARE user_id INT;
    DECLARE delayed_count INT;
    
    -- Get the user ID of the borrower
    SET user_id = NEW.`User_ID`;
    
    -- Check if the user has any delayed borrowings (including empty returning_date)
    SELECT COUNT(*) INTO delayed_count
    FROM `Borrowing`
    WHERE `User_ID` = user_id
        AND (`Returning_Date` < CURDATE() OR `Returning_Date` = '')
        AND `Status` = 'Approved';
    
    -- If there are any delayed borrowings, prevent the insertion
    IF delayed_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot borrow the book. User has overdue borrowings.';
    END IF;
END$$

---- ENFORCE not new_borrow WHEN borrowing the same book
DELIMITER $$
CREATE TRIGGER prevent_duplicate_borrowing
BEFORE INSERT ON Borrowing
FOR EACH ROW
BEGIN
  DECLARE existing_count INT;

  -- Check if the user already has a borrowing entry for the book
  SELECT COUNT(*) INTO existing_count
  FROM Borrowinge
  WHERE Book_ID = NEW.Book_ID AND User_ID = NEW.User_ID AND Returning_Date IS NULL;

  -- If the count is greater than 0, it means the user already has the book on borrowing
  IF existing_count > 0 THEN
    SIGNAL SQLSTATE '45000' -- Raise an error
      SET MESSAGE_TEXT = 'User already has the book on borrowing.';
  END IF;
END$$

---- ENFORCE not new_reservation WHEN having borrowed the same book
DELIMITER //
CREATE TRIGGER prevent_duplicate_reservation
BEFORE INSERT ON Reservation
FOR EACH ROW
BEGIN
  DECLARE borrowing_count INT;

  -- Check if the user already has an active borrowing for the book
  SELECT COUNT(*) INTO borrowing_count
  FROM Borrowing
  WHERE Book_ID = NEW.Book_ID AND User_ID = NEW.User_ID AND Returning_Date IS NULL;

  -- If the count is greater than 0, it means the user already has the book on borrowing
  IF borrowing_count > 0 THEN
    SIGNAL SQLSTATE '45000' -- Raise an error
      SET MESSAGE_TEXT = 'User already has the book on borrowing and cannot reserve it.';
  END IF;
END //

---- ENFORCE not new_reservation WHEN reserving the same book
DELIMITER //
CREATE TRIGGER prevent_duplicate_reservation
BEFORE INSERT ON Reservation
FOR EACH ROW
BEGIN
  DECLARE existing_count INT;

  -- Check if the user already has a reservation for the book
  SELECT COUNT(*) INTO existing_count
  FROM Reservation
  WHERE Book_ID = NEW.Book_ID AND User_ID = NEW.User_ID AND Status = 'On Hold';

  -- If the count is greater than 0, it means the user already has a reservation for the book
  IF existing_count > 0 THEN
    SIGNAL SQLSTATE '45000' -- Raise an error
      SET MESSAGE_TEXT = 'User already has a reservation for the book.';
  END IF;
END //


---- ENFORCE not new_borrow WHEN borrowing from another school
DELIMITER //
CREATE TRIGGER prevent_borrowing_from_other_school
BEFORE INSERT ON Borrowing
FOR EACH ROW
BEGIN
  DECLARE book_school_id INT;

  -- Get the school ID of the book being borrowed
  SELECT School_ID INTO book_school_id
  FROM Book
  WHERE Book_ID = NEW.Book_ID;

  -- Check if the book belongs to a different school
  IF book_school_id <> NEW.User_ID THEN
    SIGNAL SQLSTATE '45000' -- Raise an error
      SET MESSAGE_TEXT = 'Cannot borrow a book from another school.';
  END IF;
END //


---- ENFORCE not new_reservation WHEN reserving from another school
DELIMITER //
CREATE TRIGGER prevent_reservation_for_other_school
BEFORE INSERT ON Reservation
FOR EACH ROW
BEGIN
  DECLARE book_school_id INT;

  -- Get the school ID of the book being reserved
  SELECT School_ID INTO book_school_id
  FROM Book
  WHERE Book_ID = NEW.Book_ID;

  -- Check if the book belongs to a different school
  IF book_school_id <> NEW.User_ID THEN
    SIGNAL SQLSTATE '45000' -- Raise an error
      SET MESSAGE_TEXT = 'Cannot reserve a book from another school.';
  END IF;
END //


---- ENFORCE not new_book WHEN new_book already exists in the school (doesn't have a problem with the same book existing in another school)
DELIMITER //
CREATE TRIGGER prevent_duplicate_book
BEFORE INSERT ON Book
FOR EACH ROW
BEGIN
  DECLARE existing_count INT;

  -- Check if the book already exists in the same school
  SELECT COUNT(*) INTO existing_count
  FROM Book
  WHERE School_ID = NEW.School_ID AND Title = NEW.Title;

  -- If the count is greater than 0, it means the book already exists in the same school
  IF existing_count > 0 THEN
    SIGNAL SQLSTATE '45000' -- Raise an error
      SET MESSAGE_TEXT = 'The book already exists in the school.';
  END IF;
END //
