USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_EMP_LOGIN_SELECT
■ DESCRIPTION				: EMP 로그인 정보 검색
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC SP_EMP_LOGIN_SELECT '2008011'

------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE			AUTHOR		DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2019-04-12		김성호		최초생성
	2019-12-10		박형만		개인별,팀별 대표번호 가져오기 함수 필드 추가 ( 대표번호 발송 관련 ) 
================================================================================================================*/
CREATE PROC [dbo].[SP_EMP_LOGIN_SELECT] 
	@EMP_CODE VARCHAR(7)
AS
BEGIN

	DECLARE @TEAM_LINE VARCHAR(1000) = '';

	-- 팀리스트
	WITH TEAMLIST AS 
	(
		SELECT A.TEAM_CODE, A.TEAM_NAME, A.PARENT_CODE, 0 AS STEP
		FROM EMP_TEAM A WITH(NOLOCK)
		WHERE TEAM_CODE IN (
			-- 소속팀 && 자식팀
			SELECT AA.TEAM_CODE FROM EMP_TEAM AA WITH(NOLOCK)
			INNER JOIN EMP_MASTER_damo BB WITH(NOLOCK) ON AA.TEAM_CODE = BB.TEAM_CODE
			WHERE BB.EMP_CODE = @EMP_CODE AND BB.WORK_TYPE = 1 AND AA.USE_YN = 'Y'
			UNION
			-- 내가 팀장인팀
			SELECT AA.TEAM_CODE FROM EMP_TEAM AA WITH(NOLOCK)
			WHERE AA.TEAM_EMP_CODE = @EMP_CODE AND AA.USE_YN = 'Y'
		)
		UNION ALL
		SELECT A.TEAM_CODE, A.TEAM_NAME, A.PARENT_CODE, STEP + 1
		FROM EMP_TEAM A WITH(NOLOCK)
		INNER JOIN TEAMLIST B ON A.PARENT_CODE = B.TEAM_CODE 
		WHERE A.USE_YN = 'Y'
	)
	SELECT @TEAM_LINE = (SELECT TEAM_CODE + '|' AS [text()] FROM TEAMLIST GROUP BY TEAM_CODE FOR XML PATH(''));

	-- 직원정보
	SELECT *,
		DBO.XN_EMP_GET_EMP_KEY_NUMBER( A.EMP_CODE ) AS EMP_KEY_NUMBER ,  -- 개인별 대표번호 2019-11-18 
		DBO.XN_EMP_GET_TEAM_KEY_NUMBER( A.EMP_CODE ) AS TEAM_KEY_NUMBER ,  -- 팀 대표번호 2019-11-18 
		(SELECT TEAM_NAME FROM EMP_TEAM WITH(NOLOCK) WHERE TEAM_CODE=A.TEAM_CODE) AS [TEAM_NAME],
		(SELECT PUB_VALUE FROM COD_PUBLIC WITH(NOLOCK) WHERE PUB_TYPE='EMP.DUTYTYPE' AND PUB_CODE=A.DUTY_TYPE) AS [DUTY_NAME],
		(SELECT PUB_VALUE FROM COD_PUBLIC WITH(NOLOCK) WHERE PUB_TYPE='EMP.POSTYPE' AND PUB_CODE=A.POS_TYPE) AS [DUTY_NAME],
		@TEAM_LINE AS [TEAM_LINE]
	FROM EMP_MASTER_damo A WITH(NOLOCK)
	WHERE EMP_CODE = @EMP_CODE AND WORK_TYPE = 1;

	-- 직원권한
	--WITH STEP_PUB_MENU (MENU_GROUP_CODE, PARENT_CODE, MENU_CODE, MENU_NAME, MENU_DEPTH, SORT_CODE, SORT_NAME, MENU_LINK, SHOW_YN, MENU_ORDER) AS  
	WITH STEP_PUB_MENU (MENU_GROUP_CODE, PARENT_CODE, MENU_CODE, MENU_NAME, MENU_DEPTH, SORT_CODE, MENU_LINK, SHOW_YN, MENU_ORDER) AS  
	(
		SELECT
			A.MENU_GROUP_CODE,
			A.PARENT_CODE,
			A.MENU_CODE,
			A.MENU_NAME,
			0,
			A.SORT_CODE,
			--(SELECT MENU_NAME FROM PUB_MENU WITH(NOLOCK) WHERE MENU_GROUP_CODE = A.MENU_GROUP_CODE AND MENU_CODE = A.SORT_CODE) AS [SORT_NAME],
			A.MENU_LINK,
			A.SHOW_YN,
			A.MENU_ORDER
		FROM PUB_MENU A WITH(NOLOCK)
		WHERE PARENT_CODE IS NULL --AND MENU_GROUP_CODE = @MENU_GROUP_CODE
		UNION ALL
		SELECT
			A.MENU_GROUP_CODE,
			A.PARENT_CODE,
			A.MENU_CODE,
			A.MENU_NAME,
			B.MENU_DEPTH + 1,
			A.SORT_CODE,
			--B.SORT_NAME,
			A.MENU_LINK,
			A.SHOW_YN,
			A.MENU_ORDER
		FROM PUB_MENU A WITH(NOLOCK)
		INNER JOIN STEP_PUB_MENU B ON A.MENU_GROUP_CODE = B.MENU_GROUP_CODE AND A.PARENT_CODE = B.MENU_CODE
	)
	SELECT
		A.MENU_GROUP_CODE,
		A.PARENT_CODE,  
		A.MENU_CODE,  
		A.MENU_NAME,  
		A.MENU_DEPTH,  
		A.SORT_CODE,  
		--A.SORT_NAME,  
		A.MENU_LINK,  
		B.EMP_CODE,  
		B.SELECT_YN,  
		B.INSERT_YN,  
		B.UPDATE_YN,  
		B.DELETE_YN,  
		B.MASTER_YN ,  
		A.SHOW_YN,  
		A.MENU_ORDER  
	FROM STEP_PUB_MENU A  WITH(NOLOCK) 
	INNER JOIN PUB_GRANT B WITH(NOLOCK) ON A.MENU_GROUP_CODE = B.MENU_GROUP_CODE AND A.MENU_CODE = B.MENU_CODE AND B.EMP_CODE = @EMP_CODE AND B.SELECT_YN='Y' AND A.SHOW_YN='Y'  
	ORDER BY A.MENU_GROUP_CODE, SORT_CODE, MENU_ORDER;

	

END



GO
