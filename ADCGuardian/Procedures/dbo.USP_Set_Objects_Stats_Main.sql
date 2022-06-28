USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROC [dbo].[USP_Set_Objects_Stats_Main]
	@unused_check_days int = 90
	, @unused_retention_days int = 30
	, @unused_check_hh int = 0
	, @unused_check_mm int = 0
	, @db_list nvarchar(4000) = ''
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

declare @currdate datetime = getdate()

exec dbo.USP_Set_Check_Databases @db_list

exec dbo.USP_Table_Index_Stats

exec dbo.USP_Exec_Proc_Stats

exec dbo.USP_Exec_Func_Stats

if datepart(hh, @currdate) = @unused_check_hh and datepart(mi, @currdate) = @unused_check_mm
begin
	exec dbo.USP_Set_Unused_Objects_Main @currdate, @unused_check_days, @unused_retention_days, @db_list
end
GO
