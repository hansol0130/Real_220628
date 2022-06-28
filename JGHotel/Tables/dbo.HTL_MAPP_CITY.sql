USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_MAPP_CITY](
	[CITY_CODE] [bigint] NOT NULL,
	[SUPP_CODE] [varchar](2) NOT NULL,
	[S_CITY_CODE] [varchar](50) NOT NULL,
	[S_CITY_NAME] [varchar](100) NULL,
	[USE_YN] [varchar](1) NULL,
	[CREATE_DATE] [datetime] NULL,
	[CREATE_USER] [varchar](30) NULL,
	[UPDATE_DATE] [datetime] NULL,
	[UPDATE_USER] [varchar](30) NULL,
 CONSTRAINT [PK_HTL_MAPP_CITY] PRIMARY KEY CLUSTERED 
(
	[CITY_CODE] ASC,
	[SUPP_CODE] ASC,
	[S_CITY_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
