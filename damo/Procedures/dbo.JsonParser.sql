USE [damo]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[JsonParser]
	@spid [int],
	@user [nvarchar](256),
	@hostName [nvarchar](256),
	@hostProcessId [int],
	@indata [nvarchar](max),
	@outdata [nvarchar](max) OUTPUT
WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [damosaexp].[DamosaExp].[JsonParser]
GO
