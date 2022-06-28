USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		최미선
-- Create date: 2011.07.05
-- Description:	호텔 예약 리스트를 검색한다.
-- 2011-10-24 호텔 NET_PRICE 취소이동환불은 0 원으로 
-- 2015-01-15 신규호텔검색되도록 수정 
-- 2015-03-03 호텔판매현황 국내호텔D,해외호텔O 구분 
-- 2021-06-08 CITY_NAME 노출
-- =============================================
CREATE PROCEDURE [dbo].[SP_RES_HOTEL_SALE_LIST]
	@SEARCH_TYPE INT,
	@START_DATE VARCHAR(10),
	@END_DATE VARCHAR(10),
	@REGION_CODE CHAR(3),	
	@NATION_CODE CHAR(2),	
	@CITY_CODE VARCHAR(3),
	@SUP_CODE VARCHAR(10),
	@RES_STATE INT,
	@HOTEL_TYPE VARCHAR(1) = ''
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
---------------------------------------------------------------------------

--DECLARE @RES_CODE VARCHAR(12), --예약코드 
	
--	@SEARCH_TYPE INT,  -- 0=예약일 ,1=체크인,2=체크아웃,3=취소마감일
--	@START_DATE VARCHAR(10), --시작일
--	@END_DATE VARCHAR(10),--종료일 
--	@CITY_CODE VARCHAR(3), --도시코드	
--	@ROOM_YN CHAR(1),   --   'Y', OK/WT HotelRoomStateEnum { 전체 = 0, OK=Y, WT=N };
--	@REGION_CODE CHAR(3),	--지역코드
--	@NATION_CODE CHAR(2),	--국가코드
--	@SUP_CODE VARCHAR(10)	--공급처코드

--SELECT @RES_CODE = 'RH0909060065' , @CITY_CODE = '', @MASTER_CODE = '', @MASTER_NAME = '' ,
--@CUS_NAME = '', @SEARCH_TYPE = 1 , @START_DATE = '2010-01-01',@END_DATE = '' ,
--@ROOM_YN = '',@PAY_STATE = 9 , @RES_TYPE = 10 

---------------------------------------------------------------------------
---------------------------------------------------------------------------

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000)

	-- WHERE 조건 만들기
	BEGIN
			
		SET @SQLSTRING = ' WHERE 1=1 '
		
		--예약진행상태
		IF ISNULL(@RES_STATE, 10) <> 10
			SET @SQLSTRING = @SQLSTRING + ' AND C.RES_STATE = @RES_STATE'
			
			-- 도시코드
		IF ISNULL(@CITY_CODE, '') <> ''
			SET @SQLSTRING = @SQLSTRING + ' AND B.CITY_CODE = @CITY_CODE'

			-- 예약일
		IF ISNULL(@START_DATE, '') <> '' AND ISNULL(@END_DATE, '') <> ''
		BEGIN
			IF @SEARCH_TYPE = 0
				SET @SQLSTRING = @SQLSTRING + ' AND C.NEW_DATE BETWEEN @START_DATE AND CAST(@END_DATE AS DATETIME) + 1'
			ELSE IF @SEARCH_TYPE = 1
				SET @SQLSTRING = @SQLSTRING + ' AND A.CHECK_IN BETWEEN @START_DATE AND @END_DATE'
			ELSE IF @SEARCH_TYPE = 2
				SET @SQLSTRING = @SQLSTRING + ' AND A.CHECK_OUT BETWEEN @START_DATE AND @END_DATE'
			ELSE IF @SEARCH_TYPE = 3
				SET @SQLSTRING = @SQLSTRING + ' AND A.LAST_CXL_DATE BETWEEN @START_DATE AND @END_DATE'
				--SET @SQLSTRING = @SQLSTRING + ' AND C.NEW_DATE BETWEEN @START_DATE AND @END_DATE'
		END
		
			--지역코드
		IF ISNULL(@REGION_CODE, '') <> ''
			SET @SQLSTRING = @SQLSTRING + ' AND B.REGION_CODE = @REGION_CODE'
		
			--국가코드
		IF ISNULL(@NATION_CODE, '') <> ''
			SET @SQLSTRING = @SQLSTRING + ' AND B.NATION_CODE = @NATION_CODE'

			
			--공급자코드
		IF ISNULL(@SUP_CODE, '') <> ''
			SET @SQLSTRING = @SQLSTRING + ' AND A.SUP_CODE = @SUP_CODE'

			--호텔지역구분
		IF ISNULL(@HOTEL_TYPE, '') <> ''
		BEGIN
			IF @HOTEL_TYPE = 'D' 
			BEGIN
				SET @SQLSTRING = @SQLSTRING + ' AND C.MASTER_CODE LIKE ''KHH%'' '
			END 
			IF @HOTEL_TYPE = 'O'
			BEGIN
				SET @SQLSTRING = @SQLSTRING + ' AND C.MASTER_CODE NOT LIKE ''KHH%'' '
			END 
		END 
		
	END
	
	DECLARE @ORDER_BY VARCHAR(1000)
	SET @ORDER_BY = ' ORDER BY A.NO  ' 
	
	IF @SEARCH_TYPE = 0
		SET @ORDER_BY = @ORDER_BY + ' ,A.NEW_DATE  '
	ELSE IF @SEARCH_TYPE = 1
		SET @ORDER_BY = @ORDER_BY + ' ,A.CHECK_IN '
	ELSE IF @SEARCH_TYPE = 2
		SET @ORDER_BY = @ORDER_BY + ' ,A.CHECK_OUT '
	ELSE IF @SEARCH_TYPE = 3
		SET @ORDER_BY = @ORDER_BY + ' ,A.LAST_CXL_DATE '

	SET @SQLSTRING = N'
	SELECT A.*
	FROM (
		SELECT 
			(CASE C.RES_STATE 	WHEN 8 THEN 998	WHEN 9 THEN 999	ELSE 1	END) AS [NO]
			, C.RES_STATE, A.RES_CODE, A.SUP_CODE, A.CHECK_IN, A.CHECK_OUT
			, A.ROOM_YN
			, CASE WHEN ISNUMERIC(A.CITY_CODE) = 0  THEN (SELECT KOR_NAME FROM PUB_CITY WHERE CITY_CODE = A.CITY_CODE) ELSE (SELECT   TOP 1 CITY_NAME  FROM JGHotel.[dbo].[HTL_INFO_MAST_HOTEL] WHERE CITY_CODE = A.CITY_CODE) END  AS [CITY_NAME]
			, DBO.FN_RES_GET_PAY_PRICE(A.RES_CODE) AS [PAY_PRICE]
			, DBO.FN_RES_HTL_GET_TOTAL_PRICE(A.RES_CODE) AS [TOTAL_PRICE]
			, CASE WHEN C.RES_STATE IN (7,8,9) THEN 0 ELSE A.NET_PRICE END AS NET_PRICE
			, (DBO.FN_RES_HTL_GET_TOTAL_PRICE(A.RES_CODE) - A.NET_PRICE) AS [SALE_PROFIT]
			, A.NEW_DATE , C.PRO_CODE
		FROM RES_HTL_ROOM_MASTER A
		INNER JOIN RES_MASTER_damo C ON A.RES_CODE = C.RES_CODE
		--LEFT JOIN HTL_MASTER B ON A.MASTER_CODE = B.MASTER_CODE
		
		' + @SQLSTRING + '
	) A
' + @ORDER_BY ;

	SET @PARMDEFINITION = N'@SEARCH_TYPE INT, @START_DATE VARCHAR(10), @END_DATE VARCHAR(10), @REGION_CODE CHAR(3), @NATION_CODE CHAR(2), @CITY_CODE VARCHAR(3)  
	, @SUP_CODE VARCHAR(10), @RES_STATE int, @HOTEL_TYPE VARCHAR(1)'

	--PRINT @SQLSTRING
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @SEARCH_TYPE, @START_DATE, @END_DATE, @REGION_CODE, @NATION_CODE, @CITY_CODE, @SUP_CODE, @RES_STATE , HOTEL_TYPE 


END
GO