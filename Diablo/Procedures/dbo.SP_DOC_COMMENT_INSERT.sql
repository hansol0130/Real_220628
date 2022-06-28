USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_DOC_COMMENT_INSERT]
	@EDI_CODE		VARCHAR(10),
	@COMMENT		NVARCHAR(MAX),
	@NEW_TYPE		char(1),
	@NEW_CODE		CHAR(7),
	@NEW_NAME		VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;
	-- 변수 선언

	DECLARE @SEQ_NO INT

	-- @SEQ_NO SET
	SELECT @SEQ_NO = ISNULL((MAX(SEQ_NO) + 1), 1) FROM EDI_COMMENT WITH(NOLOCK) WHERE EDI_CODE = @EDI_CODE
	
	-- @NEW_NAME SET
	IF @NEW_NAME IS NULL
		SELECT @NEW_NAME = KOR_NAME FROM EMP_MASTER_damo WITH(NOLOCK) WHERE EMP_CODE = @NEW_CODE
	
	--IF EXISTS(SELECT 1 FROM EDI_COMMENT WHERE EDI_CODE = @EDI_CODE)
	--	SELECT @SEQ_NO = (MAX(SEQ_NO) + 1) FROM EDI_COMMENT WHERE EDI_CODE = @EDI_CODE
	--ELSE
	--	SET @SEQ_NO = 1

	-- 결재자 정보 INSERT
	INSERT INTO EDI_COMMENT (
		EDI_CODE,		SEQ_NO,		COMMENT,	NEW_TYPE,	NEW_CODE,	NEW_NAME
	) VALUES (
		@EDI_CODE,		@SEQ_NO,	@COMMENT,	@NEW_TYPE,	@NEW_CODE,	@NEW_NAME )

END
GO