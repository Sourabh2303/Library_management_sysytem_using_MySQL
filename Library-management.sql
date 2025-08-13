-- 1. CRUD OPERATIONS
--  a) INSERT
-- CREATE A NEW BOOK RECORD --"978-1-60129-456-2','to kill a mockingbird','classic',6.00
-- 'yes','harper lee','j.b. lippincott & co.'
USE library_management;
INSERT INTO books(isbn,book_title,category,rental_price,status,author,publisher)
VALUES('978-1-60129-456-2','To Kill a Mockingbird','Classic',6.00,'yes','Harper Lee','J.B. Lippincott & Co.');

-- b) UPDATE
-- UPDATE AN EXISTING MEMBER"S ADDRESS
SELECT *FROM members;
UPDATE members SET member_address='125 Main St'
WHERE member_id='C101';

-- 3. DELETE
-- DELETE THE RECORD WITH THE ISSUED_ID='IS104' FROM THE TABLE ISSUED_STATUS
DELETE FROM issued_status WHERE issued_id='IS104';

-- Task 4- RETREIVE all books issued by a specific employee with emp_id='E101';
SELECT * FROM issued_status WHERE issued_emp_id='E101';

-- task 5- LIST members who have issued more than one books 
SELECT issued_emp_id ,COUNT(*) FROM  issued_status GROUP BY issued_emp_id HAVING COUNT(*)>1;

-- TASK 6- CREATE  summary tables: use CTAS to generate new table based on query results-each book and total book issued count-
CREATE TABLE book_count AS
SELECT b.isbn,b.book_title, COUNT(ist.issued_id) FROM books as b 
JOIN issued_status as ist 
ON ist.issued_book_isbn=b.isbn
GROUP BY 1,2;

-- Task 7- Retrive all the books in specific category
SELECT * FROM books WHERE category='Classic';

-- Task 8 Find total rental income by category
SELECT b.category,SUM(b.rental_price) AS Total_rental,
COUNT(*) AS no_of_times_issued,(SUM(b.rental_price)*COUNT(*)) AS Total_income FROM books AS b
JOIN issued_status AS ist
ON ist.issued_book_isbn=b.isbn   
GROUP BY 1 ORDER BY Total_rental DESC;

-- Task 9- List all the members who are reg within 180 days
SELECT * FROM members WHERE reg_date>= CURRENT_DATE()-INTERVAL 180 day;

-- List employees with their branch manager name and branch details
SELECT  e1.*,b.manager_id,e2.emp_name AS MANAGER, b.branch_address FROM employees AS e1
JOIN branch as b
ON b.branch_id=e1.branch_id
JOIN employees AS e2
ON e2.emp_id=b.manager_id;

-- Task 11- Create a table with books having rental_price above certain threshold i.e 10;
CREATE TABLE rental_above_10 AS
SELECT * FROM books WHERE rental_price>7;
SELECT * FROM rental_above_10;

-- Task 12- Retrieve the book list not yet returned
SELECT * FROM issued_status as ist
LEFT JOIN return_status AS rs
ON rs.issued_id=ist.issued_id
WHERE rs.return_id IS NULL;


-- Task -13 Identify the members with overdue books
-- Write a query to find out the members who have overdue books(return_period -30 days)
-- Display the member's id ,member's name,book-title,issued date and days overdue
SELECT mem.member_id,mem.member_name,b.book_title,
ist.issued_date,rst.return_date,(CURRENT_DATE()-ist.issued_date) 
AS no_of_dAYS_overdue FROM issued_status as ist
JOIN members AS mem
ON ist.issued_member_id=mem.member_id 
JOIN books AS b
ON ist.issued_book_isbn=b.isbn
LEFT JOIN return_status AS rst
ON rst.issued_id=ist.issued_id
WHERE rst.return_date IS NULL AND (CURRENT_DATE()-ist.issued_date) > 30 ORDER BY 1;

/* Task 14- Update book-status on return
Write a Query to update the status of book in books table to 'yes' when they are returned based on the entry
on the return_status table' */
-- Store Procedures
DELIMITER //

CREATE PROCEDURE add_return_records_4(
    IN p_return_id VARCHAR(50),
    IN p_issued_id VARCHAR(50)
  
)
BEGIN
    DECLARE v_isbn VARCHAR(50);
    DECLARE v_bookname VARCHAR(50) ;

    -- Insert return details
    INSERT INTO return_status (return_id, issued_id, return_date)
    VALUES (p_return_id, p_issued_id, CURRENT_DATE());

    -- Fetch the book ISBN from issued_status
    SELECT issued_book_isbn,issued_book_name
    INTO v_isbn, v_bookname
    FROM issued_status
    WHERE issued_id = p_issued_id;

    -- Update book status to available
    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    -- MySQL doesn't support RAISE NOTICE; use SELECT for messages
    SELECT CONCAT('THANK YOU FOR RETURNING book: ', v_book_name) AS message;
END //

DELIMITER ;

-- Calling the procedure
CALL add_return_records_4('RS120', 'IS140');

SHOW PROCEDURE STATUS WHERE Db = 'library_management';
DELETE FROM return_status WHERE return_id='RS119';






