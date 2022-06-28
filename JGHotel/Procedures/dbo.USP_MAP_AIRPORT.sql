USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_MAP_AIRPORT]  
  
/*  
USP_MAP_AIRPORT '179900'  
*/  
  
@CITY_CODE VARCHAR(20)  
  
AS  
  
SELECT AIRPORT_CODE, AIRPORT_NAME, KOR_NAME, LATITUDE, LONGITUDE  
FROM OMNIHOTEL.DBO.CHT_AIRPORT_CODE  
WHERE CITY_CODE=(SELECT OLD_CODE FROM HTL_CODE_MAST_CITY WHERE CITY_CODE=@CITY_CODE)  
AND USE_YN='Y'  
  



GO
