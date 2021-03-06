USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		이규식
-- Create date: 2009-11-25
-- Description:	해당 예약의 알선수익을 구한다.
-- =============================================
CREATE FUNCTION [dbo].[FN_SET_GET_RES_PROFIT]
(
	@RES_CODE CHAR(12)
)
RETURNS MONEY
AS
BEGIN
	DECLARE	@PRO_CODE VARCHAR(20)
	DECLARE @행사알선수익 MONEY
	DECLARE @알선수익 MONEY
	DECLARE @항공수익 MONEY
	DECLARE @기타수익 MONEY
	DECLARE @기타경비 MONEY
	SELECT @PRO_CODE = PRO_CODE FROM RES_MASTER_damo WITH(NOLOCK) WHERE RES_CODE = @RES_CODE;

	SELECT
		@행사알선수익 = SALE_PRICE - (AIR_PRICE + LAND_PRICE + PERSON_PRICE + GROUP_PRICE + AIR_PROFIT + 		AIR_ETC_PRICE - AIR_ETC_PROFIT)
	 FROM VIEW_SET_COMPLETE  WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE

		SELECT
			@알선수익 = SUM(ISNULL(SALE_PRICE,0) - (ISNULL(AIR_PRICE,0) + ISNULL(LAND_PRICE,0) + ISNULL(PERSON_PRICE,0) + ISNULL(GROUP_PRICE,0) + ISNULL(AIR_PROFIT,0) + 		ISNULL(AIR_ETC_PRICE,0) - ISNULL(AIR_ETC_PROFIT,0))),
			@항공수익 = SUM(ISNULL(AIR_PROFIT,0) + ISNULL(AIR_ETC_COM_PROFIT,0) - ISNULL(AIR_ETC_COM_PRICE,0)),
			@기타수익 = SUM(ISNULL(PERSON_PROFIT,0)),
			@기타경비 = SUM(ISNULL(PERSON_ETC_PRICE,0) + ISNULL(AGENT_COM_PRICE,0) + ISNULL(PAY_COM_PRICE,0))
		 FROM FN_SET_GET_RES_COMPLETE(@RES_CODE)

	IF (@행사알선수익 < 11000)
	BEGIN
		RETURN ISNULL(@알선수익,0) + ISNULL(@항공수익,0) + ISNULL(@기타수익,0) - ISNULL(@기타경비,0)
	END

	RETURN (ISNULL(@알선수익,0)/1.1)+ ISNULL(@항공수익,0) + ISNULL(@기타수익,0) - ISNULL(@기타경비,0)
	
END


GO
