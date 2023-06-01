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
