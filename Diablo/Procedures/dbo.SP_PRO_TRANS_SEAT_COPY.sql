USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*

2019-03-06 박형만	좌석복사시	좌석등급 필드 추가 
2019-03-29 박형만	좌석복사시	좌석상세 세그 추가 
2019-04-19 박형만	좌석 상세세그 날짜 버그 수정 

*/
CREATE PROCEDURE [dbo].[SP_PRO_TRANS_SEAT_COPY]
	@SEAT_CODE		INT,			-- 좌석코드
	@START			VARCHAR(10),	-- 복사시작일
	@END			VARCHAR(10),	-- 복사종료일
	@WEEK_DAY_TYPE	VARCHAR(7),		-- 요일
	@EMP_CODE		CHAR(7)			-- 생성인코드
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @START_DATE DATETIME, @END_DATE DATETIME, @DIFF_DAY INT, @DEP_DIFF INT, @ARR_DIFF INT
	
	SET @START_DATE = CONVERT(DATETIME, @START);
	SET @END_DATE = CONVERT(DATETIME, @END);

	CREATE TABLE #MSG_TEMP (
		[ERROR_SEQ] INT IDENTITY,	[ERROR_DATE] DATETIME,
		[ERROR_TYPE] INT,			[ERROR_MESSAGE] NVARCHAR(2048))

	-- 기준 좌석이 있을때만 
	IF EXISTS(SELECT 1 FROM PRO_TRANS_SEAT  WITH(NOLOCK) WHERE SEAT_CODE = @SEAT_CODE)
	BEGIN
		-- 좌석내의 날짜 차이 
		SELECT
			@DIFF_DAY = DATEDIFF(DAY, DEP_DEP_DATE, ARR_DEP_DATE),  -- 한국출발/현지출발날짜차이
			@DEP_DIFF = DATEDIFF(DAY, DEP_DEP_DATE, DEP_ARR_DATE),	-- 한국출발,현지도착날짜차이
			@ARR_DIFF = DATEDIFF(DAY, DEP_DEP_DATE, ARR_ARR_DATE)	-- 한국출발/한국도착날짜차이
		FROM PRO_TRANS_SEAT WITH(NOLOCK)  WHERE SEAT_CODE = @SEAT_CODE

		-- 루프! 
		WHILE (@END_DATE >= @START_DATE)
		BEGIN
			BEGIN TRY
				
				DECLARE @ADD_DAY INT -- 세그복사시 날짜 차이 
				SELECT @ADD_DAY = DATEDIFF(DAY, DEP_DEP_DATE, @START_DATE) -- 세그복사시 날짜 차이  
				FROM PRO_TRANS_SEAT WITH(NOLOCK)  WHERE SEAT_CODE = @SEAT_CODE

				-- 날짜 동일, 복사 안됨 
				IF @ADD_DAY = 0 
				BEGIN
					INSERT INTO #MSG_TEMP 
					SELECT @START_DATE, 2, '기준날짜와 동일'

					SET @START_DATE = DATEADD(DAY, 1, @START_DATE)

					CONTINUE -- 다음으로 
				END 

				-- 날짜 패턴 있을경우 
				IF '1' = SUBSTRING(@WEEK_DAY_TYPE, DATEPART(WEEKDAY, @START_DATE), 1)
				BEGIN

					-- 중복 좌석 체크
					IF NOT EXISTS(
						SELECT 1 FROM PRO_TRANS_SEAT A WITH(NOLOCK) 
						INNER JOIN PRO_TRANS_SEAT B WITH(NOLOCK) ON B.SEAT_CODE = @SEAT_CODE
							AND A.DEP_TRANS_CODE = B.DEP_TRANS_CODE
							AND A.DEP_TRANS_NUMBER = B.DEP_TRANS_NUMBER
							AND A.ARR_TRANS_CODE = B.ARR_TRANS_CODE
							AND A.ARR_TRANS_NUMBER = B.ARR_TRANS_NUMBER
							AND A.DEP_DEP_AIRPORT_CODE = B.DEP_DEP_AIRPORT_CODE
							AND A.DEP_ARR_AIRPORT_CODE = B.DEP_ARR_AIRPORT_CODE
							AND A.ARR_DEP_AIRPORT_CODE = B.ARR_DEP_AIRPORT_CODE
							AND A.ARR_ARR_AIRPORT_CODE = B.ARR_ARR_AIRPORT_CODE

							AND A.FARE_SEAT_TYPE = B.FARE_SEAT_TYPE  -- 좌석등급 추가 
						WHERE 
							A.DEP_DEP_DATE = @START_DATE
							AND A.DEP_ARR_DATE = DATEADD(DAY, @DEP_DIFF, @START_DATE)
							AND A.ARR_DEP_DATE = DATEADD(DAY, @DIFF_DAY, @START_DATE)
							AND A.ARR_ARR_DATE = DATEADD(DAY, @ARR_DIFF, @START_DATE)
					)
					BEGIN
				
						-- 출국편 체크(마스터)
						IF EXISTS(
							SELECT 1 FROM PRO_TRANS_MASTER A WITH(NOLOCK) 
							INNER JOIN PRO_TRANS_SEAT B WITH(NOLOCK)  ON A.TRANS_CODE = B.DEP_TRANS_CODE AND A.TRANS_NUMBER = B.DEP_TRANS_NUMBER AND A.DEP_AIRPORT_CODE = B.DEP_DEP_AIRPORT_CODE AND A.ARR_AIRPORT_CODE = B.DEP_ARR_AIRPORT_CODE
							WHERE B.SEAT_CODE = @SEAT_CODE AND SUBSTRING(A.WEEKDAY_TYPE, DATEPART(WEEKDAY, @START_DATE), 1) = 1
						)
						BEGIN
							-- 귀국편 체크(마스터)
							IF EXISTS(
								SELECT 1 FROM PRO_TRANS_MASTER A WITH(NOLOCK) 
								INNER JOIN PRO_TRANS_SEAT B  WITH(NOLOCK) ON A.TRANS_CODE = B.ARR_TRANS_CODE AND A.TRANS_NUMBER = B.ARR_TRANS_NUMBER AND A.DEP_AIRPORT_CODE = B.ARR_DEP_AIRPORT_CODE AND A.ARR_AIRPORT_CODE = B.ARR_ARR_AIRPORT_CODE
								WHERE B.SEAT_CODE = @SEAT_CODE AND SUBSTRING(A.WEEKDAY_TYPE, DATEPART(WEEKDAY, DATEADD(DAY, @DIFF_DAY, @START_DATE)), 1) = 1
							)
							BEGIN
								INSERT INTO PRO_TRANS_SEAT (
									DEP_TRANS_CODE,			DEP_TRANS_NUMBER,		DEP_DEP_TIME,			DEP_ARR_TIME,
									DEP_SPEND_TIME,			DEP_DEP_AIRPORT_CODE,	DEP_ARR_AIRPORT_CODE,	ARR_TRANS_CODE,
									ARR_TRANS_NUMBER,		ARR_DEP_TIME,			ARR_ARR_TIME,			ARR_SPEND_TIME,
									ARR_DEP_AIRPORT_CODE,	ARR_ARR_AIRPORT_CODE,	ADT_PRICE,				CHD_PRICE,
									INF_PRICE,				SEAT_COUNT,				MAX_SEAT_COUNT,			SEAT_TYPE,		FARE_SEAT_TYPE,
									TRANS_TYPE,				NEW_DATE,				NEW_CODE,
									DEP_DEP_DATE,									DEP_ARR_DATE,
									ARR_DEP_DATE,									ARR_ARR_DATE )
								SELECT
									DEP_TRANS_CODE,			DEP_TRANS_NUMBER,		DEP_DEP_TIME,			DEP_ARR_TIME,
									DEP_SPEND_TIME,			DEP_DEP_AIRPORT_CODE,	DEP_ARR_AIRPORT_CODE,	ARR_TRANS_CODE,
									ARR_TRANS_NUMBER,		ARR_DEP_TIME,			ARR_ARR_TIME,			ARR_SPEND_TIME,
									ARR_DEP_AIRPORT_CODE,	ARR_ARR_AIRPORT_CODE,	ADT_PRICE,				CHD_PRICE,
									INF_PRICE,				SEAT_COUNT,				MAX_SEAT_COUNT,			SEAT_TYPE,		FARE_SEAT_TYPE,
									TRANS_TYPE,				GETDATE(),				@EMP_CODE,
									@START_DATE,									DATEADD(DAY, @DEP_DIFF, @START_DATE),
									DATEADD(DAY, @DIFF_DAY, @START_DATE),			DATEADD(DAY, @ARR_DIFF, @START_DATE )
								FROM PRO_TRANS_SEAT WITH(NOLOCK)  WHERE SEAT_CODE = @SEAT_CODE


								-- 2019-04- 신규 좌석 세그 추가 
								DECLARE @NEW_SEAT_CODE INT 
								SET @NEW_SEAT_CODE  = @@IDENTITY 
								INSERT INTO PRO_TRANS_SEAT_SEGMENT (
									SEAT_CODE,TRANS_SEQ,SEG_NO,
									DEP_AIRPORT_CODE,ARR_AIRPORT_CODE,AIRLINE_CODE,
									FLIGHT,
									DEP_DATE,ARR_DATE,NEW_CODE,NEW_DATE,
									REAL_AIRLINE_CODE,FLYING_TIME )
								SELECT
									@NEW_SEAT_CODE,TRANS_SEQ,SEG_NO,
									DEP_AIRPORT_CODE,ARR_AIRPORT_CODE,AIRLINE_CODE,
									FLIGHT,
									DATEADD(DAY, @ADD_DAY, DEP_DATE ) AS DEP_DATE  ,
									DATEADD(DAY, @ADD_DAY, ARR_DATE ) AS ARR_DATE ,
									@EMP_CODE AS NEW_CODE,GETDATE() ,
									REAL_AIRLINE_CODE,FLYING_TIME
								
									--DEP_TRANS_CODE,			DEP_TRANS_NUMBER,		DEP_DEP_TIME,			DEP_ARR_TIME,
									--DEP_SPEND_TIME,			DEP_DEP_AIRPORT_CODE,	DEP_ARR_AIRPORT_CODE,	ARR_TRANS_CODE,
									--ARR_TRANS_NUMBER,		ARR_DEP_TIME,			ARR_ARR_TIME,			ARR_SPEND_TIME,
									--ARR_DEP_AIRPORT_CODE,	ARR_ARR_AIRPORT_CODE,	ADT_PRICE,				CHD_PRICE,
									--INF_PRICE,				SEAT_COUNT,				MAX_SEAT_COUNT,			SEAT_TYPE,		FARE_SEAT_TYPE,
									--TRANS_TYPE,				GETDATE(),				@EMP_CODE,
									--@START_DATE,									DATEADD(DAY, @DEP_DIFF, @START_DATE),
									--DATEADD(DAY, @DIFF_DAY, @START_DATE),			DATEADD(DAY, @ARR_DIFF, @START_DATE )
								FROM PRO_TRANS_SEAT_SEGMENT WITH(NOLOCK)  
								WHERE SEAT_CODE = @SEAT_CODE

								-- LOG INSERT
								INSERT INTO #MSG_TEMP 
								SELECT @START_DATE, 1, '성공'
							END
							ELSE
							BEGIN
								INSERT INTO #MSG_TEMP 
								SELECT @START_DATE, 2, '귀국편 요일패턴 불일치'
							END
						END
						ELSE
						BEGIN
							INSERT INTO #MSG_TEMP 
							SELECT @START_DATE, 2, '출국편 요일패턴 불일치'
						END
					
		--				PRINT '---'
		--				PRINT @START_DATE
		--				PRINT DATEADD(DAY, @DEP_DIFF, @START_DATE)
		--				PRINT DATEADD(DAY, @DIFF_DAY, @START_DATE)
		--				PRINT DATEADD(DAY, @ARR_DIFF, @START_DATE)
					END
					ELSE
					BEGIN
						INSERT INTO #MSG_TEMP 
						SELECT @START_DATE, 2, '중복 좌석 존재'
					END
				END
			
				--PRINT @START_DATE
			END TRY
			BEGIN CATCH
				-- LOG INSERT
				INSERT INTO #MSG_TEMP 
				SELECT @START_DATE, 2, ERROR_MESSAGE()

			END CATCH

			SET @START_DATE = DATEADD(DAY, 1, @START_DATE)
		END



	END
	ELSE
	BEGIN
		-- LOG INSERT
		INSERT INTO #MSG_TEMP 
		SELECT @START_DATE, 2, '기준좌석 존재 하지 않음'
	END

	
	

	SELECT * FROM #MSG_TEMP
	
	DROP TABLE #MSG_TEMP
END
--EXEC SP_PRO_TRANS_SEAT_COPY @SEAT_CODE=87,@START=N'2009-02-22',@END=N'2009-02-28',@WEEK_DAY_TYPE=N'1111111',@EMP_CODE=N'2008011'


GO