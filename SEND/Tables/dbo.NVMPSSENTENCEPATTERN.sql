USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NVMPSSENTENCEPATTERN](
	[PATTERN_NO] [numeric](5, 0) NOT NULL,
	[PATTERN_NM] [varchar](100) NOT NULL,
	[PATTERN_FORM] [varchar](50) NOT NULL,
	[PATTERN_DESC] [varchar](250) NULL,
 CONSTRAINT [PK_NVMPSSENTENCEPATTERN] PRIMARY KEY CLUSTERED 
(
	[PATTERN_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO