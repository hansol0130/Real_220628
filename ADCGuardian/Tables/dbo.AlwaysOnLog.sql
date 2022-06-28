USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlwaysOnLog](
	[server_name] [nvarchar](256) NULL,
	[log_date] [datetime] NULL,
	[severity] [smallint] NULL,
	[state] [smallint] NULL,
	[message] [nvarchar](2048) NULL
) ON [PRIMARY]
GO
