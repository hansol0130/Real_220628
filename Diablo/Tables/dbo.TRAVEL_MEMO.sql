USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TRAVEL_MEMO](
	[RES_CODE] [char](12) NOT NULL,
	[MEMO_NO] [int] NOT NULL,
	[SEQ_NO] [int] NOT NULL,
	[DAY_NO] [int] NULL,
	[CNT_CODE] [int] NULL,
	[MEMO_TITLE] [varchar](100) NULL,
	[MEMO_CONTENT] [varchar](2000) NULL,
	[NEW_DATE] [datetime] NULL,
 CONSTRAINT [PK_TRAVEL_MEMO] PRIMARY KEY CLUSTERED 
(
	[RES_CODE] ASC,
	[SEQ_NO] ASC,
	[MEMO_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
