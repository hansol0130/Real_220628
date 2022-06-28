USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_BULK_TBL_PROG_USER]

@XML VARCHAR(MAX)

AS

DECLARE @XML_DOCUMENT_HANDLE INT;
DECLARE @XML_DOCUMENT VARCHAR(MAX);
SET @XML_DOCUMENT = '<?xml version="1.0" encoding="euc-kr"?>' + @XML

EXEC SP_XML_PREPAREDOCUMENT @XML_DOCUMENT_HANDLE OUTPUT,  @XML_DOCUMENT

SELECT *
INTO #TMP_TABLE
FROM OPENXML (@XML_DOCUMENT_HANDLE,  '/ArrayOfProgramRQ/ProgramRQ', 2)                 
WITH (  
	UserId VARCHAR(1000) './UserId',
	ProgId VARCHAR(1000) './ProgId',
	PermSel VARCHAR(1000) './PermSel',
	PermUpd VARCHAR(1000) './PermUpd',
	PermDel VARCHAR(1000) './PermDel',
	PermPrt VARCHAR(1000) './PermPrt',
	UpdateUser VARCHAR(1000) './UpdateUser'
) A


DELETE TBL_PROG_USER WHERE [USER_ID] = (SELECT TOP 1 UserId FROM #TMP_TABLE)

INSERT INTO TBL_PROG_USER
(
	USER_ID,
	PROG_ID,
	PERM_SEL,
	PERM_UPD,
	PERM_DEL,
	PERM_PRT,
	UPDATE_USER,
	UPDATE_DATE
)
SELECT UserId, ProgId, PermSel, PermUpd, PermDel, PermPrt, UpdateUser, GETDATE()
FROM #TMP_TABLE

EXEC SP_XML_REMOVEDOCUMENT @XML_DOCUMENT_HANDLE 
GO
