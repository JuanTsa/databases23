-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 27, 2023 at 10:11 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `library_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `author`
--

CREATE TABLE `author` (
  `Author_ID` int(50) NOT NULL,
  `Author_Name` varchar(50) NOT NULL,
  `Books_Written` int(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `book`
--

CREATE TABLE `book` (
  `Book_ID` int(50) NOT NULL,
  `ISBN` int(13) NOT NULL,
  `School_ID` int(50) NOT NULL,
  `Title` varchar(50) NOT NULL,
  `Publisher` varchar(50) NOT NULL,
  `Pages` int(50) NOT NULL,
  `Summary` text NOT NULL,
  `Available_Copies` int(50) NOT NULL,
  `Cover` varchar(1000) NOT NULL,
  `Language` varchar(50) NOT NULL,
  `Inventory` int(50) NOT NULL,
  `Total_Borrowings` int(50) NOT NULL,
  `Category_ID` int(50) NOT NULL,
  `Author_ID` int(50) NOT NULL,
  `Keyword_ID` int(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `borrowing`
--

CREATE TABLE `borrowing` (
  `Borrowing_ID` int(50) NOT NULL,
  `Book_ID` int(50) NOT NULL,
  `User_ID` int(50) NOT NULL,
  `Borrow_Date` varchar(50) NOT NULL,
  `Due_Date` varchar(50) NOT NULL,
  `Returning_Date` varchar(50) DEFAULT NULL,
  `Status` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `Category_ID` int(11) NOT NULL,
  `Category_Name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `keyword`
--

CREATE TABLE `keyword` (
  `Keyword_ID` int(50) NOT NULL,
  `Keyword_Name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reservation`
--

CREATE TABLE `reservation` (
  `Reservation_ID` int(50) NOT NULL,
  `Book_ID` int(50) NOT NULL,
  `User_ID` int(50) NOT NULL,
  `Request_Date` varchar(50) NOT NULL,
  `Status` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `review`
--

CREATE TABLE `review` (
  `Review_ID` int(50) NOT NULL,
  `Review_Text` text NOT NULL,
  `Book_ID` int(50) NOT NULL,
  `User_ID` int(50) NOT NULL,
  `Rating` int(1) NOT NULL,
  `Status` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `school_unit`
--

CREATE TABLE `school_unit` (
  `School_ID` int(50) NOT NULL,
  `School_Name` varchar(50) NOT NULL,
  `Address` varchar(50) NOT NULL,
  `Phone` int(11) NOT NULL,
  `Email` varchar(50) NOT NULL,
  `Principal_Name` varchar(50) NOT NULL,
  `Principal_Surname` varchar(50) NOT NULL,
  `Operator_Name` varchar(50) NOT NULL,
  `Operator_Surname` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `User_ID` int(50) NOT NULL,
  `Username` varchar(50) NOT NULL,
  `Password` varchar(50) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Surname` varchar(50) NOT NULL,
  `Email` varchar(50) NOT NULL,
  `Age` int(3) NOT NULL,
  `Copies_Borrowed` int(50) NOT NULL,
  `Copies_Reserved` int(50) NOT NULL,
  `Max_Copies_Borrowed` int(50) NOT NULL,
  `Max_Copies_Reserved` int(50) NOT NULL,
  `User_Type` enum('Administrator','Operator','Teacher','Student') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `author`
--
ALTER TABLE `author`
  ADD PRIMARY KEY (`Author_ID`);

--
-- Indexes for table `book`
--
ALTER TABLE `book`
  ADD PRIMARY KEY (`Book_ID`),
  ADD KEY `fk_book_school_id` (`School_ID`),
  ADD KEY `fk_book_author_id` (`Author_ID`),
  ADD KEY `fk_book_keyword_id` (`Keyword_ID`),
  ADD KEY `fk_book_category_id` (`Category_ID`);

--
-- Indexes for table `borrowing`
--
ALTER TABLE `borrowing`
  ADD PRIMARY KEY (`Borrowing_ID`),
  ADD KEY `fk_borrowing_book_id` (`Book_ID`),
  ADD KEY `fk_borrowing_user_id` (`User_ID`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`Category_ID`);

--
-- Indexes for table `keyword`
--
ALTER TABLE `keyword`
  ADD PRIMARY KEY (`Keyword_ID`);

--
-- Indexes for table `reservation`
--
ALTER TABLE `reservation`
  ADD PRIMARY KEY (`Reservation_ID`),
  ADD KEY `fk_reservation_book_id` (`Book_ID`),
  ADD KEY `fk_reservation_user_id` (`User_ID`);

--
-- Indexes for table `review`
--
ALTER TABLE `review`
  ADD PRIMARY KEY (`Review_ID`),
  ADD KEY `fk_review_book_id` (`Book_ID`),
  ADD KEY `fk_review_user_id` (`User_ID`);

--
-- Indexes for table `school_unit`
--
ALTER TABLE `school_unit`
  ADD PRIMARY KEY (`School_ID`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`User_ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `author`
--
ALTER TABLE `author`
  MODIFY `Author_ID` int(50) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `book`
--
ALTER TABLE `book`
  MODIFY `Book_ID` int(50) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `borrowing`
--
ALTER TABLE `borrowing`
  MODIFY `Borrowing_ID` int(50) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `Category_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `keyword`
--
ALTER TABLE `keyword`
  MODIFY `Keyword_ID` int(50) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reservation`
--
ALTER TABLE `reservation`
  MODIFY `Reservation_ID` int(50) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `review`
--
ALTER TABLE `review`
  MODIFY `Review_ID` int(50) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `school_unit`
--
ALTER TABLE `school_unit`
  MODIFY `School_ID` int(50) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `User_ID` int(50) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `book`
--
ALTER TABLE `book`
  ADD CONSTRAINT `fk_book_author_id` FOREIGN KEY (`Author_ID`) REFERENCES `author` (`Author_ID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_book_category_id` FOREIGN KEY (`Category_ID`) REFERENCES `category` (`Category_ID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_book_keyword_id` FOREIGN KEY (`Keyword_ID`) REFERENCES `keyword` (`Keyword_ID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_book_school_id` FOREIGN KEY (`School_ID`) REFERENCES `school_unit` (`School_ID`) ON UPDATE CASCADE;

--
-- Constraints for table `borrowing`
--
ALTER TABLE `borrowing`
  ADD CONSTRAINT `fk_borrowing_book_id` FOREIGN KEY (`Book_ID`) REFERENCES `book` (`Book_ID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_borrowing_user_id` FOREIGN KEY (`User_ID`) REFERENCES `user` (`User_ID`) ON UPDATE CASCADE;

--
-- Constraints for table `reservation`
--
ALTER TABLE `reservation`
  ADD CONSTRAINT `fk_reservation_book_id` FOREIGN KEY (`Book_ID`) REFERENCES `book` (`Book_ID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_reservation_user_id` FOREIGN KEY (`User_ID`) REFERENCES `user` (`User_ID`) ON UPDATE CASCADE;

--
-- Constraints for table `review`
--
ALTER TABLE `review`
  ADD CONSTRAINT `fk_review_book_id` FOREIGN KEY (`Book_ID`) REFERENCES `book` (`Book_ID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_review_user_id` FOREIGN KEY (`User_ID`) REFERENCES `user` (`User_ID`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
