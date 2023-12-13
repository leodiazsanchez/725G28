--VYER--

--Vy för att se vilka böcker som är utlånade just nu och till vem
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

--- Vy för att se en hyllas innehåll
GO
CREATE VIEW Shelves_with_books AS
SELECT
    s.shelf_id AS shelf,
    s.location,
    b.title AS book_title,
    b.author AS book_author
FROM
    Shelves AS s
LEFT JOIN
    Books AS b ON s.shelf_id = b.shelf_id;
GO

SELECT * FROM Shelves_with_books;

GO
CREATE VIEW User_Borrowing_Summary AS
SELECT
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS full_name,
    COUNT(DISTINCT bbc.order_id) AS total_borrowed_items,
    COUNT(DISTINCT CASE WHEN bbc.return_date IS NULL THEN bbc.order_id END) AS currently_borrowed_items,
    MAX(COALESCE(bbc.return_date, '1900-01-01')) AS last_return_date
FROM
    Users AS u
LEFT JOIN
    BorrowedBooksCol AS bbc ON u.user_id = bbc.user_id
LEFT JOIN
    BorrowedBooksRow AS bbr ON bbc.order_id = bbr.order_id
LEFT JOIN
    BorrowedArtifactsCol AS bac ON u.user_id = bac.user_id
LEFT JOIN
    BorrowedArtifactsRow AS bar ON bac.order_id = bar.order_id
WHERE
    bbc.return_date IS NOT NULL OR bac.return_date IS NOT NULL
GROUP BY
    u.user_id, u.first_name, u.last_name;
GO

SELECT * FROM User_Borrowing_Summary

--FRÅGOR--
SELECT COUNT (Slide_id) AS slide_count, topic_name
FROM Slides
GROUP BY topic_name
ORDER BY COUNT(slide_id) DESC;
