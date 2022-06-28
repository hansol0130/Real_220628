USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_PKG_MASTER_PRICE_COPY_INSERT
■ DESCRIPTION				: 행사 마스터 가격 & 일정 복사
■ INPUT PARAMETER			: 
	@FROM_MASTER_CODE		: 기준 마스터코드
	@FROM_PRICE_SEQ			: 기준 가격순번
	@TO_MASTER_CODE			: 대상 마스터

■ OUTPUT PARAMETER			: 
	@MESSAGE				: 에러메세지

■ EXEC						: 

	exec SP_PKG_MASTER_PRICE_COPY_INSERT 'XXX001', 1, 'XXX002', '2008011'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2015-04-01		김성호			최초생성
   2019-03-15		박형만			네이버 관련 컬럼 추가 
   2020-03-24		김성호			트리거 예외처리 추가 (트리거에 CONTEXT_INFO() 체크하여 트리거 무시하는 로직 추가 필요)
================================================================================================================*/ 
CREATE  PROCEDURE [dbo].[SP_PKG_MASTER_PRICE_COPY_INSERT]
(
	@FROM_MASTER_CODE	VARCHAR(10),
	@FROM_PRICE_SEQ		INT,
	@TO_MASTER_CODE		VARCHAR(10)
)
AS  
BEGIN
	
	-- 트리거 동작 제외
	SET CONTEXT_INFO 0x21884680;


	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @MESSAGE NVARCHAR(1000);

	-- 마스터코드가 존재하고 마스터코드의 일자가 같아야 복사를 시작한다.
	IF EXISTS(SELECT 1 FROM PKG_MASTER A CROSS JOIN PKG_MASTER B WHERE A.MASTER_CODE = @FROM_MASTER_CODE AND B.MASTER_CODE = @TO_MASTER_CODE AND A.TOUR_DAY = B.TOUR_DAY)
	BEGIN
		BEGIN TRAN;

		BEGIN TRY

			DECLARE @FROM_SCH_SEQ INT, @TO_PRICE_SEQ INT, @TO_SCH_SEQ INT;

			SELECT @FROM_SCH_SEQ = SCH_SEQ FROM PKG_MASTER_PRICE A WHERE A.MASTER_CODE = @FROM_MASTER_CODE AND A.PRICE_SEQ = @FROM_PRICE_SEQ;
			SELECT @TO_PRICE_SEQ = (ISNULL(MAX(PRICE_SEQ), 0) + 1) FROM PKG_MASTER_PRICE A WHERE A.MASTER_CODE = @TO_MASTER_CODE;
			SELECT @TO_SCH_SEQ = (ISNULL(MAX(SCH_SEQ), 0) + 1) FROM PKG_MASTER_SCH_MASTER A WHERE A.MASTER_CODE = @TO_MASTER_CODE;

			-- 행사마스터 가격정보
			INSERT INTO PKG_MASTER_PRICE (
				MASTER_CODE, PRICE_SEQ, PRICE_NAME, SEASON, SCH_SEQ, PKG_INCLUDE, PKG_NOT_INCLUDE, ADT_PRICE, CHD_PRICE, INF_PRICE, SGL_PRICE, CUR_TYPE, EXC_RATE, FLOATING_YN, POINT_RATE, POINT_PRICE, POINT_YN, 
				QCHARGE_TYPE, ADT_QCHARGE, CHD_QCHARGE, INF_QCHARGE, QCHARGE_DATE, ADT_TAX, CHD_TAX, INF_TAX
			)
			SELECT
				@TO_MASTER_CODE, @TO_PRICE_SEQ, PRICE_NAME, SEASON, @TO_SCH_SEQ, PKG_INCLUDE, PKG_NOT_INCLUDE, ADT_PRICE, CHD_PRICE, INF_PRICE, SGL_PRICE, CUR_TYPE, EXC_RATE, FLOATING_YN, POINT_RATE, POINT_PRICE, 
				POINT_YN, QCHARGE_TYPE, ADT_QCHARGE, CHD_QCHARGE, INF_QCHARGE, QCHARGE_DATE, ADT_TAX, CHD_TAX, INF_TAX
			FROM PKG_MASTER_PRICE A
			WHERE A.MASTER_CODE = @FROM_MASTER_CODE AND A.PRICE_SEQ = @FROM_PRICE_SEQ
			
			-- 행사마스터 호텔정보 --식사코드 19.03 
			INSERT INTO PKG_MASTER_PRICE_HOTEL (
				MASTER_CODE, PRICE_SEQ, DAY_NUMBER, HTL_MASTER_CODE, SUP_CODE, STAY_TYPE, STAY_INFO, DINNER_1, DINNER_2, DINNER_3,
				DINNER_CODE_1,DINNER_CODE_2,DINNER_CODE_3
			)
			SELECT
				@TO_MASTER_CODE, @TO_PRICE_SEQ, DAY_NUMBER, HTL_MASTER_CODE, SUP_CODE, STAY_TYPE, STAY_INFO, DINNER_1, DINNER_2, DINNER_3,
				DINNER_CODE_1,DINNER_CODE_2,DINNER_CODE_3
			FROM PKG_MASTER_PRICE_HOTEL A
			WHERE A.MASTER_CODE = @FROM_MASTER_CODE AND A.PRICE_SEQ = @FROM_PRICE_SEQ

			-- 행사마스터 공동경비
			INSERT INTO PKG_MASTER_PRICE_GROUP_COST (
				MASTER_CODE, PRICE_SEQ, COST_SEQ, COST_NAME, CURRENCY, ADT_COST, CHD_COST, INF_COST, USE_YN
			)
			SELECT
				@TO_MASTER_CODE, @TO_PRICE_SEQ, COST_SEQ, COST_NAME, CURRENCY, ADT_COST, CHD_COST, INF_COST, USE_YN
			FROM PKG_MASTER_PRICE_GROUP_COST A
			WHERE A.MASTER_CODE = @FROM_MASTER_CODE AND A.PRICE_SEQ = @FROM_PRICE_SEQ

			--가격 포함/불포함(네이버) 복사 19.03 추가 
			INSERT INTO PKG_MASTER_PRICE_INOUT (MASTER_CODE,PRICE_SEQ,INOUT_CODE,IN_YN)
			SELECT @TO_MASTER_CODE, @TO_PRICE_SEQ, A.INOUT_CODE, A.IN_YN
			FROM PKG_MASTER_PRICE_INOUT A WITH(NOLOCK)
			WHERE A.MASTER_CODE = @FROM_MASTER_CODE AND A.PRICE_SEQ = @FROM_PRICE_SEQ 

			-- 행사마스터 일정마스터
			INSERT INTO PKG_MASTER_SCH_MASTER (MASTER_CODE, SCH_SEQ, SCH_NAME)
			SELECT @TO_MASTER_CODE, @TO_SCH_SEQ, A.SCH_NAME
			FROM PKG_MASTER_SCH_MASTER A
			WHERE A.MASTER_CODE = @FROM_MASTER_CODE AND A.SCH_SEQ = @FROM_SCH_SEQ

			-- 행사마스터 일자
			INSERT INTO PKG_MASTER_SCH_DAY (MASTER_CODE, SCH_SEQ, DAY_SEQ, DAY_NUMBER ,FREE_SCH_YN) -- 자유일정 유무 19.03 추가 
			SELECT @TO_MASTER_CODE, @TO_SCH_SEQ, A.DAY_SEQ, A.DAY_NUMBER , A.FREE_SCH_YN 
			FROM PKG_MASTER_SCH_DAY A
			WHERE A.MASTER_CODE = @FROM_MASTER_CODE AND A.SCH_SEQ = @FROM_SCH_SEQ

			-- 행사마스터 도시
			INSERT INTO PKG_MASTER_SCH_CITY (MASTER_CODE, SCH_SEQ, DAY_SEQ, CITY_SEQ, CITY_CODE, MAINCITY_YN, CITY_SHOW_ORDER)
			SELECT @TO_MASTER_CODE, @TO_SCH_SEQ, A.DAY_SEQ, A.CITY_SEQ, A.CITY_CODE, A.MAINCITY_YN, A.CITY_SHOW_ORDER
			FROM PKG_MASTER_SCH_CITY A
			WHERE A.MASTER_CODE = @FROM_MASTER_CODE AND A.SCH_SEQ = @FROM_SCH_SEQ

			-- 행사마스터 컨텐츠
			INSERT INTO PKG_MASTER_SCH_CONTENT (MASTER_CODE, SCH_SEQ, DAY_SEQ, CITY_SEQ, CNT_SEQ, CNT_CODE, CNT_INFO, CNT_SHOW_ORDER)
			SELECT @TO_MASTER_CODE, @TO_SCH_SEQ, A.DAY_SEQ, A.CITY_SEQ, A.CNT_SEQ, A.CNT_CODE, A.CNT_INFO, A.CNT_SHOW_ORDER
			FROM PKG_MASTER_SCH_CONTENT A
			WHERE A.MASTER_CODE = @FROM_MASTER_CODE AND A.SCH_SEQ = @FROM_SCH_SEQ

			IF @@TRANCOUNT > 0
				COMMIT TRAN
		END TRY
		BEGIN CATCH

			IF @@TRANCOUNT > 0
				ROLLBACK TRAN

			SET @MESSAGE = ERROR_MESSAGE();

		END CATCH
	END
	ELSE
	BEGIN
		SET @MESSAGE = '두 마스터의 일정이 동일하지 않습니다.'
	END
	
	-- 트리거 예외처리 후 마스터 업데이트
	EXEC DBO.SP_PKG_MASTER_RESETTING @TO_MASTER_CODE;

	-- 결과리턴
	SELECT @MESSAGE;

END


GO
