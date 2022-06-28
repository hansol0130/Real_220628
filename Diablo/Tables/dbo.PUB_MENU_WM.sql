USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_MENU_WM](
	[MENU_GROUP_CODE] [varchar](5) NOT NULL,
	[MENU_CODE] [int] NOT NULL,
	[MENU_NAME] [varchar](60) NOT NULL,
	[PARENT_CODE] [int] NULL,
	[SORT_CODE] [int] NULL,
	[SHOW_YN] [char](1) NULL,
	[REMARK] [varchar](50) NULL,
	[MENU_ORDER] [int] NULL,
	[MENU_LINK] [varchar](100) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL
) ON [PRIMARY]
GO
