USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_HBS_DETAIL_QNA_LIST_SELECT
■ DESCRIPTION				: 고객 참여 게시물 검색
■ INPUT PARAMETER			: 
	@PAGE_INDEX  INT		: 현재 페이지
	@PAGE_SIZE  INT			: 한 페이지 표시 게시물 수
	@KEY		VARCHAR(400): 검색 키
	@ORDER_BY	INT			: 정렬 순서
■ OUTPUT PARAMETER			: 
	@TOTAL_COUNT INT OUTPUT	: 총 게시물 수       
■ EXEC						: 

'RT1703215175[티몬항공 예약 취소/변경문의][박형만님]'f

	DECLARE @PAGE_INDEX INT, @PAGE_SIZE  INT, @TOTAL_COUNT INT, @KEY VARCHAR(400), @ORDER_BY INT
	-- CusNo: 고객번호
	SELECT @PAGE_INDEX=1,@PAGE_SIZE=999,@KEY=N'MasterSeq=4&CusNo=0&IsDel=N&CategorySeq=90&MasterCode=RT1708025273',@ORDER_BY=1

	exec XP_HBS_DETAIL_QNA_LIST_SELECT @page_index, @page_size, @total_count output, @key, @order_by
	SELECT @TOTAL_COUNT

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-06-03		김성호			최초생성
   2013-10-29		김성호			게시판 멀티 검색 추가
   2017-03-21		박형만			CategorySeq 추가 
   2017-08-03		박형만			MasterCode 추가 (티몬은 ResCode)
   2022-05-30       이장훈			답변글이 여러개이면 가장 최근글만 보이도록 수정
================================================================================================================*/ 
CREATE  PROCEDURE [dbo].[XP_HBS_DETAIL_QNA_LIST_SELECT]
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

	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000);
	DECLARE @WHERE NVARCHAR(4000), @SORT_STRING VARCHAR(50);
	DECLARE @MASTER_SEQ VARCHAR(20), @DEL_YN VARCHAR(1), @CUS_NO INT , @CATEGORY_SEQ VARCHAR(10) ,@SEARCH_TITLE VARCHAR(100) ,@MASTER_CODE VARCHAR(20)

	SELECT
		@MASTER_SEQ = DBO.FN_PARAM(@KEY, 'MasterSeq'),
		@CUS_NO = CONVERT(INT, DBO.FN_PARAM(@KEY, 'CusNo')),
		@DEL_YN = DBO.FN_PARAM(@KEY, 'IsDel'),
		@CATEGORY_SEQ = DBO.FN_PARAM(@KEY, 'CategorySeq'),
		--@SEARCH_TITLE =  DBO.FN_PARAM(@KEY, 'SearchTitle'),
		@MASTER_CODE =  DBO.FN_PARAM(@KEY, 'MasterCode')
		--@WHERE = 'WHERE A.MASTER_SEQ IN (SELECT CONVERT(INT, DATA) FROM FN_SPLIT(@MASTER_SEQ, '','')) 
		--	AND A.PARENT_SEQ IN (SELECT BOARD_SEQ FROM HBS_DETAIL AA WHERE AA.MASTER_SEQ IN (SELECT CONVERT(INT, DATA) FROM FN_SPLIT(@MASTER_SEQ, '','')) AND AA.NEW_CODE = @CUS_NO) AND A.LEVEL = 0' 
	
	SET @WHERE = '
INNER JOIN (
	SELECT AA.MASTER_SEQ, AA.PARENT_SEQ
	FROM HBS_DETAIL AA WITH(NOLOCK)
	WHERE AA.MASTER_SEQ IN (SELECT CONVERT(INT, DATA) FROM FN_SPLIT(@MASTER_SEQ, '','') AAA)  
'
	IF (ISNULL(@CATEGORY_SEQ,'') <> '' AND  ISNULL(@CATEGORY_SEQ,'') <> '0' )
	BEGIN
		SET @WHERE = @WHERE + ' AND AA.CATEGORY_SEQ = '+ @CATEGORY_SEQ + ' ' 
	END 
	--MASTER_COD(RES_CODE)  로 검색(티몬만) 
	IF (ISNULL(@MASTER_CODE,'') <> '' )
	BEGIN
		SET @WHERE = @WHERE + '  AND AA.MASTER_CODE = '''+@MASTER_CODE+'''  AND LEVEL = 0  '  --본문글만 
	END 
	ELSE   -- 그외 일반검색 
	BEGIN 
		SET @WHERE = @WHERE + ' AND AA.NEW_CODE = @CUS_NO  '
	END 
	----SUBJECT  CONTAINS  로 검색(티몬만) 
	--IF (ISNULL(@SEARCH_TITLE,'') <> '' )
	--BEGIN
	--	SET @WHERE = @WHERE + '  AND CONTAINS(AA.SUBJECT, '''+@SEARCH_TITLE+''') '
	--END 

	
	IF ISNULL(@DEL_YN,'') <> '' 
	BEGIN
		--SET @WHERE = REPLACE(@WHERE, '--삭제조건', '')
		SET @WHERE = @WHERE + '  AND AA.DEL_YN = @DEL_YN '
	END


	SET @WHERE = @WHERE + ' 
) B ON A.MASTER_SEQ = B.MASTER_SEQ AND A.BOARD_SEQ = B.PARENT_SEQ';

	-- SORT 조건 만들기  
	SELECT @SORT_STRING = ' A.NEW_DATE DESC, A.PARENT_SEQ DESC, A.LEVEL ASC'

	SET @SQLSTRING = N'
	-- 전체 게시물 수
	SELECT @TOTAL_COUNT = COUNT(*)
	FROM HBS_DETAIL A' + @WHERE + N';

	WITH LIST AS
	(
		SELECT A.NOTICE_YN, A.MASTER_SEQ, A.BOARD_SEQ
		FROM HBS_DETAIL A WITH(NOLOCK)' + @WHERE + N'
		ORDER BY ' + @SORT_STRING + '
		OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
		ROWS ONLY
	)
	SELECT A.*, E.MASTER_NAME
		, F.FILE_CODE, F.REGION_CODE, F.NATION_CODE, F.STATE_CODE, F.CITY_CODE, F.FILE_TYPE
		, F.FILE_NAME, F.EXTENSION_NAME, F.FILE_NAME_L, F.FILE_NAME_M, F.FILE_NAME_S
		, (CASE WHEN B.CATEGORY_NAME IS NULL THEN D.KOR_NAME ELSE B.CATEGORY_NAME END) AS CATEGORY_NAME
		, CASE WHEN A.EMP_CODE IS NULL THEN DBO.FN_CUS_GET_CUS_NAME(A.NEW_CODE) ELSE DBO.FN_CUS_GET_EMP_NAME(A.EMP_CODE) END AS [NEW_NAME]
		, G.SUBJECT AS [A_SUBJECT], G.CONTENTS AS [A_CONTENTS], G.NEW_DATE AS [A_NEW_DATE], G.RES_CODE
		, CASE WHEN G.EMP_CODE IS NULL THEN DBO.FN_CUS_GET_CUS_NAME(G.NEW_CODE) ELSE DBO.FN_CUS_GET_EMP_NAME(G.EMP_CODE) END AS [A_NEW_NAME]
	FROM LIST Z
	INNER JOIN HBS_DETAIL A WITH(NOLOCK) ON Z.MASTER_SEQ = A.MASTER_SEQ AND Z.BOARD_SEQ = A.BOARD_SEQ
	LEFT JOIN HBS_CATEGORY B WITH(NOLOCK) ON B.MASTER_SEQ = A.MASTER_SEQ AND B.CATEGORY_SEQ = A.CATEGORY_SEQ
	LEFT JOIN HBS_EMPLOYEE C WITH(NOLOCK) ON C.SEQ_NO = A.CATEGORY_SEQ
	LEFT JOIN EMP_MASTER D WITH(NOLOCK) ON C.EMP_CODE = D.EMP_CODE
	LEFT JOIN PKG_MASTER E WITH(NOLOCK) ON E.MASTER_CODE = A.MASTER_CODE OR E.MASTER_CODE IN (SELECT AA.MASTER_CODE FROM PKG_DETAIL AA WHERE AA.PRO_CODE = A.MASTER_CODE)
	LEFT JOIN INF_FILE_MASTER F WITH(NOLOCK) ON F.FILE_CODE = E.MAIN_FILE_CODE
	--LEFT JOIN HBS_DETAIL G WITH(NOLOCK) ON A.MASTER_SEQ = G.MASTER_SEQ AND A.BOARD_SEQ = G.PARENT_SEQ AND G.LEVEL = 1
	LEFT JOIN  (	 
			SELECT * FROM (
				SELECT
					*
					, ROW_NUMBER() OVER (PARTITION BY PARENT_SEQ ORDER BY BOARD_SEQ DESC) AS ROW_NUM
				FROM HBS_DETAIL
			) T
			WHERE ROW_NUM = 1
	) G ON  A.MASTER_SEQ = G.MASTER_SEQ AND A.BOARD_SEQ = G.PARENT_SEQ AND G.LEVEL = 1
	
	ORDER BY ' + @SORT_STRING


	SET @PARMDEFINITION = N'
		@PAGE_INDEX INT,
		@PAGE_SIZE INT,
		@TOTAL_COUNT INT OUTPUT,
		@MASTER_SEQ VARCHAR(20),
		@DEL_YN VARCHAR(1),
		@CUS_NO INT';

	PRINT @SQLSTRING
		
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@PAGE_INDEX,
		@PAGE_SIZE,
		@TOTAL_COUNT OUTPUT,
		@MASTER_SEQ,
		@DEL_YN,
		@CUS_NO;

END
GO