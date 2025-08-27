
-- Ejercicio 3 - Table per Concrete Class (TPC)

-- a- Crear la base para el ejercicio 3


USE master;

GO

DROP DATABASE IF EXISTS GUIA5_1_Ejercicio3_DB;

GO

CREATE DATABASE GUIA5_1_Ejercicio3_DB

GO

USE GUIA5_1_Ejercicio3_DB;

GO

-- b- Crear las tablas

CREATE TABLE Rectangulos(
	Id INT IDENTITY,	
	Area DECIMAL(18, 2),
	Ancho DECIMAL(18,2) NOT NULL, 
	Largo DECIMAL(18,2) NOT NULL,
	CONSTRAINT PK_Rectangulos PRIMARY KEY (Id)
);

CREATE TABLE Circulos(
	Id INT IDENTITY,	
	Area DECIMAL(18, 2),
	Radio DECIMAL(18,2) NOT NULL,
	CONSTRAINT PK_Circulos PRIMARY KEY (Id)
);

GO


-- c- Insertar figuras como ejemplo y consulta de las Figuras

INSERT INTO Rectangulos(Ancho, Largo)
VALUES
(1,    1),
(1,    2),
(2.2,    1);

INSERT INTO Circulos(Radio)
VALUES
(1),
(2.1);


SELECT ROW_NUMBER() OVER (ORDER BY Tipo) as Numero,
	   f.Tipo,
	   f.Area,
	   f.Ancho,
	   f.Largo,
	   f.Radio
FROM (
	SELECT 'Rectangulo' AS Tipo, 
	       r.Id AS Id_Rectangulo,  r.Area, r.Ancho, r.Largo, 
	       NULL AS Id_Circulo,  NULL AS Radio
	FROM Rectangulos r
	UNION 
	SELECT 'Circulo' AS Tipo, 
	        NULL AS Id_Rectanculo,  NULL AS Area, NULL AS Ancho, NULL AS Largo,
			c.Id AS Id_Circulo, c.Radio AS Radio
	FROM Circulos c
) AS f

GO

-- d- Crear procedimiento para calcular el área de una figura por Id

CREATE PROCEDURE CalcularAreaRectangulo
(
  @Id INT
)
AS
BEGIN

	UPDATE Rectangulos SET Area=Ancho*Largo WHERE Id=@Id;
	
END

GO

CREATE PROCEDURE CalcularAreaCirculo
(
  @Id INT
)
AS
BEGIN

	UPDATE Circulos SET  Area=3.14*POWER( Radio, 2) WHERE Id=@Id;
	
END

GO

-- f- Calcular el area de todas las figuras (Cursor)

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

SELECT f.Id,
	   CASE WHEN f.Tipo=1 THEN 'Rectangulo'
			WHEN f.Tipo=2 THEN 'Circulo'
	   ELSE 'Desconocido' END AS Tipo,
	   f.Area,
	   f.Ancho,
	   f.Largo,
	   f.Radio
FROM Figuras f

USE master

