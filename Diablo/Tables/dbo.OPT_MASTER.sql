USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OPT_MASTER](
	[MASTER_CODE] [dbo].[MASTER_CODE] NOT NULL,
	[CNT_CODE] [dbo].[CNT_CODE] NULL,
	[MASTER_NAME] [nvarchar](50) NULL,
	[REGION_CODE] [dbo].[REGION_CODE] NULL,
	[NATION_CODE] [dbo].[NATION_CODE] NULL,
	[STATE_CODE] [dbo].[STATE_CODE] NULL,
	[CITY_CODE] [dbo].[CITY_CODE] NULL,
	[OPT_TYPE] [int] NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
 CONSTRAINT [PK_OPT_MASTER] PRIMARY KEY CLUSTERED 
(
	[MASTER_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : None, 1 : 스키장, 2 : 온천, 3 : 골프' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OPT_MASTER', @level2type=N'COLUMN',@level2name=N'OPT_TYPE'
GO
