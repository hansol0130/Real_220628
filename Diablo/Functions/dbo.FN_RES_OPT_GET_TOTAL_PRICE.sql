USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_RES_OPT_GET_TOTAL_PRICE]
(
	@RES_CODE VARCHAR(20)
)
RETURNS INT
AS
BEGIN

	DECLARE @TOT_PRICE INT

	IF EXISTS(SELECT * FROM RES_OPT_PRODUCT  WITH(NOLOCK) WHERE RES_CODE = @RES_CODE)
	BEGIN
		SELECT @TOT_PRICE = (ISNULL(SALE_PRICE, 0) - ISNULL(DC_PRICE, 0) + ISNULL(TAX_PRICE, 0) + ISNULL(CHG_PRICE, 0) + ISNULL(PENALTY_PRICE, 0))
		FROM RES_OPT_PRODUCT A WITH(NOLOCK) 
		WHERE RES_CODE = @RES_CODE AND OPT_RES_STATE IN (0, 3, 4)
	END
	ELSE
	BEGIN
		SELECT @TOT_PRICE = 0
	END

	RETURN (@TOT_PRICE)

END
GO
