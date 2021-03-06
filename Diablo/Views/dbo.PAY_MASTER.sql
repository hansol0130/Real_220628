USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[PAY_MASTER] ( [PAY_SEQ], [PAY_TYPE], [PAY_SUB_TYPE], [PAY_SUB_NAME], [AGT_CODE], [ACC_SEQ], [PAY_METHOD], [PAY_NAME], [PAY_PRICE], [COM_RATE], [COM_PRICE], [PAY_DATE], [PAY_REMARK], [ADMIN_REMARK], [CUS_NO], [INSTALLMENT], [EDI_CODE], [CLOSED_CODE], [CLOSED_YN], [CLOSED_DATE], [NEW_CODE], [NEW_DATE], [EDT_CODE], [EDT_DATE], [CXL_YN], [CXL_DATE], [CXL_CODE], [PAY_NUM], [PG_APP_NO], [MALL_ID] )  as select  [PAY_SEQ], [PAY_TYPE], [PAY_SUB_TYPE], [PAY_SUB_NAME], [AGT_CODE], [ACC_SEQ], [PAY_METHOD], [PAY_NAME], [PAY_PRICE], [COM_RATE], [COM_PRICE], [PAY_DATE], [PAY_REMARK], [ADMIN_REMARK], [CUS_NO], [INSTALLMENT], [EDI_CODE], [CLOSED_CODE], [CLOSED_YN], [CLOSED_DATE], [NEW_CODE], [NEW_DATE], [EDT_CODE], [EDT_DATE], [CXL_YN], [CXL_DATE], [CXL_CODE], [PAY_NUM], [PG_APP_NO], [MALL_ID]  from [dbo].[PAY_MASTER_root] 
GO
