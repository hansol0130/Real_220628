USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_MOB_PKG_DETAIL_SELECT
■ DESCRIPTION				: 모바일 행사 상세 검색
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
	@PRO_CODE VARCHAR(20)	: 행사코드
	@PRICE_SEQ INT			: 가격순번
■ EXEC						: 

	DECLARE @PRO_CODE VARCHAR(20),
	@PRICE_SEQ INT

	--SELECT @PRO_CODE = 'EPF306-130101AY', @PRICE_SEQ = 0
	SELECT @PRO_CODE = 'APF203', @PRICE_SEQ = 0

	exec XP_MOB_PKG_DETAIL_SELECT @PRO_CODE output, @PRICE_SEQ OUTPUT
	SELECT @PRO_CODE, @PRICE_SEQ

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-09-09		김성호			최초생성
   2014-06-19		정지용			가격정찰체 관련 쿼리 수정
   2014-06-24		정지용			쇼핑정보 및 안전정보 추가
   2014-07-07		박형만			QCHARGE_ADD_PRICE 컬럼삭제
   2014-07-28		정지용			옵션정보 추가
================================================================================================================*/ 
CREATE  PROCEDURE [dbo].[XP_MOB_PKG_DETAIL_SELECT]
(
	@PRO_CODE	VARCHAR(20) OUTPUT,
	@PRICE_SEQ	INT OUTPUT
)
AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000);

	IF EXISTS(SELECT 1 FROM PKG_MASTER WITH(NOLOCK) WHERE MASTER_CODE = @PRO_CODE)
	BEGIN
		-- 예약 가능 행사 검색
		SELECT TOP 1 @PRO_CODE = A.PRO_CODE 
		FROM PKG_DETAIL A WITH(NOLOCK)
		WHERE A.MASTER_CODE = @PRO_CODE AND A.DEP_DATE > DATEADD(DAY, 7, GETDATE()) AND A.SHOW_YN = 'Y' 
			AND A.RES_ADD_YN = 'Y' AND (A.MAX_COUNT = 0 OR (A.MAX_COUNT - DBO.FN_PRO_GET_RES_COUNT(A.PRO_CODE) > 0))
		ORDER BY A.DEP_DATE
	END

	IF @PRICE_SEQ = 0
	BEGIN
		SELECT TOP 1 @PRICE_SEQ = PRICE_SEQ FROM PKG_DETAIL_PRICE A WITH(NOLOCK) WHERE A.PRO_CODE = @PRO_CODE ORDER BY A.ADT_PRICE
	END

	SET @SQLSTRING = N'
	--행사정보
	SELECT A.PRO_CODE, A.PRO_NAME, A.MASTER_CODE, A.TRANSFER_TYPE, A.SEAT_CODE, A.TOUR_NIGHT, A.TOUR_DAY, A.FAKE_COUNT, A.MAX_COUNT, A.MIN_COUNT
		, A.TOUR_JOURNEY, A.RES_ADD_YN, A.DEP_CFM_YN, A.CONFIRM_YN, A.DEP_DATE, A.ARR_DATE, A.SALE_TYPE, A.FIRST_MEET, A.MEET_COUNTER, A.PKG_REVIEW, A.NEW_CODE, A.TC_YN
		, A.PKG_CONTRACT, A.PKG_PASSPORT_REMARK, A.PKG_TOUR_REMARK, A.PKG_SHOPPING_REMARK, A.OPTION_REMARK, A.HOTEL_REMARK, A.PKG_REMARK, A.RES_REMARK, A.PKG_INC_SPECIAL
		, DBO.FN_PRO_GET_RES_COUNT(A.PRO_CODE) AS [RES_COUNT], BA.TEAM_NAME, BA.KEY_NUMBER
		, B.KOR_NAME, B.INNER_NUMBER1, B.INNER_NUMBER2, B.INNER_NUMBER3, B.FAX_NUMBER1, B.FAX_NUMBER2, B.FAX_NUMBER3, B.GREETING, B.EMAIL, B.MATE_NUMBER, B.TEAM_CODE
		, C.SIGN_CODE, C.ATT_CODE, C.PKG_COMMENT, C.EVENT_PRO_CODE, C.EVENT_NAME, C.EVENT_DEP_DATE, C.BRANCH_CODE, C.BRAND_TYPE
		, D.PKG_INCLUDE, D.PKG_NOT_INCLUDE
		, (CASE WHEN A.PRO_CODE = C.EVENT_PRO_CODE THEN ''Y'' ELSE ''N'' END) AS [EVENT_YN]
		, E.DEP_TRANS_CODE, E.DEP_TRANS_NUMBER, E.DEP_DEP_DATE, E.DEP_ARR_DATE, E.DEP_DEP_TIME, E.DEP_ARR_TIME
		, E.ARR_TRANS_CODE, E.ARR_TRANS_NUMBER, E.ARR_DEP_DATE, E.ARR_ARR_DATE, E.ARR_DEP_TIME, E.ARR_ARR_TIME, F.KOR_NAME AS [DEP_TRANS_NAME]
		, (SELECT KOR_NAME FROM PUB_REGION AA WITH(NOLOCK) WHERE AA.SIGN = C.SIGN_CODE) AS [SIGN_NAME], C.SAFE_DATE, C.SAFE_REMARK_1, C.SAFE_REMARK_2, C.SAFE_REMARK_3
	FROM PKG_DETAIL A WITH(NOLOCK)
	INNER JOIN EMP_MASTER B WITH(NOLOCK) ON A.NEW_CODE = B.EMP_CODE
	INNER JOIN EMP_TEAM BA WITH(NOLOCK) ON B.TEAM_CODE = BA.TEAM_CODE
	INNER JOIN PKG_MASTER C WITH(NOLOCK) ON A.MASTER_CODE = C.MASTER_CODE
	INNER JOIN PKG_DETAIL_PRICE D WITH(NOLOCK) ON A.PRO_CODE = D.PRO_CODE
	LEFT JOIN PRO_TRANS_SEAT E WITH(NOLOCK) ON A.SEAT_CODE = E.SEAT_CODE
	LEFT JOIN PUB_AIRLINE F WITH(NOLOCK) ON E.DEP_TRANS_CODE = F.AIRLINE_CODE
	WHERE A.PRO_CODE = @PRO_CODE AND D.PRICE_SEQ = @PRICE_SEQ AND A.SHOW_YN = ''Y''
	--가격정보
	--SELECT *, (CASE ISNULL(POINT_YN, ''0'') WHEN ''0'' THEN ''N'' ELSE ''Y'' END) AS POINT_CREATE_YN FROM PKG_DETAIL_PRICE WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE;
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

	--사진정보
	SELECT TOP 1 B.*
	FROM PKG_DETAIL_FILE A WITH(NOLOCK)
	INNER JOIN INF_FILE_MASTER B WITH(NOLOCK) ON A.FILE_CODE = B.FILE_CODE
	WHERE A.PRO_CODE = @PRO_CODE AND B.FILE_TYPE = 1 AND B.SHOW_YN = ''Y''
	ORDER BY SHOW_ORDER;
	
	-- 공동경비정보
	SELECT * fROM XN_PKG_DETAIL_PRICE_GROUP_COST_SUMMARY(@PRO_CODE, @PRICE_SEQ);

	-- 쇼핑정보
	SELECT PRO_CODE,SHOP_SEQ,SHOP_NAME,SHOP_PLACE,SHOP_TIME,SHOP_REMARK FROM PKG_DETAIL_SHOPPING WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE;

	-- 옵션정보
	SELECT PRO_CODE, OPT_SEQ, OPT_NAME, OPT_CONTENT, OPT_PRICE, OPT_USETIME, OPT_REPLACE, OPT_PLACE, OPT_COMPANION FROM PKG_DETAIL_OPTION WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE'


	SET @PARMDEFINITION = N'
		@PRO_CODE VARCHAR(20) OUTPUT,
		@PRICE_SEQ INT OUTPUT';

	--SELECT LEN(@SQLSTRING)

	--PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@PRO_CODE OUTPUT,
		@PRICE_SEQ OUTPUT;

END
GO