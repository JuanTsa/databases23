SET GLOBAL event_scheduler=ON
-- ----------
-- EVENT 1
-- ----------
-- Check old reservations and delete them
CREATE EVENT delete_old_reservations
ON SCHEDULE EVERY 1 HOUR
DO
  DELETE FROM Reservation
  WHERE Request_Date < DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY);
