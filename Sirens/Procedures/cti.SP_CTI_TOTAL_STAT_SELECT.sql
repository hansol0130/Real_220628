USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_TOTAL_STAT_SELECT
■ DESCRIPTION				: 통합리포트
-- 조회기간 SDATE, EDATE
-- 비교기간 CSDATE, CEDATE
-- 담당부서 TEAM_CODE
-- LS : LEFT SUM
-- LA : LEFT AVG
-- RS : RIGHT SUM
-- RA : RIGHT AVG
■ INPUT PARAMETER			: 
	:AUTH_ID					: 그룹코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_TOTAL_STAT_SELECT '', '20141101', '20141130', '20141201', '20141231'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-26		홍영택			최초생성
   2015-01-30		박노민			부서 선택 시 하위 부서 동시 조회 추가
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_TOTAL_STAT_SELECT]
@TEAM_CODE varchar(10), 
@SDATE varchar(10), 
@EDATE varchar(10), 
@BSDATE varchar(10), 
@BEDATE varchar(10)

WITH EXEC AS CALLER
AS
SET NOCOUNT ON

BEGIN

	-- 하위 부서 체크
	DECLARE @TEAM_LIST VARCHAR(500);

	WITH TEAM_LIST AS
	(
		SELECT A.TEAM_CODE, A.PARENT_CODE, 0 AS [DEPTH]
		FROM Diablo.dbo.EMP_TEAM A WITH(NOLOCK)
		WHERE A.TEAM_CODE = @TEAM_CODE
		UNION ALL
		SELECT A.TEAM_CODE, A.PARENT_CODE, B.DEPTH + 1
		FROM Diablo.dbo.EMP_TEAM A WITH(NOLOCK)
		INNER JOIN TEAM_LIST B ON A.PARENT_CODE = B.TEAM_CODE
		WHERE A.USE_YN = 'Y' AND A.VIEW_YN = 'Y'
	)
	SELECT @TEAM_LIST= (STUFF ((SELECT (',' + TEAM_CODE) AS [text()] FROM TEAM_LIST FOR XML PATH('')), 1, 1, ''));


SELECT
    -- 총수신콜
    MAX(LS_TOTAL_CALL) AS LS_TOTAL_CALL,
    MAX(RS_TOTAL_CALL) AS RS_TOTAL_CALL,
    -- 멘트중 끊음
    MAX(LS_DAN_CALL) AS LS_DAN_CALL,
    MAX(RS_DAN_CALL) AS RS_DAN_CALL,
    -- 상담연결
    MAX(LS_REQ_CALL) AS LS_REQ_CALL,
    MAX(RS_REQ_CALL) AS RS_REQ_CALL,
    -- 상담완료
    MAX(LS_CON_CALL) AS LS_CON_CALL,
    MAX(RS_CON_CALL) AS RS_CON_CALL,
    -- 상담포기
    MAX(LS_AB_CALL) AS LS_AB_CALL,
    MAX(RS_AB_CALL) AS RS_AB_CALL,
    -- 콜백
    MAX(LS_CB_CALL) AS LS_CB_CALL,
    MAX(RS_CB_CALL) AS RS_CB_CALL,
    -- SMS예약확인
    MAX(LS_SMS_CALL) AS LS_SMS_CALL,
    MAX(RS_SMS_CALL) AS RS_SMS_CALL,
    -- 총수신콜
    MAX(LS_IN_CALL_TOTAL) AS LS_IN_CALL_TOTAL,
    MAX(RS_IN_CALL_TOTAL) AS RS_IN_CALL_TOTAL,
    -- 상담완료
    MAX(LS_IN_CALL_END) AS LS_IN_CALL_END,
    MAX(RS_IN_CALL_END) AS RS_IN_CALL_END,
    -- 직원부재
    MAX(LS_IN_CALL_AB) AS LS_IN_CALL_AB,
    MAX(RS_IN_CALL_AB) AS RS_IN_CALL_AB,
    -- 직원전환
    MAX(LS_IN_CALL_TRF) AS LS_IN_CALL_TRF,
    MAX(RS_IN_CALL_TRF) AS RS_IN_CALL_TRF,
    -- 수신응대율*
    MAX(LS_IN_CALL_RATE) AS LS_IN_CALL_RATE,
    MAX(RS_IN_CALL_RATE) AS RS_IN_CALL_RATE,
    -- 고객수
    MAX(LS_IN_CALL_CUST_COUNT) AS LS_IN_CALL_CUST_COUNT,
    MAX(RS_IN_CALL_CUST_COUNT) AS RS_IN_CALL_CUST_COUNT,
    -- 발신콜수
    MAX(LS_IN_CALL_TIME) AS LS_IN_CALL_TIME,
    MAX(RS_IN_CALL_TIME) AS RS_IN_CALL_TIME,
    -- 고객수
    MAX(LS_OUT_CALL_TOTAL) AS LS_OUT_CALL_TOTAL,
    MAX(RS_OUT_CALL_TOTAL) AS RS_OUT_CALL_TOTAL,
    -- 상담시간
    MAX(LS_OUT_CALL_CUST_COUNT) AS LS_OUT_CALL_CUST_COUNT,
    MAX(RS_OUT_CALL_CUST_COUNT) AS RS_OUT_CALL_CUST_COUNT,
    -- 평균통화시간
    MAX(LS_OUT_CALL_TIME) AS LS_OUT_CALL_TIME,
    MAX(RS_OUT_CALL_TIME) AS RS_OUT_CALL_TIME,
    -- 상담시간
    MAX(LS_IN_OUT_CALL_TIME) AS LS_IN_OUT_CALL_TIME,
    MAX(RS_IN_OUT_CALL_TIME) AS RS_IN_OUT_CALL_TIME,
    -- 평균통화시간
    MAX(LS_AVG_CALL_TIME) AS LS_AVG_CALL_TIME,
    MAX(RS_AVG_CALL_TIME) AS RS_AVG_CALL_TIME,
    -- 발생
    MAX(LS_PROMISE_TOTAL) AS LS_PROMISE_TOTAL,
    MAX(RS_PROMISE_TOTAL) AS RS_PROMISE_TOTAL,
    -- 처리
    MAX(LS_PROMISE_END) AS LS_PROMISE_END,
    MAX(RS_PROMISE_END) AS RS_PROMISE_END,
    -- 처리이행율*
    MAX(LS_PROMISE_RATE) AS LS_PROMISE_RATE,
    MAX(RS_PROMISE_RATE) AS RS_PROMISE_RATE,
    -- 고객평가*
    MAX(LS_EVA_CUST_SUM) AS LS_EVA_CUST_SUM,
    MAX(RS_EVA_CUST_SUM) AS RS_EVA_CUST_SUM,
    -- 내부모니터링*
    MAX(LS_EVA_EMP_SUM) AS LS_EVA_EMP_SUM,
    MAX(RS_EVA_EMP_SUM) AS RS_EVA_EMP_SUM,
    -- 전체예약 건수
    MAX(LS_RESERVE_COUNT) AS LS_RESERVE_COUNT,
    MAX(RS_RESERVE_COUNT) AS RS_RESERVE_COUNT,
    -- 예약전환율*
    MAX(LS_RESERVE_PER) AS LS_RESERVE_PER,
    MAX(RS_RESERVE_PER) AS RS_RESERVE_PER,
    -- 평균콜수*
    MAX(LS_RESERVE_CALL) AS LS_RESERVE_CALL,
    MAX(RS_RESERVE_CALL) AS RS_RESERVE_CALL,
    -- 평균통화시간*
    MAX(LS_RESERVE_TIME) AS LS_RESERVE_TIME,
    MAX(RS_RESERVE_TIME) AS RS_RESERVE_TIME,
    -- 고객대기피크*
    MAX(LS_PEAK_CUST) AS LS_PEAK_CUST,
    MAX(RS_PEAK_CUST) AS RS_PEAK_CUST,
    -- 동시통화피크*
    MAX(LS_PEAK_CALL) AS LS_PEAK_CALL,
    MAX(RS_PEAK_CALL) AS RS_PEAK_CALL,
    -- 남여 상담비중 @ 남
    MAX(LS_TYPE_SEX_M) AS LS_TYPE_SEX_M,
    MAX(RS_TYPE_SEX_M) AS RS_TYPE_SEX_M,
    -- 남여 상담비중 @ 여
    MAX(LS_TYPE_SEX_W) AS LS_TYPE_SEX_W,
    MAX(RS_TYPE_SEX_W) AS RS_TYPE_SEX_W,
    -- 남여 상담비중 @ 합
    MAX(LS_TYPE_SEX_SUM) AS LS_TYPE_SEX_SUM,
    MAX(RS_TYPE_SEX_SUM) AS RS_TYPE_SEX_SUM,
    -- 연령층 @ 10대
    MAX(LS_TYPE_AGE_10) AS LS_TYPE_AGE_10,
    MAX(RS_TYPE_AGE_10) AS RS_TYPE_AGE_10,
    -- 연령층 @ 20대
    MAX(LS_TYPE_AGE_20) AS LS_TYPE_AGE_20,
    MAX(RS_TYPE_AGE_20) AS RS_TYPE_AGE_20,
    -- 연령층 @ 30대
    MAX(LS_TYPE_AGE_30) AS LS_TYPE_AGE_30,
    MAX(RS_TYPE_AGE_30) AS RS_TYPE_AGE_30,
    -- 연령층 @ 40대
    MAX(LS_TYPE_AGE_40) AS LS_TYPE_AGE_40,
    MAX(RS_TYPE_AGE_40) AS RS_TYPE_AGE_40,
    -- 연령층 @ 50대
    MAX(LS_TYPE_AGE_50) AS LS_TYPE_AGE_50,
    MAX(RS_TYPE_AGE_50) AS RS_TYPE_AGE_50,
    -- 연령층 @ 60대
    MAX(LS_TYPE_AGE_60) AS LS_TYPE_AGE_60,
    MAX(RS_TYPE_AGE_60) AS RS_TYPE_AGE_60,
    -- 연령층 @ 합
    MAX(LS_TYPE_AGE_SUM) AS LS_TYPE_AGE_SUM,
    MAX(RS_TYPE_AGE_SUM) AS RS_TYPE_AGE_SUM,
    -- 상담분류 @ 고객 C
    MAX(LS_TYPE_CONSULT_C) AS LS_TYPE_CONSULT_C,
    MAX(RS_TYPE_CONSULT_C) AS RS_TYPE_CONSULT_C,
    -- 상담분류 @ 예약 R
    MAX(LS_TYPE_CONSULT_R) AS LS_TYPE_CONSULT_R,
    MAX(RS_TYPE_CONSULT_R) AS RS_TYPE_CONSULT_R,
    -- 상담분류 @ 상품 G
  MAX(LS_TYPE_CONSULT_G) AS LS_TYPE_CONSULT_G,
    MAX(RS_TYPE_CONSULT_G) AS RS_TYPE_CONSULT_G,
    -- 상담분류 @ 일반 N
    MAX(LS_TYPE_CONSULT_N) AS LS_TYPE_CONSULT_N,
    MAX(RS_TYPE_CONSULT_N) AS RS_TYPE_CONSULT_N,
    -- 상담분류 @ 합
    MAX(LS_TYPE_CONSULT_SUM) AS LS_TYPE_CONSULT_SUM,
    MAX(RS_TYPE_CONSULT_SUM) AS RS_TYPE_CONSULT_SUM
  FROM  
  (  
    SELECT
      -- 총수신콜
      CASE WHEN GUBUN = '1' THEN TOTAL_CALL ELSE 0 END AS LS_TOTAL_CALL,
      CASE WHEN GUBUN = '2' THEN TOTAL_CALL ELSE 0 END AS RS_TOTAL_CALL,

      -- 멘트중 끊음
      CASE WHEN GUBUN = '1' THEN DAN_CALL ELSE 0 END AS LS_DAN_CALL,     
      CASE WHEN GUBUN = '2' THEN DAN_CALL ELSE 0 END AS RS_DAN_CALL,

      -- 상담연결
      CASE WHEN GUBUN = '1' THEN REQ_CALL ELSE 0 END AS LS_REQ_CALL,      
      CASE WHEN GUBUN = '2' THEN REQ_CALL ELSE 0 END AS RS_REQ_CALL,
      
      -- 상담완료
      CASE WHEN GUBUN = '1' THEN CON_CALL ELSE 0 END AS LS_CON_CALL,      
      CASE WHEN GUBUN = '2' THEN CON_CALL ELSE 0 END AS RS_CON_CALL,
      
      -- 상담포기
      CASE WHEN GUBUN = '1' THEN AB_CALL ELSE 0 END AS LS_AB_CALL,    
      CASE WHEN GUBUN = '2' THEN AB_CALL ELSE 0 END AS RS_AB_CALL,
     
      -- 콜백
      CASE WHEN GUBUN = '1' THEN CB_CALL ELSE 0 END AS LS_CB_CALL,     
      CASE WHEN GUBUN = '2' THEN CB_CALL ELSE 0 END AS RS_CB_CALL,
      
      -- SMS예약확인
      CASE WHEN GUBUN = '1' THEN SMS_CALL ELSE 0 END AS LS_SMS_CALL,      
      CASE WHEN GUBUN = '2' THEN SMS_CALL ELSE 0 END AS RS_SMS_CALL,
     
      -- 총수신콜
      CASE WHEN GUBUN = '1' THEN IN_CALL_TOTAL ELSE 0 END AS LS_IN_CALL_TOTAL,     
      CASE WHEN GUBUN = '2' THEN IN_CALL_TOTAL ELSE 0 END AS RS_IN_CALL_TOTAL,
      
      -- 상담완료
      CASE WHEN GUBUN = '1' THEN IN_CALL_END ELSE 0 END AS LS_IN_CALL_END,      
      CASE WHEN GUBUN = '2' THEN IN_CALL_END ELSE 0 END AS RS_IN_CALL_END,
      
      -- 직원부재
      CASE WHEN GUBUN = '1' THEN IN_CALL_AB ELSE 0 END AS LS_IN_CALL_AB,      
      CASE WHEN GUBUN = '2' THEN IN_CALL_AB ELSE 0 END AS RS_IN_CALL_AB,
      
      -- 직원전환
      CASE WHEN GUBUN = '1' THEN IN_CALL_TRF ELSE 0 END AS LS_IN_CALL_TRF,      
      CASE WHEN GUBUN = '2' THEN IN_CALL_TRF ELSE 0 END AS RS_IN_CALL_TRF,
      
      -- 수신응대율*
      CASE WHEN GUBUN = '1' THEN IN_CALL_RATE ELSE 0 END AS LS_IN_CALL_RATE ,
      CASE WHEN GUBUN = '2' THEN IN_CALL_RATE ELSE 0 END AS RS_IN_CALL_RATE,
      
      -- 고객수
      CASE WHEN GUBUN = '1' THEN IN_CALL_CUST_COUNT ELSE 0 END AS LS_IN_CALL_CUST_COUNT,      
      CASE WHEN GUBUN = '2' THEN IN_CALL_CUST_COUNT ELSE 0 END AS RS_IN_CALL_CUST_COUNT,
      
      -- 수신시간
      CASE WHEN GUBUN = '1' THEN IN_CALL_TIME ELSE 0 END AS LS_IN_CALL_TIME,
      CASE WHEN GUBUN = '2' THEN IN_CALL_TIME ELSE 0 END AS RS_IN_CALL_TIME,
      
      -- 발신통화수
      CASE WHEN GUBUN = '1' THEN OUT_CALL_TOTAL ELSE 0 END AS LS_OUT_CALL_TOTAL,      
      CASE WHEN GUBUN = '2' THEN OUT_CALL_TOTAL ELSE 0 END AS RS_OUT_CALL_TOTAL,
      
      -- 발신고객수
      CASE WHEN GUBUN = '1' THEN OUT_CALL_CUST_COUNT ELSE 0 END AS LS_OUT_CALL_CUST_COUNT,      
      CASE WHEN GUBUN = '2' THEN OUT_CALL_CUST_COUNT ELSE 0 END AS RS_OUT_CALL_CUST_COUNT,
      
      -- 발신통화시간
      CASE WHEN GUBUN = '1' THEN OUT_CALL_TIME ELSE 0 END AS LS_OUT_CALL_TIME,      
      CASE WHEN GUBUN = '2' THEN OUT_CALL_TIME ELSE 0 END AS RS_OUT_CALL_TIME,
      
      
      -- 평균통화시간 = 상담시간(인+아웃) / (총수신콜 + 발신콜)
      CASE WHEN GUBUN = '1' THEN AVG_CALL_TIME ELSE 0 END AS LS_AVG_CALL_TIME,      
      CASE WHEN GUBUN = '2' THEN AVG_CALL_TIME ELSE 0 END AS RS_AVG_CALL_TIME,
      
      -- 상담시간 = 인 + 아웃
      CASE WHEN GUBUN = '1' THEN IN_OUT_CALL_TIME ELSE 0 END AS LS_IN_OUT_CALL_TIME,      
      CASE WHEN GUBUN = '2' THEN IN_OUT_CALL_TIME ELSE 0 END AS RS_IN_OUT_CALL_TIME,
      
      -- 약속발생
      CASE WHEN GUBUN = '1' THEN PROMISE_TOTAL ELSE 0 END AS LS_PROMISE_TOTAL,
      CASE WHEN GUBUN = '2' THEN PROMISE_TOTAL ELSE 0 END AS RS_PROMISE_TOTAL,
      
      -- 약속처리
      CASE WHEN GUBUN = '1' THEN PROMISE_END ELSE 0 END AS LS_PROMISE_END,
      CASE WHEN GUBUN = '2' THEN PROMISE_END ELSE 0 END AS RS_PROMISE_END,
      
      -- 처리이행율*
      CASE WHEN GUBUN = '1' THEN PROMISE_RATE ELSE 0 END AS LS_PROMISE_RATE,  
      CASE WHEN GUBUN = '2' THEN PROMISE_RATE ELSE 0 END AS RS_PROMISE_RATE,
      
      -- 고객평가*
      CASE WHEN GUBUN = '1' THEN EVA_CUST_SUM ELSE 0 END AS LS_EVA_CUST_SUM,   
      CASE WHEN GUBUN = '2' THEN EVA_CUST_SUM ELSE 0 END AS RS_EVA_CUST_SUM,
      
      -- 내부모니터링*
      CASE WHEN GUBUN = '1' THEN EVA_EMP_SUM ELSE 0 END AS LS_EVA_EMP_SUM,
      CASE WHEN GUBUN = '2' THEN EVA_EMP_SUM ELSE 0 END AS RS_EVA_EMP_SUM,
      
      -- 전체예약 건수
      CASE WHEN GUBUN = '1' THEN RESERVE_COUNT ELSE 0 END AS LS_RESERVE_COUNT,
      CASE WHEN GUBUN = '2' THEN RESERVE_COUNT ELSE 0 END AS RS_RESERVE_COUNT,
      
      -- 예약전환율*
      CASE WHEN GUBUN = '1' THEN RESERVE_PER ELSE 0 END AS LS_RESERVE_PER,
      CASE WHEN GUBUN = '2' THEN RESERVE_PER ELSE 0 END AS RS_RESERVE_PER,
      
      -- 평균콜수*
      CASE WHEN GUBUN = '1' THEN RESERVE_CALL ELSE 0 END AS LS_RESERVE_CALL,
      CASE WHEN GUBUN = '2' THEN RESERVE_CALL ELSE 0 END AS RS_RESERVE_CALL,
      
      -- 평균통화시간*
      CASE WHEN GUBUN = '1' THEN RESERVE_TIME ELSE 0 END AS LS_RESERVE_TIME,
      CASE WHEN GUBUN = '2' THEN RESERVE_TIME ELSE 0 END AS RS_RESERVE_TIME,
      
      -- 고객대기피크*
      CASE WHEN GUBUN = '1' THEN PEAK_CUST ELSE 0 END AS LS_PEAK_CUST,
      CASE WHEN GUBUN = '2' THEN PEAK_CUST ELSE 0 END AS RS_PEAK_CUST,
      
      -- 동시통화피크*
      CASE WHEN GUBUN = '1' THEN PEAK_CALL ELSE 0 END AS LS_PEAK_CALL,
      CASE WHEN GUBUN = '2' THEN PEAK_CALL ELSE 0 END AS RS_PEAK_CALL,
      
      -- 남여 상담비중 @ 남
      CASE WHEN GUBUN = '1' THEN TYPE_SEX_M ELSE 0 END AS LS_TYPE_SEX_M,
      CASE WHEN GUBUN = '2' THEN TYPE_SEX_M ELSE 0 END AS RS_TYPE_SEX_M,
      
      -- 남여 상담비중 @ 여
      CASE WHEN GUBUN = '1' THEN TYPE_SEX_W ELSE 0 END AS LS_TYPE_SEX_W,
      CASE WHEN GUBUN = '2' THEN TYPE_SEX_W ELSE 0 END AS RS_TYPE_SEX_W,
      
      CASE WHEN GUBUN = '1' THEN TYPE_SEX_SUM ELSE 0 END AS LS_TYPE_SEX_SUM,
      CASE WHEN GUBUN = '2' THEN TYPE_SEX_SUM ELSE 0 END AS RS_TYPE_SEX_SUM,

      -- 연령층 @ 10대
      CASE WHEN GUBUN = '1' THEN TYPE_AGE_10 ELSE 0 END AS LS_TYPE_AGE_10,    
      CASE WHEN GUBUN = '2' THEN TYPE_AGE_10 ELSE 0 END AS RS_TYPE_AGE_10,
      
      -- 연령층 @ 20대
      CASE WHEN GUBUN = '1' THEN TYPE_AGE_20 ELSE 0 END AS LS_TYPE_AGE_20,    
      CASE WHEN GUBUN = '2' THEN TYPE_AGE_20 ELSE 0 END AS RS_TYPE_AGE_20,
      
      -- 연령층 @ 30대
      CASE WHEN GUBUN = '1' THEN TYPE_AGE_30 ELSE 0 END AS LS_TYPE_AGE_30,    
      CASE WHEN GUBUN = '2' THEN TYPE_AGE_30 ELSE 0 END AS RS_TYPE_AGE_30,
      
      -- 연령층 @ 40대
      CASE WHEN GUBUN = '1' THEN TYPE_AGE_40 ELSE 0 END AS LS_TYPE_AGE_40,    
      CASE WHEN GUBUN = '2' THEN TYPE_AGE_40 ELSE 0 END AS RS_TYPE_AGE_40,
      
      -- 연령층 @ 50대
      CASE WHEN GUBUN = '1' THEN TYPE_AGE_50 ELSE 0 END AS LS_TYPE_AGE_50,    
      CASE WHEN GUBUN = '2' THEN TYPE_AGE_50 ELSE 0 END AS RS_TYPE_AGE_50,
      
      -- 연령층 @ 60대
      CASE WHEN GUBUN = '1' THEN TYPE_AGE_60 ELSE 0 END AS LS_TYPE_AGE_60,    
      CASE WHEN GUBUN = '2' THEN TYPE_AGE_60 ELSE 0 END AS RS_TYPE_AGE_60,
      
      CASE WHEN GUBUN = '1' THEN TYPE_AGE_SUM ELSE 0 END AS LS_TYPE_AGE_SUM,    
      CASE WHEN GUBUN = '2' THEN TYPE_AGE_SUM ELSE 0 END AS RS_TYPE_AGE_SUM,
      
      -- 상담분류 @ 고객
      CASE WHEN GUBUN = '1' THEN TYPE_CONSULT_C ELSE 0 END AS LS_TYPE_CONSULT_C,   
      CASE WHEN GUBUN = '2' THEN TYPE_CONSULT_C ELSE 0 END AS RS_TYPE_CONSULT_C,
      
      -- 상담분류 @ 예약
      CASE WHEN GUBUN = '1' THEN TYPE_CONSULT_R ELSE 0 END AS LS_TYPE_CONSULT_R,   
      CASE WHEN GUBUN = '2' THEN TYPE_CONSULT_R ELSE 0 END AS RS_TYPE_CONSULT_R,
      
      -- 상담분류 @ 상품
      CASE WHEN GUBUN = '1' THEN TYPE_CONSULT_G ELSE 0 END AS LS_TYPE_CONSULT_G,   
      CASE WHEN GUBUN = '2' THEN TYPE_CONSULT_G ELSE 0 END AS RS_TYPE_CONSULT_G,
      
      -- 상담분류 @ 일반
      CASE WHEN GUBUN = '1' THEN TYPE_CONSULT_N ELSE 0 END AS LS_TYPE_CONSULT_N,   
      CASE WHEN GUBUN = '2' THEN TYPE_CONSULT_N ELSE 0 END AS RS_TYPE_CONSULT_N,

      CASE WHEN GUBUN = '1' THEN TYPE_CONSULT_SUM ELSE 0 END AS LS_TYPE_CONSULT_SUM,   
      CASE WHEN GUBUN = '2' THEN TYPE_CONSULT_SUM ELSE 0 END AS RS_TYPE_CONSULT_SUM
    FROM 
    (
      SELECT 
        '1' AS GUBUN,
        SUM(TOTAL_CALL) AS TOTAL_CALL,        
        SUM(DAN_CALL) AS DAN_CALL, 
        SUM(REQ_CALL) AS REQ_CALL, 
        SUM(CON_CALL) AS CON_CALL, 
        SUM(AB_CALL) AS AB_CALL,
        SUM(CB_CALL) AS CB_CALL, 
        SUM(SMS_CALL) AS SMS_CALL,
        SUM(IN_CALL_TOTAL) AS IN_CALL_TOTAL,
        SUM(IN_CALL_END) AS IN_CALL_END, 
        SUM(IN_CALL_AB) AS IN_CALL_AB, 
        SUM(IN_CALL_TRF) AS IN_CALL_TRF, 
        CASE WHEN ISNULL(SUM(IN_CALL_TOTAL),0)  = 0 THEN 0 
                     ELSE SUM(IN_CALL_END) * 100  / SUM(IN_CALL_TOTAL) END AS IN_CALL_RATE,   -- 상담응대율
        SUM(IN_CALL_CUST_COUNT) AS IN_CALL_CUST_COUNT, 
        SUM(IN_CALL_TIME) AS IN_CALL_TIME, 
        SUM(OUT_CALL_TOTAL) AS OUT_CALL_TOTAL, 
        SUM(OUT_CALL_CUST_COUNT) AS OUT_CALL_CUST_COUNT, 
        SUM(OUT_CALL_TIME) AS OUT_CALL_TIME, 
        SUM(PROMISE_TOTAL) AS PROMISE_TOTAL, 
        SUM(IN_CALL_TIME) + SUM(OUT_CALL_TIME) AS IN_OUT_CALL_TIME,
        CASE WHEN ISNULL(SUM(IN_CALL_TOTAL)+SUM(OUT_CALL_TOTAL),0)  = 0 THEN 0
                     ELSE (SUM(IN_CALL_TIME) + SUM(OUT_CALL_TIME)) / (SUM(IN_CALL_TOTAL)+SUM(OUT_CALL_TOTAL)) END AS AVG_CALL_TIME,
        SUM(PROMISE_END) AS PROMISE_END, 
        CASE WHEN ISNULL(SUM(PROMISE_TOTAL),0)  = 0 THEN 0 
                     ELSE SUM(PROMISE_END)  * 100 / SUM(PROMISE_TOTAL) END AS PROMISE_RATE,    -- 처리이행율
        ISNULL(SUM(EVA_CUST_COUNT),0) AS EVA_CUST_COUNT,  -- 평가인원
        CASE WHEN ISNULL(SUM(EVA_CUST_COUNT),0) = 0 THEN 0 
                     ELSE ISNULL(SUM(EVA_CUST_SUM),0)  / SUM(EVA_CUST_COUNT) END AS EVA_CUST_SUM,  -- 평균점수
        ISNULL(SUM(EVA_EMP_COUNT),0) AS EVA_EMP_COUNT,  -- 내부코니터링 직원수        
        CASE WHEN ISNULL(SUM(EVA_EMP_COUNT),0) = 0 THEN 0 
                     ELSE SUM(EVA_EMP_SUM) / SUM(EVA_EMP_COUNT) END AS EVA_EMP_SUM, -- 모니터링 평균점수        
        ISNULL(SUM(RESERVE_COUNT),0) AS RESERVE_COUNT,        
        ISNULL(sum(RESERVE_PER) ,0) AS RESERVE_PER,    -- 예약전환율
        ISNULL(AVG(RESERVE_AVG_CALL),0) AS RESERVE_CALL,  -- 평균콜수
        ISNULL(AVG(RESERVE_AVG_TIME),0) AS RESERVE_TIME,  -- 평균통화시간
        MAX(PEAK_CUST) AS PEAK_CUST,  -- 고객대기피크
        MAX(PEAK_CALL) AS PEAK_CALL,  -- 동시통화피크
        
        SUM(TYPE_SEX_M)  * 100 AS TYPE_SEX_M,   --비율로 계산
        SUM(TYPE_SEX_W) * 100 AS TYPE_SEX_W,  
        ISNULL(SUM(TYPE_SEX_M),0) +ISNULL(SUM(TYPE_SEX_W),0) AS TYPE_SEX_SUM,
        
        ISNULL(SUM(TYPE_AGE_10) * 100,0) AS TYPE_AGE_10,  
        ISNULL(SUM(TYPE_AGE_20) * 100,0) AS TYPE_AGE_20, 
        ISNULL(SUM(TYPE_AGE_30) * 100,0) AS TYPE_AGE_30, 
        ISNULL(SUM(TYPE_AGE_40) * 100,0) AS TYPE_AGE_40, 
        ISNULL(SUM(TYPE_AGE_50) * 100,0) AS TYPE_AGE_50,  
        ISNULL(SUM(TYPE_AGE_60) * 100,0) AS TYPE_AGE_60, 
        ISNULL(SUM(TYPE_AGE_10),0) + ISNULL(SUM(TYPE_AGE_20),0) + ISNULL(SUM(TYPE_AGE_30),0) + 
          ISNULL(SUM(TYPE_AGE_40),0) + ISNULL(SUM(TYPE_AGE_50),0) +  ISNULL(SUM(TYPE_AGE_60),0) AS TYPE_AGE_SUM,  
        
        ISNULL(SUM(TYPE_CONSULT_C) * 100,0) AS  TYPE_CONSULT_C,
        ISNULL(SUM(TYPE_CONSULT_R) * 100,0) AS  TYPE_CONSULT_R,
        ISNULL(SUM(TYPE_CONSULT_G) * 100,0) AS  TYPE_CONSULT_G,
        ISNULL(SUM(TYPE_CONSULT_N) * 100,0) AS  TYPE_CONSULT_N,
        ISNULL(SUM(TYPE_CONSULT_C),0)+ISNULL(SUM(TYPE_CONSULT_R),0)+
          ISNULL(SUM(TYPE_CONSULT_G),0) + ISNULL(SUM(TYPE_CONSULT_N),0) AS TYPE_CONSULT_SUM
        
      FROM Sirens.cti.CTI_STAT_TOTAL_REPORT
      WHERE 1=1
       AND ( ISNULL( @TEAM_CODE,'') = '' OR  GROUP_NO = @TEAM_CODE)
	  -- AND (@TEAM_LIST IS NULL OR GROUP_NO IN (SELECT DATA FROM Diablo.dbo.FN_SPLIT(ISNULL(@TEAM_LIST, ''), ',')))
      AND S_DATE BETWEEN replace(@SDATE,'-','') AND replace(@EDATE,'-','')
      
      UNION ALL 

      SELECT 
        '2' AS GUBUN,
        SUM(TOTAL_CALL) AS TOTAL_CALL,        
        SUM(DAN_CALL) AS DAN_CALL, 
        SUM(REQ_CALL) AS REQ_CALL, 
        SUM(CON_CALL) AS CON_CALL, 
        SUM(AB_CALL) AS AB_CALL,
        SUM(CB_CALL) AS CB_CALL, 
        SUM(SMS_CALL) AS SMS_CALL,
        SUM(IN_CALL_TOTAL) AS IN_CALL_TOTAL,
        SUM(IN_CALL_END) AS IN_CALL_END, 
        SUM(IN_CALL_AB) AS IN_CALL_AB, 
        SUM(IN_CALL_TRF) AS IN_CALL_TRF, 
        CASE WHEN ISNULL(SUM(IN_CALL_TOTAL),0)  = 0 THEN 0 
                     ELSE SUM(IN_CALL_END) * 100  / SUM(IN_CALL_TOTAL) END AS IN_CALL_RATE,   -- 상담응대율
        SUM(IN_CALL_CUST_COUNT) AS IN_CALL_CUST_COUNT, 
        SUM(IN_CALL_TIME) AS IN_CALL_TIME, 
        SUM(OUT_CALL_TOTAL) AS OUT_CALL_TOTAL, 
        SUM(OUT_CALL_CUST_COUNT) AS OUT_CALL_CUST_COUNT, 
        SUM(OUT_CALL_TIME) AS OUT_CALL_TIME, 
        SUM(PROMISE_TOTAL) AS PROMISE_TOTAL, 
        SUM(IN_CALL_TIME) + SUM(OUT_CALL_TIME) AS IN_OUT_CALL_TIME,
        CASE WHEN ISNULL(SUM(IN_CALL_TOTAL)+SUM(OUT_CALL_TOTAL),0)  = 0 THEN 0
                     ELSE (SUM(IN_CALL_TIME) + SUM(OUT_CALL_TIME)) / (SUM(IN_CALL_TOTAL)+SUM(OUT_CALL_TOTAL)) END AS AVG_CALL_TIME,
        SUM(PROMISE_END) AS PROMISE_END, 
        CASE WHEN ISNULL(SUM(PROMISE_TOTAL),0)  = 0 THEN 0 
                     ELSE SUM(PROMISE_END) * 100 / SUM(PROMISE_TOTAL) END AS PROMISE_RATE,    -- 처리이행율
        ISNULL(SUM(EVA_CUST_COUNT),0) AS EVA_CUST_COUNT,  -- 평가인원
        CASE WHEN ISNULL(SUM(EVA_CUST_COUNT),0) = 0 THEN 0 
                     ELSE ISNULL(SUM(EVA_CUST_SUM),0) / SUM(EVA_CUST_COUNT) END AS EVA_CUST_SUM,  -- 평균점수
        ISNULL(SUM(EVA_EMP_COUNT),0) AS EVA_EMP_COUNT,  -- 내부코니터링 직원수        
        CASE WHEN ISNULL(SUM(EVA_EMP_COUNT),0) = 0 THEN 0 
                     ELSE SUM(EVA_EMP_SUM) / SUM(EVA_EMP_COUNT) END AS EVA_EMP_SUM, -- 모니터링 평균점수        
        ISNULL(SUM(RESERVE_COUNT),0) AS RESERVE_COUNT,        
        ISNULL(sum(RESERVE_PER) ,0) AS RESERVE_PER,    -- 예약전환율
        ISNULL(AVG(RESERVE_AVG_CALL),0) AS RESERVE_CALL,  -- 평균콜수
        ISNULL(AVG(RESERVE_AVG_TIME),0) AS RESERVE_TIME,  -- 평균통화시간
        MAX(PEAK_CUST) AS PEAK_CUST,  -- 고객대기피크
        MAX(PEAK_CALL) AS PEAK_CALL,  -- 동시통화피크
        
        SUM(TYPE_SEX_M) * 100  AS TYPE_SEX_M,   --비율로 계산
        SUM(TYPE_SEX_W) * 100 AS TYPE_SEX_W,  
        ISNULL(SUM(TYPE_SEX_M),0) +ISNULL(SUM(TYPE_SEX_W),0) AS TYPE_SEX_SUM,
        
        ISNULL(SUM(TYPE_AGE_10) * 100,0) AS TYPE_AGE_10,  
        ISNULL(SUM(TYPE_AGE_20) * 100,0) AS TYPE_AGE_20, 
        ISNULL(SUM(TYPE_AGE_30) * 100,0) AS TYPE_AGE_30, 
        ISNULL(SUM(TYPE_AGE_40) * 100,0) AS TYPE_AGE_40, 
        ISNULL(SUM(TYPE_AGE_50) * 100,0) AS TYPE_AGE_50,  
        ISNULL(SUM(TYPE_AGE_60) * 100,0) AS TYPE_AGE_60, 
        ISNULL(SUM(TYPE_AGE_10),0) + ISNULL(SUM(TYPE_AGE_20),0) + ISNULL(SUM(TYPE_AGE_30),0) + 
          ISNULL(SUM(TYPE_AGE_40),0) + ISNULL(SUM(TYPE_AGE_50),0) +  ISNULL(SUM(TYPE_AGE_60),0) AS TYPE_AGE_SUM,  
        
        ISNULL(SUM(TYPE_CONSULT_C) * 100,0) AS  TYPE_CONSULT_C,
        ISNULL(SUM(TYPE_CONSULT_R) * 100,0) AS  TYPE_CONSULT_R,
        ISNULL(SUM(TYPE_CONSULT_G) * 100,0) AS  TYPE_CONSULT_G,
        ISNULL(SUM(TYPE_CONSULT_N) * 100,0) AS  TYPE_CONSULT_N,
        ISNULL(SUM(TYPE_CONSULT_C),0)+ISNULL(SUM(TYPE_CONSULT_R),0)+
          ISNULL(SUM(TYPE_CONSULT_G),0) + ISNULL(SUM(TYPE_CONSULT_N),0) AS TYPE_CONSULT_SUM
        
      FROM Sirens.cti.CTI_STAT_TOTAL_REPORT
      WHERE 1=1
      AND  (ISNULL( @TEAM_CODE,'') = '' OR  GROUP_NO = @TEAM_CODE)
	  -- AND (@TEAM_LIST IS NULL OR GROUP_NO IN (SELECT DATA FROM Diablo.dbo.FN_SPLIT(ISNULL(@TEAM_LIST, ''), ',')))
      AND S_DATE BETWEEN replace(@BSDATE,'-','') AND replace(@BEDATE,'-','')
    ) AS A
  ) AS B
    
END


SET NOCOUNT OFF
GO
