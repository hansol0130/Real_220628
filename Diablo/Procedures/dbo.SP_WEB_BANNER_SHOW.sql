USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
2012-02-23 박형만 홈페이지 배너 노출 조회 
2012-04-12 박형만 홈페이지 배너타입 조건 추가 ,정렬조건추가
*/
CREATE PROCEDURE [dbo].[SP_WEB_BANNER_SHOW] 
@BNR_TYPE INT 
AS 
SELECT * FROM PUB_BANNER WITH(NOLOCK)
WHERE GETDATE()
	BETWEEN CONVERT(DATETIME,ISNULL(START_DATE, '1900-01-01') +' '+ ISNULL(START_TIME, '00:00:00') )
		AND CONVERT(DATETIME,ISNULL(END_DATE, '2999-12-31')  +' '+ ISNULL(END_TIME, '23:59:59')  )
AND SUBSTRING(CONVERT(VARCHAR(20), GETDATE(), 120), 12, 8) 
	BETWEEN ISNULL(DAY_START_TIME, '00:00:00')
		AND ISNULL(DAY_END_TIME, '23:59:59')  
AND SUBSTRING(ISNULL(SHOW_DAY, '1111111'), DATEPART(DW, GETDATE()), 1) = 1  
AND IS_USE = 1
AND BNR_TYPE = @BNR_TYPE
ORDER BY ORDER_NO, BNR_SEQ DESC 
GO