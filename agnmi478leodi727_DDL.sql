--Dropping views, tables and stored procedures

DROP VIEW IF EXISTS Users_view;
DROP VIEW IF EXISTS Shelves_with_books;
DROP VIEW IF EXISTS Borrowed_books;
DROP VIEW IF EXISTS Artifact_Report;
DROP VIEW IF EXISTS Borrowed_slides;
DROP VIEW IF EXISTS Slide_Catalog;

DROP PROCEDURE IF EXISTS BorrowSlide;
DROP PROCEDURE IF EXISTS ReturnSlide;
DROP PROCEDURE IF EXISTS BorrowArtifact;
DROP PROCEDURE IF EXISTS ReturnArtifact;
DROP PROCEDURE IF EXISTS ReturnBook;
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
DROP TABLE IF EXISTS Former_users;
DROP TABLE IF EXISTS Users;

--Defining tables, level 0

CREATE TABLE Users(
	user_id				INT	IDENTITY			PRIMARY KEY,
	first_name			VARCHAR(20)				NOT NULL,
	last_name			VARCHAR(30)				NOT NULL,
	date_of_birth		DATE					NOT NULL,
	email				VARCHAR(50)				UNIQUE	NOT NULL,
	phone_number		VARCHAR(10)				UNIQUE	NOT NULL				
	CHECK (LEN(phone_number) = 10 AND ISNUMERIC(phone_number) = 1),
	[address]			VARCHAR(100)			NOT NULL,
	registration_date	DATE					NOT NULL,
	user_type			VARCHAR(20)				NOT NULL				
	CHECK (UPPER(user_type) IN ('EMPLOYEE', 'STUDENT')) /*Typ av användare*/
);

CREATE TABLE Former_users (
	user_id				INT						PRIMARY KEY,
	first_name			VARCHAR(20)				NOT NULL,
	last_name			VARCHAR(30)				NOT NULL,
	date_of_birth		DATE					NOT NULL,
	email				VARCHAR(50)				UNIQUE	NOT NULL,
	phone_number		VARCHAR(10)				UNIQUE NOT NULL
	CHECK (LEN(phone_number) = 10 AND ISNUMERIC(phone_number) = 1),
	[address]			VARCHAR(100)			NOT NULL,
	registration_date	DATE					NOT NULL,
	resigned_date		DATE					NOT NULL,
	user_type			VARCHAR(20)				NOT NULL 
	CHECK (UPPER(user_type) IN ('EMPLOYEE', 'STUDENT')) /*Typ av användare*/
);

CREATE TABLE Shelves(
	shelf_id			INT	IDENTITY			PRIMARY KEY,
	row_count			INT						NOT NULL,
	[location]			VARCHAR(30)				NOT NULL
);

--Defining tables, level 1

CREATE TABLE Books(
	book_id				INT IDENTITY			PRIMARY KEY,
	shelf_id			INT						NOT NULL,
	FOREIGN KEY(shelf_id) 
	REFERENCES Shelves(shelf_id),
	[row]				INT						NOT NULL,
	title				VARCHAR(255)			NOT NULL,
	author				VARCHAR(255)			NOT NULL
);

CREATE TABLE Journals (
    journal_id			INT IDENTITY			PRIMARY KEY,
	shelf_id			INT						NOT NULL,
	FOREIGN KEY(shelf_id) 
	REFERENCES Shelves(shelf_id),
	[row]				INT						NOT NULL,
    title				VARCHAR(255)			NOT NULL,
    published			DATE					NOT NULL,
	author				VARCHAR(255)			NOT NULL
);


CREATE TABLE BorrowedBooksCol(
	order_id			INT IDENTITY			PRIMARY KEY,
	user_id				INT						NOT NULL,
	FOREIGN KEY(user_id) 
	REFERENCES Users(user_id) 
	ON DELETE CASCADE,
	borrow_date			DATE					NOT NULL,
	return_date			DATE,
	CHECK (return_date>= borrow_date)
);

CREATE TABLE BorrowedBooksRow(
	order_id			INT,
	FOREIGN KEY(order_id) 
	REFERENCES BorrowedBooksCol(order_id) 
	ON DELETE CASCADE,
	book_id				INT,
	FOREIGN KEY(book_id) 
	REFERENCES Books(book_id) 
	ON DELETE CASCADE
);

CREATE TABLE Digs(
	dig_id				INT IDENTITY			PRIMARY KEY,
	user_id				INT						NOT NULL,
	FOREIGN KEY(user_id) 
	REFERENCES Users(user_id) 
	ON DELETE CASCADE,
	grid				INT						NOT NULL,
	depth				INT						NOT NULL,
	[location]			VARCHAR(255)			NOT NULL
);

CREATE TABLE Artifacts(
	artifact_id			INT IDENTITY			PRIMARY KEY,
	dig_id				INT,
	FOREIGN KEY(dig_id) 
	REFERENCES Digs(dig_id) 
	ON DELETE CASCADE,
	shelf_id			INT,
	FOREIGN KEY(shelf_id) 
	REFERENCES Shelves(shelf_id)
	ON DELETE CASCADE,
	[row]				INT						NOT NULL,
	[description]		VARCHAR(255)			NOT NULL,
	[date]				DATE					NOT NULL
);

CREATE TABLE BorrowedArtifactsCol (
    order_id			INT IDENTITY			PRIMARY KEY,
    user_id				INT						NOT NULL,
    FOREIGN KEY(user_id)
	REFERENCES Users(user_id)
	ON DELETE CASCADE,
    borrow_date			DATE					NOT NULL,
    return_date			DATE,
	CHECK (return_date >= borrow_date)
);

CREATE TABLE BorrowedArtifactsRow (
    order_id			INT,
    FOREIGN KEY(order_id)
	REFERENCES BorrowedArtifactsCol(order_id)
	ON DELETE CASCADE,
    artifact_id			INT,
    FOREIGN KEY(artifact_id)
	REFERENCES Artifacts(artifact_id) 
);

CREATE TABLE Topics (
	topic_name			VARCHAR(255)			PRIMARY KEY
);

CREATE TABLE Slides (
	slide_id			INT IDENTITY			PRIMARY KEY,
	shelf_id			INT,
	FOREIGN KEY (shelf_id)
	REFERENCES Shelves(shelf_id),
	dig_id				INT,
	FOREIGN KEY(dig_id) 
	REFERENCES Digs(dig_id) 
	ON DELETE SET NULL,
	topic_name			VARCHAR(255),
	FOREIGN KEY (topic_name)
	REFERENCES Topics (topic_name),
	[row]				INT						NOT NULL
);

CREATE TABLE BorrowedSlidesCol (
    order_id			INT IDENTITY			PRIMARY KEY,
    user_id				INT,
    FOREIGN KEY(user_id) 
	REFERENCES Users(user_id) 
	ON DELETE CASCADE,
    borrow_date			DATE					NOT NULL,
    return_date			DATE,
	CHECK (return_date >= borrow_date)
);

CREATE TABLE BorrowedSlidesRow (
    order_id			INT,
    FOREIGN KEY(order_id) 
	REFERENCES BorrowedSlidesCol(order_id)
	ON DELETE CASCADE,
    slide_id			INT,
    FOREIGN KEY(slide_id) 
	REFERENCES Slides(slide_id) 
	ON DELETE CASCADE
);

CREATE TABLE BorrowedJournalsCol (
    order_id			INT						PRIMARY KEY,
    user_id				INT,
    FOREIGN KEY(user_id) 
	REFERENCES Users(user_id)
	ON DELETE CASCADE,
    borrow_date			DATE					NOT NULL,
    return_date			DATE,
	CHECK (return_date >= borrow_date)
);

CREATE TABLE BorrowedJournalsRow (
    order_id			INT,
    FOREIGN KEY(order_id) 
	REFERENCES BorrowedJournalsCol(order_id),
    journal_id			INT,
    FOREIGN KEY(journal_id) 
	REFERENCES Journals(journal_id)
);

-- Inserting example values into the tables
/* 	user_id				INT	IDENTITY			PRIMARY KEY,
	first_name			VARCHAR(20)				NOT NULL,
	last_name			VARCHAR(30)				NOT NULL,
	date_of_birth		DATE					NOT NULL,
	email				VARCHAR(50)				UNIQUE	NOT NULL,
	phone_number		VARCHAR(10)				UNIQUE	NOT NULL				
	CHECK (LEN(phone_number) = 10 AND ISNUMERIC(phone_number) = 1),
	[address]			VARCHAR(100)			NOT NULL,
	registration_date	DATE					NOT NULL,
	user_type			VARCHAR(20)				NOT NULL				
	CHECK (UPPER(user_type) IN ('EMPLOYEE', 'STUDENT')) /*Typ av användare*/*/

INSERT INTO Users (first_name, last_name, date_of_birth, email, phone_number, [address], registration_date, user_type)
	VALUES
		('Anna', 'Larsson', '1985-03-12', 'anna.larsson@email.com', '0701234562', 'Gatan 1, Stockholm', '2023-01-01', 'Employee'),
		('Anna', 'Andersson', '1990-05-18', 'anna.andersson@email.com', '0709876543', 'Vägen 2, Göteborg', '2023-02-01', 'Employee'),
		('Oscar', 'Svensson', '1988-09-22', 'oscar.svensson@email.com', '0705551234', 'Backen 3, Malmö', '2023-03-01', 'Employee'),
		('Emelie', 'Johansson', '1993-11-08', 'emelie.johansson@email.com', '0703334444', 'Höjden 4, Uppsala', '2023-04-01', 'Employee'),
		('Gustav', 'Nilsson', '1982-07-14', 'gustav.nilsson@email.com', '0702221111', 'Strand 5, Linköping', '2023-05-01', 'Employee'),
		('Sofia', 'Berg', '1998-02-20', 'sofia.berg@email.com', '0706667777', 'Skog 6, Örebro', '2023-06-01', 'Student'),
		('Henrik', 'Persson', '1987-12-05', 'henrik.persson@email.com', '0709998888', 'Berg 7, Västerås', '2023-07-01', 'Student'),
		('Amanda', 'Holm', '1995-04-30', 'amanda.holm@email.com', '0701112222', 'Äng 8, Jönköping', '2023-08-01', 'Student'),
		('Karl', 'Eriksson', '1980-10-17', 'karl.eriksson@email.com', '0704445555', 'Sjö 9, Norrköping', '2023-09-01', 'Student'),
		('Maja', 'Lindqvist', '1991-06-25', 'maja.lindqvist@email.com', '0707776666', 'Villevägen 4, Linköping', '2023-02-03', 'Student'),
		('Erik', 'Bergström', '1981-08-09', 'erik.bergström@email.com', '0708887777', 'Torget 10, Helsingborg', '2023-10-01', 'Employee'),
		('Olivia', 'Olsson', '1996-06-15', 'olivia.olsson@email.com', '0702226666', 'Parken 11, Umeå', '2023-11-01', 'Employee'),
		('Max', 'Karlsson', '1984-04-21', 'max.karlsson@email.com', '0705557777', 'Gatan 12, Gävle', '2023-12-01', 'Employee'),
		('Isabella', 'Nilsson', '1999-02-25', 'isabella.nilsson@email.com', '0708886666', 'Vägen 13, Kalmar', '2024-01-01', 'Employee');

/*	shelf_id			INT	IDENTITY			PRIMARY KEY,
	row_count			INT						NOT NULL,
	[location]			VARCHAR(30)				NOT NULL*/

INSERT INTO Shelves (row_count,[location])
	VALUES
		(20, 'Utställningssal A'),
		(20, 'Arkivrum B'),
		(30, 'Föremålsgalleri'),
		(10, 'Historiska utställningen'),
		(10, 'Teknikavdelningen');

/* 	book_id				INT IDENTITY			PRIMARY KEY,
	shelf_id			INT						NOT NULL,
	FOREIGN KEY(shelf_id) 
	REFERENCES Shelves(shelf_id),
	[row]				INT						NOT NULL,
	title				VARCHAR(255)			NOT NULL,
	author				VARCHAR(255)			NOT NULL*/

INSERT INTO Books (shelf_id, row, title, author)
	VALUES
		(1, 1, 'The Great Gatsby', 'F. Scott Fitzgerald'),
		(2, 2, 'To Kill a Mockingbird', 'Harper Lee'),
		(3, 3, '1984', 'George Orwell'),
		(4, 1, 'Pride and Prejudice', 'Jane Austen'),
		(5, 2, 'The Catcher in the Rye', 'J.D. Salinger'),
		(1, 3, 'One Hundred Years of Solitude', 'Gabriel García Márquez'),
		(2, 1, 'The Lord of the Rings', 'J.R.R. Tolkien');

/* 	dig_id				INT IDENTITY			PRIMARY KEY,
	user_id				INT						NOT NULL,
	FOREIGN KEY(user_id) 
	REFERENCES Users(user_id) 
	ON DELETE CASCADE,
	grid				INT						NOT NULL,
	depth				INT						NOT NULL,
	[location]			VARCHAR(255)			NOT NULL */

INSERT INTO Digs (user_id, grid, depth, [location])
	VALUES
		(1, 101, 5, 'Ancient Ruins of Pompeii'),
		(2, 202, 8, 'Valley of the Kings'),
		(3, 303, 7, 'Machu Picchu'),
		(4, 404, 10, 'Troy Archaeological Site'),
		(5, 505, 6, 'Petra, Jordan'),
		(6, 606, 9, 'Great Barrier Reef');

/*	artifact_id			INT IDENTITY			PRIMARY KEY,
	dig_id				INT,
	FOREIGN KEY(dig_id) 
	REFERENCES Digs(dig_id) 
	ON DELETE CASCADE,
	shelf_id			INT,
	FOREIGN KEY(shelf_id) 
	REFERENCES Shelves(shelf_id)
	ON DELETE CASCADE,
	[row]				INT						NOT NULL,
	[description]		VARCHAR(255)			NOT NULL,
	[date]				DATE					NOT NULL*/

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

/*	topic_name			VARCHAR(255)			PRIMARY KEY*/

INSERT INTO Topics (topic_name)
	VALUES
		('Middle East'),
		('Ancient Greece'),
		('Ancient Civilizations'),
		('Oceania'),
		('South America'),
		('Archaeological Technique'),
		('Underwater Archaeology'),
		('Prehistoric Art');

/* 	slide_id			INT IDENTITY			PRIMARY KEY,
	shelf_id			INT,
	FOREIGN KEY (shelf_id)
	REFERENCES Shelves(shelf_id),
	dig_id				INT,
	FOREIGN KEY(dig_id) 
	REFERENCES Digs(dig_id) 
	ON DELETE SET NULL,
	topic_name			VARCHAR(255),
	FOREIGN KEY (topic_name)
	REFERENCES Topics (topic_name),
	[row]				INT						NOT NULL*/

INSERT INTO Slides (shelf_id, dig_id, topic_name, row)
	VALUES
		(1, 1, 'Middle East', 1),
		(2, 2, 'South America', 3),
		(3, 3, 'Ancient Civilizations', 4),
		(4, 4, 'Archaeological Technique', 2),
		(5, 5, 'Underwater Archaeology', 4),
		(1, 6, 'Prehistoric Art', 4),
		(1, 1, 'Middle East', 1),
		(2, 2, 'South America', 3),
		(3, 3, 'Ancient Civilizations', 4),
		(4, 4, 'Archaeological Technique', 2),
		(5, 5, 'Underwater Archaeology', 4),
		(1, 6, 'Prehistoric Art', 4),
		(1, 1, 'Middle East', 1),
		(2, 2, 'South America', 3),
		(3, 3, 'Ancient Civilizations', 4),
		(4, 4, 'Archaeological Technique', 2),
		(5, 5, 'Underwater Archaeology', 4),
		(1, 6, 'Prehistoric Art', 4);

/*	journal_id			INT IDENTITY			PRIMARY KEY,
	shelf_id			INT						NOT NULL,
	FOREIGN KEY(shelf_id) 
	REFERENCES Shelves(shelf_id),
	[row]				INT						NOT NULL,
    title				VARCHAR(255)			NOT NULL,
    published			DATE					NOT NULL,
	author				VARCHAR(255)			NOT NULL*/

INSERT INTO Journals (shelf_id, [row], title, published, author)
	VALUES
		(1, 1, 'Middle east findings', '2002-05-23', 'Jenny Jacksson'),
		(2, 2, 'Ancient Empires', '2003-09-23', 'Brad Bradlyesson'),
		(3, 3, 'Ancient Languages', '2004-01-12', 'Nicki Nish'),
		(4, 4, 'Ancient Technologies', '2005-12-03', 'Justin Justinsson'),
		(5, 5, 'Ancient Warfare', '2006-02-12', 'Orlando Bllom'),
		(4, 6, 'Ancient Trade and Economy', '2007-11-26', 'Michael Michelsson'),
		(5, 7, 'Ancient Religion and Spirituality', '2008-12-01', 'Yvette Snow');

--VIWES
-- We have created 4 different views and have numbered them. We have also explained what the use of the different views are.

-- 1. View to see which slides are currently on loan and to whom
GO
CREATE VIEW Borrowed_slides AS
SELECT
	s.slide_id,
	s.topic_name,
	s.shelf_id,
	s.[row],
    CONCAT(u.first_name, ' ', u.last_name) AS borrower_name,
    bsc.borrow_date
FROM
    BorrowedSlidesCol AS bsc
INNER JOIN
    BorrowedSlidesRow AS bsr ON bsc.order_id = bsr.order_id 
INNER JOIN
    Users AS u ON u.user_id = bsc.user_id
INNER JOIN
    Slides AS s ON s.slide_id = bsr.slide_id
INNER JOIN
	Shelves as sh ON s.shelf_id = sh.shelf_id
WHERE 
    bsc.return_date IS NULL;
GO

--2. View to see which books are currently on loan and to whom
GO
CREATE VIEW Borrowed_books AS 
SELECT
    CONCAT(u.first_name, ' ', u.last_name) AS borrower_name,
	    b.title,
		b.author,
		bbc.borrow_date
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

--3. View to overview infomation about slides
GO
CREATE VIEW Slide_Catalog AS
SELECT
	s.slide_id,
	s.topic_name,
	d.location AS dig_location,
	s.shelf_id,
	s.row,
	sh.location AS shelf_location
FROM
	Slides AS s
INNER JOIN 
	Digs AS d ON s.dig_id = d.dig_id
INNER JOIN
	Shelves AS sh ON sh.shelf_id = s.shelf_id;
GO

--4. View to overview artifacts and their loan status
GO
CREATE VIEW Artifact_Report AS 
SELECT 
    a.artifact_id,
    a.description,
    a.date AS found_date,
    d.location AS dig_location,
    a.shelf_id,
    a.row,
    s.location as shelf_location,
    CASE 
        WHEN bac.borrow_date IS NULL AND bac.return_date IS NULL THEN 'NO'
        WHEN bac.borrow_date IS NOT NULL AND bac.return_date IS NOT NULL THEN 'NO'
        ELSE 'YES' 
    END AS on_loan,
    CASE
		WHEN bac.borrow_date IS NULL AND bac.return_date IS NULL THEN 'N/A'
        WHEN bac.borrow_date IS NOT NULL AND bac.return_date IS NOT NULL THEN 'N/A'
        ELSE u.first_name + ' ' + u.last_name 
    END AS [loaned_to]
FROM 
    Artifacts AS a
INNER JOIN
    Shelves AS s ON a.shelf_id = s.shelf_id
INNER JOIN
    Digs AS d ON a.dig_id = d.dig_id
LEFT JOIN BorrowedArtifactsRow bar 
    ON a.artifact_id = bar.artifact_id 
    AND bar.order_id = (
        SELECT MAX(order_id) 
        FROM BorrowedArtifactsRow 
        WHERE artifact_id = a.artifact_id
    )
LEFT JOIN 
    BorrowedArtifactsCol AS bac ON bac.order_id = bar.order_id
LEFT JOIN
    Users AS u ON u.user_id = bac.user_id
GO

--PROCEDURES AND TRIGGERS
--We have created 6 different stored procedures to handle diffrent types of loans.
--We have also created 1 trigger. Every procedure and trigger is explained in a short comment. The trigger is used to store data about former users.

-- 1. Stored procedure to handle book borrowing
GO
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

-- 2. Stored procedure to handle returning of book 
GO
CREATE PROCEDURE ReturnBook
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

-- 3. Stored procedure to handle borrowing of artifact
GO
CREATE PROCEDURE BorrowArtifact
    @user_id INT,
    @artifact_id INT
AS
BEGIN
    DECLARE @order_id INT;

    -- Check if the artifact is available
    IF EXISTS (
        SELECT
            a.artifact_id
        FROM
            Artifacts a
            INNER JOIN BorrowedArtifactsRow bar ON a.artifact_id = bar.artifact_id
            INNER JOIN BorrowedArtifactsCol bac ON bar.order_id = bac.order_id
        WHERE
            bac.return_date IS NULL
            AND a.artifact_id = @artifact_id
    )
    BEGIN
        -- Artifact is not available
        RAISERROR('Oh no! The artifact is not available for borrowing.', 16, 1);
        RETURN;
    END;

    -- Insert into BorrowedArtifactsCol
    INSERT INTO BorrowedArtifactsCol (user_id, borrow_date, return_date)
		VALUES (@user_id, GETDATE(), NULL);

    -- Get the order_id of the inserted BorrowedArtifactsCol record
    SET @order_id = SCOPE_IDENTITY();

    -- Insert into BorrowedArtifactsRow
    INSERT INTO BorrowedArtifactsRow (order_id, artifact_id)
		VALUES (@order_id, @artifact_id);
END;
GO

-- 4. Stored procedure to handle return of artifact
GO
CREATE PROCEDURE returnArtifact
    @user_id INT,
    @artifact_id INT
AS
BEGIN
    DECLARE @order_id INT;

    -- Check if the artifact is currently borrowed by the specified user
    IF NOT EXISTS (
        SELECT 1
        FROM BorrowedArtifactsCol bac
        INNER JOIN BorrowedArtifactsRow bar ON bac.order_id = bar.order_id
        WHERE bac.user_id = @user_id
          AND bar.artifact_id = @artifact_id
          AND bac.return_date IS NULL
    )
    BEGIN
        -- Artifact is not currently borrowed by the specified user
        RAISERROR('Oh no! The artifact is not currently borrowed by the specified user.', 16, 1);
        RETURN;
    END;

    -- Get the order_id of the borrowed artifact
    SELECT @order_id = bac.order_id
    FROM BorrowedArtifactsCol bac
    INNER JOIN BorrowedArtifactsRow bar ON bac.order_id = bar.order_id
    WHERE bac.user_id = @user_id
      AND bar.artifact_id = @artifact_id
      AND bac.return_date IS NULL;

    -- Update BorrowedArtifactsCol to mark the artifact as returned
    UPDATE BorrowedArtifactsCol
    SET return_date = GETDATE()
    WHERE order_id = @order_id;

    -- Optionally, perform additional actions or logging as needed

    -- Print a success message
    PRINT 'Artifact returned successfully.';
END;
GO

-- 5. Stored procedure to handle borrowing of slide
GO
CREATE PROCEDURE BorrowSlide
    @user_id INT,
    @slide_id INT
AS
BEGIN
    DECLARE @order_id INT;

    -- Check if the slide is available
    IF EXISTS (
        SELECT
            s.slide_id
        FROM
            Slides s
            INNER JOIN BorrowedSlidesRow bsr ON s.slide_id = bsr.slide_id
            INNER JOIN BorrowedSlidesCol bsc ON bsr.order_id = bsc.order_id
        WHERE
            bsc.return_date IS NULL
            AND s.slide_id = @slide_id
    )
    BEGIN
        -- Slide is not available
        RAISERROR('Oh no! The slide is not available for borrowing.', 16, 1);
        RETURN;
    END;

    -- Insert into BorrowedSlidesCol
    INSERT INTO BorrowedSlidesCol (user_id, borrow_date, return_date)
		VALUES (@user_id, GETDATE(), NULL);

    -- Get the order_id of the inserted BorrowedSlidesCol record
    SET @order_id = SCOPE_IDENTITY();

    -- Insert into BorrowedSlidesRow
    INSERT INTO BorrowedSlidesRow (order_id, slide_id)
		VALUES (@order_id, @slide_id);
END;
GO

--6. Stored procedure to handle return of slide
GO
CREATE PROCEDURE ReturnSlide
    @user_id INT,
    @slide_id INT
AS
BEGIN
    DECLARE @order_id INT;

    -- Check if the slide is currently borrowed by the specified user
    IF NOT EXISTS (
        SELECT 1
        FROM BorrowedSlidesCol bsc
        INNER JOIN BorrowedSlidesRow bsr ON bsc.order_id = bsr.order_id
        WHERE bsc.user_id = @user_id
          AND bsr.slide_id = @slide_id
          AND bsc.return_date IS NULL
    )
    BEGIN
        -- Slide is not currently borrowed by the specified user
        RAISERROR('Oh no! The slide is not currently borrowed by the specified user.', 16, 1);
        RETURN;
    END;

    -- Get the order_id of the borrowed slide
    SELECT @order_id = bsc.order_id
    FROM BorrowedSlidesCol bsc
    INNER JOIN BorrowedSlidesRow bsr ON bsc.order_id = bsr.order_id
    WHERE bsc.user_id = @user_id
      AND bsr.slide_id = @slide_id
      AND bsc.return_date IS NULL;

    -- Update BorrowedSlidesCol to mark the slide as returned
    UPDATE BorrowedSlidesCol
    SET return_date = GETDATE()
    WHERE order_id = @order_id;

    -- Optionally, perform additional actions or logging as needed

    -- Print a success message
    PRINT 'Slide returned successfully.';
END;
GO

-- 7. (The only trigger the ones above are procedures)Trigger that activates when an user is deleted. Saves the user in former_user table
GO
CREATE TRIGGER [staff_cleaner]
	ON [users]
	AFTER DELETE
	AS BEGIN
	INSERT INTO [Former_users] (user_id, first_name, last_name, date_of_birth, email, phone_number, address, registration_date, resigned_date, user_type)
	SELECT D.user_id, D.first_name, D.last_name, D.date_of_birth, D.email, D.phone_number , D.address, D.registration_date, GETDATE(), D.user_type
	FROM deleted AS D
	END;
GO
