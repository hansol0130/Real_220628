USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NVECARERETURNMAIL](
	[ECARE_NO] [numeric](15, 0) NOT NULL,
	[RESULT_SEQ] [numeric](16, 0) NOT NULL,
	[LIST_SEQ] [varchar](10) NOT NULL,
	[CUSTOMER_ID] [varchar](50) NOT NULL,
	[RECORD_SEQ] [varchar](10) NOT NULL,
	[CUSTOMER_EMAIL] [varchar](100) NOT NULL,
	[CUSTOMER_NM] [varchar](100) NOT NULL,
	[RECEIVE_DT] [char](8) NOT NULL,
	[RECEIVE_TM] [char](6) NOT NULL,
	[SMTPCODE] [char](3) NOT NULL,
	[UPDATE_YN] [char](1) NULL,
	[RETURN_MSG] [varchar](200) NULL,
 CONSTRAINT [PK_NVECARERETURNMAIL] PRIMARY KEY CLUSTERED 
(
	[ECARE_NO] ASC,
	[RESULT_SEQ] ASC,
	[LIST_SEQ] ASC,
	[CUSTOMER_ID] ASC,
	[RECORD_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NVECARERETURNMAIL] ADD  DEFAULT ('0') FOR [RECORD_SEQ]
GO
ALTER TABLE [dbo].[NVECARERETURNMAIL] ADD  DEFAULT ('N') FOR [UPDATE_YN]
GO