USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NVECARERPTDURATION](
	[ECARE_NO] [numeric](15, 0) NOT NULL,
	[RESULT_SEQ] [numeric](16, 0) NOT NULL,
	[REPORT_DT] [char](8) NOT NULL,
	[REPORT_TM] [char](2) NOT NULL,
	[DURATIONINFO_CD] [char](2) NULL,
	[VALIDOPEN_CNT] [numeric](10, 0) NULL,
	[VALIDOPEN_OCNT] [numeric](10, 0) NULL,
 CONSTRAINT [PK_NVECARERPTDURATION] PRIMARY KEY CLUSTERED 
(
	[ECARE_NO] ASC,
	[RESULT_SEQ] ASC,
	[REPORT_DT] ASC,
	[REPORT_TM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
