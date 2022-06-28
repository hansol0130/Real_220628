USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_BTMS_HOTEL_ROOM
■ DESCRIPTION				: BTMS 호텔 객실
■ INPUT PARAMETER			: 
	@RES_CODE				: 예약코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------
   DATE					AUTHOR				DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-05-02		저스트고강태영			최초 생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_BTMS_HOTEL_ROOM]
	@RES_CODE		VARCHAR(15)
AS 
BEGIN

SELECT * FROM RES_HTL_ROOM_DETAIL
WHERE RES_CODE = @RES_CODE

END
GO