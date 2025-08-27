

-- Ejercicio 2 - Table per Type (TPT)

USE master;

GO

DROP DATABASE IF EXISTS GUIA5_1_Ejercicio2_DB;

GO

CREATE DATABASE GUIA5_1_Ejercicio2_DB

GO

USE GUIA5_1_Ejercicio2_DB;

GO

CREATE TABLE Figuras(
	Id INT IDENTITY(1,1),	
	Area DECIMAL(18, 2) DEFAULT 0,
	CONSTRAINT PK_Figuras PRIMARY KEY (Id)
);

CREATE TABLE Rectangulos(
	Id INT,
	Ancho DECIMAL(18,2) NOT NULL, 
	Largo DECIMAL(18,2) NOT NULL,
	CONSTRAINT PK_Rectangulos PRIMARY KEY (Id),
	CONSTRAINT FK_Rectangulos_Figuras FOREIGN KEY (Id) REFERENCES Figuras(Id)
);

CREATE TABLE Circulos(
	Id INT,
	Radio DECIMAL(18,2) NOT NULL
	CONSTRAINT PK_Circulos PRIMARY KEY (Id),
	CONSTRAINT FK_Circulos_Figuras FOREIGN KEY (Id) REFERENCES Figuras(Id)
);

GO

-- Insertar un circulo

CREATE PROCEDURE sp_InsertarRectangulo
(
	@Ancho DECIMAL(18,2),
	@Largo DECIMAL(18,2)
)
AS
BEGIN
	INSERT INTO Figuras(Area) 
	VALUES (0);
	DECLARE @Id_Figura INT = SCOPE_IDENTITY();
	INSERT INTO Rectangulos(Id, Ancho, Largo)
	VALUES (@Id_Figura, @Ancho, @Largo);
END

GO


CREATE PROCEDURE sp_InsertarCirculo
(
	@Radio DECIMAL(18,2)
)
AS
BEGIN
	INSERT INTO Figuras(Area) 
	VALUES (0);
	DECLARE @Id_Figura INT = SCOPE_IDENTITY();
	INSERT INTO Circulos(Id, Radio)
	VALUES (@Id_Figura, @Radio);
END

GO

EXEC sp_InsertarRectangulo 1, 1
EXEC sp_InsertarRectangulo 1, 2
EXEC sp_InsertarCirculo 1
EXEC sp_InsertarRectangulo 2.2, 1
EXEC sp_InsertarCirculo 2.1

GO

SELECT * 
FROM Figuras f
LEFT JOIN Rectangulos r ON r.Id = f.Id
LEFT JOIN Circulos c ON c.Id = f.Id
WHERE f.Id IN (1, 2)

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
				WHEN EXISTS (SELECT 1 FROM Rectangulos R WHERE R.Id = @Id)
					THEN (SELECT Ancho*Largo FROM Rectangulos R WHERE R.Id = @Id)
				WHEN EXISTS (SELECT 1 FROM Circulos C WHERE C.Id = @Id)
					THEN (SELECT 3.14*power(Radio, 2) FROM Circulos C WHERE C.Id = @Id)
				ELSE 0
				END		
	WHERE Id=@Id

	-- cual sería la alternativa sencilla?	
END

GO


DECLARE Figura_CURSOR CURSOR FOR SELECT f.Id FROM Figuras f;

DECLARE @Id INT;

OPEN Figura_CURSOR;

FETCH NEXT FROM Figura_CURSOR INTO @Id;

WHILE @@FETCH_STATUS = 0
BEGIN
	EXEC CalcularArea @Id;	
	FETCH NEXT FROM Figura_CURSOR INTO @Id;
END

CLOSE Figura_CURSOR;

DEALLOCATE Figura_CURSOR;

GO

SELECT * 
FROM Figuras f
LEFT JOIN Rectangulos r ON r.Id = f.Id
LEFT JOIN Circulos c ON c.Id = f.Id

USE master

