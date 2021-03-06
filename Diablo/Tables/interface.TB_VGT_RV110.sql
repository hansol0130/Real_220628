USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [interface].[TB_VGT_RV110](
	[PNR_SEQNO] [int] NOT NULL,
	[PAX_NO] [int] NOT NULL,
	[PAX_TATOO_NO] [varchar](5) NULL,
	[PAX_AGE_FLAG] [varchar](1) NULL,
	[PAX_ENG_FMNM] [varchar](50) NULL,
	[PAX_ENG_NM] [varchar](50) NULL,
	[PAX_ENG_TITLE] [varchar](7) NULL,
	[PAX_SEX] [varchar](1) NULL,
	[PAX_BIRTH] [varchar](4000) NULL,
	[PROMTN_ID] [int] NULL,
	[SALE_TOT_AMT] [int] NULL,
	[SALE_NET_AMT] [int] NULL,
	[BAF] [int] NULL,
	[SALE_TAX_AMT] [int] NULL,
	[TASF] [int] NULL,
	[SALE_QUE_AMT] [int] NULL,
	[SALE_DSCNT_AMT] [int] NULL,
	[PROMTN_DSCNT_FARE] [int] NULL,
	[PROMTN_DSCNT_RATE] [varchar](5) NULL,
	[ADD_PROMTN_DSCNT_FARE] [int] NULL,
	[ADD_PROMTN_DSCNT_RATE] [varchar](5) NULL,
	[PTN_PROMTN_AMT] [int] NULL,
	[REG_USR_ID] [varchar](50) NULL,
	[REG_DTM] [varchar](14) NULL,
	[UPD_USR_ID] [varchar](50) NULL,
	[UPD_DTM] [varchar](14) NULL,
PRIMARY KEY CLUSTERED 
(
	[PNR_SEQNO] ASC,
	[PAX_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [interface].[TB_VGT_RV110] ADD  DEFAULT ((0)) FOR [SALE_TOT_AMT]
GO
ALTER TABLE [interface].[TB_VGT_RV110] ADD  DEFAULT ((0)) FOR [SALE_NET_AMT]
GO
ALTER TABLE [interface].[TB_VGT_RV110] ADD  DEFAULT ((0)) FOR [BAF]
GO
ALTER TABLE [interface].[TB_VGT_RV110] ADD  DEFAULT ((0)) FOR [SALE_TAX_AMT]
GO
ALTER TABLE [interface].[TB_VGT_RV110] ADD  DEFAULT ((0)) FOR [TASF]
GO
ALTER TABLE [interface].[TB_VGT_RV110] ADD  DEFAULT ((0)) FOR [SALE_QUE_AMT]
GO
ALTER TABLE [interface].[TB_VGT_RV110] ADD  DEFAULT ((0)) FOR [SALE_DSCNT_AMT]
GO
ALTER TABLE [interface].[TB_VGT_RV110] ADD  DEFAULT ((0)) FOR [PROMTN_DSCNT_FARE]
GO
ALTER TABLE [interface].[TB_VGT_RV110] ADD  DEFAULT ((0)) FOR [ADD_PROMTN_DSCNT_FARE]
GO
ALTER TABLE [interface].[TB_VGT_RV110] ADD  DEFAULT ((0)) FOR [PTN_PROMTN_AMT]
GO
ALTER TABLE [interface].[TB_VGT_RV110] ADD  DEFAULT (CONVERT([varchar](10),getdate(),(112))+replace(CONVERT([varchar](8),getdate(),(108)),':','')) FOR [REG_DTM]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PNR ????????????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV110', @level2type=N'COLUMN',@level2name=N'PNR_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV110', @level2type=N'COLUMN',@level2name=N'PAX_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????? ?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV110', @level2type=N'COLUMN',@level2name=N'PAX_TATOO_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????? ?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV110', @level2type=N'COLUMN',@level2name=N'PAX_AGE_FLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????? ?????? ???' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV110', @level2type=N'COLUMN',@level2name=N'PAX_ENG_FMNM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????? ?????? ???' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV110', @level2type=N'COLUMN',@level2name=N'PAX_ENG_NM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????? ?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV110', @level2type=N'COLUMN',@level2name=N'PAX_ENG_TITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV110', @level2type=N'COLUMN',@level2name=N'PAX_SEX'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV110', @level2type=N'COLUMN',@level2name=N'PAX_BIRTH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????? ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV110', @level2type=N'COLUMN',@level2name=N'PROMTN_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????? ?????? ?????????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV110', @level2type=N'COLUMN',@level2name=N'SALE_TOT_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV110', @level2type=N'COLUMN',@level2name=N'SALE_NET_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV110', @level2type=N'COLUMN',@level2name=N'BAF'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV110', @level2type=N'COLUMN',@level2name=N'SALE_TAX_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV110', @level2type=N'COLUMN',@level2name=N'TASF'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ??? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV110', @level2type=N'COLUMN',@level2name=N'SALE_QUE_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ????????????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV110', @level2type=N'COLUMN',@level2name=N'SALE_DSCNT_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????? ?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV110', @level2type=N'COLUMN',@level2name=N'PROMTN_DSCNT_FARE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????? ?????????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV110', @level2type=N'COLUMN',@level2name=N'PROMTN_DSCNT_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ???????????? ?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV110', @level2type=N'COLUMN',@level2name=N'ADD_PROMTN_DSCNT_FARE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ???????????? ?????? ???' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV110', @level2type=N'COLUMN',@level2name=N'ADD_PROMTN_DSCNT_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????? ???????????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV110', @level2type=N'COLUMN',@level2name=N'PTN_PROMTN_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ????????? ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV110', @level2type=N'COLUMN',@level2name=N'REG_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV110', @level2type=N'COLUMN',@level2name=N'REG_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ????????? ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV110', @level2type=N'COLUMN',@level2name=N'UPD_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ??????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV110', @level2type=N'COLUMN',@level2name=N'UPD_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV110'
GO
