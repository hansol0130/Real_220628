USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_CODE_TIME](
	[TIME_SEQ] [int] NOT NULL,
	[SUPP_CODE] [varchar](2) NULL,
	[CITY_CODE] [varchar](20) NULL,
	[HOTEL_CODE] [int] NULL,
	[TIME_VALUE] [int] NULL,
	[USE_YN] [varchar](1) NULL,
	[CREATE_DATE] [datetime] NULL,
	[CREATE_USER] [varchar](30) NULL,
	[UPDATE_DATE] [datetime] NULL,
	[UPDATE_USER] [varchar](30) NULL,
 CONSTRAINT [PK_HTL_CODE_TIME] PRIMARY KEY CLUSTERED 
(
	[TIME_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO