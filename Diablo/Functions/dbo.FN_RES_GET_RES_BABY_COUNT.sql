USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[FN_RES_GET_RES_BABY_COUNT]
(
	@RES_CODE VARCHAR(20)
)
RETURNS INT
AS
BEGIN

	DECLARE @COUNT INT

	SELECT @COUNT = COUNT(*) FROM RES_CUSTOMER_DAMO A WITH(NOLOCK)
	INNER JOIN RES_MASTER_DAMO B  WITH(NOLOCK) ON B.RES_CODE = A.RES_CODE
	WHERE B.RES_CODE = @RES_CODE AND A.RES_STATE <= 7 AND A.RES_STATE IN (0, 3) AND AGE_TYPE = 2

	RETURN (@COUNT)
END

GO
