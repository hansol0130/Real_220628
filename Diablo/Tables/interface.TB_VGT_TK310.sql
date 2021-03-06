USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [interface].[TB_VGT_TK310](
	[TASF_SEQNO] [int] NOT NULL,
	[AGT_CD] [varchar](10) NOT NULL,
	[PBLICTE_DATE] [varchar](8) NOT NULL,
	[TASF_NO] [varchar](13) NOT NULL,
	[AIR_NO_CD] [varchar](4) NULL,
	[TKT_NO] [varchar](20) NULL,
	[GDS_CD] [varchar](2) NULL,
	[ISSUE_DATE] [varchar](8) NULL,
	[IATA_NO] [varchar](10) NULL,
	[VOID_FLAG] [varchar](1) NULL,
	[PNR_NO] [varchar](10) NULL,
	[PAX_NM] [varchar](50) NULL,
	[CURR_CD] [varchar](3) NULL,
	[PAY_MTH_FLAG] [varchar](3) NULL,
	[CASH_AMT] [int] NULL,
	[CARD_AMT] [int] NULL,
	[TOT_AMT] [int] NULL,
	[CARD_NO] [varchar](200) NULL,
	[CARD_VALID_MMYY] [varchar](150) NULL,
	[CARD_CONFM_NO] [varchar](10) NULL,
	[CARD_INSTLMT_CNT] [varchar](3) NULL,
	[IATA_FEE] [int] NULL,
	[CARD_FEE] [int] NULL,
	[BRANCH_FLAG] [varchar](6) NULL,
	[REMARK] [varchar](4000) NULL,
	[REFUND_RCEPT_DATE] [varchar](8) NULL,
	[REFUND_TOT_AMT] [int] NULL,
	[REFUND_CARD_AMT] [int] NULL,
	[REFUND_CASH_AMT] [int] NULL,
	[REFUND_NETINCOME_AMT] [int] NULL,
	[REFUND_RCEPT_USR_ID] [varchar](50) NULL,
	[REFUND_REMARK] [varchar](150) NULL,
	[INICIS_DEPOSIT_AMT] [int] NULL,
	[PNR_SEQNO] [int] NULL,
	[PAX_NO] [int] NULL,
	[MNUL_REG_YN] [varchar](1) NULL,
	[PAY_SSPN_YN] [varchar](1) NULL,
	[BILL_SEQNO] [int] NULL,
	[E_TAX_BILL_NO] [varchar](100) NULL,
	[EXPREPOT_SEQNO] [int] NULL,
	[CHIT_SEQNO] [int] NULL,
	[FEE_TRANS_YN] [varchar](1) NULL,
	[TASF_PAY_DTM] [varchar](14) NULL,
	[TASF_REFUND_PAY_SSPN_YN] [varchar](1) NULL,
	[TASF_REFUND_BILL_SEQNO] [int] NULL,
	[TASF_REFUND_E_TAX_BILL_NO] [varchar](100) NULL,
	[TASF_REFUND_CHIT_SEQNO] [int] NULL,
	[TASF_REFUND_EXPREPOT_SEQNO] [int] NULL,
	[REG_USR_ID] [varchar](50) NULL,
	[REG_DTM] [varchar](14) NULL,
	[UPD_USR_ID] [varchar](50) NULL,
	[UPD_DTM] [varchar](14) NULL,
	[DSR_YN] [varchar](1) NULL,
	[LEGACY_TRANS_YN] [varchar](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[TASF_SEQNO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [interface].[TB_VGT_TK310] ADD  DEFAULT ('KRW') FOR [CURR_CD]
GO
ALTER TABLE [interface].[TB_VGT_TK310] ADD  DEFAULT ('N') FOR [MNUL_REG_YN]
GO
ALTER TABLE [interface].[TB_VGT_TK310] ADD  DEFAULT ('N') FOR [PAY_SSPN_YN]
GO
ALTER TABLE [interface].[TB_VGT_TK310] ADD  DEFAULT ('N') FOR [TASF_REFUND_PAY_SSPN_YN]
GO
ALTER TABLE [interface].[TB_VGT_TK310] ADD  DEFAULT (CONVERT([varchar](10),getdate(),(112))+replace(CONVERT([varchar](8),getdate(),(108)),':','')) FOR [REG_DTM]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????? ????????????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'TASF_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'AGT_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'PBLICTE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'TASF_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????? ?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'AIR_NO_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'TKT_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'GDS ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'GDS_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'ISSUE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'IATA ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'IATA_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'VOID_FLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PNR ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'PNR_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????? ???' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'PAX_NM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'CURR_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'PAY_MTH_FLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'CASH_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'CARD_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'TOT_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'CARD_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'CARD_VALID_MMYY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'CARD_CONFM_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ?????? ???' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'CARD_INSTLMT_CNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'IATA ?????????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'IATA_FEE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ?????????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'CARD_FEE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'BRANCH_FLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'REFUND_RCEPT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ??? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'REFUND_TOT_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'REFUND_CARD_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'REFUND_CASH_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ????????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'REFUND_NETINCOME_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ?????? ????????? ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'REFUND_RCEPT_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'REFUND_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????? ?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'INICIS_DEPOSIT_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PNR ????????????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'PNR_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'PAX_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'MNUL_REG_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'PAY_SSPN_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????? ????????????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'BILL_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ?????? ????????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'E_TAX_BILL_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????? ????????????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'EXPREPOT_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ????????????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'CHIT_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????? ?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'FEE_TRANS_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????? ?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'TASF_PAY_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????? ?????? ?????? ?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'TASF_REFUND_PAY_SSPN_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????? ?????? ????????? ????????????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'TASF_REFUND_BILL_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????? ?????? ?????? ?????? ????????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'TASF_REFUND_E_TAX_BILL_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????? ?????? ?????? ????????????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'TASF_REFUND_CHIT_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????? ?????? ????????? ????????????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'TASF_REFUND_EXPREPOT_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ????????? ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'REG_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'REG_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ????????? ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'UPD_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'UPD_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DSR ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'DSR_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????? ?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'LEGACY_TRANS_YN'
GO
