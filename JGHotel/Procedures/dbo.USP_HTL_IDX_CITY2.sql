USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_HTL_IDX_CITY2]
      
/*      
USP_HTL_IDX_CITY2 'C'
*/      

@ITEM_TYPE VARCHAR(1)
      
AS      

CREATE TABLE #TMP_CITY (
	NATION_CODE VARCHAR(2),
	NATION_NAME VARCHAR(300),
	NATION_ENAME VARCHAR(300),
	CITY_CODE BIGINT,
	CITY_NAME VARCHAR(300),
	CITY_ENAME VARCHAR(300),
	AREA_CODE BIGINT,
	AREA_NAME VARCHAR(300),
	AREA_ENAME VARCHAR(300),
	HOTEL_CODE INT,
	HOTEL_NAME VARCHAR(300),
	HOTEL_ENAME VARCHAR(300),
	INDEX_NAME VARCHAR(500),
	SORT INT,
	HOTEL_CNT INT,
	ITEM_TYPE VARCHAR(1)
);


IF (@ITEM_TYPE='C')
BEGIN

	INSERT #TMP_CITY
	SELECT NATION_CODE, NATION_NAME, NATION_ENAME, CITY_CODE, CITY_NAME, CITY_ENAME, 
	NULL, NULL, NULL, NULL, NULL, NULL, INDEX_NAME, SORT_ORDER, HOTEL_CNT, 'C'
	FROM HTL_CODE_MAST_CITY      
	WHERE USE_YN='Y' AND ISNULL(HOTEL_CNT,0) > 0

	SELECT 
	ITEM_TYPE
	+ '|' + ISNULL(CONVERT(VARCHAR,NATION_CODE),'')
	+ '|' + ISNULL(NATION_NAME,'')
	+ '|' + ISNULL(NATION_ENAME,'')
	+ '|' + ISNULL(CONVERT(VARCHAR,CITY_CODE),'')
	+ '|' + ISNULL(CITY_NAME,'')
	+ '|' + ISNULL(CITY_ENAME,'')
	+ '|' + ISNULL(CONVERT(VARCHAR,AREA_CODE),'')
	+ '|' + ISNULL(AREA_NAME,'')
	+ '|' + ISNULL(AREA_ENAME,'')
	+ '|' + ISNULL(CONVERT(VARCHAR,HOTEL_CODE),'')
	+ '|' + ISNULL(HOTEL_NAME,'')
	+ '|' + ISNULL(HOTEL_ENAME,'') AS [VALUE],
	REPLACE(INDEX_NAME, ',', ' ')
	+ ' ' + CITY_NAME
	+ ' ' + CITY_ENAME
	+ ' ' + NATION_NAME
	+ ' ' + NATION_ENAME AS [TEXT]
	FROM #TMP_CITY
	WHERE ITEM_TYPE='C'
	ORDER BY SORT, HOTEL_CNT DESC
END

ELSE IF (@ITEM_TYPE='A')
BEGIN

	INSERT #TMP_CITY
	SELECT B.NATION_CODE, B.NATION_NAME, B.NATION_ENAME, A.CITY_CODE, A.CITY_NAME, B.CITY_ENAME, 
	A.AREA_CODE, A.AREA_NAME, A.AREA_ENAME, NULL, NULL, NULL, 
	A.AREA_NAME + ',' + A.AREA_ENAME, B.SORT_ORDER,
	A.HOTEL_CNT, 'A'
	FROM HTL_CODE_MAST_AREA A
	JOIN HTL_CODE_MAST_CITY B ON A.CITY_CODE=B.CITY_CODE
	WHERE A.USE_YN='Y' AND B.USE_YN='Y'  AND ISNULL(A.HOTEL_CNT,0) > 0

	SELECT
	ITEM_TYPE
	+ '|' + ISNULL(CONVERT(VARCHAR,NATION_CODE),'')
	+ '|' + ISNULL(NATION_NAME,'')
	+ '|' + ISNULL(NATION_ENAME,'')
	+ '|' + ISNULL(CONVERT(VARCHAR,CITY_CODE),'')
	+ '|' + ISNULL(CITY_NAME,'')
	+ '|' + ISNULL(CITY_ENAME,'')
	+ '|' + ISNULL(CONVERT(VARCHAR,AREA_CODE),'')
	+ '|' + ISNULL(AREA_NAME,'')
	+ '|' + ISNULL(AREA_ENAME,'')
	+ '|' + ISNULL(CONVERT(VARCHAR,HOTEL_CODE),'')
	+ '|' + ISNULL(HOTEL_NAME,'')
	+ '|' + ISNULL(HOTEL_ENAME,'') AS [VALUE],
	AREA_NAME
	+ ' ' + AREA_ENAME AS [TEXT]
	FROM #TMP_CITY
	WHERE ITEM_TYPE='A'
	ORDER BY SORT, HOTEL_CNT DESC
END

ELSE IF (@ITEM_TYPE='H')
BEGIN

	INSERT #TMP_CITY
	SELECT DISTINCT B.NATION_CODE, B.NATION_NAME, B.NATION_ENAME, B.CITY_CODE, B.CITY_NAME, B.CITY_ENAME,
	A.AREA_CODE, A.AREA_NAME, C.AREA_ENAME, A.HOTEL_CODE, A.NAME, A.ENG_NAME, 
	A.NAME + ',' + A.ENG_NAME, B.SORT_ORDER, A.RV_POINT, 'H'
	FROM HTL_INFO_MAST_HOTEL A
	JOIN HTL_CODE_MAST_CITY B ON A.CITY_CODE=B.CITY_CODE
	LEFT JOIN HTL_CODE_MAST_AREA C ON A.AREA_CODE=C.AREA_CODE
	WHERE A.USE_YN='Y' AND B.USE_YN='Y' AND A.CITY_CODE IS NOT NULL


	SELECT
	ITEM_TYPE
	+ '|' + ISNULL(CONVERT(VARCHAR,NATION_CODE),'')
	+ '|' + ISNULL(NATION_NAME,'')
	+ '|' + ISNULL(NATION_ENAME,'')
	+ '|' + ISNULL(CONVERT(VARCHAR,CITY_CODE),'')
	+ '|' + ISNULL(CITY_NAME,'')
	+ '|' + ISNULL(CITY_ENAME,'')
	+ '|' + ISNULL(CONVERT(VARCHAR,AREA_CODE),'')
	+ '|' + ISNULL(AREA_NAME,'')
	+ '|' + ISNULL(AREA_ENAME,'')
	+ '|' + ISNULL(CONVERT(VARCHAR,HOTEL_CODE),'')
	+ '|' + ISNULL(HOTEL_NAME,'')
	+ '|' + ISNULL(HOTEL_ENAME,'') AS [VALUE],
	HOTEL_NAME
	+ ' ' + HOTEL_ENAME AS [TEXT]
	FROM #TMP_CITY
	WHERE ITEM_TYPE='H'
	ORDER BY SORT, HOTEL_CNT DESC
END


DROP TABLE #TMP_CITY
GO
