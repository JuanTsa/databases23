UPDATE `User`
SET `Copies_Reserved` = CASE
    WHEN `User_ID` BETWEEN 10 AND 24 THEN 2
    WHEN `User_ID` BETWEEN 351 AND 360 THEN 1
    ELSE `Copies_Reserved`
  END,
  `Copies_Borrowed` = CASE
    WHEN `User_ID` BETWEEN 25 AND 39 THEN 2
    WHEN `User_ID` BETWEEN 361 AND 370 THEN 1
    ELSE `Copies_Borrowed`
  END
WHERE `User_ID` BETWEEN 10 AND 39 OR `User_ID` BETWEEN 351 AND 370;
