USE [ADCGuardian_20220617]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROC [dbo].[USP_Set_Unused_Tables_Procedures_ScalarFunctions]
	@currdate datetime
	, @unused_check_days int
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

declare @sql nvarchar(4000)

set @sql = 'use [?];
if db_name() in (select DBName from ADCGuardian.dbo.TB_Unused_Objects_Check_Databases)
begin
	insert into ADCGuardian.dbo.TB_Unused_Objects (InsDate, DBName, ObjType, SchemaName, ObjName)
	select ''' + convert(nvarchar(30), @currdate, 121) + ''' as InsDate, p.DBName, p.ObjType, p.SchemaName, p.ObjName
	from (
		select db_name() collate Korean_Wansung_CI_AS as DBName
			, ''U'' as ObjType
			, schema_name(schema_id) collate Korean_Wansung_CI_AS as SchemaName
			, name collate Korean_Wansung_CI_AS as ObjName
		from sys.tables
		where is_ms_shipped = 0
	) as p
	left outer join ADCGuardian.dbo.TB_Used_Objects uo 
		on uo.DBName = p.DBName and uo.ObjType = p.ObjType and uo.SchemaName = p.SchemaName and uo.ObjName = p.ObjName and uo.LastCaptureDate >= dateadd(day, ' + cast(@unused_check_days as nvarchar(5)) + ' * -1, ''' + convert(nvarchar(30), @currdate, 121) + ''')
	where uo.ObjName is null
end'

exec sp_MSforeachdb @sql

set @sql = 'use [?];
if db_name() in (select DBName from ADCGuardian.dbo.TB_Unused_Objects_Check_Databases)
begin
	insert into ADCGuardian.dbo.TB_Unused_Objects (InsDate, DBName, ObjType, SchemaName, ObjName)
	select ''' + convert(nvarchar(30), @currdate, 121) + ''' as InsDate, p.DBName, p.ObjType, p.SchemaName, p.ObjName
	from (
		select db_name() collate Korean_Wansung_CI_AS as DBName
			, ''P'' as ObjType
			, schema_name(schema_id) collate Korean_Wansung_CI_AS as SchemaName
			, name collate Korean_Wansung_CI_AS as ObjName
		from sys.procedures
		where is_ms_shipped = 0
	) as p
	left outer join ADCGuardian.dbo.TB_Used_Objects uo 
		on uo.DBName = p.DBName and uo.ObjType = p.ObjType and uo.SchemaName = p.SchemaName and uo.ObjName = p.ObjName and uo.LastCaptureDate >= dateadd(day, ' + cast(@unused_check_days as nvarchar(5)) + ' * -1, ''' + convert(nvarchar(30), @currdate, 121) + ''')
	where uo.ObjName is null
end'

exec sp_MSforeachdb @sql

set @sql = 'use [?];
if db_name() in (select DBName from ADCGuardian.dbo.TB_Unused_Objects_Check_Databases)
begin
	insert into ADCGuardian.dbo.TB_Unused_Objects (InsDate, DBName, ObjType, SchemaName, ObjName)
	select ''' + convert(nvarchar(30), @currdate, 121) + ''' as InsDate, p.DBName, p.ObjType, p.SchemaName, p.ObjName
	from (
		select db_name() collate Korean_Wansung_CI_AS as DBName
			, ''FN'' as ObjType
			, schema_name(schema_id) collate Korean_Wansung_CI_AS as SchemaName
			, name collate Korean_Wansung_CI_AS as ObjName
		from sys.objects
		where is_ms_shipped = 0
			and type = ''FN''
	) as p
	left outer join ADCGuardian.dbo.TB_Used_Objects uo 
		on uo.DBName = p.DBName and uo.ObjType = p.ObjType and uo.SchemaName = p.SchemaName and uo.ObjName = p.ObjName and uo.LastCaptureDate >= dateadd(day, ' + cast(@unused_check_days as nvarchar(5)) + ' * -1, ''' + convert(nvarchar(30), @currdate, 121) + ''')
	where uo.ObjName is null
end'

exec sp_MSforeachdb @sql
GO
