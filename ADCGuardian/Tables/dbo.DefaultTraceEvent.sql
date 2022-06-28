USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DefaultTraceEvent](
	[trace_event_id] [smallint] NOT NULL,
	[category_id] [smallint] NOT NULL,
	[name] [nvarchar](128) NULL
) ON [PRIMARY]
GO
