USE [damo]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[hash_str_fast_data3](@i_encodeType [nvarchar](10), @i_hashType [nvarchar](8), @i_data [varbinary](8000))
RETURNS [nvarchar](4000) WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [damosaexp].[DamosaExp].[hash3]
GO
