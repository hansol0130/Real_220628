USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_REPORT_POLL_ANSWER_UPDATE
■ DESCRIPTION				: 대외업무시스템 인솔자관리 출장보고서 POLL ANSWER 수정
■ INPUT PARAMETER			: 
	@OTR_POL_MASTER_SEQ            int                 -- (PK) 
   , @OTR_POL_QUESTION_SEQ          int                 -- (PK) 
   , @QUS_TYPE                      char(1)             --  
   , @QUESTION_TITLE                varchar(400)        --  
   , @NEW_CODE                      char(7)             --  
■ OUTPUT PARAMETER			: 

■ EXEC						: 
	
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-09		오인규			최초생성
   2014-05-16		김성호			ANSWER_TEXT 형 변환 (800 -> 2000)
================================================================================================================*/ 
 CREATE PROCEDURE [dbo].[XP_ASG_EVT_REPORT_POLL_ANSWER_UPDATE] 
 ( 
    @OTR_POL_MASTER_SEQ            int                 -- (PK) 
   , @OTR_POL_QUESTION_SEQ              int                 -- (PK) 
   , @OTR_POL_ANSWER_SEQ            int                 -- (PK) 
   , @OTR_POL_EXAMPLE_SEQ           int                 --  
   , @ANSWER_TEXT                   varchar(2000)        --  
   , @NEW_CODE                      char(7)             --  
 
) 
AS 
BEGIN 

 UPDATE dbo.OTR_POL_ANSWER 
      SET  
          OTR_POL_EXAMPLE_SEQ            = @OTR_POL_EXAMPLE_SEQ, 
          ANSWER_TEXT                    = @ANSWER_TEXT, 
          EDT_DATE                       = GETDATE(), 
          EDT_CODE                       = @NEW_CODE   
    WHERE OTR_POL_MASTER_SEQ = @OTR_POL_MASTER_SEQ 
      AND OTR_POL_QUESTION_SEQ = @OTR_POL_QUESTION_SEQ 
      AND OTR_POL_ANSWER_SEQ = @OTR_POL_ANSWER_SEQ 


END 
GO
