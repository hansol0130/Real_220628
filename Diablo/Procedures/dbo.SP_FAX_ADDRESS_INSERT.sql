USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[SP_FAX_ADDRESS_INSERT]
@EMP_CODE VARCHAR(7),
@KOR_NAME VARCHAR(20),
@COM_NAME VARCHAR(20),
@FAX_NUMBER1 VARCHAR(4),
@FAX_NUMBER2 VARCHAR(4),
@FAX_NUMBER3 VARCHAR(4)
AS

BEGIN
SET NOCOUNT OFF;
DECLARE @SEQ INT;

SELECT @SEQ = isNull((MAX(SEQ) + 1),0) FROM FAX_ADDRESS WHERE EMP_CODE=@EMP_CODE


INSERT INTO FAX_ADDRESS
(EMP_CODE,SEQ,KOR_NAME,COM_NAME,FAX_NUMBER1,FAX_NUMBER2,FAX_NUMBER3)
VALUES
(@EMP_CODE,@SEQ,@KOR_NAME,@COM_NAME,@FAX_NUMBER1,@FAX_NUMBER2,@FAX_NUMBER3)

END
GO
