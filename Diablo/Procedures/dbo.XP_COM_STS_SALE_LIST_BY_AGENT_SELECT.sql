USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_COM_STS_SALE_LIST_BY_AGENT_SELECT
■ DESCRIPTION				: BTMS DSR 거래처별 매출현황 리스트 검색
XP_COM_STS_DSR_SALE_LIST_BY_AGENT_SELECT 는 발권/예약건수, 입금금액기준
XP_COM_STS_SALE_LIST_BY_AGENT_SELECT 는 출발자, 판매금액 기준
■ INPUT PARAMETER			: 
	@START_DATE		DATE	: 출발 시작일
	@END_DATE		DATE	: 출발 종료일
■ OUTPUT PARAMETER			: 
■ EXEC						: 
   DBO.XP_COM_STS_SALE_LIST_BY_AGENT_SELECT  '2016-06-20', '2016-09-30', '92756', '24', '126'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ Change History                   
------------------------------------------------------------------------------------------------------------------
   Date				Author			Description           
------------------------------------------------------------------------------------------------------------------   
	2016-12-06		이유라			최초생성
================================================================================================================*/ 
create PROC [dbo].[XP_COM_STS_SALE_LIST_BY_AGENT_SELECT]
(
	@START_DATE VARCHAR(10),		
	@END_DATE  VARCHAR(10),
	@AGT_CODE		VARCHAR(10),
	@TEAM_SEQ		INT,
	@EMP_SEQ		INT
)
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	DECLARE @SQLSTRING NVARCHAR(MAX), @PARMDEFINITION NVARCHAR(1000);
	DECLARE @WHERE NVARCHAR(MAX) = '', @GROUPBY1 NVARCHAR(20) = '', @GROUPBY2 NVARCHAR(20) = '';

	-- 검색 조건 만들기
	IF LEN(@AGT_CODE) > 0
	BEGIN
		SET @WHERE = @WHERE + ' AND B.AGT_CODE = @AGT_CODE'
		SET @GROUPBY1 = ' F.TEAM_NAME, ';
		SET @GROUPBY2 = ' ,C.TEAM_NAME ';
	END
	IF @EMP_SEQ > 0
	BEGIN
		SET @WHERE = @WHERE + ' AND C.NEW_SEQ = @EMP_SEQ'
	END
	ELSE IF @TEAM_SEQ > 0
	BEGIN
		SET @WHERE = @WHERE + ' AND D.TEAM_SEQ = @TEAM_SEQ'
	END

	IF @START_DATE IS NOT NULL AND @END_DATE IS NOT NULL
	BEGIN 
		SET @WHERE = @WHERE + ' AND  CONVERT(DATETIME, A.ARR_DATE, 121) >= CONVERT(DATETIME,@START_DATE , 121) AND CONVERT(DATETIME,  A.ARR_DATE, 121) < DATEADD(DAY, 1, CONVERT(DATETIME, @END_DATE, 121)) ';
	END

	SET @SQLSTRING = N'
	DECLARE  @AIR_PRICE DECIMAL,@HTL_PRICE DECIMAL, @CAR_PRICE DECIMAL, @VISA_PRICE DECIMAL, @ETC_PRICE DECIMAL, @TOTAL_COUNT INT, @TOTAL_PRICE DECIMAL;

	--월별
	WITH LIST AS ( 
		SELECT 
			CONVERT(VARCHAR(7),A.ARR_DATE,121) AS MONTH_DATE, 
			(SELECT COUNT(1) FROM RES_CUSTOMER_damo Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 2) AS AIR_COUNT,
			(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 2))) AS AIR_SALE_PRICE, 
			(SELECT COUNT(1) FROM RES_CUSTOMER_damo Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 3) AS HTL_COUNT,
			(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 3))) AS HTL_SALE_PRICE, 
			(SELECT COUNT(1) FROM RES_CUSTOMER_damo Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 4) AS CAR_COUNT,
			(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 4))) AS CAR_SALE_PRICE, 
			(SELECT COUNT(1) FROM RES_CUSTOMER_damo Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 5) AS VISA_COUNT,
			(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 5))) AS VISA_SALE_PRICE, 
			(SELECT COUNT(1) FROM RES_CUSTOMER_damo Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 9) AS ETC_COUNT,
			(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 9))) AS ETC_SALE_PRICE,
			(SELECT COUNT(1) FROM RES_CUSTOMER_damo Z WHERE A.RES_CODE = Z.RES_CODE) AS TOTAL_COUNT,
			(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE))) AS TOTAL_SALE_PRICE
		FROM RES_MASTER_damo A WITH(NOLOCK)
		JOIN COM_BIZTRIP_DETAIL B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE 
		JOIN COM_BIZTRIP_MASTER C WITH(NOLOCK) ON B.AGT_CODE = C.AGT_CODE AND B.BT_CODE = C.BT_CODE
		LEFT JOIN COM_EMPLOYEE D WITH(NOLOCK) ON C.AGT_CODE = D.AGT_CODE AND C.NEW_SEQ = D.EMP_SEQ
		WHERE 1 = 1 ' + @WHERE + N' AND A.RES_STATE IN (4, 5) 
		GROUP BY CONVERT(VARCHAR(7),A.ARR_DATE,121), A.RES_CODE, B.PRO_DETAIL_TYPE
	)
	SELECT 
		@AIR_PRICE = (CASE WHEN ISNULL(SUM(A.AIR_SALE_PRICE),0) = 0 THEN 1 ELSE ISNULL(SUM(A.AIR_SALE_PRICE),0) END),
		@HTL_PRICE = (CASE WHEN ISNULL(SUM(A.HTL_SALE_PRICE),0) = 0 THEN 1 ELSE ISNULL(SUM(A.HTL_SALE_PRICE),0) END),
		@CAR_PRICE = (CASE WHEN ISNULL(SUM(A.CAR_SALE_PRICE),0) = 0 THEN 1 ELSE ISNULL(SUM(A.CAR_SALE_PRICE),0) END),
		@VISA_PRICE = (CASE WHEN ISNULL(SUM(A.VISA_SALE_PRICE),0) = 0 THEN 1 ELSE ISNULL(SUM(A.VISA_SALE_PRICE),0) END),
		@ETC_PRICE = (CASE WHEN ISNULL(SUM(A.ETC_SALE_PRICE),0) = 0 THEN 1 ELSE ISNULL(SUM(A.ETC_SALE_PRICE),0) END),
		@TOTAL_PRICE = (CASE WHEN ISNULL(SUM(A.TOTAL_SALE_PRICE),0) = 0 THEN 1 ELSE ISNULL(SUM(A.TOTAL_SALE_PRICE),0) END),
		@TOTAL_COUNT = 
				(CASE WHEN ISNULL(SUM(A.AIR_COUNT + A.HTL_COUNT + A.CAR_COUNT + A.VISA_COUNT + A.ETC_COUNT),0) = 0 THEN 1 
				ELSE ISNULL(SUM(A.AIR_COUNT + A.HTL_COUNT + A.CAR_COUNT + A.VISA_COUNT + A.ETC_COUNT),0) END)
	FROM LIST A;

	WITH LIST AS ( 
		SELECT 
			CONVERT(VARCHAR(7),A.ARR_DATE,121) AS MONTH_DATE, 
			--A.PRO_TYPE, B.PRO_DETAIL_TYPE, A.RES_CODE,
			(SELECT COUNT(1) FROM RES_CUSTOMER_damo Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 2) AS AIR_COUNT,
			CONVERT(FLOAT,(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 2))) / CONVERT(FLOAT,@AIR_PRICE) * 100) AS AIR_SHARE,
			(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 2))) AS AIR_SALE_PRICE, 
			(SELECT COUNT(1) FROM RES_CUSTOMER_damo Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 3) AS HTL_COUNT,
			CONVERT(FLOAT,(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 3))) / CONVERT(FLOAT,@HTL_PRICE) * 100) AS HTL_SHARE,
			(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 3))) AS HTL_SALE_PRICE, 
			(SELECT COUNT(1) FROM RES_CUSTOMER_damo Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 4) AS CAR_COUNT,
			CONVERT(FLOAT,(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 4))) / CONVERT(FLOAT,@CAR_PRICE) * 100) AS CAR_SHARE,
			(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 4))) AS CAR_SALE_PRICE, 
			(SELECT COUNT(1) FROM RES_CUSTOMER_damo Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 5) AS VISA_COUNT,
			CONVERT(FLOAT,(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 5))) / CONVERT(FLOAT,@VISA_PRICE) * 100) AS VISA_SHARE,
			(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 5))) AS VISA_SALE_PRICE, 
			(SELECT COUNT(1) FROM RES_CUSTOMER_damo Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 9) AS ETC_COUNT,
			CONVERT(FLOAT,(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 9))) / CONVERT(FLOAT,@ETC_PRICE) * 100) AS ETC_SHARE,
			(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 9))) AS ETC_SALE_PRICE,
			(SELECT COUNT(1) FROM RES_CUSTOMER_damo Z WHERE A.RES_CODE = Z.RES_CODE) AS TOTAL_COUNT,
			CONVERT(FLOAT,(SELECT COUNT(1) FROM RES_CUSTOMER_damo Z WHERE A.RES_CODE = Z.RES_CODE) / CONVERT(FLOAT,@TOTAL_COUNT) * 100) AS TOTAL_SHARE,
			(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE))) AS TOTAL_SALE_PRICE,
			CONVERT(FLOAT,(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE))) / CONVERT(FLOAT,@TOTAL_PRICE) * 100) AS TOTAL_PRICE_SHARE
		FROM RES_MASTER_damo A WITH(NOLOCK)
		JOIN COM_BIZTRIP_DETAIL B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE 
		JOIN COM_BIZTRIP_MASTER C WITH(NOLOCK) ON B.AGT_CODE = C.AGT_CODE AND B.BT_CODE = C.BT_CODE
		LEFT JOIN COM_EMPLOYEE D WITH(NOLOCK) ON C.AGT_CODE = D.AGT_CODE AND C.NEW_SEQ = D.EMP_SEQ
		LEFT JOIN AGT_MASTER E WITH(NOLOCK) ON C.AGT_CODE = E.AGT_CODE
		LEFT JOIN COM_TEAM F WITH(NOLOCK) ON F.AGT_CODE = E.AGT_CODE AND F.TEAM_SEQ = D.TEAM_SEQ
		WHERE 1 = 1 ' + @WHERE + N' AND RES_STATE IN (4, 5) 
		GROUP BY CONVERT(VARCHAR(7),A.ARR_DATE,121), A.RES_CODE , B.PRO_DETAIL_TYPE
	)
	SELECT 
		B.MONTH_DATE, 
		ISNULL(SUM(B.AIR_COUNT),0) AS AIR_COUNT,
		ISNULL(SUM(B.AIR_SHARE),0) AS AIR_SHARE,
		ISNULL(SUM(B.AIR_SALE_PRICE),0) AS AIR_SALE_PRICE,
		ISNULL(SUM(B.HTL_COUNT),0) AS HTL_COUNT,
		ISNULL(SUM(B.HTL_SHARE),0) AS HTL_SHARE,
		ISNULL(SUM(B.HTL_SALE_PRICE),0) AS HTL_SALE_PRICE,
		ISNULL(SUM(B.CAR_COUNT),0) AS CAR_COUNT,
		ISNULL(SUM(B.CAR_SHARE),0) AS CAR_SHARE,
		ISNULL(SUM(B.CAR_SALE_PRICE),0) AS CAR_SALE_PRICE,
		ISNULL(SUM(B.VISA_COUNT),0) AS VISA_COUNT,
		ISNULL(SUM(B.VISA_SHARE),0) AS VISA_SHARE,
		ISNULL(SUM(B.VISA_SALE_PRICE),0) AS VISA_SALE_PRICE,
		ISNULL(SUM(B.ETC_COUNT),0) AS ETC_COUNT,
		ISNULL(SUM(B.ETC_SHARE),0) AS ETC_SHARE,
		ISNULL(SUM(B.ETC_SALE_PRICE),0) AS ETC_SALE_PRICE,
		ISNULL(SUM(B.TOTAL_COUNT),0) AS TOTAL_COUNT,
		ISNULL(SUM(B.TOTAL_SHARE),0) AS TOTAL_SHARE,
		ISNULL(SUM(B.TOTAL_SALE_PRICE),0) AS TOTAL_SALE_PRICE,
		ISNULL(SUM(B.TOTAL_PRICE_SHARE),0) AS TOTAL_PRICE_SHARE
	FROM LIST B
	GROUP BY MONTH_DATE
	ORDER BY MONTH_DATE DESC;

	--팀별	
	WITH LIST AS ( 
		SELECT 
			E.KOR_NAME,  ' + @GROUPBY1 + N'
			(SELECT COUNT(1) FROM RES_CUSTOMER_damo Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 2) AS AIR_COUNT,
			(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 2))) AS AIR_SALE_PRICE, 
			(SELECT COUNT(1) FROM RES_CUSTOMER_damo Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 3) AS HTL_COUNT,
			(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 3))) AS HTL_SALE_PRICE, 
			(SELECT COUNT(1) FROM RES_CUSTOMER_damo Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 4) AS CAR_COUNT,
			(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 4))) AS CAR_SALE_PRICE, 
			(SELECT COUNT(1) FROM RES_CUSTOMER_damo Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 5) AS VISA_COUNT,
			(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 5))) AS VISA_SALE_PRICE, 
			(SELECT COUNT(1) FROM RES_CUSTOMER_damo Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 9) AS ETC_COUNT,
			(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 9))) AS ETC_SALE_PRICE,
			(SELECT COUNT(1) FROM RES_CUSTOMER_damo Z WHERE A.RES_CODE = Z.RES_CODE) AS TOTAL_COUNT,
			(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE))) AS TOTAL_SALE_PRICE
		FROM RES_MASTER_damo A WITH(NOLOCK)
		JOIN COM_BIZTRIP_DETAIL B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE 
		JOIN COM_BIZTRIP_MASTER C WITH(NOLOCK) ON B.AGT_CODE = C.AGT_CODE AND B.BT_CODE = C.BT_CODE
		LEFT JOIN COM_EMPLOYEE D WITH(NOLOCK) ON C.AGT_CODE = D.AGT_CODE AND C.NEW_SEQ = D.EMP_SEQ
		LEFT JOIN AGT_MASTER E WITH(NOLOCK) ON C.AGT_CODE = E.AGT_CODE
		LEFT JOIN COM_TEAM F WITH(NOLOCK) ON F.AGT_CODE = E.AGT_CODE AND F.TEAM_SEQ = D.TEAM_SEQ
		WHERE 1 = 1 ' + @WHERE + N' AND A.RES_STATE IN (4, 5) 
		GROUP BY E.KOR_NAME, ' + @GROUPBY1 + N' A.RES_CODE , B.PRO_DETAIL_TYPE 
	)
	SELECT 
		@AIR_PRICE = (CASE WHEN ISNULL(SUM(A.AIR_SALE_PRICE),0) = 0 THEN 1 ELSE ISNULL(SUM(A.AIR_SALE_PRICE),0) END),
		@HTL_PRICE = (CASE WHEN ISNULL(SUM(A.HTL_SALE_PRICE),0) = 0 THEN 1 ELSE ISNULL(SUM(A.HTL_SALE_PRICE),0) END),
		@CAR_PRICE = (CASE WHEN ISNULL(SUM(A.CAR_SALE_PRICE),0) = 0 THEN 1 ELSE ISNULL(SUM(A.CAR_SALE_PRICE),0) END),
		@VISA_PRICE = (CASE WHEN ISNULL(SUM(A.VISA_SALE_PRICE),0) = 0 THEN 1 ELSE ISNULL(SUM(A.VISA_SALE_PRICE),0) END),
		@ETC_PRICE = (CASE WHEN ISNULL(SUM(A.ETC_SALE_PRICE),0) = 0 THEN 1 ELSE ISNULL(SUM(A.ETC_SALE_PRICE),0) END),
		@TOTAL_PRICE = (CASE WHEN ISNULL(SUM(A.TOTAL_SALE_PRICE),0) = 0 THEN 1 ELSE ISNULL(SUM(A.TOTAL_SALE_PRICE),0) END),
		@TOTAL_COUNT = (CASE WHEN ISNULL(SUM(A.AIR_COUNT + A.HTL_COUNT + A.CAR_COUNT + A.VISA_COUNT + A.ETC_COUNT),0) = 0 THEN 1 
				ELSE ISNULL(SUM(A.AIR_COUNT + A.HTL_COUNT + A.CAR_COUNT + A.VISA_COUNT + A.ETC_COUNT),0) END)
	FROM LIST A;

	WITH LIST AS ( 
		SELECT 
			E.KOR_NAME, ' + @GROUPBY1 + N'
			--A.PRO_TYPE, B.PRO_DETAIL_TYPE, A.RES_CODE,
			(SELECT COUNT(1) FROM RES_CUSTOMER_damo Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 2) AS AIR_COUNT,
			CONVERT(FLOAT,(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 2))) / CONVERT(FLOAT,@AIR_PRICE) * 100) AS AIR_SHARE,
			(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 2))) AS AIR_SALE_PRICE, 
			(SELECT COUNT(1) FROM RES_CUSTOMER_damo Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 3) AS HTL_COUNT,
			CONVERT(FLOAT,(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 3))) / CONVERT(FLOAT,@HTL_PRICE) * 100) AS HTL_SHARE,
			(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 3))) AS HTL_SALE_PRICE, 
			(SELECT COUNT(1) FROM RES_CUSTOMER_damo Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 4) AS CAR_COUNT,
			CONVERT(FLOAT,(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 4))) / CONVERT(FLOAT,@CAR_PRICE) * 100) AS CAR_SHARE,
			(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 4))) AS CAR_SALE_PRICE, 
			(SELECT COUNT(1) FROM RES_CUSTOMER_damo Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 5) AS VISA_COUNT,
			CONVERT(FLOAT,(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 5))) / CONVERT(FLOAT,@VISA_PRICE) * 100) AS VISA_SHARE,
			(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 5))) AS VISA_SALE_PRICE, 
			(SELECT COUNT(1) FROM RES_CUSTOMER_damo Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 9) AS ETC_COUNT,
			CONVERT(FLOAT,(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 9))) / CONVERT(FLOAT,@ETC_PRICE) * 100) AS ETC_SHARE,
			(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE AND B.PRO_DETAIL_TYPE = 9))) AS ETC_SALE_PRICE,
			(SELECT COUNT(1) FROM RES_CUSTOMER_damo Z WHERE A.RES_CODE = Z.RES_CODE) AS TOTAL_COUNT,
			CONVERT(FLOAT,(SELECT COUNT(1) FROM RES_CUSTOMER_damo Z WHERE A.RES_CODE = Z.RES_CODE) / CONVERT(FLOAT,@TOTAL_COUNT) * 100) AS TOTAL_SHARE,
			(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE))) AS TOTAL_SALE_PRICE,
			CONVERT(FLOAT,(SELECT dbo.FN_RES_GET_TOTAL_PRICE((SELECT Z.RES_CODE FROM COM_BIZTRIP_DETAIL Z WHERE A.RES_CODE = Z.RES_CODE))) / CONVERT(FLOAT,@TOTAL_PRICE) * 100) AS TOTAL_PRICE_SHARE
		FROM RES_MASTER_damo A WITH(NOLOCK)
		JOIN COM_BIZTRIP_DETAIL B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE 
		JOIN COM_BIZTRIP_MASTER C WITH(NOLOCK) ON B.AGT_CODE = C.AGT_CODE AND B.BT_CODE = C.BT_CODE
		LEFT JOIN COM_EMPLOYEE D WITH(NOLOCK) ON C.AGT_CODE = D.AGT_CODE AND C.NEW_SEQ = D.EMP_SEQ
		LEFT JOIN AGT_MASTER E WITH(NOLOCK) ON C.AGT_CODE = E.AGT_CODE
		LEFT JOIN COM_TEAM F WITH(NOLOCK) ON F.AGT_CODE = E.AGT_CODE AND F.TEAM_SEQ = D.TEAM_SEQ
		WHERE 1 = 1 ' + @WHERE + N' AND RES_STATE IN (4, 5) 
		GROUP BY E.KOR_NAME, ' + @GROUPBY1 + N' A.RES_CODE , B.PRO_DETAIL_TYPE
	)
	SELECT 
		C.KOR_NAME' + @GROUPBY2 + N' ,
		ISNULL(SUM(C.AIR_COUNT),0) AS AIR_COUNT,
		ISNULL(SUM(C.AIR_SHARE),0) AS AIR_SHARE,
		ISNULL(SUM(C.AIR_SALE_PRICE),0) AS AIR_SALE_PRICE,
		ISNULL(SUM(C.HTL_COUNT),0) AS HTL_COUNT,
		ISNULL(SUM(C.HTL_SHARE),0) AS HTL_SHARE,
		ISNULL(SUM(C.HTL_SALE_PRICE),0) AS HTL_SALE_PRICE,
		ISNULL(SUM(C.CAR_COUNT),0) AS CAR_COUNT,
		ISNULL(SUM(C.CAR_SHARE),0) AS CAR_SHARE,
		ISNULL(SUM(C.CAR_SALE_PRICE),0) AS CAR_SALE_PRICE,
		ISNULL(SUM(C.VISA_COUNT),0) AS VISA_COUNT,
		ISNULL(SUM(C.VISA_SHARE),0) AS VISA_SHARE,
		ISNULL(SUM(C.VISA_SALE_PRICE),0) AS VISA_SALE_PRICE,
		ISNULL(SUM(C.ETC_COUNT),0) AS ETC_COUNT,
		ISNULL(SUM(C.ETC_SHARE),0) AS ETC_SHARE,
		ISNULL(SUM(C.ETC_SALE_PRICE),0) AS ETC_SALE_PRICE,
		ISNULL(SUM(C.TOTAL_COUNT),0) AS TOTAL_COUNT,
		ISNULL(SUM(C.TOTAL_SHARE),0) AS TOTAL_SHARE,
		ISNULL(SUM(C.TOTAL_SALE_PRICE),0) AS TOTAL_SALE_PRICE,
		ISNULL(SUM(C.TOTAL_PRICE_SHARE),0) AS TOTAL_PRICE_SHARE
	FROM LIST C
	GROUP BY C.KOR_NAME' + @GROUPBY2 + N'
	ORDER BY SUM(C.TOTAL_SALE_PRICE) DESC'

	SET @PARMDEFINITION = N'	
		@AGT_CODE			VARCHAR(10),
		@START_DATE			DATE,
		@END_DATE			DATE,
		@TEAM_SEQ			INT,
		@EMP_SEQ			INT';

	PRINT @SQLSTRING

	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, 		
		@AGT_CODE,
		@START_DATE,
		@END_DATE,
		@TEAM_SEQ,
		@EMP_SEQ;
END




GO
