USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: SP_CTI_CONSULT_SELECT_LIST
■ DESCRIPTION				: 고객약속/콜백처리
■ INPUT PARAMETER			: 
	@PAGE_INDEX				: 페이징 번호
	@PAGE_SIZE				: 페이지 사이즈(ROW 갯수)
	@TOTAL_COUNT			: 전체 count
	@KEY					: 조회 Parameter
■ OUTPUT PARAMETER			: 
	@TOTAL_COUNT			: 총건수
■ EXEC						: 
	EXEC SP_CTI_CONSULT_SELECT_LIST 1,10,'',''
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------

 ------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-17		곽병삼			최초생성
   2014-12-08		곽병삼			상담구분 조건 변경 및 수발신 조건 추가
   2014-12-16		곽병삼			SaveType이 1인 내용도 모두 조회.
   2014-12-17		곽병삼			상담이력 SAVE TYPE이 0인 내용만 조회 제외.
   2015-01-17		박노민			상담이력 SAVE TYPE이 0인 내용만 조회 추가.
   2015-02-05		박노민			설명추가
   2015-02-25		박노민			consult_content 항목추가
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_CONSULT_SELECT_LIST]
--DECLARE
	@PAGE_INDEX		INT,
	@PAGE_SIZE		INT,
	@TOTAL_COUNT	INT OUTPUT,
	@KEY			VARCHAR(2000)

AS

SET NOCOUNT ON

	DECLARE
		@COLS_NAME			VARCHAR(50)='CONSULT_DATE',
		@SORT				VARCHAR(50)='DESC',
		@SDATE	VARCHAR(10),
		@EDATE	VARCHAR(10),
		@TEAM_CODE	VARCHAR(3),
		@EMP_CODE	VARCHAR(7),
		@CONSULT_TYPE	VARCHAR(1),
		@CONSULT_RESULT	VARCHAR(1),
		@CUS_NAME	VARCHAR(20),
		@CUS_TEL	VARCHAR(15),
		@CALL_TYPE	VARCHAR(1),
		@WHERE NVARCHAR(4000),
		@SQL NVARCHAR(4000),
		@BSQL NVARCHAR(4000),
		@SUBSQL	NVARCHAR(4000),
		@PARM NVARCHAR(1000)

	--SET @SDATE = '2014-11-01'
	--SET @EDATE = '2014-11-17'
	--SET @TEAM_CODE = '538'
	--SET @EMP_CODE = '2012010'
	--SET @CONSULT_TYPE = ''
	--SET @CONSULT_RESULT = ''
	--SET @CUS_NAME = ''
	--SET @CUS_TEL = ''

	SELECT
		@SDATE = Diablo.DBO.FN_PARAM(@KEY, 'SDate'),
		@EDATE = Diablo.DBO.FN_PARAM(@KEY, 'EDate'),
		@TEAM_CODE = Diablo.DBO.FN_PARAM(@KEY, 'Team'),
		@EMP_CODE = Diablo.DBO.FN_PARAM(@KEY, 'Emp'),
		@CONSULT_TYPE = Diablo.DBO.FN_PARAM(@KEY, 'CType'),
		@CONSULT_RESULT = Diablo.DBO.FN_PARAM(@KEY, 'CResult'),
		@CUS_NAME = Diablo.DBO.FN_PARAM(@KEY, 'CusName'),
		@CUS_TEL = Diablo.DBO.FN_PARAM(@KEY, 'CusTel'),
		@CALL_TYPE = Diablo.DBO.FN_PARAM(@KEY, 'CallType');

	SET @WHERE = '';

	IF @COLS_NAME IS NULL OR @COLS_NAME = ''
		SET @COLS_NAME = 'CONSULT_DATE'
		
	IF @SORT IS NULL OR @SORT=''
		SET @SORT = 'DESC'

	IF ISNULL(@TEAM_CODE,'') <> ''
	BEGIN
		SET @WHERE += ' AND CTI.TEAM_CODE = ''' + @TEAM_CODE + ''''
	END

	IF ISNULL(@EMP_CODE,'') <> ''
	BEGIN
		SET @WHERE += ' AND CTI.EMP_CODE = ''' + @EMP_CODE + ''''
	END

	--IF ISNULL(@CONSULT_TYPE,'') <> ''
	--BEGIN
	--	SET @WHERE += ' AND CTI.CONSULT_TYPE = ''' + @CONSULT_TYPE + ''''
	--END
	SET @SUBSQL = ''
	IF ISNULL(@CONSULT_TYPE,'') = 'C'
	BEGIN
		SET @SUBSQL = '(SELECT COUNT(CONSULT_TYPE) FROM sirens.cti.CTI_CONSULT_TYPE WITH(NOLOCK) WHERE CONSULT_SEQ = CTI.CONSULT_SEQ AND CONSULT_TYPE = ''C'') AS CONSULT_TYPE1,'
		SET @SUBSQL += '(SELECT COUNT(CONSULT_TYPE) FROM sirens.cti.CTI_CONSULT_TYPE WITH(NOLOCK) WHERE CONSULT_SEQ = CTI.CONSULT_SEQ AND CONSULT_TYPE = ''R'') AS CONSULT_TYPE2,'
		SET @SUBSQL += '(SELECT COUNT(CONSULT_TYPE) FROM sirens.cti.CTI_CONSULT_TYPE WITH(NOLOCK) WHERE CONSULT_SEQ = CTI.CONSULT_SEQ AND CONSULT_TYPE = ''P'') AS CONSULT_TYPE3,'

		SET @WHERE += 'AND CTI.CONSULT_SEQ IN (SELECT CONSULT_SEQ FROM sirens.cti.CTI_CONSULT_TYPE WHERE CONSULT_SEQ = CTI.CONSULT_SEQ AND CONSULT_TYPE = ''C'')'
	END
	ELSE IF ISNULL(@CONSULT_TYPE,'') = 'R'
	BEGIN
		SET @SUBSQL = '(SELECT COUNT(CONSULT_TYPE) FROM sirens.cti.CTI_CONSULT_TYPE WITH(NOLOCK) WHERE CONSULT_SEQ = CTI.CONSULT_SEQ AND CONSULT_TYPE = ''C'') AS CONSULT_TYPE1,'
		SET @SUBSQL += '(SELECT COUNT(CONSULT_TYPE) FROM sirens.cti.CTI_CONSULT_TYPE WITH(NOLOCK) WHERE CONSULT_SEQ = CTI.CONSULT_SEQ AND CONSULT_TYPE = ''R'') AS CONSULT_TYPE2,'
		SET @SUBSQL += '(SELECT COUNT(CONSULT_TYPE) FROM sirens.cti.CTI_CONSULT_TYPE WITH(NOLOCK) WHERE CONSULT_SEQ = CTI.CONSULT_SEQ AND CONSULT_TYPE = ''P'') AS CONSULT_TYPE3,'

		SET @WHERE += 'AND CTI.CONSULT_SEQ IN (SELECT CONSULT_SEQ FROM sirens.cti.CTI_CONSULT_TYPE WHERE CONSULT_SEQ = CTI.CONSULT_SEQ AND CONSULT_TYPE = ''R'')'
	END
	ELSE IF ISNULL(@CONSULT_TYPE,'') = 'P'
	BEGIN
		SET @SUBSQL = '(SELECT COUNT(CONSULT_TYPE) FROM sirens.cti.CTI_CONSULT_TYPE WITH(NOLOCK) WHERE CONSULT_SEQ = CTI.CONSULT_SEQ AND CONSULT_TYPE = ''C'') AS CONSULT_TYPE1,'
		SET @SUBSQL += '(SELECT COUNT(CONSULT_TYPE) FROM sirens.cti.CTI_CONSULT_TYPE WITH(NOLOCK) WHERE CONSULT_SEQ = CTI.CONSULT_SEQ AND CONSULT_TYPE = ''R'') AS CONSULT_TYPE2,'
		SET @SUBSQL += '(SELECT COUNT(CONSULT_TYPE) FROM sirens.cti.CTI_CONSULT_TYPE WITH(NOLOCK) WHERE CONSULT_SEQ = CTI.CONSULT_SEQ AND CONSULT_TYPE = ''P'') AS CONSULT_TYPE3,'

		SET @WHERE += 'AND CTI.CONSULT_SEQ IN (SELECT CONSULT_SEQ FROM sirens.cti.CTI_CONSULT_TYPE WHERE CONSULT_SEQ = CTI.CONSULT_SEQ AND CONSULT_TYPE = ''P'')'
	END
	ELSE IF ISNULL(@CONSULT_TYPE,'') = 'D'
	BEGIN
		SET @SUBSQL = '0 AS CONSULT_TYPE1, 0 AS CONSULT_TYPE2, 0 AS CONSULT_TYPE3,'

		SET @WHERE += 'AND CTI.CONSULT_SEQ NOT IN (SELECT CONSULT_SEQ FROM sirens.cti.CTI_CONSULT_TYPE WHERE CONSULT_SEQ = CTI.CONSULT_SEQ AND CONSULT_TYPE IN(''C'',''R'',''P''))'
	END
	ELSE
	BEGIN
		SET @SUBSQL = '(SELECT COUNT(CONSULT_TYPE) FROM sirens.cti.CTI_CONSULT_TYPE WITH(NOLOCK) WHERE CONSULT_SEQ = CTI.CONSULT_SEQ AND CONSULT_TYPE = ''C'') AS CONSULT_TYPE1,'
		SET @SUBSQL += '(SELECT COUNT(CONSULT_TYPE) FROM sirens.cti.CTI_CONSULT_TYPE WITH(NOLOCK) WHERE CONSULT_SEQ = CTI.CONSULT_SEQ AND CONSULT_TYPE = ''R'') AS CONSULT_TYPE2,'
		SET @SUBSQL += '(SELECT COUNT(CONSULT_TYPE) FROM sirens.cti.CTI_CONSULT_TYPE WITH(NOLOCK) WHERE CONSULT_SEQ = CTI.CONSULT_SEQ AND CONSULT_TYPE = ''P'') AS CONSULT_TYPE3,'
	END

	IF ISNULL(@CONSULT_RESULT,'') <> ''
	BEGIN
		SET @WHERE += ' AND CTI.CONSULT_RESULT = ''' + @CONSULT_RESULT + ''''
	END

	IF ISNULL(@CUS_NAME,'') <> ''
	BEGIN
		SET @WHERE += ' AND CTI.CUS_NAME LIKE ''%' + @CUS_NAME + '%'''
	END

	IF ISNULL(@CALL_TYPE,'') <> ''
	BEGIN
		SET @WHERE += ' AND CTI.CONSULT_CALL_TYPE = ''' + @CALL_TYPE + ''''
	END

	IF ISNULL(@CUS_TEL, '') <> ''
		BEGIN
			IF LEN(@CUS_TEL) = 4
			BEGIN
				SET @WHERE  += ' AND RIGHT(CTI.CUS_TEL,4) =''' +  @CUS_TEL  + ''''
			END
			ELSE IF LEN(@CUS_TEL) > 4
			BEGIN
				SET @WHERE  += ' AND CTI.CUS_TEL =''' +  @CUS_TEL  + ''''
			END
		END


	SET @BSQL = '
		SELECT
			ROW_NUMBER() OVER(ORDER BY ' + @COLS_NAME + ' ' + @SORT + ' ) AS RNO,
			CTI.CONSULT_SEQ,
			(SELECT KOR_NAME FROM Diablo.dbo.EMP_MASTER WHERE EMP_CODE = CTI.EMP_CODE) AS EMP_NAME,
			CTI.CONSULT_DATE,
			CTI.DURATION_TIME,
			CASE WHEN CTI.CONSULT_CALL_TYPE = ''S'' THEN ''발신'' ELSE ''수신'' END CONSULT_CALL_TYPE,
			(SELECT MAIN_NAME FROM CTI_CODE_MASTER WHERE CATEGORY=''CTI101'' AND MAIN_CODE = CTI.CONSULT_RESULT AND USE_YN=''Y'') AS CONSULT_RESULT,
			CASE WHEN CTI.POINT_YN = ''Y'' THEN ''중요'' ELSE ''일반'' END AS POINT_YN, '
			+ @SUBSQL +
			-- CASE CTI.CONSULT_TYPE WHEN ''C'' THEN ''일반'' WHEN ''R'' THEN ''예약'' WHEN ''P'' THEN ''상품'' ELSE ''일반'' END CONSULT_TYPE,
			'CTI.CUS_NO,
			CTI.CUS_NAME,
			CTI.CUS_TEL,
			CTI.CONSULT_CONTENT,
			RTRIM(CTI.CONSULT_FILE_NAME) AS CONSULT_FILE_NAME,
			'''' AS CONSULT_EVAL,
			' + @COLS_NAME + ' AS SORT_KEY
		FROM sirens.cti.CTI_CONSULT CTI
		WHERE	CTI.CONSULT_DATE BETWEEN CONVERT(DATETIME,''' + @SDATE + '''+'' 00:00:00.000'') AND CONVERT(DATETIME,''' + @EDATE + '''+'' 23:59:59.997'')'
		+ @WHERE   
		-- 'AND CTI.SAVE_TYPE <> ''0'' '
	
	--EXECUTE(@SQL)

	SET @SQL=''
	SET @SQL = '	
		SELECT 
			CONSULT_SEQ,
			EMP_NAME,
			CONSULT_DATE,
			DURATION_TIME,
			CONSULT_CALL_TYPE,
			CONSULT_RESULT,
			POINT_YN,
			CONSULT_TYPE1,
			CONSULT_TYPE2,
			CONSULT_TYPE3,
			CUS_NO,
			CUS_NAME,
			CUS_TEL,
			CONSULT_FILE_NAME,
			CONSULT_CONTENT,
			CONSULT_EVAL
		FROM (' + @BSQL + ')T1
		WHERE RNO>=' + CONVERT(VARCHAR(100),(( @PAGE_INDEX-1 )*@PAGE_SIZE)+1) + '	and RNO<=' + CONVERT(VARCHAR(100),@PAGE_INDEX*@PAGE_SIZE)

	EXECUTE(@SQL)

	SET @SQL = 'SELECT @TOTAL_COUNT = COUNT(*) FROM (' + @BSQL + ')T1'

	SET @PARM = N'@SDATE VARCHAR(10), @EDATE VARCHAR(10), @TEAM_CODE VARCHAR(3), @EMP_CODE VARCHAR(7), @CONSULT_TYPE VARCHAR(1), @CONSULT_RESULT VARCHAR(1), @CUS_NAME VARCHAR(20),@CUS_TEL VARCHAR(15), @TOTAL_COUNT INT OUTPUT'
	EXEC SP_EXECUTESQL @SQL, @PARM, @SDATE, @EDATE, @TEAM_CODE, @EMP_CODE, @CONSULT_TYPE, @CONSULT_RESULT, @CUS_NAME, @CUS_TEL, @TOTAL_COUNT OUTPUT

SET NOCOUNT OFF
GO
