USE [damo]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[decryptmaxbinary_b64_api](@spid [int], @smallint [smallint], @isNType [smallint], @spAlias [nvarchar](4000), @comment [nvarchar](4000), @tid [nvarchar](128), @shid [varbinary](128), @encdata [varbinary](max))
RETURNS [varbinary](max) WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [damosaexp].[DamosaExp].[DecryptImage_B64_API]
GO
