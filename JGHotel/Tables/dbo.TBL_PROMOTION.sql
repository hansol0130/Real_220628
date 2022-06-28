USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_PROMOTION](
	[PROMOTION_ID] [int] IDENTITY(1,1) NOT NULL,
	[PROMOTION_NAME] [varchar](200) NOT NULL,
	[PROMOTION_DESC] [varchar](1000) NULL,
	[PROMOTION_CATEGORY] [varchar](50) NULL,
	[PROMOTION_THUMBNAIL] [varchar](500) NULL,
	[PROMOTION_PATH] [varchar](500) NULL,
	[START_DATE] [varchar](50) NULL,
	[END_DATE] [varchar](50) NULL,
	[REGISTER] [varchar](50) NULL,
	[REGIST_DATE] [datetime] NULL,
	[WEB_MOBILE] [varchar](1) NULL,
	[WEB_YN] [varchar](10) NULL,
	[COMPANY_ID] [varchar](50) NULL,
	[SEQUENCE] [int] NULL,
 CONSTRAINT [PK_TBL_PROMOTION] PRIMARY KEY CLUSTERED 
(
	[PROMOTION_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TBL_PROMOTION] ADD  CONSTRAINT [DF_TBL_PROMOTION_REGIST_DATE]  DEFAULT (getdate()) FOR [REGIST_DATE]
GO
