USE [damo]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[JsonRequest]
	@spid [int],
	@user [nvarchar](256),
	@hostName [nvarchar](256),
	@hostProcessId [int],
	@loginTime [nvarchar](256),
	@isAuthOnly [bit],
	@indata [varbinary](max),
	@outdata [varbinary](max) OUTPUT
WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [damosaexp].[DamosaExp].[JsonRequest]
GO
