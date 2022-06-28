USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NV_SPAM_SENDLOG](
	[CAMPAIGN_NO] [numeric](15, 0) NOT NULL,
	[RESULT_SEQ] [numeric](16, 0) NOT NULL,
	[LIST_SEQ] [varchar](10) NOT NULL,
	[CUSTOMER_KEY] [varchar](50) NOT NULL,
	[RECORD_SEQ] [varchar](10) NOT NULL,
	[SID] [varchar](5) NOT NULL,
	[SEND_DOMAIN] [varchar](50) NOT NULL,
 CONSTRAINT [PK_NV_SPAM_SENDLOG] PRIMARY KEY CLUSTERED 
(
	[CAMPAIGN_NO] ASC,
	[RESULT_SEQ] ASC,
	[LIST_SEQ] ASC,
	[CUSTOMER_KEY] ASC,
	[RECORD_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NV_SPAM_SENDLOG] ADD  DEFAULT ('0') FOR [RECORD_SEQ]
GO
