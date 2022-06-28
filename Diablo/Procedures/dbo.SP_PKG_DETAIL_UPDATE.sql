USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================    
■ Server			: 222.122.198.100
■ Database			: DIABLO
■ USP_Name			: SP_PKG_DETAIL_UPDATE
■ Description		: 행사 수정
■ Input Parameter	: 
  @PRO_CODE			: 상품코드
  @START			: 복사시작일
  @END				: 복사종료일
  @WEEK_DAY_TYPE	: 요일
  @UPDATE_TYPE		: 복사타입
  @EMP_CODE			: 생성인코드
■ Output Parameter	: 
■ Output Value		: 
■ Exec				: 
■ Author			: 김성호
■ Date				: 2009-04-13
■ Memo				: 
------------------------------------------------------------------------------------------------------------------    
■ Change History                       
------------------------------------------------------------------------------------------------------------------    
 Date   Author   Description               
------------------------------------------------------------------------------------------------------------------    
 2009-04-13	김성호	최초생성
 2009-04-13			PK 오류발생 수정
 2009-09-17			복사 조건 추가
 2010-04-27			항공정보 복사 부분 추가 (SEAT_CODE UPDATE)
 2010-12-16	임형민	'가격', '호텔' 분리.
 2011-09-20	김현진	'상품세부항목' 세분화
 2011-10-21	김성호	예약이 존재하면 일괄수정 금지
 2011-10-28	김성호	예약이 존재하면 가격, 호텔 만 수정금지 & 업데이트 방식 변경
 2012-01-16	박형만	UPDATE_TYPE 특별약관 항목추가
 2012-03-19	김성호	전체수정 기능 추가
 2013-05-08	김성호	상세항목 전체 선택 시 수정 항목에 MEET_COUNTER 추가
 2013-10-29	김성호	상세항목 전체 선택 시 수정 항복에 TC_YN 추가 (인솔자)
 2014-06-25	김성호	총액표시제에 따른 스키마 수정 반영 6/30 PKG_PRICE_DETAIL 컬럼복사,기존공동경비삭제
 2014-07-04	김성호	유류할증료, 공동경비 별로 항목으로 체크,  항공UPDATE_TYPE 위치 수정 7->10
 2014-07-25	김성호	총액표시제에 따른 항목 추가
 2015-06-25	김성호	일정표만 복사 시 가격정보에 첫번째 일정 자동 물리도록 수정
 2015-09-03	김성호	인원에서 허수 제외
 2016-05-03	김성호	전체마스터 단위에서 항공 수정 시 대상 항공정보와 동일한 항공일 경우만 수정되도록 변경
 2016-10-11	김성호	항공복사 코드 정리
 2017-07-07	김성호	쇼핑, 옵션 전체상품 수정 오류 수정
 2017-08-24	김성호	일정표 복사 시 가격 및 일정이 하나씩 이면 매칭
 2017-12-22	김성호	사용일정표만 복사되도록 수정, 170824사항 주석
 2018-01-05	정지용	첫만남, 미팅카운터 선택항목 수정 추가
 2018-01-08	김성호	가격이 2개 이상 상품 일정표 중복 복사 오류 수정
 2018-01-16	김성호	일정표 복사 시 변경 일정표 가격에 물리도록 수정
 2019-02-19	김성호	서버 문제시 일시 정지 기능 추가 -> UPDATE COD_PUBLIC SET PUB_VALUE = 'Y' WHERE PUB_TYPE = 'PKG.COPY.CHECK' AND PUB_CODE = '1'
 2019-03-07	박형만	네이버 관련 행사 컬럼 추가 
 2019-04-24	박형만	좌석등급추가 , 행사요약설명(네이버 핵심포인트) 추가 
 2019-05-16	이명훈	상품상세 셀링포인트 추가(PKG_DETAIL_SELL_POINT)
 2019-08-19 김남훈   네이버 사용자 정의 , 이동수단 추가
 2019-12-20 박형만   상품수정히스토리에 넣기(네이버용)
 2020-02-13 김영민   SHOW_YN 제외
 2020-03-24	김성호	트리거 예외처리 추가 (트리거에 CONTEXT_INFO() 체크하여 트리거 무시하는 로직 추가 필요)
 2021-03-04	오준혁	네이버 연동 관련 제거	
 2021-12-19	김성호	트립토파즈 연동 등록 추가
================================================================================================================*/     
CREATE PROCEDURE [dbo].[SP_PKG_DETAIL_UPDATE]
(    
	@PRO_CODE		VARCHAR(20),
	@START			VARCHAR(10),
	@END			VARCHAR(10),
	@WEEK_DAY_TYPE	VARCHAR(7),
	@UPDATE_TYPE	VARCHAR(50),
	@EMP_CODE		CHAR(7),
	@ALL_PRODUCT_YN	CHAR(1)			-- BIT_CODE 무시 여부
)    
AS    
BEGIN 
	
	-- 트리거 동작 제외
	SET CONTEXT_INFO 0x21884680;
	
	   
	SET NOCOUNT ON;
	
	DECLARE @NEW_MASTER_CODE VARCHAR(10), @START_DATE DATETIME, @END_DATE DATETIME, @NEW_PRO_CODE VARCHAR(20), @BIT_CODE VARCHAR(10)    
	SET @START_DATE = CONVERT(DATETIME, @START);
	SET @END_DATE = CONVERT(DATETIME, @END);

	SELECT @BIT_CODE = SUBSTRING(A.PRO_CODE, (CHARINDEX('-', A.PRO_CODE) + 7), 10), @NEW_MASTER_CODE = A.MASTER_CODE    
	FROM PKG_DETAIL A WITH(NOLOCK) 
	WHERE A.PRO_CODE = @PRO_CODE

	-- 임시테이블 선언    
	CREATE TABLE #MSG_TEMP    
	(    
		[ERROR_SEQ] INT IDENTITY, [ERROR_DATE] DATETIME,    
		[ERROR_TYPE] INT,   [ERROR_MESSAGE] NVARCHAR(2048)    
	)    

	-- 서버 부하 발생 시 동작 일시 중지용
	IF ISNULL((SELECT PUB_VALUE FROM COD_PUBLIC A WITH(NOLOCK) WHERE A.PUB_TYPE = 'PKG.COPY.CHECK' AND A.PUB_CODE = '1'), 'Y') = 'Y'
	BEGIN 

		--항공관련변수 2010.04.27    
		DECLARE @SEAT_CODE INT, @DEP_TRANS_CODE CHAR(2), @DEP_TRANS_NUMBER CHAR(4), @ARR_TRANS_CODE CHAR(2), @ARR_TRANS_NUMBER CHAR(4)
		DECLARE @DIFF_DAY INT = -1, @DEP_DIFF INT = -1, @ARR_DIFF INT = -1	--기존행사의날짜차이

		--기존행사가 항공일때,항공수정 체크시만  2010.04.27    
		IF (( SELECT TRANSFER_TYPE FROM PKG_DETAIL WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE ) = 1     
			AND SUBSTRING(@UPDATE_TYPE, 11, 1) = '1' )     
		BEGIN    
			SET @SEAT_CODE = (SELECT TOP 1 SEAT_CODE FROM PKG_DETAIL WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE )    

			IF EXISTS(SELECT 1 FROM PRO_TRANS_SEAT WITH(NOLOCK) WHERE SEAT_CODE = @SEAT_CODE)
			BEGIN    
				SELECT    
					@DIFF_DAY = DATEDIFF(DAY, DEP_DEP_DATE, ARR_DEP_DATE),    
					@DEP_DIFF = DATEDIFF(DAY, DEP_DEP_DATE, DEP_ARR_DATE),    
					@ARR_DIFF = DATEDIFF(DAY, DEP_DEP_DATE, ARR_ARR_DATE),
					@DEP_TRANS_CODE = DEP_TRANS_CODE,
					@DEP_TRANS_NUMBER = DEP_TRANS_NUMBER,
					@ARR_TRANS_CODE = ARR_TRANS_CODE,
					@ARR_TRANS_NUMBER = ARR_TRANS_NUMBER    
				FROM PRO_TRANS_SEAT WITH(NOLOCK)
				WHERE SEAT_CODE = @SEAT_CODE    
			END  
		END    

		-- 선택 기간동안    
		WHILE (@END_DATE >= @START_DATE)    
		BEGIN    
			-- 요일이 일치하면    
			IF '1' = SUBSTRING(@WEEK_DAY_TYPE, DATEPART(WEEKDAY, @START_DATE), 1)    
			BEGIN
		
				-- 행사코드 생성
				IF @ALL_PRODUCT_YN = 'Y'
				BEGIN
					SET @NEW_PRO_CODE = (@NEW_MASTER_CODE + '-' + SUBSTRING(CONVERT(VARCHAR(10), @START_DATE, 112), 3, 10) + '%')
				END
				ELSE
				BEGIN
					SET @NEW_PRO_CODE = (@NEW_MASTER_CODE + '-' + SUBSTRING(CONVERT(VARCHAR(10), @START_DATE, 112), 3, 10) + ISNULL(@BIT_CODE, ''))
				END

				-- 기준행사와 다르고 존재하면    
				IF EXISTS(SELECT 1 FROM PKG_DETAIL WHERE PRO_CODE LIKE @NEW_PRO_CODE AND PRO_CODE <> @PRO_CODE)
				BEGIN    
					-- 기준행사 체크    
					IF  @PRO_CODE <> @NEW_PRO_CODE    
					BEGIN
						BEGIN TRY

							BEGIN TRAN
							
							DECLARE @QUERY NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000), @RESERVE_YN CHAR(1), @QUERY2 NVARCHAR(2000)
							SELECT @QUERY = '', @QUERY2 = '', @RESERVE_YN = 'N'
							
							-- 행사명 체크 시    
							IF SUBSTRING(@UPDATE_TYPE, 1, 1) = '1'
							BEGIN
								SET @QUERY = @QUERY +  ', A.PRO_NAME = B.PRO_NAME'
							END

							-- 리뷰 체크 시    
							IF SUBSTRING(@UPDATE_TYPE, 2, 1) = '1'
							BEGIN
								SET @QUERY = @QUERY +  ', A.PKG_REVIEW = B.PKG_REVIEW'
							END

							-- 항공정보 체크 시
							IF SUBSTRING(@UPDATE_TYPE, 11, 1) = '1' --AND @ALL_PRODUCT_YN = 'N'
							BEGIN

								-- 기존 좌석코드의 날짜가 있을경우-----------    
								IF( @DIFF_DAY > -1 )    
								BEGIN    
									--출국+귀국편 날짜로, 코드가 동일한 패턴 좌석코드 가져오기    
									DECLARE @NEW_SEAT_CODE INT    
									SELECT @NEW_SEAT_CODE = (

										SELECT TOP 1 PTS.SEAT_CODE
										FROM PRO_TRANS_SEAT BAS WITH(NOLOCK)
										INNER JOIN PRO_TRANS_SEAT PTS WITH(NOLOCK)
										ON PTS.DEP_TRANS_CODE =  BAS.DEP_TRANS_CODE AND PTS.DEP_TRANS_NUMBER = BAS.DEP_TRANS_NUMBER
											AND PTS.DEP_DEP_AIRPORT_CODE = BAS.DEP_DEP_AIRPORT_CODE AND PTS.DEP_ARR_AIRPORT_CODE = BAS.DEP_ARR_AIRPORT_CODE
											AND PTS.ARR_TRANS_CODE = BAS.ARR_TRANS_CODE AND PTS.ARR_TRANS_NUMBER = BAS.ARR_TRANS_NUMBER
											AND PTS.ARR_DEP_AIRPORT_CODE = BAS.ARR_DEP_AIRPORT_CODE AND PTS.ARR_ARR_AIRPORT_CODE = BAS.ARR_ARR_AIRPORT_CODE
											/* 시간일치 코드 수정 */
											AND PTS.DEP_DEP_TIME = BAS.DEP_DEP_TIME AND PTS.DEP_ARR_TIME = BAS.DEP_ARR_TIME
											AND PTS.ARR_DEP_TIME = BAS.ARR_DEP_TIME AND PTS.ARR_ARR_TIME = BAS.ARR_ARR_TIME
											AND PTS.FARE_SEAT_TYPE = BAS.FARE_SEAT_TYPE -- 2019-04-09 좌석등급 추가 
											/* 시간일치 코드 수정 끝 */
										WHERE BAS.SEAT_CODE = @SEAT_CODE AND PTS.DEP_DEP_DATE = @START_DATE
											AND PTS.ARR_DEP_DATE = DATEADD(DAY, @DIFF_DAY, @START_DATE)    
											AND PTS.DEP_ARR_DATE = DATEADD(DAY, @DEP_DIFF, @START_DATE)    
											AND PTS.ARR_ARR_DATE = DATEADD(DAY, @ARR_DIFF, @START_DATE)    
										ORDER BY SEAT_CODE

										--SELECT TOP 1 PTS.SEAT_CODE      
										--FROM PRO_TRANS_SEAT AS PTS WITH(NOLOCK)     
										--INNER JOIN (    
										--	SELECT TOP 1 *
										--	FROM PRO_TRANS_SEAT WITH(NOLOCK)    
										--	WHERE SEAT_CODE = @SEAT_CODE    
										--) AS BAS    
										--ON PTS.DEP_TRANS_CODE =  BAS.DEP_TRANS_CODE AND PTS.DEP_TRANS_NUMBER = BAS.DEP_TRANS_NUMBER
										--	AND PTS.DEP_DEP_AIRPORT_CODE = BAS.DEP_DEP_AIRPORT_CODE AND PTS.DEP_ARR_AIRPORT_CODE = BAS.DEP_ARR_AIRPORT_CODE
										--	AND PTS.ARR_TRANS_CODE = BAS.ARR_TRANS_CODE AND PTS.ARR_TRANS_NUMBER = BAS.ARR_TRANS_NUMBER
										--	AND PTS.ARR_DEP_AIRPORT_CODE = BAS.ARR_DEP_AIRPORT_CODE AND PTS.ARR_ARR_AIRPORT_CODE = BAS.ARR_ARR_AIRPORT_CODE
										--	/* 시간일치 코드 수정 */
										--	AND PTS.DEP_DEP_TIME = BAS.DEP_DEP_TIME AND PTS.DEP_ARR_TIME = BAS.DEP_ARR_TIME
										--	AND PTS.ARR_DEP_TIME = BAS.ARR_DEP_TIME AND PTS.ARR_ARR_TIME = BAS.ARR_ARR_TIME
										--	/* 시간일치 코드 수정 끝 */
										--WHERE PTS.DEP_DEP_DATE = @START_DATE    
										--	AND PTS.ARR_DEP_DATE = DATEADD(DAY, @DIFF_DAY, @START_DATE)    
										--	AND PTS.DEP_ARR_DATE = DATEADD(DAY, @DEP_DIFF, @START_DATE)    
										--	AND PTS.ARR_ARR_DATE = DATEADD(DAY, @ARR_DIFF, @START_DATE)    
										--ORDER BY SEAT_CODE    
									)

									--입력할 패턴의 좌석코드가 있을때    
									IF(@NEW_SEAT_CODE IS NOT NULL AND @NEW_SEAT_CODE > 0)    
									BEGIN    

										--기존에 있는 좌석코드가 아닐때만 UPDATE     
										IF(@SEAT_CODE <> @NEW_SEAT_CODE )
										BEGIN

											UPDATE A SET A.SEAT_CODE = @NEW_SEAT_CODE, A.TOUR_NIGHT = C.TOUR_NIGHT
												, A.TOUR_DAY = C.TOUR_DAY, A.EDT_CODE = @EMP_CODE, A.EDT_DATE = GETDATE()
											FROM PKG_DETAIL A WITH(NOLOCK)
											INNER LOOP JOIN PRO_TRANS_SEAT B WITH(NOLOCK) ON A.SEAT_CODE = B.SEAT_CODE
											CROSS JOIN PKG_DETAIL C
											WHERE A.PRO_CODE LIKE @NEW_PRO_CODE AND C.PRO_CODE = @PRO_CODE AND A.PRO_CODE <> C.PRO_CODE
												AND (@ALL_PRODUCT_YN = 'N' OR B.DEP_TRANS_CODE = @DEP_TRANS_CODE)
												AND (@ALL_PRODUCT_YN = 'N' OR B.ARR_TRANS_CODE = @ARR_TRANS_CODE)
												--AND B.DEP_TRANS_CODE = @DEP_TRANS_CODE AND (@ALL_PRODUCT_YN = 'N' OR B.DEP_TRANS_NUMBER = @DEP_TRANS_NUMBER)
												--AND B.ARR_TRANS_CODE = @ARR_TRANS_CODE AND (@ALL_PRODUCT_YN = 'N' OR B.ARR_TRANS_NUMBER = @ARR_TRANS_NUMBER)
											OPTION (MAXDOP 1)
										END
									END  
									ELSE    
									BEGIN    
										INSERT INTO #MSG_TEMP     
										SELECT @START_DATE, 2, '좌석 패턴 없음'
									END  
								END   
								ELSE    
								BEGIN    
									INSERT INTO #MSG_TEMP     
									SELECT @START_DATE, 2, '교통편 항공이 아님'
								END   
							END  

							-- 여권/비자
							IF SUBSTRING(@UPDATE_TYPE, 12, 1) = '1'
							BEGIN
								SET @QUERY = @QUERY +  ', A.PKG_PASSPORT_REMARK = B.PKG_PASSPORT_REMARK'
							END

							-- 여행준비물
							IF SUBSTRING(@UPDATE_TYPE, 14, 1) = '1'
							BEGIN
								SET @QUERY = @QUERY +  ', A.PKG_TOUR_REMARK = B.PKG_TOUR_REMARK'
							END

							-- 추가사항
							IF SUBSTRING(@UPDATE_TYPE, 16, 1) = '1'
							BEGIN
								SET @QUERY = @QUERY +  ', A.PKG_INC_SPECIAL = B.PKG_INC_SPECIAL'
							END

							-- 상세항목 체크 시    
							IF SUBSTRING(@UPDATE_TYPE, 17, 1) = '1'
							BEGIN
								--20131029
								--좌석상태			A.SEAT_STATUS
								--센딩유무			A.SENDING_YN
								--예약추가가능여부	A.RES_EDT_YN
								--비자필수여부		A.VISA_YN
								--여권비고			A.PASS_INFO
								--첫만남안내			A.FIRST_MEET ( 제외 )
								--인천항공			A.MEET_COUNTER ( 제외 )
								--가격특성			A.PRICE_TYPE
								--항공GDS			A.AIR_GDS
								--호텔GDS			A.HOTEL_GDS
								--부킹선호클래스	A.AIRLINE
								--상품요약설명		A.PKG_SUMMARY
								--예약시주의사항	A.RES_REMARK
								--화면표시여부		A.SHOW_YN(요청제외)
								--인솔자				A.TC_YN
								--여행일정			A.TOUR_JOURNEY
								--호텔설명			A.HOTEL_REMARK
								--가이드				A.GUIDE_YN
								SET @QUERY = @QUERY +  ', A.SEAT_STATUS = B.SEAT_STATUS, A.SENDING_YN = B.SENDING_YN
									, A.RES_EDT_YN = B.RES_EDT_YN, A.VISA_YN = B.VISA_YN, A.PASS_INFO = B.PASS_INFO
									, A.PRICE_TYPE = B.PRICE_TYPE, A.AIR_GDS = B.AIR_GDS
									, A.HOTEL_GDS = B.HOTEL_GDS, A.AIRLINE = B.AIRLINE, A.PKG_SUMMARY = B.PKG_SUMMARY
									, A.RES_REMARK = B.RES_REMARK, A.TC_YN = B.TC_YN
									, A.TOUR_JOURNEY = B.TOUR_JOURNEY, A.HOTEL_REMARK = B.HOTEL_REMARK, A.GUIDE_YN = B.GUIDE_YN'
							END

							-- 인원  
							IF SUBSTRING(@UPDATE_TYPE, 18, 1) = '1'
							BEGIN
								SET @QUERY = @QUERY +  ', A.MAX_COUNT = B.MAX_COUNT, A.MIN_COUNT = B.MIN_COUNT'
							END

							-- 모객특성  
							IF SUBSTRING(@UPDATE_TYPE, 19, 1) = '1'
							BEGIN
								SET @QUERY = @QUERY +  ', A.SALE_TYPE = B.SALE_TYPE'
							END

							-- 특별약관  
							IF SUBSTRING(@UPDATE_TYPE, 20, 1) = '1'
							BEGIN
								SET @QUERY = @QUERY +  ', A.PKG_CONTRACT = B.PKG_CONTRACT' 
							END

							-- 출발확정여부  
							IF SUBSTRING(@UPDATE_TYPE, 21, 1) = '1'
							BEGIN
								SET @QUERY = @QUERY +  ', A.DEP_CFM_YN = B.DEP_CFM_YN'  
							END

							-- 출발예정여부  
							IF SUBSTRING(@UPDATE_TYPE, 22, 1) = '1'
							BEGIN
								SET @QUERY = @QUERY +  ', A.CONFIRM_YN = B.CONFIRM_YN'
							END

							-- 예약가능여부
							IF SUBSTRING(@UPDATE_TYPE, 23, 1) = '1'
							BEGIN
								SET @QUERY = @QUERY +  ', A.RES_ADD_YN = B.RES_ADD_YN' 
							END

							-- 단독/연합상품여부
							IF SUBSTRING(@UPDATE_TYPE, 24, 1) = '1'
							BEGIN
								SET @QUERY = @QUERY +  ', A.UNITE_YN = B.UNITE_YN' 
							END

							-- 항공상태여부
							IF SUBSTRING(@UPDATE_TYPE, 25, 1) = '1'
							BEGIN
								SET @QUERY = @QUERY +  ', A.AIR_CFM_YN = B.AIR_CFM_YN' 
							END

							-- 숙박상태여부
							IF SUBSTRING(@UPDATE_TYPE, 26, 1) = '1'
							BEGIN
								SET @QUERY = @QUERY +  ', A.ROOM_CFM_YN = B.ROOM_CFM_YN' 
							END

							-- 일정상태여부
							IF SUBSTRING(@UPDATE_TYPE, 27, 1) = '1'
							BEGIN
								SET @QUERY = @QUERY +  ', A.SCHEDULE_CFM_YN = B.SCHEDULE_CFM_YN' 
							END

							-- 가격상태여부
							IF SUBSTRING(@UPDATE_TYPE, 28, 1) = '1'
							BEGIN
								SET @QUERY = @QUERY +  ', A.PRICE_CFM_YN = B.PRICE_CFM_YN' 
							END
						
							-- 첫만남
							IF SUBSTRING(@UPDATE_TYPE, 29, 1) = '1'
							BEGIN
								SET @QUERY = @QUERY + ', A.FIRST_MEET = B.FIRST_MEET'
							END

							-- 미팅 카운터
							IF SUBSTRING(@UPDATE_TYPE, 30, 1) = '1'
							BEGIN
								SET @QUERY = @QUERY + ', A.MEET_COUNTER = B.MEET_COUNTER'
							END

							-- 선택관광/기타  
							IF SUBSTRING(@UPDATE_TYPE, 15, 1) = '1'
							BEGIN
								SET @QUERY = @QUERY +  ', A.PKG_REMARK = B.PKG_REMARK, A.OPTION_REMARK = B.OPTION_REMARK'
								SET @QUERY2 = @QUERY2 + '
								DELETE FROM PKG_DETAIL_OPTION WHERE PRO_CODE LIKE @NEW_PRO_CODE AND PRO_CODE <> @PRO_CODE;
								INSERT INTO PKG_DETAIL_OPTION (PRO_CODE, OPT_SEQ, OPT_NAME, OPT_CONTENT, OPT_PRICE, OPT_USETIME, OPT_REPLACE, OPT_PLACE, OPT_COMPANION)
								SELECT A.PRO_CODE, B.OPT_SEQ, B.OPT_NAME, B.OPT_CONTENT, B.OPT_PRICE, B.OPT_USETIME, B.OPT_REPLACE, B.OPT_PLACE, B.OPT_COMPANION
								FROM PKG_DETAIL A WITH(NOLOCK)
								CROSS JOIN PKG_DETAIL_OPTION B WITH(NOLOCK)
								WHERE A.PRO_CODE LIKE @NEW_PRO_CODE AND A.PRO_CODE <> @PRO_CODE AND B.PRO_CODE = @PRO_CODE;'
							END

							-- 쇼핑안내
							IF SUBSTRING(@UPDATE_TYPE, 13, 1) = '1'
							BEGIN
								SET @QUERY = @QUERY + ', A.PKG_SHOPPING_REMARK = B.PKG_SHOPPING_REMARK'
								SET @QUERY2 = @QUERY2 + '
								DELETE FROM PKG_DETAIL_SHOPPING WHERE PRO_CODE LIKE @NEW_PRO_CODE AND PRO_CODE <> @PRO_CODE;
								INSERT INTO PKG_DETAIL_SHOPPING (PRO_CODE, SHOP_SEQ, SHOP_NAME, SHOP_PLACE, SHOP_TIME, SHOP_REMARK)
								SELECT A.PRO_CODE, B.SHOP_SEQ, B.SHOP_NAME, B.SHOP_PLACE, B.SHOP_TIME, B.SHOP_REMARK
								FROM PKG_DETAIL A WITH(NOLOCK)
								CROSS JOIN PKG_DETAIL_SHOPPING B WITH(NOLOCK)
								WHERE A.PRO_CODE LIKE @NEW_PRO_CODE AND A.PRO_CODE <> @PRO_CODE AND B.PRO_CODE = @PRO_CODE;'
							END

							-- 네이버 셀링 포인트 19.03추가
							IF SUBSTRING(@UPDATE_TYPE, 31, 1) = '1'
							BEGIN
								-- 행사요약설명 없으면 추가 
								IF( CHARINDEX( '.PKG_SUMMARY',@QUERY ) = 0 )
								BEGIN
									SET @QUERY = @QUERY +  ', A.PKG_SUMMARY = B.PKG_SUMMARY'  -- 행사요약설명 190424	
								END 
							
								-- 현재꺼가 있으면 
								IF EXISTS (SELECT * FROM PKG_DETAIL_SELL_POINT WHERE PRO_CODE = @NEW_PRO_CODE )
								BEGIN
									UPDATE A SET A.TRAFFIC_POINT = B.TRAFFIC_POINT ,A.STAY_POINT = B.STAY_POINT ,
									A.TOUR_POINT = B.TOUR_POINT ,A.EAT_POINT = B.EAT_POINT ,
									A.DISCOUNT_POINT = B.DISCOUNT_POINT ,A.OTHER_POINT = B.OTHER_POINT ,
									A.INNER_PKG_GUIDANCE = B.INNER_PKG_GUIDANCE, A.INNER_CONTENT_URL = B.INNER_CONTENT_URL
									FROM PKG_DETAIL_SELL_POINT A
									INNER JOIN PKG_DETAIL_SELL_POINT B 
									ON A.PRO_CODE = @NEW_PRO_CODE AND B.PRO_CODE = @PRO_CODE
								END 
								ELSE 
								BEGIN
									INSERT INTO PKG_DETAIL_SELL_POINT 
									(PRO_CODE,TRAFFIC_POINT,STAY_POINT,TOUR_POINT,EAT_POINT,DISCOUNT_POINT,OTHER_POINT,INNER_PKG_GUIDANCE,INNER_CONTENT_URL)
									SELECT @NEW_PRO_CODE , TRAFFIC_POINT,STAY_POINT,TOUR_POINT,EAT_POINT,DISCOUNT_POINT,OTHER_POINT,INNER_PKG_GUIDANCE,INNER_CONTENT_URL
									FROM PKG_DETAIL_SELL_POINT WHERE PRO_CODE = @PRO_CODE
								END 
							END
							-- 랜드사 차후 개발
						
							-- 수정사항이 있으면 일괄 수정
							IF @QUERY <> ''
							BEGIN
								SET @QUERY = 'UPDATE A SET
									' + SUBSTRING(@QUERY, 2, 4000) + '
									, A.EDT_CODE = @EMP_CODE, A.EDT_DATE = GETDATE()
								FROM PKG_DETAIL A
								CROSS JOIN PKG_DETAIL B
								WHERE A.PRO_CODE LIKE @NEW_PRO_CODE AND A.PRO_CODE <> @PRO_CODE AND B.PRO_CODE = @PRO_CODE;' + @QUERY2

								SET @PARMDEFINITION = N'@NEW_PRO_CODE VARCHAR(20), @PRO_CODE VARCHAR(20), @EMP_CODE CHAR(7)';  

								EXEC SP_EXECUTESQL @QUERY, @PARMDEFINITION, @NEW_PRO_CODE, @PRO_CODE, @EMP_CODE;
							END

							-- 일정표 체크 시 
							IF SUBSTRING(@UPDATE_TYPE, 3, 1) = '1' AND @ALL_PRODUCT_YN = 'N'
							BEGIN     
								DELETE FROM PKG_DETAIL_SCH_MASTER WHERE PRO_CODE = @NEW_PRO_CODE  
							
								INSERT INTO PKG_DETAIL_SCH_MASTER
								SELECT @NEW_PRO_CODE, A.SCH_SEQ, A.SCH_NAME
								FROM PKG_DETAIL_SCH_MASTER A WITH(NOLOCK)
								WHERE A.PRO_CODE = @PRO_CODE AND A.SCH_SEQ IN (SELECT DISTINCT AA.SCH_SEQ FROM PKG_DETAIL_PRICE AA WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE)

								INSERT INTO PKG_DETAIL_SCH_DAY
								SELECT @NEW_PRO_CODE, A.SCH_SEQ, A.DAY_SEQ, A.DAY_NUMBER,A.FREE_SCH_YN --19.03 자유일정유무추가
								FROM PKG_DETAIL_SCH_DAY A WITH(NOLOCK)
								WHERE A.PRO_CODE = @PRO_CODE AND A.SCH_SEQ IN (SELECT DISTINCT AA.SCH_SEQ FROM PKG_DETAIL_PRICE AA WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE)

								--네이버 이동수단 삭제  
								--DELETE FROM NAVER_PKG_DETAIL_SCH_DAY_TRANSPORT WHERE PRO_CODE = @NEW_PRO_CODE

								/*
								--네이버 이동수단 복사(2019-08-19)
								INSERT INTO NAVER_PKG_DETAIL_SCH_DAY_TRANSPORT
								SELECT @NEW_PRO_CODE, SCH_SEQ, DAY_SEQ, DAY_NUMBER, TRANSPORT_SEQ, TRANSPORT_TYPE, TRANSPORT_DESC
								FROM NAVER_PKG_DETAIL_SCH_DAY_TRANSPORT WITH(NOLOCK)
								WHERE PRO_CODE = @PRO_CODE
								*/
								
								INSERT INTO PKG_DETAIL_SCH_CITY
								SELECT @NEW_PRO_CODE, A.SCH_SEQ, A.DAY_SEQ, A.CITY_SEQ, A.CITY_CODE, A.MAINCITY_YN, A.CITY_SHOW_ORDER
								FROM PKG_DETAIL_SCH_CITY A WITH(NOLOCK)
								WHERE A.PRO_CODE = @PRO_CODE AND A.SCH_SEQ IN (SELECT DISTINCT AA.SCH_SEQ FROM PKG_DETAIL_PRICE AA WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE)

								INSERT INTO PKG_DETAIL_SCH_CONTENT
								SELECT @NEW_PRO_CODE, A.SCH_SEQ, A.DAY_SEQ, A.CITY_SEQ, A.CNT_SEQ, A.CNT_CODE, A.CNT_INFO, A.CNT_SHOW_ORDER 
								FROM PKG_DETAIL_SCH_CONTENT A WITH(NOLOCK)
								WHERE A.PRO_CODE = @PRO_CODE AND A.SCH_SEQ IN (SELECT DISTINCT AA.SCH_SEQ FROM PKG_DETAIL_PRICE AA WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE)

								--네이버 사용자 정의 일정 삭제
								--DELETE FROM NAVER_PKG_DETAIL_SCH_CONTENT WHERE PRO_CODE = @NEW_PRO_CODE

								/*
								--네이버 사용자 정의 복사(2019-08-19)
								INSERT INTO NAVER_PKG_DETAIL_SCH_CONTENT
								SELECT @NEW_PRO_CODE, SCH_SEQ, DAY_SEQ, CITY_SEQ, CNT_SEQ, CNT_SUBJECT, CNT_INFO
								FROM NAVER_PKG_DETAIL_SCH_CONTENT WITH(NOLOCK)
								WHERE PRO_CODE = @PRO_CODE
								*/
								
								-- 사용 스케줄 일괄수정
								IF ((SELECT COUNT(*) FROM PKG_DETAIL_PRICE A WITH(NOLOCK) WHERE A.PRO_CODE = @PRO_CODE) = 1)
								BEGIN
									UPDATE A SET A.SCH_SEQ = B.SCH_SEQ
									FROM PKG_DETAIL_PRICE A WITH(NOLOCK)
									CROSS JOIN PKG_DETAIL_PRICE B WITH(NOLOCK)
									WHERE A.PRO_CODE = @NEW_PRO_CODE AND B.PRO_CODE = @PRO_CODE
								END
								ELSE
								BEGIN
									UPDATE A SET A.SCH_SEQ = B.SCH_SEQ
									FROM PKG_DETAIL_PRICE A WITH(NOLOCK)
									INNER JOIN PKG_DETAIL_PRICE B WITH(NOLOCK) ON A.PRICE_SEQ = B.PRICE_SEQ
									WHERE A.PRO_CODE = @NEW_PRO_CODE AND B.PRO_CODE = @PRO_CODE	
								END

								/*-- 가격정보에 일정 지정이 안되어 있을 경우 강제 지정
								UPDATE A SET A.SCH_SEQ = C.SCH_SEQ
								FROM PKG_DETAIL_PRICE A WITH(NOLOCK)
								LEFT JOIN PKG_DETAIL_SCH_MASTER B WITH(NOLOCK) ON A.PRO_CODE = B.PRO_CODE AND A.SCH_SEQ = B.SCH_SEQ
								LEFT JOIN (
									SELECT TOP 1 * FROM PKG_DETAIL_SCH_MASTER A WITH(NOLOCK) WHERE A.PRO_CODE = @NEW_PRO_CODE
								) C ON A.PRO_CODE = C.PRO_CODE
								WHERE A.PRO_CODE = @NEW_PRO_CODE AND B.PRO_CODE IS NULL

								-- 가격과 일정이 하나씩이면 매칭시킨다
								UPDATE A SET A.SCH_SEQ = B.SCH_SEQ
								FROM PKG_DETAIL_PRICE A
								LEFT JOIN PKG_DETAIL_SCH_MASTER B ON A.PRO_CODE = B.PRO_CODE
								WHERE A.PRO_CODE IN (
									SELECT A.PRO_CODE 
									FROM PKG_DETAIL_PRICE A WITH(NOLOCK) 
									INNER JOIN PKG_DETAIL_SCH_MASTER B WITH(NOLOCK) ON A.PRO_CODE = B.PRO_CODE
									WHERE A.PRO_CODE = @NEW_PRO_CODE
									GROUP BY A.PRO_CODE
									HAVING COUNT(*) = 1
								) AND ISNULL(A.SCH_SEQ, 0) <> B.SCH_SEQ
								*/
							END

							-- 예약이 존재하면 일괄수정 금지
							IF NOT EXISTS(SELECT 1 FROM RES_MASTER_DAMO WHERE PRO_CODE LIKE @NEW_PRO_CODE)
							BEGIN
								IF SUBSTRING(@UPDATE_TYPE, 4, 6) = '111111' AND @ALL_PRODUCT_YN = 'N'
								BEGIN
									-- 기존가격삭제
									DELETE FROM PKG_DETAIL_PRICE WHERE PRO_CODE = @NEW_PRO_CODE

									-- 가격 복사
									INSERT INTO PKG_DETAIL_PRICE (
										PRO_CODE, PRICE_SEQ, PRICE_NAME, SEASON, SCH_SEQ, PKG_INCLUDE
										, PKG_NOT_INCLUDE, ADT_PRICE, CHD_PRICE, INF_PRICE, SGL_PRICE, CUR_TYPE
										, EXC_RATE, FLOATING_YN, POINT_RATE, POINT_PRICE, POINT_YN
										, QCHARGE_TYPE, ADT_QCHARGE, CHD_QCHARGE, INF_QCHARGE, ADT_TAX, CHD_TAX, INF_TAX, QCHARGE_DATE
									)    
									SELECT @NEW_PRO_CODE, PRICE_SEQ, PRICE_NAME, SEASON, SCH_SEQ, PKG_INCLUDE
										, PKG_NOT_INCLUDE, ADT_PRICE, CHD_PRICE, INF_PRICE, SGL_PRICE, CUR_TYPE
										, EXC_RATE, FLOATING_YN, POINT_RATE, POINT_PRICE, POINT_YN 
										, QCHARGE_TYPE, ADT_QCHARGE, CHD_QCHARGE, INF_QCHARGE, ADT_TAX, CHD_TAX, INF_TAX, QCHARGE_DATE
									FROM PKG_DETAIL_PRICE WITH(NOLOCK)
									WHERE PRO_CODE = @PRO_CODE
								END
							END

							-- 상품가격 체크 시(싱글추가요금 제외)
							IF SUBSTRING(@UPDATE_TYPE, 5, 1) = '1' AND @ALL_PRODUCT_YN = 'N'
							BEGIN
								UPDATE A SET A.PRICE_NAME = B.PRICE_NAME, A.SEASON = B.SEASON, A.ADT_PRICE = B.ADT_PRICE, A.CHD_PRICE = B.CHD_PRICE, A.INF_PRICE = B.INF_PRICE
									, A.CUR_TYPE = B.CUR_TYPE, A.EXC_RATE = B.EXC_RATE, A.FLOATING_YN = B.FLOATING_YN, A.POINT_RATE = B.POINT_RATE, A.POINT_PRICE = B.POINT_PRICE, A.POINT_YN = B.POINT_YN
								FROM PKG_DETAIL_PRICE A
								INNER JOIN PKG_DETAIL_PRICE B ON A.PRICE_SEQ = B.PRICE_SEQ
								WHERE A.PRO_CODE = @NEW_PRO_CODE AND B.PRO_CODE = @PRO_CODE
							END

							-- 유류할증료 체크 시
							IF SUBSTRING(@UPDATE_TYPE, 6, 1) = '1' AND @ALL_PRODUCT_YN = 'N'
							BEGIN
								UPDATE A SET A.QCHARGE_TYPE = B.QCHARGE_TYPE, A.ADT_QCHARGE = B.ADT_QCHARGE, A.CHD_QCHARGE = B.CHD_QCHARGE, A.INF_QCHARGE = B.INF_QCHARGE
									, A.ADT_TAX = B.ADT_TAX, A.CHD_TAX = B.CHD_TAX, A.INF_TAX = B.INF_TAX, A.QCHARGE_DATE = B.QCHARGE_DATE
								FROM PKG_DETAIL_PRICE A
								INNER JOIN PKG_DETAIL_PRICE B ON A.PRICE_SEQ = B.PRICE_SEQ
								WHERE A.PRO_CODE = @NEW_PRO_CODE AND B.PRO_CODE = @PRO_CODE
							END

							-- 싱글추가요금
							IF SUBSTRING(@UPDATE_TYPE, 9, 1) = '1' AND @ALL_PRODUCT_YN = 'N'
							BEGIN
								UPDATE A SET A.SGL_PRICE = B.SGL_PRICE
								FROM PKG_DETAIL_PRICE A
								INNER JOIN PKG_DETAIL_PRICE B ON A.PRICE_SEQ = B.PRICE_SEQ
								WHERE A.PRO_CODE = @NEW_PRO_CODE AND B.PRO_CODE = @PRO_CODE
							END

							-- 포함/불포함 체크 시
							IF SUBSTRING(@UPDATE_TYPE, 8, 1) = '1' AND @ALL_PRODUCT_YN = 'N'
							BEGIN
								UPDATE A SET A.PKG_INCLUDE = B.PKG_INCLUDE, A.PKG_NOT_INCLUDE = B.PKG_NOT_INCLUDE
								FROM PKG_DETAIL_PRICE A
								INNER JOIN PKG_DETAIL_PRICE B ON A.PRICE_SEQ = B.PRICE_SEQ
								WHERE A.PRO_CODE = @NEW_PRO_CODE AND B.PRO_CODE = @PRO_CODE

								-- 네이버 포함/불포함 추가 2019-03-07
								-- 원본 행사에 포함정보가 있을시에만 갱신한다 . 지워지면 안되므로 
								--IF EXISTS ( SELECT * FROM PKG_DETAIL_PRICE_INOUT WHERE PRO_CODE = @PRO_CODE  ) 
								--BEGIN
									-- 현재꺼 삭제 
									DELETE PKG_DETAIL_PRICE_INOUT WHERE PRO_CODE = @NEW_PRO_CODE  
									 --원본 행사껄로 다시 넣기 
									INSERT INTO PKG_DETAIL_PRICE_INOUT (PRO_CODE,PRICE_SEQ,INOUT_CODE,IN_YN)
									SELECT @NEW_PRO_CODE, A.PRICE_SEQ, A.INOUT_CODE, A.IN_YN
									FROM PKG_DETAIL_PRICE_INOUT A WITH(NOLOCK)
									WHERE A.PRO_CODE = @PRO_CODE 
								--END 
							END

							-- 예약이 존재하면 일괄수정 금지
							IF NOT EXISTS(SELECT 1 FROM RES_MASTER_DAMO WHERE PRO_CODE LIKE @NEW_PRO_CODE)
							BEGIN
								IF SUBSTRING(@UPDATE_TYPE, 4, 6) = '111111' AND @ALL_PRODUCT_YN = 'N'
								BEGIN
									-- 호텔 복사 --19.03 식사코드 추가 
									INSERT INTO PKG_DETAIL_PRICE_HOTEL    
									SELECT @NEW_PRO_CODE, PRICE_SEQ, DAY_NUMBER, HTL_MASTER_CODE, SUP_CODE, STAY_TYPE, STAY_INFO, DINNER_1, DINNER_2, DINNER_3,
										DINNER_CODE_1,DINNER_CODE_2,DINNER_CODE_3  
									FROM PKG_DETAIL_PRICE_HOTEL WHERE PRO_CODE = @PRO_CODE
								END
							END

							-- 호텔 체크 시
							-- 19.03 식사코드추가
							IF SUBSTRING(@UPDATE_TYPE, 4, 1) = '1' AND @ALL_PRODUCT_YN = 'N'
							BEGIN
								--UPDATE PKG_DETAIL_PRICE_HOTEL SET HTL_MASTER_CODE = NULL, SUP_CODE = NULL, STAY_TYPE = NULL, STAY_INFO = NULL, DINNER_1 = NULL, DINNER_2 = NULL, DINNER_3 = NULL
								--WHERE PRO_CODE = @NEW_PRO_CODE

								IF EXISTS(SELECT 1 FROM PKG_DETAIL_PRICE_HOTEL WITH(NOLOCK) WHERE PRO_CODE = @NEW_PRO_CODE)
								BEGIN
									UPDATE A SET A.HTL_MASTER_CODE = B.HTL_MASTER_CODE, A.SUP_CODE = B.SUP_CODE, A.STAY_TYPE = B.STAY_TYPE, A.STAY_INFO = B.STAY_INFO
										, A.DINNER_1 = B.DINNER_1, A.DINNER_2 = B.DINNER_2, A.DINNER_3 = B.DINNER_3
										, A.DINNER_CODE_1 = B.DINNER_CODE_1, A.DINNER_CODE_2 = B.DINNER_CODE_2, A.DINNER_CODE_3 = B.DINNER_CODE_3
									FROM PKG_DETAIL_PRICE_HOTEL A
									INNER JOIN PKG_DETAIL_PRICE_HOTEL B ON A.PRICE_SEQ = B.PRICE_SEQ AND A.DAY_NUMBER = B.DAY_NUMBER
									WHERE A.PRO_CODE = @NEW_PRO_CODE AND B.PRO_CODE = @PRO_CODE
								END
								ELSE
								BEGIN
									INSERT INTO PKG_DETAIL_PRICE_HOTEL    
									(PRO_CODE, PRICE_SEQ, DAY_NUMBER, HTL_MASTER_CODE, SUP_CODE, STAY_TYPE, STAY_INFO, DINNER_1,DINNER_2,DINNER_3,DINNER_CODE_1,DINNER_CODE_2,DINNER_CODE_3)
									SELECT @NEW_PRO_CODE, PRICE_SEQ, DAY_NUMBER, HTL_MASTER_CODE, SUP_CODE, STAY_TYPE, STAY_INFO, DINNER_1, DINNER_2, DINNER_3,DINNER_CODE_1,DINNER_CODE_2,DINNER_CODE_3
									FROM PKG_DETAIL_PRICE_HOTEL WHERE PRO_CODE = @PRO_CODE
								END
							END

							-- 예약이 존재하면 일괄수정 금지
							IF NOT EXISTS(SELECT 1 FROM RES_MASTER_DAMO WHERE PRO_CODE LIKE @NEW_PRO_CODE)
							BEGIN
								IF SUBSTRING(@UPDATE_TYPE, 4, 6) = '111111' AND @ALL_PRODUCT_YN = 'N'
								BEGIN
									-- 공동경비 복사
									INSERT INTO PKG_DETAIL_PRICE_GROUP_COST (PRO_CODE, PRICE_SEQ, COST_SEQ, COST_NAME, CURRENCY, ADT_COST, CHD_COST, INF_COST, USE_YN)
									SELECT @NEW_PRO_CODE, A.PRICE_SEQ, A.COST_SEQ, A.COST_NAME, A.CURRENCY, A.ADT_COST, A.CHD_COST, A.INF_COST, A.USE_YN
									FROM PKG_DETAIL_PRICE_GROUP_COST A WITH(NOLOCK)
									WHERE A.PRO_CODE = @PRO_CODE
								END
							END

							-- 공동경비 체크 시
							IF SUBSTRING(@UPDATE_TYPE, 7, 1) = '1' AND @ALL_PRODUCT_YN = 'N'
							BEGIN
								--UPDATE PKG_DETAIL_PRICE_GROUP_COST SET COST_NAME = NULL, CURRENCY = NULL, ADT_COST = NULL, CHD_COST = NULL, INF_COST = NULL, USE_YN = NULL
								--WHERE PRO_CODE = @NEW_PRO_CODE

								IF EXISTS(SELECT 1 FROM PKG_DETAIL_PRICE_GROUP_COST WITH(NOLOCK) WHERE PRO_CODE = @NEW_PRO_CODE)
								BEGIN
									UPDATE A SET A.COST_NAME = B.COST_NAME, A.CURRENCY = B.CURRENCY, A.ADT_COST = B.ADT_COST, A.CHD_COST = B.CHD_COST, A.INF_COST = B.INF_COST, A.USE_YN = B.USE_YN
									FROM PKG_DETAIL_PRICE_GROUP_COST A
									INNER JOIN PKG_DETAIL_PRICE_GROUP_COST B ON A.PRICE_SEQ = B.PRICE_SEQ AND A.COST_SEQ = B.COST_SEQ
									WHERE A.PRO_CODE = @NEW_PRO_CODE AND B.PRO_CODE = @PRO_CODE
								END
								ELSE
								BEGIN
									INSERT INTO PKG_DETAIL_PRICE_GROUP_COST (PRO_CODE, PRICE_SEQ, COST_SEQ, COST_NAME, CURRENCY, ADT_COST, CHD_COST, INF_COST, USE_YN)
									SELECT @NEW_PRO_CODE, A.PRICE_SEQ, A.COST_SEQ, A.COST_NAME, A.CURRENCY, A.ADT_COST, A.CHD_COST, A.INF_COST, A.USE_YN
									FROM PKG_DETAIL_PRICE_GROUP_COST A WITH(NOLOCK)
									WHERE A.PRO_CODE = @PRO_CODE
								END
							END

							-- 파일 체크 시
							IF SUBSTRING(@UPDATE_TYPE, 10, 1) = '1' AND @ALL_PRODUCT_YN = 'N'
							BEGIN
								-- 기존이미지 삭제
								DELETE FROM PKG_DETAIL_FILE WHERE PRO_CODE = @NEW_PRO_CODE    
								-- 기준 이미지 입력
								INSERT INTO PKG_DETAIL_FILE    
								SELECT @NEW_PRO_CODE, FILE_CODE, SHOW_ORDER FROM PKG_DETAIL_FILE WHERE PRO_CODE = @PRO_CODE
							END

							-- LOG INSERT
							IF @RESERVE_YN = 'N'
							BEGIN
								INSERT INTO #MSG_TEMP
								SELECT @START_DATE, 1, '수정 성공'
							END
							ELSE
							BEGIN
								INSERT INTO #MSG_TEMP
								SELECT @START_DATE, 3, '예약 존재 가격/호텔 제외 수정'
							END

							COMMIT TRAN

							--------------------------------------------------------------------------------------
							-- 트립토파즈 연동 등록
							--------------------------------------------------------------------------------------
							EXEC DBO.XP_NTT_PKG_DETAIL_TARGET_INSERT @PRO_CODE=@NEW_PRO_CODE, @EMP_CODE=@EMP_CODE
							--------------------------------------------------------------------------------------
							/*
							--------------------------------------------------------------------------------------
							-- 수정 히스토리에 등록 (네이버용) 2019-12
							-- 현재는 DYNAMIC(가격,상태)만 처리 하기 , 
							-- 추후 전체 처리로 바꿔야함
							DECLARE @IS_UPDATE_PRICE INT ,@IS_UPDATE_STATUS INT , @UPDATE_TARGET VARCHAR(20) 
							IF SUBSTRING(@UPDATE_TYPE, 5, 1) = '1'  --가격
								OR SUBSTRING(@UPDATE_TYPE, 6, 1) = '1'  --유류
								OR SUBSTRING(@UPDATE_TYPE, 9, 1) = '1'  --싱글
							BEGIN
								SET @IS_UPDATE_PRICE = 1 
								SET @UPDATE_TARGET = 'PRICE'
							END 
							IF SUBSTRING(@UPDATE_TYPE, 18, 1) = '1' -- 인원  
								OR SUBSTRING(@UPDATE_TYPE, 23, 1) = '1' -- 예약가능여부 
							BEGIN
								SET @IS_UPDATE_STATUS = 1 
								SET @UPDATE_TARGET = 'STATUS'
							END 

							IF @IS_UPDATE_PRICE = 1  AND  @IS_UPDATE_STATUS  = 1 
							BEGIN 
								SET @UPDATE_TARGET = 'PRICESTATUS'
							END
							
							/*
							IF ISNULL(@UPDATE_TARGET,'') <> ''
							BEGIN
								EXEC DBO.XP_NAVER_PKG_DETAIL_UPDATE_HISTORY_INSERT @NEW_PRO_CODE ,'UPDATEMON' ,@UPDATE_TARGET ,@EMP_CODE
							END
							*/							
							--------------------------------------------------------------------------------------
							*/
						
						END TRY    
						BEGIN CATCH    

							ROLLBACK TRAN    

							-- LOG INSERT    
							INSERT INTO #MSG_TEMP     
							SELECT @START_DATE, 2, ERROR_MESSAGE()    

							--SET @START_DATE = DATEADD(DAY, 1, @START_DATE)    
						END CATCH
					END  
					ELSE    
					BEGIN    
						-- LOG INSERT    
						INSERT INTO #MSG_TEMP     
						SELECT @START_DATE, 2, (@NEW_PRO_CODE + ' 기준행사')    
					END  
				END  
				ELSE    
				BEGIN    
					-- LOG INSERT    
					INSERT INTO #MSG_TEMP     
					SELECT @START_DATE, 2, (@NEW_PRO_CODE + ' 행사 없음')    
				END  
			END  

			SET @START_DATE = DATEADD(DAY, 1, @START_DATE)    
		END  


		-- 트리거 예외처리 후 마스터 업데이트
		EXEC DBO.SP_PKG_MASTER_RESETTING @NEW_MASTER_CODE;

	END
	ELSE
	BEGIN
		INSERT INTO #MSG_TEMP 
		SELECT GETDATE(), 2, '일시동작중지(개발팀)';
	END
	
	-- 결과리턴
	SELECT * FROM #MSG_TEMP;
	DROP TABLE #MSG_TEMP;
	  
END




GO
