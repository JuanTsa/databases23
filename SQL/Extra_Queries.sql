-- You'd change only the <...> with the desired variable. If something is in this format: '<...>' DO NOT DELETE the single quotes ''.

-- ----------------
-- ADMINISTRATOR
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

---- Backup

---- Restore



-- ----------------
-- OPERATOR (only for their school)
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
---- Approve_Loan

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
WHERE u.School_ID =  <operator_school_id>			-- Replace with the desired element
  AND b.Status = 'Approved',
  AND b.Returning_Date IS NULL;

---- New_Return
---- Delayed_Loans

---- (-) New_Reservation
---- Approve_Reservation

---- Show_Reservations_Per_User (active)
SELECT r.Reservation_ID, r.Book_ID, bk.Title, u.Username, u.Name, u.Surname, u.User_Type, r.Request_Date, r.Status
FROM Reservation r
INNER JOIN User u ON r.User_ID = u.User_ID
INNER JOIN Book bk ON r.Book_ID = bk.Book_ID
WHERE u.School_ID =  <operator_school_id>			-- Replace with the desired element
  AND r.Status = 'Approved';

---- Approve_Review
---- Show_Reviews_Per_User

---- New_Category
INSERT INTO `Category` (`Category_Name`) VALUES ('<category_name>');

---- New_Author
INSERT INTO `Author` (`Author_Name`, `Author_Surname`) VALUES ('<author_name>', '<author_surname>');

-- ----------------
-- STUDENTS AND TEACHERS
-- ----------------
---- Show_My_Loans (history)
SELECT b.Borrowing_ID, b.Book_ID, bk.Title, u.Username, u.Name, u.Surname, b.Borrow_Date, b.Due_Date, b.Returning_Date
FROM Borrowing b
INNER JOIN User u ON b.User_ID = u.User_ID
INNER JOIN Book bk ON b.Book_ID = bk.Book_ID
WHERE u.User_ID = <logged_in_user_id>;					-- Replace with the desired element

---- Show_My_Loans (active)
SELECT b.Borrowing_ID, b.Book_ID, bk.Title, u.Username, u.Name, u.Surname, b.Borrow_Date, b.Due_Date, b.Returning_Date
FROM Borrowing b
INNER JOIN User u ON b.User_ID = u.User_ID
INNER JOIN Book bk ON b.Book_ID = bk.Book_ID
WHERE u.User_ID = <logged_in_user_id>					-- Replace with the desired element
   AND b.Returning_Date is NULL;

---- Show_My_Reservations (active)
SELECT r.Reservation_ID, r.Book_ID, bk.Title, u.Username, u.Name, u.Surname, u.User_Type, r.Request_Date, r.Status
FROM Reservation r
INNER JOIN User u ON r.User_ID = u.User_ID
INNER JOIN Book bk ON r.Book_ID = bk.Book_ID
WHERE u.User_ID =  <logged_in_user_id>			-- Replace with the desired element
  AND r.Status = 'Approved';

---- Show_My_Reservations (active)
SELECT r.Reservation_ID, r.Book_ID, bk.Title, u.Username, u.Name, u.Surname, u.User_Type, r.Request_Date, r.Status
FROM Reservation r
INNER JOIN User u ON r.User_ID = u.User_ID
INNER JOIN Book bk ON r.Book_ID = bk.Book_ID
WHERE u.User_ID =  <logged_in_user_id>			-- Replace with the desired element
  AND r.Status = 'Approved',
  AND r;
  
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
