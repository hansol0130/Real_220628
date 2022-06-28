USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DBBlockInfo](
	[SQLServerID] [smallint] NOT NULL,
	[Type] [varchar](20) NULL,
	[Spid] [smallint] NOT NULL,
	[Kpid] [smallint] NOT NULL,
	[Blocked] [smallint] NOT NULL,
	[InsDate] [datetime] NOT NULL,
	[Waittime] [int] NULL,
	[AffectedCount] [int] NULL,
	[Sql] [varchar](7739) NULL,
	[DBName] [varchar](50) NULL,
	[LoginName] [varchar](40) NULL,
	[HostName] [varchar](40) NULL,
	[Program_Name] [varchar](80) NULL,
	[login_time] [datetime] NULL,
	[Last_batch] [datetime] NULL,
	[Open_Tran] [int] NULL,
	[CpuTime] [int] NULL,
	[Physical_io] [int] NULL,
	[Memusage] [int] NULL,
 CONSTRAINT [PK_DBBlockInfo] PRIMARY KEY NONCLUSTERED 
(
	[SQLServerID] ASC,
	[Spid] ASC,
	[Kpid] ASC,
	[InsDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DBBlockInfo] ADD  DEFAULT ((0)) FOR [Kpid]
GO
ALTER TABLE [dbo].[DBBlockInfo] ADD  DEFAULT ((0)) FOR [Blocked]
GO
ALTER TABLE [dbo].[DBBlockInfo] ADD  DEFAULT (getdate()) FOR [InsDate]
GO
