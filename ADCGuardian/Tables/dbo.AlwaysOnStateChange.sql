USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlwaysOnStateChange](
	[group_name] [sysname] NULL,
	[replica_server_name] [nvarchar](256) NULL,
	[change_date] [datetime] NULL,
	[previous_state] [char](1) NULL,
	[current_state] [char](1) NULL
) ON [PRIMARY]
GO
