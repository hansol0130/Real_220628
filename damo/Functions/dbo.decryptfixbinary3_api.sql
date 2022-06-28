USE [damo]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[decryptfixbinary3_api](@isNType [bit], @encodeType [nvarchar](30), @spid [int], @dataType [smallint], @user [nvarchar](256), @hostName [nvarchar](256), @hostProcessId [int], @spAlias [nvarchar](4000), @comment [nvarchar](4000), @tid [nvarchar](128), @shid [varbinary](128), @encdata [varbinary](8000))
RETURNS [varbinary](8000) WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [damosaexp].[DamosaExp].[decryptbinary3_api]
GO
