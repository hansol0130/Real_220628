USE [VGLog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MKT_STATS_LOG](
	[PRO_CODE] [varchar](50) NOT NULL,
	[CLICK_TYPE] [varchar](1) NOT NULL,
	[PRO_NAME] [varchar](200) NULL,
	[VIEW_CNT] [int] NULL,
	[CLICK_CNT] [int] NULL,
	[CLICK_RATE] [decimal](16, 2) NULL,
	[CPC_PRICE] [decimal](18, 0) NULL,
	[CPC_ONE_PRICE] [decimal](18, 0) NULL,
	[CREATE_DATE] [datetime] NULL,
 CONSTRAINT [PK_MKT_STATS_LOG] PRIMARY KEY CLUSTERED 
(
	[PRO_CODE] ASC,
	[CLICK_TYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO