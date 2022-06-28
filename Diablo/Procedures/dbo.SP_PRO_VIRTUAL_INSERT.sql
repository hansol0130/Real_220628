USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		이규식
-- Create date: 2009-9-25
-- Description:	실시간항공, 실시간호텔을 위한 가상의 행사생성
--2011-09-02 PRO_TYPE 추가 
-- =============================================
CREATE PROCEDURE [dbo].[SP_PRO_VIRTUAL_INSERT]
(
	@MASTER_CODE	VARCHAR(10),
	@PRO_NAME	NVARCHAR(100),
	@PRO_CODE	VARCHAR(20),
	@DEP_DATE	DATETIME,
	@NEW_CODE	CHAR(7),
	@PRO_TYPE	INT
)

AS
BEGIN
	INSERT INTO PKG_DETAIL
	(PRO_CODE, PRO_NAME, MASTER_CODE, TRANSFER_TYPE, SEAT_CODE, DEP_DATE, ARR_DATE, 
	TOUR_NIGHT, TOUR_DAY,MIN_COUNT, MAX_COUNT,
	LAST_PAY_DATE, SENDING_YN, DEP_CFM_YN, CONFIRM_YN, SHOW_YN, NEW_CODE , PRO_TYPE)
	VALUES(@PRO_CODE, @PRO_NAME, @MASTER_CODE, 3, 0, @DEP_DATE, @DEP_DATE + 1, 1, 2, 1, 999,@DEP_DATE - 1, 'N', 'N', 'Y', 'N',@NEW_CODE, @PRO_TYPE)
END
GO
