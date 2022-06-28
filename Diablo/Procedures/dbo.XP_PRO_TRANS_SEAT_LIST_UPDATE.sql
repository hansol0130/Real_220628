USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ USP_Name					: XP_PRO_TRANS_SEAT_LIST_UPDATE  
■ Description				: 마스터의 좌석 정보 일괄정보 업데이트
■ Input Parameter			:                  


■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: EXEC XP_PRO_TRANS_SEAT_LIST_UPDATE '
■ Author					: 박형만  
■ Date						: 2019-07-16
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
   2019-07-16		박형만			최초생성  
-------------------------------------------------------------------------------------------------*/ 
CREATE  PROC [dbo].[XP_PRO_TRANS_SEAT_LIST_UPDATE] 
	@SEAT_CODES VARCHAR(4000),
	
	@DEP_TRANS_NUMBER VARCHAR(4),
	@ARR_TRANS_NUMBER VARCHAR(4),

	@DEP_DEP_AIRPORT_CODE VARCHAR(3),
	@DEP_ARR_AIRPORT_CODE VARCHAR(3),
	@ARR_DEP_AIRPORT_CODE VARCHAR(3),
	@ARR_ARR_AIRPORT_CODE VARCHAR(3),

	@DEP_DEP_TIME VARCHAR(5),
	@DEP_ARR_TIME VARCHAR(5),
	@ARR_DEP_TIME VARCHAR(5),
	@ARR_ARR_TIME VARCHAR(5),

	@DEP_SPEND_TIME VARCHAR(5),
	@ARR_SPEND_TIME VARCHAR(5),

	@DEP_DIFF_DAY INT,
	@ARR_DIFF_DAY INT,

	@TOT_DAYS INT ,

	@EMP_CODE VARCHAR(7) 
AS 
BEGIN


 
--DECLARE @SEAT_CODES VARCHAR(4000) , 

--@DEP_TRANS_NUMBER VARCHAR(4) ,
--@ARR_TRANS_NUMBER VARCHAR(4) ,

--@DEP_DEP_AIRPORT_CODE VARCHAR(3),
--@DEP_ARR_AIRPORT_CODE VARCHAR(3),
--@ARR_DEP_AIRPORT_CODE VARCHAR(3),
--@ARR_ARR_AIRPORT_CODE VARCHAR(3),

--@DEP_DEP_TIME VARCHAR(5),
--@DEP_ARR_TIME VARCHAR(5),
--@ARR_DEP_TIME VARCHAR(5),
--@ARR_ARR_TIME VARCHAR(5),

--@DEP_SPEND_TIME VARCHAR(5),
--@ARR_SPEND_TIME VARCHAR(5),

--@DEP_DIFF_DAY INT,@ARR_DIFF_DAY INT,@TOT_DAYS INT,
--@EMP_CODE VARCHAR(7) 

--SELECT @DEP_TRANS_NUMBER = '323',
--@ARR_TRANS_NUMBER ='322',
--@DEP_DEP_AIRPORT_CODE ='ICN',@DEP_ARR_AIRPORT_CODE ='DXB',@ARR_DEP_AIRPORT_CODE ='DXB',@ARR_ARR_AIRPORT_CODE ='ICN',
--@DEP_DEP_TIME = '23:55' , @DEP_ARR_TIME = '04:25' , @ARR_DEP_TIME = '03:40', @ARR_ARR_TIME= '16:55',
--@DEP_SPEND_TIME = '09:30',@ARR_SPEND_TIME = '08:15',
--@DEP_DIFF_DAY = 0 ,
--@ARR_DIFF_DAY = 0 ,
--@TOT_DAYS = 9 ,
--@EMP_CODE = '2013007'

---- 수정할 SEAT_CODE 
--SET @SEAT_CODES = '7548910,7548912'

	-- 임시테이블 
	DECLARE @TMP_SEAT_CODES TABLE 
	( NUM INT,  SEAT_CODE INT  ) 
	INSERT INTO @TMP_SEAT_CODES 
	SELECT ID , DATA FROM DBO.FN_SPLIT(@SEAT_CODES,',') 


	-- 좌석 테이블이 있으면 
	IF EXISTS ( SELECT * FROM @TMP_SEAT_CODES )
	BEGIN

		-- 값 처리 
		UPDATE A 
		SET A.DEP_TRANS_NUMBER = B.DEP_TRANS_NUMBER 
			,A.ARR_TRANS_NUMBER = B.ARR_TRANS_NUMBER
			,A.DEP_DEP_AIRPORT_CODE = B.DEP_DEP_AIRPORT_CODE
			,A.DEP_ARR_AIRPORT_CODE = B.DEP_ARR_AIRPORT_CODE
			,A.ARR_DEP_AIRPORT_CODE = B.ARR_DEP_AIRPORT_CODE
			,A.ARR_ARR_AIRPORT_CODE = B.ARR_ARR_AIRPORT_CODE

			,A.DEP_DEP_TIME = B.DEP_DEP_TIME
			,A.DEP_ARR_TIME = B.DEP_ARR_TIME
			,A.ARR_DEP_TIME = B.ARR_DEP_TIME
			,A.ARR_ARR_TIME = B.ARR_ARR_TIME

			,A.DEP_SPEND_TIME = B.DEP_SPEND_TIME
			,A.ARR_SPEND_TIME = B.ARR_SPEND_TIME

			,A.DEP_DEP_DATE = B.DEP_DEP_DATE 
			,A.DEP_ARR_DATE = B.DEP_ARR_DATE 
			,A.ARR_DEP_DATE = B.ARR_DEP_DATE 
			,A.ARR_ARR_DATE = B.ARR_ARR_DATE 
			,A.EDT_CODE = @EMP_CODE 
			,A.EDT_DATE = GETDATE() 
		----확인시 
		--SELECT B.* , @EMP_CODE , GETDATE() 
		FROM PRO_TRANS_SEAT A 
		INNER JOIN ( 
			SELECT 
			SEAT_CODE , 
			@DEP_TRANS_NUMBER AS DEP_TRANS_NUMBER , 
			@ARR_TRANS_NUMBER AS ARR_TRANS_NUMBER ,

			@DEP_DEP_AIRPORT_CODE AS DEP_DEP_AIRPORT_CODE ,
			@DEP_ARR_AIRPORT_CODE AS DEP_ARR_AIRPORT_CODE ,
			@ARR_DEP_AIRPORT_CODE AS ARR_DEP_AIRPORT_CODE ,
			@ARR_ARR_AIRPORT_CODE AS ARR_ARR_AIRPORT_CODE ,

			@DEP_DEP_TIME AS DEP_DEP_TIME , 
			@DEP_ARR_TIME AS DEP_ARR_TIME , 
			@ARR_DEP_TIME AS ARR_DEP_TIME , 
			@ARR_ARR_TIME AS ARR_ARR_TIME , 

			@DEP_SPEND_TIME AS DEP_SPEND_TIME,
			@ARR_SPEND_TIME AS ARR_SPEND_TIME,

			--출발일 처리 
			DEP_DEP_DATE , 
			DATEADD(D,@DEP_DIFF_DAY,DEP_DEP_DATE) AS DEP_ARR_DATE ,

			--귀국일 처리
			DATEADD(D,-@ARR_DIFF_DAY,ARR_ARR_DATE) AS ARR_DEP_DATE ,
			CASE WHEN @TOT_DAYS > 0 THEN DATEADD(D,@TOT_DAYS-1,DEP_DEP_DATE) ELSE ARR_ARR_DATE END AS ARR_ARR_DATE 

			FROM PRO_TRANS_SEAT 
			WHERE SEAT_CODE IN ( SELECT SEAT_CODE FROM @TMP_SEAT_CODES ) 
		) B 
			ON A.SEAT_CODE = B.SEAT_CODE 

		SELECT @@ROWCOUNT AS ROW_COUNT
	END 
	ELSE 
	BEGIN
		SELECT -1 
	END 

END 
GO