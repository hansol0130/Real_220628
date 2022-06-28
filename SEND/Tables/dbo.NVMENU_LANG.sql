USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NVMENU_LANG](
	[MENU_CD] [varchar](10) NOT NULL,
	[LANG] [varchar](10) NOT NULL,
	[MENU_NM] [varchar](50) NULL,
 CONSTRAINT [PK_NVMENU_LANG] PRIMARY KEY CLUSTERED 
(
	[MENU_CD] ASC,
	[LANG] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO