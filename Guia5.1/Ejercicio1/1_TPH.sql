

-- Ejercicio 1 - Table Per Hierarchy (TPH)


-- a- Crear la base para el ejercicio 1

USE master;

GO

DROP DATABASE IF EXISTS GUIA5_1_Ejercicio1_DB;

GO

CREATE DATABASE GUIA5_1_Ejercicio1_DB

GO

USE GUIA5_1_Ejercicio1_DB;

GO

-- b- Crear las tablas

CREATE TABLE Figuras(
	Id INT PRIMARY KEY IDENTITY(1,1),	
	Tipo INT NOT NULL,
	Area DECIMAL(18, 2),
	Ancho DECIMAL(18,2), 
	Largo DECIMAL(18,2),
	Radio DECIMAL(18,2)
);

GO

-- c- Insertar figuras como ejemplo

INSERT INTO Figuras(Tipo, Ancho, Largo, Radio) 
VALUES
(1, 1,    1,    NULL),
(1, 1,    2,    NULL),
(2, NULL, NULL, 1),
(1, 2.2,    1,    NULL),
(2, NULL, NULL, 2.1)

GO

-- d- Crear procedimiento para calcular el área de una figura por Id

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

-- e- Calcular el area de un rectangulo y un circulo previamente insertados

EXEC CalcularArea 1

EXEC CalcularArea 3

SELECT f.Id,
	   CASE WHEN f.Tipo=1 THEN 'Rectangulo'
			WHEN f.Tipo=2 THEN 'Circulo'
	   ELSE 'Desconocido' END AS Tipo,
	   f.Area,
	   f.Ancho,
	   f.Largo,
	   f.Radio
FROM Figuras f
WHERE f.Id IN (1, 3);

GO

-- f- Calcular el area de todas las figuras (Cursor)


DECLARE Figura_CURSOR CURSOR FOR SELECT f.Id FROM Figuras f;

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

-- g- Consultar todas las figuras con sus áreas calculadas

SELECT f.Id,
	   CASE WHEN f.Tipo=1 THEN 'Rectangulo'
			WHEN f.Tipo=2 THEN 'Circulo'
	   ELSE 'Desconocido' END AS Tipo,
	   f.Area,
	   f.Ancho,
	   f.Largo,
	   f.Radio
FROM Figuras f;

USE master

