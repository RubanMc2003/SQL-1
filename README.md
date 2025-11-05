# 🧠 SQL Practice Scenarios

This repository contains a collection of **SQL exercises** covering essential database concepts — from basic `CREATE TABLE` commands to advanced features like **views**, **functions**, **stored procedures**, **triggers**, and **transactions**.  

Each section includes a **real-world scenario**, a **task description**, and the corresponding **SQL solution**.

---

## 📚 Topics Covered

1. CREATE TABLE  
2. ALTER TABLE  
3. PRIMARY & FOREIGN KEYS  
4. UNIQUE Constraint  
5. DELETE vs TRUNCATE  
6. DISTINCT Keyword  
7. NULL & NOT NULL  
8. IN, BETWEEN, NOT BETWEEN  
9. ORDER BY & LIMIT  
10. Aggregate Functions (COUNT, SUM, AVG, MAX, MIN)  
11. GROUP BY & HAVING  
12. INNER JOIN  
13. LEFT & RIGHT JOIN  
14. UNION & UNION ALL  
15. String Functions (UPPER, LOWER, SUBSTRING, CONCAT)  
16. Date Functions (DATEDIFF, YEAR, NOW)  
17. User Defined Function (UDF)  
18. Stored Procedure  
19. Views  
20. Multi-table View  
21. Triggers  
22. GRANT & REVOKE  
23. Transactions (COMMIT, ROLLBACK, SAVEPOINT)  

---

## 🏥 Example Scenarios

### 1️⃣ Create Table — *City Hospital*
```sql
CREATE DATABASE IF NOT EXISTS HospitalDb;
USE HospitalDb;

CREATE TABLE IF NOT EXISTS Patients (
  PatientID INT PRIMARY KEY AUTO_INCREMENT,
  PatientName VARCHAR(20),
  Age INT,
  Gender ENUM('Male', 'Female'),
  AdmissionDate DATE
);

