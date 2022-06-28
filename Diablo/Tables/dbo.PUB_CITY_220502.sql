USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_CITY_220502](
	[CITY_CODE] [char](3) NOT NULL,
	[KOR_NAME] [nvarchar](100) NULL,
	[ENG_NAME] [varchar](100) NULL,
	[NATION_CODE] [char](2) NULL,
	[STATE_CODE] [varchar](4) NULL,
	[GMT_TIME] [varchar](5) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[MAJOR_YN] [char](1) NULL,
	[ORDER_SEQ] [int] NULL,
	[GPS_X] [varchar](30) NULL,
	[GPS_Y] [varchar](30) NULL,
	[IS_USE_HTL] [char](1) NULL,
	[IS_USE_AIR] [char](1) NULL,
 CONSTRAINT [PK_PUB_CITY_220522] PRIMARY KEY CLUSTERED 
(
	[CITY_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
