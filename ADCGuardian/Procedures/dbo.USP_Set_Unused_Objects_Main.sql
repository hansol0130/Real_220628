USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROC [dbo].[USP_Set_Unused_Objects_Main]
	@currdate datetime
	, @unused_check_days int
	, @unused_retention_days int
	, @db_list nvarchar(4000)
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

exec dbo.USP_Set_Unused_Tables_Procedures_ScalarFunctions @currdate, @unused_check_days

exec dbo.USP_Set_Unused_Views @currdate

exec dbo.USP_Set_Unused_TableFunctions @currdate

exec dbo.USP_Set_Unused_Views @currdate				-- 미사용 테이블 반환 함수를 한 번 더 확인

exec dbo.USP_Set_Unused_TableFunctions @currdate	-- 추가로 발견된 미사용 뷰를 한 번 더 확인

delete dbo.TB_Unused_Objects 
where InsDate < dateadd(day, @unused_retention_days * -1, @currdate)
	and DBName in (select DBName from ADCGuardian.dbo.TB_Unused_Objects_Check_Databases)
GO
