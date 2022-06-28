USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_COUPON_MAST](
	[COUPON_ID] [varchar](50) NOT NULL,
	[COUPON_NAME] [varchar](100) NULL,
	[COUPON_DESC] [varchar](2000) NULL,
	[VALID_DATE_FROM] [datetime] NULL,
	[VALID_DATE_TO] [datetime] NULL,
	[CHECKIN_FROM] [datetime] NULL,
	[CHECKIN_TO] [datetime] NULL,
	[STAY_NIGHT] [int] NULL,
	[USE_YN] [varchar](1) NULL,
	[COUPON_CITY] [varchar](10) NULL,
	[DISCNT_TYPE] [varchar](1) NULL,
	[DISCNT_AMT] [int] NULL,
	[DISCNT_MAX] [int] NULL,
	[CREATE_USER] [varchar](50) NULL,
	[CREATE_DATE] [datetime] NULL,
 CONSTRAINT [PK_HTL_COUPON_MAST] PRIMARY KEY CLUSTERED 
(
	[COUPON_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO