USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_CITY_AREA_HOTEL_COUNT]

/*
USP_CITY_AREA_HOTEL_COUNT
*/

AS


UPDATE HTL_CODE_MAST_CITY SET HOTEL_CNT=B.HOTEL_CNT
FROM HTL_CODE_MAST_CITY A
JOIN (
	SELECT A.CITY_CODE, COUNT(*) AS HOTEL_CNT
	FROM HTL_CODE_MAST_CITY A
	JOIN HTL_INFO_MAST_HOTEL B ON A.CITY_CODE=B.CITY_CODE
	GROUP BY A.CITY_CODE
) B ON A.CITY_CODE=B.CITY_CODE



UPDATE HTL_CODE_MAST_AREA SET HOTEL_CNT=B.HOTEL_CNT
FROM HTL_CODE_MAST_AREA A
JOIN (
	SELECT AREA_CODE, COUNT(*) AS HOTEL_CNT
	FROM HTL_INFO_MAST_HOTEL
	GROUP BY AREA_CODE
) B ON A.AREA_CODE=B.AREA_CODE



GO
