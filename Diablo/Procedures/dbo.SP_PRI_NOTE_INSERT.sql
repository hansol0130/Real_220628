USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<문태중>
-- Create date: <2008-06-19>
-- Description:	<전자결제에서 메일보내기 프로시저>
-- Edit History: <2010-05-27 SET NOCOUNT ON 제거 >
-- Edit History: <2013-03-22 Insert 컬럼명 기입 >
-- Edit History: <2014-12-24 정지용 : 랜드사명도 같이 조회되도록 수정 >
-- =============================================
CREATE PROCEDURE [dbo].[SP_PRI_NOTE_INSERT]
	@EMP_CODE VARCHAR(100),	
	@SEND_CAT_SEQ_NO INT,	
	@CONTENTS nVARCHAR(MAX),
	@SUBJECT VARCHAR(300),
	@NEW_CODE VARCHAR(7)
AS
BEGIN	
	--SET NOCOUNT ON;

	DECLARE @TEAM_NAME VARCHAR(50);
	DECLARE @SEQ_NO INT;
	--SET @TEAM_NAME = (SELECT B.TEAM_NAME FROM EMP_MASTER A INNER JOIN EMP_TEAM B ON A.TEAM_CODE = B.TEAM_CODE WHERE A.EMP_CODE = @EMP_CODE);
	SET @TEAM_NAME = (
		SELECT TOP 1 B.TEAM_NAME FROM EMP_MASTER A INNER JOIN EMP_TEAM B ON A.TEAM_CODE = B.TEAM_CODE WHERE A.EMP_CODE = @EMP_CODE
		UNION ALL
		SELECT TOP 1 B.AGT_NAME FROM AGT_MEMBER A INNER JOIN AGT_MASTER B ON A.AGT_CODE = B.AGT_CODE WHERE A.MEM_CODE = @EMP_CODE
	);

	INSERT PRI_NOTE (SUBJECT, CONTENTS, NEW_CODE, NEW_DATE)
	SELECT @SUBJECT, @CONTENTS, @NEW_CODE, GETDATE()
	SET @SEQ_NO = @@IDENTITY
	INSERT PRI_NOTE_RECEIPT (NOTE_SEQ_NO, RCV_TYPE, EMP_CODE, CONFIRM_DATE, SEND_DEL_YN, TEAM_NAME, RCV_CAT_SEQ_NO, CONFIRM_YN, RCV_SEQ_NO, RCV_DEL_YN, SEND_CAT_SEQ_NO)
	SELECT @SEQ_NO, 1, @EMP_CODE, NULL,'N',@TEAM_NAME,0,'N',1,'N',0
END
GO