USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NVECARELINKRESULT](
	[ECARE_NO] [numeric](15, 0) NOT NULL,
	[RESULT_SEQ] [numeric](16, 0) NOT NULL,
	[LIST_SEQ] [varchar](10) NOT NULL,
	[LINK_SEQ] [numeric](2, 0) NOT NULL,
	[LINK_DT] [char](8) NOT NULL,
	[LINK_TM] [char](6) NOT NULL,
	[RECORD_SEQ] [varchar](10) NULL,
	[CUSTOMER_ID] [varchar](50) NOT NULL,
	[CUSTOMER_EMAIL] [varchar](100) NOT NULL,
	[CUSTOMER_NM] [varchar](100) NULL,
	[CLICK_CNT] [numeric](10, 0) NULL,
 CONSTRAINT [PK_NVECARELINKRESULT] PRIMARY KEY CLUSTERED 
(
	[ECARE_NO] ASC,
	[RESULT_SEQ] ASC,
	[LIST_SEQ] ASC,
	[LINK_DT] ASC,
	[LINK_TM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NVECARELINKRESULT] ADD  DEFAULT ('0') FOR [RECORD_SEQ]
GO
ALTER TABLE [dbo].[NVECARELINKRESULT]  WITH CHECK ADD  CONSTRAINT [FK_ELT_ECARELINKRESULT] FOREIGN KEY([ECARE_NO], [LINK_SEQ])
REFERENCES [dbo].[NVECARELINKTRACE] ([ECARE_NO], [LINK_SEQ])
GO
ALTER TABLE [dbo].[NVECARELINKRESULT] CHECK CONSTRAINT [FK_ELT_ECARELINKRESULT]
GO
