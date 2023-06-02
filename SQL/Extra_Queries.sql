-- I put here some extra queries for the website
-- You'd change only the <...> with the desired variable. If something is in this format: '<...>' DO NOT DELETE the single quotes ''.


-- ----------------
-- ADMINISTRATOR
-- ----------------
---- New_School
INSERT INTO `School_Unit` (`School_Name`, `Address`, `Phone`, `Email`, `Principal_Name`, `Principal_Surname`) VALUES ('<school_name>', '<address>', <phone>, '<email>', '<principal_name>', '<principal_surname>');

---- Alter_School

---- New_Operator (so by default some values)
INSERT INTO `User` (`School_ID`, `Username`, `Password`, `Name`, `Surname`, `Email`, `Age`, `Copies_Borrowed`, `Copies_Reserved`, `Max_Copies_Borrowed`, `Max_Copies_Reserved`, `User_Type`, `Status`) 
VALUES ('<school_id>', '<username>', '<password>', '<name>', '<surname>', '<email>', <age>, 0, 0, 0, 0, 'Operator', 'Approved');

---- Alter_Operator

---- Approve_Operator

---- Backup

---- Restore



-- ----------------
-- OPERATOR (only for their school)
-- ----------------
---- (-) New_User
---- (-) Alter_User
---- Approve_User
---- Delete_User

---- New_Book
---- Alter_Book
---- (-) Delete_Book

---- (-) New_Loan
---- Approve_Loan

---- Show_Loans_Per_User (history)
SELECT b.Borrowing_ID, b.Book_ID, bk.Title, u.Username, u.Name, u.Surname, b.Borrow_Date, b.Due_Date, b.Returning_Date
FROM Borrowing b
INNER JOIN User u ON b.User_ID = u.User_ID
INNER JOIN Book bk ON b.Book_ID = bk.Book_ID
WHERE u.School_ID = (SELECT School_ID FROM User WHERE User_ID = <operator_user_id>);			-- Replace with the desired element

---- Show_Loans_Per_User (active)
SELECT b.Borrowing_ID, b.Book_ID, bk.Title, u.Username, u.Name, u.Surname, b.Borrow_Date, b.Due_Date, b.Returning_Date
FROM Borrowing b
INNER JOIN User u ON b.User_ID = u.User_ID
INNER JOIN Book bk ON b.Book_ID = bk.Book_ID
WHERE u.School_ID = (SELECT School_ID FROM User WHERE User_ID = <operator_user_id>)			-- Replace with the desired element
  AND b.Returning_Date IS NULL;

---- New_Return
---- Delayed_Loans

---- (-) New_Reservation
---- Approve_Reservation

---- Show_Reservations_Per_User (history)
SELECT r.Reservation_ID, r.Book_ID, bk.Title, u.Username, u.Name, u.Surname, r.Request_Date, r.Status
FROM Reservation r
INNER JOIN User u ON r.User_ID = u.User_ID
INNER JOIN Book bk ON r.Book_ID = bk.Book_ID
WHERE u.School_ID = (SELECT School_ID FROM User WHERE User_ID = <operator_user_id>)			-- Replace with the desired element
  AND r.Status = 'Approved';
  
---- Show_Reservations_Per_User (active)
SELECT r.Reservation_ID, r.Book_ID, bk.Title, u.Username, u.Name, u.Surname, r.Request_Date, r.Status
FROM Reservation r
INNER JOIN User u ON r.User_ID = u.User_ID
INNER JOIN Book bk ON r.Book_ID = bk.Book_ID
WHERE u.School_ID = (SELECT School_ID FROM User WHERE User_ID = <operator_user_id>)			-- Replace with the desired element
  AND r.Status = 'Approved'
  AND r.Returning_Date IS NULL;

---- Approve_Review
---- Show_Reviews_Per_User

---- New_Category
INSERT INTO `Category` (`Category_Name`) VALUES ('<category_name>');

---- New_Author
INSERT INTO `Author` (`Author_Name`, `Author_Surname`) VALUES ('<author_name>', '<author_surname>');

---- adds a new user
-- school_id should be the same as the logged_in operator's school_id
-- max_copies should automatically take a value, depending on the user
INSERT INTO `User` (`School_ID`, `Username`, `Password`, `Name`, `Surname`, `Email`, `Age`, `Copies_Borrowed`, `Copies_Reserved`, `Max_Copies_Borrowed`, `Max_Copies_Reserved`, `User_Type`, `Status`)
VALUES (<school_id>, '<username>', '<password>', '<name>', '<surname>', '<email>', <age>, 0, 0, <max_copies_borrowed>, <max_copies_reserved>, '<user_type>', 'Approved');

---- list with all users that have not been approved

---- adds a new book
-- school_id should be the same as the logged_in operator's school_id
-- available_copies should automatically take the same value as inventory
-- cover should not be a necessary field
INSERT INTO `Book` (`ISBN`, `School_ID`, `Title`, `Publisher`, `Pages`, `Summary`, `Available_Copies`, `Cover`, `Language`, `Keywords`, `Inventory`)
VALUES (<isbn>, <school_id>, '<title>', '<publisher', <pages>, '<summary>', <available_copies>, '<cover>', '<language>', '<keywords>', <inventory>);

INSERT INTO `Book_Author` (`Author_ID`, `Book_ID`) VALUES (1, 1);

INSERT INTO `Book_Category` (`Category_ID`, `Book_ID`) VALUES (1, 1);

INSERT INTO `Borrowing` (`Borrowing_ID`, `Book_ID`, `User_ID`, `Borrow_Date`, `Due_Date`, `Returning_Date`, `Status`) VALUES (1, 7, 18, '2022-09-28', '2022-10-05', '2022-10-11', 'Approved'),

INSERT INTO `Reservation` (`Reservation_ID`, `Book_ID`, `User_ID`, `Request_Date`, `Status`) VALUES (1, 62, 60, '2022-07-11', 'Approved'),

INSERT INTO `Review` (`Review_ID`, `Review_Text`, `Book_ID`, `User_ID`, `Rating`, `Status`) VALUES (1, 'An awesome, page-turner, book. My review does not apply to my rating!', 28, 22, 5, 'Approved');

-- ----------------
-- STUDENTS AND TEACHERS
-- ----------------
---- Show_My_Loans
---- Show_My_Reservatiosn
---- Show_My_Reviews

---- New_Loan
---- New_Reservation
---- New_Review
---- (-) Cancel_Reservation

-- ----------------
-- ALL_USERS
-- ----------------
---- View_Books_In_My_School
	---- \>> admin can see all schools
---- My_Profile
	---- \>> all users except students can change all info
	---- |>> students can change only pwd
