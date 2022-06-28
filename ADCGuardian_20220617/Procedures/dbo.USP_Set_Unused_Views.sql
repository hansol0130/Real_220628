USE [ADCGuardian_20220617]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROC [dbo].[USP_Set_Unused_Views]
	@currdate datetime
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

drop table if exists #view
drop table if exists #view_dependencies

create table #view (DBName nvarchar(128), SchemaName nvarchar(128), ObjName nvarchar(128), UnusedYN nchar(1))
create table #view_dependencies (DBName nvarchar(128), SchemaName nvarchar(128), ObjName nvarchar(128), referenced_database_name nvarchar(128), referenced_schema_name nvarchar(128), referenced_entity_name nvarchar(128), UnusedYN nchar(1))

EXEC sp_MSforeachdb 'use [?];
if db_name() in (select DBName from ADCGuardian.dbo.TB_Unused_Objects_Check_Databases)
begin
	insert into #view
	select db_name() as DBName
		, object_schema_name(object_id) as SchemaName
		, name as ObjName
		, ''N''
	from sys.views
	where is_ms_shipped = 0

	insert into #view_dependencies
	select db_name() as DBName
		, object_schema_name(v.object_id) as SchemaName
		, v.name as ObjName
		, isnull(sed.referenced_database_name, db_name()) as referenced_database_name
		, isnull(sed.referenced_schema_name, ''dbo'') as referenced_schema_name
		, sed.referenced_entity_name
		, ''N''
	from sys.views v
	join sys.sql_expression_dependencies sed on sed.referencing_id = v.object_id
	where v.is_ms_shipped = 0
		and sed.referencing_minor_id = 0
		and (sed.referenced_server_name is null or sed.referenced_server_name = @@servername)
end'

update vd set UnusedYN = 'Y'
from #view_dependencies vd
join dbo.TB_Unused_Objects ut
	on ut.DBName = vd.referenced_database_name and ut.SchemaName = vd.referenced_schema_name and ut.ObjName = vd.referenced_entity_name
where ut.InsDate = @currdate
	and ut.ObjType in ('U', 'FN', 'TF', 'IF')

declare @rowcnt int

while 1 = 1
begin
	update v set UnusedYN = 'Y'
	from #view v
	where UnusedYN = 'N'
		and not exists (
			select 1 
			from #view_dependencies vd
			where vd.DBName = v.DBName and vd.SchemaName = v.SchemaName and vd.ObjName = v.ObjName and vd.UnusedYN = 'N'
		)

	set @rowcnt = @@rowcount

	if @rowcnt = 0	break

	update vd set UnusedYN = 'Y'
	from #view_dependencies vd
	join #view v on v.DBName = vd.referenced_database_name and v.SchemaName = vd.referenced_schema_name and v.ObjName = vd.referenced_entity_name and v.UnusedYN = 'Y'
end

insert into dbo.TB_Unused_Objects (InsDate, DBName, ObjType, SchemaName, ObjName)
select @currdate, DBName, 'V', SchemaName, ObjName
from #view v
where UnusedYN = 'Y'
	and not exists (select 1 from dbo.TB_Unused_Objects ut where ut.InsDate = @currdate and ut.DBName = v.DBName and ut.ObjType = 'V' and ut.SchemaName = v.SchemaName and ut.ObjName = v.ObjName)
GO
