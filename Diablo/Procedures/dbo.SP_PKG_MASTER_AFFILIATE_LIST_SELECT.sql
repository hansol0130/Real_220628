USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PKG_MASTER_AFFILIATE_LIST_SELECT
■ DESCRIPTION				: 마스터 상품별 제휴사 등록 상태 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: EXEC SP_PKG_MASTER_AFFILIATE_LIST_SELECT '2016-08-01'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
2016-07-15			김성호			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_PKG_MASTER_AFFILIATE_LIST_SELECT]
	@BASE_DATE	DATE
AS
BEGIN
	
	DECLARE @SQLSTRING NVARCHAR(4000), @AGENT_STRING NVARCHAR(100)

	SELECT @AGENT_STRING = STUFF((
		SELECT ',[' + B.PUB_VALUE + ']' AS [text()]
		FROM (SELECT A.PROVIDER FROM PKG_MASTER_AFFILIATE A WHERE A.PROVIDER IS NOT NULL GROUP BY A.PROVIDER HAVING COUNT(*) > 0) A
		LEFT JOIN COD_PUBLIC B ON B.PUB_TYPE = 'RES.AGENT.TYPE' AND A.PROVIDER = B.PUB_CODE
		FOR XML PATH('')), 1, 1, '')

	SET @SQLSTRING = N'

	WITH AFFILIATE_LIST AS
	(
		SELECT UPPER(A.MASTER_CODE) AS [MASTER_CODE], MAX(A.USE_YN) AS [USE_YN] 
		FROM PKG_MASTER_AFFILIATE A WITH(NOLOCK)
		GROUP BY A.MASTER_CODE
		HAVING MAX(A.USE_YN) = ''Y''
	)
	, MASTER_LIST AS
	(
		SELECT A.*
		FROM AFFILIATE_LIST A
		INNER JOIN PKG_MASTER B WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE
		WHERE B.NEXT_DATE >= @BASE_DATE
	)
	, PROVIDER_LIST AS
	(
		SELECT A.PROVIDER, B.PUB_VALUE
		FROM (SELECT A.PROVIDER FROM PKG_MASTER_AFFILIATE A WHERE A.PROVIDER IS NOT NULL GROUP BY A.PROVIDER HAVING COUNT(*) > 0) A
		LEFT JOIN COD_PUBLIC B ON B.PUB_TYPE = ''RES.AGENT.TYPE'' AND A.PROVIDER = B.PUB_CODE
	)
	, DATA_LIST AS
	(
		SELECT A.MASTER_CODE, A.PUB_VALUE, ISNULL(B.USE_YN, ''N'') AS [USE_YN]
		FROM (
			SELECT A.MASTER_CODE, B.PUB_VALUE, B.PROVIDER
			FROM MASTER_LIST A
			CROSS JOIN PROVIDER_LIST B
		) A
		LEFT JOIN PKG_MASTER_AFFILIATE B ON A.PROVIDER = B.PROVIDER AND A.MASTER_CODE = B.MASTER_CODE
		--ORDER BY A.PROVIDER, B.MASTER_CODE
	)
	, PIVOT_LIST AS
	(
		SELECT *
		FROM DATA_LIST A
		PIVOT
		(
			MAX(USE_YN)
			FOR PUB_VALUE IN (' + @AGENT_STRING + N')
		) B
	)
	SELECT A.MASTER_CODE AS [마스터코드], B.MASTER_NAME AS [상품명], C.KOR_NAME AS [담당자], ' + @AGENT_STRING + N'
	FROM PIVOT_LIST A
	INNER JOIN PKG_MASTER B WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE
	INNER JOIN EMP_MASTER_DAMO C WITH(NOLOCK) ON B.NEW_CODE = C.EMP_CODE
	INNER JOIN EMP_TEAM D WITH(NOLOCK) ON C.TEAM_CODE = D.TEAM_CODE
	WHERE D.TEAM_TYPE = 1
	ORDER BY A.MASTER_CODE
	'
	EXEC SP_EXECUTESQL @SQLSTRING, N'@BASE_DATE	DATE', @BASE_DATE

END
GO