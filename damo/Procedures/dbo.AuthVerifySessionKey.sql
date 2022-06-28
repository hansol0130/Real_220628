USE [damo]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[AuthVerifySessionKey]
	@spid [int],
	@user [nvarchar](256),
	@hostName [nvarchar](256),
	@hostProcessId [int],
	@loginTime [nvarchar](256),
	@response [varbinary](1024)
WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [damosaexp].[DamosaExp].[VerifySessionKey]
GO
