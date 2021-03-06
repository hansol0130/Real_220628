USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUS_RCV_AGREE_UPLOADED](
	[SEQ_NO] [int] IDENTITY(1,1) NOT NULL,
	[INFLOW_TYPE] [varchar](2) NULL,
	[FILE_PATH] [varchar](1000) NULL,
	[ROW_CNT] [int] NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL
) ON [PRIMARY]
GO
