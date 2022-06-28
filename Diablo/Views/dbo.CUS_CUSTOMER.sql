USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[CUS_CUSTOMER] ( [CUS_NO], [CUS_ID], [CUS_PASS], [CUS_STATE], [CUS_NAME], [LAST_NAME], [FIRST_NAME], [NICKNAME], [CUS_ICON], [EMAIL], [GENDER], [SOC_NUM1], [NOR_TEL1], [NOR_TEL2], [NOR_TEL3], [COM_TEL1], [COM_TEL2], [COM_TEL3], [HOM_TEL1], [HOM_TEL2], [HOM_TEL3], [FAX_TEL1], [FAX_TEL2], [FAX_TEL3], [VISA_YN], [PASS_YN], [PASS_EXPIRE], [PASS_ISSUE], [NATIONAL], [FOREIGNER_YN], [CUS_GRADE], [ETC], [ETC2], [BIRTHDAY], [LUNAR_YN], [RCV_EMAIL_YN], [RCV_SMS_YN], [ADDRESS1], [ADDRESS2], [ZIP_CODE], [NEW_DATE], [NEW_CODE], [EDT_DATE], [EDT_CODE], [EDT_MESSAGE], [CXL_DATE], [CXL_CODE], [CXL_REMARK], [OLD_YN], [CU_YY], [CU_SEQ], [RCV_DM_YN], [POINT_CONSENT], [POINT_CONSENT_DATE], [SOC_NUM2], [PASS_NUM], [VSOC_NUM], [IPIN_DUP_INFO], [IPIN_CONN_INFO], [IPIN_ACC_DATE], [PASS_DATE], [PASS_EMP_CODE], [FAX_SEQ], [EMAIL_AGREE_DATE], [SMS_AGREE_DATE], [EMAIL_INFLOW_TYPE], [SMS_INFLOW_TYPE], [RCV_EMP_CODE], [SAFE_ID], [BIRTH_DATE] )  as select  [CUS_NO], [CUS_ID], [CUS_PASS], [CUS_STATE], [CUS_NAME], [LAST_NAME], [FIRST_NAME], [NICKNAME], [CUS_ICON], [EMAIL], [GENDER], [SOC_NUM1], [NOR_TEL1], [NOR_TEL2], [NOR_TEL3], [COM_TEL1], [COM_TEL2], [COM_TEL3], [HOM_TEL1], [HOM_TEL2], [HOM_TEL3], [FAX_TEL1], [FAX_TEL2], [FAX_TEL3], [VISA_YN], [PASS_YN], [PASS_EXPIRE], [PASS_ISSUE], [NATIONAL], [FOREIGNER_YN], [CUS_GRADE], [ETC], [ETC2], [BIRTHDAY], [LUNAR_YN], [RCV_EMAIL_YN], [RCV_SMS_YN], [ADDRESS1], [ADDRESS2], [ZIP_CODE], [NEW_DATE], [NEW_CODE], [EDT_DATE], [EDT_CODE], [EDT_MESSAGE], [CXL_DATE], [CXL_CODE], [CXL_REMARK], [OLD_YN], [CU_YY], [CU_SEQ], [RCV_DM_YN], [POINT_CONSENT], [POINT_CONSENT_DATE], [SOC_NUM2], [PASS_NUM], [VSOC_NUM], [IPIN_DUP_INFO], [IPIN_CONN_INFO], [IPIN_ACC_DATE], [PASS_DATE], [PASS_EMP_CODE], [FAX_SEQ], [EMAIL_AGREE_DATE], [SMS_AGREE_DATE], [EMAIL_INFLOW_TYPE], [SMS_INFLOW_TYPE], [RCV_EMP_CODE], [SAFE_ID], [BIRTH_DATE]  from [dbo].[CUS_CUSTOMER_root] 
GO
