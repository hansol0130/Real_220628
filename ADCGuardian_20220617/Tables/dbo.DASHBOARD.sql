USE [ADCGuardian_20220617]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DASHBOARD](
	[ServerID] [smallint] NOT NULL,
	[SQLServerID] [smallint] NOT NULL,
	[ITEM_ID] [smallint] NOT NULL,
	[ITEM_VALUE] [float] NOT NULL,
	[REF_ID] [int] NULL,
	[CPID] [smallint] NULL,
	[UPD_DATE] [datetime] NULL,
 CONSTRAINT [PK_DASHBOARD] PRIMARY KEY NONCLUSTERED 
(
	[ServerID] ASC,
	[SQLServerID] ASC,
	[ITEM_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DASHBOARD] ADD  DEFAULT (getdate()) FOR [UPD_DATE]
GO
ALTER TABLE [dbo].[DASHBOARD]  WITH CHECK ADD  CONSTRAINT [FK_DASH_BOARD__ITEM_ID] FOREIGN KEY([ITEM_ID])
REFERENCES [dbo].[DASHBOARD_ITEM] ([ITEM_ID])
GO
ALTER TABLE [dbo].[DASHBOARD] CHECK CONSTRAINT [FK_DASH_BOARD__ITEM_ID]
GO