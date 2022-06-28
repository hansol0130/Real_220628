USE [ADCGuardian_20220617]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlwaysOnStatus](
	[ag_name] [sysname] NULL,
	[replica_server_name] [nvarchar](256) NULL,
	[database_name] [sysname] NULL,
	[is_local] [bit] NULL,
	[primary_replica] [nvarchar](128) NULL,
	[role] [tinyint] NULL,
	[availability_mode] [tinyint] NULL,
	[failover_mode] [tinyint] NULL,
	[primary_role_allow_connections] [tinyint] NULL,
	[secondary_role_allow_connections] [tinyint] NULL,
	[connected_state] [tinyint] NULL,
	[synchronization_state] [tinyint] NULL,
	[is_commit_participant] [bit] NULL,
	[synchronization_health] [tinyint] NULL,
	[is_suspended] [bit] NULL,
	[suspend_reason] [tinyint] NULL,
	[last_sent_time] [datetime] NULL,
	[last_received_time] [datetime] NULL,
	[last_hardened_time] [datetime] NULL,
	[last_redone_time] [datetime] NULL,
	[last_commit_time] [datetime] NULL,
	[log_send_queue_size] [bigint] NULL,
	[log_send_rate] [bigint] NULL,
	[redo_queue_size] [bigint] NULL,
	[redo_rate] [bigint] NULL,
	[filestream_send_rate] [bigint] NULL,
	[recovery_lsn] [varchar](25) NULL,
	[truncation_lsn] [varchar](25) NULL,
	[last_sent_lsn] [varchar](25) NULL,
	[last_received_lsn] [varchar](25) NULL,
	[last_hardened_lsn] [varchar](25) NULL,
	[last_redone_lsn] [varchar](25) NULL,
	[end_of_log_lsn] [varchar](25) NULL,
	[last_commit_lsn] [varchar](25) NULL,
	[InsDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
