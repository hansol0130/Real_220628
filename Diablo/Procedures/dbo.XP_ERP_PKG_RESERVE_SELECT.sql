USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ERP_PKG_RESERVE_SELECT
■ DESCRIPTION				: ERP 예약자 정보 상세 보기 . 타임아웃이 많이 나서 , WITH NOLOCK 붙여서 새로 SP 생성 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	XP_ERP_PKG_RESERVE_SELECT 'RP1211268184'
	
	RP1211268184
■ MEMO						: 
	
	기존 SQL.SELECT_PACKAGE_RESERVE 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2019-12-20		박형만			최초생성
================================================================================================================*/ 
CREATE  PROC [dbo].[XP_ERP_PKG_RESERVE_SELECT]
	@RES_CODE	RES_CODE
AS 
BEGIN
--DECLARE @RES_CODE RES_CODE 
--SET @RES_CODE = 'RP1911186402' 
	SELECT 
		A.RES_CODE,A.PRICE_SEQ,A.SYSTEM_TYPE,A.PROVIDER,A.MEDIUM_TYPE,A.AD_CODE,A.PRO_CODE,A.PRO_NAME,A.MASTER_CODE,
		A.PRO_TYPE,A.RES_STATE,A.RES_TYPE,A.DEP_DATE,C.ARR_DATE,A.GRP_RES_CODE,A.CUS_NO,A.RES_NAME,
		--A.SOC_NUM1,
		--damo.dbo.dec_varchar('DIABLO','dbo.RES_MASTER','SOC_NUM2', A.SEC_SOC_NUM2) AS SOC_NUM2,
		A.BIRTH_DATE, A.GENDER,
		A.RES_EMAIL,A.NOR_TEL1,A.NOR_TEL2,A.NOR_TEL3,A.ETC_TEL1,A.ETC_TEL2,A.ETC_TEL3,A.RES_ADDRESS1,A.RES_ADDRESS2,A.ZIP_CODE,A.MEMBER_YN,A.CUS_REQUEST,A.CUS_RESPONSE,A.ETC,A.TAX_YN,A.INSURANCE_YN,
		A.SENDING_REMARK,A.MOV_BEFORE_CODE,A.MOV_AFTER_CODE,A.MOV_DATE,A.COMM_RATE,A.LAST_PAY_DATE,A.PNR_INFO,A.RES_PRO_TYPE,
		A.SALE_COM_CODE,A.SALE_EMP_CODE,A.SALE_TEAM_CODE,A.SALE_TEAM_NAME,A.NEW_DATE,A.NEW_CODE,A.NEW_TEAM_CODE,A.NEW_TEAM_NAME,
		A.PROFIT_EMP_CODE,A.PROFIT_TEAM_CODE,A.PROFIT_TEAM_NAME,A.EDT_DATE,A.EDT_CODE,A.CXL_DATE,A.CXL_CODE,A.CXL_TYPE,A.REFUNDMENT_BANK,
		A.REFUNDMENT_NAME,A.REFUNDMENT_BANKCODE,A.REFUNDMENT_STATUS,A.CFM_DATE,A.CFM_CODE,A.CARD_PROVE,A.COMM_AMT, A.AGT_REMARK, 
		B.AIR_GDS,
		B.HOTEL_GDS,
		B.AIR_PNR,
		B.HOTEL_VOUCHER,
		B.AIR_ONLINE_YN,
		B.HOTEL_ONLINE_YN,
		dbo.XN_COM_GET_EMP_NAME(A.NEW_CODE) AS NEW_NAME,
		dbo.XN_COM_GET_TEAM_NAME(A.NEW_CODE) AS NEW_TEAM_NAME,
		dbo.XN_COM_GET_EMP_NAME(A.EDT_CODE) AS EDT_NAME,
		dbo.XN_COM_GET_TEAM_NAME(A.EDT_CODE) AS EDT_TEAM_NAME,
		(SELECT KOR_NAME FROM AGT_MASTER  WITH(NOLOCK) WHERE AGT_CODE = A.SALE_COM_CODE) AS SALE_COM_NAME,
		ISNULL(dbo.FN_RES_GET_SALE_PRICE(A.RES_CODE), 0) AS SALE_AMT ,
		ISNULL(dbo.FN_RES_GET_TOTAL_PRICE(A.RES_CODE), 0) AS TOTAL_AMT ,
		C.NEW_CODE AS PKG_NEW_CODE,
		(SELECT KOR_NAME FROM EMP_MASTER B  WITH(NOLOCK) WHERE B.EMP_CODE = C.NEW_CODE) AS PKG_NEW_NAME,
		(SELECT TEAM_CODE FROM EMP_MASTER B  WITH(NOLOCK) WHERE B.EMP_CODE = C.NEW_CODE) AS PKG_TEAM_CODE,
		--D.SEQ_NO AS SCH_SEQ_NO, D.SCH_DATE,	D.CONTENTS , D.ALT_TIME,
		A.IPIN_DUP_INFO,
		(
		CASE WHEN A.CUS_NO > 1 THEN 
		(SELECT COUNT(*) FROM RES_MASTER_DAMO WITH(NOLOCK) WHERE DEP_DATE > GETDATE() AND CUS_NO = A.CUS_NO AND RES_STATE <= 7)
		ELSE 0 END ) AS [SOCIAL_COUNT] ,
		A.VIEW_YN , dbo.FN_CUS_GET_WEB_TYPE(A.CUS_NO) AS WEB_CUS_TYPE ,
		ISNULL(G.CUS_NO,H.CUS_NO) AS REC_CUS_NO,
		ISNULL(G.CUS_NAME,H.CUS_NAME) AS REC_CUS_NAME,
		ISNULL(G.CUS_ID,H.CUS_ID) AS REC_CUS_ID,
		E.BRANCH_RATE
	FROM RES_MASTER_DAMO A WITH(NOLOCK)
	INNER JOIN RES_PKG_DETAIL B WITH(NOLOCK) ON B.RES_CODE = A.RES_CODE
	INNER JOIN PKG_DETAIL C WITH(NOLOCK) ON A.PRO_CODE = C.PRO_CODE
	--LEFT JOIN PRI_SCHEDULE D WITH(NOLOCK) ON A.RES_CODE = D.RES_CODE 
	--	AND SEQ_NO  = ( SELECT TOP 1 SEQ_NO FROM PRI_SCHEDULE WITH(NOLOCK) WHERE RES_CODE = D.RES_CODE ORDER BY SEQ_NO DESC )
	LEFT JOIN RES_PKG_DETAIL E WITH(NOLOCK) ON A.RES_CODE = E.RES_CODE
	LEFT JOIN RES_RECOMMEND F  WITH(NOLOCK) 
		ON A.RES_CODE = F.RES_CODE
	LEFT JOIN CUS_MEMBER_SLEEP G WITH(NOLOCK)  
		ON F.REC_CUS_NO = G.CUS_NO 
	LEFT JOIN CUS_MEMBER H WITH(NOLOCK) 
		ON F.REC_CUS_NO = H.CUS_NO 

	WHERE A.RES_CODE = @RES_CODE

END 


GO
