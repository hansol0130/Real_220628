USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_CODE_HOLIDAY](
	[TARGET_DATE] [datetime] NOT NULL,
	[WEEK_DAY] [tinyint] NULL,
	[DATE_DESC] [varchar](100) NULL
) ON [PRIMARY]
GO
