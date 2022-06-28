USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUS_MASTER_HISTORY](
	[CUS_NO] [int] NOT NULL,
	[HIS_NO] [int] IDENTITY(1,1) NOT NULL,
	[HIS_TYPE] [int] NULL,
	[MASTER_CODE] [varchar](20) NULL,
	[EVT_SEQ] [int] NULL,
	[MASTER_SEQ] [int] NULL,
	[BOARD_SEQ] [int] NULL,
	[KEYWORD] [varchar](100) NULL,
	[HIS_DATE] [datetime] NULL,
 CONSTRAINT [PK_CUS_MASTER_HISTORY] PRIMARY KEY CLUSTERED 
(
	[CUS_NO] ASC,
	[HIS_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
