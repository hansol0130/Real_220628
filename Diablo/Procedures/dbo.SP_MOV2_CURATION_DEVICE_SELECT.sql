USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_MOV2_CURATION_DEVICE_SELECT
■ DESCRIPTION				: 검색_큐레이션디바이스정보
■ INPUT PARAMETER			: 
		START_DATE, 
		END_DATE, 
		CUS_NO, 
		RES_CODE, 
		SELECT_TYPE(1: 큐비배치, 2:사용자(웹), 3: 예약번호(웹)),
		ITEM_TYPE(1: 여권사본, 2: 여행자계약서)
■ EXEC						: 
    -- EXEC SP_MOV2_CURATION_DEVICE_SELECT '2016-10-31', '2016-11-01', 0, '', 1, 0	-- 큐비배치
	-- EXEC SP_MOV2_CURATION_DEVICE_SELECT '2017-12-29', '2017-12-31', 0, '', 6, 1  -- 큐비여권사본
	-- EXEC SP_MOV2_CURATION_DEVICE_SELECT '2017-12-29', '2017-12-31', 0, '', 6, 2  -- 큐비여행자계약서
	-- EXEC SP_MOV2_CURATION_DEVICE_SELECT '', '', 9001978, '', 2, 0                
	-- EXEC SP_MOV2_CURATION_DEVICE_SELECT '', '', 0, 'RP1607282981', 3, 0

■ MEMO						: 큐레이션대상 디바이스목록을 가져온다.
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-05-29		IBSOLUTION				최초생성
   2017-12-27		IBSOLUTION				여권사본 / 여행자계약서 / 입금마감일 추가
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_CURATION_DEVICE_SELECT]
	@START_DATE		DATETIME,
	@END_DATE		DATETIME,
	@CUS_NO			INT,
	@RES_CODE		VARCHAR(20),
	@SELECT_TYPE	INT,
	@ITEM_TYPE		INT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000);
	DECLARE @START_TIME CHAR(5) = CONVERT(CHAR(5), @START_DATE, 108), @END_TIME CHAR(5) = CONVERT(CHAR(5), @END_DATE, 108);
	
	IF @SELECT_TYPE = 1           
		BEGIN
			-- 예약일
			SET @SQLSTRING = N'
				SELECT A.RES_CODE, A.SEQ_NO, A.CUS_NO, A.CUS_NAME, A.LAST_NAME, A.FIRST_NAME, B.CUS_DEVICE_ID, B.REMARK, M.APP_OS 
				FROM RES_CUSTOMER_DAMO A WITH(NOLOCK) 
					LEFT JOIN DEVICE_MASTER B WITH(NOLOCK) 
						ON A.CUS_NO = B.CUS_NO   
					LEFT JOIN APP_MASTER M WITH(NOLOCK) 
						ON B.APP_CODE = M.APP_CODE  
				WHERE A.RES_CODE IN (
					SELECT RES_CODE FROM RES_MASTER_damo C WITH(NOLOCK) 
					WHERE C.VIEW_YN =''Y''
						AND C.RES_STATE < 7
		   				AND C.NEW_DATE >= @START_DATE
		   				AND C.NEW_DATE <= @END_DATE
					) 
					-- AND B.CUS_DEVICE_ID IS NOT NULL
					AND A.RES_STATE = 0 ';
		END
	ELSE IF @SELECT_TYPE = 2
		BEGIN	
			-- 특정고객
			SET @SQLSTRING = N'
				SELECT B.CUS_NO, B.CUS_DEVICE_ID, B.REMARK, M.APP_OS 
				FROM DEVICE_MASTER B WITH(NOLOCK) 
					LEFT JOIN APP_MASTER M WITH(NOLOCK) 
						ON B.APP_CODE = M.APP_CODE  
				WHERE B.CUS_NO = ' + CONVERT(varchar(20), @CUS_NO) ;
		END	
	ELSE IF @SELECT_TYPE = 3
		BEGIN	
			-- 출발자
			SET @SQLSTRING = N'
				SELECT A.RES_CODE, A.SEQ_NO, A.CUS_NO, A.CUS_NAME, A.LAST_NAME, A.FIRST_NAME, B.CUS_DEVICE_ID, B.REMARK, M.APP_OS 
				FROM RES_CUSTOMER_DAMO A WITH(NOLOCK) 
					LEFT JOIN DEVICE_MASTER B WITH(NOLOCK) 
						ON A.CUS_NO = B.CUS_NO   
					LEFT JOIN APP_MASTER M WITH(NOLOCK) 
						ON B.APP_CODE = M.APP_CODE  
				WHERE A.VIEW_YN =''Y'' and A.RES_CODE = ''' + @RES_CODE + '''';
		END	
	ELSE IF @SELECT_TYPE = 4
		BEGIN
			-- 출발일
			SET @SQLSTRING = N'
				WITH LIST AS (
					-- 패키지
					SELECT A.RES_CODE, A.MASTER_CODE
					FROM RES_MASTER_damo A WITH(NOLOCK)
					INNER JOIN PKG_DETAIL B WITH(NOLOCK) ON A.PRO_CODE = B.PRO_CODE
					INNER JOIN PRO_TRANS_SEAT C WITH(NOLOCK) ON B.SEAT_CODE = C.SEAT_CODE
					WHERE A.DEP_DATE >= CONVERT(DATE, @START_DATE) AND A.DEP_DATE < CONVERT(DATE, DATEADD(D, 1, @END_DATE)) AND A.RES_STATE <= 7 AND A.PRO_TYPE = 1
					AND C.DEP_DEP_TIME >= @START_TIME AND C.DEP_DEP_TIME <= @END_TIME
					UNION ALL
					-- 항공
					SELECT A.RES_CODE, A.MASTER_CODE
					FROM RES_MASTER_damo A WITH(NOLOCK)
					WHERE A.DEP_DATE >= @START_DATE AND A.DEP_DATE < @END_DATE AND A.RES_STATE <= 7 AND A.PRO_TYPE = 2
				)

				SELECT A.RES_CODE, A.SEQ_NO, A.CUS_NO, A.CUS_NAME, A.LAST_NAME, A.FIRST_NAME, B.CUS_DEVICE_ID, B.REMARK, M.APP_OS 
				FROM RES_CUSTOMER_DAMO A WITH(NOLOCK) 
					LEFT JOIN DEVICE_MASTER B WITH(NOLOCK) 
						ON A.CUS_NO = B.CUS_NO   
					LEFT JOIN APP_MASTER M WITH(NOLOCK) 
						ON B.APP_CODE = M.APP_CODE  
				WHERE A.RES_CODE IN (
					SELECT C.RES_CODE
					FROM LIST C
						INNER JOIN PKG_MASTER P WITH(NOLOCK) 
							ON C.MASTER_CODE = P.MASTER_CODE 
							AND P.ATT_CODE IN (''P'',''R'',''W'',''G'') 
							AND P.SIGN_CODE <> ''K''
					) 
					-- AND B.CUS_DEVICE_ID IS NOT NULL
					AND A.RES_STATE = 0 ';
		END
	ELSE IF @SELECT_TYPE = 5
		BEGIN
			-- 도착일
			SET @SQLSTRING = N'
				WITH LIST AS (
					-- 패키지
					SELECT A.RES_CODE, A.MASTER_CODE
					FROM RES_MASTER_damo A WITH(NOLOCK)
					INNER JOIN PKG_DETAIL B WITH(NOLOCK) ON A.PRO_CODE = B.PRO_CODE
					INNER JOIN PRO_TRANS_SEAT C WITH(NOLOCK) ON B.SEAT_CODE = C.SEAT_CODE
					WHERE A.ARR_DATE >= CONVERT(DATE, @START_DATE) AND A.ARR_DATE < CONVERT(DATE, DATEADD(D, 1, @END_DATE)) AND A.RES_STATE <= 7 AND A.PRO_TYPE = 1
					AND C.ARR_ARR_TIME >= @START_TIME AND C.ARR_ARR_TIME <= @END_TIME
					UNION ALL
					-- 항공
					SELECT A.RES_CODE, A.MASTER_CODE
					FROM RES_MASTER_damo A WITH(NOLOCK)
					WHERE A.ARR_DATE >= @START_DATE AND A.ARR_DATE < @END_DATE AND A.RES_STATE <= 7 AND A.PRO_TYPE = 2
				)

				SELECT A.RES_CODE, A.SEQ_NO, A.CUS_NO, A.CUS_NAME, A.LAST_NAME, A.FIRST_NAME, B.CUS_DEVICE_ID, B.REMARK, M.APP_OS 
				FROM RES_CUSTOMER_DAMO A WITH(NOLOCK) 
					LEFT JOIN DEVICE_MASTER B WITH(NOLOCK) 
						ON A.CUS_NO = B.CUS_NO   
					LEFT JOIN APP_MASTER M WITH(NOLOCK) 
						ON B.APP_CODE = M.APP_CODE  
				WHERE A.RES_CODE IN (
					SELECT C.RES_CODE
					FROM LIST C
						INNER JOIN PKG_MASTER P WITH(NOLOCK) 
							ON C.MASTER_CODE = P.MASTER_CODE 
							AND P.ATT_CODE IN (''P'',''R'',''W'',''G'') 
							AND P.SIGN_CODE <> ''K''
					) 
					-- AND B.CUS_DEVICE_ID IS NOT NULL
					AND A.RES_STATE = 0 ';

		END
	ELSE IF @SELECT_TYPE = 6
		BEGIN
			-- 입금마감일
			IF @ITEM_TYPE = 1           
				BEGIN
					-- 여권사본 등록안된경우
					SET @SQLSTRING = N'
						SELECT A.RES_CODE, A.SEQ_NO, A.CUS_NO, A.CUS_NAME, A.LAST_NAME, A.FIRST_NAME, B.CUS_DEVICE_ID, B.REMARK, M.APP_OS 
						FROM RES_CUSTOMER_DAMO A WITH(NOLOCK) 
							LEFT JOIN DEVICE_MASTER B WITH(NOLOCK) 
								ON A.CUS_NO = B.CUS_NO   
							LEFT JOIN APP_MASTER M WITH(NOLOCK) 
								ON B.APP_CODE = M.APP_CODE  
						WHERE A.RES_CODE IN (
							SELECT RES_CODE FROM RES_MASTER_damo C WITH(NOLOCK) 
							WHERE C.VIEW_YN =''Y''
								AND C.PRO_TYPE = 1
								AND C.RES_STATE < 7
		   						AND C.LAST_PAY_DATE >= @START_DATE
		   						AND C.LAST_PAY_DATE <= @END_DATE
							) 
							AND (SELECT COUNT(*) FROM PPT_MASTER P WITH(NOLOCK) WHERE P.RES_CODE = A.RES_CODE AND P.RES_NO = A.SEQ_NO) < 1  -- 여권사본 제출되지 않은 상태

							-- AND B.CUS_DEVICE_ID IS NOT NULL
							AND A.RES_STATE = 0 ';
				END
			ELSE IF @ITEM_TYPE = 2
				BEGIN
					-- 여행자 계약서 동의 안된 대표사용자만
					SET @SQLSTRING = N'
						SELECT A.RES_CODE, A.SEQ_NO, A.CUS_NO, A.CUS_NAME, A.LAST_NAME, A.FIRST_NAME, B.CUS_DEVICE_ID, B.REMARK, M.APP_OS 
						FROM RES_CUSTOMER_DAMO A WITH(NOLOCK) 
							LEFT JOIN DEVICE_MASTER B WITH(NOLOCK) 
								ON A.CUS_NO = B.CUS_NO   
							LEFT JOIN APP_MASTER M WITH(NOLOCK) 
								ON B.APP_CODE = M.APP_CODE  
							LEFT JOIN RES_CONTRACT H WITH(NOLOCK)
								ON A.RES_CODE = H.RES_CODE 
								AND H.CONTRACT_NO = (SELECT MAX(CONTRACT_NO) FROM RES_CONTRACT WHERE RES_CODE = H.RES_CODE)
						WHERE A.RES_CODE IN (
								SELECT RES_CODE FROM RES_MASTER_damo C WITH(NOLOCK) 
								WHERE C.VIEW_YN =''Y''
									AND C.PRO_TYPE = 1
									AND C.RES_STATE < 7
		   							AND C.LAST_PAY_DATE >= @START_DATE
		   							AND C.LAST_PAY_DATE <= @END_DATE
							) 
							AND A.CUS_NO = (  -- 대표사용자
								SELECT TOP 1 RC.CUS_NO FROM RES_CUSTOMER_damo RC WITH (NOLOCK)
								WHERE RC.RES_CODE = A.RES_CODE AND RC.AGE_TYPE = 0
								ORDER BY SEQ_NO								
							)
							AND H.CONTRACT_NO > 0	-- 계약서 존재
							AND H.CFM_YN = ''N''	-- 동의 안된 상태

							-- AND B.CUS_DEVICE_ID IS NOT NULL
							AND A.RES_STATE = 0 ';

				END
			ELSE
				BEGIN
					-- 입금마감일
					SET @SQLSTRING = N'
						SELECT A.RES_CODE, A.SEQ_NO, A.CUS_NO, A.CUS_NAME, A.LAST_NAME, A.FIRST_NAME, B.CUS_DEVICE_ID, B.REMARK, M.APP_OS 
						FROM RES_CUSTOMER_DAMO A WITH(NOLOCK) 
							LEFT JOIN DEVICE_MASTER B WITH(NOLOCK) 
								ON A.CUS_NO = B.CUS_NO   
							LEFT JOIN APP_MASTER M WITH(NOLOCK) 
								ON B.APP_CODE = M.APP_CODE  
						WHERE A.RES_CODE IN (
							SELECT RES_CODE FROM RES_MASTER_damo C WITH(NOLOCK) 
							WHERE C.VIEW_YN =''Y''
								AND C.RES_STATE < 7
		   						AND C.LAST_PAY_DATE >= @START_DATE
		   						AND C.LAST_PAY_DATE <= @END_DATE
							) 
							-- AND B.CUS_DEVICE_ID IS NOT NULL
							AND A.RES_STATE = 0 ';
				END
		END
	
	PRINT @SQLSTRING		

	SET @PARMDEFINITION = N'@START_DATE DATETIME, @END_DATE DATETIME, @START_TIME CHAR(5), @END_TIME CHAR(5)';
	EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @START_DATE, @END_DATE, @START_TIME, @END_TIME

	SET NOCOUNT OFF;
END           



GO
