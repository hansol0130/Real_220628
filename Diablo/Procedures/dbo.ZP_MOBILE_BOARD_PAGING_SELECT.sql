USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  /*================================================================================================================
■ USP_NAME					: [[ZP_MOBILE_BOARD_PAGING_SELECT]]
■ DESCRIPTION				: VR 동영상 링크 정보 조회
■ INPUT PARAMETER			: @VR_NO@VR_NAME @VR_DESC @VR_CREATOR @nowPage	
■ EXEC						: 	
    -- [[ZP_MOBILE_BOARD_PAGING_SELECT]] 	 		

declare @p12 int
set @p12=0
exec ZP_MOBILE_BOARD_PAGING_SELECT @MASTER_SEQ=1,@CATEGORY_SEQ=1,@SEARCH_TEXT='',@REGION_NAME='',@DEL_YN='N',@NOTICE_YN='N',@nowPage=1,@pageSize=15,@CUSTOMER_NO=4244501,@FLAG=1,@MASTER_CODE=NULL,@TOTAL_COUNT=@p12 output
select @p12

■ MEMO						: VR 동영상 링크 정보 조회.

							

------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY             		      
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2017-05-26		아이비솔루션				최초생성
	2017-09-21		정지용					@MASTER_CODE 추가
	2017-10-10		김성호					동적쿼리 변환
	2017-10-27		정지용					쿼리 속도 문제 수정..
	2017-11-03		김성호					쿼리 수정
	2019-02-20		이명훈					공지글 공지글만 나오게 수정
	2019-09-03		김성호					FullTextIndex 검색 수정
	2019-09-06      김주환					SP_MOV2_BOARD_PAGING_SELECT 복사
											테이블[PKG_MASTER]		MASTER_NAME, SHOW_YN, ATT_CODE  추가
											테이블[INF_FILE_MASTER] FILE_NAME_S, FILE_CODE, FILE_TYPE, REGION_CODE, NATION_CODE, STATE_CODE, CITY_CODE 추가
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[ZP_MOBILE_BOARD_PAGING_SELECT]

	-- Add the parameters for the stored procedure here
	@MASTER_SEQ			INT,
	@SEARCH_TEXT		VARCHAR(50),
	@CATEGORY_SEQ		INT,
	@REGION_NAME		VARCHAR(20),
	@DEL_YN				VARCHAR(2),
	@NOTICE_YN			VARCHAR(2),
	@nowPage			INT,
    @pageSize			INT,
	@CUSTOMER_NO		INT,
	@FLAG				INT,
	@MASTER_CODE		VARCHAR(20) = NULL,
	@TOTAL_COUNT		INT OUT
AS
BEGIN

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @WHERE NVARCHAR(4000), @NOTICE_WHERE NVARCHAR(1000), @SORT_STRING VARCHAR(50);


	IF @NOTICE_YN = 'Y'
	BEGIN
		SELECT
			@WHERE = 'WHERE A.MASTER_SEQ = @MASTER_SEQ AND A.BOARD_SEQ = A.PARENT_SEQ AND A.NOTICE_YN = ''N''',
			@NOTICE_WHERE = 'UNION ALL
			SELECT A.MASTER_SEQ, A.BOARD_SEQ, A.PARENT_SEQ, A.NOTICE_YN, 0 AS [CTE_LEVEL]
			FROM HBS_DETAIL A WITH(NOLOCK)
			WHERE A.MASTER_SEQ = @MASTER_SEQ AND A.BOARD_SEQ = A.PARENT_SEQ AND A.NOTICE_YN = ''Y'' AND A.DEL_YN = ''N''',
			@SORT_STRING = 'A.NOTICE_YN DESC, '
	END
	ELSE
	BEGIN
		SELECT
			@WHERE = 'WHERE A.MASTER_SEQ = @MASTER_SEQ AND A.BOARD_SEQ = A.PARENT_SEQ',
			@NOTICE_WHERE = '',
			@SORT_STRING = ''
	END

	IF @DEL_YN <> ''
	BEGIN
		SELECT
			@WHERE = @WHERE + ' AND A.DEL_YN = @DEL_YN'
	END

	IF (@CUSTOMER_NO > 0)
	BEGIN
		SET @WHERE = @WHERE + ' AND A.NEW_CODE = @CUSTOMER_NO'
	END

	IF @CATEGORY_SEQ > 0
	BEGIN
		SET @WHERE = @WHERE + ' AND A.CATEGORY_SEQ = @CATEGORY_SEQ'
	END

	IF @MASTER_CODE <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.MASTER_CODE = @MASTER_CODE'
	END

	IF @REGION_NAME <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.REGION_NAME = @REGION_NAME'
	END

	IF (@SEARCH_TEXT <> '')
	BEGIN
		IF (CHARINDEX(' ', @SEARCH_TEXT) > 0)
			SELECT @SEARCH_TEXT = STUFF((SELECT (' AND "' + Data + '"') AS [text()] FROM [dbo].[FN_SPLIT](@SEARCH_TEXT, ' ') FOR XML PATH('')), 1, 5, '')

		SET @WHERE = @WHERE + (' AND (CONTAINS((A.CONTENTS, A.SUBJECT), @SEARCH_TEXT) OR A.NEW_CODE IN (SELECT CUS_NO FROM CUS_CUSTOMER_DAMO AA WITH(NOLOCK) WHERE AA.CUS_NAME LIKE @SEARCH_TEXT + ''%''))')

		-- 2019-09-03
		--SET @WHERE = @WHERE + (' AND (
		--							CONTAINS((A.CONTENTS, A.SUBJECT), @SEARCH_TEXT) OR CONTAINS(A.SUBJECT, @SEARCH_TEXT) OR 
		--							CONTAINS(A.CONTENTS, @SEARCH_TEXT) OR 
		--							A.NEW_CODE IN (SELECT CUS_NO FROM CUS_CUSTOMER_DAMO AA WHERE AA.CUS_NAME LIKE @SEARCH_TEXT + ''%''))')
	END
	print '@SEARCH_TEXT:'+ @SEARCH_TEXT
	print '@WHERE      :'+ @WHERE
	-- SORT 조건 만들기  
	SET @SORT_STRING = @SORT_STRING + ' A.PARENT_SEQ DESC, Z.CTE_LEVEL ASC'


	IF @NOTICE_YN = 'Y'
	BEGIN
		SET @SQLSTRING = N'
		-- 전체 게시물 수
		SELECT @TOTAL_COUNT = COUNT(*)
		FROM (
			SELECT A.MASTER_SEQ, A.BOARD_SEQ, A.PARENT_SEQ, A.NOTICE_YN, 0 AS [CTE_LEVEL]
			FROM HBS_DETAIL A WITH(NOLOCK)
			' + @WHERE + N'
			' + @NOTICE_WHERE + N'
		) A;

		SELECT
			A.NOTICE_YN,		A.MASTER_SEQ,		A.BOARD_SEQ,		A.SUBJECT,			A.SHOW_COUNT,	
			A.PARENT_SEQ,		A.LEVEL,			A.STEP,				A.COMPLETE_YN,		A.EDIT_PASS,
			A.LOCK_YN,			A.MASTER_CODE,		A.REGION_NAME,		C.CUS_NAME AS [NICK_NAME],
			A.NEW_DATE,			A.DEL_YN,			A.NEW_CODE AS [CUS_NO],					A.NEW_CODE,		
			A.CATEGORY_SEQ,		A.CONTENTS,			A.EMP_CODE,			B.CATEGORY_NAME,
			(SELECT COUNT(*) FROM HBS_FILE WITH(NOLOCK) WHERE MASTER_SEQ = A.MASTER_SEQ AND BOARD_SEQ = A.BOARD_SEQ) AS FILE_COUNT
		FROM (
			SELECT A.MASTER_SEQ, A.BOARD_SEQ, A.PARENT_SEQ, A.NOTICE_YN, 0 AS [CTE_LEVEL]
			FROM HBS_DETAIL A WITH(NOLOCK)
			WHERE A.MASTER_SEQ = @MASTER_SEQ AND A.BOARD_SEQ = A.PARENT_SEQ AND A.NOTICE_YN = ''Y'' AND A.DEL_YN = ''N''
		) Z
		INNER JOIN HBS_DETAIL A WITH(NOLOCK) ON Z.MASTER_SEQ = A.MASTER_SEQ AND Z.BOARD_SEQ = A.BOARD_SEQ
		LEFT JOIN HBS_CATEGORY B WITH(NOLOCK) ON A.MASTER_SEQ = B.MASTER_SEQ AND A.CATEGORY_SEQ = B.CATEGORY_SEQ
		LEFT JOIN CUS_CUSTOMER_damo C WITH(NOLOCK) ON A.NEW_CODE = C.CUS_NO
		ORDER BY ' + @SORT_STRING + N';
		'
	END

	ELSE
	BEGIN
		SET @SQLSTRING = N'
		-- 전체 게시물 수
		SELECT @TOTAL_COUNT = COUNT(*)
		FROM (
			SELECT A.MASTER_SEQ, A.BOARD_SEQ, A.PARENT_SEQ, A.NOTICE_YN, 0 AS [CTE_LEVEL]
			FROM HBS_DETAIL A WITH(NOLOCK)
			' + @WHERE + N'
			' + @NOTICE_WHERE + N'
		) A;

		WITH BOARD_LIST AS (
			SELECT A.MASTER_SEQ, A.BOARD_SEQ, A.PARENT_SEQ, A.NOTICE_YN
			FROM HBS_DETAIL A			WITH(NOLOCK)
			' + @WHERE + N'
			ORDER BY A.MASTER_SEQ, A.BOARD_SEQ DESC
			OFFSET ((@NOWPAGE - 1) * @PAGESIZE) ROWS FETCH NEXT @PAGESIZE
			ROWS ONLY
		), COMMENT_LIST AS (
			SELECT A.MASTER_SEQ, A.BOARD_SEQ, A.PARENT_SEQ, A.NOTICE_YN, 0 AS [CTE_LEVEL]
			FROM BOARD_LIST A
			UNION ALL
			SELECT A.MASTER_SEQ, A.BOARD_SEQ, A.PARENT_SEQ, A.NOTICE_YN, (B.CTE_LEVEL + 1)
			FROM HBS_DETAIL A WITH(NOLOCK)
			INNER JOIN COMMENT_LIST B ON A.MASTER_SEQ = B.MASTER_SEQ AND A.PARENT_SEQ = B.BOARD_SEQ AND A.BOARD_SEQ <> B.PARENT_SEQ
		), NOTICE_LIST AS (
			SELECT A.MASTER_SEQ, A.BOARD_SEQ, A.PARENT_SEQ, A.NOTICE_YN, A.CTE_LEVEL
			FROM COMMENT_LIST A
			' + @NOTICE_WHERE + N'
		)
		SELECT	A.NOTICE_YN,		A.MASTER_SEQ,		A.BOARD_SEQ,		A.SUBJECT,			A.SHOW_COUNT,	
				A.PARENT_SEQ,		A.LEVEL,			A.STEP,				A.COMPLETE_YN,		A.EDIT_PASS,
				A.LOCK_YN,			A.MASTER_CODE,		A.REGION_NAME,		C.CUS_NAME AS [NICK_NAME],
				A.NEW_DATE,			A.DEL_YN,			A.NEW_CODE AS [CUS_NO],					A.NEW_CODE,		
				A.CATEGORY_SEQ,		A.CONTENTS,			A.EMP_CODE,			B.CATEGORY_NAME,
				(	SELECT	COUNT(*) 
					FROM	HBS_FILE	WITH(NOLOCK) 
					WHERE	MASTER_SEQ	=	A.MASTER_SEQ 
					AND		BOARD_SEQ	=	A.BOARD_SEQ	)	AS FILE_COUNT, 
				E.MASTER_NAME,		E.SHOW_YN,			E.ATT_CODE,
				F.FILE_NAME_S,		F.FILE_CODE,		F.FILE_TYPE,		F.REGION_CODE,		F.NATION_CODE, 
				F.STATE_CODE, F.CITY_CODE
		FROM NOTICE_LIST Z
		INNER JOIN HBS_DETAIL A WITH(NOLOCK) ON Z.MASTER_SEQ = A.MASTER_SEQ AND Z.BOARD_SEQ = A.BOARD_SEQ
		LEFT JOIN HBS_CATEGORY B WITH(NOLOCK) ON A.MASTER_SEQ = B.MASTER_SEQ AND A.CATEGORY_SEQ = B.CATEGORY_SEQ
		LEFT JOIN PKG_MASTER E		WITH(NOLOCK)	ON A.MASTER_CODE	= E.MASTER_CODE			-- 2019-09-06 ADD
		LEFT JOIN INF_FILE_MASTER F WITH(NOLOCK)	ON F.FILE_CODE		= E.MAIN_FILE_CODE		-- 2019.09.06 ADD
		LEFT JOIN CUS_CUSTOMER_damo C WITH(NOLOCK) ON A.NEW_CODE = C.CUS_NO
		ORDER BY ' + @SORT_STRING + N';'
	END

	SET @PARMDEFINITION = N'
		@NOWPAGE INT,
		@PAGESIZE INT,
		@TOTAL_COUNT INT OUTPUT,
		@MASTER_SEQ INT,
		@CATEGORY_SEQ INT,
		@REGION_NAME VARCHAR(30),
		@MASTER_CODE VARCHAR(10),
		@SEARCH_TEXT VARCHAR(100),
		@DEL_YN VARCHAR(1),
		@CUSTOMER_NO INT';

	PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@NOWPAGE,
		@PAGESIZE,
		@TOTAL_COUNT OUTPUT,
		@MASTER_SEQ,
		@CATEGORY_SEQ,
		@REGION_NAME,
		@MASTER_CODE,
		@SEARCH_TEXT,
		@DEL_YN,
		@CUSTOMER_NO;

	
END
GO
