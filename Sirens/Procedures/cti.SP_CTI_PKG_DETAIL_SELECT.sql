USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_PKG_DETAIL_SELECT
■ DESCRIPTION				: 행사 상세 정보
■ INPUT PARAMETER			: 	
■ OUTPUT PARAMETER			: 
■ EXEC						: 	
exec CTI.SP_CTI_PKG_DETAIL_SELECT @PRO_CODE='XXX201-141109',@PRICE_SEQ=NULL
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-10-22		정지용				최초생성
================================================================================================================*/ 

CREATE PROCEDURE [cti].[SP_CTI_PKG_DETAIL_SELECT]
(
	@PRO_CODE	VARCHAR(20),
	@PRICE_SEQ	INT
)
AS  
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	IF ISNULL(@PRICE_SEQ, 0) = 0
	BEGIN
		SELECT TOP 1 @PRICE_SEQ = PRICE_SEQ FROM DIABLO.DBO.PKG_DETAIL_PRICE WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE ORDER BY ADT_PRICE
	END

	-- 상품상세 정보
	SELECT 
		  A.PRO_CODE, @PRICE_SEQ AS PRICE_SEQ, A.PRO_NAME, A.MASTER_CODE, C.NEXT_DATE, A.TRANSFER_TYPE, A.SEAT_CODE, A.TOUR_NIGHT, A.TOUR_DAY
		, A.TOUR_JOURNEY, A.RES_ADD_YN, A.DEP_CFM_YN, A.CONFIRM_YN, A.DEP_DATE, A.ARR_DATE, A.SALE_TYPE, A.PKG_TOUR_REMARK, A.PKG_SUMMARY, A.HOTEL_REMARK
		, A.PKG_INC_SPECIAL, A.RES_REMARK, A.OPTION_REMARK, A.PKG_PASSPORT_REMARK, A.PKG_SHOPPING_REMARK, A.PKG_REMARK, A.PKG_CONTRACT, A.NEW_CODE, A.TC_YN, A.AIR_CFM_YN, A.ROOM_CFM_YN, A.SCHEDULE_CFM_YN, A.PRICE_CFM_YN		
		, C.SIGN_CODE, C.ATT_CODE, C.PKG_COMMENT
		, ISNULL((SELECT COUNT(*) FROM DIABLO.DBO.PRO_COMMENT WITH(NOLOCK) WHERE MASTER_CODE = A.MASTER_CODE), 0) AS [COMMENT_COUNT]
		, ISNULL((SELECT COUNT(*) FROM DIABLO.DBO.HBS_DETAIL WITH(NOLOCK) WHERE MASTER_SEQ=1 AND MASTER_CODE = A.MASTER_CODE AND DEL_YN='N' AND LEVEL=0), 0) AS [REVIEWS_COUNT]		
		, PC.*
		, B.ADT_PRICE, B.CHD_PRICE, B.INF_PRICE, B.SGL_PRICE, B.POINT_RATE, B.POINT_PRICE, B.POINT_YN
		, ISNULL(BB.ADT_SALE_PRICE, 0) AS ADT_SALE_PRICE, ISNULL(BB.CHD_SALE_PRICE, 0) AS CHD_SALE_PRICE, ISNULL(BB.INF_SALE_PRICE, 0) AS INF_SALE_PRICE
		, ISNULL(BB.ADT_SALE_QCHARGE, 0) AS ADT_SALE_QCHARGE
		, ISNULL(BB.CHD_SALE_QCHARGE, 0) AS CHD_SALE_QCHARGE
		, ISNULL(BB.INF_SALE_QCHARGE, 0) AS INF_SALE_QCHARGE
		, BB.SALE_QCHARGE_DATE
		, BB.QCHARGE_TYPE
		, B.PKG_INCLUDE, B.PKG_NOT_INCLUDE
		, DIABLO.DBO.FN_PRO_GET_RES_COUNT(A.PRO_CODE) AS [RES_COUNT]
		, A.FAKE_COUNT, A.MAX_COUNT, A.MIN_COUNT
		, (SELECT COUNT(*) FROM DIABLO.DBO.RES_CUSTOMER_damo WITH(NOLOCK) WHERE RES_CODE IN (SELECT RES_CODE FROM DIABLO.DBO.RES_MASTER_damo WHERE PRO_CODE = A.PRO_CODE) AND RES_STATE = 0 AND SEAT_YN = 'Y') AS [OK_COUNT]
	FROM DIABLO.DBO.PKG_DETAIL A WITH(NOLOCK)
	INNER JOIN DIABLO.DBO.PKG_DETAIL_PRICE B WITH(NOLOCK) ON A.PRO_CODE = B.PRO_CODE AND B.PRICE_SEQ = @PRICE_SEQ
	INNER JOIN DIABLO.DBO.XN_PKG_DETAIL_PRICE(@PRO_CODE, @PRICE_SEQ) BB ON A.PRO_CODE = BB.PRO_CODE AND B.PRICE_SEQ = B.PRICE_SEQ
	INNER JOIN DIABLO.DBO.PKG_MASTER C WITH(NOLOCK) ON A.MASTER_CODE = C.MASTER_CODE
	CROSS JOIN (
		SELECT ISNULL(AVG(GRADE), 0) AS [STAR_POINT], ISNULL(AVG(POINT1), 0) AS [POINT1], ISNULL(AVG(POINT2), 0) AS [POINT2], ISNULL(AVG(POINT3), 0) AS [POINT3], ISNULL(AVG(POINT4), 0) AS [POINT4], ISNULL(AVG(POINT5), 0) AS [POINT5]
		FROM DIABLO.DBO.PRO_COMMENT PC WITH(NOLOCK) WHERE PC.MASTER_CODE = (SELECT MASTER_CODE FROM DIABLO.DBO.PKG_DETAIL WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE)
	) PC
	WHERE A.PRO_CODE = @PRO_CODE
	
	-- 쇼핑정보
	SELECT 
		PRO_CODE,SHOP_SEQ,SHOP_NAME,SHOP_PLACE,SHOP_TIME,SHOP_REMARK 
	FROM DIABLO.DBO.PKG_DETAIL_SHOPPING WITH(NOLOCK) 
	WHERE PRO_CODE = @PRO_CODE;

	-- 옵션정보
	SELECT 
		PRO_CODE, OPT_SEQ, OPT_NAME, OPT_CONTENT, OPT_PRICE, OPT_USETIME, OPT_REPLACE, OPT_PLACE, OPT_COMPANION 
	FROM DIABLO.DBO.PKG_DETAIL_OPTION WITH(NOLOCK) WHERE 
	PRO_CODE = @PRO_CODE
END

GO