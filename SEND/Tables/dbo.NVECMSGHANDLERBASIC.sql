USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NVECMSGHANDLERBASIC](
	[SEQ] [numeric](10, 0) NOT NULL,
	[SERVICE_TYPE] [char](1) NOT NULL,
	[DEFAULT_YN] [char](1) NOT NULL,
	[HANDLER_DESC] [varchar](250) NULL,
	[APPSOURCE] [text] NULL,
 CONSTRAINT [PK_NVECMSGHANDLERBASIC] PRIMARY KEY CLUSTERED 
(
	[SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[NVECMSGHANDLERBASIC] ADD  DEFAULT ('N') FOR [DEFAULT_YN]
GO
