USE [damo]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[AuthMakeSessionKey]
	@spid [int],
	@uicert [varbinary](8000),
	@encSessionKey [varbinary](1024) OUTPUT
WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [damosaexp].[DamosaExp].[MakeSessionKey]
GO
