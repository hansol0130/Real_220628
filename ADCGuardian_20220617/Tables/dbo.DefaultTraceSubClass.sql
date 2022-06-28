USE [ADCGuardian_20220617]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DefaultTraceSubClass](
	[trace_event_id] [smallint] NOT NULL,
	[trace_column_id] [smallint] NOT NULL,
	[subclass_value] [smallint] NULL,
	[subclass_name] [nvarchar](128) NULL
) ON [PRIMARY]
GO
