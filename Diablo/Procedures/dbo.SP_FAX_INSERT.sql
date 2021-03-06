USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_FAX_INSERT]
	@SEQ   VARCHAR(17) OUTPUT,
	@FAX_TYPE VARCHAR(1),
	@SEND_TYPE VARCHAR(1),
	@RESERVE_DATE DATETIME,
	@SUBJECT VARCHAR(100),
	--@KOR_NAME VARCHAR(20),
	@CONTENTS VARCHAR(MAX),
	--@RCV_NUMBER1 VARCHAR(4),
	--@RCV_NUMBER2 VARCHAR(4),
	--@RCV_NUMBER3 VARCHAR(4),
	@SEND_NUMBER1 VARCHAR(4),
	@SEND_NUMBER2 VARCHAR(4),
	@SEND_NUMBER3 VARCHAR(4),
	@RESERVE_YN VARCHAR(1),
	@FAX_GROUP INT,
	@PAGE_COUNT INT,
	@NEW_CODE VARCHAR(7),
	@NEW_NAME VARCHAR(20)
AS

BEGIN

SET NOCOUNT OFF;

DECLARE @FAX_SEQ VARCHAR(17)

-- 팩스코드 생성
SELECT @FAX_SEQ = ( REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(20), GETDATE(),120), '-', ''), ' ', ''), ':', '')
	 + LEFT(ABS(CHECKSUM(NEWID())), 3));

-- 팩스정보 저장
INSERT INTO FAX_MASTER (
	FAX_SEQ,FAX_TYPE,SEND_TYPE,[SUBJECT],CONTENTS,
	SEND_NUMBER1,SEND_NUMBER2,SEND_NUMBER3,
	RESERVE_YN,RESERVE_DATE,NEW_CODE,NEW_DATE,NEW_NAME,PAGE_COUNT,FAX_GROUP,READ_YN)
VALUES (
	@FAX_SEQ,@FAX_TYPE,@SEND_TYPE,@SUBJECT,@CONTENTS,
	@SEND_NUMBER1,@SEND_NUMBER2,@SEND_NUMBER3,
	@RESERVE_YN,@RESERVE_DATE,@NEW_CODE,getdate(),@NEW_NAME,@PAGE_COUNT,@FAX_GROUP,'N'
)

SET @SEQ = @FAX_SEQ

END


--SELECT
--	@FAX_SEQ = CONVERT(CHAR(8), GETDATE(),112) + cast(DATEPART(HOUR,GETDATE()) as varchar) + CAST(DATEPART(MINUTE,GETDATE()) AS VARCHAR)
--  + CAST( DATEPART(SECOND,GETDATE()) AS VARCHAR)  + CAST(RIGHT(RAND(),9) AS VARCHAR);

--중복된 SEQ가 간혹 나와서 추가진행함(2009-08-27)
--WHILE(EXISTS(SELECT 1 FROM FAX_MASTER WHERE FAX_SEQ = @FAX_SEQ))
--BEGIN
--	SELECT REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(20), GETDATE(),120), '-', ''), ' ', ''), ':', '') + LEFT(ABS(CHECKSUM(NEWID())), 3)
--	--SELECT   @FAX_SEQ =   CONVERT(CHAR(8), GETDATE(),112) + cast(DATEPART(HOUR,GETDATE()) as varchar) + CAST(DATEPART(MINUTE,GETDATE()) AS VARCHAR)
-- -- + CAST( DATEPART(SECOND,GETDATE()) AS VARCHAR)  + CAST(RIGHT(RAND(),9) AS VARCHAR);
--END
GO
