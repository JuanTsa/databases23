DELIMITER //
CREATE TRIGGER update_available_copies
BEFORE INSERT ON Reservation
FOR EACH ROW
BEGIN
  UPDATE Book
  SET Available_Copies = Available_Copies - 1
  WHERE Book_ID = NEW.Book_ID;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER update_available_copies_borrowing
BEFORE INSERT ON Borrowing
FOR EACH ROW
BEGIN
  UPDATE Book
  SET Available_Copies = Available_Copies - 1
  WHERE Book_ID = NEW.Book_ID;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER update_available_copies_returning
BEFORE UPDATE ON Borrowing
FOR EACH ROW
BEGIN
  IF NEW.Status = 'Approved' AND OLD.Status = 'Rejected' THEN
    UPDATE Book
    SET Available_Copies = Available_Copies + 1
    WHERE Book_ID = NEW.Book_ID;
  END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER update_copies_borrowed
BEFORE INSERT ON Borrowing
FOR EACH ROW
BEGIN
  UPDATE User
  SET Copies_Borrowed = Copies_Borrowed + 1
  WHERE User_ID = NEW.User_ID;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER update_copies_borrowed_returning
BEFORE UPDATE ON Borrowing
FOR EACH ROW
BEGIN
  IF NEW.Status = 'Approved' AND OLD.Status = 'Rejected' THEN
    UPDATE User
    SET Copies_Borrowed = Copies_Borrowed + 1
    WHERE User_ID = NEW.User_ID;
  END IF;
  IF NEW.Status = 'Rejected' AND OLD.Status = 'Approved' THEN
    UPDATE User
    SET Copies_Borrowed = Copies_Borrowed - 1
    WHERE User_ID = NEW.User_ID;
  END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER enforce_max_copies_borrowed
BEFORE INSERT ON Borrowing
FOR EACH ROW
BEGIN
  DECLARE borrowed_count INT;
  SELECT COUNT(*) INTO borrowed_count
  FROM Borrowing
  WHERE User_ID = NEW.User_ID AND (Status = 'Approved' OR Status = 'On Hold');

  IF borrowed_count >= (SELECT Max_Copies_Borrowed FROM User WHERE User_ID = NEW.User_ID) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'User has reached the maximum number of borrowed copies.';
  END IF;
END;
//
DELIMITER ;
