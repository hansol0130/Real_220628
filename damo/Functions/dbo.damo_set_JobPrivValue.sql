USE [damo]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[damo_set_JobPrivValue](@spid [int])
RETURNS [int] WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [damosaexp].[DamosaExp].[CLR_SetJobPrivValue]
GO
