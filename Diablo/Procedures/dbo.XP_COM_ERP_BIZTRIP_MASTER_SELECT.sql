USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_ERP_BIZTRIP_MASTER_SELECT
■ DESCRIPTION				: BTMS ERP 출장 현황 마스터 정보 검색
■ INPUT PARAMETER			: 
	@RES_CODE				: 예약코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC XP_COM_ERP_BIZTRIP_MASTER_SELECT '93853', 'BT1605120287';

	SELECT * FROM COM_BIZTRIP_MASTER

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-04-19		김성호			최초생성
   2016-05-04		박형만			CUS_NO , 생년월일 , 성별 추가 
   2016-05-04		정지용			EMP_ID 추가
   2016-05-09		김성호			출장상태 예약 상태 기준 실시간 상태값 검색으로 변경
   2016-05-12		정지용			정산상태값 null일때 미정산으로 설정
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_ERP_BIZTRIP_MASTER_SELECT]
	@AGT_CODE		VARCHAR(10),
	@BT_CODE		VARCHAR(20)
AS 
BEGIN

	WITH BT_INFO AS
	(
		SELECT A.AGT_CODE, A.BT_CODE, A.PRO_CODE, A.NEW_DATE, A.BT_START_DATE, A.BT_END_DATE, A.BT_NAME, A.PAY_REQUEST_DATE, H.KOR_NAME AS [EDT_NAME], A.EDT_DATE
			, A.APPROVAL_STATE
			, ISNULL((
				SELECT (CASE WHEN MIN(RM.RES_STATE) < 7 THEN 0 WHEN MIN(RM.RES_STATE) = 7 THEN 7 ELSE 9 END)
				FROM COM_BIZTRIP_DETAIL CBD WITH(NOLOCK)
				INNER JOIN RES_MASTER_damo RM WITH(NOLOCK) ON CBD.RES_CODE = RM.RES_CODE
				WHERE CBD.AGT_CODE = A.AGT_CODE AND CBD.BT_CODE = A.BT_CODE
			), 9) AS [BT_STATE]
--			, A.BT_STATE
			, B.KOR_NAME AS [AGT_NAME], B.PAY_LATER_YN, C.EMP_ID AS NEW_ID, A.NEW_SEQ, C.KOR_NAME AS [NEW_NAME], D.POS_NAME, E.TEAM_NAME, C.HP_NUMBER, C.EMAIL
			, ISNULL(F.SET_STATE, 9) AS SET_STATE, G.MANAGE_CODE, G.MANAGE_NAME
			, DBO.FN_PRO_GET_TOTAL_PRICE(A.PRO_CODE) AS [TOTAL_PRICE]
			, DBO.FN_PRO_GET_PAY_PRICE(A.PRO_CODE) AS [PAY_PRICE]
			, DBO.FN_PRO_GET_CHANGE_PRICE(A.PRO_CODE) AS [CHG_PRICE]
			, I.CUS_NO , C.BIRTH_DATE , C.GENDER  
		FROM COM_BIZTRIP_MASTER A WITH(NOLOCK)
		INNER JOIN AGT_MASTER B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE
		LEFT JOIN COM_EMPLOYEE C WITH(NOLOCK) ON A.AGT_CODE = C.AGT_CODE AND A.NEW_SEQ = C.EMP_SEQ
		LEFT JOIN COM_POSITION D WITH(NOLOCK) ON A.AGT_CODE = D.AGT_CODE AND C.POS_SEQ = D.POS_SEQ
		LEFT JOIN COM_TEAM E WITH(NOLOCK) ON A.AGT_CODE = E.AGT_CODE AND C.TEAM_SEQ = E.TEAM_SEQ
		LEFT JOIN SET_MASTER F WITH(NOLOCK) ON A.PRO_CODE = F.PRO_CODE
		LEFT JOIN (
			SELECT TOP 1 A.AGT_CODE, A.EMP_CODE AS [MANAGE_CODE], B.KOR_NAME AS [MANAGE_NAME]
			FROM COM_MANAGER A WITH(NOLOCK)
			INNER JOIN EMP_MASTER B WITH(NOLOCK) ON A.EMP_CODE = B.EMP_CODE
			WHERE A.AGT_CODE = @AGT_CODE AND A.MANAGER_TYPE = 0
		) G ON A.AGT_CODE = G.AGT_CODE
		LEFT JOIN EMP_MASTER H WITH(NOLOCK) ON A.EDT_CODE = H.EMP_CODE

		LEFT JOIN COM_EMPLOYEE_MATCHING I WITH(NOLOCK) ON A.NEW_SEQ = I.EMP_SEQ AND A.AGT_CODE = I.AGT_CODE 
			
		WHERE A.AGT_CODE = @AGT_CODE AND A.BT_CODE = @BT_CODE
	)
	, RES_INFO AS (
		SELECT A.AGT_CODE, A.BT_CODE
			, SUM(CASE WHEN B.PRO_DETAIL_TYPE = 2 THEN 1 ELSE 0 END) AS [AIR_COUNT]
			, SUM(CASE WHEN B.PRO_DETAIL_TYPE = 3 THEN 1 ELSE 0 END) AS [HOTEL_COUNT]
			, SUM(CASE WHEN B.PRO_DETAIL_TYPE = 4 THEN 1 ELSE 0 END) AS [RENTCAR_COUNT]
			, SUM(CASE WHEN B.PRO_DETAIL_TYPE = 5 THEN 1 ELSE 0 END) AS [VISA_COUNT]
			, SUM(CASE WHEN B.PRO_DETAIL_TYPE = 9 THEN 1 ELSE 0 END) AS [ETC_COUNT]
		FROM COM_BIZTRIP_MASTER A WITH(NOLOCK)
		INNER JOIN COM_BIZTRIP_DETAIL B WITH(NOLOCK) ON A.AGT_CODE = B.AGT_CODE AND A.BT_CODE = B.BT_CODE
		LEFT JOIN RES_MASTER_damo C WITH(NOLOCK) ON B.RES_CODE = C.RES_CODE
		WHERE A.AGT_CODE = @AGT_CODE AND A.BT_CODE = @BT_CODE
		GROUP BY A.AGT_CODE, A.BT_CODE
	)
	SELECT A.*, B.AIR_COUNT, B.HOTEL_COUNT, B.RENTCAR_COUNT, B.VISA_COUNT, B.ETC_COUNT
		, (
			CASE
				WHEN A.PAY_PRICE = 0 THEN 0					-- 미납
				WHEN A.TOTAL_PRICE > A.PAY_PRICE THEN 1		-- 부분납
				WHEN A.TOTAL_PRICE = A.PAY_PRICE THEN 2		-- 완납
				WHEN A.TOTAL_PRICE < A.PAY_PRICE THEN 3		-- 과납
			END) AS [PAY_STATE]
	FROM BT_INFO A
	LEFT JOIN RES_INFO B ON A.AGT_CODE = B.AGT_CODE AND A.BT_CODE = B.BT_CODE

END 




GO
