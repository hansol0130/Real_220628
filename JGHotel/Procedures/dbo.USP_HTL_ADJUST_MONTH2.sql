USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_HTL_ADJUST_MONTH2]

/*
USP_HTL_ADJUST_MONTH2 'C', '2014-08-01', '2014-08-31'
*/

@TYPE VARCHAR(1), 
@DATE_FROM VARCHAR(10),
@DATE_TO VARCHAR(10),
@PARTNER_SHIP VARCHAR(10) = ''  

AS    

DECLARE @T_DATE VARCHAR(20)      
       
  IF (@TYPE = 'C')      
        
   SET @T_DATE = 'CREATE_DATE'      
         
  ELSE      
        
   SET @T_DATE = 'CHECK_IN_DATE'

DECLARE @SQL VARCHAR(MAX)      
      
SET @SQL = ''  

SET @SQL = @SQL + 'SELECT' + CHAR(13)
SET @SQL = @SQL + 'SUPP_CODE,' + CHAR(13)
SET @SQL = @SQL + 'SUM(CASE WHEN LAST_STATUS = ''RMTK'' THEN TOTAL_AMT ELSE 0 END) AS TOTAL_AMT,' + CHAR(13)
SET @SQL = @SQL + 'SUM(CASE WHEN LAST_STATUS = ''RMTK'' THEN SUPP_NET ELSE 0 END) + SUM(CASE WHEN LAST_STATUS IN (''RMXX'', ''RMXQ'') AND CANCEL_NET > 0 THEN CANCEL_NET ELSE 0 END) AS SUPP_NET,' + CHAR(13)
SET @SQL = @SQL + 'SUM(CASE WHEN LAST_STATUS = ''RMTK'' THEN COM_AMT ELSE 0 END) AS COM_AMT' + CHAR(13)
SET @SQL = @SQL + 'FROM HTL_RESV_MAST' + CHAR(13)
SET @SQL = @SQL + 'WHERE ' + @T_DATE + ' >= ''' + @DATE_FROM + ''' AND ' + @T_DATE + ' < CONVERT(DATETIME, ''' + @DATE_TO + ''') + 1' + CHAR(13)

IF(@PARTNER_SHIP <> '') SET @SQL = @SQL + ' AND MCPN_CODE = ''' + @PARTNER_SHIP + ''' ' + CHAR(13) 

SET @SQL = @SQL + 'GROUP BY SUPP_CODE' + CHAR(13)
SET @SQL = @SQL + 'ORDER BY SUPP_CODE' + CHAR(13)
	
PRINT(@SQL)    
EXEC(@SQL)


GO
