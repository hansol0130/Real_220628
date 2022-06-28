USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_BEST_DETAIL](
	[SITE_CODE] [varchar](3) NOT NULL,
	[MENU_CODE] [varchar](20) NOT NULL,
	[SEC_SEQ] [int] NOT NULL,
	[MAP_SEQ] [int] NOT NULL,
	[ITEM_SEQ] [int] NOT NULL,
	[TYPE_SEQ] [int] NULL,
	[ITEM_TYPE] [int] NULL,
	[DTI_NAME] [varchar](300) NULL,
	[DTI_ITEM1] [varchar](300) NULL,
	[DTI_ITEM2] [varchar](300) NULL,
	[DTI_ITEM3] [varchar](300) NULL,
	[DTI_ITEM4] [varchar](300) NULL,
	[DTI_ITEM5] [varchar](300) NULL,
	[ORDER_NO] [int] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
 CONSTRAINT [PK_PKG_BEST_DETAIL] PRIMARY KEY CLUSTERED 
(
	[SITE_CODE] ASC,
	[MENU_CODE] ASC,
	[SEC_SEQ] ASC,
	[MAP_SEQ] ASC,
	[ITEM_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
