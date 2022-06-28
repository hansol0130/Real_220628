USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TRAVEL_REPORT_DETAIL](
	[OTR_SEQ] [int] NOT NULL,
	[SECTION] [char](1) NOT NULL,
	[BEST_WORST] [char](1) NOT NULL,
	[SEQ_NO] [int] NOT NULL,
	[SECTION_CODE] [varchar](10) NULL,
	[NAME] [varchar](100) NULL,
	[CLASSIFY] [varchar](20) NULL,
	[REASON] [varchar](max) NULL,
	[FILE1] [varchar](max) NULL,
	[FILE2] [varchar](max) NULL,
	[FILE3] [varchar](max) NULL,
 CONSTRAINT [PK_TRAVEL_REPORT_DETAIL_1] PRIMARY KEY CLUSTERED 
(
	[OTR_SEQ] ASC,
	[SECTION] ASC,
	[BEST_WORST] ASC,
	[SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO