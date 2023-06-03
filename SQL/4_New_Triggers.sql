constraint για νέο δανεισμό/κράτηση ενώ έχω 2 βιβλία
θέλω ένα trigger για όταν ο user /πάει/ να κάνει δανεισμό και ένα όταν o operator το κάνει approve

constraint για νέο δανεισμό/κράτηση ενώ έχω εκπρόθεσμο

constraint για νέο δανεισμό/κράτηση ενώ έχω ίδιο βιβλίο

constraint για νέα κράτηση ενώ έχω ίδια κράτηση

constraint για αλλαγή available στον δανεισμό/επιστροφή

constraint για παλαιότερο reservation μόλις υπάρξει available να γίνει on hold borrow


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

-- Check whenever a user makes a new reservation request, if they have the right do so (without actually increasing the value of copies_reserved)
DELIMITER //
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

-- Increase the copies_borrowed whenever a borrowing is approved
DELIMITER //
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

