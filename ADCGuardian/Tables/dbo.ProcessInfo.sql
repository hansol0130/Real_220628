USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProcessInfo](
	[ServerID] [smallint] NOT NULL,
	[InsDate] [datetime] NOT NULL,
	[ProcessName] [varchar](128) NULL,
	[ProcessID] [int] NOT NULL,
	[ParentProcessID] [int] NULL,
	[CpuTime] [float] NULL,
	[WorkingSetSize] [int] NULL,
 CONSTRAINT [PK_ProcessInfo] PRIMARY KEY CLUSTERED 
(
	[InsDate] ASC,
	[ServerID] ASC,
	[ProcessID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
