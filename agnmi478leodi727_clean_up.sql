--Deleting data from all the tables

DELETE FROM BorrowedJournalsCol;
DELETE FROM BorrowedJournalsRow;
DELETE FROM Journals;
DELETE FROM BorrowedSlidesCol;
DELETE FROM BorrowedSlidesRow;
DELETE FROM Slides;
DELETE FROM Topics;
DELETE FROM BorrowedArtifactsCol;
DELETE FROM BorrowedArtifactsRow;
DELETE FROM Artifacts;
DELETE FROM Digs;
DELETE FROM BorrowedBooksCol;
DELETE FROM BorrowedBooksRow;
DELETE FROM Books;
DELETE FROM Shelves;
DELETE FROM Former_users;
DELETE FROM Users;

--Dropping the tables from the DB

DROP TABLE BorrowedJournalsRow;
DROP TABLE BorrowedJournalsCol;
DROP TABLE Journals;
DROP TABLE BorrowedSlidesRow;
DROP TABLE BorrowedSlidesCol;
DROP TABLE Slides;
DROP TABLE Topics;
DROP TABLE BorrowedArtifactsRow;
DROP TABLE BorrowedArtifactsCol;
DROP TABLE Artifacts;
DROP TABLE Digs;
DROP TABLE BorrowedBooksRow;
DROP TABLE BorrowedBooksCol;
DROP TABLE Books;
DROP TABLE Shelves;
DROP TABLE Former_users;
DROP TABLE Users;
