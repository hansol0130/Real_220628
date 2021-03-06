USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SET_PROFIT]

/*
USP_SET_PROFIT 10007
*/

@RESV_NO INT

AS

DECLARE @CARD_COST DECIMAL;
SET @CARD_COST = 0;

SELECT @CARD_COST = ISNULL(SUM(DBO.FN_GET_PAY_COMMITION(CARD_AMOUNT+CASH_AMOUNT, A.PAY_TYPE)),0)
FROM HTL_RESV_PAY A
JOIN TBL_PAY_COM_RATE B ON A.PAY_TYPE=B.PAY_TYPE
WHERE NOT (A.PAY_STATUS ='RMXX' AND A.PAY_TYPE = 'VTAC')
AND (B.COM_RATE > 0 OR B.COM_PRICE > 0)
AND A.RESV_NO=@RESV_NO
GROUP BY A.RESV_NO

DECLARE @STATUS VARCHAR(4);
DECLARE @CANCEL_AMT DECIMAL(18,0);
SELECT @STATUS = LAST_STATUS, @CANCEL_AMT=CANCEL_AMT FROM HTL_RESV_MAST WHERE RESV_NO=@RESV_NO  

IF (@STATUS IN ('RMXQ', 'RMXX') OR @CANCEL_AMT > 0)
BEGIN
	UPDATE HTL_RESV_MAST SET     
	CARD_COST=@CARD_COST,    
	COM_AMT=CANCEL_AMT - CANCEL_NET - AFF_COST - @CARD_COST
	WHERE RESV_NO=@RESV_NO
END
ELSE
BEGIN
	UPDATE HTL_RESV_MAST SET     
	CARD_COST=@CARD_COST,    
	COM_AMT=TOTAL_AMT - SUPP_NET - DSC_COST - AFF_COST - @CARD_COST - VAT_COST - COUP_COST - AIR_COST
	WHERE RESV_NO=@RESV_NO
END
GO
