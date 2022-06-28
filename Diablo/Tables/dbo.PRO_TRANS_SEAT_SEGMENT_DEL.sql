USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRO_TRANS_SEAT_SEGMENT_DEL](
	[SEAT_CODE] [int] NOT NULL,
	[TRANS_SEQ] [int] NOT NULL,
	[SEG_NO] [int] NOT NULL,
	[DEP_AIRPORT_CODE] [dbo].[AIRPORT_CODE] NULL,
	[ARR_AIRPORT_CODE] [dbo].[AIRPORT_CODE] NULL,
	[AIRLINE_CODE] [dbo].[AIRLINE_CODE] NULL,
	[FLIGHT] [varchar](20) NULL,
	[DEP_DATE] [datetime] NULL,
	[ARR_DATE] [datetime] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[REAL_AIRLINE_CODE] [varchar](2) NULL,
	[FLYING_TIME] [varchar](5) NULL
) ON [PRIMARY]
GO