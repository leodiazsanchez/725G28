DROP TABLE IF EXISTS BorrowedSlidesRow;
DROP TABLE IF EXISTS BorrowedSlidesCol;
DROP TABLE IF EXISTS Slides;
DROP TABLE IF EXISTS Topics;
DROP TABLE IF EXISTS BorrowedArtifactsRow;
DROP TABLE IF EXISTS BorrowedArtifactsCol;
DROP TABLE IF EXISTS Artifacts;
DROP TABLE IF EXISTS Digs;
DROP TABLE IF EXISTS BorrowedBooksRow;
DROP TABLE IF EXISTS BorrowedBooksCol;
DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Shelves;
DROP TABLE IF EXISTS Users;

CREATE TABLE Users(
	user_id INT PRIMARY KEY,
	first_name VARCHAR(20),
	last_name VARCHAR(30),
	date_of_birth DATE,
	email VARCHAR(50) UNIQUE,
	phone_number VARCHAR(15) UNIQUE,
	[address] VARCHAR(100),
	registration_date DATE
);
------ Vi skapar TABLE Users
CREATE TABLE Shelves(
	shelf_id INT PRIMARY KEY,
	row_count INT,
	[location] VARCHAR(30) NOT NULL
);

CREATE TABLE Books(
	book_id INT PRIMARY KEY,
	shelf_id INT,
	FOREIGN KEY(shelf_id) REFERENCES Shelves(shelf_id),
	[row] INT,
	title VARCHAR(255),
	author VARCHAR(255),
);

CREATE TABLE BorrowedBooksCol(
	order_id INT PRIMARY KEY,
	user_id INT,
	FOREIGN KEY(user_id) REFERENCES Users(user_id),
	borrow_date DATE NOT NULL,
	return_date DATE,
	CHECK (return_date>= borrow_date)
);

CREATE TABLE BorrowedBooksRow(
	order_id INT,
	FOREIGN KEY(order_id) REFERENCES BorrowedBooksCol(order_id),
	book_id INT,
	FOREIGN KEY(book_id) REFERENCES Books(book_id)
);

CREATE TABLE Digs(
	dig_id INT PRIMARY KEY,
	user_id INT,
	FOREIGN KEY(user_id) REFERENCES Users(user_id),
	grid INT,
	depth INT,
	[location] VARCHAR(255) NOT NULL
);

CREATE TABLE Artifacts(
	artifact_id INT PRIMARY KEY,
	dig_id INT,
	FOREIGN KEY(dig_id) REFERENCES Digs(dig_id),
	shelf_id INT,
	FOREIGN KEY(shelf_id) REFERENCES Shelves(shelf_id),
	[row] INT,
	[description] VARCHAR(255),
	[date] DATE
);

CREATE TABLE BorrowedArtifactsCol (
    order_id INT PRIMARY KEY,
    user_id INT,
    FOREIGN KEY(user_id) REFERENCES Users(user_id),
    borrow_date DATE NOT NULL,
    return_date DATE
);

CREATE TABLE BorrowedArtifactsRow (
    order_id INT,
    FOREIGN KEY(order_id) REFERENCES BorrowedArtifactsCol(order_id),
    artifact_id INT,
    FOREIGN KEY(artifact_id) REFERENCES Artifacts(artifact_id)
);

CREATE TABLE Topics (
	topic_name VARCHAR(255) PRIMARY KEY
);

CREATE TABLE Slides (
	slide_id INT PRIMARY KEY,
	shelf_id INT,
	FOREIGN KEY (shelf_id) REFERENCES Shelves(shelf_id),
	dig_id INT,
	FOREIGN KEY(dig_id) REFERENCES Digs(dig_id),
	topic_name VARCHAR(255),
	FOREIGN KEY (topic_name) REFERENCES Topics (topic_name),
	[row] INT
);

CREATE TABLE BorrowedSlidesCol (
    order_id INT PRIMARY KEY,
    user_id INT,
    FOREIGN KEY(user_id) REFERENCES Users(user_id),
    borrow_date DATE NOT NULL,
    return_date DATE
);

CREATE TABLE BorrowedSlidesRow (
    order_id INT,
    FOREIGN KEY(order_id) REFERENCES BorrowedSlidesCol(order_id),
    slide_id INT,
    FOREIGN KEY(slide_id) REFERENCES Slides(slide_id)
);

---- to add values to our users table we insert it here underneath

INSERT INTO Users (user_id, first_name, last_name, date_of_birth, email, phone_number, address, registration_date)
VALUES
  (1, 'Erik', 'Larsson', '1985-03-12', 'erik.larsson@email.com', '0701234567', 'Gatan 1, Stockholm', '2023-01-01'),
  (2, 'Anna', 'Andersson', '1990-05-18', 'anna.andersson@email.com', '0709876543', 'Vägen 2, Göteborg', '2023-02-01'),
  (3, 'Oscar', 'Svensson', '1988-09-22', 'oscar.svensson@email.com', '0705551234', 'Backen 3, Malmö', '2023-03-01'),
  (4, 'Emelie', 'Johansson', '1993-11-08', 'emelie.johansson@email.com', '0703334444', 'Höjden 4, Uppsala', '2023-04-01'),
  (5, 'Gustav', 'Nilsson', '1982-07-14', 'gustav.nilsson@email.com', '0702221111', 'Strand 5, Linköping', '2023-05-01'),
  (6, 'Sofia', 'Berg', '1998-02-20', 'sofia.berg@email.com', '0706667777', 'Skog 6, Örebro', '2023-06-01'),
  (7, 'Henrik', 'Persson', '1987-12-05', 'henrik.persson@email.com', '0709998888', 'Berg 7, Västerås', '2023-07-01'),
  (8, 'Amanda', 'Holm', '1995-04-30', 'amanda.holm@email.com', '0701112222', 'Äng 8, Jönköping', '2023-08-01'),
  (9, 'Karl', 'Eriksson', '1980-10-17', 'karl.eriksson@email.com', '0704445555', 'Sjö 9, Norrköping', '2023-09-01'),
  (10, 'Maja', 'Lindqvist', '1991-06-25', 'maja.lindqvist@email.com', '0707776666','Villevägen 4, Linköping','2023-02-03');
  -- to print we select the whole table
  SELECT * FROM Users
  -- Lägger in värden för hyllorna 
  INSERT INTO Shelves (shelf_id,row_count,[location])
  VALUES
  (1, 20, 'Utställningssal A'),
  (2, 20, 'Arkivrum B'),
  (3, 30, 'Föremålsgalleri'),
  (4, 10, 'Historiska utställningen'),
  (5, 10, 'Teknikavdelningen');

SELECT * FROM Shelves
	
INSERT INTO Books (book_id, shelf_id, row, title, author)
VALUES
  (1, 1, 1, 'The Great Gatsby', 'F. Scott Fitzgerald'),
  (2, 2, 2, 'To Kill a Mockingbird', 'Harper Lee'),
  (3, 3, 3, '1984', 'George Orwell'),
  (4, 4, 1, 'Pride and Prejudice', 'Jane Austen'),
  (5, 5, 2, 'The Catcher in the Rye', 'J.D. Salinger');

SELECT * FROM Books

INSERT INTO Digs (dig_id, user_id, grid, depth, [location])
VALUES
  (1, 1, 101, 5, 'Ancient Ruins of Pompeii'),
  (2, 2, 202, 8, 'Valley of the Kings'),
  (3, 3, 303, 7, 'Machu Picchu'),
  (4, 4, 404, 10, 'Troy Archaeological Site'),
  (5, 5, 505, 6, 'Petra, Jordan');

SELECT * FROM Digs

INSERT INTO Artifacts (artifact_id,dig_id,shelf_id,row,description,date)
VALUES 
  (1, 1, 1, 3, 'Ancient pottery', '2023-01-15'),
  (2, 2, 2, 1, 'Bronze figurine', '2023-02-28'),
  (3, 3, 3, 2, 'Stone tools', '2023-03-12'),
  (4, 4, 4, 4, 'Ceramic artifacts', '2023-04-20'),
  (5, 5, 5, 3, 'Glass beads', '2023-05-05');
  SELECT * FROM Artifacts

  INSERT INTO Topics (topic_name)
	VALUES
	('Middle Est'),
	('Anicent Greek'),
	('CUBAN'),
	('From Torrevija'),
	('Viking Time')
	SELECT * FROM Topics

  INSERT INTO Slides (slide_id,shelf_id,dig_id,topic_name,row)
  VALUES
    (1, 1,1 , 'Middle est',	1),
    (2, 1,1 , 'Middle est', 2),
    (3, 1,1 , 'Middle est', 2),
    (4, 1,1 , 'Middle est', 4),
    (5, 1,1 , 'Middle est', 2)

	SELECT * FROM Slides


	
