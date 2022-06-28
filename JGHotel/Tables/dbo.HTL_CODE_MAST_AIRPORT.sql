USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_CODE_MAST_AIRPORT](
	[AIRPORT_CODE] [varchar](3) NULL,
	[AIRPORT_NAME] [varchar](200) NULL,
	[AIRPORT_ENAME] [varchar](200) NULL,
	[CITY_CODE] [bigint] NULL,
	[CITY_NAME] [nvarchar](400) NULL
) ON [PRIMARY]
GO