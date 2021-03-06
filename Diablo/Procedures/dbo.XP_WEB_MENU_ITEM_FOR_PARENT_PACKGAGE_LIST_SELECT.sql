USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_WEB_MENU_ITEM_FOR_PARENT_PACKGAGE_LIST_SELECT
■ DESCRIPTION				: PARENT CODE를 이용 베스트 상품 상품 검색
■ INPUT PARAMETER			: 
	@SITE_CODE				: 사이트 코드
	@PARENT_CODE			: 부모 코드
	@SEC_CODE				: 섹션코드
	@ORDER_BY				: 섹션 코드 정렬 방향 (D: DESC, 이외 ASC)
	@TOP_COUNT				: 최대 검색 수
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_WEB_MENU_ITEM_FOR_PARENT_PACKGAGE_LIST_SELECT 'VGT', '102', '3', 5, ''

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-20		김성호			최초생성
   2013-05-29		김성호			SEC_CODE VARCHAR(4)로 수정
   2013-06-01		김성호			스케줄 검색 조건 반영
   2013-06-10		김성호			WITH(NOLOCK) 추가
   2013-10-25		김성호			INF_FILE_MASTER 테이블 컬럼명 지정
   2014-06-19		정지용			가격정찰제 관련 쿼리 수정
   2015-02-24		김성호			SEC_CODE ORDER BY 정렬 방향 설정과 TOP 설정값 추가 (최근베스트 상품 검색 이유)
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[XP_WEB_MENU_ITEM_FOR_PARENT_PACKGAGE_LIST_SELECT]
(
	@SITE_CODE		VARCHAR(3),
	@PARENT_CODE	VARCHAR(20),
	@SEC_CODE		VARCHAR(4),
	@TOP_COUNT		INT,
	@ORDER_BY		VARCHAR(1)
)
AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @WHERE NVARCHAR(100);

	IF ISNULL(@SEC_CODE, '') = ''
		SET @WHERE = ''
	ELSE
		SET @WHERE = ' AND A.SEC_CODE = @SEC_CODE'


	SET @SQLSTRING = N'
	WITH LIST AS
	(
		SELECT ''M'' AS [FLAG], A.SITE_CODE, A.MENU_CODE, A.SEC_CODE, A.GRP_SEQ, A.ITEM_SEQ, A.MASTER_CODE
			, B.LOW_PRICE AS [PRICE], B.MAIN_FILE_CODE AS [FILE_CODE]
			, (SELECT MIN(PRO_CODE) FROM PKG_DETAIL AA WITH(NOLOCK) WHERE AA.MASTER_CODE = A.MASTER_CODE AND AA.DEP_DATE > GETDATE()) AS [PRO_CODE]
			, (SELECT MAX(COM_SEQ) FROM PRO_COMMENT AA WITH(NOLOCK) WHERE AA.MASTER_CODE = B.MASTER_CODE) AS [COM_SEQ]
		FROM MNU_MNG_ITEM A WITH(NOLOCK)
		INNER JOIN PKG_MASTER B WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE
		INNER JOIN MNU_MASTER C WITH(NOLOCK) ON A.SITE_CODE = C.SITE_CODE AND A.MENU_CODE = C.MENU_CODE
		LEFT JOIN MNU_MNG_ITEM_SCH Z WITH(NOLOCK) ON A.SITE_CODE = Z.SITE_CODE AND A.MENU_CODE = Z.MENU_CODE AND A.SEC_CODE = Z.SEC_CODE AND A.GRP_SEQ = Z.GRP_SEQ AND A.ITEM_SEQ = Z.ITEM_SEQ
		WHERE A.SITE_CODE = @SITE_CODE AND C.PARENT_CODE = @PARENT_CODE' + @WHERE + N'
			AND (A.SCH_YN = ''N'' OR (
				GETDATE() >= Z.START_DATE AND GETDATE() < Z.END_DATE
				AND Z.DAY_START_TIME <= SUBSTRING(CONVERT(VARCHAR(20), GETDATE(), 120), 12, 8)
				AND Z.DAY_END_TIME > SUBSTRING(CONVERT(VARCHAR(20), GETDATE(), 120), 12, 8)
				AND SUBSTRING(Z.SHOW_DAY, DATEPART(DW, GETDATE()), 1) = 1
			))
		UNION ALL
		SELECT ''P'' AS [FALG], A.SITE_CODE, A.MENU_CODE, A.SEC_CODE, A.GRP_SEQ, A.ITEM_SEQ, B.MASTER_CODE
			--, (SELECT MIN(ADT_PRICE) FROM PKG_DETAIL_PRICE AA WITH(NOLOCK) WHERE AA.PRO_CODE = A.PRO_CODE)
			, DBO.XN_PRO_DETAIL_SALE_PRICE_CUTTING(A.PRO_CODE, 0)
			, (SELECT TOP 1 FILE_CODE FROM PKG_DETAIL_FILE WITH(NOLOCK) WHERE PRO_CODE = A.PRO_CODE ORDER BY SHOW_ORDER) AS [FILE_CODE]
			, A.PRO_CODE
			, (SELECT MAX(COM_SEQ) FROM PRO_COMMENT AA WITH(NOLOCK) WHERE AA.MASTER_CODE = B.MASTER_CODE) AS [COM_SEQ]
		FROM MNU_MNG_ITEM A WITH(NOLOCK)
		INNER JOIN PKG_DETAIL B WITH(NOLOCK) ON A.PRO_CODE = B.PRO_CODE
		INNER JOIN MNU_MASTER C WITH(NOLOCK) ON A.SITE_CODE = C.SITE_CODE AND A.MENU_CODE = C.MENU_CODE
		LEFT JOIN MNU_MNG_ITEM_SCH Z WITH(NOLOCK) ON A.SITE_CODE = Z.SITE_CODE AND A.MENU_CODE = Z.MENU_CODE AND A.SEC_CODE = Z.SEC_CODE AND A.GRP_SEQ = Z.GRP_SEQ AND A.ITEM_SEQ = Z.ITEM_SEQ
		WHERE A.SITE_CODE = @SITE_CODE AND C.PARENT_CODE = @PARENT_CODE' + @WHERE + N'
			AND (A.SCH_YN = ''N'' OR (
				GETDATE() >= Z.START_DATE AND GETDATE() < Z.END_DATE
				AND Z.DAY_START_TIME <= SUBSTRING(CONVERT(VARCHAR(20), GETDATE(), 120), 12, 8)
				AND Z.DAY_END_TIME > SUBSTRING(CONVERT(VARCHAR(20), GETDATE(), 120), 12, 8)
				AND SUBSTRING(Z.SHOW_DAY, DATEPART(DW, GETDATE()), 1) = 1
			))
	)
	SELECT ' + (CASE @TOP_COUNT WHEN 0 THEN '' ELSE 'TOP (@TOP_COUNT) ' END) + N'
		Z.*, A.IMG_URL, A.PRO_NAME, A.PKG_COMMENT, A.DTI_ITEM1, A.DTI_ITEM2, A.DTI_ITEM3, A.DTI_ITEM4--, A.IMG_URL, A.LINK_URL
		, (SELECT TOP 1 PRICE_SEQ FROM PKG_DETAIL_PRICE AA WITH(NOLOCK) WHERE AA.PRO_CODE = Z.PRO_CODE ORDER BY ADT_PRICE) AS [PRICE_SEQ]
		, B.GRP_TITLE, B.GRP_DESC, B.GRP_CODE
		, C.DEP_DATE, C.TOUR_NIGHT, C.TOUR_DAY, C.TOUR_JOURNEY
		, D.FILE_CODE, D.REGION_CODE, D.NATION_CODE, D.STATE_CODE, D.CITY_CODE, D.FILE_TYPE
		, D.FILE_NAME, D.EXTENSION_NAME, D.FILE_NAME_L, D.FILE_NAME_M, D.FILE_NAME_S
		, E.CONTENTS AS [COMMENT_CONTENTS], E.GRADE AS [COMMENT_GRADE], E.NICKNAME AS [COMMENT_NAME], E.NEW_DATE AS [COMMENT_DATE]
	FROM LIST Z
	INNER JOIN MNU_MNG_ITEM A WITH(NOLOCK) ON A.SITE_CODE = Z.SITE_CODE AND A.MENU_CODE = Z.MENU_CODE AND A.SEC_CODE = Z.SEC_CODE AND A.GRP_SEQ = Z.GRP_SEQ AND A.ITEM_SEQ = Z.ITEM_SEQ
	INNER JOIN MNU_MNG_GROUP B WITH(NOLOCK) ON A.SITE_CODE = B.SITE_CODE AND A.MENU_CODE = B.MENU_CODE AND A.SEC_CODE = B.SEC_CODE AND A.GRP_SEQ = B.GRP_SEQ
	INNER JOIN PKG_DETAIL C WITH(NOLOCK) ON C.PRO_CODE = Z.PRO_CODE
	LEFT JOIN INF_FILE_MASTER D WITH(NOLOCK) ON D.FILE_CODE = Z.FILE_CODE
	LEFT JOIN PRO_COMMENT E WITH(NOLOCK) ON E.MASTER_CODE = C.MASTER_CODE AND E.COM_SEQ = Z.COM_SEQ
	ORDER BY Z.SITE_CODE, Z.MENU_CODE, Z.SEC_CODE' + (CASE @ORDER_BY WHEN 'D' THEN ' DESC' ELSE '' END) + ', Z.GRP_SEQ, A.ORDER_NO;'

	SET @PARMDEFINITION = N'
		@SITE_CODE		VARCHAR(3),
		@PARENT_CODE	VARCHAR(20),
		@SEC_CODE		VARCHAR(4),
		@TOP_COUNT		INT';

	--PRINT @SQLSTRING

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, 
		@SITE_CODE,
		@PARENT_CODE,
		@SEC_CODE,
		@TOP_COUNT;

END

GO
