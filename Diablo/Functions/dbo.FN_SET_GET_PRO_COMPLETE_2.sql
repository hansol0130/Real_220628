USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		이규식
-- Create date: 2010-02-06
-- Description:	행사코드의 모든 예약들에 대한 수익현황을 가져온다.
-- (2010-2-1 일 행사변경안 적용버전)
-- 2011-07-21 : PRO_TYPE 컬럼 추가
-- =============================================
CREATE FUNCTION [dbo].[FN_SET_GET_PRO_COMPLETE_2]
(	
	@PRO_CODE VARCHAR(20)
)
RETURNS 
@RESULT_TABLE TABLE 
(
	PRO_CODE	VARCHAR(20),
	PRO_TYPE	INT,
	RES_CODE	VARCHAR(20),
	RES_COUNT	INT,
	SALE_PRICE	MONEY,
	MASTER_PROFIT	MONEY,
	BRANCH_PROFIT	MONEY,
	TOTAL_PROFIT	MONEY,
	PROFIT_RATE	NUMERIC(5,2),
	PROFIT_EMP_CODE	CHAR(7),
	PROFIT_TEAM_CODE VARCHAR(10),
	PROFIT_TEAM_NAME VARCHAR(50)

)
AS
BEGIN

DECLARE @PROFIT INT

SELECT @PROFIT = DBO.FN_SET_GET_PRO_PERSON_PROFIT(@PRO_CODE)

INSERT INTO @RESULT_TABLE
SELECT 
	PRO_CODE,
	PRO_TYPE,
	RES_CODE,
	CASE
		WHEN PROFIT_TYPE = '2' THEN 0
		ELSE RES_COUNT
	END AS RES_COUNT,
	SALE_PRICE,
	CASE
		WHEN PROFIT_TYPE = '2' THEN 0 
		ELSE RES_COUNT * @PROFIT *(100 -  PROFIT_RATE) * 0.01 
	END AS MASTER_PROFIT,
	RES_COUNT * @PROFIT * PROFIT_RATE * 0.01 AS BRANCH_PROFIT,
	CASE
		WHEN PROFIT_TYPE = '2' THEN 0
		ELSE RES_COUNT * @PROFIT  
	END AS TOTAL_PROFIT,
	PROFIT_RATE,
	PROFIT_EMP_CODE,
	PROFIT_TEAM_CODE,
	PROFIT_TEAM_NAME
FROM 
(
	SELECT
		'1' AS PROFIT_TYPE,
		DBO.FN_SET_GET_RES_COUNT(B.RES_CODE) AS RES_COUNT,
		DBO.FN_RES_GET_TOTAL_PRICE(B.RES_CODE) AS SALE_PRICE,
		A.PRO_CODE, B.PRO_TYPE, A.RES_CODE, A.PROFIT_RATE,
		B.PROFIT_EMP_CODE,
		B.PROFIT_TEAM_CODE,
		B.PROFIT_TEAM_NAME
	FROM SET_PROFIT A WITH(NOLOCK) 
	INNER JOIN RES_MASTER_DAMO B WITH(NOLOCK) ON B.RES_CODE = A.RES_CODE
	WHERE A.PRO_CODE = @PRO_CODE AND B.RES_STATE <= 7 
	UNION
	SELECT
		'2' AS PROFIT_TYPE,
		DBO.FN_SET_GET_RES_COUNT(B.RES_CODE) AS RES_COUNT,
		DBO.FN_RES_GET_TOTAL_PRICE(B.RES_CODE) AS SALE_PRICE,
		A.PRO_CODE, B.PRO_TYPE, A.RES_CODE, 100-A.PROFIT_RATE AS PROFIT_RATE,
		C.NEW_CODE AS PROFIT_EMP_CODE,
		D.TEAM_CODE AS PROFIT_TEAM_CODE,
		(SELECT TEAM_NAME FROM EMP_TEAM Z WITH(NOLOCK)  WHERE Z.TEAM_CODE = D.TEAM_CODE) AS PROFIT_TEAM_NAME
	FROM SET_PROFIT A WITH(NOLOCK) 
	INNER JOIN RES_MASTER_DAMO B WITH(NOLOCK) ON B.RES_CODE = A.RES_CODE
	INNER JOIN PKG_DETAIL C WITH(NOLOCK) ON C.PRO_CODE = A.PRO_CODE
	INNER JOIN EMP_MASTER D WITH(NOLOCK) ON D.EMP_CODE = C.NEW_CODE
	WHERE A.PRO_CODE = @PRO_CODE AND B.RES_STATE <= 7 AND PROFIT_RATE <> 100 
) X

	RETURN 
END
GO
