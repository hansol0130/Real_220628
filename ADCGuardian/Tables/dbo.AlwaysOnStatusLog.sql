USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlwaysOnStatusLog](
	[SQLServerID] [smallint] NULL,
	[ag_name] [sysname] NOT NULL,
	[replica_server_name] [nvarchar](256) NULL,
	[role] [tinyint] NULL,
	[database_name] [sysname] NOT NULL,
	[InsDate] [datetime] NULL
) ON [PRIMARY]
GO
