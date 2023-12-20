--VYER--

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

SELECT * FROM Borrowed_slides ORDER BY topic_name;

--Vy för att se vilka böcker som är utlånade just nu och till vem
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
	/*GO
		SELECT COUNT(*) AS borrowed_books_count FROM Borrowed_books;
	GO*/
GO
--SELECT * FROM Borrowed_books;

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

--SELECT * FROM Shelves_with_books;

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

--SELECT * FROM User_Borrowing_Summary

GO
CREATE VIEW Slide_Catalog AS
SELECT
	s.slide_id,
	s.topic_name,
	d.location as dig_location,
	s.shelf_id,
	s.row
FROM
	Slides AS s
INNER JOIN 
	Digs AS d ON s.dig_id = d.dig_id;
GO


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

SELECT * FROM BorrowedArtifactsCol;
SELECT * FROM BorrowedArtifactsRow;

SELECT * FROM Artifact_Report;

--FRÅGOR--
SELECT * FROM Users WHERE user_type = 'Employee' ORDER BY first_name,last_name;

SELECT * FROM Slide_Catalog ORDER BY topic_name;

/*SELECT COUNT (Slide_id) AS slide_count, topic_name
FROM Slides
GROUP BY topic_name
ORDER BY COUNT(slide_id) DESC;*/
