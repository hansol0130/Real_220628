USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NVTESTUSER](
	[CAMPAIGN_NO] [numeric](15, 0) NOT NULL,
	[CAMPAIGN_TYPE] [char](1) NOT NULL,
	[USER_ID] [varchar](15) NOT NULL,
	[SEQ_NO] [numeric](5, 0) NOT NULL,
 CONSTRAINT [PK_NVTESTUSER] PRIMARY KEY CLUSTERED 
(
	[CAMPAIGN_NO] ASC,
	[CAMPAIGN_TYPE] ASC,
	[USER_ID] ASC,
	[SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO