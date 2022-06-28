USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_PROM_MAST](
	[PRM_NO] [int] NOT NULL,
	[TITLE] [varchar](100) NULL,
	[SHORT_DESC] [varchar](300) NULL,
	[IMG_TOP] [varchar](max) NULL,
	[IMG_MID] [varchar](max) NULL,
	[IMG_BTM] [varchar](max) NULL,
	[TYPE] [varchar](4) NULL,
	[DATE_FROM] [datetime] NULL,
	[DATE_TO] [datetime] NULL,
	[USE_YN] [varchar](1) NULL,
	[CREATE_USER] [varchar](30) NULL,
	[CREATE_DATE] [datetime] NULL,
	[UPDATE_USER] [varchar](30) NULL,
	[UPDATE_DATE] [datetime] NULL,
 CONSTRAINT [PK_HTL_PROM_MAST] PRIMARY KEY CLUSTERED 
(
	[PRM_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO