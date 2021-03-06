USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_WORKTIME_STAT_SELECT
■ DESCRIPTION				: 상담업무시간분석
■ INPUT PARAMETER			: 
	@TEAM_CODE				: 부서코드
	@EMP_CODE				: 사용안함 ???
	@SDATE					: 조회시작일자
	@EDATE					: 조회종료일자
	@GUBUN					: 검색 구분 코드 (M: 월, D: 일, H: 시간)
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_WORKTIME_STAT_SELECT

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-26		홍영택			최초생성
   2015-01-30		박노민			부서 선택 시 하위 부서 동시 조회 추가
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_WORKTIME_STAT_SELECT]
@TEAM_CODE varchar(10), 
@EMP_CODE varchar(10), 
@SDATE varchar(10), 
@EDATE varchar(10), 
@GUBUN varchar(10)

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


  IF @GUBUN IS NULL OR @GUBUN = ''
		SET @GUBUN = 'M ';


    SELECT
  CASE WHEN GROUPING(GUBUN)  = '1' THEN ' 전체' ELSE GUBUN END AS TITLE,
  SUM(IN_WORK_TIME) AS SUM_IN_WORK_TIME, 
  SUM(OUT_WORK_TIME) AS SUM_OUT_WORK_TIME ,
  SUM(IN_CALL_TIME) AS SUM_IN_CALL_TIME ,
  SUM(OUT_CALL_TIME)  AS SUM_OUT_CALL_TIME , 
  SUM(IN_CALL_COUNT) AS  SUM_IN_CALL_COUNT, 
  SUM(IN_CON_COUNT) AS  SUM_IN_CON_COUNT ,
  SUM(IN_AB_COUNT) AS  SUM_IN_AB_COUNT, 
  SUM(IN_CUST_COUNT) AS SUM_IN_CUST_COUNT , 
  SUM(OUT_CALL_COUNT) AS  SUM_OUT_CALL_COUNT , 
  SUM(OUT_CUST_COUNT) AS  SUM_OUT_CUST_COUNT,
  SUM(PICKUP_COUNT) AS  SUM_PICKUP_COUNT , 
  SUM(TRANSFER_COUNT ) AS  SUM_TRANSFER_COUNT , 
  SUM(RESERVE_COUNT) AS  SUM_RESERVE_COUNT,
  
  AVG(IN_WORK_TIME) AS AVG_IN_WORK_TIME, 
  AVG(OUT_WORK_TIME) AS AVG_OUT_WORK_TIME ,
  AVG(IN_CALL_TIME) AS AVG_IN_CALL_TIME ,
  AVG(OUT_CALL_TIME) AS AVG_OUT_CALL_TIME , 
  AVG(IN_CALL_COUNT) AS AVG_IN_CALL_COUNT, 
  AVG(IN_CON_COUNT) AS AVG_IN_CON_COUNT ,
  AVG(IN_AB_COUNT) AS AVG_IN_AB_COUNT, 
  AVG(IN_CUST_COUNT) AS AVG_IN_CUST_COUNT , 
  AVG(OUT_CALL_COUNT) AS AVG_OUT_CALL_COUNT , 
  AVG(OUT_CUST_COUNT) AS AVG_OUT_CUST_COUNT,
  AVG(PICKUP_COUNT) AS AVG_PICKUP_COUNT , 
  AVG(TRANSFER_COUNT ) AS AVG_TRANSFER_COUNT , 
  AVG(RESERVE_COUNT) AS AVG_RESERVE_COUNT 
 FROM
 (
  SELECT 
      CASE WHEN @GUBUN = 'M' THEN ISNULL(CONVERT(VARCHAR(6),S_DATE,120),'')
                WHEN  @GUBUN = 'D' THEN ISNULL(CONVERT(VARCHAR(8),S_DATE,120),'')
                --ELSE ISNULL(CONVERT(VARCHAR(2), S_HOUR,108),'') END AS GUBUN,
                ELSE ISNULL(CONVERT(VARCHAR(6), S_DATE,120),'') END AS GUBUN,
      CASE WHEN ISNULL( @TEAM_CODE,'') = ''  THEN TEAM_CODE 
                ELSE  EMP_CODE END AS TEAM_CODE,
      CASE WHEN ISNULL( @TEAM_CODE,'') = ''  THEN TEAM_NAME
                ELSE  EMP_NAME END AS TEAM_NAME,  
      SUM(IN_WORK_TIME) AS IN_WORK_TIME, 
      SUM(OUT_WORK_TIME) AS OUT_WORK_TIME ,
      SUM(IN_CALL_TIME) AS IN_CALL_TIME ,
      SUM(OUT_CALL_TIME) AS OUT_CALL_TIME , 
      SUM(IN_CALL_COUNT) AS IN_CALL_COUNT, 
      SUM(IN_CON_COUNT) AS IN_CON_COUNT ,
      SUM(IN_AB_COUNT) AS IN_AB_COUNT, 
      SUM(IN_CUST_COUNT) AS IN_CUST_COUNT , 
      SUM(OUT_CALL_COUNT) AS OUT_CALL_COUNT , 
      SUM(OUT_CUST_COUNT) AS OUT_CUST_COUNT,
      SUM(PICKUP_COUNT) AS PICKUP_COUNT , 
      SUM(TRANSFER_COUNT ) AS TRANSFER_COUNT , 
      SUM(RESERVE_COUNT) AS RESERVE_COUNT 
  FROM Sirens.cti.CTI_STAT_WORKTIME
  WHERE 1=1
  AND S_DATE BETWEEN replace(@SDATE,'-','') AND replace(@EDATE,'-','')
   AND  (ISNULL( @TEAM_CODE,'') = '' OR  TEAM_CODE = @TEAM_CODE)
  -- AND (@TEAM_LIST IS NULL OR TEAM_CODE IN (SELECT DATA FROM Diablo.dbo.FN_SPLIT(ISNULL(@TEAM_LIST, ''), ',')))
  GROUP BY S_DATE, TEAM_CODE, TEAM_NAME, EMP_CODE, EMP_NAME
)  A
WHERE 1=1
GROUP BY A.GUBUN WITH ROLLUP
ORDER BY A.GUBUN
  
END


SET NOCOUNT OFF
GO
