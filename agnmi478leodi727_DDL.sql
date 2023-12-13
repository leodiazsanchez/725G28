DROP VIEW IF EXISTS Users_view;
DROP VIEW IF EXISTS Borrowed_books;
DROP PROCEDURE IF EXISTS returnBook;
DROP PROCEDURE IF EXISTS BorrowBook;

DROP TABLE IF EXISTS BorrowedJournalsRow;
DROP TABLE IF EXISTS BorrowedJournalsCol;
DROP TABLE IF EXISTS Journals;
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
	user_id INT IDENTITY PRIMARY KEY,
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
	shelf_id INT IDENTITY PRIMARY KEY,
	row_count INT,
	[location] VARCHAR(30) NOT NULL
);

CREATE TABLE Books(
	book_id INT IDENTITY PRIMARY KEY,
	shelf_id INT,
	FOREIGN KEY(shelf_id) REFERENCES Shelves(shelf_id),
	[row] INT,
	title VARCHAR(255),
	author VARCHAR(255),
);

CREATE TABLE BorrowedBooksCol(
	order_id INT IDENTITY PRIMARY KEY,
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
	dig_id INT IDENTITY PRIMARY KEY,
	user_id INT,
	FOREIGN KEY(user_id) REFERENCES Users(user_id),
	grid INT,
	depth INT,
	[location] VARCHAR(255) NOT NULL
);

CREATE TABLE Artifacts(
	artifact_id INT IDENTITY PRIMARY KEY,
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
	slide_id INT IDENTITY PRIMARY KEY,
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

CREATE TABLE Journals (
    journal_id INT IDENTITY PRIMARY KEY,
    title VARCHAR(255),
    published DATE
);

-- Table for overall borrowed journals information
CREATE TABLE BorrowedJournalsCol (
    order_id INT PRIMARY KEY,
    user_id INT,
    FOREIGN KEY(user_id) REFERENCES Users(user_id),
    borrow_date DATE NOT NULL,
    return_date DATE
);

-- Table for individual borrowed journals
CREATE TABLE BorrowedJournalsRow (
    order_id INT,
    FOREIGN KEY(order_id) REFERENCES BorrowedJournalsCol(order_id),
    journal_id INT,
    FOREIGN KEY(journal_id) REFERENCES Journals(journal_id)
);

---- to add values to our users table we insert it here underneath

INSERT INTO Users (first_name, last_name, date_of_birth, email, phone_number, address, registration_date)
VALUES
  ('Erik', 'Larsson', '1985-03-12', 'erik.larsson@email.com', '0701234567', 'Gatan 1, Stockholm', '2023-01-01'),
  ('Anna', 'Andersson', '1990-05-18', 'anna.andersson@email.com', '0709876543', 'Vägen 2, Göteborg', '2023-02-01'),
  ('Oscar', 'Svensson', '1988-09-22', 'oscar.svensson@email.com', '0705551234', 'Backen 3, Malmö', '2023-03-01'),
  ('Emelie', 'Johansson', '1993-11-08', 'emelie.johansson@email.com', '0703334444', 'Höjden 4, Uppsala', '2023-04-01'),
  ('Gustav', 'Nilsson', '1982-07-14', 'gustav.nilsson@email.com', '0702221111', 'Strand 5, Linköping', '2023-05-01'),
  ('Sofia', 'Berg', '1998-02-20', 'sofia.berg@email.com', '0706667777', 'Skog 6, Örebro', '2023-06-01'),
  ('Henrik', 'Persson', '1987-12-05', 'henrik.persson@email.com', '0709998888', 'Berg 7, Västerås', '2023-07-01'),
  ('Amanda', 'Holm', '1995-04-30', 'amanda.holm@email.com', '0701112222', 'Äng 8, Jönköping', '2023-08-01'),
  ('Karl', 'Eriksson', '1980-10-17', 'karl.eriksson@email.com', '0704445555', 'Sjö 9, Norrköping', '2023-09-01'),
  ('Maja', 'Lindqvist', '1991-06-25', 'maja.lindqvist@email.com', '0707776666','Villevägen 4, Linköping','2023-02-03');
  -- to print we select the whole table
 SELECT * FROM Users
  -- Lägger in värden för hyllorna 
INSERT INTO Shelves (row_count,[location])
  VALUES
  (20, 'Utställningssal A'),
  (20, 'Arkivrum B'),
  (30, 'Föremålsgalleri'),
  (10, 'Historiska utställningen'),
  (10, 'Teknikavdelningen');

SELECT * FROM Shelves
	
INSERT INTO Books (shelf_id, row, title, author)
VALUES
  (1, 1, 'The Great Gatsby', 'F. Scott Fitzgerald'),
  (2, 2, 'To Kill a Mockingbird', 'Harper Lee'),
  (3, 3, '1984', 'George Orwell'),
  (4, 1, 'Pride and Prejudice', 'Jane Austen'),
  (5, 2, 'The Catcher in the Rye', 'J.D. Salinger'),
  (1, 3, 'One Hundred Years of Solitude', 'Gabriel García Márquez'),
  (2, 1, 'The Lord of the Rings', 'J.R.R. Tolkien');

SELECT * FROM Books

INSERT INTO Digs (user_id, grid, depth, [location])
VALUES
  (1, 101, 5, 'Ancient Ruins of Pompeii'),
  (2, 202, 8, 'Valley of the Kings'),
  (3, 303, 7, 'Machu Picchu'),
  (4, 404, 10, 'Troy Archaeological Site'),
  (5, 505, 6, 'Petra, Jordan'),
  (6, 606, 9, 'Great Barrier Reef');

SELECT * FROM Digs

INSERT INTO Artifacts (dig_id,shelf_id,row,description,date)
VALUES 
  (1, 1, 3, 'Ancient pottery', '2023-01-15'),
  (2, 2, 1, 'Bronze figurine', '2023-02-28'),
  (3, 3, 2, 'Stone tools', '2023-03-12'),
  (4, 4, 4, 'Ceramic artifacts', '2023-04-20'),
  (5, 5, 3, 'Glass beads', '2023-05-05'),
  (1, 1, 2, 'Roman coins', '2023-06-10'),
  (2, 2, 3, 'Hieroglyphic tablet', '2023-07-15'),
  (3, 3, 1, 'Incan textile fragment', '2023-08-22'),
  (4, 4, 2, 'Ancient pottery shards', '2023-09-05'),
  (5, 5, 4, 'Nabataean carvings', '2023-10-18'),
  (6, 1, 3, 'Greek amphora', '2023-11-25'),
  (6, 2, 1, 'Egyptian scarab beetle', '2023-12-10'),
  (1, 1, 4, 'Etruscan jewelry', '2024-01-15'),
  (2, 2, 2, 'Pharaonic papyrus scroll', '2024-02-28'),
  (3, 3, 3, 'Golden Incan artifact', '2024-03-12'),
  (4, 4, 1, 'Byzantine mosaic fragment', '2024-04-20'),
  (5, 5, 2, 'Petraean pottery', '2024-05-05'),
  (6, 1, 1, 'Roman glassware', '2024-06-10'),
  (6, 2, 3, 'Tutankhamuns necklace', '2024-07-15'),
  (1, 1, 2, 'Mayan jade carving', '2024-08-22'),
  (2, 2, 4, 'Sumerian cuneiform tablet', '2024-09-05'),
  (3, 3, 3, 'Moche pottery figurine', '2024-10-18'),
  (4, 4, 2, 'Hellenistic marble statue', '2024-11-25'),
  (5, 5, 1, 'Norse Viking artifact', '2024-12-10'),
  (6, 1, 4, 'Aztec ceremonial mask', '2025-01-15'),
  (6, 2, 2, 'Babylonian cylinder seal', '2025-02-28'),
  (1, 1, 3, 'Minoan fresco fragment', '2025-03-12'),
  (2, 2, 1, 'Indus Valley seal', '2025-04-20'),
  (3, 3, 4, 'Khmer Empire sculpture', '2025-05-05'),
  (4, 4, 3, 'Angkor Wat stone carvings', '2025-06-10');

SELECT * FROM Artifacts

-- Corrected Topics table
INSERT INTO Topics (topic_name)
VALUES
	('Middle East'),
	('Ancient Greece'), -- Corrected typo
	('Ancient Civilizations'),
	('Torrevieja'),
	('South America'),
	('Archaeological Technique'), -- Corrected typo
	('Underwater Archaeology'),
	('Prehistoric Art');

-- Corrected Slides table
INSERT INTO Slides (shelf_id, dig_id, topic_name, row)
VALUES
	(1, 1, 'Middle East', 1),
	(2, 2, 'South America', 3),
	(3, 3, 'Ancient Civilizations', 4),
	(4, 4, 'Archaeological Technique', 2), 
	(5, 5, 'Underwater Archaeology', 4),
	(1, 6, 'Prehistoric Art', 4),
	(1, 2, 'Middle East', 1);


SELECT * FROM Topics

SELECT * FROM Slides

GO
-- Create a stored procedure to handle book borrowing
CREATE PROCEDURE BorrowBook
    @user_id INT,
    @book_id INT
AS
BEGIN
    DECLARE @order_id INT;
	 IF EXISTS (
        SELECT
            b.book_id
        FROM
            Books b
            INNER JOIN BorrowedBooksRow bbr ON b.book_id = bbr.book_id
            INNER JOIN BorrowedBooksCol bbc ON bbr.order_id = bbc.order_id
        WHERE
            bbc.return_date IS NULL
            AND b.book_id = @book_id
    )
    BEGIN
        -- Book is not available
        RAISERROR('Oh no! Something bad just happened!', 16, 1);
        RETURN;
    END;
    -- Insert into BorrowedBooksCol
    INSERT INTO BorrowedBooksCol (user_id, borrow_date, return_date)
    VALUES (@user_id, GETDATE(), NULL);

    -- Get the order_id of the inserted BorrowedBooksCol record
    SET @order_id = SCOPE_IDENTITY();

    -- Insert into BorrowedBooksRow
    INSERT INTO BorrowedBooksRow (order_id, book_id)
    VALUES (@order_id, @book_id);
END;
GO

GO
CREATE PROCEDURE returnBook
    @user_id INT,
    @book_id INT
AS
BEGIN
DECLARE @order_id INT;

    -- Check if the book is currently borrowed by the specified user
    IF NOT EXISTS (
        SELECT 1
        FROM BorrowedBooksCol bbc
        INNER JOIN BorrowedBooksRow bbr ON bbc.order_id = bbr.order_id
        WHERE bbc.user_id = @user_id
          AND bbr.book_id = @book_id
          AND bbc.return_date IS NULL
    )
    BEGIN
        -- Book is not currently borrowed by the specified user
        RAISERROR('Oh no! Something bad just happened!', 16, 1);
        RETURN;
    END;

    -- Get the order_id of the borrowed book
    SELECT @order_id = bbc.order_id
    FROM BorrowedBooksCol bbc
    INNER JOIN BorrowedBooksRow bbr ON bbc.order_id = bbr.order_id
    WHERE bbc.user_id = @user_id
      AND bbr.book_id = @book_id
      AND bbc.return_date IS NULL;

    -- Update BorrowedBooksCol to mark the book as returned
    UPDATE BorrowedBooksCol
    SET return_date = GETDATE()
    WHERE order_id = @order_id;

    -- Optionally, perform additional actions or logging as needed

    -- Print a success message
    PRINT 'Book returned successfully.';
END;
GO
-- Example of borrowing a book
EXEC BorrowBook
    @user_id = 1,
    @book_id = 5;

EXEC BorrowBook
    @user_id = 2,
    @book_id = 2;

EXEC returnBook
    @user_id = 2,
    @book_id = 2;

SELECT * FROM BorrowedBooksCol;
SELECT * FROM BorrowedBooksRow;

GO
CREATE VIEW 
Users_view AS
SELECT USER_ID, first_name,Last_name 
FROM Users
WHERE user_id = 2;
GO

SELECT * FROM Users_view;

--VIEWS--
GO
CREATE VIEW Borrowed_books AS 
SELECT
    CONCAT(u.first_name, ' ', u.last_name) AS borrower_name,
	    b.title,
		b.author
FROM
    BorrowedBooksCol AS bbc
INNER JOIN
    BorrowedBooksRow AS bbr ON bbc.order_id = bbr.order_id 
INNER JOIN
    Users AS u ON u.user_id = bbc.user_id
INNER JOIN
    Books AS b ON b.book_id = bbr.book_id
WHERE 
	bbc.return_date IS NULL;
	GO
		SELECT COUNT(*) AS borrowed_books_count FROM Borrowed_books;
	GO
GO
SELECT * FROM Borrowed_books;

--FRÅGOR--
SELECT COUNT (Slide_id) AS slide_count, topic_name
FROM Slides
GROUP BY topic_name
ORDER BY COUNT(slide_id) DESC;
