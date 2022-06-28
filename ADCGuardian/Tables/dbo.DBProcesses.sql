USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DBProcesses](
	[SQLServerID] [smallint] NOT NULL,
	[spid] [smallint] NOT NULL,
	[kpid] [smallint] NOT NULL,
	[status] [nchar](30) NOT NULL,
	[program_name] [varchar](80) NOT NULL,
	[loginame] [varchar](40) NOT NULL,
	[hostname] [varchar](40) NOT NULL,
	[dbname] [nvarchar](128) NULL,
	[cmd] [nchar](16) NOT NULL,
	[blocked] [smallint] NOT NULL,
	[open_tran] [int] NOT NULL,
	[login_time] [datetime] NOT NULL,
	[last_batch] [datetime] NOT NULL,
	[cpu] [int] NOT NULL,
	[physical_io] [bigint] NOT NULL,
	[waittime] [bigint] NOT NULL,
	[lastwaittype] [nchar](32) NOT NULL,
	[waitresource] [nchar](256) NOT NULL,
	[InsDate] [datetime] NOT NULL,
	[interface] [nvarchar](32) NULL,
	[ip] [varchar](48) NULL,
	[ecid] [smallint] NULL,
	[hostprocess] [nchar](10) NULL,
	[memusage] [int] NULL,
	[net_library] [nchar](12) NULL,
	[nt_domain] [nchar](128) NULL,
	[nt_username] [nchar](128) NULL,
	[uid] [smallint] NULL,
 CONSTRAINT [PK_DBProcesses] PRIMARY KEY NONCLUSTERED 
(
	[SQLServerID] ASC,
	[spid] ASC,
	[kpid] ASC,
	[InsDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DBProcesses] ADD  DEFAULT ((0)) FOR [kpid]
GO
