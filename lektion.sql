DROP TABLE IF EXISTS Screening;
DROP TABLE IF EXISTS Movies;
DROP TABLE IF EXISTS Cinemas;
DROP TABLE IF EXISTS Staff;

CREATE TABLE Staff(
	StaffNo INT PRIMARY KEY,
	Surname VARCHAR(20),
	Given VARCHAR (20),
	Sex VARCHAR (1),
	Dob DATE,
	Joined DATE,
	Resigned DATE,
	[Address] VARCHAR(30),
	PostCode INT,
	HomePhone BIGINT,
	WorkPhone BIGINT,
	Rateperhour INT,
	--CHECK (Joined >= Dob),
    --CHECK (Resigned >= Joined)
);
------------------------------ Ovan skapar vi STAFF TABLE
CREATE TABLE Cinemas (
	CinemaNo INT PRIMARY KEY,
	Numericseats INT,
	Screensize INT,
);
------------------------------ Ovan skapar vi CINEMA TABLE
CREATE TABLE Movies(
	MovieNo INT PRIMARY KEY,
	Title VARCHAR(20),
	Length INT,
	Category VARCHAR(20),
	Classification CHAR,
	Year INT,
	Studio VARCHAR(20),
);
------------------------- ovan skapar vi movird TABLE
CREATE TABLE Screening (
	ScreeningNo INT PRIMARY KEY,
	CinemaNo INT,
	FOREIGN KEY(CinemaNo) REFERENCES Cinemas(CinemaNo),
	MovieNo INT,
	FOREIGN KEY(MovieNo) REFERENCES Movies(MovieNo),
	SupervisorNo INT,
	FOREIGN KEY(SupervisorNo) REFERENCES Staff(StaffNo),
	Hourstart INT,
	Screeningdate DATE,
);

-------------------------ovan skapar vi screening TABLE
INSERT INTO Staff(StaffNo,Surname,Given,Sex,Dob,Joined,Resigned,[Address],PostCode,HomePhone,WorkPhone,Rateperhour)
	VALUES(143,'Johansson','Jonas','M','1982-11-11','2008-12-10',NULL,'Ryavägen 98',19163,087519468,0725222736,20),
	(243,'Agnesson','Agnes','F','2001-03-28','2021-05-15','2022-12-10','Skolgatan 45',58434,8434834,0735383291,20),
	(433,'Gustafsson','Simeon','M','1982-11-11','2008-12-10',NULL,'Alsättersgatan 4',58321,087519468,0725222736,45),
	(544,'Anka','Kalle','M','2001-11-11','2008-12-10','2010-12-10','Storgatan 28',83232,087519468,0725222736,45),
	(534,'Felixsson','Felix','M','2014-11-11','2008-12-10','2015-12-10','Strandvägen 53',97756,087519468,0725222736,10);

SELECT * FROM Staff



