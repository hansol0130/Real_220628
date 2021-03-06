USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_EVENT](
	[EVT_SEQ] [int] NULL,
	[PRO_CODE] [dbo].[PRO_CODE] NULL,
	[PRICE_SEQ] [int] NULL,
	[START_DATE] [datetime] NULL,
	[END_DATE] [datetime] NULL,
	[COST_PRICE] [int] NULL,
	[ORDER_SEQ] [int] NULL,
	[REMARK] [varchar](500) NULL,
	[SHOW_YN] [char](1) NULL,
	[NEW_CODE] [char](7) NULL,
	[NEW_DATE] [datetime] NULL,
	[EDT_CODE] [char](7) NULL,
	[EDT_DATE] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PKG_EVENT] ADD  CONSTRAINT [DEF_PKG_EVENT_COST_PRICE]  DEFAULT ((0)) FOR [COST_PRICE]
GO
ALTER TABLE [dbo].[PKG_EVENT] ADD  CONSTRAINT [DEF_PKG_EVENT_NEW_DATE]  DEFAULT (getdate()) FOR [NEW_DATE]
GO
