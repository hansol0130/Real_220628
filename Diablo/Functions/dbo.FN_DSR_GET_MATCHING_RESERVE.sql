USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- 2012-03-02 WITH(NOLOCK) 추가 
-- =============================================
CREATE FUNCTION [dbo].[FN_DSR_GET_MATCHING_RESERVE]
(	
	-- Add the parameters for the function here
	@PRO_CODE VARCHAR(20),
	@ENG_NAME VARCHAR(100)
)
RETURNS @RESERVE_TABLE TABLE 
(
	RES_CODE	VARCHAR(20),
	SEQ_NO		INT
)
AS
BEGIN

	DECLARE @COUNT INT

	SELECT @COUNT = COUNT(*) FROM RES_CUSTOMER A WITH(NOLOCK)
	INNER JOIN RES_MASTER B WITH(NOLOCK) ON B.RES_CODE = A.RES_CODE
	WHERE 
	B.PRO_CODE = @PRO_CODE AND A.RES_STATE NOT IN (1,2) AND
	(
DBO.FN_AIR_GET_PAX_NAME(ISNULL(A.LAST_NAME, '') + ISNULL(A.FIRST_NAME, '')) = DBO.FN_AIR_GET_PAX_NAME(ISNULL(@ENG_NAME, ''))
OR
DBO.FN_AIR_GET_PAX_NAME(ISNULL(A.FIRST_NAME, '') + ISNULL(A.LAST_NAME, '')) = DBO.FN_AIR_GET_PAX_NAME(ISNULL(@ENG_NAME, ''))
	)

	IF @COUNT IS NULL 
	BEGIN
		RETURN
	END
	ELSE IF @COUNT > 1 OR @COUNT = 0
	BEGIN
		RETURN
	END
	ELSE BEGIN
		INSERT INTO @RESERVE_TABLE(RES_CODE, SEQ_NO)
		SELECT RES_CODE, SEQ_NO FROM RES_CUSTOMER A
		WHERE 
		RES_CODE IN (SELECT RES_CODE FROM RES_MASTER WHERE PRO_CODE = @PRO_CODE)
		AND A.RES_STATE NOT IN (1,2) AND
		(
DBO.FN_AIR_GET_PAX_NAME(ISNULL(A.LAST_NAME, '') + ISNULL(A.FIRST_NAME, '')) = DBO.FN_AIR_GET_PAX_NAME(ISNULL(@ENG_NAME, ''))
OR
DBO.FN_AIR_GET_PAX_NAME(ISNULL(A.FIRST_NAME, '') + ISNULL(A.LAST_NAME, '')) = DBO.FN_AIR_GET_PAX_NAME(ISNULL(@ENG_NAME, ''))
		)
		ORDER BY RES_CODE, SEQ_NO
	END

	RETURN 
END


GO
