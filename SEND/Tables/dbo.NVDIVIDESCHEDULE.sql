USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NVDIVIDESCHEDULE](
	[CLIENT] [varchar](2) NOT NULL,
	[SERVICE_NO] [numeric](15, 0) NOT NULL,
	[DIVIDE_SEQ] [numeric](2, 0) NOT NULL,
	[TARGET_CNT] [numeric](10, 0) NULL,
	[START_DT] [varchar](14) NULL,
 CONSTRAINT [PK_NVDIVIDESCHEDULE] PRIMARY KEY CLUSTERED 
(
	[CLIENT] ASC,
	[SERVICE_NO] ASC,
	[DIVIDE_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO