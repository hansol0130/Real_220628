USE [damo]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[hmac_str_fast_data3_api](@i_encodeType [nvarchar](10), @i_spAlias [nvarchar](128), @i_data [varbinary](8000))
RETURNS [nvarchar](4000) WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [damosaexp].[DamosaExp].[hmac3_api]
GO
