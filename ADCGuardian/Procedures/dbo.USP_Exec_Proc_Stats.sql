USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE  PROC [dbo].[USP_Exec_Proc_Stats]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

merge dbo.TB_Used_Objects as t
using (
	select db_name(database_id) as DBName
		, 'P' as ObjType
		, object_schema_name(object_id, database_id) as SchemaName
		, object_name(object_id, database_id) as ObjName
		, max(last_execution_time) as last_execution_time
	from sys.dm_exec_procedure_stats
	where type = 'P'
		and database_id in (select DBID from TB_Unused_Objects_Check_Databases)
	group by database_id, object_id
) as s
on (s.DBName = t.DBName and s.ObjType = t.ObjType and s.SchemaName = t.SchemaName and s.ObjName = t.ObjName)
when matched and t.LastCaptureDate <> s.last_execution_time then
	update set LastCaptureDate = last_execution_time, CaptureCount = t.CaptureCount + 1
when not matched then
	insert (DBName, ObjType, SchemaName, ObjName, FirstCaptureDate, LastCaptureDate, CaptureCount)
	values (s.DBName, s.ObjType, s.SchemaName, s.ObjName, last_execution_time, last_execution_time, 1);
GO
