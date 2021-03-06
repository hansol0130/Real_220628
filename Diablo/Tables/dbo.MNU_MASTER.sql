USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MNU_MASTER](
	[SITE_CODE] [char](3) NOT NULL,
	[MENU_CODE] [varchar](20) NOT NULL,
	[PARENT_CODE] [varchar](20) NULL,
	[MENU_NAME] [varchar](100) NULL,
	[REGION_CODE] [varchar](30) NULL,
	[NATION_CODE] [varchar](30) NULL,
	[CITY_CODE] [varchar](30) NULL,
	[ATT_CODE] [varchar](50) NULL,
	[GROUP_CODE] [varchar](100) NULL,
	[BASIC_CODE] [varchar](20) NULL,
	[CATEGORY_TYPE] [varchar](1) NULL,
	[VIEW_TYPE] [varchar](1) NULL,
	[LINK_URL] [varchar](200) NULL,
	[IMAGE_URL] [varchar](200) NULL,
	[BEST_CODE] [varchar](50) NULL,
	[FONT_STYLE] [varchar](30) NULL,
	[FONT_COLOR] [varchar](10) NULL,
	[ORDER_TYPE] [int] NULL,
	[ORDER_NUM] [int] NULL,
	[USE_YN] [char](1) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[MENU_TYPE] [int] NULL,
	[GROUP_REGION] [varchar](20) NULL,
	[GROUP_ATTRIBUTE] [varchar](20) NULL,
	[MOBILE_YN] [char](1) NOT NULL,
	[ENG_MENU_NAME] [varchar](100) NULL,
 CONSTRAINT [PK_MNU_MASTER] PRIMARY KEY CLUSTERED 
(
	[SITE_CODE] ASC,
	[MENU_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MNU_MASTER] ADD  CONSTRAINT [DEF_MNU_MASTER_ORDER_TYPE]  DEFAULT ((1)) FOR [ORDER_TYPE]
GO
ALTER TABLE [dbo].[MNU_MASTER] ADD  CONSTRAINT [DEF_MNU_MASTER_MENU_TYPE]  DEFAULT ((9)) FOR [MENU_TYPE]
GO
ALTER TABLE [dbo].[MNU_MASTER] ADD  DEFAULT ('') FOR [GROUP_REGION]
GO
ALTER TABLE [dbo].[MNU_MASTER] ADD  DEFAULT ('') FOR [GROUP_ATTRIBUTE]
GO
ALTER TABLE [dbo].[MNU_MASTER] ADD  CONSTRAINT [DEF_MNU_MASTER_MOBILE_YN]  DEFAULT ('N') FOR [MOBILE_YN]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 전체메뉴, 1 : 상품관련메뉴, 2 : 이벤트메뉴, 3 : 비상품메뉴, 9 : 기타메뉴' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MNU_MASTER', @level2type=N'COLUMN',@level2name=N'MENU_TYPE'
GO
