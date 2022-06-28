USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Stored Procedure

/*================================================================================================================
■ USP_NAME					: ZP_WEB_PKG_DETAIL_MULTI_SELECT
■ DESCRIPTION				: 행사 상세 검색(multi price) = XP_WEB_PKG_DETAIL_SELECT 복사 생성
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
	@PRO_CODE VARCHAR(20)	: 행사코드
■ EXEC						: 


■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2020-12-07		홍종우			MULTI PRICE 화면을 위해 XP_WEB_PKG_DETAIL_SELECT 복사하여 수정 후 생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[ZP_WEB_PKG_DETAIL_MULTI_SELECT]
(
    @PRO_CODE        VARCHAR(20) OUTPUT
   ,@SHOW_ALL_YN     CHAR(1) = 'N' -- 기본값(N) , Y 가 아닐때 SHOW 상태와 관계 없이 보여주기
)
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING          NVARCHAR(MAX)

	       ,@PARMDEFINITION     NVARCHAR(1000)
	       ,@SHOWYNQUERY        NVARCHAR(500)

	IF EXISTS(
	       SELECT 1
	       FROM   PKG_MASTER WITH(NOLOCK)
	       WHERE  MASTER_CODE = @PRO_CODE
	   )
	BEGIN
	    -- 예약 가능 행사 검색
	    SELECT TOP 1 @PRO_CODE = A.PRO_CODE
	    FROM   PKG_DETAIL A WITH(NOLOCK)
	    WHERE  A.MASTER_CODE = @PRO_CODE
	           AND A.DEP_DATE > DATEADD(DAY ,7 ,GETDATE())
	           AND A.SHOW_YN = 'Y'
	           AND A.RES_ADD_YN = 'Y'
	           AND (A.MAX_COUNT = 0 OR (A.MAX_COUNT - DBO.FN_PRO_GET_RES_COUNT(A.PRO_CODE) > 0))
	    ORDER BY
	           A.DEP_DATE
	END

	--IF @PRICE_SEQ = 0
	--BEGIN
	--	  SELECT TOP 1 @PRICE_SEQ = PRICE_SEQ FROM PKG_DETAIL_PRICE A WITH(NOLOCK) WHERE A.PRO_CODE = @PRO_CODE ORDER BY A.ADT_PRICE
	--END

	-- Y가 아닐때만 동작
	SET @SHOWYNQUERY = '' 
	IF ISNULL(@SHOW_ALL_YN ,'') <> 'Y'
	BEGIN
	    SET @SHOWYNQUERY = ' AND A.SHOW_YN = ''Y'' '
	END  

	SET @SQLSTRING = 
	    N'
	--행사정보
	SELECT PC.*, A.PRO_CODE, A.PRO_NAME, A.MASTER_CODE, A.TRANSFER_TYPE, A.SEAT_CODE, A.TOUR_NIGHT, A.TOUR_DAY, A.FAKE_COUNT, A.MAX_COUNT, A.MIN_COUNT
		, A.TOUR_JOURNEY, A.RES_ADD_YN, A.DEP_CFM_YN, A.CONFIRM_YN, A.DEP_DATE, A.ARR_DATE, A.SALE_TYPE, A.FIRST_MEET, A.MEET_COUNTER, A.PKG_TOUR_REMARK, A.PKG_SUMMARY, A.HOTEL_REMARK
		, A.PKG_INC_SPECIAL, A.RES_REMARK, A.OPTION_REMARK, A.PKG_PASSPORT_REMARK, A.PKG_SHOPPING_REMARK, A.PKG_REVIEW, A.PKG_REMARK, A.PKG_CONTRACT, A.NEW_CODE, A.TC_YN, A.AIR_CFM_YN, A.ROOM_CFM_YN, A.SCHEDULE_CFM_YN, A.PRICE_CFM_YN
		, DBO.FN_PRO_GET_RES_COUNT(A.PRO_CODE) AS [RES_COUNT], BA.TEAM_NAME, BA.KEY_NUMBER
		, B.KOR_NAME, B.INNER_NUMBER1, B.INNER_NUMBER2, B.INNER_NUMBER3, B.FAX_NUMBER1, B.FAX_NUMBER2, B.FAX_NUMBER3, B.GREETING, B.EMAIL, B.MATE_NUMBER, B.MATE_NUMBER2, B.TEAM_CODE, B.MAIN_NUMBER1, B.MAIN_NUMBER2, B.MAIN_NUMBER3, B.IN_USE_YN
		, (SELECT TOP 1 KOR_NAME FROM EMP_MASTER BB WITH(NOLOCK) WHERE BB.INNER_NUMBER3 = B.MATE_NUMBER AND BB.WORK_TYPE = ''1'' AND LEN(B.MATE_NUMBER) > 0) AS [MATE_NAME]
		, (SELECT TOP 1 KOR_NAME FROM EMP_MASTER BB WITH(NOLOCK) WHERE BB.INNER_NUMBER3 = B.MATE_NUMBER2 AND BB.WORK_TYPE = ''1'' AND LEN(B.MATE_NUMBER2) > 0) AS [MATE_NAME2]
		, C.SIGN_CODE, C.ATT_CODE, C.PKG_COMMENT, C.EVENT_PRO_CODE, C.EVENT_NAME, C.EVENT_DEP_DATE, C.BRANCH_CODE, C.BRAND_TYPE, C.CLEAN_YN, C.SINGLE_YN
		, (SELECT KOR_NAME FROM PUB_REGION AA WITH(NOLOCK) WHERE AA.SIGN = C.SIGN_CODE) AS [SIGN_NAME]		
		, (SELECT TOP 1 PUB_VALUE FROM COD_PUBLIC AA WITH(NOLOCK) WHERE PUB_TYPE = ''PKG.ATTRIBUTE'' AND AA.PUB_CODE = C.ATT_CODE) AS [ATT_NAME]
		, (SELECT COUNT(*) FROM VR_CONTENT V2 WITH(NOLOCK) INNER JOIN VR_MASTER VM WITH(NOLOCK) ON V2.VR_NO = VM.VR_NO WHERE A.MASTER_CODE = V2.MASTER_CODE AND VM.VR_TYPE = 1) AS [VR_COUNT]
		, (CASE WHEN A.PRO_CODE = C.EVENT_PRO_CODE THEN ''Y'' ELSE ''N'' END) AS [EVENT_YN]
		, D.DEP_TRANS_CODE, D.DEP_TRANS_NUMBER, ISNULL(D.DEP_DEP_DATE,A.DEP_DATE) AS DEP_DEP_DATE, ISNULL(D.DEP_ARR_DATE,A.DEP_DATE) AS DEP_ARR_DATE, D.DEP_DEP_TIME, D.DEP_ARR_TIME
		, D.ARR_TRANS_CODE, D.ARR_TRANS_NUMBER, ISNULL(D.ARR_DEP_DATE,A.ARR_DATE) AS ARR_DEP_DATE, ISNULL(D.ARR_ARR_DATE,A.ARR_DATE) AS ARR_ARR_DATE, D.ARR_DEP_TIME, D.ARR_ARR_TIME, E.KOR_NAME AS [DEP_TRANS_NAME]
		, (SELECT DBO.FN_PUB_GET_CITY_NAME(AA.CITY_CODE) FROM PUB_AIRPORT AA WITH(NOLOCK) WHERE AA.AIRPORT_CODE = D.DEP_DEP_AIRPORT_CODE) AS [DEP_DEP_CITY_NAME]
		, (SELECT DBO.FN_PUB_GET_CITY_NAME(AA.CITY_CODE) FROM PUB_AIRPORT AA WITH(NOLOCK) WHERE AA.AIRPORT_CODE = D.DEP_ARR_AIRPORT_CODE) AS [DEP_ARR_CITY_NAME]
		, (SELECT DBO.FN_PUB_GET_CITY_NAME(AA.CITY_CODE) FROM PUB_AIRPORT AA WITH(NOLOCK) WHERE AA.AIRPORT_CODE = D.ARR_DEP_AIRPORT_CODE) AS [ARR_DEP_CITY_NAME]
		, (SELECT DBO.FN_PUB_GET_CITY_NAME(AA.CITY_CODE) FROM PUB_AIRPORT AA WITH(NOLOCK) WHERE AA.AIRPORT_CODE = D.ARR_ARR_AIRPORT_CODE) AS [ARR_ARR_CITY_NAME]
		, ISNULL(( SELECT TOP 1 AIRLINE_CODE FROM PRO_TRANS_SEAT_SEGMENT WITH(NOLOCK) WHERE SEAT_CODE = D.SEAT_CODE AND TRANS_SEQ=1 ORDER BY SEG_NO DESC ),D.DEP_TRANS_CODE) AS DEP_ARR_TRANS_CODE 
		, ISNULL(( SELECT TOP 1 FLIGHT FROM PRO_TRANS_SEAT_SEGMENT WITH(NOLOCK) WHERE SEAT_CODE = D.SEAT_CODE AND TRANS_SEQ=1 ORDER BY SEG_NO DESC ),D.DEP_TRANS_NUMBER) AS DEP_ARR_TRANS_NUMBER 
		, ISNULL(( SELECT TOP 1 AIRLINE_CODE FROM PRO_TRANS_SEAT_SEGMENT WITH(NOLOCK) WHERE SEAT_CODE = D.SEAT_CODE AND TRANS_SEQ=2 ORDER BY SEG_NO DESC ),D.ARR_TRANS_CODE) AS ARR_ARR_TRANS_CODE 
		, ISNULL(( SELECT TOP 1 FLIGHT FROM PRO_TRANS_SEAT_SEGMENT WITH(NOLOCK) WHERE SEAT_CODE = D.SEAT_CODE AND TRANS_SEQ=2 ORDER BY SEG_NO DESC ),D.ARR_TRANS_NUMBER) AS ARR_ARR_TRANS_NUMBER 
		, F.TWO_COUNT, F.THREE_COUNT, F.FOUR_COUNT, F.FIVE_COUNT, F.TWO_PERCENT, F.THREE_PERCENT, F.FOUR_PERCENT, F.FIVE_PERCENT
		, (SELECT PUB_VALUE FROM COD_PUBLIC WITH(NOLOCK) WHERE PUB_TYPE =''PKG.BRANDTYPE'' AND PUB_CODE = C.BRAND_TYPE) AS [BRAND_NAME]
		, (SELECT COUNT(*) FROM PKG_DETAIL_FILE AA WITH(NOLOCK) INNER JOIN INF_FILE_MASTER BB WITH(NOLOCK) ON AA.FILE_CODE=BB.FILE_CODE WHERE AA.PRO_CODE=A.PRO_CODE AND BB.FILE_TYPE=1 AND BB.SHOW_YN=''Y'') AS [IMAGE_COUNT]
		, ISNULL((SELECT COUNT(*) FROM PRO_COMMENT WITH(NOLOCK) WHERE MASTER_CODE = A.MASTER_CODE), 0) AS [COMMENT_COUNT]
		, ISNULL((SELECT COUNT(*) FROM HBS_DETAIL WITH(NOLOCK) WHERE MASTER_SEQ=1 AND MASTER_CODE=A.MASTER_CODE AND DEL_YN=''N'' AND LEVEL=0), 0) AS [REVIEWS_COUNT]
		, ISNULL((SELECT COUNT(*) FROM HBS_DETAIL WITH(NOLOCK) WHERE MASTER_SEQ=4 AND MASTER_CODE=A.MASTER_CODE AND DEL_YN=''N'' AND LEVEL=0), 0) AS [INQUIRY_COUNT], C.SAFE_DATE, C.SAFE_REMARK_1, C.SAFE_REMARK_2, C.SAFE_REMARK_3, ISNULL(C.SWIM_INFO, ''N'') AS SWIM_INFO
		, ISNULL((SELECT ZZ.INNER_PKG_GUIDANCE from dbo.PKG_DETAIL_SELL_POINT ZZ WHERE ZZ.PRO_CODE = A.PRO_CODE), '''') AS INNER_PKG_GUIDANCE, C.LOW_PRICE, C.HIGH_PRICE -- 2019-10-29 추가
		, A.SHOW_YN, C.PKG_TOOLTIP
	FROM PKG_DETAIL A WITH(NOLOCK)
	INNER JOIN EMP_MASTER B WITH(NOLOCK) ON A.NEW_CODE = B.EMP_CODE
	INNER JOIN EMP_TEAM BA WITH(NOLOCK) ON B.TEAM_CODE = BA.TEAM_CODE
	INNER JOIN PKG_MASTER C WITH(NOLOCK) ON A.MASTER_CODE = C.MASTER_CODE
	LEFT JOIN PRO_TRANS_SEAT D WITH(NOLOCK) ON A.SEAT_CODE = D.SEAT_CODE
	LEFT JOIN PUB_AIRLINE E WITH(NOLOCK) ON D.DEP_TRANS_CODE = E.AIRLINE_CODE
	LEFT JOIN STS_PKG_RES_COUNT F WITH(NOLOCK) ON A.MASTER_CODE = F.MASTER_CODE
	CROSS JOIN (
		SELECT ISNULL(ROUND(AVG(CONVERT(FLOAT,GRADE)), 1), 0.0) AS [STAR_POINT] -- 기존 ISNULL(AVG(GRADE), 0) 에서 변경 (2019-10-29 추가)
		     , ISNULL(AVG(POINT1), 0) AS [POINT1]
			 , ISNULL(AVG(POINT2), 0) AS [POINT2]
			 , ISNULL(AVG(POINT3), 0) AS [POINT3]
			 , ISNULL(AVG(POINT4), 0) AS [POINT4]
			 , ISNULL(AVG(POINT5), 0) AS [POINT5]
		FROM PRO_COMMENT PC WITH(NOLOCK) WHERE PC.MASTER_CODE = (SELECT MASTER_CODE FROM PKG_DETAIL WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE)
	) PC
	WHERE A.PRO_CODE = @PRO_CODE ' + @SHOWYNQUERY + 
	    ' 
	--관련이벤트
	SELECT TOP 10 PE.* 
	FROM (
		SELECT EVT_SEQ FROM PUB_EVENT_DATA WITH(NOLOCK) WHERE MASTER_CODE = (SELECT MASTER_CODE FROM PKG_DETAIL WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE) AND SHOW_YN = ''Y''
		UNION
		SELECT EVT_SEQ FROM PUB_EVENT_DATA WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE AND SHOW_YN = ''Y''
	) PED
	INNER JOIN PUB_EVENT PE WITH(NOLOCK) ON PED.EVT_SEQ = PE.EVT_SEQ
	WHERE PE.SHOW_YN = ''Y''
		AND ISNULL(PE.END_DATE, ''2099-12-31'') > GETDATE()
	ORDER BY ISNULL(PE.EDT_DATE, PE.NEW_DATE) DESC;
	--가격정보
	SELECT 
		A.PRO_CODE, A.PRICE_SEQ, A.PRICE_NAME
		, A.SEASON, A.SCH_SEQ, A.PKG_INCLUDE, A.PKG_NOT_INCLUDE, A.SGL_PRICE, A.CUR_TYPE, A.EXC_RATE, A.FLOATING_YN, A.POINT_RATE, A.POINT_PRICE, A.POINT_YN
		, B.ADT_TAX, B.CHD_TAX, B.INF_TAX, A.ADT_PRICE, A.CHD_PRICE, A.INF_PRICE
		, ISNULL(B.ADT_SALE_PRICE, 0) AS ADT_SALE_PRICE, ISNULL(B.CHD_SALE_PRICE, 0) AS CHD_SALE_PRICE, ISNULL(B.INF_SALE_PRICE, 0) AS INF_SALE_PRICE
		, ISNULL(B.ADT_SALE_QCHARGE, 0) AS ADT_SALE_QCHARGE
		, ISNULL(B.CHD_SALE_QCHARGE, 0) AS CHD_SALE_QCHARGE
		, ISNULL(B.INF_SALE_QCHARGE, 0) AS INF_SALE_QCHARGE
		, B.SALE_QCHARGE_DATE
		, B.QCHARGE_TYPE
		, (CASE ISNULL(A.POINT_YN, ''0'') WHEN ''0'' THEN ''N'' ELSE ''Y'' END) AS POINT_CREATE_YN 
	FROM PKG_DETAIL_PRICE A WITH(NOLOCK) 
	INNER JOIN XN_PKG_DETAIL_PRICE(@PRO_CODE, 0) B ON A.PRO_CODE = B.PRO_CODE AND A.PRICE_SEQ = B.PRICE_SEQ
	WHERE A.PRO_CODE = @PRO_CODE;

	/*
	SELECT *, DBO.XN_PRO_GET_QCHARGE_PRICE(PRO_CODE,'''') AS QCHARGE_PRICE ,
		(CASE ISNULL(POINT_YN, ''0'') WHEN ''0'' THEN ''N'' ELSE ''Y'' END) AS POINT_CREATE_YN 
	FROM PKG_DETAIL_PRICE WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE;
	*/
	--사진정보
	SELECT B.*
	, ''0'' AS SORT_GUBUN
	FROM PKG_MASTER A WITH(NOLOCK)
	INNER JOIN INF_FILE_MASTER B WITH(NOLOCK) ON A.MAIN_FILE_CODE = B.FILE_CODE
	WHERE A.MASTER_CODE = (SELECT TOP 1 MASTER_CODE FROM PKG_DETAIL WHERE PRO_CODE = @PRO_CODE) AND B.FILE_TYPE = 1 AND B.SHOW_YN = ''Y''
	UNION
	SELECT B.*
	, A.SHOW_ORDER AS SORT_GUBUN
	FROM PKG_DETAIL_FILE A WITH(NOLOCK)
	INNER JOIN INF_FILE_MASTER B WITH(NOLOCK) ON A.FILE_CODE = B.FILE_CODE
	WHERE A.PRO_CODE = @PRO_CODE AND B.FILE_TYPE = 1 AND B.SHOW_YN = ''Y''
	ORDER BY SORT_GUBUN; -- SHOW_ORDER;
	'

	SET @PARMDEFINITION = N'
		@PRO_CODE VARCHAR(20) OUTPUT';

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
	@PRO_CODE OUTPUT;

END
GO
