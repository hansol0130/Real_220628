USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DBBackupInfo](
	[SQLServerID] [smallint] NOT NULL,
	[dbname] [varchar](128) NOT NULL,
	[Status] [varchar](30) NULL,
	[CreateDate] [datetime] NULL,
	[LogMode] [varchar](30) NULL,
	[IsInStandBy] [tinyint] NULL,
	[IsReadOnly] [tinyint] NULL,
	[IsSuspect] [tinyint] NULL,
	[Version] [int] NULL,
	[LastFullBackup_start] [datetime] NOT NULL,
	[LastFullBackup_finish] [datetime] NOT NULL,
	[LastLogBackup_start] [datetime] NOT NULL,
	[LastLogBackup_finish] [datetime] NOT NULL,
	[LastDifferentialBackup_start] [datetime] NOT NULL,
	[LastDifferentialBackup_finish] [datetime] NOT NULL,
	[LastFileBackup_start] [datetime] NOT NULL,
	[LastFileBackup_finish] [datetime] NOT NULL,
	[InsDate] [datetime] NOT NULL,
 CONSTRAINT [PK_DBBackupInfo] PRIMARY KEY CLUSTERED 
(
	[InsDate] ASC,
	[SQLServerID] ASC,
	[dbname] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
