USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_GET_CANCEL_DATE]

/*
USP_GET_CANCEL_DATE
*/

@SUPP_CODE VARCHAR(2),
@TARGET_DATE DATETIME,
@XML VARCHAR(1000)

AS


SET @TARGET_DATE = DATEADD(d, -2, @TARGET_DATE)


DECLARE @XML_DOCUMENT_HANDLE INT;                              
DECLARE @XML_DOCUMENT VARCHAR(MAX);                              
SET @XML_DOCUMENT = '<?xml version="1.0" encoding="euc-kr"?>' + @XML                                 
                            
EXEC SP_XML_PREPAREDOCUMENT @XML_DOCUMENT_HANDLE OUTPUT, @XML_DOCUMENT           
        
             
SELECT DT        
INTO #TMP_TABLE                    
FROM OPENXML (@XML_DOCUMENT_HANDLE, '/CalRQ/Cal',2)                             
WITH (                                                                                                                                            
     DT DATETIME './DT'
) A    
ORDER BY DT


--SELECT MAX(DT) AS TARGET_DATE

SELECT DT, RANK() OVER (ORDER BY DT DESC) AS SORT
INTO #TMP_CAL
FROM #TMP_TABLE A
LEFT JOIN HTL_CODE_HOLIDAY B ON A.DT=B.TARGET_DATE
WHERE DT <= @TARGET_DATE
AND B.TARGET_DATE IS NULL

--SELECT * FROM #TMP_CAL

SELECT TOP 1 A.DT AS TARGET_DATE
FROM #TMP_CAL A
JOIN #TMP_CAL B ON A.SORT+1=B.SORT
WHERE A.DT-1=B.DT


EXEC SP_XML_REMOVEDOCUMENT @XML_DOCUMENT_HANDLE 

--SELECT * FROM HTL_CODE_HOLIDAY


GO
