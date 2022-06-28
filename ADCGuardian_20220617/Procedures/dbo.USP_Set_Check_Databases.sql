USE [ADCGuardian_20220617]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROC [dbo].[USP_Set_Check_Databases]
	@db_list nvarchar(4000) = ''
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

truncate table dbo.TB_Unused_Objects_Check_Databases

insert into dbo.TB_Unused_Objects_Check_Databases (DBName)
select value from string_split(@db_list, ',')

update cd set
	DBName = rtrim(ltrim(cd.DBName))
	, DBID = d.database_id
from dbo.TB_Unused_Objects_Check_Databases cd
join sys.databases d on d.name = cd.DBName
GO
