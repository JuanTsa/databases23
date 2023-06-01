-- I put here some extra queries for the website
-- You'd change only the <...> with the desired variable. If something is in this format: '<...>' DO NOT DELETE the single quotes ''.

-- -------------
-- ADMINISTRATOR
-- -------------
---- adds a new school unit
INSERT INTO `School_Unit` (`School_Name`, `Address`, `Phone`, `Email`, `Principal_Name`, `Principal_Surname`) VALUES ('<school_name>', '<address>', <phone>, '<email>', '<principal_name>', '<principal_surname>');

---- adds a new operator (so by default some values)
INSERT INTO `User` (`School_ID`, `Username`, `Password`, `Name`, `Surname`, `Email`, `Age`, `Copies_Borrowed`, `Copies_Reserved`, `Max_Copies_Borrowed`, `Max_Copies_Reserved`, `User_Type`, `Status`) 
VALUES ('<school_id>', '<username>', '<password>', '<name>', '<surname>', '<email>', <age>, 0, 0, 0, 0, 'Operator', 'Approved');

---- list with all operators that have not been approved

-- --------
-- OPERATOR
-- --------
---- adds a new category 
INSERT INTO `Category` (`Category_Name`) VALUES ('<category_name>');

---- adds a new author
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
