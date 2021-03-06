USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_ESTI_SHEET_UPDATE
■ DESCRIPTION				: 평가 SHEET 추가/수정
■ INPUT PARAMETER			: 
	@SHEET_CODE				:쉬트코드
	@TITLE					:제목
	@MODIFY_FLAG			:수정가능여부
	@EMP_CODE				:직원코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXECUTE SP_CTI_ESTI_SHEET_UPDATE @SHEET_CODE, @TITLE, @MODIFY_FLAG, @EMP_CODE

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-12-13		곽병삼			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_ESTI_SHEET_UPDATE]
--DECLARE
	@SHEET_CODE		INT,
	@TITLE			VARCHAR(100),
	@MODIFY_FLAG	CHAR(1),
	@EMP_CODE		VARCHAR(7)

AS

--SET @SHEET_CODE = 2
--SET @TITLE= '테스트 평가2'
--SET @MODIFY_FLAG = 'Y'
--SET @EMP_CODE = '2012019'

BEGIN
	IF @SHEET_CODE > 0
	BEGIN
		UPDATE Sirens.cti.CTI_ESTI_SHEET
		SET	TITLE = @TITLE,
			EDT_DATE = GETDATE(),
			EDT_CODE = @EMP_CODE
		WHERE	SHEET_CODE = @SHEET_CODE
	END
	ELSE
	BEGIN
		--SHEET 추가
		INSERT INTO Sirens.cti.CTI_ESTI_SHEET
		VALUES (@TITLE,@MODIFY_FLAG,GETDATE(),@EMP_CODE,NULL,NULL)
	END
END
GO
