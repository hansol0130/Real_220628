USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[EMP_MASTER] ( [EMP_CODE], [KOR_NAME], [ENG_FIRST_NAME], [ENG_LAST_NAME], [SOC_NUMBER1], [GENDER], [PASSWORD], [TEAM_CODE], [GROUP_CODE], [WORK_TYPE], [DUTY_TYPE], [POS_TYPE], [JOIN_TYPE], [JOIN_DATE], [OUT_DATE], [EMAIL], [EMAIL_PASSWORD], [MESSENGER], [INNER_NUMBER1], [INNER_NUMBER2], [INNER_NUMBER3], [ZIP_CODE], [ADDRESS1], [ADDRESS2], [TEL_NUMBER1], [TEL_NUMBER2], [TEL_NUMBER3], [HP_NUMBER1], [HP_NUMBER2], [HP_NUMBER3], [FAX_NUMBER1], [FAX_NUMBER2], [FAX_NUMBER3], [GREETING], [PASSPORT], [PASS_EXPIRE_DATE], [NEW_CODE], [NEW_DATE], [EDT_CODE], [EDT_DATE], [BIRTH_DATE], [SALARY_CLASS], [MATE_NUMBER], [GROUP_TYPE], [ACC_OUT_YN], [CH_NUM], [RECORD_YN], [MY_AREA], [SIGN_CODE], [CTI_USE_YN], [SOC_NUMBER2], [MATE_NUMBER2], [MAIN_NUMBER1], [MAIN_NUMBER2], [MAIN_NUMBER3], [IN_USE_YN], [FALE_COUNT], [BLOCK_YN] )  as select  [EMP_CODE], [KOR_NAME], [ENG_FIRST_NAME], [ENG_LAST_NAME], [SOC_NUMBER1], [GENDER], [PASSWORD], [TEAM_CODE], [GROUP_CODE], [WORK_TYPE], [DUTY_TYPE], [POS_TYPE], [JOIN_TYPE], [JOIN_DATE], [OUT_DATE], [EMAIL], [EMAIL_PASSWORD], [MESSENGER], [INNER_NUMBER1], [INNER_NUMBER2], [INNER_NUMBER3], [ZIP_CODE], [ADDRESS1], [ADDRESS2], [TEL_NUMBER1], [TEL_NUMBER2], [TEL_NUMBER3], [HP_NUMBER1], [HP_NUMBER2], [HP_NUMBER3], [FAX_NUMBER1], [FAX_NUMBER2], [FAX_NUMBER3], [GREETING], [PASSPORT], [PASS_EXPIRE_DATE], [NEW_CODE], [NEW_DATE], [EDT_CODE], [EDT_DATE], [BIRTH_DATE], [SALARY_CLASS], [MATE_NUMBER], [GROUP_TYPE], [ACC_OUT_YN], [CH_NUM], [RECORD_YN], [MY_AREA], [SIGN_CODE], [CTI_USE_YN], [SOC_NUMBER2], [MATE_NUMBER2], [MAIN_NUMBER1], [MAIN_NUMBER2], [MAIN_NUMBER3], [IN_USE_YN], [FALE_COUNT], [BLOCK_YN]  from [dbo].[EMP_MASTER_root] 
GO
