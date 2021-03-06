USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_RES_GET_OK_COUNT]
(
	@RES_CODE VARCHAR(20)
)
RETURNS INT
AS
BEGIN

	DECLARE @COUNT INT

	SELECT @COUNT = COUNT(*) FROM RES_CUSTOMER_DAMO WITH(NOLOCK) 
	WHERE RES_CODE = @RES_CODE AND RES_STATE = 0 AND SEAT_YN = 'Y'

	RETURN (@COUNT)
END
GO
