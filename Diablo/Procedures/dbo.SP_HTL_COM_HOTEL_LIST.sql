USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김성호
-- Create date: 2011-6-2
-- Description:	임시 가격테이블에 저장된 호텔의 정보를 페이징한다.
-- History 
-- 2011-06-01 : 최초생성
-- 2011-06-02 : 캐싱 및 페이징 기능 추가
-- 2011-08-10 : 임시테이블 VGLog DB로 수정
-- 2011-12-30 : 호텔 이벤트 정보 추가 검색
-- 2012-03-02 : READ UNCOMMITTED 설정
-- 2014-03-19 : 등급 검색 시 전체 일때 세팅 값 변경
-- =============================================
CREATE PROCEDURE [dbo].[SP_HTL_COM_HOTEL_LIST]
	@SESSION_ID int,
	@PAGE_INDEX int,
	@PAGE_SIZE int,
	@ORDER	int,
	@LINEUP	int,
	@MASTER_CODE	varchar(10),
	@HOTEL_NAME	varchar(30),
	@MIN_PRICE	decimal,
	@MAX_PRICE	decimal,
	@LOW_GRADE	varchar(10),
	@HIGH_GRADE	varchar(10)
AS
BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

DECLARE @SQL NVARCHAR(4000)
DECLARE @ORDER_SQL NVARCHAR(1000), @LINEUP_SQL NVARCHAR(10)
DECLARE @PARMDEFINITION NVARCHAR(1000)
DECLARE @FROM INT
DECLARE @TO INT

SET @FROM = (@PAGE_INDEX - 1) * @PAGE_SIZE + 1
SET @TO = @FROM + @PAGE_SIZE - 1

-- 결과내 재검색
IF @MAX_PRICE = 0
	SET @MAX_PRICE = 99999999
IF @LOW_GRADE = '전체'
	SET @LOW_GRADE = '별1'
SET @HIGH_GRADE = (
	CASE 
		WHEN @HIGH_GRADE = '전체' THEN '별7'
		WHEN @HIGH_GRADE >= '별5' THEN '별7'
		ELSE @HIGH_GRADE
	END
)

-- 정렬 방향
IF @LINEUP = 0
	SET @LINEUP_SQL = ' ASC'
ELSE IF @LINEUP = 1
	SET @LINEUP_SQL = ' DESC'

SET @ORDER_SQL = 
	CASE @ORDER
		-- 이름순
		WHEN 1 THEN 'MASTER_NAME'
		-- 등급순
		WHEN 2 THEN 'CASE WHEN HTL_GRADE = ''전체'' THEN ''별0'' ELSE HTL_GRADE END'
		-- 추천순
		WHEN 3 THEN 'RECOMMAND_ORDER'
		-- 가격순
		ELSE 'MIN_PRICE'
	END;
-- @SQL 4000천가 빠듯해서 줄 간격 되도록 없앰
SET @SQL =
N'
SELECT
	@SESSION_ID AS [SessionNo], @PAGE_SIZE AS [PageSize], @PAGE_INDEX AS [PageIndex]
	, (SELECT COUNT(*) FROM VGLog.dbo.HTL_TMP_PRICE_HOTEL AA WHERE AA.SEQ_NO = @SESSION_ID AND AA.MIN_PRICE BETWEEN @MIN_PRICE AND @MAX_PRICE AND AA.HTL_GRADE BETWEEN @LOW_GRADE AND @HIGH_GRADE
		--검색조건
	) AS [TotalCount]
	, (SELECT MIN(SELLER_PRICE) FROM VGLog.dbo.HTL_TMP_PRICE_DETAIL WHERE SEQ_NO = @SESSION_ID) AS [MinPrice]
	, (SELECT MAX(SELLER_PRICE) FROM VGLog.dbo.HTL_TMP_PRICE_DETAIL WHERE SEQ_NO = @SESSION_ID) AS [MaxPrice]
	, (SELECT
		A.MASTER_CODE AS [MasterCode], B.MASTER_NAME AS [HotelName], A.HTL_GRADE AS [HotelGradeType]
		, ISNULL(B.RECOME_YN, ''N'') AS [RecomeYn], B.RECOME_REMARK AS [RecomeInfo], B.RECOME_URL AS [RecomeUrl]
		, CASE WHEN D.SHORT_LOCATION IS NULL THEN D.DETAIL_LOCATION ELSE D.SHORT_LOCATION END AS [LocationInfo]
		, C.CNT_CODE AS [ContentCode], C.GPS_X AS [GpsX], C.GPS_Y AS [GpsY]
		, CASE WHEN C.SHORT_DESCRIPTION IS NULL THEN C.DESCRIPTION ELSE C.SHORT_DESCRIPTION  END AS [ShortDescription]
		, (	SELECT TOP 1 (
				''/CONTENT/'' + BB.REGION_CODE + ''/'' + BB.NATION_CODE + ''/'' + RTRIM(BB.STATE_CODE) + ''/'' + BB.CITY_CODE + ''/IMAGE/'' +
				(CASE
					WHEN ISNULL(BB.FILE_NAME_M, '''') <> '''' THEN BB.FILE_NAME_M
					ELSE BB.FILE_NAME_S
				END))
			FROM INF_FILE_MANAGER AA
			INNER JOIN INF_FILE_MASTER BB ON BB.FILE_CODE = AA.FILE_CODE AND BB.FILE_TYPE = 1
			WHERE AA.CNT_CODE = C.CNT_CODE
		) AS [ImageUrl]
		, (SELECT MIN(ONEDAY_PRICE) FROM VGLog.dbo.HTL_TMP_PRICE_DETAIL WHERE SEQ_NO = @SESSION_ID AND MASTER_CODE = A.MASTER_CODE) AS [MinPrice]
		, (SELECT MAX(ONEDAY_PRICE) FROM VGLog.dbo.HTL_TMP_PRICE_DETAIL WHERE SEQ_NO = @SESSION_ID AND MASTER_CODE = A.MASTER_CODE) AS [MaxPrice]
		, A.EVENT_SEQ AS [EventSeq]
		, A.EVT_INFO AS [EventInfo]
		, (	SELECT
				AA.MASTER_CODE AS [MasterCode], AA.PRICE_NO AS [PriceNo]
				, AA.SUP_CODE AS [ProviderType], AA.PVD_HTL_CODE AS [ProviderHotelCode]
				, AA.PVD_CITY_CODE AS [ProviderCityCode], AA.PVD_CITY_NAME AS [ProviderCityName]
				, AA.PVD_ROOM_TYPE_CODE1 AS [ProviderRoomTypeCode1]
				, AA.PVD_ROOM_TYPE_NAME AS [ProviderRoomTypeName]
				, AA.PVD_ROOM_TYPE_CODE2 AS [ProviderRoomTypeCode2]
				, AA.CFM_TYPE AS [ConfirmationType]
				, AA.PVD_CFM_CODE AS [ProviderConfirmationCode]
				, AA.PVD_CFM_NAME AS [ProviderConfirmationName]
				, AA.BREAKFAST_YN AS [BreakfastYN]
				, AA.BREAKFAST_NAME AS [BreakfastName]
				, AA.CURRENCY AS [Currency], AA.NET_PRICE AS [NetPrice]
				, AA.SELLER_PRICE AS [SellerPrice], AA.ONEDAY_PRICE AS [OnedayPrice]
				, AA.EVENT_SEQ AS [EventSeq]
				, ISNULL(BB.EVT_REMARK, '''') AS [EventRemark]
			FROM VGLog.dbo.HTL_TMP_PRICE_DETAIL AA
			LEFT JOIN HTL_EVENT BB ON AA.EVENT_SEQ = BB.EVT_SEQ
			WHERE AA.SEQ_NO = @SESSION_ID AND AA.MASTER_CODE = A.MASTER_CODE
			FOR XML PATH (''RoomInfo''), TYPE
		) AS [Rooms]
		FROM (
			SELECT
				ROW_NUMBER() OVER (ORDER BY ' + @ORDER_SQL + @LINEUP_SQL + ', MIN_PRICE ) AS ROWNUMBER
				, AA.HTL_GRADE, AA.MASTER_CODE, AA.EVENT_SEQ, BB.EVT_INFO
			FROM VGLog.dbo.HTL_TMP_PRICE_HOTEL AA
			LEFT JOIN HTL_EVENT BB ON AA.EVENT_SEQ = BB.EVT_SEQ
			WHERE AA.SEQ_NO = @SESSION_ID
				AND AA.MIN_PRICE BETWEEN @MIN_PRICE AND @MAX_PRICE
				AND	AA.HTL_GRADE BETWEEN @LOW_GRADE AND @HIGH_GRADE
				--검색조건
		) A
		INNER JOIN HTL_MASTER B ON B.MASTER_CODE = A.MASTER_CODE
		INNER JOIN INF_MASTER C ON C.CNT_CODE = B.CNT_CODE
		INNER JOIN INF_HOTEL D ON D.CNT_CODE = C.CNT_CODE
		WHERE A.ROWNUMBER BETWEEN @FROM AND @TO
		ORDER BY A.ROWNUMBER
		FOR XML PATH (''HotelInfo''), BINARY BASE64
	) AS [Hotels]
FROM VGLog.dbo.HTL_TMP_PRICE_MASTER
WHERE SEQ_NO = @SESSION_ID
FOR XML PATH (''HotelSearchRS'')
'

IF @MASTER_CODE <> ''
	SET @SQL = REPLACE(@SQL, '--검색조건', 'AND AA.MASTER_CODE = @MASTER_CODE')
ELSE IF @HOTEL_NAME <> ''
	SET @SQL = REPLACE(@SQL, '--검색조건', 'AND (AA.MASTER_NAME = @HOTEL_NAME OR PATINDEX(''%'' + @HOTEL_NAME + ''%'', AA.MASTER_NAME) > 0)')

SET @PARMDEFINITION = N'@FROM INT, @TO INT, @SESSION_ID INT, @PAGE_SIZE INT, @PAGE_INDEX INT, @MASTER_CODE VARCHAR(10), @HOTEL_NAME VARCHAR(30), @MIN_PRICE DECIMAL, @MAX_PRICE DECIMAL, @LOW_GRADE VARCHAR(10), @HIGH_GRADE VARCHAR(10)';  

EXEC SP_EXECUTESQL @SQL, @PARMDEFINITION, @FROM, @TO, @SESSION_ID, @PAGE_SIZE ,@PAGE_INDEX, @MASTER_CODE, @HOTEL_NAME, @MIN_PRICE, @MAX_PRICE, @LOW_GRADE, @HIGH_GRADE;
--PRINT @SQL
--PRINT LEN(@SQL)
END


--exec SP_HTL_COM_HOTEL_LIST @SESSION_ID=100218,@PAGE_INDEX=1,@PAGE_SIZE=10,@ORDER=0,@LINEUP=0,@MASTER_CODE='AHH30596',@HOTEL_NAME='kimberley',@MIN_PRICE=0,@MAX_PRICE=0,@LOW_GRADE=N'전체',@HIGH_GRADE=N'전체'

GO
