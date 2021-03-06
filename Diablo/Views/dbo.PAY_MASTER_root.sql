USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  create view [dbo].[PAY_MASTER_root] (  [PAY_SEQ] , [PAY_TYPE] , [PAY_SUB_TYPE] , [PAY_SUB_NAME] , [AGT_CODE] , [ACC_SEQ] , [PAY_METHOD] , [PAY_NAME] , [PAY_PRICE] , [COM_RATE] , [COM_PRICE] , [PAY_DATE] , [PAY_REMARK] , [ADMIN_REMARK] , [CUS_NO] , [INSTALLMENT] , [EDI_CODE] , [CLOSED_CODE] , [CLOSED_YN] , [CLOSED_DATE] , [NEW_CODE] , [NEW_DATE] , [EDT_CODE] , [EDT_DATE] , [CXL_YN] , [CXL_DATE] , [CXL_CODE] , [PAY_NUM] , [PG_APP_NO] , [MALL_ID]  ) as select   [PAY_SEQ], [PAY_TYPE], [PAY_SUB_TYPE], [PAY_SUB_NAME], [AGT_CODE], [ACC_SEQ], [PAY_METHOD], [PAY_NAME], [PAY_PRICE], [COM_RATE], [COM_PRICE], [PAY_DATE], [PAY_REMARK], [ADMIN_REMARK], [CUS_NO], [INSTALLMENT], [EDI_CODE], [CLOSED_CODE], [CLOSED_YN], [CLOSED_DATE], [NEW_CODE], [NEW_DATE], [EDT_CODE], [EDT_DATE], [CXL_YN], [CXL_DATE], [CXL_CODE],convert(varchar(100), damo.[dbo].[damo_decrypt_Diablo_PAY_MASTER_PAY_NUM_B03A038532E2C9A4BF7B2F1A65B9EC26FBC36F7D]('Diablo','dbo.PAY_MASTER','PAY_NUM', [sec_PAY_NUM] ,'I')) COLLATE Korean_Wansung_CI_AS , [PG_APP_NO], [MALL_ID]   from [dbo].[PAY_MASTER_damo] 
GO
