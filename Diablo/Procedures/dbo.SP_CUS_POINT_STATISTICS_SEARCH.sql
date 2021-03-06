USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ Server					: 211.115.202.203
■ Database					: DIABLO
■ USP_Name					: SP_CUS_POINT_STATISTICS_SEARCH
■ Description				: ERP 사용자 포인트 통계 조회
■ Input Parameter			:                  
		@START_DATE			: 
		@END_DATE			: 
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: EXEC SP_CUS_POINT_STATISTICS_SEARCH @START_DATE='2010-05-01',@END_DATE='2010-05-31'
■ Author					: 박형만  
■ Date						: 2010-05-20
■ Memo						: 
------------------------------------------------------------------------------------------------------------------
■ Change History                   
------------------------------------------------------------------------------------------------------------------
   Date				Author			Description           
------------------------------------------------------------------------------------------------------------------   
   2010-05-20		박형만			최초생성 
   2010-07-22		박형만			회원 테이블과 INNER JOIN - 내역과 맞춤
   2010-09-09		박형만			환불적립 코드 수정 6->7
   2010-09-13		임형민			포인트 사용 시 (-) 부분 수정
   2010-12-09		김성호			회원테이블 분리
   2011-01-20		박형만			여행자테이블로 변경(CUS_CUSTOMER)
   2011-09-08		박형만			관리자 사용취소 금액 - 로 표시 되던거 원상 복구. (이제부턴 데이터에 - 가 들어간다)
   2011-09-08		박형만			사용내역의 적립타입별 금액 구분 
   2012-02-16		박형만			예전내역 조회 , 월별 정렬 추가
   2013-07-23		김성호			cus_customer 테이블 삭제로 인해 해당 테이블 조인형태를 left join 으로 변경 
   2013-12-02		박형만			OK캐쉬백 사용(7) 추가 
   2019-01-08		박형만			포인트 구매실적129 회원가입378 로 수정 , vip 추가는 관리자 적립으로, 추천인 적립 항목추가
   2020-05-11		김성호			포인트 구매실적1259 회원가입378 로 수정 (이벤트 적립 = 5 추가) 
   2020-06-03		김성호			포인트 적립 중 관리자적립에 이벤트적립 포함으로 수정 (이벤트 적립 = 5
   2021-06-11		김성호			FN_RES_GET_CUS_POINT_HISTORY_ACC_PRICE 함수 제외 쿼리 재 작성 (2013년 6월 예외처리 제거)
   2021-08-19		김성호			이벤트적립(acc_use_type=5 구매실적에서 회원가입으로 변경)
   2021-12-13		전형철(ADC)		쿼리 분리
================================================================================================================*/ 
CREATE PROC [dbo].[SP_CUS_POINT_STATISTICS_SEARCH]
(
	@START_DATE VARCHAR(10),		
	@END_DATE  VARCHAR(10)
)
AS
	BEGIN
		SET NOCOUNT ON 
--DECLARE @START_DATE VARCHAR(10),		
--@END_DATE  VARCHAR(10)
--SET @START_DATE = '2012-01-01'
--SET @END_DATE = '2012-01-31' 
		
		SET @END_DATE = CONVERT(VARCHAR(10),DATEADD(DD,1, CONVERT(DATETIME,@END_DATE)),121);  -- 조회기간 +1일 

		SELECT CONVERT(VARCHAR(7),CP.NEW_DATE,121) AS MONTH_DATE, 
			SUM(CASE WHEN POINT_TYPE = 1 AND ACC_USE_TYPE = 1 THEN POINT_PRICE ELSE 0 END ) AS ACC_POINT1,--일반적립 1 ?? 컨텐츠적립,이벤트적립
			SUM(CASE WHEN POINT_TYPE = 1 AND ACC_USE_TYPE IN (2,5,9) THEN POINT_PRICE ELSE 0 END ) AS ACC_POINT2,--관리자적립 2,이벤트적립 5, vip 추가 9
			SUM(CASE WHEN POINT_TYPE = 1 AND ACC_USE_TYPE = 3 THEN POINT_PRICE ELSE 0 END ) AS ACC_POINT3,--회원가입 3 
			SUM(CASE WHEN POINT_TYPE = 1 AND ACC_USE_TYPE IN (7,8) THEN POINT_PRICE ELSE 0 END ) AS ACC_POINT4,--추천인,피추천인 7,8 
			SUM(CASE WHEN POINT_TYPE = 1 THEN POINT_PRICE ELSE 0 END ) AS ACC_TOTAL_POINT , 
			
			SUM(CASE WHEN POINT_TYPE = 2 AND ACC_USE_TYPE = 1 THEN POINT_PRICE ELSE 0 END ) AS USE_POINT1,--일반사용 1 
			SUM(CASE WHEN POINT_TYPE = 2 AND ACC_USE_TYPE = 3 THEN POINT_PRICE ELSE 0 END ) AS USE_POINT2 ,--관리자차감 3 
			SUM(CASE WHEN POINT_TYPE = 2 AND ACC_USE_TYPE = 7 THEN POINT_PRICE ELSE 0 END ) AS USE_POINT3 ,--OK캐쉬백사용 7
			SUM(CASE WHEN POINT_TYPE = 2 AND ACC_USE_TYPE = 6 THEN POINT_PRICE ELSE 0 END ) AS USE_POINT4,--사용취소6
			SUM(CASE WHEN POINT_TYPE = 2 AND ACC_USE_TYPE = 2 THEN POINT_PRICE ELSE 0 END ) AS USE_POINT5,--기간만료소멸 2
			SUM(CASE WHEN POINT_TYPE = 2 AND ACC_USE_TYPE = 5 THEN POINT_PRICE ELSE 0 END ) AS USE_POINT6, --탈퇴소멸 5
			
			SUM(CASE WHEN CP.POINT_TYPE = 2 THEN CP.POINT_PRICE ELSE 0 END ) AS USE_TOTAL_POINT , 
			SUM(CASE WHEN CP.POINT_TYPE = 1 AND CP.ACC_USE_TYPE = 6 THEN CP.POINT_PRICE ELSE 0 END ) AS TRF_POINT--양도(적립만)
		INTO #TEMP_A
		FROM dbo.CUS_POINT  AS CP WITH(NOLOCK)
		WHERE CP.NEW_DATE >= CONVERT(DATETIME,@START_DATE)
		AND  CP.NEW_DATE < CONVERT(DATETIME,@END_DATE)
		GROUP BY CONVERT(VARCHAR(7),CP.NEW_DATE,121);

		SELECT CONVERT(VARCHAR(7),CP.NEW_DATE,121) AS MONTH_DATE,
			SUM(CASE WHEN CP.POINT_TYPE = 2 AND CP.ACC_USE_TYPE = 1 AND CPH.ACC_TYPE IN (1,2,9) THEN CPH.POINT_PRICE ELSE 0 END ) AS USE_POINT1_1,--일반사용 구매실적 1 
			SUM(CASE WHEN CP.POINT_TYPE = 2 AND CP.ACC_USE_TYPE = 1 AND CPH.ACC_TYPE IN (3,5,7,8) THEN CPH.POINT_PRICE ELSE 0 END ) AS USE_POINT1_2,--일반사용 회원가입 1 
			
			SUM(CASE WHEN CP.POINT_TYPE = 2 AND CP.ACC_USE_TYPE = 3 AND CPH.ACC_TYPE IN (1,2,9) THEN CPH.POINT_PRICE ELSE 0 END ) AS USE_POINT2_1 ,--관리자차감 3 
			SUM(CASE WHEN CP.POINT_TYPE = 2 AND CP.ACC_USE_TYPE = 3 AND CPH.ACC_TYPE IN (3,5,7,8) THEN CPH.POINT_PRICE ELSE 0 END ) AS USE_POINT2_2 ,--관리자차감 3 

			SUM(CASE WHEN CP.POINT_TYPE = 2 AND CP.ACC_USE_TYPE = 7 AND CPH.ACC_TYPE IN (1,2,9) THEN CPH.POINT_PRICE ELSE 0 END ) AS USE_POINT3_1 ,--OK캐쉬백사용 7
			SUM(CASE WHEN CP.POINT_TYPE = 2 AND CP.ACC_USE_TYPE = 7 AND CPH.ACC_TYPE IN (3,5,7,8) THEN CPH.POINT_PRICE ELSE 0 END ) AS USE_POINT3_2 ,--OK캐쉬백사용 7
			
			SUM(CASE WHEN CP.POINT_TYPE = 2 AND CP.ACC_USE_TYPE = 6 AND CPH.ACC_TYPE IN (1,2,9) THEN CPH.POINT_PRICE ELSE 0 END ) AS USE_POINT4_1,--사용취소6
			SUM(CASE WHEN CP.POINT_TYPE = 2 AND CP.ACC_USE_TYPE = 6 AND CPH.ACC_TYPE IN (3,5,7,8) THEN CPH.POINT_PRICE ELSE 0 END ) AS USE_POINT4_2,--사용취소6
			
			SUM(CASE WHEN CP.POINT_TYPE = 2 AND CP.ACC_USE_TYPE = 2 AND CPH.ACC_TYPE IN (1,2,9) THEN CPH.POINT_PRICE ELSE 0 END ) AS USE_POINT5_1,--기간만료소멸 2
			SUM(CASE WHEN CP.POINT_TYPE = 2 AND CP.ACC_USE_TYPE = 2 AND CPH.ACC_TYPE IN (3,5,7,8) THEN CPH.POINT_PRICE ELSE 0 END ) AS USE_POINT5_2,--기간만료
			
			SUM(CASE WHEN CP.POINT_TYPE = 2 AND CP.ACC_USE_TYPE = 5 AND CPH.ACC_TYPE IN (1,2,9) THEN CPH.POINT_PRICE ELSE 0 END ) AS USE_POINT6_1,--탈퇴소멸 5
			SUM(CASE WHEN CP.POINT_TYPE = 2 AND CP.ACC_USE_TYPE = 5 AND CPH.ACC_TYPE IN (3,5,7,8) THEN CPH.POINT_PRICE ELSE 0 END ) AS USE_POINT6_2--탈퇴소멸 5
		INTO #TEMP_B
		FROM dbo.CUS_POINT  AS CP WITH(NOLOCK)
		INNER JOIN dbo.CUS_POINT_HISTORY CPH WITH(NOLOCK) ON CP.POINT_NO = CPH.POINT_NO
		WHERE CP.NEW_DATE >= CONVERT(DATETIME,@START_DATE)
		AND  CP.NEW_DATE < CONVERT(DATETIME,@END_DATE)
		GROUP BY CONVERT(VARCHAR(7),CP.NEW_DATE,121);

		SELECT A.MONTH_DATE, A.ACC_POINT1, A.ACC_POINT2, A.ACC_POINT3, A.ACC_POINT4, A.ACC_TOTAL_POINT, A.USE_POINT1, A.USE_POINT2, A.USE_POINT3, A.USE_POINT4, A.USE_POINT5, A.USE_POINT6,
			B.USE_POINT1_1, B.USE_POINT1_2, B.USE_POINT2_1, B.USE_POINT2_2, B.USE_POINT3_1, B.USE_POINT3_2, B.USE_POINT4_1, B.USE_POINT4_2, B.USE_POINT5_1, B.USE_POINT5_2, B.USE_POINT6_1, B.USE_POINT6_2,
			A.USE_TOTAL_POINT, A.TRF_POINT
		FROM #TEMP_A A
		INNER JOIN #TEMP_B B ON A.MONTH_DATE = B.MONTH_DATE
		ORDER BY A.MONTH_DATE;
		
	END

GO
