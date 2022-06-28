USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_WEB_NAVI_LIST_SELECT
■ DESCRIPTION				: 행사코드의 네비게이션 검색
■ INPUT PARAMETER			: 
	@SITE_CODE				: 사이트코드
	@MENU_CODE				: 메뉴코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_WEB_NAVI_LIST_SELECT 'VGT', '118', 3, 'Y'

	SELECT * FROM MNU_MASTER WHERE MENU_CODE IN ('10101030101','101010301','1010103','10101','101')

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-01		김성호			최초생성
   2013-05-21		김성호			Root MenuType 검색 조건, 하단 데이터 검색 유무 파라메터 추가
   2013-06-10		김성호			WITH(NOLOCK) 추가
   2022-06-20		이장훈			@PARENT_CODE PARSING 에러 수정 ex) '1111'|2222' --> '1111|2222' 변경
================================================================================================================*/ 
CREATE  PROCEDURE [dbo].[XP_WEB_NAVI_LIST_SELECT]
(
	@SITE_CODE VARCHAR(3),
	@MENU_CODE VARCHAR(20),
	@MENU_TYPE	INT,
	@LIST_YN	VARCHAR(1)
)

AS  
BEGIN

    SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @PARENT_CODE VARCHAR(100), @WHERE VARCHAR(50);

	IF @MENU_TYPE > 0
		SET @WHERE = N' AND MENU_TYPE <= @MENU_TYPE'
	ELSE
		SET @WHERE = ''

	SET @PARENT_CODE = DBO.XN_COM_GET_NAVI(@SITE_CODE, @MENU_CODE);

	SET @PARENT_CODE = ''''+REPLACE(@PARENT_CODE,'''','')+''''

	--PRINT @PARENT_CODE

	SET @SQLSTRING = N'
	SELECT REPLACE(REPLACE(@PARENT_CODE, '''''''', ''''), '','', ''[^]'') AS [CODE_LIST], MENU_CODE AS [TOP_CODE], MENU_NAME AS [TOP_NAME]
		, STUFF((SELECT (''[^]'' + MENU_NAME) AS [text()] FROM MNU_MASTER_REL AA WITH(NOLOCK) WHERE AA.SITE_CODE = @SITE_CODE AND AA.MENU_CODE IN (' + @PARENT_CODE + N') ORDER BY LEN(MENU_CODE) DESC FOR XML PATH('''')), 1, 3, '''') AS [CODE_NAME]
		, (SELECT MENU_NAME FROM MNU_MASTER_REL AA WITH(NOLOCK) WHERE AA.SITE_CODE = @SITE_CODE AND AA.MENU_CODE = @MENU_CODE) AS [MENU_NAME]
	FROM MNU_MASTER_REL A WITH(NOLOCK)
	WHERE A.SITE_CODE = @SITE_CODE AND A.MENU_CODE IN (' + @PARENT_CODE + N') AND A.PARENT_CODE IS NULL;'

	IF @LIST_YN = 'Y'
	BEGIN
		SET @SQLSTRING = @SQLSTRING + N'
	WITH LIST AS
	(
		SELECT 0 AS [LEVEL], A.SITE_CODE, A.MENU_CODE, A.PARENT_CODE, A.MENU_NAME, A.ORDER_NUM, A.LINK_URL
			--, A.REGION_CODE, A.CITY_CODE, A.NATION_CODE, A.ATT_CODE, A.GROUP_CODE, A.BASIC_CODE, A.CATEGORY_TYPE, A.VIEW_TYPE, A.LINK_URL, A.IMAGE_URL
		FROM MNU_MASTER_REL A WITH(NOLOCK)
		WHERE A.SITE_CODE = @SITE_CODE AND A.PARENT_CODE IS NULL' + @WHERE + N'
		UNION ALL
		SELECT (B.LEVEL + 1), A.SITE_CODE, A.MENU_CODE, A.PARENT_CODE, A.MENU_NAME, A.ORDER_NUM, A.LINK_URL
			--, A.REGION_CODE, A.CITY_CODE, A.NATION_CODE, A.ATT_CODE, A.GROUP_CODE, A.BASIC_CODE, A.CATEGORY_TYPE, A.VIEW_TYPE, A.LINK_URL, A.IMAGE_URL
		FROM MNU_MASTER_REL A WITH(NOLOCK)
		INNER JOIN LIST B ON A.SITE_CODE = B.SITE_CODE AND A.PARENT_CODE = B.MENU_CODE AND A.PARENT_CODE IN (' + @PARENT_CODE + N')
	)
	SELECT *
	FROM LIST A
	WHERE A.LEVEL <= 2
	ORDER BY A.LEVEL, A.ORDER_NUM'
	END

	SET @PARMDEFINITION = N'
		@SITE_CODE VARCHAR(3),
		@MENU_CODE VARCHAR(20),
		@MENU_TYPE INT,
		@PARENT_CODE VARCHAR(100)';

	--PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@SITE_CODE,
		@MENU_CODE,
		@MENU_TYPE,
		@PARENT_CODE;

END


GO