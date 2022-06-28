USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE  PROC [dbo].[USP_Table_Index_Stats]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

merge dbo.TB_Used_Objects as t
using (
	select db_name(database_id) as DBName
		, 'U' as ObjType
		, object_schema_name(object_id, database_id) as SchemaName
		, object_name(object_id, database_id) as ObjName
		, max(LastAccessDate) as LastAccessDate
	from (
		select database_id, object_id, AccessCount, LastAccessType, LastAccessDate
		from (
			select database_id
				, object_id
				, ( sum(isnull(user_seeks, 0)) + sum(isnull(user_scans, 0)) + sum(isnull(user_lookups, 0)) + sum(isnull(user_updates, 0)) ) as AccessCount
				, max(isnull(last_user_seek, '1900-01-01')) as last_user_seek
				, max(isnull(last_user_scan, '1900-01-01')) as last_user_scan
				, max(isnull(last_user_lookup, '1900-01-01')) as last_user_lookup
				, max(isnull(last_user_update, '1900-01-01')) as last_user_update
			from sys.dm_db_index_usage_stats
			where database_id in (select DBID from TB_Unused_Objects_Check_Databases)
			group by database_id, object_id
		) as t
		unpivot (
			LastAccessDate for LastAccessType
			in (last_user_seek,last_user_scan,last_user_lookup, last_user_update)
		) as unpvt
	) as t2
	where AccessCount > 0
	group by database_id, object_id
) as s
on (s.DBName = t.DBName and s.ObjType = t.ObjType and s.SchemaName = t.SchemaName and s.ObjName = t.ObjName)
when matched and t.LastCaptureDate <> s.LastAccessDate then
	update set LastCaptureDate = s.LastAccessDate, CaptureCount = t.CaptureCount + 1
when not matched then
	insert (DBName, ObjType, SchemaName, ObjName, FirstCaptureDate, LastCaptureDate, CaptureCount)
	values (s.DBName, s.ObjType, s.SchemaName, s.ObjName, s.LastAccessDate, s.LastAccessDate, 1);
GO
