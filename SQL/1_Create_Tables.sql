CREATE TABLE IF NOT EXISTS `School_Unit` (
  `School_ID` int(50) NOT NULL AUTO_INCREMENT,
  `School_Name` varchar(50) NOT NULL UNIQUE,
  `Address` varchar(50) NOT NULL UNIQUE,
  `Phone` int(11) NOT NULL UNIQUE,
  `Email` varchar(50) NOT NULL UNIQUE,
  `Principal_Name` varchar(50) NOT NULL,
  `Principal_Surname` varchar(50) NOT NULL,
  PRIMARY KEY (`School_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `User` (
  `User_ID` int(50) NOT NULL AUTO_INCREMENT,
  `School_ID` int(50) NOT NULL,
  `Username` varchar(50) NOT NULL UNIQUE,
  `Password` varchar(50) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Surname` varchar(50) NOT NULL,
  `Email` varchar(50) NOT NULL UNIQUE,
  `Age` int(3) NOT NULL,
  `Copies_Borrowed` int(50) NOT NULL DEFAULT 0,
  `Copies_Reserved` int(50) NOT NULL DEFAULT 0,
  `Max_Copies` INT(50) NOT NULL DEFAULT (CASE WHEN `User_Type` = 'Student' THEN 2
                                                       WHEN `User_Type` = 'Teacher' THEN 1
                                                       ELSE 0
                                                  END),
  `User_Type` enum('Administrator', 'Operator', 'Teacher', 'Student') NOT NULL,
  `Status` enum('Approved', 'On Hold') NOT NULL,
  PRIMARY KEY (`User_ID`),
  CHECK (`Max_Copies` >= `Copies_Borrowed` AND `Max_Copies` >= `Copies_Reserved`),
  CHECK (`Copies_Borrowed` >= 0),
  CHECK (`Copies_Reserved` >= 0),
  CONSTRAINT `fk_user_id_school_unit` FOREIGN KEY (`School_ID`) REFERENCES `School_Unit` (`School_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `Category` (
  `Category_ID` INT NOT NULL AUTO_INCREMENT,
  `Category_Name` VARCHAR(50) NOT NULL UNIQUE,
   PRIMARY KEY (`Category_ID`)
)  ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `Author` (
  `Author_ID` INT(50) NOT NULL AUTO_INCREMENT,
  `Author_Name` VARCHAR(50) NOT NULL,
  `Author_Surname` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`Author_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `Book` (
  `Book_ID` INT(50) NOT NULL AUTO_INCREMENT,
  `ISBN` BIGINT(13) NOT NULL,
  `School_ID` INT(50) NOT NULL,
  `Title` VARCHAR(50) NOT NULL,
  `Publisher` VARCHAR(50) NOT NULL,
  `Pages` INT(50) NOT NULL,
  `Summary` TEXT NOT NULL,
  `Available_Copies` INT(50) CHECK (Available_Copies >= 0),
  `Cover` VARCHAR(1000) NOT NULL DEFAULT 'https://hotemoji.com/images/dl/1/orange-book-emoji-by-twitter.png',
  `Language` VARCHAR(50) NOT NULL,
  `Keywords` VARCHAR(100) NOT NULL,
  `Inventory` INT(50) NOT NULL CHECK (Inventory > 0),
  PRIMARY KEY (`Book_ID`),
  CONSTRAINT `chk_available_copies` CHECK (`Available_Copies` <= `Inventory`),
  CONSTRAINT `fk_book_school_id` FOREIGN KEY (`School_ID`) REFERENCES `School_Unit` (`School_ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CHECK (ISBN REGEXP '^[0-9]{13}$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `Reservation` (
  `Reservation_ID` int(50) NOT NULL AUTO_INCREMENT,
  `Book_ID` int(50) NOT NULL,
  `User_ID` int(50) NOT NULL,
  `Request_Date` date NOT NULL DEFAULT CURRENT_DATE(),
  `Status` enum('Approved', 'On Hold') NOT NULL DEFAULT 'On Hold',
  PRIMARY KEY (`Reservation_ID`),
  CONSTRAINT `fk_reservation_book_id` FOREIGN KEY (`Book_ID`) REFERENCES `Book` (`Book_ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_reservation_user_id` FOREIGN KEY (`User_ID`) REFERENCES `User` (`User_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `Review` (
  `Review_ID` int(50) NOT NULL AUTO_INCREMENT,
  `Book_ID` int(50) NOT NULL,
  `User_ID` int(50) NOT NULL,
  `Review_Text` text NOT NULL,
  `Rating` TINYINT(1) NOT NULL CHECK (Rating >= 1 AND Rating <= 5),
  `Status` enum('Approved', 'On Hold') NOT NULL DEFAULT 'On Hold',
  PRIMARY KEY (`Review_ID`),
  CONSTRAINT `fk_review_book_id` FOREIGN KEY (`Book_ID`) REFERENCES `Book` (`Book_ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_review_user_id` FOREIGN KEY (`User_ID`) REFERENCES `User` (`User_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `Borrowing` (
  `Borrowing_ID` int(50) NOT NULL AUTO_INCREMENT,
  `Book_ID` int(50) NOT NULL,
  `User_ID` int(50) NOT NULL,
  `Borrow_Date` date NOT NULL DEFAULT CURRENT_DATE(),
  `Due_Date` date NOT NULL DEFAULT DATE_ADD(`Borrow_Date`, INTERVAL 7 DAY),
  `Returning_Date` date DEFAULT NULL,
  `Status` enum('Approved', 'On Hold') NOT NULL DEFAULT 'On Hold',
  PRIMARY KEY (`Borrowing_ID`),
  CONSTRAINT `fk_borrowing_book_id` FOREIGN KEY (`Book_ID`) REFERENCES `Book` (`Book_ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_borrowing_user_id` FOREIGN KEY (`User_ID`) REFERENCES `User` (`User_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `Book_Author` (
  `Author_ID` INT(50),
  `Book_ID` INT(50),
  CONSTRAINT `fk_book_author_author_id` FOREIGN KEY (`Author_ID`) REFERENCES `Author` (`Author_ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_book_author_book_id` FOREIGN KEY (`Book_ID`) REFERENCES `Book` (`Book_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `Book_Category` (
  `Category_ID` INT(50),
  `Book_ID` INT(50),
  CONSTRAINT `fk_book_category_category_id` FOREIGN KEY (`Category_ID`) REFERENCES `Category` (`Category_ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_book_category_book_id` FOREIGN KEY (`Book_ID`) REFERENCES `Book` (`Book_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
