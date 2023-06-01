-- I put here some extra queries for the website (mostly are supposed to be only for the operator).
-- You'd change only the <...> with the desired variable. If something is in this format: '<...>' DO NOT DELETE the single quotes ''.

-- ADMINISTRATOR
---- adds a new school unit
INSERT INTO `School_Unit` (`School_Name`, `Address`, `Phone`, `Email`, `Principal_Name`, `Principal_Surname`) VALUES ('<school_name>', '<address>', <phone>, '<email>', '<principal_name>', '<principal_surname>');

---- adds a new operator (so by default some values)
INSERT INTO `User` (`School_ID`, `Username`, `Password`, `Name`, `Surname`, `Email`, `Age`, `Copies_Borrowed`, `Copies_Reserved`, `Max_Copies_Borrowed`, `Max_Copies_Reserved`, `User_Type`, `Status`) 
VALUES  ('<school_id>', '<username>', '<password>', '<name>', '<surname>', '<email>', <age>, 0, 0, 0, 0, 'Operator', 'Approved');

---- list with all operators that have not been approved

-- OPERATOR
INSERT INTO `Category` (`Category_Name`) VALUES ('<category_name>');

INSERT INTO `Author` (`Author_Name`, `Author_Surname`) VALUES ('<author_name>', '<author_surname>');

INSERT INTO `User` (`School_ID`, `Username`, `Password`, `Name`, `Surname`, `Email`, `Age`, `Copies_Borrowed`, `Copies_Reserved`, `Max_Copies_Borrowed`, `Max_Copies_Reserved`, `User_Type`, `Status`)
VALUES (
(2,'JohnDoe1', 'pass1', 'John', 'Doe', 'johndoe1@schoollib.com', 20, 0, 0, 2, 2, 'Student', 'Approved');


INSERT INTO `Book` (`Book_ID`, `ISBN`, `School_ID`, `Title`, `Publisher`, `Pages`, `Summary`, `Available_Copies`, `Cover`, `Language`, `Keywords`, `Inventory`)
VALUES
(1, 5553191371787, 3, 'Don Quixote', 'Tor Books', 250, 'A unique and intriguing book, full of wonders and plot', 3, 'https://hotemoji.com/images/dl/1/orange-book-emoji-by-twitter.png', 'chinese', 'Philosophy, Psychology, Adventure', 13);


INSERT INTO `Book_Author` (`Author_ID`, `Book_ID`) VALUES (1, 1);

INSERT INTO `Book_Category` (`Category_ID`, `Book_ID`) VALUES (1, 1);

INSERT INTO `Borrowing` (`Borrowing_ID`, `Book_ID`, `User_ID`, `Borrow_Date`, `Due_Date`, `Returning_Date`, `Status`) VALUES (1, 7, 18, '2022-09-28', '2022-10-05', '2022-10-11', 'Approved'),

INSERT INTO `Reservation` (`Reservation_ID`, `Book_ID`, `User_ID`, `Request_Date`, `Status`) VALUES (1, 62, 60, '2022-07-11', 'Approved'),

INSERT INTO `Review` (`Review_ID`, `Review_Text`, `Book_ID`, `User_ID`, `Rating`, `Status`) VALUES (1, 'An awesome, page-turner, book. My review does not apply to my rating!', 28, 22, 5, 'Approved');
