USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================

■ USP_NAME					: XP_COM_BBS_DETAIL_LIST_ERP_SELECT
■ DESCRIPTION				: BTMS 게시물 검색
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
	-- agtCode : 거래처 코드
	SELECT @PAGE_INDEX=1,@PAGE_SIZE=30,@KEY=N'MasterSeq=2&BoardType=1&CategorySeq=&RegionName=&MasterCode=&SearchType=&SearchText=&IsNotice=N&IsDel=N&IsEmp=N&Ntype=Y',@ORDER_BY=1
	exec XP_COM_BBS_DETAIL_LIST_SELECT 1, 15, 10, N'MasterSeq=3&AgtCode=&SearchType=1&SearchText=&StartDate=&EndDate=&isErp=Y', 1

	SELECT @TOTAL_COUNT
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-04-26		이유라			최초생성
   2016-12-26		이유라			국가없을시 '전체'로 표기
================================================================================================================*/ 
CREATE  PROCEDURE [dbo].[XP_COM_BBS_DETAIL_LIST_ERP_SELECT]
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

	DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000), @JOINTABLE NVARCHAR(1000), @JOINTABLE2 NVARCHAR(1000), @COLUMN NVARCHAR(100),@COLUMN2 NVARCHAR(100);
	DECLARE @WHERE NVARCHAR(4000), @NOTICE_WHERE NVARCHAR(1000), @SORT_STRING VARCHAR(350), @ERP_NOTICE_UNION NVARCHAR(1000);
	DECLARE @MASTER_SEQ INT,@AGT_CODE VARCHAR(20), @BOARD_TYPE VARCHAR(1), @CATEGORY_SEQ INT, @NATION_CODE VARCHAR(30), @REGION_CODE VARCHAR(30), @BT_CODE varchar(20), @MASTER_CODE VARCHAR(10)
		, @SEARCH_TYPE VARCHAR(1), @SEARCH_TEXT VARCHAR(100), @NOTICE_YN VARCHAR(1), @DEL_YN VARCHAR(1), @EMPLOYEE_YN VARCHAR(1), @NTYPE VARCHAR(1);
	DECLARE	@ERP_YN VARCHAR(1), @START_DATE VARCHAR(20), @END_DATE VARCHAR(20), @REQUEST_SEQ INT, @COMMENT_COUNT VARCHAR(1), @MANAGER_EMP_CODE VARCHAR(7), @EMP_TYPE VARCHAR(50);

	SELECT
		@MASTER_SEQ = CONVERT(INT, DBO.FN_PARAM(@KEY, 'MasterSeq')),
		@BOARD_TYPE = DBO.FN_PARAM(@KEY, 'BoardType'),
		@AGT_CODE = DBO.FN_PARAM(@KEY, 'AgtCode'),
		@CATEGORY_SEQ = CONVERT(INT, DBO.FN_PARAM(@KEY, 'CategorySeq')),
		@NATION_CODE = DBO.FN_PARAM(@KEY, 'NationCode'),
		@REGION_CODE = DBO.FN_PARAM(@KEY, 'RegionCode'),
		@BT_CODE = DBO.FN_PARAM(@KEY, 'BtCode'),
		@MASTER_CODE = DBO.FN_PARAM(@KEY, 'MasterCode'),
		@SEARCH_TYPE = DBO.FN_PARAM(@KEY, 'SearchType'),
		@SEARCH_TEXT = DBO.FN_PARAM(@KEY, 'SearchText'),
		@NOTICE_YN = DBO.FN_PARAM(@KEY, 'IsNotice'),
		@DEL_YN = DBO.FN_PARAM(@KEY, 'IsDel'),
		@NTYPE = DBO.FN_PARAM(@KEY, 'Ntype'),
		@ERP_YN = DBO.FN_PARAM(@KEY, 'isErp'),
		@START_DATE = DBO.FN_PARAM(@KEY, 'StartDate'),
		@END_DATE = DBO.FN_PARAM(@KEY, 'EndDate'),
		@REQUEST_SEQ = DBO.FN_PARAM(@KEY, 'RequestSeq'),
		@COMMENT_COUNT = DBO.FN_PARAM(@KEY, 'CommentCount'),
		@MANAGER_EMP_CODE = DBO.FN_PARAM(@KEY, 'ManagerEmpCode');

		-- 자유여행 담당자별 문의만 'Y' [MASTER_SEQ : 24]
        --PRINT DBO.FN_PARAM(@KEY, 'SearchText')

	IF @NOTICE_YN = 'Y'
	BEGIN
		SELECT
			@WHERE = 'WHERE A.MASTER_SEQ = @MASTER_SEQ AND A.NOTICE_YN = ''N'' AND A.DEL_YN = ''N'' ',
			@NOTICE_WHERE = 'WHERE A.MASTER_SEQ = @MASTER_SEQ AND A.NOTICE_YN = ''Y'' AND A.DEL_YN = ''N'' ',
			@SORT_STRING = ' A.NOTICE_YN DESC, '
	END
	ELSE
	BEGIN
		SELECT
			@WHERE = 'WHERE A.MASTER_SEQ = @MASTER_SEQ AND A.PARENT_SEQ = A.BOARD_SEQ AND A.NOTICE_YN = ''N'' AND A.DEL_YN = ''N''',
			@NOTICE_WHERE = 'WHERE 1 <> 1',
			@SORT_STRING = ''
	END

	IF (@ERP_YN <> '' AND @NOTICE_YN = 'Y')
	BEGIN
		SELECT
			@WHERE = 'WHERE A.MASTER_SEQ = @MASTER_SEQ AND A.NOTICE_YN = ''Y'' AND A.DEL_YN = ''N'' ',
			@NOTICE_WHERE = 'WHERE A.MASTER_SEQ = @MASTER_SEQ AND A.NOTICE_YN = ''Y'' AND A.DEL_YN = ''N'' ',
			@ERP_NOTICE_UNION = ''
	END
	ELSE
	BEGIN
		SET @ERP_NOTICE_UNION = 'SELECT * FROM LIST  UNION ALL '
	END

	IF(@ERP_YN <> '' )
	BEGIN 
		SET @EMP_TYPE = ' A.NEW_SEQ  '
	END
	ELSE
	BEGIN 
		SET @EMP_TYPE = ' ISNULL(A.EDT_SEQ, A.NEW_SEQ) '
	END

	-- ERP, 상담게시판의 경우 삭제된것도 노출
	IF(@ERP_YN <> '' AND @MASTER_SEQ = '4')
	BEGIN
		SELECT
			@WHERE = 'WHERE A.MASTER_SEQ = @MASTER_SEQ AND A.PARENT_SEQ = A.BOARD_SEQ AND A.NOTICE_YN = ''N'' '
	END

	-- 공지사항만 TOP으로 끊어오는 경우 사용
	IF @NTYPE <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.NOTICE_YN = @NTYPE'
	END
	IF @DEL_YN <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.DEL_YN = @DEL_YN  WHERE AA.MASTER_SEQ = A.MASTER_SEQ AND AA.BOARD_SEQ = A.PARENT_SEQ AND AA.DEL_YN = @DEL_YN))'
		SET @NOTICE_WHERE = @NOTICE_WHERE + ' AND A.DEL_YN = @DEL_YN  WHERE AA.MASTER_SEQ = A.MASTER_SEQ AND AA.BOARD_SEQ = A.PARENT_SEQ AND AA.DEL_YN = @DEL_YN))'
	END
	ELSE
	BEGIN
		SELECT @COLUMN = 'B.CATEGORY_NAME', @JOINTABLE = N'LEFT JOIN COM_BBS_CATEGORY B ON A.MASTER_SEQ = B.MASTER_SEQ AND A.CATEGORY_SEQ = B.CATEGORY_SEQ'
	END
	BEGIN
		SELECT @COLUMN2 = 'BB.CATEGORY_NAME AS REQUEST_NAME', @JOINTABLE2 = N'LEFT JOIN COM_BBS_CATEGORY BB ON A.MASTER_SEQ = BB.MASTER_SEQ AND A.REQUEST_SEQ = BB.CATEGORY_SEQ'
	END

	IF @CATEGORY_SEQ > 0
	BEGIN
		SET @WHERE = @WHERE + ' AND A.CATEGORY_SEQ = @CATEGORY_SEQ'
	END

	IF @REQUEST_SEQ > 0
	BEGIN
		SET @WHERE = @WHERE + ' AND A.REQUEST_SEQ = @REQUEST_SEQ'
	END

	IF @COMMENT_COUNT <> ''
	BEGIN
		SELECT @WHERE = @WHERE + ' AND ISNULL((SELECT STATUS FROM COM_BBS_DETAIL WITH(NOLOCK) WHERE MASTER_SEQ = A.MASTER_SEQ AND PARENT_SEQ = A.BOARD_SEQ AND BOARD_SEQ <> PARENT_SEQ),1) = @COMMENT_COUNT '
	END

	IF @MASTER_CODE <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND A.MASTER_CODE = @MASTER_CODE'
	END

	IF @NATION_CODE <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND NATION_CODE = @NATION_CODE'
	END

	IF @REGION_CODE <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND REGION_CODE = @REGION_CODE'
	END

	IF @BT_CODE <> ''
	BEGIN
		SET @WHERE = @WHERE + ' AND BT_CODE = @BT_CODE'
	END

	IF (@AGT_CODE <>'' AND @MASTER_SEQ != '3' )
	BEGIN
		SET @WHERE = @WHERE + ' AND A.AGT_CODE = @AGT_CODE  '
	END

	IF (@AGT_CODE <>'' AND @MASTER_SEQ = '3' )
	BEGIN
		SET @WHERE = @WHERE + ' AND (A.AGT_CODE = @AGT_CODE OR A.ALL_NOTICE_YN = ''Y''
		OR STUFF(( SELECT '','' + B.AGT_CODE FROM COM_BBS_NOTICE B WHERE A.MASTER_SEQ = B.MASTER_SEQ AND A.BOARD_SEQ = B.BOARD_SEQ ORDER BY B.AGT_NAME FOR XML PATH ('''')),1,1,'''')  LIKE ''%'' + @AGT_CODE + ''%'')  '
	END

	IF (@AGT_CODE <>'' AND @MASTER_SEQ = '1' )
	BEGIN
		SET @NOTICE_WHERE = @NOTICE_WHERE + ' AND (A.AGT_CODE = @AGT_CODE OR A.ALL_NOTICE_YN = ''Y''
		OR STUFF(( SELECT '','' + B.AGT_CODE FROM COM_BBS_NOTICE B WHERE A.MASTER_SEQ = B.MASTER_SEQ AND A.BOARD_SEQ = B.BOARD_SEQ ORDER BY B.AGT_NAME FOR XML PATH ('''')),1,1,'''')  LIKE ''%'' + @AGT_CODE + ''%'') '
	END

	IF LEN(@START_DATE) > 0
	BEGIN
		SELECT @WHERE = @WHERE + (  
			' AND A.NEW_DATE >= CONVERT(DATETIME, @START_DATE, 121)  '
		)
	END

	IF LEN(@END_DATE) > 0
	BEGIN
		SELECT @WHERE = @WHERE + (  
			' AND A.NEW_DATE < CONVERT(DATETIME, @END_DATE, 121) '
		)
	END

	IF(@MANAGER_EMP_CODE <> '')
	BEGIN 
		SELECT @WHERE = @WHERE + (  
			' AND  A.AGT_CODE IN ( SELECT AGT_CODE FROM COM_MANAGER WHERE EMP_CODE = @MANAGER_EMP_CODE ) '
		)
	END

	IF (@SEARCH_TYPE <> '' AND @SEARCH_TEXT <> '')
	BEGIN
		--IF (@SEARCH_TYPE <> 4 AND CHARINDEX(' ', @SEARCH_TEXT) > 0)
		IF @SEARCH_TYPE <> 4 AND @SEARCH_TYPE <> 5
			SELECT @SEARCH_TEXT = STUFF((SELECT (' AND "' + Data + '"') AS [text()] FROM [dbo].[FN_SPLIT](@SEARCH_TEXT, ' ') FOR XML PATH('')), 1, 5, '')
		-- 제목내용 = 1, 제목 = 2, 내용 = 3, 작성자 = 4, 출장번호 = 5
		SET @WHERE = @WHERE + (
			CASE @SEARCH_TYPE
				WHEN '1' THEN ' AND CONTAINS((A.CONTENTS, A.SUBJECT), @SEARCH_TEXT)'
				WHEN '2' THEN ' AND CONTAINS(A.SUBJECT, @SEARCH_TEXT)'
				WHEN '3' THEN ' AND CONTAINS(A.CONTENTS, @SEARCH_TEXT)'
				WHEN '4' THEN ' AND (A.NEW_SEQ IN (SELECT EMP_SEQ FROM COM_EMPLOYEE AA WHERE AA.KOR_NAME LIKE ''%'' + @SEARCH_TEXT + ''%'' AND A.AGT_CODE = AA.AGT_CODE )) '
				WHEN '5' THEN ' AND A.BT_CODE = @SEARCH_TEXT '
				ELSE ' AND CONTAINS(A.SUBJECT, @SEARCH_TEXT)'
			END
		)
	END

	-- SORT 조건 만들기  
	SELECT @SORT_STRING = @SORT_STRING + (  
		CASE @ORDER_BY
			WHEN 1 THEN ' A.PARENT_SEQ DESC'
			WHEN 2 THEN ' A.NEW_DATE ASC'
			WHEN 3 THEN ' A.PARENT_SEQ DESC'
		END
	)
	
	SET @SQLSTRING = N'
	-- 전체 게시물 수
	SELECT @TOTAL_COUNT = COUNT(*)
	FROM COM_BBS_DETAIL A WITH(NOLOCK)
	LEFT JOIN COM_MANAGER B ON A.AGT_CODE = B.AGT_CODE AND A.CATEGORY_SEQ = B.MANAGER_TYPE
	' + @WHERE + N';
	WITH LIST AS
	(
		SELECT A.NOTICE_YN, A.MASTER_SEQ, A.BOARD_SEQ
		FROM COM_BBS_DETAIL A WITH(NOLOCK)
		LEFT JOIN COM_MANAGER B ON A.AGT_CODE = B.AGT_CODE AND A.CATEGORY_SEQ = B.MANAGER_TYPE
		' + @WHERE + N'
		ORDER BY ' + @SORT_STRING + '
		OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE
		ROWS ONLY
	)
	SELECT
		A.*,(CASE WHEN C.KOR_NAME IS NOT NULL THEN C.KOR_NAME ELSE ''전체'' END) AS NATION_NAME, D.KOR_NAME AS REGION_NAME,
		A.NEW_SEQ AS [CUS_NO],A.NEW_SEQ,A.STATUS, A.ALL_NOTICE_YN,
		 E.KOR_NAME AS COM_EMP_NAME,	K.TEAM_NAME, M.POS_NAME, (SELECT KOR_NAME FROM AGT_MASTER WHERE E.AGT_CODE = AGT_CODE) AS COM_AGT_NAME,' + @COLUMN + ',' + @COLUMN2 + ' ,
		G.KOR_NAME AS ERP_EMP_NAME, H.TEAM_NAME AS ERP_TEAM_NAME,
		(SELECT PUB_VALUE FROM COD_PUBLIC  WHERE PUB_TYPE=''EMP.POSTYPE'' AND PUB_CODE=G.POS_TYPE) AS [ERP_POS_NAME],
		(SELECT COUNT(*) FROM COM_BBS_FILE  WHERE MASTER_SEQ = A.MASTER_SEQ AND BOARD_SEQ = A.BOARD_SEQ) AS FILE_COUNT,
		ISNULL((SELECT STATUS FROM COM_BBS_DETAIL WITH(NOLOCK) WHERE MASTER_SEQ = A.MASTER_SEQ AND PARENT_SEQ = A.BOARD_SEQ AND BOARD_SEQ <> PARENT_SEQ), 1)  AS COMMENT_STATUS,
		STUFF(( SELECT '','' + B.AGT_NAME FROM COM_BBS_NOTICE B WHERE A.MASTER_SEQ = B.MASTER_SEQ AND A.BOARD_SEQ = B.BOARD_SEQ ORDER BY B.AGT_NAME FOR XML PATH ('''')),1,1,'''') AS NOTICE_AGENT_NAME,
		STUFF(( SELECT '','' + B.AGT_CODE FROM COM_BBS_NOTICE B WHERE A.MASTER_SEQ = B.MASTER_SEQ AND A.BOARD_SEQ = B.BOARD_SEQ ORDER BY B.AGT_NAME FOR XML PATH ('''')),1,1,'''') AS NOTICE_AGENT_CODE
	FROM (
		' + @ERP_NOTICE_UNION + '
		SELECT A.NOTICE_YN, A.MASTER_SEQ, A.BOARD_SEQ FROM COM_BBS_DETAIL A WITH(NOLOCK)
		' + @NOTICE_WHERE + ' 
	) Z
	INNER JOIN COM_BBS_DETAIL A WITH(NOLOCK) ON Z.MASTER_SEQ = A.MASTER_SEQ AND Z.BOARD_SEQ = A.BOARD_SEQ	
	' + @JOINTABLE + N'
	' + @JOINTABLE2 + N' 
	LEFT JOIN COM_EMPLOYEE E ON ' + @EMP_TYPE + N'= E.EMP_SEQ AND A.AGT_CODE = E.AGT_CODE 
	LEFT JOIN COM_TEAM K WITH(NOLOCK) ON E.TEAM_SEQ = K.TEAM_SEQ AND E.AGT_CODE = K.AGT_CODE
    LEFT JOIN COM_POSITION M WITH(NOLOCK) ON E.POS_SEQ = M.POS_SEQ AND E.AGT_CODE = M.AGT_CODE
   	LEFT JOIN PUB_NATION C ON A.NATION_CODE = C.NATION_CODE
	LEFT JOIN PUB_REGION D ON A.REGION_CODE = D.REGION_CODE
	LEFT JOIN AGT_MASTER F ON A.AGT_CODE = F.AGT_CODE
	LEFT JOIN EMP_MASTER G ON A.EMP_CODE = G.EMP_CODE
	LEFT JOIN EMP_TEAM H ON G.TEAM_CODE = H.TEAM_CODE
	ORDER BY ' + @SORT_STRING

print @SQLSTRING

	SET @PARMDEFINITION = N'
		@PAGE_INDEX INT,
		@PAGE_SIZE INT,
		@TOTAL_COUNT INT OUTPUT,
		@MASTER_SEQ INT,
		@CATEGORY_SEQ INT,
		@NATION_CODE VARCHAR(30),
		@REGION_CODE VARCHAR(30),
		@BT_CODE VARCHAR(20),
		@MASTER_CODE VARCHAR(10),
		@AGT_CODE VARCHAR(20),
		@SEARCH_TEXT VARCHAR(100),
		@DEL_YN VARCHAR(1),
		@NTYPE VARCHAR(1),
		@ERP_YN VARCHAR(1),
		@START_DATE VARCHAR(20),
		@END_DATE VARCHAR(20),
		@REQUEST_SEQ INT,
		@COMMENT_COUNT VARCHAR(1),
		@MANAGER_EMP_CODE VARCHAR(7),
		@EMP_TYPE VARCHAR(50)';

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION,
		@PAGE_INDEX,
		@PAGE_SIZE,
		@TOTAL_COUNT OUTPUT,
		@MASTER_SEQ,
		@CATEGORY_SEQ,
		@NATION_CODE,
		@REGION_CODE,
		@BT_CODE,
		@MASTER_CODE,
		@AGT_CODE,
		@SEARCH_TEXT,
		@DEL_YN,
		@NTYPE,
		@ERP_YN,
		@START_DATE,
		@END_DATE,
		@REQUEST_SEQ,
		@COMMENT_COUNT,
		@MANAGER_EMP_CODE, 
		@EMP_TYPE;
END




GO
