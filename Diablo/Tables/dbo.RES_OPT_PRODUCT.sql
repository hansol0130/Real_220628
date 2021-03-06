USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RES_OPT_PRODUCT](
	[RES_CODE] [dbo].[RES_CODE] NOT NULL,
	[OPT_NO] [int] NOT NULL,
	[MASTER_CODE] [dbo].[MASTER_CODE] NULL,
	[OPT_REG_NO] [int] NULL,
	[START_DATE] [datetime] NULL,
	[END_DATE] [datetime] NULL,
	[OPT_RES_STATE] [int] NULL,
	[SALE_PRICE] [int] NULL,
	[DC_PRICE] [int] NULL,
	[TAX_PRICE] [int] NULL,
	[CHG_PRICE] [int] NULL,
	[PENALTY_PRICE] [int] NULL,
	[NET_PRICE] [int] NULL,
	[OPT_REMARK] [nvarchar](max) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[CXL_DATE] [dbo].[CANCEL_DATE] NULL,
	[CXL_CODE] [dbo].[CANCEL_CODE] NULL,
 CONSTRAINT [PK_RES_OPT_PRODUCT] PRIMARY KEY CLUSTERED 
(
	[RES_CODE] ASC,
	[OPT_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[RES_OPT_PRODUCT]  WITH CHECK ADD  CONSTRAINT [R_252] FOREIGN KEY([RES_CODE])
REFERENCES [dbo].[RES_OPT_DETAIL] ([RES_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RES_OPT_PRODUCT] CHECK CONSTRAINT [R_252]
GO
ALTER TABLE [dbo].[RES_OPT_PRODUCT]  WITH CHECK ADD  CONSTRAINT [R_253] FOREIGN KEY([MASTER_CODE], [OPT_REG_NO])
REFERENCES [dbo].[OPT_PRICE] ([MASTER_CODE], [OPT_REG_NO])
GO
ALTER TABLE [dbo].[RES_OPT_PRODUCT] CHECK CONSTRAINT [R_253]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 예약, 1 : 취소, 9 : 전체' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_OPT_PRODUCT', @level2type=N'COLUMN',@level2name=N'OPT_RES_STATE'
GO
