USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DASHBOARD_ITEM_RANGE](
	[ServerID] [smallint] NOT NULL,
	[ITEM_ID] [smallint] NOT NULL,
	[MIN_VALUE] [float] NOT NULL,
	[MAX_VALUE] [float] NOT NULL,
	[INS_DATE] [smalldatetime] NULL,
	[UPD_DATE] [smalldatetime] NULL,
 CONSTRAINT [PK_DASHBOARD_ITEM_RANGE] PRIMARY KEY NONCLUSTERED 
(
	[ServerID] ASC,
	[ITEM_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DASHBOARD_ITEM_RANGE] ADD  DEFAULT (getdate()) FOR [INS_DATE]
GO