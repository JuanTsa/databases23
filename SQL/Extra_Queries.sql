-- You'd change only the <...> with the desired variable. If something is in this format: '<...>' DO NOT DELETE the single quotes ''.
-- This symbol (-) means that Chris' team haven't included it in their database

-- ----------------
-- ----------------
-- ADMINISTRATOR
-- ----------------
-- ----------------
---- New_School
INSERT INTO `School_Unit` (`School_Name`, `Address`, `Phone`, `Email`, `Principal_Name`, `Principal_Surname`)
VALUES ('<school_name>', '<address>', <phone>, '<email>', '<principal_name>', '<principal_surname>'); -- Replace with the desired elements

---- Alter_School

---- New_Operator (so by default some values)
INSERT INTO `User` (`School_ID`, `Username`, `Password`, `Name`, `Surname`, `Email`, `Age`, `Copies_Borrowed`, `Copies_Reserved`, `Max_Copies_Borrowed`, `Max_Copies_Reserved`, `User_Type`, `Status`) 
VALUES ('<school_id>', '<username>', '<password>', '<name>', '<surname>', '<email>', <age>, 0, 0, 0, 0, 'Operator', 'Approved'); -- Replace with the desired elements

---- Alter_Operator

---- Approve_Operator
SELECT * FROM User WHERE User_Type = 'Operator' AND Status = 'On Hold';

---- Backup

---- Restore




-- ----------------
-- ----------------
-- OPERATOR (only for their school)
-- ----------------
-- ----------------
---- (-) New_User
--    \>>max_copies should automatically take a value, depending on the user
---- (-) Alter_User
---- Approve_User
---- Delete_User

---- New_Book
-- 	\>> available_copies should automatically take the same value as inventory
-- 	\>> cover should not be a necessary field
---- Alter_Book
---- (-) Delete_Book

---- (-) New_Loan
---- New_Return
---- (-) New_Reservation

---- Approve_Loan
SELECT br.Borrowing_ID, br.Book_ID, bk.Title, u.Username, u.Name, u.Surname, br.Borrow_Date, br.Due_Date, br.Returning_Date
FROM Borrowing br
INNER JOIN User u ON br.User_ID = u.User_ID
INNER JOIN Book bk ON br.Book_ID = bk.Book_ID
WHERE u.School_ID = <operator_school_id>		-- Replace with the desired element
AND br.Status = 'On Hold';

---- Show_Loans_Per_User (history)
SELECT b.Borrowing_ID, b.Book_ID, bk.Title, u.Username, u.Name, u.Surname, u.User_Type, b.Borrow_Date, b.Due_Date, b.Returning_Date
FROM Borrowing b
INNER JOIN User u ON b.User_ID = u.User_ID
INNER JOIN Book bk ON b.Book_ID = bk.Book_ID
WHERE u.School_ID =  <operator_school_id>		-- Replace with the desired element
  AND b.Status = 'Approved';			

---- Show_Loans_Per_User (active)
SELECT b.Borrowing_ID, b.Book_ID, bk.Title, u.Username, u.Name, u.Surname, u.User_Type, b.Borrow_Date, b.Due_Date, b.Returning_Date
FROM Borrowing b
INNER JOIN User u ON b.User_ID = u.User_ID
INNER JOIN Book bk ON b.Book_ID = bk.Book_ID
WHERE u.School_ID = <operator_school_id>		-- Replace with the desired element
  AND b.Status = 'Approved'
  AND (b.Returning_Date IS NULL OR b.Returning_Date = '');

---- Delayed_Loans
SELECT br.Borrowing_ID, br.Book_ID, bk.Title, u.Username, u.Name, u.Surname, br.Borrow_Date, br.Due_Date, br.Returning_Date
FROM Borrowing br
INNER JOIN User u ON br.User_ID = u.User_ID
INNER JOIN Book bk ON br.Book_ID = bk.Book_ID
WHERE u.School_ID = <operator_school_id>		-- Replace with the desired element
AND br.Status = 'Approved'
AND br.Returning_Date IS NULL
AND CURDATE() > br.Due_Date;

---- Approve_Reservation
SELECT r.Reservation_ID, r.Book_ID, bk.Title, u.Username, u.Name, u.Surname, r.Request_Date
FROM Reservation r
INNER JOIN User u ON r.User_ID = u.User_ID
INNER JOIN Book bk ON r.Book_ID = bk.Book_ID
WHERE u.School_ID = <operator_school_id>		-- Replace with the desired element
AND r.Status = 'On Hold';

---- Show_Reservations_Per_User (active)
SELECT r.Reservation_ID, r.Book_ID, bk.Title, u.Username, u.Name, u.Surname, u.User_Type, r.Request_Date, r.Status
FROM Reservation r
INNER JOIN User u ON r.User_ID = u.User_ID
INNER JOIN Book bk ON r.Book_ID = bk.Book_ID
WHERE u.School_ID =  <operator_school_id>			-- Replace with the desired element
  AND r.Status = 'Approved';

---- Show_Reviews_Per_User (On Hold)
SELECT rv.Review_ID, rv.Book_ID, bk.Title, u.Username, u.Name, u.Surname, rv.Rating, rv.Review_Text
FROM Review rv
INNER JOIN User u ON rv.User_ID = u.User_ID
INNER JOIN Book bk ON rv.Book_ID = bk.Book_ID
WHERE u.School_ID = <operator_school_id>			-- Replace with the desired element
  AND rv.Status = 'On Hold';

---- Show_Reviews_Per_User (Approved)
SELECT rv.Review_ID, rv.Book_ID, bk.Title, u.Username, u.Name, u.Surname, rv.Rating, rv.Review_Text
FROM Review rv
INNER JOIN User u ON rv.User_ID = u.User_ID
INNER JOIN Book bk ON rv.Book_ID = bk.Book_ID
WHERE u.School_ID = <operator_school_id>			-- Replace with the desired element
  AND rv.Status = 'Approved';

---- New_Category
INSERT INTO `Category` (`Category_Name`) VALUES ('<category_name>');

---- New_Author
INSERT INTO `Author` (`Author_Name`, `Author_Surname`) VALUES ('<author_name>', '<author_surname>');

-- ----------------
-- ----------------
-- STUDENTS AND TEACHERS
-- ----------------
-- ----------------
---- Show_My_Loans (History)
SELECT b.Borrowing_ID, b.Book_ID, bk.Title, u.Username, u.Name, u.Surname, b.Borrow_Date, b.Due_Date, b.Returning_Date
FROM Borrowing b
INNER JOIN User u ON b.User_ID = u.User_ID
INNER JOIN Book bk ON b.Book_ID = bk.Book_ID
WHERE u.User_ID = <logged_in_user_id>;					-- Replace with the desired element

---- Show_My_Loans (Active)
SELECT b.Borrowing_ID, b.Book_ID, bk.Title, u.Username, u.Name, u.Surname, b.Borrow_Date, b.Due_Date, b.Returning_Date
FROM Borrowing b
INNER JOIN User u ON b.User_ID = u.User_ID
INNER JOIN Book bk ON b.Book_ID = bk.Book_ID
WHERE u.User_ID = <logged_in_user_id>					-- Replace with the desired element
   AND (b.Returning_Date IS NULL OR b.Returning_Date = '');

---- Show_My_Reservations (Active)
SELECT r.Reservation_ID, r.Book_ID, bk.Title, u.Username, u.Name, u.Surname, r.Request_Date, r.Status
FROM Reservation r
INNER JOIN User u ON r.User_ID = u.User_ID
INNER JOIN Book bk ON r.Book_ID = bk.Book_ID
WHERE u.User_ID =  <logged_in_user_id>					-- Replace with the desired element
  AND r.Status = 'Approved';
  
---- Show_My_Reviews (Approved)
SELECT rv.Review_ID, bk.Book_ID, bk.Title, u.Username, u.Name, u.Surname, rv.Rating, rv.Review_Text
FROM Review rv
INNER JOIN User u ON rv.User_ID = u.User_ID
INNER JOIN Book bk ON rv.Book_ID = bk.Book_ID
WHERE u.User_ID = <logged_in_user_id> 					-- Replace with the desired element
   AND rv.Status = 'Approved';

---- New_Loan
INSERT INTO `Borrowing` (`Book_ID`, `User_ID`, `Borrow_Date`, `Due_Date`, `Returning_Date`, `Status`)
VALUES (<book_id>, <logged_in_user_id>, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY), '', 'On Hold');			-- Replace with the desired elements

---- New_Reservation
INSERT INTO `Reservation` (`Book_ID`, `User_ID`, `Request_Date`, `Status`)
VALUES (<book_id>, <logged_in_user_id>, CURDATE(), 'On Hold');					-- Replace with the desired elements

---- New_Review
INSERT INTO `Review` (`Review_Text`, `Book_ID`, `User_ID`, `Rating`, `Status`) 
VALUES ('<review_text>', <book_id>, <logged_in_user_id>, <rating>, 'On Hold'); 			-- Replace with the desired elements

---- (-) Cancel_Reservation

-- ----------------
-- ----------------
-- ALL_USERS
-- ----------------
-- ----------------
---- View_Books_In_My_School
	---- \>> admin can see all schools
---- My_Profile
	---- \>> all users except students can change all info
	---- |>> students can change only pwd
