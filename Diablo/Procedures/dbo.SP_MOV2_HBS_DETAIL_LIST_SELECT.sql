USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_MOV2_HBS_DETAIL_LIST_SELECT (XP_HBS_DETAIL_LIST_SELECT)
■ DESCRIPTION				: 게시물 검색
■ INPUT PARAMETER			: 
	@PAGE_INDEX  INT		: 현재 페이지
	@PAGE_SIZE  INT			: 한 페이지 표시 게시물 수
	@KEY		VARCHAR(400): 검색 키
	@ORDER_BY	INT			: 정렬 순서
■ OUTPUT PARAMETER			: 
	@TOTAL_COUNT INT OUTPUT	: 총 게시물 수       
■ EXEC						: 

	DECLARE @PAGE_INDEX INT, @PAGE_SIZE  INT, @TOTAL_COUNT INT, @KEY VARCHAR(400), @ORDER_BY INT

	-- BoardType: 1 계층형, 2 답변형
	-- IsNotice: 'Y'일때는 공지사항은 무조건 노출
	-- IsDel: 'N' 삭제되지 않은것, 'Y' 삭제된건, '' 무시
	-- SearchType: 제목내용 = 1, 제목 = 2, 내용 = 3, 작성자 = 4
	-- IsEmp: 'Y' 담당자게시판, 'N' 일반게시판
	SELECT @PAGE_INDEX=1,@PAGE_SIZE=30,@KEY=N'MasterSeq=1&BoardType=1&CategorySeq=&RegionName=&MasterCode=&SearchType=&SearchText=&IsNotice=N&IsDel=N&IsEmp=N&Ntype=Y',@ORDER_BY=1

	exec SP_MOV2_HBS_DETAIL_LIST_SELECT @page_index, @page_size, @total_count output, @key, @order_by
	SELECT @TOTAL_COUNT

	--//웹진//
	DECLARE @PAGE_INDEX INT, @PAGE_SIZE  INT, @TOTAL_COUNT INT, @KEY VARCHAR(400), @ORDER_BY INT

	-- BoardType: 1 계층형, 2 답변형
	-- IsNotice: 'Y'일때는 공지사항은 무조건 노출
	-- IsDel: 'N' 삭제되지 않은것, 'Y' 삭제된건, '' 무시
	-- SearchType: 제목내용 = 1, 제목 = 2, 내용 = 3, 작성자 = 4
	-- IsEmp: 'Y' 담당자게시판, 'N' 일반게시판
	SELECT @PAGE_INDEX=1,@PAGE_SIZE=30,@KEY=N'MasterSeq=16&BoardType=1&CategorySeq=&RegionName=&MasterCode=&SearchType=&SearchText=&IsNotice=Y&IsDel=N&TopWebzinBoardSeq=348',@ORDER_BY=1

	exec SP_MOV2_HBS_DETAIL_LIST_SELECT @page_index, @page_size, @total_count output, @key, @order_by
	SELECT @TOTAL_COUNT

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-08		김성호			최초생성
   2013-05-31		김성호			자유여행 담당자별 문의 일때 EMPLOYEE_YN = 'Y'로 세팅
   2013-06-08		김성호			고객명 & 직원명 통합 검색으로 수정
   2013-06-10		김성호			EMP_CODE 항목 추가
   2013-06-10		김성호			CATEGORY_SEQ INT 수정 (전체 값이 0)
   2013-06-27		김성호			본문이 삭제 되었을때 댓글로 검색되지 않게 수정
   2013-07-10		김성호			공지사항만 가져오기 위해 조건 NTYPE 추가  
   2015-10-01		정지용			답변유무 조건 추가
   2015-03-22		정지용			Index Spool 발생해서 쿼리가 느려짐 인라인 쿼리에 재귀하는 master_seq 제거 및 @MASTER_SEQ 로 대체
   2017-08-03		박형만			티몬항공 카테고리 안나오기 , isErp추가 
   2017-09-13		IBSOLUTION		웹진 검색 시 Order By 필터 추가(2, 3)
   2017-09-13		IBSOLUTION		웹진 상단 고정 리스트를 위해 @TOPWEBZIN_BOARD_SEQ 추가 : 해당 SEQ를 제외하고 조회
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[SP_MOV2_HBS_DETAIL_LIST_SELECT]
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

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @JOINTABLE NVARCHAR(1000), @COLUMN NVARCHAR(100);
	DECLARE @WHERE NVARCHAR(4000), @NOTICE_WHERE NVARCHAR(1000), @SORT_STRING VARCHAR(50);
	DECLARE @MASTER_SEQ INT, @BOARD_TYPE VARCHAR(1), @CATEGORY_SEQ INT, @REGION_NAME VARCHAR(30), @MASTER_CODE VARCHAR(10)
		, @SEARCH_TYPE VARCHAR(1), @SEARCH_TEXT VARCHAR(100), @NOTICE_YN VARCHAR(1), @DEL_YN VARCHAR(1), @EMPLOYEE_YN VARCHAR(1), @NTYPE VARCHAR(1), @COMPLETE_YN VARCHAR(1)
		, @ERP_YN VARCHAR(1), @TOPWEBZIN_BOARD_SEQ INT


	SELECT
		@MASTER_SEQ = CONVERT(INT, DBO.FN_PARAM(@KEY, 'MasterSeq')),
		@BOARD_TYPE = DBO.FN_PARAM(@KEY, 'BoardType'),
		@CATEGORY_SEQ = CONVERT(INT, DBO.FN_PARAM(@KEY, 'CategorySeq')),
		@REGION_NAME = DBO.FN_PARAM(@KEY, 'RegionName'),
		@MASTER_CODE = DBO.FN_PARAM(@KEY, 'MasterCode'),
		@SEARCH_TYPE = DBO.FN_PARAM(@KEY, 'SearchType'),
		@SEARCH_TEXT = DBO.FN_PARAM(@KEY, 'SearchText'),
		@NOTICE_YN = DBO.FN_PARAM(@KEY, 'IsNotice'),
		@DEL_YN = DBO.FN_PARAM(@KEY, 'IsDel'),
		@NTYPE = DBO.FN_PARAM(@KEY, 'Ntype'),
		@COMPLETE_YN = DBO.FN_PARAM(@KEY, 'CompleteYn'),
		-- 자유여행 담당자별 문의만 'Y' [MASTER_SEQ : 24]
		@EMPLOYEE_YN = CASE CONVERT(INT, DBO.FN_PARAM(@KEY, 'MasterSeq')) WHEN 24 THEN 'Y' ELSE 'N' END,
		--@EMPLOYEE_YN = DBO.FN_PARAM(@KEY, 'IsEmp')
		@ERP_YN = DBO.FN_PARAM(@KEY, 'IsErp'),
		@TOPWEBZIN_BOARD_SEQ = CONVERT(INT, DBO.FN_PARAM(@KEY, 'TopWebzinBoardSeq'))

--PRINT DBO.FN_PARAM(@KEY, 'SearchText')

	IF @NOTICE_YN = 'Y'
	BEGIN
		SELECT
			@WHERE = 'WHERE A.MASTER_SEQ = @MASTER_SEQ AND A.NOTICE_YN = ''N''',
			@NOTICE_WHERE = 'WHERE A.MASTER_SEQ = @MASTER_SEQ AND A.NOTICE_YN = ''Y'' AND A.LEVEL = 0',
			@SORT_STRING = 'A.NOTICE_YN DESC, '
	END
	ELSE
	BEGIN
		SELECT
			@WHERE = 'WHERE A.MASTER_SEQ = @MASTER_SEQ',
			@NOTICE_WHERE = 'WHERE 1 <> 1',
			@SORT_STRING = ''
	END

	-- 공지사항만 TOP으로 끊어오는 경우 사용
	IF @NTYPE <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.NOTICE_YN = @NTYPE'
	END

	IF @DEL_YN <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.DEL_YN = @DEL_YN AND (A.LEVEL = 0 OR EXISTS(SELECT 1 FROM HBS_DETAIL AA WITH(NOLOCK) WHERE AA.MASTER_SEQ = @MASTER_SEQ AND AA.BOARD_SEQ = A.PARENT_SEQ AND AA.DEL_YN = @DEL_YN))'
		SET @NOTICE_WHERE = @NOTICE_WHERE + ' AND A.DEL_YN = @DEL_YN AND (A.LEVEL = 0 OR EXISTS(SELECT 1 FROM HBS_DETAIL AA WITH(NOLOCK) WHERE AA.MASTER_SEQ = @MASTER_SEQ AND AA.BOARD_SEQ = A.PARENT_SEQ AND AA.DEL_YN = @DEL_YN))'
	END

	IF @EMPLOYEE_YN = 'Y'
	BEGIN
		SELECT @COLUMN = 'C.KOR_NAME AS [CATEGORY_NAME]', @JOINTABLE = N'LEFT JOIN HBS_EMPLOYEE B ON A.CATEGORY_SEQ = B.SEQ_NO	-- 카테고리 대신 1:1담당자별 게시판 담당자 매핑
	LEFT JOIN EMP_MASTER C ON B.EMP_CODE = C.EMP_CODE'
	END
	ELSE
	BEGIN
		SELECT @COLUMN = 'B.CATEGORY_NAME', @JOINTABLE = N'LEFT JOIN HBS_CATEGORY B ON A.MASTER_SEQ = B.MASTER_SEQ AND A.CATEGORY_SEQ = B.CATEGORY_SEQ'
	END
	
	IF @CATEGORY_SEQ > 0
	BEGIN
		SET @WHERE = @WHERE + ' AND A.CATEGORY_SEQ = @CATEGORY_SEQ'
	END
	ELSE 
	BEGIN 
		IF @MASTER_SEQ = 4 AND @ERP_YN <> 'Y'   --ERP 가 아닐 경우에 
		BEGIN
			SET @WHERE = @WHERE + ' AND A.CATEGORY_SEQ NOT IN (90) ' -- 티몬항공 카테고리 제외 
		END 
		
	END 

	IF @MASTER_CODE <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.MASTER_CODE = @MASTER_CODE'
	END

	--웹진일 때 TOP 1 웹진의 SEQ를 제외하고 조회하도록 조건 추가
	IF (@MASTER_SEQ = 16 AND @TOPWEBZIN_BOARD_SEQ <> 0)
	BEGIN
		SET @WHERE = @WHERE + ' AND A.BOARD_SEQ <> @TOPWEBZIN_BOARD_SEQ'
	END

	IF @REGION_NAME <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND REGION_NAME = @REGION_NAME'
	END

	IF @COMPLETE_YN <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.COMPLETE_YN = @COMPLETE_YN'
	END

	IF (@SEARCH_TYPE <> '' AND @SEARCH_TEXT <> '')
	BEGIN
		--IF (@SEARCH_TYPE <> 4 AND CHARINDEX(' ', @SEARCH_TEXT) > 0)
		IF @SEARCH_TYPE <> 4
			SELECT @SEARCH_TEXT = STUFF((SELECT (' AND "' + Data + '"') AS [text()] FROM [dbo].[FN_SPLIT](@SEARCH_TEXT, ' ') FOR XML PATH('')), 1, 5, '')

		-- 제목내용 = 1, 제목 = 2, 내용 = 3, 작성자 = 4
		SET @WHERE = @WHERE + (
			CASE @SEARCH_TYPE
				WHEN '1' THEN ' AND CONTAINS((A.CONTENTS, A.SUBJECT), @SEARCH_TEXT)'
				WHEN '2' THEN ' AND CONTAINS(A.SUBJECT, @SEARCH_TEXT)'
				WHEN '3' THEN ' AND CONTAINS(A.CONTENTS, @SEARCH_TEXT)'
				WHEN '4' THEN ' AND (A.NEW_CODE IN (SELECT CUS_NO FROM CUS_CUSTOMER_DAMO AA WHERE AA.CUS_NAME LIKE @SEARCH_TEXT + ''%'') OR EMP_CODE IN (SELECT EMP_CODE FROM EMP_MASTER BB WHERE BB.KOR_NAME LIKE @SEARCH_TEXT + ''%''))'
				ELSE ' AND CONTAINS(A.SUBJECT, @SEARCH_TEXT)'
			END
		)
	END

	IF @BOARD_TYPE = '2'
	BEGIN
		SET @WHERE = @WHERE + ' AND A.LEVEL = 0'
	END

	-- SORT 조건 만들기  
	SELECT @SORT_STRING = @SORT_STRING + (  
		CASE @ORDER_BY
			WHEN 1 THEN ' A.PARENT_SEQ DESC, A.LEVEL ASC'
			WHEN 2 THEN ' A.SHOW_COUNT DESC'
			WHEN 3 THEN ' A.NEW_DATE ASC'
		END
	)

	SET @SQLSTRING = N'
	-- 전체 게시물 수
	SELECT @TOTAL_COUNT = COUNT(*)
	FROM HBS_DETAIL A WITH(NOLOCK)
	' + @WHERE + N';

	WITH LIST AS
	(
		SELECT A.NOTICE_YN, A.MASTER_SEQ, A.BOARD_SEQ
		FROM HBS_DETAIL A WITH(NOLOCK)
		' + @WHERE + N'
		ORDER BY ' + @SORT_STRING + '
		OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
		ROWS ONLY
	)
	SELECT
		A.NOTICE_YN,		A.MASTER_SEQ,		A.BOARD_SEQ,		A.SUBJECT,			A.SHOW_COUNT,	
		A.PARENT_SEQ,		A.LEVEL,			A.STEP,				A.COMPLETE_YN,		A.EDIT_PASS,
		A.LOCK_YN,			A.MASTER_CODE,		A.REGION_NAME,		A.NICKNAME,
		A.NEW_DATE,			A.DEL_YN,			A.NEW_CODE AS [CUS_NO],					A.NEW_CODE,		
		A.CATEGORY_SEQ,		A.CONTENTS,			A.EMP_CODE,			' + @COLUMN + ',
		--dbo.FN_CUS_GET_CUS_NAME(A.NEW_CODE) AS CUS_NAME, 
		(CASE WHEN A.EMP_CODE IS NULL THEN DBO.FN_CUS_GET_CUS_NAME(A.NEW_CODE) ELSE DBO.FN_CUS_GET_EMP_NAME(A.EMP_CODE) END) AS [CUS_NAME],
		(SELECT COUNT(*) FROM HBS_COMMENT WITH(NOLOCK) WHERE MASTER_SEQ = A.MASTER_SEQ AND BOARD_SEQ = A.BOARD_SEQ AND DEL_YN = ''N'') AS COMMENT_COUNT,
		(SELECT COUNT(*) FROM HBS_FILE WITH(NOLOCK) WHERE MASTER_SEQ = A.MASTER_SEQ AND BOARD_SEQ = A.BOARD_SEQ) AS FILE_COUNT		
	FROM (
		SELECT * FROM LIST
		UNION ALL
		SELECT A.NOTICE_YN, A.MASTER_SEQ, A.BOARD_SEQ
		FROM HBS_DETAIL A WITH(NOLOCK)
		' + @NOTICE_WHERE + ' 
	) Z
	INNER JOIN HBS_DETAIL A WITH(NOLOCK) ON Z.MASTER_SEQ = A.MASTER_SEQ AND Z.BOARD_SEQ = A.BOARD_SEQ		
	' + @JOINTABLE + N'
	ORDER BY ' + @SORT_STRING


	SET @PARMDEFINITION = N'
		@PAGE_INDEX INT,
		@PAGE_SIZE INT,
		@TOTAL_COUNT INT OUTPUT,
		@MASTER_SEQ INT,
		@CATEGORY_SEQ INT,
		@REGION_NAME VARCHAR(30),
		@MASTER_CODE VARCHAR(10),
		@SEARCH_TEXT VARCHAR(100),
		@DEL_YN VARCHAR(1),
		@NTYPE VARCHAR(1),
		@COMPLETE_YN VARCHAR(1),
		@TOPWEBZIN_BOARD_SEQ INT';

	PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@PAGE_INDEX,
		@PAGE_SIZE,
		@TOTAL_COUNT OUTPUT,
		@MASTER_SEQ,
		@CATEGORY_SEQ,
		@REGION_NAME,
		@MASTER_CODE,
		@SEARCH_TEXT,
		@DEL_YN,
		@NTYPE,
		@COMPLETE_YN,
		@TOPWEBZIN_BOARD_SEQ;

END

GO
