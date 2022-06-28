USE [damo]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[decryptmaxbinary3](@isNType [bit], @encodeType [nvarchar](30), @spid [int], @user [nvarchar](256), @hostName [nvarchar](256), @hostProcessId [int], @schema [nvarchar](4000), @table [nvarchar](4000), @column [nvarchar](4000), @tid [nvarchar](128), @shid [varbinary](128), @encdata [varbinary](max))
RETURNS [varbinary](max) WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [damosaexp].[DamosaExp].[decryptbinary3]
GO
