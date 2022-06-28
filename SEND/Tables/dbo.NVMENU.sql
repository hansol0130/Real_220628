USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NVMENU](
	[MENU_CD] [varchar](10) NOT NULL,
	[PMENU_CD] [varchar](10) NULL,
	[LEVEL_NO] [numeric](1, 0) NOT NULL,
	[MENU_NM] [varchar](50) NULL,
	[MENU_LINK_URL] [varchar](100) NULL,
	[MENU_ICON_IMG] [varchar](100) NULL,
	[ACTIVE_YN] [char](1) NULL,
	[MODULE_NM] [varchar](20) NULL,
	[SORT_NO] [numeric](2, 0) NULL,
	[M_TYPE] [char](1) NULL,
 CONSTRAINT [PK_NVMENU] PRIMARY KEY CLUSTERED 
(
	[MENU_CD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NVMENU] ADD  DEFAULT ('Y') FOR [ACTIVE_YN]
GO
ALTER TABLE [dbo].[NVMENU] ADD  DEFAULT ('M') FOR [M_TYPE]
GO