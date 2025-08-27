
-- Ejercicio 3 - Table per Concrete Class (TPC)

USE master;

GO

DROP DATABASE IF EXISTS GUIA5_1_Ejercicio3_DB;

GO

CREATE DATABASE GUIA5_1_Ejercicio3_DB

GO

USE GUIA5_1_Ejercicio3_DB;

GO

CREATE TABLE Rectangulos(
	Id INT PRIMARY KEY IDENTITY(1,1),	
	Area DECIMAL(18, 2),
	Ancho DECIMAL(18,2), 
	Largo DECIMAL(18,2),
	Radio DECIMAL(18,2)
);

CREATE TABLE Circulos(
	Id INT PRIMARY KEY IDENTITY(1,1),	
	Area DECIMAL(18, 2),
	Ancho DECIMAL(18,2), 
	Largo DECIMAL(18,2),
	Radio DECIMAL(18,2)
);

GO

INSERT INTO Figuras(Tipo, Ancho, Largo, Radio) 
VALUES
(1, 1,    1,    NULL),
(1, 1,    2,    NULL),
(2, NULL, NULL, 1),
(1, 2.2,    1,    NULL),
(2, NULL, NULL, 2.1)

GO

CREATE PROCEDURE CalcularArea
(
  @Id INT
)
AS
BEGIN
	UPDATE Figuras 
	SET
		Area = CASE 
					WHEN Tipo=1 THEN Ancho*Largo	
					WHEN Tipo=2 THEN 3.14*power( Radio, 2) 
					ELSE NULL
			   END
	WHERE Id=@Id;
END

GO

EXEC CalcularArea 1

EXEC CalcularArea 3

SELECT * 
FROM Figuras 
WHERE Id IN (1, 3)

GO

DECLARE Figura_CURSOR CURSOR FOR SELECT f.Id, f.Tipo, f.Ancho, f.Largo, f.Radio FROM Figuras f;

OPEN Figura_CURSOR;

DECLARE @Id INT;
FETCH NEXT FROM Figura_CURSOR INTO @Id;

WHILE @@FETCH_STATUS = 0 
BEGIN
	
	EXEC CalcularArea @Id;

	PRINT @Id

	FETCH NEXT FROM Figura_CURSOR INTO @Id;
END

CLOSE Figura_CURSOR;

DEALLOCATE Figura_CURSOR;

GO

SELECT * FROM Figuras;

USE master

