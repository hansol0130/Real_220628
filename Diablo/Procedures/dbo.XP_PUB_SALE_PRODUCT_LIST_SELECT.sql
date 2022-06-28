USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_PUB_SALE_PRODUCT_LIST_SELECT
■ DESCRIPTION				: 할인상품 검색
■ INPUT PARAMETER			: 
	@PAGE_INDEX  INT		: 현재 페이지
	@PAGE_SIZE  INT			: 한 페이지 표시 게시물 수
	@KEY		VARCHAR(400): 검색 키
	@ORDER_BY	INT			: 정렬 순서
■ OUTPUT PARAMETER			: 
	@TOTAL_COUNT INT OUTPUT	: 총 메일 수       
■ EXEC						: 
	DECLARE @PAGE_INDEX INT,
	@PAGE_SIZE  INT,
	@TOTAL_COUNT INT, 
	@KEY		VARCHAR(400),
	@ORDER_BY	INT

	SELECT @PAGE_INDEX=1,@PAGE_SIZE=30,@KEY=N'SiteCode=&SignCode=P&Date=&Ongoing=N',@ORDER_BY=1

	exec XP_PUB_SALE_PRODUCT_LIST_SELECT @page_index, @page_size, @total_count output, @key, @order_by
	SELECT @TOTAL_COUNT
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-24		김성호			최초생성
   2013-05-02		김성호			진행상태 조건 수정 (GETDATE() - 1)
   2013-06-10		김성호			WITH(NOLOCK) 추가
   2014-07-15		정지용			가격정찰제 가격수정
================================================================================================================*/ 

CREATE PROCEDURE [dbo].[XP_PUB_SALE_PRODUCT_LIST_SELECT]
(
	@PAGE_INDEX  INT,
	@PAGE_SIZE  INT,
	@TOTAL_COUNT INT OUTPUT,
	@KEY		VARCHAR(400),
	@ORDER_BY	INT
)

AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @WHERE NVARCHAR(4000), @SORT_STRING VARCHAR(50);
	
	DECLARE @SITE_CODE VARCHAR(3), @SIGN_CODE VARCHAR(30), @DATE VARCHAR(10), @ONGOING VARCHAR(1);

	SELECT
		@SITE_CODE = DBO.FN_PARAM(@KEY, 'SiteCode'),
		@SIGN_CODE = DBO.FN_PARAM(@KEY, 'SignCode'),
		@DATE = DBO.FN_PARAM(@KEY, 'Date'),
		@ONGOING = DBO.FN_PARAM(@KEY, 'Ongoing'),
		@WHERE = 'WHERE SITE_CODE = @SITE_CODE AND SHOW_YN = ''Y'''

	-- 기초코드 VGL
	IF @SITE_CODE = ''
		SET @SITE_CODE = 'VGL';

	IF ISNULL(@SIGN_CODE, '') <> ''
	BEGIN
		--SELECT @REGION_CODE = STUFF((SELECT (',''' + DATA + '''') AS [text()] FROM [DBO].[FN_SPLIT] (@SIGN_CODE, ',') FOR XML PATH('')), 1, 1, '')
		--SET @WHERE = @WHERE + ' AND A.SIGN_CODE IN (' + @SIGN_CODE + ')'
		SET @WHERE = @WHERE + ' AND CHARINDEX(@SIGN_CODE, SIGN_CODE) > 0'
	END

	IF ISNULL(@DATE, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND CONVERT(DATETIME, @DATE) BETWEEN START_DATE AND END_DATE'
		--SET @WHERE = @WHERE + ' AND CONVERT(DATETIME, @DATE) >= START_DATE AND CONVERT(DATETIME, @DATE) <= END_DATE'
	END

	IF ISNULL(@ONGOING, '') <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND ' + (CASE @ONGOING WHEN 'Y' THEN '  DATEADD(DAY, -1, GETDATE()) <= END_DATE' WHEN 'N' THEN '  DATEADD(DAY, -1, GETDATE()) > END_DATE' END)
	END

	-- SORT 조건 만들기  
	SELECT @SORT_STRING = ('SITE_CODE ASC, ORDER_NUM DESC, SALE_SEQ DESC'
		--CASE @ORDER_BY  
		--	WHEN 2 THEN 'A.LOW_PRICE'
		--	WHEN 3 THEN 'A.HIGH_PRICE DESC'
		--	ELSE 'A.THEME_ORDER'
		--END
	)

	SET @SQLSTRING = N'
	-- 전체 마스터 수
	SELECT @TOTAL_COUNT = COUNT(*)
	FROM SALE_MASTER A WITH(NOLOCK)
	' + @WHERE + N';

	WITH LIST AS
	(
		SELECT SITE_CODE, SALE_SEQ
			, (SELECT TOP 1 PRICE_SEQ FROM PKG_DETAIL_PRICE AA WITH(NOLOCK) WHERE AA.PRO_CODE = A.PRO_CODE ORDER BY ADT_PRICE) AS [PRICE_SEQ]
			, (SELECT TOP 1 FILE_CODE FROM PKG_DETAIL_FILE WITH(NOLOCK) WHERE PRO_CODE = A.PRO_CODE ORDER BY SHOW_ORDER) AS [FILE_CODE]
		FROM SALE_MASTER A WITH(NOLOCK)
		' + @WHERE + N'
		ORDER BY ' + @SORT_STRING + '
		OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
		ROWS ONLY
	)	
	--SELECT A.*, B.PRO_NAME, C.ADT_PRICE, D.*
	SELECT A.*, B.PRO_NAME, DBO.XN_PRO_DETAIL_SALE_PRICE_CUTTING(C.PRO_CODE, C.PRICE_SEQ) AS [ADT_PRICE], D.*
	FROM LIST Z
	INNER JOIN SALE_MASTER A WITH(NOLOCK) ON A.SITE_CODE = Z.SITE_CODE AND A.SALE_SEQ = Z.SALE_SEQ
	LEFT JOIN PKG_DETAIL B WITH(NOLOCK) ON B.PRO_CODE = A.PRO_CODE
	LEFT JOIN PKG_DETAIL_PRICE C WITH(NOLOCK) ON C.PRO_CODE = A.PRO_CODE AND C.PRICE_SEQ = Z.PRICE_SEQ
	LEFT JOIN INF_FILE_MASTER D WITH(NOLOCK) ON D.FILE_CODE = Z.FILE_CODE'
	
	SET @PARMDEFINITION = N'
		@PAGE_INDEX INT,
		@PAGE_SIZE INT,
		@TOTAL_COUNT INT OUTPUT,
		@SITE_CODE VARCHAR(3),
		@SIGN_CODE VARCHAR(30),
		@DATE VARCHAR(10),
		@ONGOING VARCHAR(1)';

	PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@PAGE_INDEX,
		@PAGE_SIZE,
		@TOTAL_COUNT OUTPUT,
		@SITE_CODE,
		@SIGN_CODE,
		@DATE,
		@ONGOING;

END

GO