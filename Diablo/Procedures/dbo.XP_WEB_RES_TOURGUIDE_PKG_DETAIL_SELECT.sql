USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_WEB_RES_TOURGUIDE_PKG_DETAIL_SELECT
■ DESCRIPTION				: 여행가이드 일정 정보 검색
■ INPUT PARAMETER			: 
	@RES_CODE VARCHAR(20)	: 예약코드
	@TG_CODE VARCHAR(10)	: 여가코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_WEB_RES_TOURGUIDE_PKG_DETAIL_SELECT 'RP1307022383', '10203'

	exec XP_WEB_RES_TOURGUIDE_PKG_DETAIL_SELECT 'RH1306247910', '50202'

	exec XP_WEB_RES_TOURGUIDE_PKG_DETAIL_SELECT 'RP1306269436', '10204'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-07-03		김성호			최초생성
   2014-07-28		정지용			쇼핑정보 및 옵션정보 추가
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_WEB_RES_TOURGUIDE_PKG_DETAIL_SELECT]
(
	@RES_CODE	VARCHAR(20),
	@TG_CODE	VARCHAR(10)
)

AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @MASTER_CODE VARCHAR(10), @PRO_CODE VARCHAR(20), @PRICE_SEQ INT, @TG_TYPE VARCHAR(1);

	SELECT @MASTER_CODE = A.MASTER_CODE, @PRO_CODE = A.PRO_CODE, @PRICE_SEQ = A.PRICE_SEQ
		, @TG_TYPE = (
			CASE
				WHEN A.PRO_TYPE = 1 AND A.NEW_TEAM_CODE = 514 THEN 'B'
				WHEN A.PRO_TYPE = 1 AND B.ATT_CODE = 'F' THEN 'F'
				WHEN A.PRO_TYPE = 2 THEN 'A'
				WHEN A.PRO_TYPE = 3 THEN 'H'
				ELSE 'P'
			END
		)
	FROM RES_MASTER_damo A WITH(NOLOCK)
	LEFT JOIN PKG_MASTER B WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE
	WHERE RES_CODE = @RES_CODE;

	/* 행사, 자유, 부산 일정 */
	IF @TG_CODE LIKE '_0202' AND @TG_TYPE <> 'H'
	BEGIN
		--행사정보
		SELECT A.PRO_CODE, A.PRO_NAME, A.TOUR_NIGHT, A.TOUR_DAY, A.TOUR_JOURNEY
		FROM PKG_DETAIL A WITH(NOLOCK)
		WHERE A.PRO_CODE = @PRO_CODE AND A.SHOW_YN = 'Y'

		--일정정보
		EXEC DBO.XP_WEB_PKG_DETAIL_SCHEDULE_SELECT @PRO_CODE, @PRICE_SEQ
	END

	/* 호텔 일정 */
	ELSE IF @TG_CODE LIKE '_0202' AND @TG_TYPE = 'H'
	BEGIN
		-- 호텔정보 조회
		SELECT 
			B.CNT_CODE, B.MASTER_CODE, B.MASTER_NAME, B.CITY_CODE, E.KOR_NAME AS CITY_NAME, F.REGION_CODE, F.KOR_NAME AS NATION_NAME, B.HTL_GRADE, C.DESCRIPTION, C.CNT_CODE,
			C.GPS_X, C.GPS_Y, D.ADDRESS, D.TEL_NUMBER, D.FAX_NUMBER, D.SHORT_LOCATION, D.DETAIL_LOCATION, D.ROOM_INFO, ISNULL(B.POINT_RATE,0) AS POINT_RATE, (
				SELECT TOP 1 ('/CONTENT/'+BB.REGION_CODE+'/'+BB.NATION_CODE+'/'+RTRIM(BB.STATE_CODE)+'/'+BB.CITY_CODE+'/IMAGE/'+(CASE WHEN BB.FILE_NAME_M <> '' THEN BB.FILE_NAME_M ELSE BB.FILE_NAME_S END))
				FROM INF_FILE_MANAGER AA WITH(NOLOCK) 
				INNER JOIN INF_FILE_MASTER BB WITH(NOLOCK) ON BB.FILE_CODE = AA.FILE_CODE AND BB.FILE_TYPE = 1  
				WHERE AA.CNT_CODE = C.CNT_CODE  
			) AS IMG_URL, (
				SELECT TOP 1 EVT_SEQ 
				FROM HTL_EVENT AS AA WITH(NOLOCK)  
				WHERE AA.MASTER_CODE = B.MASTER_CODE AND GETDATE() BETWEEN EVT_START_DATE AND EVT_END_DATE AND USE_YN = 'Y'
			) AS EVT_SEQ
		FROM
		HTL_MASTER B WITH(NOLOCK)
		LEFT JOIN INF_MASTER C WITH(NOLOCK) ON C.CNT_CODE = B.CNT_CODE  
		LEFT JOIN INF_HOTEL D WITH(NOLOCK) ON D.CNT_CODE = C.CNT_CODE
		LEFT JOIN PUB_CITY E WITH(NOLOCK) ON B.CITY_CODE = E.CITY_CODE
		LEFT JOIN PUB_NATION F WITH(NOLOCK) ON B.NATION_CODE = F.NATION_CODE
		WHERE B.MASTER_CODE = @MASTER_CODE
		-- 호텔 부대시설
		SELECT CNT_CODE, ATT_SEQ, ATT_NAME, ATT_REMARK, SHOW_YN
		FROM INF_HOTEL_ATTRIBUTE WITH(NOLOCK)
		WHERE CNT_CODE IN (SELECT CNT_CODE FROM HTL_MASTER WITH(NOLOCK) WHERE MASTER_CODE = @MASTER_CODE) AND SHOW_YN = 'Y'
	END

	/* 행사, 자유, 부산 숙박지정보 */
	IF @TG_CODE LIKE '_0203'
	BEGIN
		-- 숙박지
		SELECT A.DAY_NUMBER, A.STAY_TYPE, A.STAY_INFO, B.MASTER_CODE, B.MASTER_NAME, C.GPS_X, C.GPS_Y, C.SHORT_DESCRIPTION, D.*
		FROM PKG_DETAIL_PRICE_HOTEL A WITH(NOLOCK) 
		INNER JOIN HTL_MASTER B  WITH(NOLOCK) ON A.HTL_MASTER_CODE = B.MASTER_CODE
		LEFT OUTER JOIN INF_MASTER C  WITH(NOLOCK) ON B.CNT_CODE = C.CNT_CODE
		LEFT OUTER JOIN INF_HOTEL D  WITH(NOLOCK) ON C.CNT_CODE = D.CNT_CODE
		WHERE A.PRO_CODE = @PRO_CODE AND A.PRICE_SEQ = @PRICE_SEQ
		-- 속성
		SELECT * 
		FROM INF_HOTEL_ATTRIBUTE A WITH(NOLOCK) 
		WHERE A.CNT_CODE IN (
			SELECT CNT_CODE FROM HTL_MASTER WITH(NOLOCK) 
			WHERE MASTER_CODE IN (
				SELECT HTL_MASTER_CODE FROM PKG_DETAIL_PRICE_HOTEL A WITH(NOLOCK) 
				WHERE A.PRO_CODE = @PRO_CODE AND A.PRICE_SEQ = @PRICE_SEQ
			)
		)
	END

	/* 행사, 자유, 부산 관광지정보 */
	IF @TG_CODE LIKE '_0204'
	BEGIN
		--변수선언
		DECLARE @SCH_SEQ INT
		SELECT @SCH_SEQ = SCH_SEQ FROM PKG_DETAIL_PRICE WHERE PRO_CODE = @PRO_CODE AND PRICE_SEQ = @PRICE_SEQ
		-- 일자
		SELECT A.DAY_NUMBER, A.SCH_SEQ 
		FROM PKG_DETAIL_SCH_DAY A WITH(NOLOCK) 
		WHERE A.PRO_CODE = @PRO_CODE AND A.SCH_SEQ = @SCH_SEQ
		AND EXISTS(
			SELECT 1 FROM PKG_DETAIL_SCH_CONTENT B WITH(NOLOCK) 
			INNER JOIN INF_MASTER C  WITH(NOLOCK) ON B.CNT_CODE = C.CNT_CODE AND C.SHOW_YN = 'Y'
			WHERE A.PRO_CODE = B.PRO_CODE AND A.SCH_SEQ = B.SCH_SEQ AND A.DAY_SEQ = B.DAY_SEQ
		)
		ORDER BY A.DAY_NUMBER
		-- 관광지 정보
		SELECT
			A.DAY_NUMBER, C.CNT_CODE, D.KOR_TITLE, D.ORG_TITLE, D.ENG_TITLE, D.DESCRIPTION, D.GPS_X, D.GPS_Y, D.SHOW_YN
			, E.ADDRESS, E.PHONE, E.HOMEPAGE, E.PRICE, E.TRAFFIC, E.CHECK_POINT, E.OP_TIME
			, (SELECT AVG(GRADE) FROM INF_COMMENT  WITH(NOLOCK) WHERE CNT_CODE = D.CNT_CODE) AS [STAR_POINT]
			, (SELECT COUNT(*) FROM INF_COMMENT  WITH(NOLOCK) WHERE CNT_CODE = D.CNT_CODE) AS [PAR_NUM]
		FROM PKG_DETAIL_SCH_DAY A WITH(NOLOCK) 
		INNER JOIN PKG_DETAIL_SCH_CITY B  WITH(NOLOCK) ON A.PRO_CODE = B.PRO_CODE AND A.SCH_SEQ = B.SCH_SEQ AND A.DAY_SEQ = B.DAY_SEQ
		INNER JOIN PKG_DETAIL_SCH_CONTENT C  WITH(NOLOCK) ON B.PRO_CODE = C.PRO_CODE AND B.SCH_SEQ = C.SCH_SEQ AND B.DAY_SEQ = C.DAY_SEQ AND B.CITY_SEQ = C.CITY_SEQ
		INNER JOIN INF_MASTER D  WITH(NOLOCK) ON C.CNT_CODE = D.CNT_CODE
		INNER JOIN INF_TRAVEL E  WITH(NOLOCK) ON D.CNT_CODE = E.CNT_CODE
		WHERE A.PRO_CODE = @PRO_CODE AND A.SCH_SEQ = @SCH_SEQ AND D.SHOW_YN = 'Y'
		ORDER BY A.DAY_NUMBER, B.CITY_SHOW_ORDER, C.CNT_SHOW_ORDER
	END

	IF @TG_CODE LIKE '_0205'
	BEGIN
		--행사정보
		SELECT B.PKG_INCLUDE, B.PKG_NOT_INCLUDE, A.PKG_SHOPPING_REMARK, A.PKG_TOUR_REMARK, A.OPTION_REMARK, A.HOTEL_REMARK, A.PKG_REMARK, A.PKG_INC_SPECIAL, PM.SAFE_DATE, PM.SAFE_REMARK_1, PM.SAFE_REMARK_2, PM.SAFE_REMARK_3
		FROM PKG_DETAIL A WITH(NOLOCK)
		INNER JOIN PKG_MASTER PM WITH(NOLOCK) ON A.MASTER_CODE = PM.MASTER_CODE
		INNER JOIN PKG_DETAIL_PRICE B WITH(NOLOCK) ON A.PRO_CODE = B.PRO_CODE
		WHERE A.PRO_CODE = @PRO_CODE AND B.PRICE_SEQ = @PRICE_SEQ AND A.SHOW_YN = 'Y'

		-- 쇼핑정보
		SELECT PRO_CODE,SHOP_SEQ,SHOP_NAME,SHOP_PLACE,SHOP_TIME,SHOP_REMARK FROM PKG_DETAIL_SHOPPING WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE;

		-- 옵션정보
		SELECT PRO_CODE, OPT_SEQ, OPT_NAME, OPT_CONTENT, OPT_PRICE, OPT_USETIME, OPT_REPLACE, OPT_PLACE, OPT_COMPANION FROM PKG_DETAIL_OPTION WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE;
	END

END

GO
