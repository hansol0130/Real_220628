USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_RES_HTL_CUSTOMER_DETAIL_RESET_INSERT
■ DESCRIPTION				: 호텔예약 투숙객 배정 초기화
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-07-22		김성호			최초생성
   2016-04-05		박형만			소아매칭 안되던 현상 수정, 나이 포함된 신규 로직 적용 
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[XP_RES_HTL_CUSTOMER_DETAIL_RESET_INSERT]
	@RES_CODE	VARCHAR(20)
AS
BEGIN


--투숙자 
DECLARE @PAX_CUSTOMERS TABLE ( PAX_NO INT, SEQ_NO INT, AGE_TYPE INT , AGE INT )
INSERT INTO @PAX_CUSTOMERS 
SELECT 
	ROW_NUMBER() OVER (ORDER BY A.SEQ_NO) AS [PAX_NO], 
	A.SEQ_NO ,
	A.AGE_TYPE ,
	CASE WHEN B.AGE IS NOT NULL THEN B.AGE ELSE 
		CASE WHEN AGE_TYPE = 0 THEN 30 WHEN AGE_TYPE IN (1,2) THEN 7 END 
	END AS AGE 
FROM RES_CUSTOMER_damo A
	LEFT JOIN RES_HTL_CUSTOMER_DETAIL B 
		ON A.RES_CODE = B.RES_CODE 
		AND A.SEQ_NO = B.SEQ_NO 
WHERE A.RES_CODE = @RES_CODE
AND A.RES_STATE = 0 

--남은룸
DECLARE @ROOM_REMAIN TABLE ( ROOM_NO INT , ADT_PAX_CNT INT , USE_ADT_CNT INT ) 
INSERT INTO @ROOM_REMAIN 
SELECT A.ROOM_NO , 
(CASE A.ROOM_TYPE WHEN 1 THEN 1 WHEN 2 THEN 2 WHEN 3 THEN 2 WHEN 4 THEN 3 WHEN 4 THEN 4 ELSE 0 END) AS ADT_PAX_CNT , --2 CHD_PAX_CNT 
0 AS USE_ADT_CNT --, 0 AS  REMAIN_CHD_CNT   
FROM RES_HTL_ROOM_DETAIL A WITH(NOLOCK)
WHERE RES_CODE = @RES_CODE


--룸매칭 정보 
DECLARE @ROOM_MATCH TABLE ( ROOM_NO INT , SEQ_NO INT , AGE_TYPE INT , AGE INT ) 

--룸채우기 시작 
DECLARE @ROOM_NO INT 
DECLARE @PAX_NO INT 
SET @ROOM_NO = 1 
SET @PAX_NO = 1

--투숙자 루프
WHILE @PAX_NO <= (SELECT COUNT(*) FROM @PAX_CUSTOMERS )
BEGIN
	--변수 담기
	DECLARE @AGE_TYPE INT ,@SEQ_NO INT  , @AGE INT 
	SELECT @AGE_TYPE = AGE_TYPE , @SEQ_NO = SEQ_NO , @AGE = AGE FROM @PAX_CUSTOMERS WHERE PAX_NO = @PAX_NO 

	--성인일 경우에만 
	IF @AGE_TYPE = 0 
	BEGIN
		--룸한도에 도달했는지 체크 
		IF (SELECT CASE WHEN ADT_PAX_CNT = USE_ADT_CNT THEN 1 ELSE 0 END FROM @ROOM_REMAIN WHERE ROOM_NO = @ROOM_NO) = 1 
		BEGIN
			--다음룸으로 
			SET @ROOM_NO = @ROOM_NO + 1 
		END 
	END 

	--룸이 남아 있는지 체크 
	--룸이 없으면 
	IF NOT EXISTS (SELECT * FROM @ROOM_REMAIN WHERE ROOM_NO = @ROOM_NO)
	BEGIN
		--룸없는 매칭정보 등록  ROOM_NO = 0 
		INSERT INTO @ROOM_MATCH 
		SELECT 0 AS ROOM_NO  , @SEQ_NO AS SEQ_NO , @AGE_TYPE , @AGE 
	END 
	ELSE  -- 룸있음
	BEGIN
		--매칭정보 등록 
		INSERT INTO @ROOM_MATCH 
		SELECT @ROOM_NO AS ROOM_NO  , @SEQ_NO AS SEQ_NO , @AGE_TYPE , @AGE 
			
		--성인일때만 
		IF @AGE_TYPE = 0 
		BEGIN
			--룸사용+1 
			UPDATE @ROOM_REMAIN 
			SET USE_ADT_CNT =  USE_ADT_CNT +1 
			WHERE ROOM_NO = @ROOM_NO	
		END 
	END 
	--투숙자 +1 
	SET @PAX_NO = @PAX_NO + 1 
END 

--매칭정보 삭제 
DELETE RES_HTL_CUSTOMER_DETAIL WHERE RES_CODE = @RES_CODE;

--매칭정보 재등록 
INSERT INTO RES_HTL_CUSTOMER_DETAIL 
SELECT 
A.RES_CODE, B.ROOM_NO, 
ROW_NUMBER() OVER (PARTITION BY B.ROOM_NO ORDER BY A.SEQ_NO ) AS MATCH_NO, A.SEQ_NO
,B.AGE 
FROM RES_CUSTOMER_DAMO A
	INNER JOIN @ROOM_MATCH  B 
		ON A.SEQ_NO = B.SEQ_NO 
WHERE A.RES_CODE = @RES_CODE 
ORDER BY SEQ_NO 
--기존쿼리 
--BEGIN TRY

--	DELETE FROM RES_HTL_CUSTOMER_DETAIL WHERE RES_CODE = @RES_CODE;

--	WITH LIST AS
--	(
--		SELECT ROW_NUMBER() OVER (ORDER BY A.ROOM_NO, B.SEQ) AS [ROWNUMBER], A.RES_CODE, A.ROOM_NO, A.ROOM_TYPE, B.SEQ AS [MATCH_NO]
--		FROM RES_HTL_ROOM_DETAIL A WITH(NOLOCK)
--		LEFT JOIN PUB_TMP_SEQ B WITH(NOLOCK) ON B.SEQ <= ((CASE A.ROOM_TYPE WHEN 1 THEN 1 WHEN 2 THEN 2 WHEN 3 THEN 2 WHEN 4 THEN 3 WHEN 4 THEN 4 ELSE 0 END) * A.ROOM_COUNT)
--		WHERE RES_CODE = @RES_CODE
--	)
--	SELECT A.RES_CODE, A.ROOM_NO, A.MATCH_NO, B.SEQ_NO
--	INTO #TMP_HOTEL_CUSTOMER_DETAIL
--	FROM LIST A
--	LEFT JOIN (
--		SELECT ROW_NUMBER() OVER (ORDER BY A.SEQ_NO) AS [ROWNUMBER], A.SEQ_NO
--		FROM RES_CUSTOMER_damo A 
--		WHERE A.RES_CODE = @RES_CODE AND A.RES_STATE = 0
--	) B ON A.ROWNUMBER = B.ROWNUMBER

--	INSERT INTO RES_HTL_CUSTOMER_DETAIL (RES_CODE, ROOM_NO, MATCH_NO, SEQ_NO)
--	SELECT RES_CODE, ROOM_NO, MATCH_NO, SEQ_NO
--	FROM #TMP_HOTEL_CUSTOMER_DETAIL

--	DROP TABLE #TMP_HOTEL_CUSTOMER_DETAIL
--END TRY
--BEGIN CATCH

--	DROP TABLE #TMP_HOTEL_CUSTOMER_DETAIL
--END CATCH

END

GO