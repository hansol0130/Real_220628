USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_DOC_REFUND_LIST_INSERT
■ DESCRIPTION				: 전자결재 일괄 처리 시 환불 등록
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
	@EDI_CODE_LIST			: 전자결재 문서코드 (ex 1501076726,1412052437,1411052196)
	@RCV_CODE				: 처리자 사원코드
	@RCV_DATE				: 처리 일시
	@PAY_TYPE				: 환불 계정 구분 (0: 은행, 3: PG신용카드, 13: ARS)
	@PAY_SUB_TYPE			: 거래처코드|X (은행: X 계좌순번, PG신용카드 X 수수료)
■ EXEC						: 

	-- 각 타입별 샘플
	SELECT * FROM PAY_MASTER_DAMO WHERE PAY_SEQ IN (1285050, 1285126, 1285138)
	ORDER BY PAY_TYPE

	SELECT * FROM PAY_MATCHING WHERE PAY_SEQ IN (1285050, 1285126, 1285138)

	SELECT * FROM EDI_MASTER_DAMO WHERE EDI_CODE IN ('1501286428', '1501286348', '1501286600')
	ORDER BY (CASE EDI_CODE WHEN '1501286428' THEN 1 WHEN '1501286348' THEN 2 ELSE 3 END)


	EXEC SP_DOC_REFUND_LIST_INSERT '', '2008011', 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2015-02-04		김성호			최초생성
   2015-04-28		김성호			문서코드가 1개일때 생성 PAY_SEQ, MCH_SEQ 리턴
   2016-10-13		김성호			MAIL_ID 수동 입력
   2021-10-22		김성호			PAYSMS 추가 및 PG, ARS, PAYSMS 수수료율 통합 조회로 수정 (COD_PUBLIC 테이블 수정)
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_DOC_REFUND_LIST_INSERT]
	@EDI_CODE_LIST	VARCHAR(8000),
	@RCV_CODE		CHAR(7),
	@RCV_DATE		DATETIME,
	@PAY_TYPE		VARCHAR(5),
	@PAY_SUB_TYPE	VARCHAR(20),
	@MAIL_ID		VARCHAR(8),
	@PAY_SEQ		INT OUTPUT,
	@MCH_SEQ		INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	--DECLARE @PAY_SUB_NAME VARCHAR(50), @AGT_CODE VARCHAR(10), @ACC_SEQ INT, @PAY_METHOD INT, @PAY_NAME VARCHAR(80), @PAY_PRICE INT, @COM_RATE DECIMAL, @COM_PRICE DECIMAL

	-- PAY_MASTER 등록
	IF @PAY_TYPE = 0		-- 은행
	BEGIN
		INSERT INTO PAY_MASTER_damo (
			PAY_TYPE,		PAY_SUB_TYPE,	AGT_CODE,		ACC_SEQ,		PAY_METHOD,
			PAY_NAME,		PAY_DATE,		EDI_CODE,		NEW_CODE,		NEW_DATE,		CXL_YN,
			PAY_PRICE,		
			PAY_SUB_NAME,
			sec_PAY_NUM,
			sec1_PAY_NUM,
			MALL_ID
		)
		SELECT
			@PAY_TYPE,		C.AGT_CODE,		C.AGT_CODE,		C.ACC_SEQ,		2 /*직접방문*/,	
			A.PAY_RECEIPT,	@RCV_DATE,		A.EDI_CODE,		@RCV_CODE,		GETDATE(),		'N',
			((CASE WHEN A.REAL_PRICE = 0 THEN A.PRICE ELSE A.REAL_PRICE END) * -1),
			('[' + C.ADMIN_REMARK + '] ' + C.REG_NUMBER),
			damo.dbo.enc_varchar('DIABLO', 'dbo.PAY_MASTER', 'PAY_NUM', C.REG_NUMBER),
			damo.dbo.pred_meta_plain_v(C.REG_NUMBER, 'DIABLO', 'dbo.PAY_MASTER', 'PAY_NUM'),
			ISNULL((SELECT MALL_ID FROM PAY_MASTER_DAMO WITH(NOLOCK) WHERE PAY_SEQ = A.PAY_SEQ), @MAIL_ID)
		FROM EDI_MASTER_damo A WITH(NOLOCK)
		INNER JOIN RES_MASTER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
		CROSS JOIN (
			SELECT * FROM AGT_ACCOUNT WITH(NOLOCK)
			WHERE AGT_CODE = SUBSTRING(@PAY_SUB_TYPE, 0, CHARINDEX('|', @PAY_SUB_TYPE)) AND ACC_SEQ = SUBSTRING(@PAY_SUB_TYPE, CHARINDEX('|', @PAY_SUB_TYPE) + 1, 100)
		) C
		WHERE A.EDI_CODE IN (SELECT Data FROM FN_SPLIT(@EDI_CODE_LIST, ','))
	END
	ELSE IF @PAY_TYPE IN (3, 13, 19) -- 3: PG신용카드, 13: ARS, 19: SMSPAY
	BEGIN
		INSERT INTO PAY_MASTER_damo (
			PAY_TYPE,		PAY_SUB_TYPE,	PAY_SUB_NAME,	AGT_CODE,		ACC_SEQ,		PAY_METHOD,
			PAY_NAME,		PAY_DATE,		EDI_CODE,		NEW_CODE,		NEW_DATE,		CXL_YN,
			PAY_PRICE,
			COM_RATE,		
			COM_PRICE,
			MALL_ID
		)
		SELECT
			@PAY_TYPE,		C.PUB_CODE,		C.PUB_VALUE,	C.PUB_CODE,		1,				2,
			B.RES_NAME,		@RCV_DATE,		A.EDI_CODE,		@RCV_CODE,		GETDATE(),		'N',
			((CASE WHEN A.REAL_PRICE = 0 THEN A.PRICE ELSE A.REAL_PRICE END) * -1),
			SUBSTRING(@PAY_SUB_TYPE, CHARINDEX('|', @PAY_SUB_TYPE) + 1, 100),
			((CASE WHEN A.REAL_PRICE = 0 THEN A.PRICE ELSE A.REAL_PRICE END) / 100 * SUBSTRING(@PAY_SUB_TYPE, CHARINDEX('|', @PAY_SUB_TYPE) + 1, 100) * -1),
			ISNULL((SELECT MALL_ID FROM PAY_MASTER_DAMO WITH(NOLOCK) WHERE PAY_SEQ = A.PAY_SEQ), @MAIL_ID)
		FROM EDI_MASTER_damo A WITH(NOLOCK)
		INNER JOIN RES_MASTER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
		CROSS JOIN (
			SELECT * FROM COD_PUBLIC
			WHERE PUB_TYPE = 'PAY.FEE.ETC' AND PUB_CODE = SUBSTRING(@PAY_SUB_TYPE, 0, CHARINDEX('|', @PAY_SUB_TYPE))
		) C
		WHERE A.EDI_CODE IN (SELECT Data FROM FN_SPLIT(@EDI_CODE_LIST, ','))
	END

	-- PAY_MATCHING
	-- MCH_TYPE (0: 결제, 1: 기타) CCCF 타입만 '1'
	INSERT INTO PAY_MATCHING (PAY_SEQ, MCH_SEQ, MCH_TYPE, RES_CODE, PRO_CODE, PART_PRICE, CXL_YN, NEW_CODE,	NEW_DATE)
	SELECT B.PAY_SEQ, 1, 0, UPPER(A.RES_CODE),	UPPER(A.PRO_CODE),	B.PAY_PRICE, 'N', @RCV_CODE, @RCV_DATE
	FROM EDI_MASTER_damo A WITH(NOLOCK)
	INNER JOIN PAY_MASTER_damo B WITH(NOLOCK) ON A.EDI_CODE = B.EDI_CODE
	WHERE A.EDI_CODE IN (SELECT Data FROM FN_SPLIT(@EDI_CODE_LIST, ','))

	-- 결제 취소에 따른 예약 상태값 수정
	-- 현재 예약상태가 출발완료 이하 일때만 실행한다.
	UPDATE A SET A.EDT_CODE = @RCV_CODE, A.EDT_DATE = @RCV_DATE,
		A.RES_STATE = (CASE WHEN (DBO.FN_RES_GET_TOTAL_PRICE(A.RES_CODE) - DBO.FN_RES_GET_PAY_PRICE(A.RES_CODE)) <= 0 THEN 4 ELSE 3 END)
	FROM RES_MASTER_damo A
	INNER JOIN EDI_MASTER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
	WHERE B.EDI_CODE IN (SELECT Data FROM FN_SPLIT(@EDI_CODE_LIST, ',')) AND A.RES_STATE < 5

	-- 생성 코드 리턴
	IF LEN(@EDI_CODE_LIST) = 10
	BEGIN
		SELECT TOP 1 @PAY_SEQ = A.PAY_SEQ, @MCH_SEQ = B.MCH_SEQ
		FROM PAY_MASTER_damo A WITH(NOLOCK)
		INNER JOIN PAY_MATCHING B WITH(NOLOCK) ON A.PAY_SEQ = B.PAY_SEQ
		WHERE A.EDI_CODE = @EDI_CODE_LIST
		ORDER BY B.NEW_DATE DESC
	END

END

GO