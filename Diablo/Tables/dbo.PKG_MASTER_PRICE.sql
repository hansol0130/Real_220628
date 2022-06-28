USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_MASTER_PRICE](
	[MASTER_CODE] [dbo].[MASTER_CODE] NOT NULL,
	[PRICE_SEQ] [int] NOT NULL,
	[PRICE_NAME] [nvarchar](60) NULL,
	[SEASON] [varchar](2) NULL,
	[SCH_SEQ] [int] NULL,
	[PKG_INCLUDE] [nvarchar](max) NULL,
	[PKG_NOT_INCLUDE] [nvarchar](max) NULL,
	[ADT_PRICE] [int] NULL,
	[CHD_PRICE] [int] NULL,
	[INF_PRICE] [int] NULL,
	[SGL_PRICE] [int] NULL,
	[CUR_TYPE] [int] NULL,
	[EXC_RATE] [decimal](8, 2) NULL,
	[FLOATING_YN] [varchar](20) NULL,
	[POINT_RATE] [decimal](4, 2) NULL,
	[POINT_PRICE] [int] NULL,
	[POINT_YN] [char](1) NULL,
	[QCHARGE_TYPE] [int] NULL,
	[ADT_QCHARGE] [int] NULL,
	[CHD_QCHARGE] [int] NULL,
	[INF_QCHARGE] [int] NULL,
	[QCHARGE_DATE] [datetime] NULL,
	[ADT_TAX] [int] NULL,
	[CHD_TAX] [int] NULL,
	[INF_TAX] [int] NULL,
 CONSTRAINT [PK_PKG_MASTER_PRICE] PRIMARY KEY CLUSTERED 
(
	[MASTER_CODE] ASC,
	[PRICE_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[PKG_MASTER_PRICE]  WITH CHECK ADD  CONSTRAINT [R_294] FOREIGN KEY([MASTER_CODE])
REFERENCES [dbo].[PKG_MASTER] ([MASTER_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PKG_MASTER_PRICE] CHECK CONSTRAINT [R_294]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가격순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE', @level2type=N'COLUMN',@level2name=N'PRICE_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE', @level2type=N'COLUMN',@level2name=N'PRICE_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시즌' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE', @level2type=N'COLUMN',@level2name=N'SEASON'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일정순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE', @level2type=N'COLUMN',@level2name=N'SCH_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'포함사항' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE', @level2type=N'COLUMN',@level2name=N'PKG_INCLUDE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'불포함사항' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE', @level2type=N'COLUMN',@level2name=N'PKG_NOT_INCLUDE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'성인가격' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE', @level2type=N'COLUMN',@level2name=N'ADT_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아동가격' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE', @level2type=N'COLUMN',@level2name=N'CHD_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'유아가격' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE', @level2type=N'COLUMN',@level2name=N'INF_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'싱글추가금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE', @level2type=N'COLUMN',@level2name=N'SGL_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'화폐단위' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE', @level2type=N'COLUMN',@level2name=N'CUR_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환율기준' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE', @level2type=N'COLUMN',@level2name=N'EXC_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'변동환율유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE', @level2type=N'COLUMN',@level2name=N'FLOATING_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'포인트 율' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE', @level2type=N'COLUMN',@level2name=N'POINT_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'포인트 금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE', @level2type=N'COLUMN',@level2name=N'POINT_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'포인트 사용여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE', @level2type=N'COLUMN',@level2name=N'POINT_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 시스템, 1 : 직접입력' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE', @level2type=N'COLUMN',@level2name=N'QCHARGE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'성인유류할증료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE', @level2type=N'COLUMN',@level2name=N'ADT_QCHARGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아동유류할증료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE', @level2type=N'COLUMN',@level2name=N'CHD_QCHARGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'유아유류할증료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE', @level2type=N'COLUMN',@level2name=N'INF_QCHARGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'유류할증료적용일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE', @level2type=N'COLUMN',@level2name=N'QCHARGE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'성인제세공과금' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE', @level2type=N'COLUMN',@level2name=N'ADT_TAX'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아동제세공과금' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE', @level2type=N'COLUMN',@level2name=N'CHD_TAX'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'유아제세공과금' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE', @level2type=N'COLUMN',@level2name=N'INF_TAX'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터가격정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE'
GO
