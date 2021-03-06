USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*-------------------------------------------------------------------------------------------------
■ USP_Name					: SP_RES_PKG_MASTER_MOVE  
■ Description				: 예약 이동 프로시저
■ Input Parameter			:                     
		@FROM_PRO_CODE		: 이동전 행사코드
		@FROM_RES_CODE		: 이동전 예약코드
		@TO_PRO_CODE		: 이동할 행사코드
		@TO_PRICE_SEQ		: 이동할 행사 선택 가격 순번
		@SEQ_LIST			: 출발자 순번
		@EMP_CODE			: 작업자 코드
		@EMP_TEAM_NAME		: 작업자 팀명
		@TO_RES_CODE		: 이동한 예약코드
		@ERRORCODE			: 에러 코드
		@ERRORMSG			: 에러 메세지
■ Output Parameter			:                
         @VISION_CONTENT	:
■ Output Value				:                 
■ Exec						: EXEC SP_RES_PKG_MASTER_MOVE  
■ Author					: 
■ Date						:  
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
									최초생성  
2011-12-02							예약이동시 현금영수증 내역이동(전체이동시만) 추가
2013-11-11			김성호			@SEQ_LIST VARCHAR(100) -> VARCHAR(4000) 변환
2015-03-03			김성호			주민번호 삭제, 생년월일 추가
2015-12-23			김성호			예약이동전표자동생성로직 추가
2016-06-02			김성호			환불, 페널티도 이동되도록 수정 
2018-06-20			박형만			팀명 잘리는 현상 수정 @TO_TEAM_NAME VARCHAR(20) -> VARCHAR(50)
2018-08-30			김성호			부분이동시 CUS_POINT 예약코드변경 주석
2018-09-05			정지용			부분이동시 동적쿼리 변수 선언안되어있어서 에러나는거 수정
2019-01-30			박형만			예약이동시 계좌,신용카드 결제요청내역 이동 추가   
2019-07-02			박형만			예약이동시 제휴 예약 정보 이동하기 
2019-07-25			박형만			예약이동시 제휴 예약정보 이동 시 네이버 패키지만 적용 

-------------------------------------------------------------------------------------------------*/ 
CREATE PROCEDURE [dbo].[SP_RES_PKG_MASTER_MOVE]
(
	@FROM_PRO_CODE		VARCHAR(20),
	@FROM_RES_CODE		CHAR(12),
	@TO_PRO_CODE		VARCHAR(20),
	@TO_PRICE_SEQ		INT,
	@SEQ_LIST			VARCHAR(4000),
	@EMP_CODE			CHAR(7),
	@EMP_TEAM_NAME		VARCHAR(50),
	@TO_RES_CODE		CHAR(12) OUTPUT,
	@ERRORCODE			INTEGER OUTPUT,
	@ERRORMSG			VARCHAR(1000) OUTPUT
)
AS
BEGIN

	/*
	0   - 성공
	10  - 임금마감되어 임금을 제외하고 이동
	
	// 이후부터 에러코드
	100 - 행사가 존재하지 않습니다.
	200 - 현재 상품은 예약을 이동할 수 없습니다.
	300 - 이동할 상품은 예약 추가 불가 행사입니다.
	400 - 이동할 상품의 예약가능자 수가 부족합니다.
	500 - 보험이 확정된 행사의 예약은 이동할 수 없습니다.
	999 - SQL-SERVER 에러
	*/

	BEGIN TRY

	BEGIN TRAN
	
	SELECT @ERRORCODE = 0, @ERRORMSG = ''
	
	IF NOT EXISTS(SELECT 1 FROM PKG_DETAIL WITH(NOLOCK) WHERE PRO_CODE = @FROM_PRO_CODE)
		OR NOT EXISTS(SELECT 1 FROM PKG_DETAIL WITH(NOLOCK) WHERE PRO_CODE = @TO_PRO_CODE)
	BEGIN
		SET @ERRORCODE = 100
		SET @ERRORMSG = '행사가 존재하지 않습니다.'
		
		ROLLBACK TRAN
		RETURN
	END

	-- 이동전 행사 상태 체크
	IF EXISTS(SELECT 1 FROM PKG_DETAIL WITH(NOLOCK) WHERE PRO_CODE = @FROM_PRO_CODE AND RES_EDT_YN = 'N')
	BEGIN
		SET @ERRORCODE = 200
		SET @ERRORMSG = @FROM_PRO_CODE + '은 예약수정 불가 행사입니다.'
		
		ROLLBACK TRAN
		RETURN
	END

	-- 이동할 행사 상태 체크
	IF EXISTS(SELECT 1 FROM PKG_DETAIL WITH(NOLOCK) WHERE PRO_CODE = @TO_PRO_CODE AND RES_ADD_YN = 'N')
	BEGIN
		SET @ERRORCODE = 300
		SET @ERRORMSG = @TO_PRO_CODE + '은 예약추가 불가 행사입니다.'
		
		ROLLBACK TRAN
		RETURN
	END

	-- 예약 가능 인원수 체크, 이동할 행사명, 마스터명 검색
	DECLARE @DIFF INT, @COUNT INT, @QUERY NVARCHAR(4000)
	DECLARE @DEP_DATE DATETIME, @ARR_DATE DATETIME, @LAST_PAY_DATE DATETIME
	DECLARE @TO_PRO_NAME NVARCHAR(1000), @TO_MASTER_CODE VARCHAR(10), @TO_NEW_CODE CHAR(7), @TO_TEAM_CODE VARCHAR(3), @TO_TEAM_NAME VARCHAR(50)
	DECLARE @TO_PROFIT_EMP_CODE CHAR(7)

	SELECT
		@DIFF = A.MAX_COUNT - DBO.FN_PRO_GET_RES_COUNT(A.PRO_CODE)
		, @DEP_DATE = A.DEP_DATE, @ARR_DATE = A.ARR_DATE, @LAST_PAY_DATE = A.LAST_PAY_DATE
		, @TO_PRO_NAME = A.PRO_NAME, @TO_MASTER_CODE = A.MASTER_CODE, @TO_NEW_CODE = A.NEW_CODE
		, @TO_TEAM_CODE = (SELECT TEAM_CODE FROM EMP_MASTER WHERE EMP_CODE = A.NEW_CODE)
		, @TO_TEAM_NAME = (SELECT TEAM_NAME FROM EMP_TEAM WHERE TEAM_CODE IN (SELECT TEAM_CODE FROM EMP_MASTER WHERE EMP_CODE = A.NEW_CODE))
	FROM PKG_DETAIL A WITH(NOLOCK)
	WHERE PRO_CODE = @TO_PRO_CODE

	-- 전체, 부분 이동 체크
	IF ISNULL(@SEQ_LIST, '') = ''
		SET @QUERY = N'SELECT @COUNT = COUNT(*) FROM RES_CUSTOMER_damo WITH(NOLOCK) WHERE RES_CODE = @FROM_RES_CODE AND RES_STATE = 0'
	ELSE
		SET @QUERY = N'SELECT @COUNT = COUNT(*) FROM RES_CUSTOMER_damo WITH(NOLOCK) WHERE RES_CODE = @FROM_RES_CODE AND SEQ_NO IN (' + @SEQ_LIST + N') AND RES_STATE = 0'

	EXEC SP_EXECUTESQL @QUERY, N'@FROM_RES_CODE CHAR(12),@COUNT INT OUTPUT', @FROM_RES_CODE, @COUNT OUTPUT

--	IF @DIFF < @COUNT
--	BEGIN
--		SET @ERRORCODE = 400
--		SET @ERRORMSG = @TO_PRO_CODE + '의 남은 예약가능자수가 부족합니다.'
--		
--		ROLLBACK TRAN
--		RETURN
--	END

	-- 보험 확정 여부는 Business Logic 에서 체크
	--IF EXISTS(SELECT 1 FROM PKG_DETAIL WHERE PRO_CODE = @TO_PRO_CODE AND INS_YN = 'Y')
	--BEGIN
	--	SET @ERRORCODE = 500
	--	SET @ERRORMSG = '보험이 확정된 행사의 예약은 이동할 수 없습니다.'
		
	--	ROLLBACK TRAN
	--	RETURN
	--END

	-- 예약번호 채번
	EXEC SP_RES_GET_RES_CODE 'P', @TO_RES_CODE OUTPUT;
	SELECT @TO_PROFIT_EMP_CODE = dbo.FN_RES_GET_PROFIT_CODE(@TO_PRO_CODE, SALE_EMP_CODE)
	FROM RES_MASTER_damo WITH(NOLOCK)
	WHERE RES_CODE = @FROM_RES_CODE

	INSERT INTO RES_MASTER_damo (
		RES_CODE, PRICE_SEQ, SYSTEM_TYPE, PROVIDER, MEDIUM_TYPE, AD_CODE, PRO_CODE, PRO_NAME, MASTER_CODE
		, PRO_TYPE, RES_STATE, RES_TYPE, DEP_DATE, ARR_DATE, CUS_NO, RES_NAME--, SOC_NUM1, SOC_NUM2
		, RES_EMAIL, BIRTH_DATE, GENDER
		, NOR_TEL1, NOR_TEL2, NOR_TEL3, ETC_TEL1, ETC_TEL2, ETC_TEL3, RES_ADDRESS1, RES_ADDRESS2, ZIP_CODE, MEMBER_YN
		, CUS_REQUEST, CUS_RESPONSE, ETC, TAX_YN, SENDING_REMARK, COMM_RATE
		, LAST_PAY_DATE, NEW_DATE, NEW_CODE, NEW_TEAM_CODE, NEW_TEAM_NAME, EDT_DATE, EDT_CODE
		, MOV_BEFORE_CODE, MOV_DATE, SALE_EMP_CODE, SALE_COM_CODE, SALE_TEAM_CODE, SALE_TEAM_NAME
		, CARD_PROVE
		, PROFIT_EMP_CODE, PROFIT_TEAM_CODE, PROFIT_TEAM_NAME
		--, SEC_SOC_NUM2 , SEC1_SOC_NUM2
		, IPIN_DUP_INFO
		 )
	SELECT
		@TO_RES_CODE, @TO_PRICE_SEQ, SYSTEM_TYPE, PROVIDER, MEDIUM_TYPE, AD_CODE, @TO_PRO_CODE, @TO_PRO_NAME, @TO_MASTER_CODE
		, PRO_TYPE, 1, RES_TYPE, @DEP_DATE, @ARR_DATE, CUS_NO, RES_NAME--, SOC_NUM1, NULL
		, RES_EMAIL, BIRTH_DATE, GENDER
		, NOR_TEL1, NOR_TEL2, NOR_TEL3, ETC_TEL1, ETC_TEL2, ETC_TEL3, RES_ADDRESS1, RES_ADDRESS2, ZIP_CODE, MEMBER_YN
		, CUS_REQUEST, CUS_RESPONSE, ETC, TAX_YN, SENDING_REMARK, COMM_RATE
		, @LAST_PAY_DATE, NEW_DATE, @TO_NEW_CODE, @TO_TEAM_CODE, @TO_TEAM_NAME, GETDATE(), @EMP_CODE
		, @FROM_RES_CODE, GETDATE(), SALE_EMP_CODE, SALE_COM_CODE, SALE_TEAM_CODE, SALE_TEAM_NAME
		, CARD_PROVE
		, @TO_PROFIT_EMP_CODE
		, dbo.FN_CUS_GET_EMP_TEAM_CODE(@TO_PROFIT_EMP_CODE)
		, dbo.FN_CUS_GET_EMP_TEAM(@TO_PROFIT_EMP_CODE)
		--, SEC_SOC_NUM2 , SEC1_SOC_NUM2
		, IPIN_DUP_INFO
	FROM RES_MASTER_damo WITH(NOLOCK)
	WHERE RES_CODE = @FROM_RES_CODE
	
	SET @ERRORMSG = '[예약마스터등록]'

	-- 항공, 호텔 예약
	IF EXISTS(SELECT 1 FROM RES_PKG_DETAIL WITH(NOLOCK) WHERE RES_CODE = @TO_RES_CODE)
	BEGIN
		UPDATE A SET AIR_GDS = B.AIR_GDS, HOTEL_GDS = B.HOTEL_GDS
			, AIR_ONLINE_YN = B.AIR_ONLINE_YN, HOTEL_ONLINE_YN = B.HOTEL_ONLINE_YN
		FROM RES_PKG_DETAIL A
		CROSS JOIN (SELECT * FROM RES_PKG_DETAIL WHERE RES_CODE = @FROM_RES_CODE) B
		WHERE A.RES_CODE = @TO_RES_CODE
	END
	ELSE
	BEGIN
		INSERT INTO RES_PKG_DETAIL (
			RES_CODE, AIR_GDS, HOTEL_GDS, AIR_ONLINE_YN, HOTEL_ONLINE_YN)
		SELECT
			@TO_RES_CODE, AIR_GDS, HOTEL_GDS, AIR_ONLINE_YN, HOTEL_ONLINE_YN
		FROM RES_PKG_DETAIL
		WHERE RES_CODE = @FROM_RES_CODE
	END

	-- 네이버 패키지만 제휴 예약 있을경우에 정보 고대로 이동하여줌 
	IF EXISTS ( SELECT * FROM RES_MASTER_damo WITH(NOLOCK) 
		WHERE RES_CODE = @FROM_RES_CODE AND PROVIDER = 41 )
	BEGIN
		IF EXISTS(SELECT 1 FROM RES_ALT_MATCHING WITH(NOLOCK) WHERE RES_CODE = @TO_RES_CODE)
		BEGIN
			UPDATE A SET A.ALT_NAME = B.ALT_NAME, A.ALT_CODE = B.ALT_CODE , A.ALT_RES_CODE = B.ALT_RES_CODE
				, A.ALT_PRO_URL = B.ALT_PRO_URL, A.ALT_MEM_NO = B.ALT_MEM_NO
			FROM RES_ALT_MATCHING A
			CROSS JOIN (SELECT * FROM RES_ALT_MATCHING WHERE RES_CODE = @FROM_RES_CODE) B
			WHERE A.RES_CODE = @TO_RES_CODE
		END
		ELSE
		BEGIN 
			-- 없는경우엔 새로 생성 
			INSERT INTO RES_ALT_MATCHING (
				RES_CODE,ALT_NAME,ALT_CODE,ALT_RES_CODE,NEW_CODE,NEW_DATE,ALT_PRO_URL,ALT_MEM_NO)
			SELECT
				@TO_RES_CODE, ALT_NAME,ALT_CODE,ALT_RES_CODE,@EMP_CODE ,GETDATE() AS NEW_DATE,ALT_PRO_URL,ALT_MEM_NO
			FROM RES_ALT_MATCHING
			WHERE RES_CODE = @FROM_RES_CODE
		END
	END 
	
	
	SET @ERRORMSG = '[예약마스터세부등록]'
	
	--PRINT @TO_RES_CODE

	-- 출발자이동
	EXEC DBO.SP_RES_PKG_CUSTOMER_MOVE @FROM_RES_CODE, @TO_RES_CODE, @TO_PRO_CODE, @TO_PRICE_SEQ, @SEQ_LIST, @EMP_CODE
	
	SET @ERRORMSG = '[예약출발자이동]'

	-- 예약상태코드 업데이트
	IF ISNULL(@SEQ_LIST, '') = ''	-- 전체
	BEGIN
		UPDATE RES_MASTER_damo SET RES_STATE = 8, MOV_AFTER_CODE = @TO_RES_CODE, MOV_DATE = GETDATE() WHERE RES_CODE = @FROM_RES_CODE
		UPDATE RES_CUSTOMER_damo SET RES_STATE = 2, CXL_DATE = GETDATE(), CXL_CODE = @EMP_CODE
		WHERE RES_CODE = @FROM_RES_CODE AND RES_STATE = 0

		SET @ERRORMSG = '[이전예약상태변경]'

		--IF @EMP_CODE = '2010046'
		--BEGIN
		-- 예약이동전표 생성
			EXEC DBO.SP_ACC_PAY_CHANGE_INS @FROM_PRO_CODE, @FROM_RES_CODE, @TO_PRO_CODE, @TO_RES_CODE, @EMP_CODE, @ERRORCODE OUTPUT, @ERRORMSG OUTPUT
		--END

		IF @ERRORCODE <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
		ELSE
		BEGIN
			SET @ERRORMSG = '[예약이동전표체크]'
		END

		UPDATE A SET
			A.RES_CODE = @TO_RES_CODE, A.PRO_CODE = @TO_PRO_CODE, A.EDT_DATE = GETDATE(), A.EDT_CODE = @EMP_CODE
		FROM PAY_MATCHING A
		INNER JOIN PAY_MASTER_damo B ON A.PAY_SEQ = B.PAY_SEQ
		WHERE A.RES_CODE = @FROM_RES_CODE
		AND B.PAY_TYPE NOT IN (10)  --2010.05.11 CCCF 는 입금 이동안되도록 수정
		
		SET @ERRORMSG = '[입금내역이동]'

		-- 포인트 예약번호 전체 이동
		UPDATE DBO.CUS_POINT SET RES_CODE = @TO_RES_CODE, TITLE = @TO_PRO_NAME
		WHERE RES_CODE = @FROM_RES_CODE
		
		SET @ERRORMSG = '[포인트이동]'
		
		-- 현금영수증 내역 전체 이동 
		UPDATE DBO.PAY_CASH_RECEIPT_damo 
		SET RES_CODE = @TO_RES_CODE, REMARK = @FROM_RES_CODE + '->' + @TO_RES_CODE +'이동'
		WHERE RES_CODE = @FROM_RES_CODE
	
		SET @ERRORMSG = '[현금영수증내역이동]'

		-- 결제요청 내역 가상계좌,신용카드만 이동  2019-02-22 09시적용 
		UPDATE DBO.KICC_PAY_REQUEST 
		SET RES_CODE = @TO_RES_CODE
		, ORG_RES_CODE = CASE WHEN ORG_RES_CODE IS NULL THEN @FROM_RES_CODE  ELSE ORG_RES_CODE END   -- 기존 예약코드 비었을때만 갱신 
		WHERE RES_CODE = @FROM_RES_CODE
		AND PAY_REQ_TYPE IN ( 'VACCT','CARD')  -- 가상계좌 , 카드 결제 
		AND (DEL_YN ='N' OR DEL_YN IS NULL ) -- 삭제 아니것만 
		AND REQ_EXP_DATE  > @DEP_DATE  -- 출발일 이전에 만료 되는 요청정보는 제외 

		SET @ERRORMSG = '[결제요청내역이동]'

	END
	ELSE
	BEGIN
		SET @QUERY = N'
UPDATE RES_CUSTOMER_damo SET RES_STATE = 2, CXL_DATE = GETDATE(), CXL_CODE = ''' + @EMP_CODE + N''' 
WHERE RES_CODE = @FROM_RES_CODE AND SEQ_NO IN (' + @SEQ_LIST + N') AND RES_STATE = 0'


/*		
		-- 포인트 예약번호 부분 이동
		SET @QUERY = @QUERY + N'
UPDATE DBO.CUS_POINT SET
	RES_CODE = ''' + @TO_RES_CODE + N''', TITLE = ''' + @TO_PRO_NAME + N'''
WHERE RES_CODE = ''' + @FROM_RES_CODE + N''' AND CUS_NO IN (
	SELECT CUS_NO FROM RES_CUSTOMER_damo WHERE RES_CODE = ''' + @FROM_RES_CODE + N''' AND SEQ_NO IN (' + @SEQ_LIST + N')
)'

*/
		
		EXEC SP_EXECUTESQL @QUERY, N'@FROM_RES_CODE CHAR(12)', @FROM_RES_CODE
		
	END

	-- 이동완료
	IF @ERRORCODE = 0
		COMMIT TRAN
	ELSE
		ROLLBACK TRAN

	END TRY
	BEGIN CATCH 
		SET @ERRORCODE = 999
		SET @ERRORMSG = @ERRORMSG + ERROR_MESSAGE()

		ROLLBACK TRAN
	END CATCH
END



GO
