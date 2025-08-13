
# 📚 Library Management System – MySQL Project

## 📌 Overview
This project is a **Library Management System** built using **MySQL**.  
It manages books, members, employees, branches, issue and return records.  
Data is imported into MySQL using the **Import Data Wizard**, and various SQL operations are performed to simulate real-world library tasks.

---

## ⚙️ Prerequisites
- **MySQL Server** (8.0+ recommended)
- **MySQL Workbench**
- The provided SQL file: `Library-management.sql`

---

## 📥 Data Import Instructions
1. **Open MySQL Workbench** and connect to your MySQL server.
2. **Create the database**:
   ```sql
   CREATE DATABASE library_management;
   USE library_management;
   ```
3. **Use Import Data Wizard**:
   - Go to **Server → Data Import**.
   - Select **Import from Self-Contained File** and choose the `.sql` file.
   - Select `library_management` as the target schema.
   - Click **Start Import**.

---

## 📂 Database Tables
The main tables in the system are:
- `books` – Stores book details.
- `members` – Library members and their info.
- `employees` – Employees working in the library.
- `branch` – Library branch details.
- `issued_status` – Records of issued books.
- `return_status` – Records of returned books.

---

## 🛠 Features & Tasks Implemented

### 1. **CRUD Operations**
- **Create**: Add new books.
- **Read**: View records (e.g., list all books in a category).
- **Update**: Change member details.
- **Delete**: Remove issued book records.

### 2. **SQL Queries**
- Retrieve books issued by a specific employee.
- List members who have issued more than one book.
- Create summary tables using **CTAS**.
- Find books in a specific category.
- Calculate total rental income by category.
- List members registered within 180 days.
- Show employees with their branch manager and branch details.
- Create filtered tables for rental prices above a threshold.
- Retrieve books not yet returned.
- Identify members with overdue books.

### 3. **Stored Procedure**
**`add_return_records_4`**:
- Inserts return details into `return_status`.
- Updates the book status to `'yes'` (available).
- Displays a thank-you message with the book name.

**Usage**:
```sql
CALL add_return_records_4('RS120', 'IS140');
```

---

## 📊 Example Queries

**Insert a New Book**:
```sql
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
```

**Find Overdue Books**:
```sql
SELECT mem.member_id, mem.member_name, b.book_title,
       ist.issued_date, (CURRENT_DATE() - ist.issued_date) AS days_overdue
FROM issued_status AS ist
JOIN members AS mem ON ist.issued_member_id = mem.member_id
JOIN books AS b ON ist.issued_book_isbn = b.isbn
LEFT JOIN return_status AS rst ON rst.issued_id = ist.issued_id
WHERE rst.return_date IS NULL AND (CURRENT_DATE() - ist.issued_date) > 30
ORDER BY 1;
```

---

## 🚀 How to Run
1. Import the `.sql` file as described above.
2. Execute the queries in `Library-management.sql`.
3. Test the stored procedures using `CALL` statements.
4. Modify queries to match your library data needs.

---

## 📌 Notes
- Make sure foreign keys and indexes are correctly set after import.
- Adjust date intervals in queries if your MySQL version requires `INTERVAL` keyword syntax.
- The `Import Data Wizard` is the simplest way to load the provided `.sql` file without manual scripting.

---

## 📜 License
This project is for **educational purposes** only. Feel free to modify and adapt it.
