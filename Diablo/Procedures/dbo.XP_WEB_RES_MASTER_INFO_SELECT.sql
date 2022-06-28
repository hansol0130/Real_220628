USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_WEB_RES_MASTER_INFO_SELECT
■ DESCRIPTION				: 예약된 상품 정보 OR 상품정보 보기 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: XP_WEB_RES_MASTER_INFO_SELECT 'RP1705107676'
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-09		박형만			최초생성
   2013-07-05		박형만			팀대표번호 keynuymber 추가 ,  호텔 조식여부  추가 
   2013-09-10		박형만			모바일 페이지용
   2013-10-28		박형만			FILE_TYPE 추가 
   2014-12-09		박형만			호텔 SALE_COM_CODE 추가 
   2015-07-08		박형만			ARR_DEP_DATE -> ARR_ARR_DATE  , SALE_COM_CODE 추가 
   2015-07-21		정지용			국내항공이고 편도일때 도착일 추가
   2015-08-26		박형만			항공 예약상태에 관계 없이 전체 출발자 금액 더하기 필드추가  TOTAL_PRICE2
   2015-11-09		박형만			국내항공이고 편도일때 도착시간 잘못 나오는것 수정 
   2016-01-11		박형만			제휴판매사 담당자가 접수자가 나오도록 수정 
   2016-08-11		박형만			BTMS복지몰 ,접수시 담당자가 접수자가 나오도록 수정 
   2016-10-21		박형만			PROVIDER 추가 
   2017-02-22		박형만			항공 TICKET_STATUS 추가 (티몬)
   2017-03-17		박형만			항공 CXL_REQ_YN , CXL_REQ_DATE 추가 (티몬)
   2017-04-18		박형만			제휴사 ALT_MEM_NO 추가 (티몬)
   2017-04-27		박형만			항공 DC_PRICE 제외 한 ORG_PRICE 조회 , DC_PRICE 조회  (티몬
   2017-08-09		박형만			항공 CXL_DATE 표시  , PAY_REQ_DATE 표시 (티몬)
   2017-09-28		박형만			APIS_CNT 추가 , 여행자계약서추가 , 항공 항공코드 , 루팅정보 추가
   2017-10-10		박형만			마이트래블가이드 사용여부
   2017-11-03		박형만			DEP_DEP_DATE , ARR_ARR_DATE , DEP_DEP_CITY_NAME 추가  
   2018-07-23		박형만			항공출발자 금액 정상 출발자만 더하기 
   2019-02-28		박형만			롯데카드는 접수자가 나오도록\
   2019-10-01		김성호			패키지 좌석코드 항목 추가
   2019-10-18		박형만			출발확정여부 항목 추가 
================================================================================================================*/ 
CREATE PROC [dbo].[XP_WEB_RES_MASTER_INFO_SELECT]
	@RES_CODE RES_CODE 
AS 

DECLARE @PRO_TYPE INT 
DECLARE @PROVIDER INT 
DECLARE @RES_STATE INT 
DECLARE @EMP_CODE VARCHAR(10)

SELECT @PRO_TYPE =PRO_TYPE , @PROVIDER = PROVIDER , @RES_STATE = RES_STATE FROM RES_MASTER_damo WHERE RES_CODE = @RES_CODE 

--신한,롯데  , BTMS 복지몰 접수상태일때만 
IF( @PROVIDER IN ( 15 , 17 )  OR  (@PROVIDER = 35 AND @RES_STATE = 0  )  )
BEGIN
	SELECT @EMP_CODE = SALE_EMP_CODE FROM RES_MASTER_damo WHERE RES_CODE = @RES_CODE   --접수자 
END 
ELSE
BEGIN
	SELECT @EMP_CODE = NEW_CODE FROM RES_MASTER_damo WHERE RES_CODE = @RES_CODE -- 담당자 
END 
 

--패키지 = 1, 항공 = 2, 호텔 = 3,
IF( @PRO_TYPE = 1 )
BEGIN
	SELECT 
		A.PRO_TYPE, A.RES_STATE, A.PROVIDER,
		A.RES_CODE, A.PRO_NAME, A.PRO_CODE, A.PRICE_SEQ, A.NEW_DATE, 
		A.CUS_NO, A.RES_NAME, A.NOR_TEL1, A.NOR_TEL2, A.NOR_TEL3, A.RES_EMAIL,
		
		CASE WHEN D.SEAT_CODE IS NOT NULL THEN D.DEP_DEP_DATE ELSE B.DEP_DATE END AS DEP_DATE, 
		D.DEP_DEP_DATE,D.DEP_ARR_DATE,
		CASE WHEN D.SEAT_CODE IS NOT NULL THEN D.ARR_ARR_DATE ELSE B.ARR_DATE END AS ARR_DATE, 
		D.ARR_DEP_DATE,D.ARR_ARR_DATE,	
		
		D.DEP_DEP_TIME , D.DEP_ARR_TIME , 
		D.ARR_DEP_TIME , D.ARR_ARR_TIME , 

		D.DEP_TRANS_CODE ,( SELECT KOR_NAME FROM PUB_AIRLINE WHERE AIRLINE_CODE = D.DEP_TRANS_CODE ) AS DEP_TRANS_NAME,  D.DEP_TRANS_NUMBER ,
		D.ARR_TRANS_CODE ,( SELECT KOR_NAME FROM PUB_AIRLINE WHERE AIRLINE_CODE = D.ARR_TRANS_CODE ) AS ARR_TRANS_NAME,  D.ARR_TRANS_NUMBER ,

		(SELECT KOR_NAME FROM PUB_CITY WHERE CITY_CODE = ( SELECT CITY_CODE FROM PUB_AIRPORT WHERE AIRPORT_CODE = D.DEP_DEP_AIRPORT_CODE )) AS DEP_DEP_CITY_NAME,
		(SELECT KOR_NAME FROM PUB_CITY WHERE CITY_CODE = ( SELECT CITY_CODE FROM PUB_AIRPORT WHERE AIRPORT_CODE = D.DEP_ARR_AIRPORT_CODE )) AS DEP_ARR_CITY_NAME,
		(SELECT KOR_NAME FROM PUB_CITY WHERE CITY_CODE = ( SELECT CITY_CODE FROM PUB_AIRPORT WHERE AIRPORT_CODE = D.ARR_DEP_AIRPORT_CODE )) AS ARR_DEP_CITY_NAME,
		(SELECT KOR_NAME FROM PUB_CITY WHERE CITY_CODE = ( SELECT CITY_CODE FROM PUB_AIRPORT WHERE AIRPORT_CODE = D.ARR_ARR_AIRPORT_CODE )) AS ARR_ARR_CITY_NAME,

		B.TOUR_DAY , B.TOUR_NIGHT, B.SEAT_CODE, 
		F.REGION_CODE, F.NATION_CODE, F.STATE_CODE, F.CITY_CODE, F.FILE_NAME_S, F.FILE_TYPE , 

		dbo.FN_RES_GET_RES_AGE_COUNT(A.RES_CODE, 0) AS ADULT_COUNT,
		dbo.FN_RES_GET_RES_AGE_COUNT(A.RES_CODE, 1) AS CHILD_COUNT,
		dbo.FN_RES_GET_RES_AGE_COUNT(A.RES_CODE, 2) AS INFANT_COUNT,
		DBO.FN_RES_GET_TOTAL_PRICE(A.RES_CODE) AS TOTAL_PRICE,
		DBO.FN_RES_GET_PAY_PRICE(A.RES_CODE) AS PAY_PRICE,
		A.LAST_PAY_DATE, A.CUS_REQUEST, A.CUS_RESPONSE,
		C.EMP_CODE, C.KOR_NAME, C.INNER_NUMBER1, C.INNER_NUMBER2, C.INNER_NUMBER3, 
		C.FAX_NUMBER1, C.FAX_NUMBER2, C.FAX_NUMBER3, C.EMAIL AS EMP_EMAIL, C.GREETING , 
		C.TEAM_CODE , DBO.XN_COM_GET_TEAM_NAME(C.EMP_CODE)  AS TEAM_NAME  ,
		( SELECT KEY_NUMBER FROM EMP_TEAM WITH(NOLOCK) WHERE TEAM_CODE = C.TEAM_CODE )  AS KEY_NUMBER  ,

		B.SHOW_YN AS [PKG_SHOW_YN],

		CASE WHEN H.CONTRACT_NO > 0 THEN 'Y' ELSE 'N' END AS CONT_YN ,  --여행자 계약서 생성여부
		H.CFM_YN AS CFM_YN ,  --여행자 계약서 동의여부
		DBO.FN_RES_GET_APIS_COUNT(A.RES_CODE) AS APIS_CNT ,
		(SELECT TOP 1 CUS_NAME FROM RES_CUSTOMER_DAMO WITH(NOLOCK) WHERE RES_CODE = A.RES_CODE AND AGE_TYPE = 0 AND RES_STATE = 0 ORDER BY SEQ_NO ASC ) AS FIRST_CUS_NAME ,
		DBO.XN_APP_RES_USE_YN(A.RES_CODE) AS TRAVEL_GUIDE_YN ,
		ISNULL((SELECT TOP 1 'Y' FROM APP_FREETOUR_GUIDEFILE WITH(NOLOCK) WHERE RES_CODE = A.RES_CODE ),'N') AS FREE_GUIDE_YN ,
		B.DEP_CFM_YN 
	FROM RES_MASTER_damo A WITH(NOLOCK)	
		INNER JOIN PKG_DETAIL B WITH(NOLOCK) 
			ON A.PRO_CODE = B.PRO_CODE
		LEFT JOIN EMP_MASTER C WITH(NOLOCK) 
			ON C.EMP_CODE = @EMP_CODE 
		LEFT JOIN PRO_TRANS_SEAT D WITH(NOLOCK) 
			ON B.SEAT_CODE = D.SEAT_CODE
		LEFT JOIN PKG_MASTER E WITH(NOLOCK) 
			ON B.MASTER_CODE = E.MASTER_CODE
		LEFT JOIN INF_FILE_MASTER F WITH(NOLOCK) 
			ON E.MAIN_FILE_CODE = F.FILE_CODE AND E.SHOW_YN = 'Y'

		LEFT JOIN RES_CONTRACT H WITH(NOLOCK)
			ON A.RES_CODE = H.RES_CODE 
			AND H.CONTRACT_NO = (SELECT MAX(CONTRACT_NO) FROM RES_CONTRACT WHERE RES_CODE = H.RES_CODE  )

	WHERE A.RES_CODE = @RES_CODE
	ORDER BY A.RES_CODE
END 
ELSE IF (  @PRO_TYPE = 2 )  --항공 
BEGIN

	SELECT 
		A.PRO_TYPE,A.RES_STATE ,A.PROVIDER ,
		A.RES_CODE, A.PRO_NAME, A.PRO_CODE,A.PRICE_SEQ , A.NEW_DATE , 
		A.CUS_NO , A.RES_NAME, A.NOR_TEL1 , A.NOR_TEL2 , A.NOR_TEL3 , A.RES_EMAIL , 
		B.ROUTING_TYPE,
		-- 무조건 항공 정보에서 , 없으면 PKG_DETAIL 에서 
		CASE 
			WHEN B.DEP_DEP_DATE IS NOT NULL THEN CONVERT(DATETIME,CONVERT(VARCHAR(10),B.DEP_DEP_DATE,121) + ' ' + B.DEP_DEP_TIME + ':00')
			ELSE A.DEP_DATE END AS DEP_DATE,-- 추가
		CASE 
			--국내 편도는 도착일을 출발도착시간으로 
			WHEN B.INTER_YN = 'N' AND B.ROUTING_TYPE = 1 THEN 
				CASE WHEN B.DEP_ARR_DATE IS NOT NULL THEN CONVERT(DATETIME,CONVERT(VARCHAR(10),B.DEP_ARR_DATE,121) + ' ' + B.DEP_ARR_TIME + ':00')
				ELSE B.DEP_ARR_DATE END
			ELSE 
				CASE WHEN B.ARR_ARR_DATE IS NOT NULL THEN CONVERT(DATETIME,CONVERT(VARCHAR(10),B.ARR_ARR_DATE,121) + ' ' + B.ARR_ARR_TIME + ':00')
				ELSE B.ARR_ARR_DATE END 
			END AS ARR_DATE, 
		--CASE 
		--	WHEN B.INTER_YN = 'N' AND B.ROUTING_TYPE = 1 THEN  A.DEP_DATE
		--	ELSE
		--		B.DEP_DEP_DATE END AS DEP_DATE,-- 추가
		--CASE 
		--	WHEN B.INTER_YN = 'N' AND B.ROUTING_TYPE = 1 THEN A.ARR_DATE
		--	ELSE
		--		B.ARR_ARR_DATE END AS ARR_DATE,-- 추가
		--B.DEP_DEP_DATE AS DEP_DATE , 
		--B.ARR_ARR_DATE AS ARR_DATE , 
		B.AIRLINE_CODE AS DEP_TRANS_CODE ,
		dbo.FN_RES_GET_RES_AGE_COUNT(A.RES_CODE, 0) AS ADULT_COUNT,
		dbo.FN_RES_GET_RES_AGE_COUNT(A.RES_CODE, 1) AS CHILD_COUNT,
		dbo.FN_RES_GET_RES_AGE_COUNT(A.RES_CODE, 2) AS INFANT_COUNT,
		(SUM_SALE_PRICE + SUM_CHG_PRICE + SUM_TAX_PRICE + SUM_PENALTY_PRICE) AS ORG_PRICE, 
		(SUM_DC_PRICE) AS DC_PRICE, 
		DBO.FN_RES_GET_TOTAL_PRICE(A.RES_CODE) AS TOTAL_PRICE,
		(SUM_SALE_PRICE - SUM_DC_PRICE + SUM_CHG_PRICE + SUM_TAX_PRICE + SUM_PENALTY_PRICE) AS TOTAL_PRICE2 ,
		DBO.FN_RES_GET_PAY_PRICE(A.RES_CODE) AS PAY_PRICE,
		A.LAST_PAY_DATE, A.CUS_REQUEST, A.CUS_RESPONSE,
		C.EMP_CODE, C.KOR_NAME, C.INNER_NUMBER1, C.INNER_NUMBER2, C.INNER_NUMBER3, 
		C.FAX_NUMBER1, C.FAX_NUMBER2, C.FAX_NUMBER3, C.EMAIL AS EMP_EMAIL, C.GREETING , 
		C.TEAM_CODE , DBO.XN_COM_GET_TEAM_NAME(C.EMP_CODE)  AS TEAM_NAME  ,
		( SELECT KEY_NUMBER FROM EMP_TEAM WITH(NOLOCK) WHERE TEAM_CODE = C.TEAM_CODE )  AS KEY_NUMBER  ,

		(CASE WHEN G.SEAT_OK_COUNT > 0 THEN 'N' ELSE 'Y' END) AS SEAT_YN ,
		B.PNR_CODE1 , B.PNR_CODE2 ,
		A.SALE_COM_CODE  ,
		ISNULL((SELECT TOP 1 TICKET_STATUS FROM DSR_TICKET WITH(NOLOCK) WHERE RES_CODE = A.RES_CODE AND GDS IN (2,5) ORDER BY RES_SEQ_NO ASC ),0) AS TICKET_STATUS ,
		B.CXL_REQ_YN , B.CXL_REQ_DATE , A.CXL_DATE , B.PAY_REQ_DATE ,
		(SELECT TOP 1 ALT_RES_CODE FROM RES_ALT_MATCHING WITH(NOLOCK) WHERE RES_CODE  = A.RES_CODE ) AS SUP_RES_CODE ,
		(SELECT TOP 1 ALT_MEM_NO FROM RES_ALT_MATCHING WITH(NOLOCK) WHERE RES_CODE  = A.RES_CODE ) AS SUP_MEM_NO ,
		--(SELECT STUFF((
		--	SELECT ('-' + DEP_CITY_NAME + '(' + DEP_AIRPORT_CODE + ')' + '-' + ARR_CITY_NAME + '(' + ARR_AIRPORT_CODE + ')') AS [text()]
		--	FROM (
		--		SELECT SEQ_NO, DEP_AIRPORT_CODE, ARR_AIRPORT_CODE
		--			, (SELECT KOR_NAME FROM PUB_CITY WITH(NOLOCK) WHERE CITY_CODE IN (SELECT CITY_CODE FROM PUB_AIRPORT WITH(NOLOCK) WHERE AIRPORT_CODE = DEP_AIRPORT_CODE)) AS [DEP_CITY_NAME]
		--			, (SELECT KOR_NAME FROM PUB_CITY WITH(NOLOCK) WHERE CITY_CODE IN (SELECT CITY_CODE FROM PUB_AIRPORT WITH(NOLOCK) WHERE AIRPORT_CODE = ARR_AIRPORT_CODE)) AS [ARR_CITY_NAME]
		--		FROM RES_SEGMENT WITH(NOLOCK) WHERE RES_CODE = A.RES_CODE
		--	) A
		--	FOR XML PATH('')
		--), 1, 1, '')) AS [JOURNEY] -- 여정 
		CASE WHEN H.CONTRACT_NO > 0 THEN 'Y' ELSE 'N' END AS CONT_YN ,  --여행자 계약서 생성여부
		H.CFM_YN AS CFM_YN ,  --여행자 계약서 동의여부
		DBO.FN_RES_GET_APIS_COUNT(A.RES_CODE) AS APIS_CNT ,
		(SELECT TOP 1 CUS_NAME FROM RES_CUSTOMER_DAMO WITH(NOLOCK) WHERE RES_CODE = A.RES_CODE AND AGE_TYPE = 0 AND RES_STATE = 0 ORDER BY SEQ_NO ASC ) AS FIRST_CUS_NAME ,
		CASE WHEN A.PRO_TYPE = 2 THEN dbo.FN_RES_AIR_GET_PRO_NAME(A.RES_CODE) END AS ROUTING_INFO ,
		DBO.XN_APP_RES_USE_YN(A.RES_CODE) AS TRAVEL_GUIDE_YN 
	FROM RES_MASTER_damo A WITH(NOLOCK)	
		INNER JOIN RES_AIR_DETAIL B WITH(NOLOCK) 
			ON A.RES_CODE = B.RES_CODE
		left JOIN 
		(
			SELECT RES_CODE, SUM(CASE WHEN SEAT_STATUS = 'HK' THEN 0 ELSE 1 END) AS SEAT_OK_COUNT
			FROM RES_SEGMENT WITH(NOLOCK)
			GROUP BY RES_CODE
		) G ON G.RES_CODE = A.RES_CODE

		left JOIN 
		(
			SELECT
				RES_CODE ,
				SUM(ISNULL(SALE_PRICE, 0)) AS [SUM_SALE_PRICE],
				SUM(ISNULL(CHG_PRICE, 0)) AS [SUM_CHG_PRICE],
				SUM(ISNULL(DC_PRICE, 0)) AS [SUM_DC_PRICE],
				SUM(ISNULL(TAX_PRICE, 0)) AS [SUM_TAX_PRICE],
				SUM(ISNULL(PENALTY_PRICE, 0)) AS [SUM_PENALTY_PRICE]
			FROM RES_CUSTOMER_DAMO WITH(NOLOCK)
			WHERE RES_CODE = @RES_CODE
			AND RES_STATE = 0 -- 정상  출발자만 
			GROUP BY RES_CODE 
		) F ON F.RES_CODE = A.RES_CODE

		LEFT JOIN EMP_MASTER C WITH(NOLOCK) 
			ON A.NEW_CODE = C.EMP_CODE

		LEFT JOIN RES_CONTRACT H WITH(NOLOCK)
			ON A.RES_CODE = H.RES_CODE 
			AND H.CONTRACT_NO = (SELECT MAX(CONTRACT_NO) FROM RES_CONTRACT WHERE RES_CODE = H.RES_CODE  )

	WHERE A.RES_CODE = @RES_CODE
	ORDER BY RES_CODE
END 
ELSE IF (  @PRO_TYPE = 3 ) --호텔 
BEGIN

	-- 호텔 룸 정보
	DECLARE @ROOM_INFO VARCHAR(500)
	SET @ROOM_INFO  = '' 
	DECLARE @ROOM_NO INT 
	SET @ROOM_NO  = 1 
	WHILE EXISTS ( SELECT * FROM RES_HTL_ROOM_DETAIL WITH(NOLOCK) WHERE RES_CODE = @RES_CODE AND ROOM_NO = @ROOM_NO ) 
	BEGIN
		SET @ROOM_INFO  = @ROOM_INFO + (
			SELECT ROOM_NAME + ' ' + 
				CASE WHEN ROOM_TYPE = 1 THEN '싱글룸'  
					WHEN ROOM_TYPE = 2 THEN '더블룸' 
					WHEN ROOM_TYPE = 3 THEN '트윈룸'
					WHEN ROOM_TYPE = 4 THEN '트리플룸'
					WHEN ROOM_TYPE = 5 THEN '4인실' ELSE '' END + ' ' +  
				CONVERT(VARCHAR,ROOM_COUNT) + '개 * ' + CONVERT(VARCHAR, DATEDIFF( D, B.CHECK_IN , B.CHECK_OUT ) ) + '박'
				+ CASE WHEN BREAKFAST_YN ='Y' THEN'[조식포함]' ELSE '[조식불포함]' END 
			FROM RES_HTL_ROOM_DETAIL A WITH(NOLOCK)
				INNER JOIN RES_HTL_ROOM_MASTER B WITH(NOLOCK) 
					ON A.RES_CODE = B.RES_CODE 
			WHERE A.RES_CODE = @RES_CODE
			AND A.ROOM_NO = @ROOM_NO 
		) + '<BR>' 

		SET @ROOM_NO = @ROOM_NO + 1 
	END 

	--호텔예약 정보
	SELECT 
		A.PRO_TYPE,A.RES_STATE ,A.PROVIDER ,
		A.RES_CODE, A.PRO_NAME, A.PRO_CODE,A.PRICE_SEQ , A.NEW_DATE , 
		A.CUS_NO , A.RES_NAME, A.NOR_TEL1 , A.NOR_TEL2 , A.NOR_TEL3 , A.RES_EMAIL , 
		B.CHECK_IN AS DEP_DATE , 
		B.CHECK_OUT AS ARR_DATE ,
		dbo.FN_RES_GET_RES_AGE_COUNT(A.RES_CODE, 0) AS ADULT_COUNT,
		dbo.FN_RES_GET_RES_AGE_COUNT(A.RES_CODE, 1) AS CHILD_COUNT,
		dbo.FN_RES_GET_RES_AGE_COUNT(A.RES_CODE, 2) AS INFANT_COUNT,
		DBO.FN_RES_HTL_GET_TOTAL_PRICE(A.RES_CODE)  AS TOTAL_PRICE,
		DBO.FN_RES_GET_PAY_PRICE(A.RES_CODE) AS PAY_PRICE,
		A.LAST_PAY_DATE, A.CUS_REQUEST, A.CUS_RESPONSE,
		C.EMP_CODE, C.KOR_NAME, C.INNER_NUMBER1, C.INNER_NUMBER2, C.INNER_NUMBER3, 
		C.FAX_NUMBER1, C.FAX_NUMBER2, C.FAX_NUMBER3, C.EMAIL AS EMP_EMAIL, C.GREETING , 
		C.TEAM_CODE , DBO.XN_COM_GET_TEAM_NAME(C.EMP_CODE)  AS TEAM_NAME  ,
		( SELECT KEY_NUMBER FROM EMP_TEAM WITH(NOLOCK) WHERE TEAM_CODE = C.TEAM_CODE )  AS KEY_NUMBER  ,

		B.ROOM_YN , B.LAST_CXL_DATE , DATEDIFF( D, B.CHECK_IN , B.CHECK_OUT ) AS NIGHTS ,
		@ROOM_INFO AS ROOM_INFO ,
		A.SALE_COM_CODE  ,
		B.SUP_RES_CODE 

	FROM RES_MASTER_damo A WITH(NOLOCK)	
		INNER JOIN RES_HTL_ROOM_MASTER B WITH(NOLOCK) 
			ON A.RES_CODE = B.RES_CODE
		LEFT JOIN EMP_MASTER C WITH(NOLOCK) 
			ON A.NEW_CODE = C.EMP_CODE
	WHERE A.RES_CODE = @RES_CODE
	ORDER BY RES_CODE
	
END 



GO