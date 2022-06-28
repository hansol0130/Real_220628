USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_CODE_MAST_CITY](
	[CITY_CODE] [bigint] NOT NULL,
	[CITY_NAME] [nvarchar](400) NULL,
	[CITY_ENAME] [nvarchar](400) NULL,
	[NATION_CODE] [varchar](2) NULL,
	[NATION_NAME] [varchar](100) NULL,
	[NATION_ENAME] [varchar](100) NULL,
	[SORT_ORDER] [int] NULL,
	[MAIN_YN] [varchar](1) NULL,
	[INDEX_NAME] [varchar](1000) NULL,
	[HOTEL_CNT] [int] NULL,
	[CENTER_LAT] [varchar](50) NULL,
	[CENTER_LNG] [varchar](50) NULL,
	[MIN_ZOOM] [int] NULL,
	[USE_YN] [varchar](1) NULL,
	[OLD_CODE] [varchar](4) NULL,
	[CREATE_DATE] [datetime] NULL,
	[CREATE_USER] [varchar](30) NULL,
	[UPDATE_DATE] [datetime] NULL,
	[UPDATE_USER] [varchar](30) NULL,
 CONSTRAINT [PK_HTL_CODE_MAST_CITY] PRIMARY KEY CLUSTERED 
(
	[CITY_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
