USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_COM_STS_DSR_SALE_LIST_SELECT
■ DESCRIPTION				: BTMS DSR 판매현황 리스트 검색
■ INPUT PARAMETER			: 
	@SELECT_TYPE	INT		: 구분 (0: 항공, 1: 지역)
	@START_DATE		DATE	: 발권일 시작점
	@END_DATE		DATE	: 발권일 종료점
	@AGT_CODE	VARCHAR(10) : BTMS 거래처 코드
	@TEAM_SEQ	INT			: BTMS 거래처 부서코드
	@EMP_SEQ	INT			: BTMS 거래처 직원코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 
   DBO.XP_COM_STS_DSR_SALE_LIST_SELECT  0, '2016-11-08', '2016-11-08', '93971', '', '', '', 'I'
■ MEMO                     : 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
	DATE			AUTHOR		DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2016-06-09		이유라		최초생성
	2016-09-29		이유라		발권일 외 출발일 조회 추가 (@DATE_TYPE 추가로 구분)
	2016-10-12		이유라		티켓 조건 수정 (컨정션티켓, 보이드티켓도 나오도록 조건절 삭제)
	2016-10-19		이유라		발권수수료 항목추가
	2018-01-19		박형만		RES_AIR_DETAIL JOIN 제거 ( DSR등록된 RP 기타 예약 건수 나오도록 )
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_STS_DSR_SALE_LIST_SELECT]
	@SELECT_TYPE	INT,
	@START_DATE		DATE,
	@END_DATE		DATE,
	@AGT_CODE		VARCHAR(10),
	@TEAM_SEQ		INT,
	@EMP_SEQ		INT,
	@ROUTE_TYPE		VARCHAR(1),
	@DATE_TYPE		VARCHAR(1)
AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000);
	DECLARE @TYPENAME NVARCHAR(100), @GROUPBY NVARCHAR(100), @GROUPBY2 NVARCHAR(100), @WHERE NVARCHAR(MAX) = '';

	-- TYPE별 조건 만들기
	IF @SELECT_TYPE = 0
	BEGIN
		SELECT	@TYPENAME = '(SELECT KOR_NAME FROM PUB_AIRLINE WHERE AIRLINE_CODE = A.AIRLINE_CODE)',
				@GROUPBY  = 'AIRLINE_CODE',
				@GROUPBY2 = 'A.AIRLINE_CODE'
	END
	ELSE IF @SELECT_TYPE = 1
	BEGIN
		SELECT	@TYPENAME = '(SELECT KOR_NAME FROM PUB_REGION WHERE REGION_CODE = A.REGION_CODE)',
				@GROUPBY  = 'I.REGION_CODE',
				@GROUPBY2 = 'A.REGION_CODE'
	END

	-- 검색 조건 만들기
	IF LEN(@AGT_CODE) > 0
	BEGIN
		SET @WHERE = @WHERE + ' AND E.AGT_CODE = @AGT_CODE'
	END
	IF @EMP_SEQ > 0
	BEGIN
		SET @WHERE = @WHERE + ' AND F.NEW_SEQ = @EMP_SEQ'
	END
	ELSE IF @TEAM_SEQ > 0
	BEGIN
		SET @WHERE = @WHERE + ' AND G.TEAM_SEQ = @TEAM_SEQ'
	END

	IF @ROUTE_TYPE = 'I'
	BEGIN 
		SET @WHERE = @WHERE + ' AND A.CITY_CODE NOT IN (SELECT CITY_CODE FROM PUB_CITY WHERE NATION_CODE = ''KR'') '
	END
	ELSE IF @ROUTE_TYPE = 'D'
	BEGIN 
		SET @WHERE = @WHERE + ' AND A.CITY_CODE IN (SELECT CITY_CODE FROM PUB_CITY WHERE NATION_CODE = ''KR'') '
	END

	IF @START_DATE IS NOT NULL AND @END_DATE IS NOT NULL
	BEGIN 
		IF @DATE_TYPE = 'I'
		BEGIN
			SET @WHERE = @WHERE + ' AND A.ISSUE_DATE >= @START_DATE AND A.ISSUE_DATE < DATEADD(DAY, 1, CONVERT(DATETIME, @END_DATE, 121)) '	
		END
		IF @DATE_TYPE = 'S'
		BEGIN
			SET @WHERE = @WHERE + ' AND A.START_DATE >= @START_DATE AND A.START_DATE < DATEADD(DAY, 1, CONVERT(DATETIME, @END_DATE, 121)) '			
		END
	END

	IF LEN(@WHERE) > 10
	BEGIN
		SELECT @WHERE = (N'WHERE ' + SUBSTRING(@WHERE, 5, 1000))
	END

	SET @SQLSTRING = N'
		DECLARE @TOTAL_TICKET INT, @TOTAL_PRICE DECIMAL;

		WITH LIST AS (
			SELECT 
				--(SELECT COUNT(*) FROM RES_AIR_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE ) AS TICKET_COUNT,
				--(SELECT ISNULL(A.NET_PRICE,0) + ISNULL(A.TAX_PRICE,0) FROM RES_AIR_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE ) AS TICKET_PRICE,
				1 AS TICKET_COUNT ,
				ISNULL(A.NET_PRICE,0) + ISNULL(A.TAX_PRICE,0) AS TICKET_PRICE ,
				ROW_NUMBER() OVER (PARTITION BY A.RES_CODE, A.RES_SEQ_NO ORDER BY A.START_DATE) AS [ROWNUMBER],
				ISNULL(B.CHG_PRICE,0) AS CHG_PRICE
			FROM DSR_TICKET A WITH(NOLOCK)
			INNER JOIN RES_CUSTOMER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE AND A.RES_SEQ_NO = B.SEQ_NO
			INNER JOIN RES_MASTER_damo C WITH(NOLOCK) ON B.RES_CODE = C.RES_CODE AND C.PROVIDER = ''33''
			LEFT JOIN DSR_REFUND D WITH(NOLOCK) ON A.TICKET = D.TICKET
			INNER JOIN COM_BIZTRIP_DETAIL E WITH(NOLOCK) ON C.RES_CODE = E.RES_CODE
			INNER JOIN COM_BIZTRIP_MASTER F WITH(NOLOCK) ON E.AGT_CODE = F.AGT_CODE AND E.BT_CODE = F.BT_CODE
			LEFT JOIN COM_EMPLOYEE G WITH(NOLOCK) ON F.AGT_CODE = G.AGT_CODE AND F.NEW_SEQ = G.EMP_SEQ
			LEFT JOIN PUB_CITY H WITH(NOLOCK) ON A.CITY_CODE = H.CITY_CODE 
			LEFT JOIN PUB_NATION I WITH(NOLOCK) ON H.NATION_CODE = I.NATION_CODE
			' + @WHERE + N'
		)
		SELECT 
			@TOTAL_TICKET = (CASE WHEN ISNULL(SUM(A.TICKET_COUNT),0) = 0 THEN 1 ELSE ISNULL(SUM(A.TICKET_COUNT),0) END),  
			@TOTAL_PRICE = (CASE WHEN ISNULL(SUM(A.TICKET_PRICE),0) + SUM(CASE WHEN A.ROWNUMBER = 1 THEN A.CHG_PRICE ELSE 0 END) = 0 THEN 1 ELSE ISNULL(SUM(A.TICKET_PRICE),0)  + SUM(CASE WHEN A.ROWNUMBER = 1 THEN A.CHG_PRICE ELSE 0 END) END)
		FROM LIST A ;

		WITH LIST AS (
			SELECT
				' + @GROUPBY + N',
				A.TICKET,
				ISNULL(A.NET_PRICE, 0) + ISNULL(A.TAX_PRICE, 0) AS PRICE,
				ISNULL(A.FARE, 0) AS FARE,
				ISNULL(A.NET_PRICE, 0) AS NET_PRICE,
				ISNULL(A.TAX_PRICE, 0) AS TAX_PRICE,
				ISNULL(D.CANCEL_CHARGE, 0) AS CANCEL_CHARGE,
				ISNULL(B.CHG_PRICE, 0) AS CHG_PRICE,
				ROW_NUMBER() OVER (PARTITION BY A.RES_CODE, A.RES_SEQ_NO ORDER BY A.START_DATE) AS [ROWNUMBER]
			FROM DSR_TICKET A WITH(NOLOCK)
			INNER JOIN RES_CUSTOMER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE AND A.RES_SEQ_NO = B.SEQ_NO
			INNER JOIN RES_MASTER_damo C WITH(NOLOCK) ON B.RES_CODE = C.RES_CODE AND C.PROVIDER = ''33''
			LEFT JOIN DSR_REFUND D WITH(NOLOCK) ON A.TICKET = D.TICKET
			INNER JOIN COM_BIZTRIP_DETAIL E WITH(NOLOCK) ON C.RES_CODE = E.RES_CODE
			INNER JOIN COM_BIZTRIP_MASTER F WITH(NOLOCK) ON E.AGT_CODE = F.AGT_CODE AND E.BT_CODE = F.BT_CODE
			LEFT JOIN COM_EMPLOYEE G WITH(NOLOCK) ON F.AGT_CODE = G.AGT_CODE AND F.NEW_SEQ = G.EMP_SEQ
			LEFT JOIN PUB_CITY H WITH(NOLOCK) ON A.CITY_CODE = H.CITY_CODE 
			LEFT JOIN PUB_NATION I WITH(NOLOCK) ON H.NATION_CODE = I.NATION_CODE
			' + @WHERE + N'
			
		)
			SELECT
				' + @TYPENAME + N' AS [TYPE_NAME],
				' + @GROUPBY2 + N',
				SUM(A.PRICE) + SUM(CASE WHEN A.ROWNUMBER = 1 THEN A.CHG_PRICE ELSE 0 END) AS [PRICE],
				CONVERT(FLOAT,SUM(A.PRICE) + SUM(CASE WHEN A.ROWNUMBER = 1 THEN A.CHG_PRICE ELSE 0 END)) / CONVERT(FLOAT,@TOTAL_PRICE) * 100 AS [PRICE_SHARE],
				COUNT(A.TICKET) AS [TICKET_COUNT],
				CONVERT(FLOAT,COUNT(A.TICKET) / CONVERT(FLOAT,@TOTAL_TICKET) * 100) AS [TICKET_SHARE],
				SUM(A.FARE) AS [FARE_PRICE],
				SUM(A.NET_PRICE) AS [NET_PRICE],
				SUM(A.TAX_PRICE) AS [TAX_PRICE],
				SUM(A.CANCEL_CHARGE) AS [CANCEL_CHARGE],
				SUM(CASE WHEN A.ROWNUMBER = 1 THEN A.CHG_PRICE ELSE 0 END) AS [CHG_PRICE]
			FROM LIST A 
			GROUP BY ' + @GROUPBY2 + N'
			ORDER BY 5 DESC, 1 DESC; '

	SET @PARMDEFINITION = N'	
		@AGT_CODE			VARCHAR(10),
		@START_DATE			DATE,
		@END_DATE			DATE,
		@TEAM_SEQ			INT,
		@EMP_SEQ			INT,
		@ROUTE_TYPE			VARCHAR(1)';

	PRINT @SQLSTRING

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, 		
		@AGT_CODE,
		@START_DATE,
		@END_DATE,
		@TEAM_SEQ,
		@EMP_SEQ,
		@ROUTE_TYPE;
END 

GO