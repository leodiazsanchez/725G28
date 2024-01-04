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

SELECT * FROM Borrowed_slides ORDER BY topic_name;
--SELECT * FROM Borrowed_books;
--SELECT * FROM Shelves_with_books;
--SELECT * FROM User_Borrowing_Summary
SELECT * FROM BorrowedArtifactsCol;
SELECT * FROM BorrowedArtifactsRow;

SELECT * FROM Artifact_Report;


SELECT * FROM Borrowed_books;

--FRÅGOR--
SELECT * FROM Users WHERE user_type = 'Employee' ORDER BY first_name,last_name;

SELECT * FROM Slide_Catalog ORDER BY topic_name;

/*SELECT COUNT (Slide_id) AS slide_count, topic_name
FROM Slides
GROUP BY topic_name
ORDER BY COUNT(slide_id) DESC;*/

DELETE FROM Users WHERE user_id=1;

--SELECT * FROM Users;
--SELECT * FROM Former_users;
--SELECT * FROM Books;
SELECT * FROM Borrowed_books;
