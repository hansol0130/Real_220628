USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XN_PRO_DETAIL_QCHARGE_PRICE_ALL
■ DESCRIPTION				: 행사 연령구분 별 유류할증료 반환
■ INPUT PARAMETER			: 
	@PRO_CODE				: 행사코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	SELECT DBO.XN_PRO_DETAIL_QCHARGE_PRICE('CPP9018-200426')
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-07-07		김성호			최초생성
   2017-12-21		김성호			공항코드 우선 처리
   2018-08-06		박형만			예외 지역은 END_DATE 처리 함 . END_DATE 미처리시 계속 나옴(ex)JPP802-180905 BX
-- 제외  2020-03-06		김성호			프로모션 검색 시 END_DATE 처리 . END_DATE 미처리시 계속 나옴(ex)JPP802-180905 BX
================================================================================================================*/ 
CREATE FUNCTION [dbo].[XN_PRO_DETAIL_QCHARGE_PRICE]
(
	@PRO_CODE VARCHAR(20)
)
RETURNS INT
AS
BEGIN

	DECLARE @ADT_SYS_QCHARGE INT;

	WITH LIST AS 
	(
		SELECT A.PRO_CODE, B.ARR_TRANS_CODE AS [AIRLINE_CODE], B.DEP_ARR_AIRPORT_CODE AS [AIRPORT_CODE], A.DEP_DATE, D.NATION_CODE
		FROM PKG_DETAIL A WITH(NOLOCK)
		INNER JOIN PRO_TRANS_SEAT B WITH(NOLOCK) ON A.SEAT_CODE = B.SEAT_CODE
		INNER JOIN PUB_AIRPORT C WITH(NOLOCK) ON B.DEP_ARR_AIRPORT_CODE = C.AIRPORT_CODE
		INNER JOIN PUB_CITY D WITH(NOLOCK) ON C.CITY_CODE = D.CITY_CODE
		WHERE A.PRO_CODE = @PRO_CODE AND A.SEAT_CODE > 0
		UNION ALL
		SELECT A.PRO_CODE, B.AIRLINE_CODE, B.AIRPORT_CODE, A.DEP_DATE, D.NATION_CODE
		FROM PKG_DETAIL A WITH(NOLOCK)
		INNER JOIN PKG_MASTER B WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE
		LEFT JOIN PUB_AIRPORT C WITH(NOLOCK) ON B.AIRPORT_CODE = C.AIRPORT_CODE
		LEFT JOIN PUB_CITY D WITH(NOLOCK) ON C.CITY_CODE = D.CITY_CODE
		WHERE A.PRO_CODE = @PRO_CODE AND A.SEAT_CODE <= 0
	)
	SELECT TOP 1 @ADT_SYS_QCHARGE = A.ADT_SYS_QCHARGE
	FROM (
		SELECT DBO.XN_PUB_PRICE_CUTTING(ISNULL(BB.ADT_QCHARGE, 0), 3) AS [ADT_SYS_QCHARGE],
			(CASE WHEN BB.END_DATE > AA.DEP_DATE THEN 1 ELSE 2 END) AS [TARGET_NUM], BB.NEW_DATE,
			(CASE WHEN PATINDEX('%' + AA.AIRPORT_CODE + '%', BB.AIRPORT_CODES) > 0 THEN 1 ELSE 2 END) AS [ZONE_ORDER]
		FROM LIST AA
		INNER JOIN AIRLINE_EXC_QCHARGE BB WITH(NOLOCK) ON AA.AIRLINE_CODE = BB.AIRLINE_CODE
		WHERE BB.START_DATE <= AA.DEP_DATE 
		AND BB.END_DATE >= AA.DEP_DATE   -- 예외 지역은 END 기간 체크 18.08.06
		AND (PATINDEX('%' + AA.AIRPORT_CODE + '%', BB.AIRPORT_CODES) > 0 OR PATINDEX('%' + AA.NATION_CODE + '%', BB.NATION_CODES) > 0)
		
		UNION ALL
		SELECT DBO.XN_PUB_PRICE_CUTTING(ISNULL(BB.ADT_QCHARGE, 0), 3) AS [ADT_SYS_QCHARGE],
			(CASE WHEN BB.END_DATE > AA.DEP_DATE THEN 1 ELSE 2 END) AS [TARGET_NUM], BB.NEW_DATE,
			(CASE WHEN PATINDEX('%' + AA.AIRPORT_CODE + '%', CC.AIRPORT_CODES) > 0 THEN 3 ELSE 4 END) AS [ZONE_ORDER]
		FROM LIST AA
		INNER JOIN AIRLINE_QCHARGE BB WITH(NOLOCK) ON AA.AIRLINE_CODE = BB.AIRLINE_CODE
		INNER JOIN AIRLINE_REGION CC WITH(NOLOCK) ON BB.AIRLINE_CODE = CC.AIRLINE_CODE AND BB.GROUP_SEQ = CC.GROUP_SEQ AND BB.REGION_SEQ = CC.REGION_SEQ
		WHERE BB.START_DATE <= AA.DEP_DATE
		--AND BB.END_DATE >= AA.DEP_DATE	-- END 기간 체크 20.03.06  
		AND (PATINDEX('%' + AA.AIRPORT_CODE + '%', CC.AIRPORT_CODES) > 0 OR PATINDEX('%' + AA.NATION_CODE + '%', CC.NATION_CODES) > 0)
		
		-- 해당 유류할증료가 없을 경우 0 반환
		UNION ALL
		SELECT 0, 3, NULL, 5
	) A
	ORDER BY A.TARGET_NUM, ZONE_ORDER, A.NEW_DATE DESC

	RETURN (@ADT_SYS_QCHARGE)
END

GO
