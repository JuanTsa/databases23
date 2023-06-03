constraint για αλλαγή available στον δανεισμό/επιστροφή

constraint για παλαιότερο reservation μόλις υπάρξει available να γίνει on hold borrow

-- ----------
-- TRIGGER 1
-- ----------
-- Check whenever a user makes a new borrowing request, if they have the right do so (without actually increasing the value of copies_borrowed)
DELIMITER //
CREATE TRIGGER before_borrowing_insert
BEFORE INSERT ON Borrowing
FOR EACH ROW
BEGIN
  DECLARE total_borrowed INT;
  DECLARE max_copies INT;
  
  -- Get the total number of copies already borrowed by the user
  SELECT Copies_Borrowed INTO total_borrowed
  FROM User
  WHERE User_ID = NEW.User_ID;
  
  -- Get the maximum number of copies allowed for the user
  SELECT Max_Copies INTO max_copies
  FROM User
  WHERE User_ID = NEW.User_ID;
  
  -- Check if the new borrowing would exceed the maximum number of copies
  IF (total_borrowed + 1 > max_copies) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'New borrowing exceeds the maximum number of copies allowed.';
  END IF;
END //

-- ----------
-- TRIGGER 2
-- ----------
-- Check whenever a user makes a new reservation request, if they have the right do so (without actually increasing the value of copies_reserved)
CREATE TRIGGER before_reservation_insert
BEFORE INSERT ON Reservation
FOR EACH ROW
BEGIN
  DECLARE total_reserved INT;
  DECLARE max_copies INT;
  
  -- Get the total number of copies already reserved by the user
  SELECT Copies_Reserved INTO total_reserved
  FROM User
  WHERE User_ID = NEW.User_ID;
  
  -- Get the maximum number of copies allowed for the user
  SELECT Max_Copies INTO max_copies
  FROM User
  WHERE User_ID = NEW.User_ID;
  
  -- Check if the new reservation would exceed the maximum number of copies
  IF (total_reserved + 1 > max_copies) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'New reservation exceeds the maximum number of copies allowed.';
  END IF;
END //

-- ----------
-- TRIGGER 3
-- ----------
-- Increase the copies_borrowed whenever a borrowing is approved
CREATE TRIGGER increase_copies_borrowed
AFTER UPDATE ON Borrowing
FOR EACH ROW
BEGIN
  DECLARE user_id INT;
  
  -- Check if the status has changed from 'On Hold' to 'Approved'
  IF (OLD.Status = 'On Hold' AND NEW.Status = 'Approved') THEN
    -- Get the user ID who made the borrowing request
    SET user_id = NEW.User_ID;
  
    -- Update the copies_borrowed for the user
    UPDATE User
    SET Copies_Borrowed = Copies_Borrowed + 1
    WHERE User_ID = user_id;
  END IF;
END //

-- ----------
-- TRIGGER 4
-- ----------
-- Increase the copies_borrowed whenever a reservation is approved
CREATE TRIGGER increase_copies_reserved
AFTER UPDATE ON Reservation
FOR EACH ROW
BEGIN
  DECLARE user_id INT;
  
  -- Check if the status has changed from 'On Hold' to 'Approved'
  IF (OLD.Status = 'On Hold' AND NEW.Status = 'Approved') THEN
    -- Get the user ID who made the reservation request
    SET user_id = NEW.User_ID;
  
    -- Update the copies_borrowed for the user
    UPDATE User
    SET Copies_Reserved = Copies_Reserved + 1
    WHERE User_ID = user_id;
  END IF;
END //

-- ----------
-- TRIGGER 5
-- ----------
-- Check whether there are any available_copies before making a new borrowing
CREATE TRIGGER check_available_copies
BEFORE INSERT ON Borrowing
FOR EACH ROW
BEGIN
  DECLARE available INT;
  
  -- Get the available_copies of the book being borrowed
  SELECT Available_Copies INTO available
  FROM Book
  WHERE Book_ID = NEW.Book_ID;
  
  -- Check if the available_copies is zero
  IF (available = 0) THEN
    -- Raise an error and prevent the new borrowing from being inserted
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No available copies for this book. You should request a reservation.';
  END IF;
END //

-- ----------
-- TRIGGER 6
-- ----------
-- Check whether there are any available_copies before making a new reservation
CREATE TRIGGER check_available_copies_vol2
BEFORE INSERT ON Reservation
FOR EACH ROW
BEGIN
  DECLARE available INT;
  
  -- Get the available_copies of the book being reserved
  SELECT Available_Copies INTO available
  FROM Book
  WHERE Book_ID = NEW.Book_ID;
  
  -- Check if the available_copies is not zero
  IF (available <> 0) THEN
    -- Raise an error and prevent the new reservation from being inserted
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Available copies exist for this book. You should request a borrowing.';
  END IF;
END //

-- ----------
-- TRIGGER 7
-- ----------
-- Check whether the user has a delayed borrowing before making a new borrowing
CREATE TRIGGER check_delayed_borrowing
BEFORE INSERT ON Borrowing
FOR EACH ROW
BEGIN
  DECLARE delayed_count INT;
  
  -- Count the number of delayed borrowings for the user
  SELECT COUNT(*) INTO delayed_count
  FROM Borrowing
  WHERE User_ID = NEW.User_ID
    AND Returning_Date < CURDATE()
    AND Status = 'Approved';
  
  -- Check if there are any delayed borrowings
  IF (delayed_count > 0) THEN
    -- Raise an error and prevent the new borrowing from being inserted
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User has delayed borrowings. New borrowing not allowed.';
  END IF;
END //

-- ----------
-- TRIGGER 8
-- ----------
-- Check whether the user has a delayed borrowing before making a new reservation
CREATE TRIGGER check_delayed_borrowing_vol2
BEFORE INSERT ON Reservation
FOR EACH ROW
BEGIN
  DECLARE delayed_count INT;
  
  -- Count the number of delayed borrowings for the user
  SELECT COUNT(*) INTO delayed_count
  FROM Borrowing
  WHERE User_ID = NEW.User_ID
    AND Returning_Date < CURDATE()
    AND Status = 'Approved';
  
  -- Check if there are any delayed borrowings
  IF (delayed_count > 0) THEN
    -- Raise an error and prevent the new reservation from being inserted
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User has delayed borrowings. New reservation not allowed.';
  END IF;
END //
DELIMETER ;

-- ----------
-- TRIGGER 9
-- ----------
-- Check whether the user tries to make a new borrowing on a already owned book
CREATE TRIGGER check_duplicate_borrowing
BEFORE INSERT ON Borrowing
FOR EACH ROW
BEGIN
  DECLARE borrowing_count INT;
  
  -- Count the number of existing borrowings for the user and book
  SELECT COUNT(*) INTO borrowing_count
  FROM Borrowing
  WHERE User_ID = NEW.User_ID
    AND Book_ID = NEW.Book_ID;
  
  -- Check if the user has already borrowed the book
  IF (borrowing_count > 0) THEN
    -- Raise an error and prevent the new borrowing from being inserted
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User has already borrowed this book. Duplicate borrowing not allowed.';
  END IF;
END //

-- ----------
-- TRIGGER 10
-- ----------
-- Check whether the user tries to make a new reservation on a already owned book
CREATE TRIGGER check_duplicate_reservation
BEFORE INSERT ON Reservation
FOR EACH ROW
BEGIN
  DECLARE borrowing_count INT;
  
  -- Count the number of existing borrowings for the book
  SELECT COUNT(*) INTO borrowing_count
  FROM Borrowing
  WHERE Book_ID = NEW.Book_ID;
  
  -- Check if the book is already borrowed
  IF (borrowing_count > 0) THEN
    -- Raise an error and prevent the new reservation from being inserted
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The book is already borrowed. Reservation not allowed.';
  END IF;
END //

-- ----------
-- TRIGGER 11
-- ----------
-- Check whether the user tries to make a new reservation on a already reserved book
CREATE TRIGGER check_duplicate_reservation_vol2
BEFORE INSERT ON Reservation
FOR EACH ROW
BEGIN
  DECLARE reservation_count INT;
  
  -- Count the number of existing reservations for the book
  SELECT COUNT(*) INTO reservation_count
  FROM Reservation
  WHERE Book_ID = NEW.Book_ID
    AND Status = 'On Hold';
  
  -- Check if the book already has a reservation
  IF (reservation_count > 0) THEN
    -- Raise an error and prevent the new reservation from being inserted
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The book already has a reservation requested. New reservation not allowed.';
  END IF;
END //

-- ----------
-- TRIGGER 12
-- ----------
-- Decrease the available copies of a book whenever a borrowing is approved
CREATE TRIGGER update_available_copies
AFTER UPDATE ON Borrowing
FOR EACH ROW
BEGIN
  IF (NEW.Status = 'Approved' AND OLD.Status = 'On Hold') THEN
    UPDATE Book
    SET available_copies = available_copies - 1
    WHERE Book_ID = NEW.Book_ID;
  END IF;
END //

-- ----------
-- TRIGGER 13
-- ----------
-- Increase the available copies of a book whenever a borrowing is completed
CREATE TRIGGER update_available_copies_vol2
AFTER UPDATE ON Borrowing
FOR EACH ROW
BEGIN
  IF (NEW.Returning_Date <> OLD.Returning_Date) THEN
    UPDATE Book
    SET available_copies = available_copies + 1
    WHERE Book_ID = NEW.Book_ID;
  END IF;
END //
