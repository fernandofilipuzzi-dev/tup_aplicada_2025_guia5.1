
-- Ejemplo de un vista, es un escenario interesante para probar el concepto


USE GUIA5_1_Ejercicio3_DB;

GO


CREATE VIEW vw_Figuras
AS	

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

USE master

