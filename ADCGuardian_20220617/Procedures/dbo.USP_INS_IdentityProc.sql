USE [ADCGuardian_20220617]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** 
Object:  StoredProcedure 
Identity 컬럼정보 입력용. decimal 변환 오류로 인해 변경
2015-02-27 신대경
******/
CREATE PROCEDURE [dbo].[USP_INS_IdentityProc]
@SQLServerID smallint, 
@DBName nvarchar(256), 
@InsDate datetime, 
@SchemaName nvarchar(256), 
@TabName nvarchar(256), 
@ColName nvarchar(256), 
@DataType varchar(20), 
@MaxVal decimal(38,0), 
@CurMax decimal(38,0), 
@Seed decimal(38,0), 
@Incr decimal(38,0), 
@Rate decimal(5,2)
AS
--GuardianQuery
SET NOCOUNT ON
INSERT INTO dbo.DBIdentityCheck
(
SQLServerID, DBName, InsDate, SchemaName, TabName, ColName, DataType, MaxVal, CurMax, Seed, Incr, Rate
)
VALUES
(
@SQLServerID, @DBName, @InsDate, @SchemaName, @TabName, @ColName, @DataType, @MaxVal, @CurMax, @Seed, @Incr, @Rate
)
GO
