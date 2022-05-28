
--Creating a Database for a computer store

--------------------------------------------------------------------------------------------------------------------------
--Creating a table for the stores Inventory

CREATE TABLE Inventory (id INTEGER PRIMARY KEY,condition TEXT, color TEXT, operatingsystem TEXT, price INTEGER);

--Inserting Data into the Inventory table

INSERT INTO Inventory VALUES(1, 'excellent', 'black', 'Windows 10', 250);
INSERT INTO Inventory VALUES(2, 'bad', 'black', 'Windows 7', 170);
INSERT INTO Inventory VALUES(3, 'fair', 'blue', 'Windows 10', 200);
INSERT INTO Inventory VALUES(4, 'good', 'silver', 'MacOS', 310);
INSERT INTO Inventory VALUES(5, 'good', 'blue', 'MacOS', 200);
INSERT INTO Inventory VALUES(6, 'excellent', 'black', 'Windows 10', 250);
INSERT INTO Inventory VALUES(7, 'good', 'black', 'Windows 7', 170);
INSERT INTO Inventory VALUES(8, 'good', 'blue', 'Windows 10', 190);
INSERT INTO Inventory VALUES(9, 'good', 'silver', 'MacOS', 300);
INSERT INTO Inventory VALUES(10, 'good', 'blue', 'Windows 10', 200);

--------------------------------------------------------------------------------------------------------------------------
--Creating a table for the stores Customers

CREATE TABLE Customer (id INTEGER PRIMARY KEY, Name VARCHAR(150), Phone_Number VARCHAR(50), Email VARCHAR(150));

--Inserting Data into the Customer table

INSERT INTO Customer VALUES(1, 'Max Willis', '508-234-6253', 'maxchill424@yahoo.com');
INSERT INTO Customer VALUES(2, 'Bob Charles', '508-245-5745', 'coolbob234@yahoo.com');
INSERT INTO Customer VALUES(3, 'Alice Barker', '508-342-2322', 'alicequeen22@gmail.com');
INSERT INTO Customer VALUES(4, 'Alex Pacheco', '508-264-3332', 'alexanderthegreat3@yahoo.com');
INSERT INTO Customer VALUES(5, 'Jeff Tiller', '508-1112-3654', 'Frankice@gmail.com');
INSERT INTO Customer VALUES(6, 'Elon Todd', '508-234-8882', 'Toddman66@gmail.com');
INSERT INTO Customer VALUES(7, 'Michael Shafer', '508-264-9702', 'bigmike33@yahoo.com');

--------------------------------------------------------------------------------------------------------------------------
--Select statements on Inventory table

SELECT * FROM Inventory ORDER BY price;

SELECT SUM(price) FROM Inventory;

SELECT AVG(price) FROM Inventory;
--------------------------------------------------------------------------------------------------------------------------
--Select statements on Customer table

SELECT * FROM Customer ORDER BY ID DESC;

SELECT COUNT(*) FROM Customer;

SELECT Name, Phone_Number FROM Customer;


--------------------------------------------------------------------------------------------------------------------------
