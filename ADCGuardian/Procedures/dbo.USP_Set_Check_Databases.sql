USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- sp_help TB_Unused_Objects
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
USE ADCGuardian
DROP PROC IF EXISTS dbo.USP_Set_Check_Databases
DROP PROC IF EXISTS dbo.USP_Set_Objects_Stats_Main
DROP PROC IF EXISTS dbo.USP_Set_Unused_Objects_Main
DROP PROC IF EXISTS dbo.USP_Table_Index_Stats
DROP PROC IF EXISTS dbo.USP_Exec_Proc_Stats
DROP PROC IF EXISTS dbo.USP_Exec_Func_Stats
DROP PROC IF EXISTS dbo.USP_Set_Unused_Tables_Procedures_ScalarFunctions
DROP PROC IF EXISTS dbo.USP_Set_Unused_Views
DROP PROC IF EXISTS dbo.USP_Set_Unused_TableFunctions

select * from ADCGuardian.sys.procedures where create_date > '2022-01-25'
*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
