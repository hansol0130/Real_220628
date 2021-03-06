USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		최미선
-- Create date: 2011.06.21
-- Description:	호텔 예약 리스트를 검색한다.

-- 2013-05-02 박형만 RES_MASTER 기준으로 변경 
-- 2014-12-09 박형만 저스트고 호텔 수정 
-- 2015-01-12 박형만 FN_PRO_GET_PAY_STATE  -> FN_RES_GET_PAY_STATE 
-- 2015-02-12 박형만 호텔명수정 
-- 2015-03-13 박형만 @SOC_NUM1 ,2 제거 
-- 2021-06-08 김영민 CITY_NAME 노출 
-- =============================================
/*
SP_RES_HOTEL_MASTER_SELECT_LIST '','','','','',1,'2012-06-12', '2012-06-30','',9,10,3
,'','' ,  '',''  ,'','' ,1,''

 @PRO_TYPE = 3 , @RES_CODE = '' , @CITY_CODE = 'TYO', @MASTER_CODE = '', @MASTER_NAME = '',
@CUS_NAME = '', @SEARCH_TYPE = 0 , @START_DATE = '2009-09-03',@END_DATE = '2010-09-03' ,
@ROOM_YN = 'N',@PAY_STATE = 9 , @RES_TYPE = 10 , @SUP_CODE  = '' ,
@REGION_CODE = '', @NATION_CODE = '' , @EMP_CODE = '' ,@TEAM_CODE = ''

*/
CREATE PROCEDURE [dbo].[SP_RES_HOTEL_MASTER_SELECT_LIST]
	@RES_CODE VARCHAR(12),
	@CITY_CODE VARCHAR(3),
	@MASTER_CODE VARCHAR(10),
	@MASTER_NAME VARCHAR(50),
	@CUS_NAME VARCHAR(20),
	@SEARCH_TYPE INT,
	@START_DATE VARCHAR(10),
	@END_DATE VARCHAR(10),
	@ROOM_YN CHAR(1),
	@PAY_STATE INT,
	@RES_TYPE INT,
	@PRO_TYPE INT,
	@EMP_CODE VARCHAR(7),
	@TEAM_CODE VARCHAR(3),
	@REGION_CODE CHAR(3),	--지역코드
	@NATION_CODE CHAR(2),	--국가코드
	--@SOC_NUM1 VARCHAR(6),	--주민번호1
	--@SOC_NUM2 VARCHAR(7),	--주민번호2
	@RES_STATE INT,			--예약진행상태
	@SUP_CODE VARCHAR(10)
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
---------------------------------------------------------------------------

--DECLARE @RES_CODE VARCHAR(12), --예약코드 
--	@CITY_CODE VARCHAR(3), --도시코드
--	@MASTER_CODE VARCHAR(10), --호텔코드
--	@MASTER_NAME VARCHAR(50), --호텔명
--	@CUS_NAME VARCHAR(20), --예약자명
	
--	@SEARCH_TYPE INT,  -- 0=예약일 ,1=체크인,2=체크아웃,3=취소마감일
--	@START_DATE VARCHAR(10), --시작일
--	@END_DATE VARCHAR(10),--종료일 
	
--	@ROOM_YN CHAR(1),   --   'Y', OK/WT HotelRoomStateEnum { 전체 = 0, OK=Y, WT=N };
	
--	@PAY_STATE INT,   --미수여부 미납=0, 부분납=1, 완납=2, 과납=3, 전체 = 9   
--	@RES_TYPE INT,	--유입처  ReserveTypeEnum { 일반 = 0, 대리점, 상용, 외부, 직원 = 9, 전체 = 10 }
--	@PRO_TYPE INT,		--  행사타입 ProductTypeEnum { 패키지 = 1, 항공 = 2, 호텔 = 3, 자유여행 = 4, 옵션 = 5, 전체 = 9 }
--	@EMP_CODE VARCHAR(7),	--사번
--	@TEAM_CODE VARCHAR(3),	--팀코드 
--	@REGION_CODE CHAR(3),	--지역코드
--	@NATION_CODE CHAR(2),	--국가코드
--	@SOC_NUM1 VARCHAR(6),	--주민번호1
--	@SOC_NUM2 VARCHAR(7),	--주민번호2
--	@RES_STATE INT	,		--예약진행상태
--	@SUP_CODE VARCHAR(10)	--공급처코드

----SELECT @RES_CODE = 'RH0909060065' , @CITY_CODE = '', @MASTER_CODE = '', @MASTER_NAME = '' ,
----@CUS_NAME = '', @SEARCH_TYPE = 1 , @START_DATE = '2010-01-01',@END_DATE = '' ,
----@ROOM_YN = '',@PAY_STATE = 9 , @RES_TYPE = 10 

--SELECT @PRO_TYPE = 3 , @RES_CODE = '' , @CITY_CODE = 'TYO', @MASTER_CODE = '', @MASTER_NAME = '',
--@CUS_NAME = '', @SEARCH_TYPE = 0 , @START_DATE = '2009-09-03',@END_DATE = '2010-09-03' ,
--@ROOM_YN = 'N',@PAY_STATE = 9 , @RES_TYPE = 10 , @SUP_CODE  = ''
---------------------------------------------------------------------------
---------------------------------------------------------------------------

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000)

	-- WHERE 조건 만들기
	IF LEN(ISNULL(@RES_CODE, '')) = 12
	BEGIN
		SET @SQLSTRING = 'WHERE C.RES_CODE = @RES_CODE';
	END
	ELSE
	BEGIN
			-- 상품타입, OK/WT
		SET @SQLSTRING = 'WHERE C.PRO_TYPE = @PRO_TYPE '
		
			-- 룸상태
		IF ISNULL(@ROOM_YN, '') <> ''
			SET @SQLSTRING = @SQLSTRING + ' AND A.ROOM_YN = @ROOM_YN'
			
			-- 도시코드
		IF ISNULL(@CITY_CODE, '') <> ''
			SET @SQLSTRING = @SQLSTRING + ' AND B.CITY_CODE = @CITY_CODE'

			-- 호텔코드
		IF ISNULL(@MASTER_CODE, '') <> ''
			SET @SQLSTRING = @SQLSTRING + ' AND A.MASTER_CODE = @MASTER_CODE'

			-- 호텔명
		IF ISNULL(@MASTER_NAME, '') <> ''
			SET @SQLSTRING = @SQLSTRING + ' AND B.MASTER_NAME LIKE (''%'' + @MASTER_NAME + ''%'')'

			-- 예약자명
		IF ISNULL(@CUS_NAME, '') <> ''
			SET @SQLSTRING = @SQLSTRING + ' AND C.RES_NAME = @CUS_NAME'

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

			-- 유입처
		IF ISNULL(@RES_TYPE, 10) <> 10
			SET @SQLSTRING = @SQLSTRING + ' AND C.RES_TYPE = @RES_TYPE'

			-- 담당자코드( 없으면 팀 전체, 팀 코드가 없으면 전체)
		IF ISNULL(@TEAM_CODE, '') <> ''
		BEGIN
			IF ISNULL(@EMP_CODE, '') <> ''
				SET @SQLSTRING = @SQLSTRING + ' AND C.NEW_CODE = @EMP_CODE'
			ELSE
				SET @SQLSTRING = @SQLSTRING + ' AND C.NEW_CODE IN (SELECT EMP_CODE FROM EMP_MASTER WHERE TEAM_CODE = @TEAM_CODE)'
		END
		
		--------2011.06.20 최미선 지역, 국가, 주민번호, 예약진행상태 추가--------
		
			--지역코드
		IF ISNULL(@REGION_CODE, '') <> ''
			SET @SQLSTRING = @SQLSTRING + ' AND B.REGION_CODE = @REGION_CODE'
		
			--국가코드
		IF ISNULL(@NATION_CODE, '') <> ''
			SET @SQLSTRING = @SQLSTRING + ' AND B.NATION_CODE = @NATION_CODE'

		--	--주민번호1
		--IF ISNULL(@SOC_NUM1, '') <> ''
		--	SET @SQLSTRING = @SQLSTRING + ' AND C.SOC_NUM1 LIKE @SOC_NUM1 + ''%'''
		--	--주민번호2
		--IF ISNULL(@SOC_NUM2, '') <> ''
		--BEGIN
		--	--SET @SQLSTRING = @SQLSTRING + ' AND A.SOC_NUM2 = @SOC_NUM2'
		--	SET @SQLSTRING = @SQLSTRING + ' AND C.SEC1_SOC_NUM2 = damo.dbo.pred_meta_plain_v (@SOC_NUM2,''DIABLO'',''dbo.CUS_CUSTOMER'',''SOC_NUM2'') '
		--END
		
			--예약진행상태
		IF ISNULL(@RES_STATE, '10') <> '10'
			SET @SQLSTRING = @SQLSTRING + ' AND C.RES_STATE = @RES_STATE'
			
			--공급자코드
		IF ISNULL(@SUP_CODE, '') <> ''
			SET @SQLSTRING = @SQLSTRING + ' AND A.SUP_CODE = @SUP_CODE'
		
		-- 미수여부
		IF LEN(ISNULL(@RES_CODE, '')) <> 12 AND ISNULL(@PAY_STATE, 9) <> 9
			SET @SQLSTRING = @SQLSTRING + ' AND DBO.FN_RES_GET_PAY_STATE(C.RES_CODE)= @PAY_STATE'
			
		
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
			,C.RES_STATE, C.PRO_TYPE, DBO.FN_RES_HTL_GET_PAY_STATE(C.RES_CODE) AS [PAY_STATE], A.ROOM_YN
			, CASE WHEN ISNUMERIC(A.CITY_CODE) = 0  THEN (SELECT KOR_NAME FROM PUB_CITY WHERE CITY_CODE = A.CITY_CODE) ELSE (SELECT   TOP 1 CITY_NAME  FROM JGHotel.[dbo].[HTL_INFO_MAST_HOTEL] WHERE CITY_CODE = A.CITY_CODE) END  AS [CITY_NAME]
			, C.RES_CODE, C.PRO_CODE, C.RES_NAME, ISNULL(C.PRO_NAME,B.MASTER_NAME) AS MASTER_NAME, A.CHECK_IN, A.CHECK_OUT, C.NEW_DATE
			, C.PROVIDER, C.NEW_CODE
			, (SELECT KOR_NAME FROM EMP_MASTER WITH(NOLOCK) WHERE EMP_CODE = C.NEW_CODE) AS [NEW_NAME]
			, STUFF((
				SELECT (''/'' + BB.PUB_VALUE + '' ('' + CONVERT(VARCHAR(10), AA.ROOM_COUNT) + '')'') AS [text()]
				FROM RES_HTL_ROOM_DETAIL AA WITH(NOLOCK)
				INNER JOIN COD_PUBLIC BB WITH(NOLOCK) ON BB.PUB_TYPE = ''HOTEL.ROOMTYPE'' AND BB.PUB_CODE = CONVERT(VARCHAR(1), AA.ROOM_TYPE)
				WHERE AA.RES_CODE = A.RES_CODE /*AND AA.HTL_NO = A.HTL_NO*/ FOR XML PATH('''')
			), 1, 1, '''') AS [ROOM_REMARK]
			, (SELECT PUB_VALUE FROM COD_PUBLIC WITH(NOLOCK) WHERE PUB_TYPE = ''RES.AGENT.TYPE'' AND PUB_CODE = ISNULL(C.PROVIDER,''01'')) AS PROVIDER_NAME
			, A.LAST_CXL_DATE
			, (SELECT COUNT(*) FROM RES_CUSTOMER_damo AA WITH(NOLOCK) WHERE AA.RES_CODE = C.RES_CODE AND C.RES_STATE <= 7 AND AA.RES_STATE = 0) AS [RES_COUNT]
			, (SELECT COUNT(*) FROM RES_CUSTOMER_damo AA WITH(NOLOCK) WHERE AA.RES_CODE = C.RES_CODE) AS [RES_TOTAL_COUNT]
		FROM RES_MASTER_damo C WITH(NOLOCK) 
		LEFT JOIN HTL_MASTER B WITH(NOLOCK) ON C.MASTER_CODE = B.MASTER_CODE
		LEFT JOIN RES_HTL_ROOM_MASTER A WITH(NOLOCK)
			ON A.RES_CODE = C.RES_CODE 
		
		' + @SQLSTRING + '
	) A
' + @ORDER_BY ;

	SET @PARMDEFINITION = N'@RES_CODE VARCHAR(12), @CITY_CODE VARCHAR(3), @MASTER_CODE VARCHAR(10), @MASTER_NAME VARCHAR(50), @CUS_NAME VARCHAR(20), @SEARCH_TYPE INT, @START_DATE VARCHAR(10), @END_DATE VARCHAR(10), @ROOM_YN CHAR(1), @PAY_STATE INT, 
	@RES_TYPE INT	, @PRO_TYPE INT, @EMP_CODE VARCHAR(7), @TEAM_CODE VARCHAR(3), @REGION_CODE CHAR(3), @NATION_CODE CHAR(2), @RES_STATE INT  ,@SUP_CODE VARCHAR(10)'

	--PRINT @SQLSTRING
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @RES_CODE, @CITY_CODE, @MASTER_CODE, @MASTER_NAME, @CUS_NAME, @SEARCH_TYPE, @START_DATE, @END_DATE, @ROOM_YN, @PAY_STATE, @RES_TYPE, @PRO_TYPE, @EMP_CODE, @TEAM_CODE, @REGION_CODE, @NATION_CODE, /*@SOC_NUM1, @SOC_NUM2,*/ @RES_STATE , @SUP_CODE 

END

GO
