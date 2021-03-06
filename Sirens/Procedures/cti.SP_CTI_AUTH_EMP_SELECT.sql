USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_AUTH_EMP_SELECT
■ DESCRIPTION				: 사용자별 화면권한 조회
■ INPUT PARAMETER			: 
	@AUTH_ID					: 사원번호
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_AUTH_EMP_SELECT

	AUTH_ID AUTH_NAME                                          MENU_ID MENU_NAME                                          REMARK
------- -------------------------------------------------- ------- -------------------------------------------------- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
2013017 김영화                                                C001    고객검색                                               그룹단위등록
2013017 김영화                                                C002    전화약속                                               그룹단위등록


■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-11		홍영택			최초생성
   2014-12-23		곽병삼			메뉴명을 메뉴테이블(CTI_MENU) 기준으로 변경 및 LEFT OUTER JOIN을 INNER JOIN 으로 변경.
   2015-02-05		박노민			설명추가
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_AUTH_EMP_SELECT]
--DECLARE
	@AUTH_ID	VARCHAR(20)

--SET @AUTH_ID = '2012011'

AS

SELECT 
  A.AUTH_ID, 
  A.AUTH_NAME, 
  B.MENU_ID, 
  B.MENU_NAME, 
  A.REMARK
FROM Sirens.cti.CTI_AUTH A INNER JOIN Sirens.cti.CTI_MENU B
ON A.MENU_ID = B.MENU_ID
WHERE AUTH_ID = @AUTH_ID
GO
