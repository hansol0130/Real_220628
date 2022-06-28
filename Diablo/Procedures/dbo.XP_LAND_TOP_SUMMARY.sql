USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*================================================================================================================
■ USP_NAME					: XP_LAND_TOP_SUMMARY
■ DESCRIPTION				: 랜드사 메인 상단 요약
■ INPUT PARAMETER			: 
	@EMP_CODE	CHAR(7)		: 사원코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	exec XP_LAND_TOP_SUMMARY 'L130002', '92685'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-06-11		김완기			최초생성
   2014-04-07		정지용			수정
================================================================================================================*/ 

CREATE  PROCEDURE [dbo].[XP_LAND_TOP_SUMMARY]
(
	@EMP_CODE	CHAR(7),
	@AGT_CODE	VARCHAR(10)
)
AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	DECLARE @MAIL_COUNT INT,  @TODAY_ARG_COUNT INT ,@TODAY_ARG_CANCEL_COUNT INT, @TODAY_ARG_INVOICE_COUNT INT

	SELECT @MAIL_COUNT = COUNT(*) FROM PRI_NOTE_RECEIPT WITH(NOLOCK) WHERE EMP_CODE = @EMP_CODE AND RCV_DEL_YN = 'N' AND CONFIRM_YN = 'N';

	SELECT  @TODAY_ARG_COUNT = COUNT(A.GRP_SEQ_NO)
	  FROM  ARG_DETAIL A WITH(NOLOCK)
	 INNER  JOIN ARG_MASTER B WITH(NOLOCK)
	    ON A.ARG_CODE = B.ARG_CODE AND B.AGT_CODE = @AGT_CODE
	 WHERE  A.ARG_STATUS = 1
	   AND  CONVERT(VARCHAR(10), A.NEW_DATE, 120) = CONVERT(VARCHAR(10), GETDATE(), 120)

	SELECT  @TODAY_ARG_CANCEL_COUNT = COUNT(A.GRP_SEQ_NO)
	  FROM  ARG_DETAIL A WITH(NOLOCK)
	 INNER  JOIN ARG_MASTER B WITH(NOLOCK)
	    ON A.ARG_CODE = B.ARG_CODE AND B.AGT_CODE = @AGT_CODE
	 WHERE  A.ARG_STATUS = 3
	   AND  CONVERT(VARCHAR(10), A.NEW_DATE, 120) = CONVERT(VARCHAR(10), GETDATE(), 120)

	SELECT  @TODAY_ARG_INVOICE_COUNT = COUNT(A.GRP_SEQ_NO)
	  FROM  ARG_DETAIL A WITH(NOLOCK)
	 INNER  JOIN ARG_MASTER B WITH(NOLOCK)
	    ON A.ARG_CODE = B.ARG_CODE AND B.AGT_CODE = @AGT_CODE
	 WHERE  A.ARG_STATUS = 6
	   AND  CONVERT(VARCHAR(10), A.NEW_DATE, 120) = CONVERT(VARCHAR(10), GETDATE(), 120)


	SELECT  @MAIL_COUNT AS MAIL_COUNT
	       ,@TODAY_ARG_COUNT AS TODAY_ARG_COUNT
		   ,@TODAY_ARG_CANCEL_COUNT AS TODAY_ARG_CANCEL_COUNT
		   ,@TODAY_ARG_INVOICE_COUNT AS TODAY_ARG_INVOICE_COUNT
	/*
	DECLARE @MAIL_COUNT INT,  @TODAY_ARG_COUNT INT ,@UNCONFIRM_ARG_COUNT INT ,@DAY7_PKG_COUNT INT

	SELECT @MAIL_COUNT = COUNT(*) FROM PRI_NOTE_RECEIPT WHERE EMP_CODE = @EMP_CODE AND RCV_DEL_YN = 'N' AND CONFIRM_YN = 'N';

	
	SELECT  @TODAY_ARG_COUNT = COUNT(A.GRP_SEQ_NO)
	  FROM  ARG_DETAIL A
	 INNER  JOIN ARG_MASTER B
	    ON (A.ARG_SEQ_NO = B.ARG_SEQ_NO AND B.AGT_CODE = @AGT_CODE)
	 WHERE  A.ARG_DETAIL_STATUS = 0
	   AND  CONVERT(VARCHAR(10), A.NEW_DATE, 120) = CONVERT(VARCHAR(10), GETDATE(), 120)
	   
	SELECT  @UNCONFIRM_ARG_COUNT = COUNT(A.GRP_SEQ_NO)
	  FROM  ARG_DETAIL A
	 INNER  JOIN ARG_MASTER B
	    ON (A.ARG_SEQ_NO = B.ARG_SEQ_NO AND B.AGT_CODE = @AGT_CODE)
	 WHERE  A.ARG_DETAIL_STATUS = 0
	   AND  A.CFM_CODE IS NULL


	SELECT  @MAIL_COUNT AS MAIL_COUNT
	       ,@TODAY_ARG_COUNT AS TODAY_ARG_COUNT
		   ,@UNCONFIRM_ARG_COUNT AS UNCONFIRM_ARG_COUNT
		   ,0 AS DAY7_PKG_COUNT	-- 임시
	*/
END



GO