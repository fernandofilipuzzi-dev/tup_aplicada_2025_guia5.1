

-- Ejercicio 2 - Table per Type (TPT)


-- a- Crear la base para el ejercicio 2

USE master;

GO

DROP DATABASE IF EXISTS GUIA5_1_Ejercicio2_DB;

GO

CREATE DATABASE GUIA5_1_Ejercicio2_DB

GO

USE GUIA5_1_Ejercicio2_DB;

GO

-- b- Crear las tablas

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

-- c- Procedimientos para insertar figuras (Rectangulo y circulo)

CREATE PROCEDURE sp_InsertarRectangulo
(
	@Ancho DECIMAL(18,2),
	@Largo DECIMAL(18,2)
)
AS
BEGIN

	BEGIN TRANSACTION;

	BEGIN TRY;

		INSERT INTO Figuras(Area) 
		VALUES (0);
	
		DECLARE @Id_Figura INT = SCOPE_IDENTITY();
	
		INSERT INTO Rectangulos(Id, Ancho, Largo)
		VALUES (@Id_Figura, @Ancho, @Largo);

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH;
		ROLLBACK TRANSACTION;
	END CATCH;

END

GO

CREATE PROCEDURE sp_InsertarCirculo
(
	@Radio DECIMAL(18,2)
)
AS
BEGIN

	BEGIN TRANSACTION;

	BEGIN TRY;

	INSERT INTO Figuras(Area) 
	VALUES (0);

	DECLARE @Id_Figura INT = SCOPE_IDENTITY();

	INSERT INTO Circulos(Id, Radio)
	VALUES (@Id_Figura, @Radio);
	
	COMMIT TRANSACTION;
	
	END TRY
	BEGIN CATCH;
		ROLLBACK TRANSACTION;
	END CATCH;

END

GO

-- d- Insertar figuras como ejemplo y consulta de las Figuras

EXEC sp_InsertarRectangulo @Ancho=1, @Largo=1;
EXEC sp_InsertarRectangulo @Ancho=1, @Largo=2;
EXEC sp_InsertarCirculo @Radio=1;
EXEC sp_InsertarRectangulo @Ancho=2.2, @Largo=1;
EXEC sp_InsertarCirculo @Radio=2.1;

SELECT f.Id,
	   CASE WHEN r.Id IS NOT NULL THEN 'Rectangulo'
			WHEN c.Id IS NOT NULL THEN 'Circulo'
	   ELSE 'Desconocido' END AS Tipo,
	   f.Area,
	   r.Ancho,
	   r.Largo,
	   c.Radio
FROM Figuras f
LEFT JOIN Rectangulos r ON r.Id = f.Id
LEFT JOIN Circulos c ON c.Id = f.Id

GO

-- e- Crear procedimiento para calcular el área de una figura por Id

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

-- f- Calcular el area de todas las figuras (Cursor)

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

-- g- Consultar todas las figuras con sus áreas calculadas

SELECT f.Id,
	   CASE WHEN r.Id IS NOT NULL THEN 'Rectangulo'
			WHEN c.Id IS NOT NULL THEN 'Circulo'
	   ELSE 'Desconocido' END AS Tipo,
	   f.Area,
	   r.Ancho,
	   r.Largo,
	   c.Radio
FROM Figuras f
LEFT JOIN Rectangulos r ON r.Id = f.Id
LEFT JOIN Circulos c ON c.Id = f.Id;

USE master

