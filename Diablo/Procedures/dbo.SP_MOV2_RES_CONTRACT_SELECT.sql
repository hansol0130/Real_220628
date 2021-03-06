USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_RES_CONTRACT_SELECT
■ DESCRIPTION				: 모바일 여행자 계약서 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: EXEC SP_MOV2_RES_CONTRACT_SELECT 'RP1802066632'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
2018-05-11			정지용			최초생성
2018-05-17			정지용			업체 정보 추가 ( 대리판매 정보 )
2019-04-17			박형만			여행자 계약서 출발자 상태 정상인것만 
================================================================================================================*/ 
CREATE PROC [dbo].[SP_MOV2_RES_CONTRACT_SELECT]	
	@RES_CODE		VARCHAR(20)
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	WITH RES_CUSTOMER_LIST AS (
		SELECT 
			ROW_NUMBER() OVER (ORDER BY SEQ_NO ASC) AS [SEQ_NO], RES_CODE, CUS_NAME AS RES_NAME, CUS_NO, NOR_TEL1, NOR_TEL2, NOR_TEL3
		FROM RES_CUSTOMER WITH(NOLOCK) 
		WHERE RES_CODE = @RES_CODE 
			--AND (( AGE_TYPE = 0 AND RES_STATE = 0 ) OR ( AGE_TYPE = 0 )) -- 성인이고 예약상태인것 또는 성인  2019-04-17 주석처리 
			AND AGE_TYPE = 0 AND RES_STATE = 0  -- 성인이고 예약상태 정상 인것 또는 성인
	)
	SELECT 
		B.PRO_CODE,
		C.PKG_CONTRACT,
		ISNULL((SELECT KOR_NAME FROM AGT_MASTER WITH(NOLOCK) WHERE AGT_CODE = C.INS_CODE AND AGT_TYPE_CODE = 17), '') AS INS_NAME,
		D.RES_NAME,
		A.*,
		D.NOR_TEL1, D.NOR_TEL2, D.NOR_TEL3, E.SIGN_CODE, B.SALE_COM_CODE, 
		F.KOR_NAME AS AGT_NAME, F.ADDRESS1 AS AGT_ADDRESS1, F.ADDRESS2 AS AGT_ADDRESS2, F.CEO_NAME AS AGT_CEO_NAME, F.NOR_TEL1 AS AGT_TEL1, F.NOR_TEL2 AS AGT_TEL2, F.NOR_TEL3 AS AGT_TEL3, F.AGT_REGISTER,
		CASE WHEN PAYMENT_YN = 'Y' OR PAY_PRICE >= TOTAL_PRICE THEN 'Y' ELSE 'N' END PAYMENT_YN  -- Y : 완납, N : 미납
	FROM (
		SELECT TOP 1 
			A.RES_CODE,			
			A.CONTRACT_NO,
			A.DEP_DATE,
			A.ARR_DATE,
			A.NIGHT,
			A.INS_TYPE,
			A.INS_PRICE,
			A.MIN_COUNT,
			A.MAX_COUNT,
			A.TRANS_TYPE,
			A.TRANS_GRADE,
			A.STAY_TYPE,
			A.STAY_COUNT,
			A.TC_YN,
			A.TRANSPORT_TYPE,
			A.TRANSPORT_COUNT,
			A.MANDATORY_1,
			A.MANDATORY_2,
			A.MANDATORY_4,
			A.MANDATORY_5,
			A.MANDATORY_6,
			A.MANDATORY_7,
			A.MANDATORY_3,
			A.OPTION_1,
			A.OPTION_2,
			A.OPTION_3,
			A.OPTION_4,
			A.OPTION_5,
			A.OPTION_6,
			A.OPTION_7,
			A.OPTION_8,
			A.NEW_DATE,
			A.NEW_CODE,
			dbo.XN_COM_GET_TEAM_CODE(A.NEW_CODE) AS NEW_TEAM,
			dbo.XN_COM_GET_TEAM_NAME(A.NEW_CODE) AS NEW_NAME,
			A.TOUR_TYPE,
			A.INSIDE_DAY,
			A.REMARK,
			A.CFM_YN,
			A.CFM_DATE,
			A.CFM_TYPE,
			A.CFM_HEADER,
			A.CFM_IP,
			A.PRO_NAME,
			A.ADT_PRICE,
			DBO.FN_RES_GET_TOTAL_PRICE(A.RES_CODE) AS [TOTAL_PRICE],
			DBO.FN_RES_GET_PAY_PRICE(A.RES_CODE) AS [PAY_PRICE],
			DBO.FN_RES_GET_RES_COUNT(RES_CODE) AS RES_COUNT,
			A.DEP_DEP_DATE,
			A.ARR_ARR_DATE,
			A.DEP_AIRPORT,
			A.ARR_AIRPORT,
			A.PAYMENT_YN,
			DBO.FN_RES_IS_TOURLIST(A.RES_CODE) AS TOUR_STATE,
			CASE WHEN RSV_DATE IS NULL THEN (SELECT TOP 1 B.CFM_DATE FROM DBO.RES_SND_EMAIL B WITH(NOLOCK) WHERE B.RES_CODE = A.RES_CODE AND B.SND_TYPE = 6  ORDER BY B.NEW_DATE DESC) ELSE A.RSV_DATE END AS RSV_DATE
		FROM DBO.RES_CONTRACT A WITH(NOLOCK)
		WHERE A.RES_CODE =  @RES_CODE
	) A
	INNER JOIN RES_MASTER B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
	INNER JOIN PKG_DETAIL C WITH(NOLOCK) ON B.PRO_CODE = C.PRO_CODE
	INNER JOIN PKG_MASTER E WITH(NOLOCK) ON C.MASTER_CODE = E.MASTER_CODE
	LEFT JOIN RES_CUSTOMER_LIST D ON B.RES_CODE = D.RES_CODE AND D.SEQ_NO = 1
	LEFT JOIN AGT_MASTER F WITH(NOLOCK) ON F.AGT_CODE = B.SALE_COM_CODE
	ORDER BY A.RES_CODE, A.CONTRACT_NO DESC;	
END

GO
