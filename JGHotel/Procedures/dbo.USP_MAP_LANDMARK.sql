USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_MAP_LANDMARK]  
  
/*  
USP_MAP_LANDMARK '179900'  
*/  
  
@CITY_CODE VARCHAR(20)  
  
AS  
  
SELECT MARK_CODE, ENG_NAME, KOR_NAME, LATITUDE, LONGITUDE, USE_YN  
FROM OMNIHOTEL.DBO.CHT_LANDMARK  
WHERE CITY_CODE=(SELECT OLD_CODE FROM HTL_CODE_MAST_CITY WHERE CITY_CODE=@CITY_CODE) 
ORDER BY ENG_NAME  
  


GO
