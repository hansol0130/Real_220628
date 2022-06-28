USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<이규식>
-- Create date: <2009-01-08>
-- Description:	<상담일지 PAGING>
-- 2012-03-02 READ UNCOMMITTED 설정
-- =============================================
CREATE PROCEDURE [dbo].[SP_CUS_CONSULT_SELECT_LIST]
	@FLAG	char(1),
	@PAGE_SIZE	int	= 10,
	@PAGE_INDEX		int = 1,	
	@CUS_NO	int
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	-- 검색된 데이타의 카운트를 돌려준다.
	IF @FLAG = 'C'
	BEGIN
		SELECT COUNT(*) AS COUNT
		FROM CUS_CONSULT
		WHERE CUS_NO = @CUS_NO
	END
	-- 검색된 데이타의 리스트를 돌려준다.
	ELSE IF @FLAG = 'L'
	BEGIN
		WITH TMP_CUS_CONSULT AS (
			SELECT 
				ROW_NUMBER() OVER (ORDER BY CON_NO DESC) AS ROWNUMBER, CON_NO
			FROM CUS_CONSULT
			WHERE CUS_NO = @CUS_NO
		)
		SELECT B.*
			, CASE WHEN B.HOPE_TIME IS NULL THEN 'Y' ELSE 'N' END AS HOPE_YN
			, DBO.FN_CUS_GET_EMP_NAME(B.NEW_CODE) AS NEW_NAME
			, DBO.FN_CUS_GET_EMP_NAME(B.EDT_CODE) AS EDT_NAME
			, DBO.FN_CUS_GET_EMP_NAME(B.MNG_CODE) AS MNG_NAME
		FROM TMP_CUS_CONSULT A
		INNER JOIN CUS_CONSULT B ON A.CON_NO = B.CON_NO
		WHERE A.ROWNUMBER BETWEEN (@PAGE_SIZE * (@PAGE_INDEX - 1) + 1) AND (@PAGE_SIZE * (@PAGE_INDEX - 1) + @PAGE_SIZE)
		ORDER BY CON_NO DESC;
		
		-- 관심 행사
		WITH TMP_CUS_CONSULT AS (
			SELECT 
				ROW_NUMBER() OVER (ORDER BY CON_NO DESC) AS ROWNUMBER, CON_NO
			FROM CUS_CONSULT
			WHERE CUS_NO = @CUS_NO
		)
		SELECT C.PRICE_TYPE, C.RES_ADD_YN, C.PRO_CODE, C.PRO_NAME, C.DEP_DATE
			, (SELECT TOP 1 ADT_PRICE FROM PKG_DETAIL_PRICE WHERE PRO_CODE = C.PRO_CODE) AS [PRO_PRICE]
			, DBO.FN_PRO_GET_RES_COUNT(C.PRO_CODE) AS [RES_COUNT]
			, C.FAKE_COUNT, C.MIN_COUNT
		FROM TMP_CUS_CONSULT A
		INNER JOIN CUS_CONSULT_PRODUCT B ON A.CON_NO = B.CON_NO
		INNER JOIN PKG_DETAIL C ON B.PRO_CODE = C.PRO_CODE
		WHERE A.ROWNUMBER BETWEEN (@PAGE_SIZE * (@PAGE_INDEX - 1) + 1) AND (@PAGE_SIZE * (@PAGE_INDEX - 1) + @PAGE_SIZE);
		
		--SELECT 
		--	*,
		--	CASE WHEN HOPE_TIME IS NULL THEN 'Y' ELSE 'N' END AS HOPE_YN,
		--	(SELECT KOR_NAME FROM EMP_MASTER_damo B WHERE B.EMP_CODE = A.NEW_CODE) AS NEW_NAME,
		--	(SELECT KOR_NAME FROM EMP_MASTER_damo B WHERE B.EMP_CODE = A.EDT_CODE) AS EDT_NAME,
		--	(SELECT KOR_NAME FROM EMP_MASTER_damo B WHERE B.EMP_CODE = A.MNG_CODE) AS MNG_NAME
		--FROM 
		--	CUS_CONSULT A
		--WHERE
		--	A.CON_NO IN (
		--		SELECT CON_NO
		--		FROM TMP_CUS_CONSULT
		--		WHERE ROWNUMBER BETWEEN (@PAGE_SIZE * (@PAGE_INDEX - 1) + 1) AND (@PAGE_SIZE * (@PAGE_INDEX - 1) + @PAGE_SIZE)
		--	)
		--ORDER BY CON_NO DESC
	END

END

--EXEC [SP_CUS_CONSULT_SELECT_LIST] 'C', 0, 0, 1
--EXEC [SP_CUS_CONSULT_SELECT_LIST] 'L', 10, 1, 1
GO