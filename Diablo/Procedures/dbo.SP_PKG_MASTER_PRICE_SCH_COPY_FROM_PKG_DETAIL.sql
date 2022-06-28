USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_PKG_MASTER_PRICE_SCH_COPY_FROM_PKG_DETAIL
- 기 능 : 행사가격/일정 마스터로 복사 
====================================================================================
	참고내용
====================================================================================
- 행사(가격,스케쥴) -> 마스터(가격,스케쥴)복사등록

- 예제
 EXEC SP_PKG_MASTER_PRICE_SCH_COPY_FROM_PKG_DETAIL 'XXX101-140318' , '' , '1' 
====================================================================================
	변경내역
====================================================================================
- 2014-03-10 박형만 최초생성
- 2014-06-24 박형만 유류할증료 컬럼 추가 , 현지필수경비 테이블 추가 
- 2019-03-07 박형만	네이버 관련 행사 컬럼 추가 
===================================================================================*/
CREATE PROC [dbo].[SP_PKG_MASTER_PRICE_SCH_COPY_FROM_PKG_DETAIL]
	@PRO_CODE PRO_CODE ,
	@STR_PRICE_SEQ VARCHAR(200) , --복사할 PRICE_SEQ '1,2,3'
	@STR_SCH_SEQ VARCHAR(200) --복사할 SCH_SEQ '1,2,3'
AS 
SET NOCOUNT ON 

--DECLARE @PRO_CODE PRO_CODE ,
--@STR_PRICE_SEQ VARCHAR(200) , --복사할 PRICE_SEQ '1,2,3'
--@STR_SCH_SEQ VARCHAR(200) --복사할 SCH_SEQ '1,2,3'
--SET @PRO_CODE =  'CPP9050-140311A'  
--SET @STR_PRICE_SEQ =  '2,3'
--SET @STR_SCH_SEQ  =  '1,2'

DECLARE @MASTER_CODE MASTER_CODE 
SET @MASTER_CODE = SUBSTRING(@PRO_CODE,1,CHARINDEX('-',@PRO_CODE) -1 ) 

DECLARE @STEP_MESSAGE VARCHAR(300)


BEGIN TRY

	BEGIN TRAN
	----------------------------------------------------------------------------------------------------------------
	--[ 가격 ] 
	IF( ISNULL(@STR_PRICE_SEQ,'') <> '' )
	BEGIN

		DECLARE @MAX_PRICE_SEQ INT 
		SET @MAX_PRICE_SEQ = ISNULL((SELECT MAX(PRICE_SEQ) FROM PKG_MASTER_PRICE WITH(NOLOCK) WHERE MASTER_CODE =@MASTER_CODE),0) 

		--SELECT MAX(PRICE_SEQ) FROM PKG_MASTER_PRICE WITH(NOLOCK)  WHERE MASTER_CODE =@MASTER_CODE
		--가격 복사등록
		INSERT INTO PKG_MASTER_PRICE (MASTER_CODE,PRICE_SEQ,
			PRICE_NAME,SEASON,SCH_SEQ,PKG_INCLUDE,PKG_NOT_INCLUDE,
			ADT_PRICE,CHD_PRICE,INF_PRICE,SGL_PRICE,CUR_TYPE,EXC_RATE,FLOATING_YN,POINT_RATE,POINT_PRICE,POINT_YN,
			QCHARGE_TYPE,ADT_QCHARGE,CHD_QCHARGE,INF_QCHARGE,QCHARGE_DATE,ADT_TAX,CHD_TAX,INF_TAX )
		SELECT @MASTER_CODE, @MAX_PRICE_SEQ + (DENSE_RANK() OVER (ORDER BY PRICE_SEQ ASC ))  ,
			PRICE_NAME,SEASON, NULL as SCH_SEQ ,PKG_INCLUDE,PKG_NOT_INCLUDE,
			ADT_PRICE,CHD_PRICE,INF_PRICE,SGL_PRICE,CUR_TYPE,EXC_RATE,FLOATING_YN,POINT_RATE,POINT_PRICE,POINT_YN,
			QCHARGE_TYPE,ADT_QCHARGE,CHD_QCHARGE,INF_QCHARGE,QCHARGE_DATE,ADT_TAX,CHD_TAX,INF_TAX
		FROM PKG_DETAIL_PRICE WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE AND PRICE_SEQ IN ( SELECT DATA FROM DBO.FN_SPLIT(@STR_PRICE_SEQ,',') )
		SET @STEP_MESSAGE = '1.가격 복사등록까지 완료'

		--가격호텔 복사등록  19.03 식사코드 추가 
		INSERT INTO PKG_MASTER_PRICE_HOTEL (MASTER_CODE,PRICE_SEQ,DAY_NUMBER,HTL_MASTER_CODE,SUP_CODE,STAY_TYPE,STAY_INFO,
			DINNER_1,DINNER_2,DINNER_3,DINNER_CODE_1,DINNER_CODE_2,DINNER_CODE_3)
		SELECT @MASTER_CODE ,@MAX_PRICE_SEQ + (DENSE_RANK() OVER ( ORDER BY PRICE_SEQ ASC )), 
			DAY_NUMBER,HTL_MASTER_CODE,SUP_CODE,STAY_TYPE,STAY_INFO,DINNER_1,DINNER_2,DINNER_3,DINNER_CODE_1,DINNER_CODE_2,DINNER_CODE_3
		FROM PKG_DETAIL_PRICE_HOTEL WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE AND PRICE_SEQ IN ( SELECT DATA FROM DBO.FN_SPLIT(@STR_PRICE_SEQ,',') )
		SET @STEP_MESSAGE = '2.가격호텔 복사등록까지 완료'

		--현지필수지불경비
		INSERT INTO PKG_MASTER_PRICE_GROUP_COST (
			MASTER_CODE,PRICE_SEQ,COST_SEQ,COST_NAME,CURRENCY,ADT_COST,CHD_COST,INF_COST,USE_YN )
		SELECT @MASTER_CODE ,@MAX_PRICE_SEQ + (DENSE_RANK() OVER ( ORDER BY PRICE_SEQ ASC )), 
			COST_SEQ,COST_NAME,CURRENCY,ADT_COST,CHD_COST,INF_COST,USE_YN 
		FROM PKG_DETAIL_PRICE_GROUP_COST WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE AND PRICE_SEQ IN ( SELECT DATA FROM DBO.FN_SPLIT(@STR_PRICE_SEQ,',') )

		SET @STEP_MESSAGE = '3.현지필수경비 복사등록까지 완료'
		
		--가격 포함/불포함(네이버) 복사 19.03 추가 
		INSERT INTO PKG_MASTER_PRICE_INOUT (MASTER_CODE,PRICE_SEQ,INOUT_CODE,IN_YN)
		SELECT @MASTER_CODE,@MAX_PRICE_SEQ + (DENSE_RANK() OVER ( ORDER BY PRICE_SEQ ASC )), 
			A.INOUT_CODE, A.IN_YN
		FROM PKG_DETAIL_PRICE_INOUT A WITH(NOLOCK)
		WHERE A.PRO_CODE = @PRO_CODE AND A.PRICE_SEQ IN ( SELECT DATA FROM DBO.FN_SPLIT(@STR_PRICE_SEQ,',') )
		SET @STEP_MESSAGE = '4.포함/불포함사항 복사등록까지 완료'

	END 
	----------------------------------------------------------------------------------------------------------------
	-- [일정]
	IF( ISNULL(@STR_SCH_SEQ,'') <> '' )
	BEGIN

		DECLARE @MAX_SCH_SEQ INT 
		SET @MAX_SCH_SEQ = ISNULL((SELECT MAX(SCH_SEQ) FROM PKG_MASTER_SCH_MASTER WITH(NOLOCK) WHERE MASTER_CODE =@MASTER_CODE),0) 

		--SELECT MAX(SCH_SEQ) FROM PKG_MASTER_SCH_MASTER WITH(NOLOCK) WHERE MASTER_CODE = @MASTER_CODE

		--일정 복사등록 
		INSERT INTO PKG_MASTER_SCH_MASTER (MASTER_CODE,SCH_SEQ,SCH_NAME)
		SELECT @MASTER_CODE, @MAX_SCH_SEQ + DENSE_RANK() OVER (ORDER BY SCH_SEQ ASC),SCH_NAME FROM PKG_DETAIL_SCH_MASTER WITH(NOLOCK)
		WHERE PRO_CODE = @PRO_CODE AND SCH_SEQ IN ( SELECT DATA FROM DBO.FN_SPLIT(@STR_SCH_SEQ,',') )
		SET @STEP_MESSAGE = '3.일정 복사등록까지 완료'

		--일정날짜 복사등록 
		INSERT INTO PKG_MASTER_SCH_DAY (MASTER_CODE,SCH_SEQ,DAY_SEQ,DAY_NUMBER,FREE_SCH_YN ) --자유일정유무 19.03 추가 
		SELECT @MASTER_CODE,@MAX_SCH_SEQ + DENSE_RANK() OVER (ORDER BY SCH_SEQ ASC),DAY_SEQ,DAY_NUMBER,FREE_SCH_YN  --자유일정유무 19.03 추가 
		FROM PKG_DETAIL_SCH_DAY WITH(NOLOCK)
		WHERE PRO_CODE = @PRO_CODE AND SCH_SEQ IN ( SELECT DATA FROM DBO.FN_SPLIT(@STR_SCH_SEQ,',') )
		SET @STEP_MESSAGE = '4.일정날짜 복사등록까지 완료'

		--일정날짜별도시 복사등록 
		INSERT INTO PKG_MASTER_SCH_CITY (MASTER_CODE,SCH_SEQ,DAY_SEQ,CITY_SEQ,CITY_CODE,MAINCITY_YN,CITY_SHOW_ORDER)
		SELECT @MASTER_CODE,@MAX_SCH_SEQ + DENSE_RANK() OVER (ORDER BY SCH_SEQ ASC),
		DAY_SEQ,CITY_SEQ,CITY_CODE,MAINCITY_YN,CITY_SHOW_ORDER FROM PKG_DETAIL_SCH_CITY WITH(NOLOCK)
		WHERE PRO_CODE = @PRO_CODE AND SCH_SEQ IN ( SELECT DATA FROM DBO.FN_SPLIT(@STR_SCH_SEQ,',') )
		SET @STEP_MESSAGE = '5.일정날짜별도시 복사등록까지  완료'

		--일정날짜별도시컨텐츠 복사등록 
		INSERT INTO PKG_MASTER_SCH_CONTENT (MASTER_CODE,SCH_SEQ,DAY_SEQ,CITY_SEQ,CNT_SEQ,CNT_CODE,CNT_INFO,CNT_SHOW_ORDER)
		SELECT @MASTER_CODE,@MAX_SCH_SEQ + DENSE_RANK() OVER (ORDER BY SCH_SEQ ASC),
		DAY_SEQ,CITY_SEQ,CNT_SEQ,CNT_CODE,CNT_INFO,CNT_SHOW_ORDER FROM PKG_DETAIL_SCH_CONTENT WITH(NOLOCK)
		WHERE PRO_CODE = @PRO_CODE AND SCH_SEQ IN ( SELECT DATA FROM DBO.FN_SPLIT(@STR_SCH_SEQ,',') )
		SET @STEP_MESSAGE = '6.일정날짜별도시컨텐츠 복사등록까지(전체완료)'

	END 
	----------------------------------------------------------------------------------------------------------------
	COMMIT TRAN    
	SELECT '' 
END TRY    
BEGIN CATCH    
	ROLLBACK TRAN    
	SELECT @STEP_MESSAGE 
END CATCH





GO
