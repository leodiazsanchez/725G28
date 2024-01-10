-- Example of borrowing and returnuing books

EXEC BorrowBook
    @user_id = 1,
    @book_id = 5;

EXEC BorrowBook
    @user_id = 2,
    @book_id = 2;

EXEC ReturnBook
    @user_id = 2,
    @book_id = 2;

EXEC BorrowBook
    @user_id = 1,
    @book_id = 7;

EXEC BorrowBook
    @user_id = 6,
    @book_id = 3;

EXEC BorrowBook
    @user_id = 4,
    @book_id = 6;

EXEC BorrowBook
    @user_id = 3,
    @book_id = 4;

-- Example of borrowing and returnuing slides

EXEC BorrowSlide
	@user_id = 6,
	@slide_id = 4;

EXEC ReturnSlide
	@user_id = 6,
	@slide_id = 4;

EXEC BorrowSlide
	@user_id = 4,
	@slide_id = 4;

EXEC BorrowSlide
	@user_id = 1,
	@slide_id = 5;

EXEC BorrowSlide
	@user_id = 9,
	@slide_id = 3;

EXEC BorrowSlide
	@user_id = 9,
	@slide_id = 1;

EXEC BorrowSlide
	@user_id = 2,
	@slide_id = 12;

-- Example of borrowing and returnuing artifacts

EXEC BorrowArtifact
    @user_id = 2,
    @artifact_id = 2;

EXEC ReturnArtifact
    @user_id = 2,
    @artifact_id = 2;

EXEC BorrowArtifact
    @user_id = 4,
    @artifact_id = 2;

EXEC ReturnArtifact
	@user_id = 4,
	@artifact_id = 2;


EXEC BorrowArtifact
    @user_id = 1,
    @artifact_id = 1;


EXEC BorrowArtifact
    @user_id = 2,
    @artifact_id = 3;


EXEC BorrowArtifact
    @user_id = 3,
    @artifact_id = 4;

	
EXEC BorrowArtifact
    @user_id = 4,
    @artifact_id = 5;


EXEC BorrowArtifact
    @user_id = 2,
    @artifact_id = 7;

--Using views
SELECT * FROM Borrowed_books 
ORDER BY 
	borrower_name;

SELECT * FROM Artifact_Report 
ORDER BY
	dig_location;

SELECT * FROM Slide_Catalog  
WHERE 
	shelf_location = 'Utställningssal A'
ORDER BY 
	topic_name;

SELECT * FROM Borrowed_slides 
ORDER BY 
	topic_name;

--Simple queries--

--Query to retrive employees from the users table
SELECT * FROM Users	
WHERE 
	user_type = 'Employee' 
ORDER BY 
	first_name,last_name;

-- Complex queries

-- Query to retrieve the books borrowed within a specified date range
SELECT 
	B.title, BBC.borrow_date, BBC.return_date
FROM 
	Books B
INNER JOIN 
	BorrowedBooksRow BBR ON B.book_id = BBR.book_id
INNER JOIN 
	BorrowedBooksCol BBC ON BBR.order_id = BBC.order_id
WHERE 
	BBC.borrow_date BETWEEN '2023-01-01' AND '2024-12-31'
ORDER BY
	BBC.borrow_date DESC;

-- Query to show how many artifacts each user has borrowed
SELECT 
	U.user_id, CONCAT(u.first_name, ' ', u.last_name) AS name, COUNT(BA.artifact_id) AS total_borrowed
FROM 
	BorrowedArtifactsRow BA
INNER JOIN 
	BorrowedArtifactsCol BAC ON BA.order_id = BAC.order_id
INNER JOIN 
	Users U ON BAC.user_id = U.user_id
GROUP BY 
	U.user_id, CONCAT(u.first_name, ' ', u.last_name)
ORDER BY 
	total_borrowed DESC;

--Query to filter out the users that borrowed a ceratin number of books
SELECT
    Users.user_id,
    Users.first_name,
    Users.last_name,
    COUNT(BorrowedBooksCol.order_id) AS num_borrowed_books
FROM
    Users
LEFT JOIN 
	BorrowedBooksCol ON Users.user_id = BorrowedBooksCol.user_id
GROUP BY
    Users.user_id, Users.first_name, Users.last_name
HAVING
    COUNT(BorrowedBooksCol.order_id) > 1; -- desired threshold

-- Delete and verifying that trigger works as intended
DELETE FROM Users 
WHERE user_id = 1;

SELECT * FROM Users;
SELECT * FROM Former_users;
