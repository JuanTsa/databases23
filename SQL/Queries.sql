-- -------------------
-- ----- ADMIN ------- 
-- -------------------
-- ---------------------------------
-- ------- QUERY 1 - 3.1.1 --------- List with the total borrowings per school (Search criteria: year, calendar month).
-- ---------------------------------
SELECT
  s.School_Name,
  YEAR(b.Borrow_Date) AS Borrow_Year,
  MONTH(b.Borrow_Date) AS Borrow_Month,
  COUNT(*) AS Total_Borrowings
FROM
  School_Unit s
  INNER JOIN User u ON s.School_ID = u.School_ID
  INNER JOIN Borrowing b ON u.User_ID = b.User_ID
WHERE
  YEAR(b.Borrow_Date) = <year> AND		-- Replace with the desired year
  MONTH(b.Borrow_Date) = <month>		-- Replace with the desired calendar month
GROUP BY
  s.School_ID,
  YEAR(b.Borrow_Date),
  MONTH(b.Borrow_Date)
ORDER BY
  s.School_Name;

-- ---------------------------------
-- ------- QUERY 2 - 3.1.2 --------- For a given book category (user-selected), which authors belong to it and which teachers have borrowed books from that category in the last year?
-- ---------------------------------
SELECT DISTINCT a.Author_Name, a.Author_Surname
FROM Author a
JOIN Book_Author ba ON a.Author_ID = ba.Author_ID
JOIN Book_Category bc ON ba.Book_ID = bc.Book_ID
JOIN Category c ON bc.Category_ID = c.Category_ID
WHERE c.Category_Name = 'category_name';               -- Replace with the desired category_name

SELECT DISTINCT U.Name, U.Surname
FROM User U
JOIN Borrowing B ON U.User_ID = B.User_ID
JOIN Book_Category BC ON B.Book_ID = BC.Book_ID
JOIN Category C ON BC.Category_ID = C.Category_ID
WHERE U.User_Type = 'Teacher'
  AND C.Category_Name = 'category_name'                 -- Replace with the desired category_name
  AND B.Borrow_Date >= DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR);

-- ---------------------------------
-- ------- QUERY 3 - 3.1.3 --------- Find young teachers (age < 40 years) who have borrowed the most books and the number of books.
-- ---------------------------------
SELECT U.User_ID, U.Name, U.Surname, U.Age, COUNT(*) AS NumOfBooksBorrowed
FROM User U
JOIN Borrowing B ON U.User_ID = B.User_ID
JOIN Book BK ON B.Book_ID = BK.Book_ID
WHERE U.User_Type = 'Teacher' AND U.Age < 40
GROUP BY U.User_ID
ORDER BY NumOfBooksBorrowed DESC;

-- ---------------------------------
-- ------- QUERY 4 - 3.1.4 --------- Find authors whose books have not been borrowed.
-- ---------------------------------
SELECT a.Author_ID, a.Author_Name, a.Author_Surname
FROM Author a
JOIN Book_Author ba ON a.Author_ID = ba.Author_ID
LEFT JOIN Book b ON ba.Book_ID = b.Book_ID
LEFT JOIN Borrowing bor ON b.Book_ID = bor.Book_ID
GROUP BY a.Author_ID, a.Author_Name, a.Author_Surname
HAVING COUNT(DISTINCT bor.Borrowing_ID) = 0;


-- ---------------------------------
-- ------- QUERY 5 - 3.1.5 --------- Which operators have loaned the same number of books in a year with more than 20 loans?
-- ---------------------------------
SELECT sq.School_ID, sq.School_Name, u.Name AS Operator_Name, u.Surname AS Operator_Surname, sq.Total_Borrowings
FROM (
  SELECT su.School_ID, su.School_Name, COUNT(*) AS Total_Borrowings
  FROM School_Unit su
  INNER JOIN User u ON su.School_ID = u.School_ID
  INNER JOIN Borrowing b ON u.User_ID = b.User_ID
  WHERE YEAR(b.Borrow_Date) = <user_selected_year>		-- Replace it!
  GROUP BY su.School_ID
  HAVING COUNT(*) >= 20
) AS sq
INNER JOIN (
  SELECT Total_Borrowings
  FROM (
    SELECT COUNT(*) AS Total_Borrowings
    FROM School_Unit su
    INNER JOIN User u ON su.School_ID = u.School_ID
    INNER JOIN Borrowing b ON u.User_ID = b.User_ID
    WHERE YEAR(b.Borrow_Date) = <user_selected_year>		-- Replace it!
    GROUP BY su.School_ID
    HAVING COUNT(*) >= 20
  ) AS t
  GROUP BY Total_Borrowings
  HAVING COUNT(*) > 1
) AS t2 ON sq.Total_Borrowings = t2.Total_Borrowings
INNER JOIN User u ON sq.School_ID = u.School_ID
WHERE u.User_Type = 'Operator'
ORDER BY sq.Total_Borrowings DESC;

-- ---------------------------------
-- ------- QUERY 6 - 3.1.6 --------- Many books cover more than one category; among category pairs (e.g., history and poetry) that are common in books, find the top-3 pairs that appeared in borrowings.
-- ---------------------------------
SELECT C1.Category_Name AS Category1, C2.Category_Name AS Category2, COUNT(*) AS BorrowingCount
FROM Book_Category BC1
JOIN Book_Category BC2 ON BC1.Book_ID = BC2.Book_ID AND BC1.Category_ID < BC2.Category_ID
JOIN Book B ON BC1.Book_ID = B.Book_ID
JOIN Borrowing BR ON B.Book_ID = BR.Book_ID
JOIN Category C1 ON BC1.Category_ID = C1.Category_ID
JOIN Category C2 ON BC2.Category_ID = C2.Category_ID
GROUP BY C1.Category_Name, C2.Category_Name
ORDER BY BorrowingCount DESC
LIMIT 3;

-- ---------------------------------
-- ------- QUERY 7 - 3.1.7 --------- Find all authors who have written at least 5 books less than the author with the most books.
-- ---------------------------------
SELECT A.Author_ID, A.Author_Name, A.Author_Surname, COUNT(*) AS Books_Written
FROM Author A
JOIN Book_Author BA ON A.Author_ID = BA.Author_ID
GROUP BY A.Author_ID, A.Author_Name, A.Author_Surname
HAVING Books_Written <= (
    SELECT COUNT(*) - 5
    FROM Book_Author
    GROUP BY Author_ID
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
ORDER BY Books_Written DESC;

-- ----------------------
-- ----- OPERATOR -------
-- ----------------------
-- ---------------------------------
-- ------- QUERY 8 - 3.2.1 --------- Find all books by Title, Author (Search criteria: title/ category/ author/ copies).
-- ---------------------------------
SELECT b.Book_ID, b.Title, GROUP_CONCAT(CONCAT(a.Author_Name, ' ', a.Author_Surname) SEPARATOR ', ') AS Authors, b.Pages, b.Available_Copies, b.Inventory
FROM Book b
JOIN Book_Author ba ON b.Book_ID = ba.Book_ID
JOIN Author a ON ba.Author_ID = a.Author_ID
WHERE b.Title = '<title>' 		                       -- Replace with the desired element
	AND b.School_ID = <operator_school_id>		       -- Replace with the desired element
GROUP BY b.Book_ID;

SELECT b.Book_ID, b.Title, GROUP_CONCAT(CONCAT(a.Author_Name, ' ', a.Author_Surname) SEPARATOR ', ') AS Authors, b.Pages, b.Available_Copies, b.Inventory
FROM Book b
JOIN Book_Author ba ON b.Book_ID = ba.Book_ID
JOIN Author a ON ba.Author_ID = a.Author_ID
WHERE a.Author_Name = '<author_name>' 		           -- Replace with the desired element
   OR a.Author_Surname = '<author_surname>' 	       -- Replace with the desired element
	AND b.School_ID = <operator_school_id>		       -- Replace with the desired element
GROUP BY b.Book_ID;

SELECT b.Book_ID, b.Title, GROUP_CONCAT(CONCAT(a.Author_Name, ' ', a.Author_Surname) SEPARATOR ', ') AS Authors, b.Pages, b.Available_Copies, b.Inventory
FROM Book b
JOIN Book_Author ba ON b.Book_ID = ba.Book_ID
JOIN Author a ON ba.Author_ID = a.Author_ID
JOIN Book_Category bc ON b.Book_ID = bc.Book_ID
JOIN Category c ON bc.Category_ID = c.Category_ID
WHERE c.Category_Name = 'category_name' 	            -- Replace with the desired element
	AND b.School_ID = <operator_school_id>		       -- Replace with the desired element
GROUP BY b.Book_ID;

SELECT b.Book_ID, b.Title, GROUP_CONCAT(CONCAT(a.Author_Name, ' ', a.Author_Surname) SEPARATOR ', ') AS Authors, b.Pages, b.Available_Copies, b.Inventory
FROM Book b
JOIN Book_Author ba ON b.Book_ID = ba.Book_ID
JOIN Author a ON ba.Author_ID = a.Author_ID
WHERE b.Available_Copies = <available_copies> 			                        -- Replace with the desired element
	AND b.School_ID = <operator_school_id>		       -- Replace with the desired element
GROUP BY b.Book_ID;

-- ---------------------------------
-- ------- QUERY 9 - 3.2.2 --------- Find all borrowers who own at least one book and have delayed its return. (Search criteria: First Name, Last Name, Delay Days).
-- ---------------------------------
SELECT u.User_ID, u.Name, u.Surname, DATEDIFF(CURDATE(), bor.Due_Date) AS Delay_Days
FROM User u
JOIN Borrowing bor ON u.User_ID = bor.User_ID
WHERE DATEDIFF(CURDATE(), bor.Due_Date) > 0
  AND u.Name = '<name>'                                         -- Replace with the desired element
  AND u.Surname = '<surname>'                                   -- Replace with the desired element
  AND u.School_ID = <operator_school_id>                        -- Replace with the desired element
  AND bor.Returning_Date IS NULL
GROUP BY u.User_ID, u.Name, u.Surname;

SELECT u.User_ID, u.Name, u.Surname, DATEDIFF(CURDATE(), bor.Due_Date) AS Delay_Days
FROM User u
JOIN Borrowing bor ON u.User_ID = bor.User_ID
WHERE DATEDIFF(CURDATE(), bor.Due_Date) > 0
  AND DATEDIFF(CURDATE(), bor.Due_Date) > <delay_days>                         -- Replace with the desired element
  AND u.School_ID = <operator_school_id>                        -- Replace with the desired element
  AND bor.Returning_Date IS NULL
GROUP BY u.User_ID, u.Name, u.Surname;

-- ----------------------------------
-- ------- QUERY 10 - 3.2.3 --------- Average Ratings per borrower and category (Search criteria: user/category)
-- ----------------------------------
SELECT u.User_ID, u.Name, u.Surname, AVG(r.Rating) AS Average_Rating
FROM User u
JOIN Review r ON u.User_ID = r.User_ID
WHERE (u.User_Type = 'Student' OR u.User_Type = 'Teacher')
AND u.username = '<username>' 		                                -- Replace with the desired element
AND u.School_ID = <operator_school_id>		       -- Replace with the desired element
GROUP BY u.User_ID, u.Name, u.Surname;

SELECT u.User_ID, u.Name, u.Surname, AVG(r.Rating) AS Average_Rating
FROM User u
JOIN Review r ON u.User_ID = r.User_ID
JOIN Book b ON r.Book_ID = b.Book_ID
JOIN Book_Category bc ON b.Book_ID = bc.Book_ID
JOIN Category c ON bc.Category_ID = c.Category_ID
WHERE (u.User_Type = 'Student' OR u.User_Type = 'Teacher')
AND c.Category_Name = '<category_name>'                   -- Replace with the desired element
AND b.School_ID = <operator_school_id>		       -- Replace with the desired element
GROUP BY u.User_ID, u.Name, u.Surname;
 
-- ------------------
-- ----- USER -------
-- ------------------
-- ----------------------------------
-- ------- QUERY 11 - 3.3.1 --------- List with all books (Search criteria: title/category/author), ability to select a book and create a reservation request.
-- ----------------------------------
SELECT b.Book_ID, b.Title, GROUP_CONCAT(a.Author_Name, ' ', a.Author_Surname) AS Authors, b.Pages, b.Available_Copies, b.Inventory
FROM Book b
JOIN Book_Author ba ON b.Book_ID = ba.Book_ID
JOIN Author a ON ba.Author_ID = a.Author_ID
WHERE b.Title = '<title>'                                     -- Replace with the desired element
GROUP BY b.Book_ID, b.Title, b.Pages, b.Available_Copies, b.Inventory;

SELECT b.Book_ID, b.Title, GROUP_CONCAT(a.Author_Name, ' ', a.Author_Surname) AS Authors, b.Pages, b.Available_Copies, b.Inventory
FROM Book b
JOIN Book_Author ba ON b.Book_ID = ba.Book_ID
JOIN Author a ON ba.Author_ID = a.Author_ID
JOIN Book_Category bc ON b.Book_ID = bc.Book_ID
JOIN Category c ON bc.Category_ID = c.Category_ID
WHERE c.Category_Name = '<category_name>'                  -- Replace with the desired element
GROUP BY b.Book_ID, b.Title, b.Pages, b.Available_Copies, b.Inventory;

SELECT b.Book_ID, b.Title, GROUP_CONCAT(a.Author_Name, ' ', a.Author_Surname) AS Authors, b.Pages, b.Available_Copies, b.Inventory
FROM Book b
JOIN Book_Author ba ON b.Book_ID = ba.Book_ID
JOIN Author a ON ba.Author_ID = a.Author_ID
WHERE a.Author_Name = '<author_name>'                       -- Replace with the desired element
AND a.Author_Surname = '<author_surname>'                   -- Replace with the desired element
GROUP BY b.Book_ID, b.Title, b.Pages, b.Available_Copies, b.Inventory;

-- ----------------------------------
-- ------- QUERY 12 - 3.3.2 --------- List of all books borrowed by this user.
-- ----------------------------------
SELECT b.Book_ID, b.Title, GROUP_CONCAT(a.Author_Name, ' ', a.Author_Surname) AS Authors
FROM Borrowing bor
JOIN Book b ON bor.Book_ID = b.Book_ID
JOIN Book_Author ba ON b.Book_ID = ba.Book_ID
JOIN Author a ON ba.Author_ID = a.Author_ID
WHERE bor.User_ID = '<logged_in_user_id>'                    -- Replace with the desired element
GROUP BY b.Book_ID, b.Title;
