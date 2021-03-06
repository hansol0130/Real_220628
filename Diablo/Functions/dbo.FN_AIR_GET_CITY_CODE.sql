USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_AIR_GET_CITY_CODE]
(
	@AIRPORT_CODE CHAR(3)
)
RETURNS CHAR(3)
AS
BEGIN
	DECLARE @CITY_CODE CHAR(3)
	SET @CITY_CODE = ISNULL((select CITY_CODE from pub_airport WITH(NOLOCK) where airport_code = @AIRPORT_CODE), @AIRPORT_CODE)

	IF @CITY_CODE = 'GMP' or @CITY_CODE = 'ICN' SET @CITY_CODE = 'SEL';
	IF @CITY_CODE = 'HND' or @CITY_CODE = 'NRT' SET @CITY_CODE = 'TYO';

	RETURN @CITY_CODE
END
GO
