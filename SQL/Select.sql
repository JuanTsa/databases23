---- View Contents
select * from user;
select * from school_unit;
select * from category;
select * from author;
select * from book;
select * from book_author;
select * from book_category;
select * from reservation;
select * from borrowing;
select * from review;

---- View triggers
SELECT TRIGGER_SCHEMA, TRIGGER_NAME, EVENT_OBJECT_TABLE, ACTION_TIMING, ACTION_STATEMENT
FROM information_schema.TRIGGERS
WHERE TRIGGER_SCHEMA = 'asd';
