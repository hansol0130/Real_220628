USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
-- 2012-03-02 WITH(NOLOCK) 추가 	
*/
CREATE FUNCTION [dbo].[FN_AIR_GET_IATA_PRICE_2]
(
	@DEP_CITY_CODE CHAR(3),
	@ARR_CITY_CODE CHAR(3),
	@BKG_CLASS CHAR(1),
	@AIRLINE_CODE CHAR(2),
	@START_DATE DATETIME,
	@IATA_BASIS VARCHAR(20)
)

RETURNS INT
AS
BEGIN

	DECLARE @PRICE INT;
	DECLARE @COUNT INT;
	DECLARE @TEMP_IATA2 TABLE (IATA_NO INT, BKG_CLASS CHAR(1), IATA_PRICE MONEY);

	WITH TEMP_IATA AS
	(
		SELECT 
			A.IATA_NO, A.BKG_CLASS, A.PRICE
		FROM FARE_IATA A WITH(NOLOCK)
		WHERE 
			A.DEP_CITY_CODE = DBO.FN_AIR_GET_CITY_CODE(@DEP_CITY_CODE)
			AND A.ARR_CITY_CODE = DBO.FN_AIR_GET_CITY_CODE(@ARR_CITY_CODE)
			AND A.AIRLINE_CODE = @AIRLINE_CODE
			AND A.IATA_BASIS = @IATA_BASIS
			AND SUBSTRING(WEEKDAY, DATEPART(DW, @START_DATE) , 1) = '1'
			--AND	GETDATE() BETWEEN ISNULL(A.START_DATE, DATEADD(DAY, -1, GETDATE())) AND ISNULL(A.END_DATE, DATEADD(DAY, 1, GETDATE()))
			AND A.START_DATE <= @START_DATE
			AND A.END_DATE >= @START_DATE
			AND A.SHOW_YN = 'Y'
	)
	INSERT INTO @TEMP_IATA2
	SELECT * FROM TEMP_IATA;

	IF @@ROWCOUNT > 1
	BEGIN
		-- 검색건수가 1건 이상일경우 요금의 FARE_BASIS의 첫자와 IATA의 부킹 클래스를 다시 비교한다.
		SELECT @COUNT = COUNT(*) FROM @TEMP_IATA2 A
		WHERE A.BKG_CLASS = @BKG_CLASS

		-- 그래도 검색결과가 2건 이상일 경우에는 0을 돌려준다.
		IF @COUNT > 1 SET @PRICE = 0
		ELSE
		BEGIN
			-- 검색건수가 1건 이상일경우 요금의 FARE_BASIS의 첫자와 IATA의 부킹 클래스를 다시 비교한다.
			SELECT @PRICE = IATA_PRICE FROM @TEMP_IATA2 A
			WHERE A.BKG_CLASS = @BKG_CLASS
		END
	END
	ELSE
	BEGIN
		SELECT @PRICE = A.IATA_PRICE FROM @TEMP_IATA2 A
	END

	RETURN ISNULL(@PRICE, 0)
END
GO