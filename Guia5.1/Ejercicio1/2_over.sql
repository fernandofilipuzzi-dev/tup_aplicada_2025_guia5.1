


USE master;


DECLARE @Ventas TABLE
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	Ciudad VARCHAR(100),
	Ventas NUMERIC(18,2)
);


INSERT INTO @Ventas (Ciudad, Ventas) 
VALUES
('Paraná', 10.00),
('Hasenkamp', 30.00),
('Paraná', 10.00),
('Hernandarias', 5.0),
('Paraná', 10.00),
('Paraná', 15.00);

--select * from @Ventas;

SELECT ROW_NUMBER() OVER (PARTITION BY v.Ciudad ORDER BY v.Ciudad ) Numero, v.Ciudad, v.Ventas
FROM @Ventas v

