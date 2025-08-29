


EXEC sp_who2;
-- luego identificás los SPIDs y usás:
KILL 68;  -- ejemplo

SELECT 
    s.session_id,
    s.login_name,
    s.host_name,
    s.program_name,
    s.status,
    r.command,
    r.wait_type,
    r.wait_time,
    r.blocking_session_id
FROM sys.dm_exec_sessions s
LEFT JOIN sys.dm_exec_requests r ON s.session_id = r.session_id
WHERE s.database_id = DB_ID('GUIA5_1_Ejercicio1_DB');

use master;

go

ALTER DATABASE GUIA5_1_Ejercicio1_DB
SET SINGLE_USER
WITH ROLLBACK IMMEDIAT