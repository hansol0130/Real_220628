USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MNU_MNG_GROUP](
	[SITE_CODE] [varchar](3) NOT NULL,
	[MENU_CODE] [varchar](20) NOT NULL,
	[SEC_CODE] [varchar](4) NOT NULL,
	[GRP_SEQ] [int] NOT NULL,
	[GRP_TITLE] [varchar](100) NULL,
	[GRP_CODE] [varchar](10) NULL,
	[GRP_DESC] [varchar](1000) NULL,
	[COLS_USE_NAME] [varchar](300) NULL,
	[COLS_TITLE] [varchar](300) NULL,
	[COLS_ATTR] [varchar](300) NULL,
	[COLS_WIDTH] [varchar](300) NULL,
	[COLS_ORDER] [varchar](100) NULL,
	[ORDER_NO] [int] NULL,
	[TYPE_SEQ] [int] NULL,
	[USE_YN] [char](1) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
 CONSTRAINT [PK_MNU_MNG_GROUP] PRIMARY KEY CLUSTERED 
(
	[SITE_CODE] ASC,
	[MENU_CODE] ASC,
	[SEC_CODE] ASC,
	[GRP_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
