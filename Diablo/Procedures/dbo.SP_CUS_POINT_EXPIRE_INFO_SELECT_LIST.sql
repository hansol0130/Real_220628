USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_CUS_POINT_EXPIRE_INFO_SELECT_LIST
- 기 능 : 포인트 소멸 예정안내 대상자 조회
====================================================================================
	참고내용
====================================================================================
- PointExpireSendMail.exe 포인트 소멸 안내 메일 스케쥴 프로그램 에서 사용
- 예제 
 EXEC SP_CUS_POINT_EXPIRE_INFO_SELECT_LIST  '2012-06-10'
 EXEC SP_CUS_POINT_EXPIRE_INFO_SELECT_LIST  '2018-09-30'

====================================================================================
	변경내역
====================================================================================
- 2010-05-13 박형만 신규 작성 
- 2010-06-03 박형만 암호화 적용
- 2010-12-08 김성호 회원테이블 분리
- 2013-06-19 박형만 12,6,3,1 개월 남은 포인트 안내 - 오운 차장님 요청 
- 2018-09-30 박형만 알림톡 관련 알림톡만 3,1 개월만 나가도록 - 김연옥 차장님 요청 
===================================================================================*/
CREATE PROC [dbo].[SP_CUS_POINT_EXPIRE_INFO_SELECT_LIST]
	@EXE_DATE VARCHAR(10)
AS 
BEGIN 

SET NOCOUNT ON 


--DECLARE @EXE_DATE VARCHAR(10) 
--SET @EXE_DATE ='2018-10-01'

--DECLARE @EXP_DATE_12M DATETIME  
--DECLARE @EXP_DATE_6M DATETIME
DECLARE @EXP_DATE_3M DATETIME
DECLARE @EXP_DATE_1M DATETIME

--SET @EXP_DATE_12M = DATEADD(M,12, CONVERT(DATETIME,@EXE_DATE))
--SET @EXP_DATE_6M = DATEADD(M,6, CONVERT(DATETIME,@EXE_DATE))
SET @EXP_DATE_3M = DATEADD(M,3, CONVERT(DATETIME,@EXE_DATE))
SET @EXP_DATE_1M = DATEADD(M,1, CONVERT(DATETIME,@EXE_DATE));


--잔여 포인트 먼저 구하기 
WITH LIST AS ( 

	SELECT 
		CUS_NO,SUM(POINT_PRICE) AS POINT_PRICE ,START_DATE , END_DATE , COUNT(*) AS POINT_CNT
	FROM ( 
		SELECT  CP.POINT_PRICE - ISNULL(SUM(CPH.POINT_PRICE),0) AS POINT_PRICE ,
			CONVERT(DATETIME,CONVERT(VARCHAR(10),START_DATE,121)) AS START_DATE ,
			CONVERT(DATETIME,CONVERT(VARCHAR(10),END_DATE,121)) AS END_DATE ,
			CP.CUS_NO 
		FROM CUS_POINT AS CP  WITH(NOLOCK)
			LEFT JOIN CUS_POINT_HISTORY AS CPH WITH(NOLOCK)
				ON CP.POINT_NO = CPH.ACC_POINT_NO 
		WHERE CP.POINT_TYPE = 1  --적립
		--AND CC.RCV_EMAIL_YN = 'Y' -- 이메일 수신 동의한 사람만 
		AND 
		(	
		--	--CP.END_DATE BETWEEN  @EXP_DATE_12M AND  CONVERT(DATETIME ,CONVERT(VARCHAR(10),@EXP_DATE_12M,121) + ' 23:59:59')  --만료예정 12 개월인것
		--	--OR
		--	--CP.END_DATE BETWEEN  @EXP_DATE_6M AND  CONVERT(DATETIME ,CONVERT(VARCHAR(10),@EXP_DATE_6M,121) + ' 23:59:59')  --만료예정 6 개월인것
		--	--OR
			CP.END_DATE BETWEEN  @EXP_DATE_3M AND  CONVERT(DATETIME ,CONVERT(VARCHAR(10),@EXP_DATE_3M,121) + ' 23:59:59')  --만료예정 3 개월인것
			OR
			CP.END_DATE BETWEEN  @EXP_DATE_1M AND  CONVERT(DATETIME ,CONVERT(VARCHAR(10),@EXP_DATE_1M,121) + ' 23:59:59')  --만료예정 1 개월인것
		)
		--AND CP.CUS_NO = 3326910 
		--AND CP.END_DATE < '2018-10-01'
		GROUP BY  CP.POINT_NO, CP.POINT_PRICE , CP.CUS_NO , 
			CONVERT(VARCHAR(10),START_DATE,121), CONVERT(VARCHAR(10),END_DATE,121)  -- 포인트별로  GROUP BY 
	) T 
	GROUP BY CUS_NO , START_DATE , END_DATE  -- 고객,만료기간별로 GROUP BY 
	--HAVING COUNT(*) > 1 
) 

SELECT 
A.* 
, ISNULL(CMS.CUS_NAME,CC.CUS_NAME) AS CUS_NAME
, ISNULL(CMS.EMAIL,CC.EMAIL) AS EMAIL 

, ISNULL(CMS.NOR_TEL1,CC.NOR_TEL1) AS NOR_TEL1
, ISNULL(CMS.NOR_TEL2,CC.NOR_TEL2) AS NOR_TEL2
, ISNULL(CMS.NOR_TEL3,CC.NOR_TEL3) AS NOR_TEL3

, CASE WHEN A.END_DATE BETWEEN  @EXP_DATE_1M AND  CONVERT(DATETIME ,CONVERT(VARCHAR(10),@EXP_DATE_1M,121) + ' 23:59:59') THEN 1 
		WHEN A.END_DATE BETWEEN  @EXP_DATE_3M AND  CONVERT(DATETIME ,CONVERT(VARCHAR(10),@EXP_DATE_3M,121) + ' 23:59:59') THEN 3 END AS REMAIN_MONTH 

FROM LIST A 
	INNER JOIN CUS_MEMBER AS CC WITH(NOLOCK)
		ON A.CUS_NO = CC.CUS_NO 
	LEFT JOIN CUS_MEMBER_SLEEP AS CMS WITH(NOLOCK)
		ON CC.CUS_NO = CMS.CUS_NO 
WHERE POINT_PRICE > 0 
ORDER BY A.CUS_NO , A.END_DATE ASC  



/*
1차 
SELECT CUS_NO, SUM(POINT_PRICE) AS POINT_PRICE ,CUS_NAME,EMAIL, START_DATE,END_DATE
FROM ( 
	SELECT CP.POINT_NO , CP.POINT_PRICE - ISNULL(SUM(CPH.POINT_PRICE),0) AS POINT_PRICE 
	, CONVERT(DATETIME,CONVERT(VARCHAR(10),START_DATE,121)) AS START_DATE 
	, CONVERT(DATETIME,CONVERT(VARCHAR(10),END_DATE,121)) AS END_DATE 
	, CP.CUS_NO ,CC.CUS_NAME
	, CC.EMAIL
	FROM CUS_POINT as CP WITH(NOLOCK)
		INNER JOIN CUS_MEMBER AS CC WITH(NOLOCK)
			ON CP.CUS_NO = CC.CUS_NO 
		LEFT JOIN CUS_POINT_HISTORY AS CPH WITH(NOLOCK)
			ON CP.POINT_NO = CPH.ACC_POINT_NO 
	WHERE CP.POINT_TYPE = 1  --적립
	AND CC.RCV_EMAIL_YN = 'Y' -- 이메일 수신 동의한 사람만 
	
	AND CP.END_DATE <= DATEADD(DD,30,@EXE_DATE) --만료예정인것 모두
	AND CP.END_DATE <= DATEADD(DD,30,@EXE_DATE) --만료예정인것 모두

	GROUP BY  CP.POINT_NO , CP.POINT_PRICE , CP.CUS_NO , CONVERT(VARCHAR(10),START_DATE,121)
			, CONVERT(VARCHAR(10),END_DATE,121) , CC.EMAIL , CC.CUS_NAME 
) TBL2 
WHERE POINT_PRICE > 0 
GROUP BY START_DATE,END_DATE,CUS_NO,CUS_NAME,EMAIL


2차 

SET NOCOUNT ON 
SELECT CUS_NO, SUM(POINT_PRICE) AS POINT_PRICE ,CUS_NAME,EMAIL, START_DATE,END_DATE
FROM ( 
	SELECT CP.POINT_NO , CP.POINT_PRICE - ISNULL(SUM(CPH.POINT_PRICE),0) AS POINT_PRICE 
	, CONVERT(DATETIME,CONVERT(VARCHAR(10),START_DATE,121)) AS START_DATE 
	, CONVERT(DATETIME,CONVERT(VARCHAR(10),END_DATE,121)) AS END_DATE 
	, CP.CUS_NO ,CC.CUS_NAME
	, CC.EMAIL
	FROM CUS_POINT as CP WITH(NOLOCK)
		INNER JOIN CUS_MEMBER AS CC WITH(NOLOCK)
			ON CP.CUS_NO = CC.CUS_NO 
		LEFT JOIN CUS_POINT_HISTORY AS CPH WITH(NOLOCK)
			ON CP.POINT_NO = CPH.ACC_POINT_NO 
	WHERE CP.POINT_TYPE = 1  --적립
	--AND CC.RCV_EMAIL_YN = 'Y' -- 이메일 수신 동의한 사람만 
	AND 
	(	
		CP.END_DATE BETWEEN  @EXP_DATE_12M AND  CONVERT(DATETIME ,CONVERT(VARCHAR(10),@EXP_DATE_12M,121) + ' 23:59:59')  --만료예정 12,6,3,1 개월인것
		OR
		CP.END_DATE BETWEEN  @EXP_DATE_6M AND  CONVERT(DATETIME ,CONVERT(VARCHAR(10),@EXP_DATE_6M,121) + ' 23:59:59')  --만료예정 12,6,3,1 개월인것
		OR
		CP.END_DATE BETWEEN  @EXP_DATE_3M AND  CONVERT(DATETIME ,CONVERT(VARCHAR(10),@EXP_DATE_3M,121) + ' 23:59:59')  --만료예정 12,6,3,1 개월인것
		OR
		CP.END_DATE BETWEEN  @EXP_DATE_1M AND  CONVERT(DATETIME ,CONVERT(VARCHAR(10),@EXP_DATE_1M,121) + ' 23:59:59')  --만료예정 12,6,3,1 개월인것
	)
	GROUP BY  CP.POINT_NO , CP.POINT_PRICE , CP.CUS_NO , CONVERT(VARCHAR(10),START_DATE,121)
			, CONVERT(VARCHAR(10),END_DATE,121) , CC.EMAIL , CC.CUS_NAME 
) TBL2 
WHERE POINT_PRICE > 0 
GROUP BY START_DATE,END_DATE,CUS_NO,CUS_NAME,EMAIL
ORDER BY END_DATE ASC , CUS_NO 
*/

END 

GO