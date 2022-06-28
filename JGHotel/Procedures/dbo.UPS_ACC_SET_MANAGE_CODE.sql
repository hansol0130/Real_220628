USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UPS_ACC_SET_MANAGE_CODE]

@XML VARCHAR(MAX)

/*
UPS_ACC_SET_MANAGE_CODE '<XML />'
*/

AS

DECLARE @XML_DOCUMENT_HANDLE INT;
DECLARE @XML_DOCUMENT VARCHAR(MAX);
SET @XML_DOCUMENT = '<?xml version="1.0" encoding="euc-kr"?>' + @XML

EXEC SP_XML_PREPAREDOCUMENT @XML_DOCUMENT_HANDLE OUTPUT,  @XML_DOCUMENT

SELECT *
INTO #TMP_TABLE
FROM OPENXML (@XML_DOCUMENT_HANDLE,  '/ArrayOfManageCodeRS/ManageCodeRS', 2)                 
WITH (  
	MCode VARCHAR(1000) './MCode',  
	SCode VARCHAR(1000) './SCode',  
	CodeDesc VARCHAR(1000) './CodeDesc',  
	CCode1 VARCHAR(1000) './CCode1', 
	CCode2 VARCHAR(1000) './CCode2',
	UseYn VARCHAR(1000) './UseYn'
) A


DECLARE @CNT INT;
SELECT @CNT = COUNT(*) FROM #TMP_TABLE

IF (@CNT > 100)
BEGIN
	DELETE FROM ACC_CODE_MANAGE WHERE M_CODE <> '00'

	INSERT ACC_CODE_MANAGE
	SELECT MCode, SCode, CodeDesc, CCode1, CCode2, UseYn
	FROM #TMP_TABLE
END

EXEC SP_XML_REMOVEDOCUMENT @XML_DOCUMENT_HANDLE 
GO