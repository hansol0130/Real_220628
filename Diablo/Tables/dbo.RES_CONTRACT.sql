USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RES_CONTRACT](
	[RES_CODE] [dbo].[RES_CODE] NOT NULL,
	[CONTRACT_NO] [int] NOT NULL,
	[DEP_DATE] [datetime] NULL,
	[ARR_DATE] [datetime] NULL,
	[NIGHT] [int] NULL,
	[INS_TYPE] [int] NULL,
	[INS_PRICE] [int] NULL,
	[MIN_COUNT] [int] NULL,
	[MAX_COUNT] [int] NULL,
	[TRANS_TYPE] [int] NULL,
	[TRANS_GRADE] [varchar](20) NULL,
	[STAY_TYPE] [varchar](30) NULL,
	[STAY_COUNT] [varchar](10) NULL,
	[TC_YN] [char](1) NULL,
	[TRANSPORT_TYPE] [int] NULL,
	[TRANSPORT_COUNT] [int] NULL,
	[MANDATORY_1] [char](1) NULL,
	[MANDATORY_2] [char](1) NULL,
	[MANDATORY_4] [char](1) NULL,
	[MANDATORY_5] [char](1) NULL,
	[MANDATORY_6] [char](1) NULL,
	[MANDATORY_7] [char](1) NULL,
	[MANDATORY_3] [char](1) NULL,
	[OPTION_1] [char](1) NULL,
	[OPTION_2] [char](1) NULL,
	[OPTION_3] [char](1) NULL,
	[OPTION_4] [char](1) NULL,
	[OPTION_5] [char](1) NULL,
	[OPTION_6] [char](1) NULL,
	[OPTION_7] [char](1) NULL,
	[OPTION_8] [char](1) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[TOUR_TYPE] [int] NULL,
	[INSIDE_DAY] [int] NULL,
	[REMARK] [varchar](max) NULL,
	[CFM_YN] [dbo].[USE_N] NULL,
	[CFM_DATE] [datetime] NULL,
	[CFM_TYPE] [int] NULL,
	[CFM_HEADER] [varchar](max) NULL,
	[CFM_IP] [varchar](20) NULL,
	[PRO_NAME] [nvarchar](100) NULL,
	[ADT_PRICE] [int] NULL,
	[DEP_DEP_DATE] [datetime] NULL,
	[ARR_ARR_DATE] [datetime] NULL,
	[DEP_AIRPORT] [varchar](40) NULL,
	[ARR_AIRPORT] [varchar](40) NULL,
	[RSV_DATE] [datetime] NULL,
	[PAYMENT_YN] [char](1) NULL,
	[RES_COUNT] [int] NULL,
	[TOTAL_PRICE] [int] NULL,
	[CONT_DATE] [dbo].[NEW_DATE] NULL,
	[SPC_TERMS_INFO] [varchar](max) NULL,
	[CONT_NAME] [varchar](40) NULL,
	[INS_YN] [char](1) NULL,
 CONSTRAINT [PK_RES_CONTRACT] PRIMARY KEY CLUSTERED 
(
	[RES_CODE] ASC,
	[CONTRACT_NO] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[RES_CONTRACT] ADD  CONSTRAINT [DF__RES_CONTR__ADT_P__0F0E1094]  DEFAULT ((0)) FOR [ADT_PRICE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'CONTRACT_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'DEP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'ARR_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'NIGHT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : ????????????, 1 : ??????, 2 : ????????? ( ???????????? = 0 , ?????? = 1, ????????? = 2)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'INS_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'INS_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'MIN_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'MAX_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : ?????????, 1 : ??????, 2 : ??????, 9 : ?????? ( ????????? = 0 , ?????? = 1 , ?????? = 2 , ?????? = 9 ) ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'TRANS_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????? ??????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'TRANS_GRADE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : ??????, 1 : ?????????, 2 : ????????????, 3 : ????????????, 4 : ???????????????, 5 : ??????, 99 : ?????? ( ?????? = 0 , ????????? = 1, ???????????? = 2, ???????????? = 3, ??????????????? = 4, ?????? = 5, ?????? = 6, ?????? = 99)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'STAY_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'STAY_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????? ??????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'TC_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : ??????, 1 : ?????????, 9 : ?????? ( ?????? = 0 , ????????? = 1 , ?????? = 9) ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'TRANSPORT_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????? ??????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'TRANSPORT_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'MANDATORY_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'MANDATORY_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'MANDATORY_4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????5' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'MANDATORY_5'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????6' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'MANDATORY_6'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????7' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'MANDATORY_7'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'MANDATORY_3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'OPTION_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'OPTION_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'OPTION_3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'OPTION_4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????5' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'OPTION_5'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????6' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'OPTION_6'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????7' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'OPTION_7'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????8' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'OPTION_8'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : ??????, 1 : ?????? ( ?????? = 0 , ?????? = 1)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'TOUR_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'INSIDE_DAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'CFM_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'CFM_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : EMAIL, 1 : HOMEPAGE, 2 : ???????????? ( EMAIL = 0 ,  MYPAGE = 1, ???????????? =2 )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'CFM_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'CFM_HEADER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????IP' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'CFM_IP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'PRO_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'ADT_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'DEP_DEP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'ARR_ARR_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'DEP_AIRPORT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'ARR_AIRPORT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'RSV_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'PAYMENT_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'RES_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'TOTAL_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'CONT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'SPC_TERMS_INFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'CONT_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????? ?????? ??????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'INS_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT'
GO
