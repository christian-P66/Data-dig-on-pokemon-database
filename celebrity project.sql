
--Demonstrating the many different JOINS you can do in SQL
--Skills used Creating tables, Inserting data, JOIN Clauses

 --------------------------------------------------------------------------------------------------------------------------
-- Creating a table of Actors and inserting data

CREATE TABLE Actors (id INTEGER PRIMARY KEY, name TEXT, age INTEGER, height TEXT, net_worth INTEGER, spouses_id INTEGER );

--Inserting data into the Actors table

INSERT INTO Actors VALUES(1, 'Ashton Kutcher', 44, ' 6′2 ',200000000, 2);
INSERT INTO Actors VALUES(2, 'Mila Kunis', 38, ' 5′4 ',75000000, 1);
INSERT INTO Actors VALUES(3, 'rita wilson', 65, ' 5′8 ',100000000 , 4);
INSERT INTO Actors VALUES(4, 'Tom Hanks', 65, ' 6′0 ',400000000, 3);
INSERT INTO Actors VALUES(5, 'Blake Lively', 34, ' 5′10 ',30000000 , 6);
INSERT INTO Actors VALUES(6, 'Ryan Reynolds', 45, ' 6′2 ',150000000 , 5);
--------------------------------------------------------------------------------------------------------------------------
-- Creating a table of Movies the actors what been in and inserting data

CREATE TABLE Movies (Actor_id INTEGER , name TEXT, release_year INTEGER);

--Inserting data into the Movies table

INSERT INTO Movies VALUES(1, 'Killers', 2010);
INSERT INTO Movies VALUES(1, 'Jobs', 2013);
INSERT INTO Movies VALUES(1, 'The Butterfly Effect', 2004);
INSERT INTO Movies VALUES(2, 'Ted', 2012);
INSERT INTO Movies VALUES(2, 'Bad Moms', 2016);
INSERT INTO Movies VALUES(3, 'Old Dogs', 2009);
INSERT INTO Movies VALUES(3, 'Sleepless In Seattle', 1993);
INSERT INTO Movies VALUES(4, 'The Green Mile', 1999);
INSERT INTO Movies VALUES(4, 'The Polar Express', 2004);
INSERT INTO Movies VALUES(4, 'Forest Gump', 1994);
INSERT INTO Movies VALUES(4, 'Philidelphia', 1993);
INSERT INTO Movies VALUES(5, 'Green Lantern', 2011);
INSERT INTO Movies VALUES(5, 'Town', 2010);
INSERT INTO Movies VALUES(6, 'Free Guy', 2021);
INSERT INTO Movies VALUES(6, 'Buried', 2010);
INSERT INTO Movies VALUES(6, 'Deadpool', 2016);
INSERT INTO Movies VALUES(6, 'Deadpool 2', 2018);
--------------------------------------------------------------------------------------------------------------------------

-- Creating a table of Relatives of famous actors and inserting data

CREATE TABLE Family (Famous_Reletive_id INTEGER , name TEXT, Age INTEGER, relation TEXT);

--Inserting data into the Family table

INSERT INTO Family VALUES(1, 'Michael Kutcher', 44, 'Brother');
INSERT INTO Family VALUES(1, 'Tausha Kutcher', 47, 'Sister');
INSERT INTO Family VALUES(2, 'Michael Kunis', 46, 'Brother');
INSERT INTO Family VALUES(4, 'Colin Hanks', 44, 'Son');
INSERT INTO Family VALUES(4, 'Elizabeth Ann Hanks', 40, 'Daughter');
INSERT INTO Family VALUES(5, 'Lori Lively', 55, 'Sister');
INSERT INTO Family VALUES(5, 'Eric Lively', 40, 'Brother');
INSERT INTO Family VALUES(5, 'Jason Lively', 54, 'Brother');
--------------------------------------------------------------------------------------------------------------------------
-- Cross join on family combines the two tables but doesnt provide any meaningful data.

SELECT *
FROM Actors, Family

--------------------------------------------------------------------------------------------------------------------------
--Implicit Inner JOIN on the Movies and Actors tables, it shows the actors and the movies they star in.

SELECT Actors.name, Actors.age, Actors.height, Movies.name, Movies.release_year
FROM Actors, Movies
WHERE Actors.id = Movies.Actor_id

--------------------------------------------------------------------------------------------------------------------------
--Explicit Inner JOIN on the Movies and Actors tables, showing the movies that were released after 2005 and who starred in it. 

SELECT Actors.name, Movies.name, Movies.release_year
FROM Movies
JOIN Actors
ON Actors.id = Movies.Actor_id
WHERE Movies.release_year > 2005
ORDER BY Movies.release_year;

--------------------------------------------------------------------------------------------------------------------------
--Explicit Inner JOIN on the Actors and Family tables, showing the Actors and Relatives ordered by age

SELECT Actors.name, Family.name AS family_member, Family.age, Family.relation
FROM Actors
JOIN Family
ON Actors.id = Family.Famous_Reletive_id
ORDER BY Family.Age;

--------------------------------------------------------------------------------------------------------------------------
--Self JOIN showing the Actors and their spouses

SELECT Actors.name,spouse.name AS spouse
FROM Actors
JOIN Actors spouse
ON Actors.id = spouse.spouses_id;

--------------------------------------------------------------------------------------------------------------------------
--Self JOIN showing the Actors and their spouses, and then calculating the couples networth

SELECT Actors.name,spouse.name AS spouse, Actors.net_worth + spouse.net_worth AS couples_networth
FROM Actors
JOIN Actors spouse
ON Actors.id = spouse.spouses_id ;

--------------------------------------------------------------------------------------------------------------------------
--Using multiple JOINS with Actor and Movies table to show the Actor couples and the movies they have been in 

SELECT Actors.name AS Actor,spouse.name AS spouse, Movies.name
FROM Actors
JOIN Actors spouse
ON Actors.id = spouse.spouses_id
JOIN Movies
ON Actors.id = Movies.Actor_id;

--------------------------------------------------------------------------------------------------------------------------







