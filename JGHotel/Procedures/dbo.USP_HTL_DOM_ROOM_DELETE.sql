USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_HTL_DOM_ROOM_DELETE]

/*
USP_HTL_DOM_ROOM_DELETE '900332', '2'
*/

@HOTEL_CODE VARCHAR(50),
@ROOM_CODE VARCHAR(50)

AS


DELETE FROM HTL_DOM_INFO_ROOM_DIR
WHERE HOTEL_CODE=@HOTEL_CODE
AND ROOM_CODE=@ROOM_CODE


DELETE FROM HTL_DOM_INFO_PRICE_DIR
WHERE HOTEL_CODE=@HOTEL_CODE
AND ROOM_CODE=@ROOM_CODE
GO
