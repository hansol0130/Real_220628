USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- =============================================
-- Author:권윤경
-- Create date: 2008-03-20
-- Description:	쪽지 카테고리 생성 SP
--2011-07-19 SP_COD_GETSEQ -> SP_COD_GETSEQ_UNLIMITED 사용으로 변경

CREATE PROCEDURE [dbo].[SP_NOTE_CATEGORY_INSERT]
	@EMP_CODE VARCHAR(7),
	@NAME VARCHAR(50)
AS

BEGIN

 	SET NOCOUNT ON;
	DECLARE @CAT_SEQ INT;
	
	BEGIN
		
		EXEC	[dbo].[SP_COD_GETSEQ_UNLIMITED] 'NOT', @CAT_SEQ OUTPUT


	
		INSERT INTO PUB_NOTE_CATEGORY
			(CAT_SEQ_NO,EMP_CODE,NAME)
		VALUES
			(@CAT_SEQ,@EMP_CODE,@NAME)
	END
END
GO
