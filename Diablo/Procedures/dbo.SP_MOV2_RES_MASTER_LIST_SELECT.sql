USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_MOV2_RES_MASTER_LIST_SELECT
■ DESCRIPTION				: 예약리스트 가져오기
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 



declare @p6 int
set @p6=157
exec SP_MOV2_RES_MASTER_LIST_SELECT @PRO_TYPE=0,@CUS_NO=4797216,@PAGE_INDEX=1,@PAGE_SIZE=10,@ORDER_BY=1,@TOTAL_COUNT=@p6 output
select @p6


■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   CITY_NAME
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-30		박형만			최초생성
   2013-06-18		박형만			호텔체크아웃날짜 수정
   2013-07-19		박형만			TRANSFER_TYPE 추가 
   2013-08-06		김성호			상품 표시 여부 항목 추가
   2013-09-06		박형만			항공스케쥴및도착시간표시, 모바일정렬순서 추가 ORDER_BY
   2013-10-28		박형만			FILE_TYPE 추가 , 모바일ORDER_BY=1은 정상예약-출발일지난것-취소순
   2013-11-12		박형만			외부예약상품 URL 필드 추가(ALT_PRO_URL) 
   2014-05-20		박형만			비회원은 출발일 30일 지난것 표시 안함 
   2014-06-17		박형만			노출여부 VIEW_YN 컬럼조건 추가 
   2014-12-09		박형만			저스트고 예약은 제외 (웹서비스에서 조회됨 ) 
   2015-03-25		박형만			판매처 , 결제금액조회
   2015-07-17		박형만			항공관련 ARR_dATE 수정 
   2015-08-31		박형만			공동운항 OP_AIRLINE 추가 
   2015-11-30		박형만			LAST_PAY_DATE 추가 
   2017-09-28		박형만			모바일앱,여권정보입력건수,출발인원,담당자정보,좌석등급,출발대표자여부,정렬순서 수정 
   2017-10-10		박형만			마이트래블가이드 사용여부,티켓발권여부추가 .자유여행 개별일정여부
   2017-10-25		박형만			모바일 진행중예약,출발완료예약->도착완료예약으로순으로(전날도착까지표시)
   2017-11-04		김성호			모바일전용으로 생성
   2018-01-02		박형만			호텔 DB 에서 MASTER_CODE (HOTEL_CODE ) 불러오기 
   2018-03-15		박형만			PRO_TYPE 있을때 A.NEW_DATE 로 정렬되던 현상 수정 ORDER BY ROWNUMBER 로 수정 
   2018-08-08		박형만			RES_LEADER_NAME 올바르게 나오도록 수정 
================================================================================================================*/ 
CREATE PROC [dbo].[SP_MOV2_RES_MASTER_LIST_SELECT]
	@CUS_NO			INT,
	@PRO_TYPE		INT, -- 예약타입 0:전체,1:패키지,2:항공,3:호텔
	@PAGE_INDEX		INT,
	@PAGE_SIZE		INT,
	@ORDER_BY		INT, --정렬순서
	@TOTAL_COUNT	INT OUTPUT
AS 
BEGIN

--DECLARE @CUS_NO		INT,
--@PRO_TYPE	INT, -- 0 전체 
--@PAGE_INDEX  INT,
--@PAGE_SIZE  INT,
--@ORDER_BY	int , 
--@TOTAL_COUNT INT --OUTPUT

--SET @CUS_NO = 4228549
--SET @PRO_TYPE = 0
--SET @PAGE_SIZE = 10 
--set @ORDER_BY = 1 
--SET @PAGE_INDEX = 1 

	--변수 선언
	DECLARE @NOR_TEL1 VARCHAR(6), @NOR_TEL2 VARCHAR(5), @NOR_TEL3 VARCHAR(4), @EMAIL VARCHAR(40), @MEM_YN VARCHAR(1)  --정회원 여부

	-- 고객 정보 검색
	SELECT @MEM_YN = (CASE WHEN B.CUS_NO > 0 THEN 'Y' ELSE 'N' END)
		, @NOR_TEL1 = ISNULL(B.NOR_TEL1, A.NOR_TEL1)
		, @NOR_TEL2 = ISNULL(B.NOR_TEL2, A.NOR_TEL2)
		, @NOR_TEL3 = ISNULL(B.NOR_TEL3, A.NOR_TEL3)
	FROM CUS_CUSTOMER_damo A WITH(NOLOCK)
	LEFT JOIN CUS_MEMBER B WITH(NOLOCK) ON A.CUS_NO = B.CUS_NO
	WHERE A.CUS_NO = @CUS_NO;


	--총갯수
	SELECT @TOTAL_COUNT = COUNT(*) FROM 
	(
		SELECT A.RES_CODE 
		FROM RES_MASTER_damo A WITH(NOLOCK) 
		WHERE A.CUS_NO = @CUS_NO AND (@PRO_TYPE IN (0, 9) OR PRO_TYPE = @PRO_TYPE)
			AND ((@MEM_YN = 'N' AND A.DEP_DATE > DATEADD(DD,-30,GETDATE())) OR @MEM_YN = 'Y')  --비회원 출발일 30일 지난것은 표시 안함 
			AND A.VIEW_YN ='Y' --노출여부
			--AND A.SALE_COM_CODE <> '92474' --JUSTGO 제외
		UNION ALL
		SELECT A.RES_CODE
		FROM RES_MASTER_damo A WITH(NOLOCK) 
		INNER JOIN RES_CUSTOMER_DAMO B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE AND A.CUS_NO <> B.CUS_NO
		WHERE B.CUS_NO = @CUS_NO AND (@PRO_TYPE IN (0, 9) OR PRO_TYPE = @PRO_TYPE)
			AND ((@MEM_YN = 'N' AND A.DEP_DATE > DATEADD(DD,-30,GETDATE())) OR @MEM_YN = 'Y')  --비회원 출발일 30일 지난것은 표시 안함 
			AND B.RES_STATE = 0  --정상출발자만 
			AND B.VIEW_YN ='Y'  --노출여부
			--AND A.SALE_COM_CODE <> '92474' --JUSTGO 제외
		GROUP BY A.RES_CODE
	) TBL;


	WITH CUS_RES_LIST AS (
		SELECT A.RES_CODE, 'Y' AS MASTER_YN
		FROM RES_MASTER_damo A WITH(NOLOCK) 
		WHERE A.CUS_NO = @CUS_NO AND (@PRO_TYPE IN (0, 9) OR PRO_TYPE = @PRO_TYPE)
			AND ((@MEM_YN = 'N' AND A.DEP_DATE > DATEADD(DD,-30,GETDATE())) OR @MEM_YN = 'Y')  --비회원 출발일 30일 지난것은 표시 안함 
			AND A.VIEW_YN ='Y' --노출여부
			--AND A.SALE_COM_CODE <> '92474' --JUSTGO 제외
		UNION ALL
		SELECT A.RES_CODE, MAX('N') AS MASTER_YN
		FROM RES_MASTER_damo A WITH(NOLOCK) 
		INNER JOIN RES_CUSTOMER_DAMO B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE AND A.CUS_NO <> B.CUS_NO
		WHERE B.CUS_NO = @CUS_NO AND (@PRO_TYPE IN (0, 9) OR PRO_TYPE = @PRO_TYPE)
			AND ((@MEM_YN = 'N' AND A.DEP_DATE > DATEADD(DD,-30,GETDATE())) OR @MEM_YN = 'Y')  --비회원 출발일 30일 지난것은 표시 안함 
			AND B.RES_STATE = 0  --정상출발자만 
			AND B.VIEW_YN ='Y'  --노출여부
			--AND A.SALE_COM_CODE <> '92474' --JUSTGO 제외
		GROUP BY A.RES_CODE
	), RES_PAGING_LIST AS (
		SELECT A.RES_CODE, Z.MASTER_YN, (
			SELECT TOP 1 AA.CUS_NO
			FROM RES_CUSTOMER_damo AA WITH(NOLOCK) 
			WHERE AA.RES_CODE = A.RES_CODE AND AA.RES_STATE = 0 
			ORDER BY (CASE WHEN A.CUS_NO = AA.CUS_NO THEN 0 ELSE AA.SEQ_NO END)
			) AS CUS_NO,(
			SELECT TOP 1 AA.CUS_NAME
			FROM RES_CUSTOMER_damo AA WITH(NOLOCK) 
			WHERE AA.RES_CODE = A.RES_CODE AND AA.RES_STATE = 0 
			ORDER BY (CASE WHEN A.CUS_NO = AA.CUS_NO THEN 0 ELSE AA.SEQ_NO END)
			) AS CUS_NAME
			, (ROW_NUMBER() OVER (ORDER BY 
				(CASE WHEN @ORDER_BY = 1 AND A.RES_STATE IN (7,8,9) THEN -2 WHEN @ORDER_BY = 1 AND IIF(A.ARR_DATE IS NULL, A.DEP_DATE, A.ARR_DATE) >= CONVERT(DATETIME,CAST(DATEADD(D,1,GETDATE()) as date)) THEN 0 ELSE -1 END) DESC,
				(CASE WHEN @ORDER_BY = 1 AND A.RES_STATE IN (7,8,9) THEN A.NEW_DATE ELSE '2999-01-01' END ) DESC , -- 취소예약은 최근등록순 
				(CASE WHEN @ORDER_BY = 1 AND IIF(A.ARR_DATE IS NULL, A.DEP_DATE, A.ARR_DATE) < CONVERT(DATETIME,CAST(DATEADD(D,1,GETDATE()) AS DATE)) THEN A.DEP_DATE ELSE '1900-01-01' END) DESC, -- 도착완료 예약은 최근출발일순 
				(CASE WHEN @ORDER_BY = 1 THEN A.DEP_DATE ELSE '1900-01-01' END) ASC,   -- 그외(정상미출발예약)은 출발일순
				A.NEW_DATE DESC  --   그외는 예약일순(PC)
			)) AS [ROWNUMBER]
		FROM CUS_RES_LIST Z
		INNER JOIN RES_MASTER_damo A WITH(NOLOCK) ON Z.RES_CODE = A.RES_CODE
		ORDER BY 
			(CASE WHEN @ORDER_BY = 1 AND A.RES_STATE IN (7,8,9) THEN -2 WHEN @ORDER_BY = 1 AND IIF(A.ARR_DATE IS NULL, A.DEP_DATE, A.ARR_DATE) >= CONVERT(DATETIME,CAST(DATEADD(D,1,GETDATE()) as date)) THEN 0 ELSE -1 END) DESC,
			(CASE WHEN @ORDER_BY = 1 AND A.RES_STATE IN (7,8,9) THEN A.NEW_DATE ELSE '2999-01-01' END ) DESC , -- 취소예약은 최근등록순 
			(CASE WHEN @ORDER_BY = 1 AND IIF(A.ARR_DATE IS NULL, A.DEP_DATE, A.ARR_DATE) < CONVERT(DATETIME,CAST(DATEADD(D,1,GETDATE()) AS DATE)) THEN A.DEP_DATE ELSE '1900-01-01' END) DESC, -- 도착완료 예약은 최근출발일순 
			(CASE WHEN @ORDER_BY = 1 THEN A.DEP_DATE ELSE '1900-01-01' END) ASC,   -- 그외(정상미출발예약)은 출발일순
			A.NEW_DATE DESC  --   그외는 예약일순(PC)
		OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
		ROWS ONLY
	)
	SELECT A.RES_CODE, A.PRICE_SEQ, A.RES_STATE, A.DEP_DATE, A.ARR_DATE, A.PRO_CODE, A.PRO_NAME, A.PRO_TYPE, A.LAST_PAY_DATE, A.CUS_RESPONSE, A.SALE_COM_CODE, Z.MASTER_YN,
		A.NEW_TEAM_NAME AS [TEAM_NAME], A.NEW_CODE AS [EMP_CODE], D.KOR_NAME AS [EMP_NAME],
		((CASE WHEN ISNULL(D.INNER_NUMBER1, '') = '' THEN '02' ELSE D.INNER_NUMBER1 END) + '-' +
		(CASE WHEN ISNULL(D.INNER_NUMBER2, '') = '' THEN '2188' ELSE D.INNER_NUMBER2 END) + '-' +
		(CASE WHEN ISNULL(D.INNER_NUMBER3,'') = '' THEN '2188' ELSE D.INNER_NUMBER3 END)) AS [EMP_NUMBER],
		B.SHOW_YN AS [PKG_SHOW_YN], B.TOUR_DAY, B.TOUR_NIGHT,
		A.RES_NAME ,
		Z.CUS_NAME AS [RES_LEADER_NAME],
		F.FARE_SEAT_TYPE, F.ROUTING_TYPE,
		H.FILE_CODE, H.REGION_CODE, H.NATION_CODE, H.STATE_CODE, H.CITY_CODE, H.FILE_NAME_S, H.FILE_TYPE,
		DBO.FN_RES_GET_PAY_PRICE(A.RES_CODE) AS [PAY_PRICE],
		DBO.FN_RES_GET_RES_ADULT_COUNT(A.RES_CODE) AS [ADT_CNT],
		DBO.FN_RES_GET_RES_CHILD_COUNT(A.RES_CODE) AS [CHD_CNT],
		DBO.FN_RES_GET_RES_BABY_COUNT(A.RES_CODE) AS [INF_CNT],
		(SELECT COUNT(*) FROM RES_CUSTOMER_DAMO RC, PPT_MASTER PT WHERE RC.RES_CODE = PT.RES_CODE AND RC.RES_CODE = A.RES_CODE AND RC.PPT_NO = PT.PPT_NO)  AS [APIS_CNT],
		(CASE WHEN A.PRO_TYPE IN (1,2) THEN DBO.XN_APP_RES_USE_YN(A.RES_CODE) ELSE 'N' END) AS [TRAVEL_GUIDE_YN],

		(SELECT AA.KOR_NAME FROM PUB_AIRLINE AA WITH(NOLOCK) WHERE AA.AIRLINE_CODE = (CASE WHEN A.PRO_TYPE = 1 THEN E.DEP_TRANS_CODE ELSE F.AIRLINE_CODE END)) AS [AIRLINE_NAME], 

		(CASE WHEN A.PRO_TYPE = 1 THEN ISNULL((SELECT TOP 1 'Y' FROM APP_FREETOUR_GUIDEFILE AA WITH(NOLOCK) WHERE AA.RES_CODE = A.RES_CODE), 'N') ELSE 'N' END) AS FREE_GUIDE_YN,
		(CASE WHEN A.PRO_TYPE = 1 THEN E.DEP_DEP_TIME ELSE F.DEP_DEP_TIME END) AS [DEP_DEP_TIME], --출발시간
		(CASE WHEN A.PRO_TYPE = 1 THEN E.DEP_ARR_TIME ELSE F.DEP_ARR_TIME END) AS [DEP_ARR_TIME], --출발도착
		(CASE WHEN A.PRO_TYPE = 2 THEN (SELECT SUM(CASE WHEN AA.SEAT_STATUS = 'HK' THEN 1 ELSE 0 END) - COUNT(*) FROM RES_SEGMENT AA WITH(NOLOCK) WHERE AA.RES_CODE = A.RES_CODE)
			ELSE 0 END
		) AS [HK_COUNT], --좌석별 확약건수 - 전체좌석 (0건이면 확정)
		(CASE WHEN A.PRO_TYPE = 2 THEN (SELECT TOP 1 AA.OP_AIRLINE_CODE FROM RES_SEGMENT AA WITH(NOLOCK) WHERE AA.RES_CODE = A.RES_CODE AND AA.OP_AIRLINE_CODE IS NOT NULL)
			ELSE NULL END
		) AS [OP_AIRLINE_CODE],
		(CASE WHEN A.PRO_TYPE = 2 THEN (SELECT AA.KOR_NAME FROM PUB_AIRLINE AA WITH(NOLOCK) WHERE AA.AIRLINE_CODE = (SELECT TOP 1 AAA.OP_AIRLINE_CODE FROM RES_SEGMENT AAA WITH(NOLOCK) WHERE AAA.RES_CODE = A.RES_CODE AND AAA.OP_AIRLINE_CODE IS NOT NULL))
			ELSE NULL END
		) AS [OP_AIRLINE_NAME], 
		(CASE WHEN A.PRO_TYPE = 2 THEN dbo.FN_RES_AIR_GET_PRO_NAME(A.RES_CODE) END) AS [ROUTING_INFO]  ,  --항공여정
		(CASE A.PRO_TYPE WHEN 3 THEN DBO.FN_RES_HTL_GET_TOTAL_PRICE(A.RES_CODE) ELSE DBO.FN_RES_GET_TOTAL_PRICE(A.RES_CODE) END) AS [TOTAL_PRICE],

		CASE WHEN A.PRO_TYPE = 3 THEN (SELECT AA.[SIGN] FROM PUB_REGION AA WITH(NOLOCK) WHERE AA.REGION_CODE = I.REGION_CODE) ELSE G.SIGN_CODE END AS [SIGN_CODE],
		CASE WHEN A.PRO_TYPE = 3 THEN DBO.FN_PUB_GET_REGION_NAME(I.REGION_CODE) ELSE DBO.FN_PUB_GET_REGION_NAME2(A.PRO_CODE) END AS [REGION_NAME],

		--호텔코드 
		CASE WHEN A.PRO_TYPE = 3 THEN  (SELECT AA.MASTER_CODE FROM RES_HTL_ROOM_MASTER AA WITH(NOLOCK) WHERE AA.RES_CODE = A.RES_CODE) ELSE '' END AS [MASTER_CODE],
		

		(CASE WHEN J.CONTRACT_NO > 0 THEN 'Y' ELSE 'N' END) AS CONT_YN ,  --여행자 계약서 생성여부
		J.CFM_YN AS [CFM_YN],  --여행자 계약서 동의여부

		Z.CUS_NO  

	FROM RES_PAGING_LIST Z
	INNER JOIN RES_MASTER_damo A WITH(NOLOCK) ON Z.RES_CODE = A.RES_CODE
	INNER JOIN PKG_DETAIL B WITH(NOLOCK) ON A.PRO_CODE = B.PRO_CODE
	LEFT JOIN CUS_CUSTOMER_damo C WITH(NOLOCK) ON Z.CUS_NO = C.CUS_NO
	LEFT JOIN EMP_MASTER_damo D WITH(NOLOCK) ON A.NEW_CODE = D.EMP_CODE
	LEFT JOIN PRO_TRANS_SEAT E WITH(NOLOCK) ON B.SEAT_CODE = E.SEAT_CODE
	LEFT JOIN RES_AIR_DETAIL F WITH(NOLOCK) ON A.RES_CODE = F.RES_CODE
	LEFT JOIN PKG_MASTER G WITH(NOLOCK) ON A.MASTER_CODE = G.MASTER_CODE
	LEFT JOIN INF_FILE_MASTER H WITH(NOLOCK) ON G.MAIN_FILE_CODE = H.FILE_CODE AND H.SHOW_YN = 'Y'
	LEFT JOIN HTL_MASTER I WITH(NOLOCK) ON A.MASTER_CODE = I.MASTER_CODE
	LEFT JOIN RES_CONTRACT J WITH(NOLOCK) ON A.RES_CODE = J.RES_CODE AND J.CONTRACT_NO = (SELECT MAX(AA.CONTRACT_NO) FROM RES_CONTRACT AA WITH(NOLOCK) WHERE AA.RES_CODE = J.RES_CODE)
	

	--ORDER BY A.NEW_DATE DESC
	ORDER BY Z.ROWNUMBER ASC
/*

	--회원의 예약자+출발자(예약자일시제외) 정보 조회 
	WITH CUS_RES_LIST AS
	(
		SELECT *, 
			CASE WHEN (SELECT TOP 1 CUS_NO FROM RES_CUSTOMER_DAMO WITH(NOLOCK) WHERE RES_CODE = TBL.RES_CODE AND AGE_TYPE = 0 AND RES_STATE = 0 ) =  @CUS_NO THEN 'Y' ELSE 'N' END AS RES_LEADER_YN ,
			CASE WHEN MASTER_YN ='Y'  AND RES_INC_YN ='Y' THEN RES_NAME 
				ELSE (SELECT TOP 1 CUS_NAME FROM RES_CUSTOMER_DAMO WITH(NOLOCK) WHERE RES_CODE = TBL.RES_CODE AND AGE_TYPE = 0 AND RES_STATE = 0 ORDER BY SEQ_NO ASC ) END AS RES_LEADER_NAME ,
				(SELECT TOP 1 CUS_NAME FROM RES_CUSTOMER_DAMO WITH(NOLOCK) WHERE RES_CODE = TBL.RES_CODE AND AGE_TYPE = 0 AND RES_STATE = 0 ORDER BY SEQ_NO ASC ) AS FIRST_CUS_NAME 
		FROM ( 
			SELECT A.RES_STATE, A.DEP_DATE,A.ARR_DATE, A.PRO_TYPE , A.RES_CODE , 'Y' AS MASTER_YN , A.NEW_DATE ,RES_NAME AS RES_NAME ,
				CASE WHEN EXISTS (SELECT * FROM RES_CUSTOMER_DAMO WITH(NOLOCK) WHERE RES_CODE = A.RES_CODE AND AGE_TYPE = 0 AND RES_STATE = 0 AND CUS_NO = @CUS_NO) THEN 'Y' ELSE 'N' END AS RES_INC_YN 
			FROM RES_MASTER_damo A WITH(NOLOCK) 
			WHERE CUS_NO = @CUS_NO  AND (@PRO_TYPE IN(0,9) OR PRO_TYPE = @PRO_TYPE)
			AND (( @MEM_YN = 'N' AND A.DEP_DATE > DATEADD(DD,-30,GETDATE()) ) OR @MEM_YN = 'Y' )  --비회원 출발일 30일 지난것은 표시 안함 
			AND A.VIEW_YN ='Y' --노출여부
			--AND A.SALE_COM_CODE <> '92474' --JUSTGO 제외
			UNION ALL 
			SELECT A.RES_STATE, A.DEP_DATE,A.ARR_DATE, A.PRO_TYPE , A.RES_CODE , 'N' AS MASTER_YN , A.NEW_DATE ,CUS_NAME AS RES_NAME , 'Y' AS RES_INC_YN FROM RES_MASTER_damo A WITH(NOLOCK) 
				INNER JOIN RES_CUSTOMER_DAMO B WITH(NOLOCK) 
					ON A.RES_CODE = B.RES_CODE 
					AND A.CUS_NO  <> B.CUS_NO
			WHERE B.CUS_NO = @CUS_NO  
			AND (@PRO_TYPE IN(0,9) OR PRO_TYPE = @PRO_TYPE)
			AND B.RES_STATE = 0  --정상출발자만 
			AND (( @MEM_YN = 'N' AND A.DEP_DATE > DATEADD(DD,-30,GETDATE()) ) OR @MEM_YN = 'Y' )  --비회원 출발일 30일 지난것은 표시 안함 
			AND B.VIEW_YN ='Y' --노출여부
			--AND A.SALE_COM_CODE <> '92474' --JUSTGO 제외
		) TBL 
		ORDER BY 
			--(CASE WHEN @ORDER_BY = 1 AND TBL.RES_STATE IN(7,8,9) THEN -2 
			--	WHEN @ORDER_BY = 1 AND TBL.DEP_DATE < GETDATE() THEN -1  ELSE 0 END ) DESC , -- @ORDER_BY=1 모바일정렬 , 예약정상-출발일지난것-취소순
			--(CASE WHEN @ORDER_BY = 1 AND TBL.RES_STATE IN(7,8,9) THEN TBL.NEW_DATE ELSE '2999-01-01' END ) DESC ,--모바일 취소된것은 등록일순
			--(CASE WHEN @ORDER_BY = 1 THEN TBL.DEP_DATE ELSE '1900-01-01' END) ASC ,   -- @ORDER_BY=1 모바일정렬=출발일순 , 그외는 예약일순
			--TBL.NEW_DATE DESC  --   예약일순

			--(CASE WHEN @ORDER_BY = 1 AND TBL.RES_STATE IN(7,8,9) THEN -2 WHEN @ORDER_BY = 1 AND TBL.DEP_DATE < GETDATE() THEN -1  ELSE 0 END ) DESC , --정상미출발예약0-출발완료예약(-1)-취소예약순(-2)
			(CASE WHEN @ORDER_BY = 1 AND TBL.RES_STATE IN(7,8,9) THEN -2 WHEN @ORDER_BY = 1 
			AND IIF(TBL.ARR_DATE IS NULL, TBL.DEP_DATE, TBL.ARR_DATE) >= CONVERT(DATETIME,cast(DATEADD(D,1,getdate()) as date))  THEN 0  ELSE -1 END ) DESC ,
			(CASE WHEN @ORDER_BY = 1 AND TBL.RES_STATE IN(7,8,9) THEN TBL.NEW_DATE ELSE '2999-01-01' END ) DESC , -- 취소예약은 최근등록순 
			(CASE WHEN @ORDER_BY = 1 AND IIF(TBL.ARR_DATE IS NULL, TBL.DEP_DATE, TBL.ARR_DATE) < CONVERT(DATETIME,cast(DATEADD(D,1,getdate()) as date))  THEN TBL.DEP_DATE ELSE '1900-01-01' END) DESC , -- 도착완료 예약은 최근출발일순 
			(CASE WHEN @ORDER_BY = 1 THEN TBL.DEP_DATE ELSE '1900-01-01' END) ASC ,   -- 그외(정상미출발예약)은 출발일순
			TBL.NEW_DATE DESC  --   그외는 예약일순(PC)
		
		OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
			ROWS ONLY
	)
	--최근예약내역 

	SELECT  
		@CUS_NO AS CUS_NO , B.RES_NAME  , 
		B.MASTER_YN ,A.PRO_TYPE , A.RES_STATE, C.MASTER_CODE,  A.PRO_CODE, A.PRICE_SEQ,  A.RES_CODE , B.RES_LEADER_YN , B.RES_LEADER_NAME , B.FIRST_CUS_NAME ,
		
		CASE WHEN A.PRO_TYPE = 3 THEN (SELECT [SIGN] FROM PUB_REGION WHERE REGION_CODE = I.REGION_CODE) 
			ELSE D.SIGN_CODE END AS SIGN_CODE  ,
		CASE WHEN A.PRO_TYPE = 3 THEN DBO.FN_PUB_GET_REGION_NAME(I.REGION_CODE) 
			ELSE DBO.FN_PUB_GET_REGION_NAME2(A.PRO_CODE) END AS REGION_NAME  ,

		A.NEW_DATE , 
		CASE WHEN A.PRO_TYPE = 2 THEN A.DEP_DATE WHEN A.PRO_TYPE = 3 THEN C.DEP_DATE ELSE A.DEP_DATE END AS DEP_DATE ,
		CASE WHEN A.PRO_TYPE = 2 THEN A.ARR_DATE WHEN A.PRO_TYPE = 3 THEN G.CHECK_OUT ELSE A.ARR_DATE END AS ARR_DATE ,

		CASE WHEN A.PRO_TYPE = 1 THEN  J.DEP_DEP_TIME ELSE F.DEP_DEP_TIME END AS DEP_DEP_TIME , --출발시간
		CASE WHEN A.PRO_TYPE = 1 THEN  J.DEP_ARR_TIME ELSE F.DEP_ARR_TIME END AS DEP_ARR_TIME , --출발시간 
		CASE A.PRO_TYPE WHEN 3 THEN DBO.FN_RES_HTL_GET_TOTAL_PRICE(A.RES_CODE) ELSE DBO.FN_RES_GET_TOTAL_PRICE(A.RES_CODE) END AS TOTAL_PRICE , 

		(	SELECT COUNT(*) FROM RES_SND_SMS WITH(NOLOCK) 
			WHERE RES_CODE = A.RES_CODE
			AND RCV_NUMBER1 = @NOR_TEL1 AND RCV_NUMBER2 = @NOR_TEL2 AND RCV_NUMBER3 = @NOR_TEL3 ) AS SMS_CNT , 
		(	SELECT COUNT(*) FROM RES_SND_EMAIL WITH(NOLOCK) 
			WHERE RES_CODE = A.RES_CODE
			AND RCV_EMAIL =  @EMAIL )  AS EMAIL_CNT , 

		A.PRO_NAME ,
		E.FILE_CODE, E.REGION_CODE, E.NATION_CODE, E.STATE_CODE, E.CITY_CODE, E.FILE_NAME_S, E.FILE_TYPE , 
		
		(SELECT TOP 1 (
			'/CONTENT/' + BB.REGION_CODE + '/' + BB.NATION_CODE + '/'  
			+ RTRIM(BB.STATE_CODE) + '/' + BB.CITY_CODE + '/IMAGE/' + (  
			CASE WHEN BB.FILE_NAME_M <> '' THEN BB.FILE_NAME_M ELSE BB.FILE_NAME_S  END))  
			FROM INF_FILE_MANAGER AA WITH(NOLOCK) 
			INNER JOIN INF_FILE_MASTER BB WITH(NOLOCK) ON BB.FILE_CODE = AA.FILE_CODE AND BB.FILE_TYPE = 1  
			WHERE AA.CNT_CODE = I.CNT_CODE  
		) AS HTL_IMG_URL,


		C.TOUR_NIGHT, C.TOUR_DAY , 
		CASE WHEN H.CONTRACT_NO > 0 THEN 'Y' ELSE 'N' END AS CONT_YN ,  --여행자 계약서 생성여부
		H.CFM_YN AS CFM_YN ,  --여행자 계약서 동의여부

		F.PNR_CODE1 ,   
		CASE WHEN A.PRO_TYPE = 3 THEN 
			STUFF ((SELECT (', ' + ROOM_INFO  ) AS [text()] FROM DBO.XN_HTL_ROOM_INFO_LIST(A.RES_CODE)
			FOR XML PATH('')), 1, 2, '') END   AS ROOM_INFO ,  --호텔룸정보
		CASE WHEN A.PRO_TYPE = 2 THEN dbo.FN_RES_AIR_GET_PRO_NAME(A.RES_CODE) END AS ROUTING_INFO  ,  --항공여정
		F.ROUTING_TYPE ,
		CASE WHEN A.PRO_TYPE = 1 THEN J.DEP_TRANS_CODE ELSE F.AIRLINE_CODE END AIRLINE_CODE , 
		CASE WHEN A.PRO_TYPE = 2 THEN 
			(SELECT TOP 1 OP_AIRLINE_CODE FROM RES_SEGMENT WITH(NOLOCK) WHERE RES_CODE = A.RES_CODE AND OP_AIRLINE_CODE IS NOT NULL) ELSE NULL END  AS  OP_AIRLINE_CODE, 
		CASE WHEN A.PRO_TYPE = 2 THEN 
			(SELECT KOR_NAME FROM PUB_AIRLINE WHERE AIRLINE_CODE = (SELECT TOP 1 OP_AIRLINE_CODE FROM RES_SEGMENT WITH(NOLOCK) WHERE RES_CODE = A.RES_CODE AND OP_AIRLINE_CODE IS NOT NULL)) ELSE NULL END  AS  OP_AIRLINE_NAME, 
		(SELECT KOR_NAME FROM PUB_AIRLINE WHERE AIRLINE_CODE = (CASE WHEN A.PRO_TYPE = 1 THEN J.DEP_TRANS_CODE ELSE F.AIRLINE_CODE END)) AS AIRLINE_NAME, 
		CASE WHEN A.PRO_TYPE = 2 THEN 
			(SELECT TOP 1 FLIGHT FROM RES_SEGMENT WITH(NOLOCK) WHERE RES_CODE = A.RES_CODE ) ELSE J.DEP_TRANS_NUMBER END  AS  FLIGHT_NUMBER, 

		CASE WHEN A.PRO_TYPE = 2 THEN 
			(SELECT SUM(CASE WHEN SEAT_STATUS = 'HK' THEN 1 ELSE 0 END) - COUNT(*) FROM RES_SEGMENT  WITH(NOLOCK) 
			WHERE RES_CODE = A.RES_CODE ) ELSE 0 END AS HK_COUNT , --좌석별 확약건수 - 전체좌석 (0건이면 확정)
		CASE WHEN A.PRO_TYPE = 2 THEN 
			ISNULL((SELECT TOP 1 TICKET_STATUS FROM DSR_TICKET WITH(NOLOCK) WHERE RES_CODE = A.RES_CODE AND GDS IN (2,5) ORDER BY RES_SEQ_NO ASC ),0) ELSE 0 END AS TICKET_STATUS ,  --티켓발권상태

		CASE WHEN A.PRO_TYPE = 3 THEN dbo.FN_PUB_GET_CITY_NAME(I.CITY_CODE)--호텔
			WHEN A.PRO_TYPE = 2 THEN dbo.FN_PUB_GET_CITY_NAME(dbo.FN_AIR_GET_CITY_CODE(F.DEP_ARR_AIRPORT_CODE)) --항공
			 ELSE  dbo.FN_PUB_GET_CITY_NAME(E.CITY_CODE) END  AS CITY_NAME ,  --도시명
		
		CASE WHEN A.PRO_TYPE = 3 THEN dbo.FN_PUB_GET_NATION_NAME(I.NATION_CODE)--호텔
			 ELSE  dbo.FN_PUB_GET_NATION_NAME((SELECT NATION_CODE FROM PUB_CITY WHERE CITY_CODE = E.CITY_CODE))  --국가명
		END  AS NATION_NAME  ,--국가
		C.TRANSFER_TYPE,
		C.SHOW_YN AS [PKG_SHOW_YN],
		
		K.ALT_PRO_URL , -- 외부예약 상품URL 
		A.SALE_COM_CODE , 
		DBO.FN_RES_GET_PAY_PRICE(A.RES_CODE) AS PAY_PRICE ,
		A.LAST_PAY_DATE ,

		A.CUS_RESPONSE , 
		F.FARE_SEAT_TYPE , 
		DBO.FN_RES_GET_APIS_COUNT(A.RES_CODE) AS APIS_CNT  ,
		DBO.FN_RES_GET_RES_ADULT_COUNT(A.RES_CODE) AS ADT_CNT ,
		DBO.FN_RES_GET_RES_CHILD_COUNT(A.RES_CODE) AS CHD_CNT ,
		DBO.FN_RES_GET_RES_BABY_COUNT(A.RES_CODE) AS INF_CNT ,
		DBO.FN_CUS_GET_EMP_NAME(A.NEW_CODE) AS EMP_NAME,
		DBO.FN_CUS_GET_EMP_TEAM(A.NEW_CODE) AS TEAM_NAME, 
		DBO.FN_CUS_GET_EMP_INNERNUM(A.NEW_CODE) AS EMP_NUMBER ,
		CASE WHEN A.PRO_TYPE IN (1,2) THEN DBO.XN_APP_RES_USE_YN(A.RES_CODE) ELSE 'N' END AS TRAVEL_GUIDE_YN,
		CASE WHEN A.PRO_TYPE IN (1) THEN ISNULL((SELECT TOP 1 'Y' FROM APP_FREETOUR_GUIDEFILE WITH(NOLOCK) WHERE RES_CODE = A.RES_CODE ),'N') ELSE 'N' END AS FREE_GUIDE_YN 
		--,(CASE WHEN @ORDER_BY = 1 AND A.RES_STATE IN(7,8,9) THEN -2 WHEN @ORDER_BY = 1 AND A.DEP_DATE < GETDATE() THEN -1  ELSE 0 END ) as  desc1, --정상미출발예약0-출발완료예약(-1)-취소예약순(-2)
		,(CASE WHEN @ORDER_BY = 1 AND A.RES_STATE IN(7,8,9) THEN -2 WHEN @ORDER_BY = 1 
			AND IIF(A.ARR_DATE IS NULL, A.DEP_DATE, A.ARR_DATE) >= CONVERT(DATETIME,cast(DATEADD(D,1,getdate()) as date))  THEN 0  ELSE -1 END ) 
		--	(CASE WHEN @ORDER_BY = 1 AND A.RES_STATE IN(7,8,9) THEN A.NEW_DATE ELSE '2999-01-01' END ) as desc2  , -- 취소예약은 최근등록순 
		--	(CASE WHEN @ORDER_BY = 1 AND A.DEP_DATE < GETDATE() THEN A.DEP_DATE ELSE '1900-01-01' END) as desc3 , -- 출발완료 예약은 최근출발일순 
		--	(CASE WHEN @ORDER_BY = 1 THEN A.DEP_DATE ELSE '1900-01-01' END)  as asc1 ,   -- 그외(정상미출발예약)은 출발일순
		--	A.NEW_DATE as desc4 
	FROM RES_MASTER_damo A WITH(NOLOCK)
		INNER JOIN CUS_RES_LIST B  WITH(NOLOCK)
			ON A.RES_CODE = B.RES_CODE 
		
		LEFT JOIN PKG_DETAIL  C  WITH(NOLOCK)
			ON A.PRO_CODE = C.PRO_CODE 
		LEFT JOIN PKG_MASTER D WITH(NOLOCK) 
			ON A.MASTER_CODE = D.MASTER_CODE
		LEFT JOIN INF_FILE_MASTER E WITH(NOLOCK) 
			ON D.MAIN_FILE_CODE = E.FILE_CODE AND E.SHOW_YN = 'Y'
		LEFT JOIN RES_AIR_DETAIL F WITH(NOLOCK) 
			ON A.RES_CODE = F.RES_CODE
		LEFT JOIN RES_HTL_ROOM_MASTER G WITH(NOLOCK) 
			ON A.RES_CODE = G.RES_CODE
		LEFT JOIN  RES_CONTRACT H WITH(NOLOCK)
			ON A.RES_CODE = H.RES_CODE 
			AND H.CONTRACT_NO = (SELECT MAX(CONTRACT_NO) FROM RES_CONTRACT WHERE RES_CODE = H.RES_CODE  )

		LEFT JOIN HTL_MASTER I WITH(NOLOCK) 
			ON A.MASTER_CODE = I.MASTER_CODE
			
		LEFT JOIN PRO_TRANS_SEAT J WITH(NOLOCK) 
			ON C.SEAT_CODE = J.SEAT_CODE

		LEFT JOIN RES_ALT_MATCHING K WITH(NOLOCK)
			ON A.RES_CODE = K.RES_CODE 
				
	--WHERE A.RES_STATE IN (0,1,2,3,4)
	-- @ORDER_BY=1 모바일정렬 , 정상미출발예약-출발완료예약-취소예약순
	ORDER BY --(CASE WHEN @ORDER_BY = 1 AND A.RES_STATE IN(7,8,9) THEN -2 WHEN @ORDER_BY = 1 AND A.DEP_DATE < GETDATE() THEN -1  ELSE 0 END ) DESC , --정상미출발예약0-도착완료예약(-1)-취소예약순(-2)
			(CASE WHEN @ORDER_BY = 1 AND A.RES_STATE IN(7,8,9) THEN -2 WHEN @ORDER_BY = 1 
			AND IIF(A.ARR_DATE IS NULL, A.DEP_DATE, A.ARR_DATE) >= CONVERT(DATETIME,cast(DATEADD(D,1,getdate()) as date))  THEN 0  ELSE -1 END ) DESC , --정상미출발예약0-도착완료예약(-1)-취소예약순(-2)
			(CASE WHEN @ORDER_BY = 1 AND A.RES_STATE IN(7,8,9) THEN A.NEW_DATE ELSE '2999-01-01' END ) DESC , -- 취소예약은 최근등록순 
			(CASE WHEN @ORDER_BY = 1 AND IIF(A.ARR_DATE IS NULL, A.DEP_DATE, A.ARR_DATE) < CONVERT(DATETIME,cast(DATEADD(D,1,getdate()) as date))  THEN A.DEP_DATE ELSE '1900-01-01' END) DESC , -- 도착완료 예약은 최근출발일순 
			(CASE WHEN @ORDER_BY = 1 THEN A.DEP_DATE ELSE '1900-01-01' END) ASC ,   -- 그외(정상미출발예약)은 출발일순
			A.NEW_DATE DESC  --   그외는 최근 예약일순(PC)
	--ORDER BY A.NEW_DATE DESC 

*/
END 



GO
