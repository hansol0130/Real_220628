USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_SMS_INSERT]
 @SEQ   INT OUTPUT,
@CODE1 VARCHAR(20),
@CODE2 VARCHAR(20),
@CODE3 VARCHAR(20),
@HP_NUMBER1 VARCHAR(4),
@HP_NUMBER2 VARCHAR(4),
@HP_NUMBER3 VARCHAR(4),
@CONTENTS VARCHAR(500),
@SEND_DATE DATETIME,
@SEND_NUMBER VARCHAR(13),
@SEND_TYPE TINYINT,
@NEW_CODE VARCHAR(7)


AS

BEGIN

INSERT INTO SMS_MASTER
(CODE1,CODE2,CODE3,HP_NUMBER1,HP_NUMBER2,HP_NUMBER3,CONTENTS,SEND_DATE,SEND_NUMBER,SEND_TYPE, NEW_CODE)
VALUES
(@CODE1,@CODE2,@CODE3,@HP_NUMBER1,@HP_NUMBER2,@HP_NUMBER3,@CONTENTS,@SEND_DATE,@SEND_NUMBER,@SEND_TYPE, @NEW_CODE)

SELECT @SEQ = @@IDENTITY 

END 

GO
