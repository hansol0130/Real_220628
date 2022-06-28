USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExecQueryCost](
	[SQLServerID] [smallint] NOT NULL,
	[session_id] [smallint] NOT NULL,
	[start_time] [datetime] NOT NULL,
	[status] [nvarchar](30) NOT NULL,
	[command] [nvarchar](16) NOT NULL,
	[Parallel_cnt] [smallint] NULL,
	[CPU] [int] NULL,
	[Duration] [int] NOT NULL,
	[LReads] [bigint] NOT NULL,
	[PReads] [bigint] NOT NULL,
	[writes] [bigint] NOT NULL,
	[host_name] [nvarchar](128) NULL,
	[login_name] [nvarchar](128) NOT NULL,
	[db_name] [nvarchar](128) NULL,
	[user_name] [nvarchar](128) NULL,
	[blocking_session_id] [smallint] NULL,
	[wait_type] [nvarchar](60) NULL,
	[wait_time] [int] NOT NULL,
	[last_wait_type] [nvarchar](60) NOT NULL,
	[wait_resource] [nvarchar](256) NOT NULL,
	[object_name] [nvarchar](128) NULL,
	[encrypted] [bit] NOT NULL,
	[statement_start_offset] [int] NULL,
	[statement_end_offset] [int] NULL,
	[text] [varchar](8000) NULL,
	[LastViewDate] [datetime] NOT NULL,
	[CPU_SEQ] [int] NULL,
	[Duration_SEQ] [int] NULL,
	[Reads_SEQ] [int] NULL,
 CONSTRAINT [PK_ExecQueryCost] PRIMARY KEY CLUSTERED 
(
	[LastViewDate] ASC,
	[SQLServerID] ASC,
	[session_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ExecQueryCost]  WITH CHECK ADD  CONSTRAINT [FK_ExecQueryCost_CP_REACH_LIST_cpu] FOREIGN KEY([CPU_SEQ])
REFERENCES [dbo].[CP_REACH_LIST] ([SEQ])
GO
ALTER TABLE [dbo].[ExecQueryCost] CHECK CONSTRAINT [FK_ExecQueryCost_CP_REACH_LIST_cpu]
GO
ALTER TABLE [dbo].[ExecQueryCost]  WITH CHECK ADD  CONSTRAINT [FK_ExecQueryCost_CP_REACH_LIST_Duration] FOREIGN KEY([Duration_SEQ])
REFERENCES [dbo].[CP_REACH_LIST] ([SEQ])
GO
ALTER TABLE [dbo].[ExecQueryCost] CHECK CONSTRAINT [FK_ExecQueryCost_CP_REACH_LIST_Duration]
GO
ALTER TABLE [dbo].[ExecQueryCost]  WITH CHECK ADD  CONSTRAINT [FK_ExecQueryCost_CP_REACH_LIST_Reads] FOREIGN KEY([Reads_SEQ])
REFERENCES [dbo].[CP_REACH_LIST] ([SEQ])
GO
ALTER TABLE [dbo].[ExecQueryCost] CHECK CONSTRAINT [FK_ExecQueryCost_CP_REACH_LIST_Reads]
GO
