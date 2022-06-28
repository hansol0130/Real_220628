USE [ADCGuardian_20220617]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DBJobInfo](
	[SQLServerID] [smallint] NOT NULL,
	[name] [sysname] NOT NULL,
	[run_result] [nvarchar](6) NULL,
	[run_duration] [varchar](14) NULL,
	[description] [nvarchar](512) NULL,
	[enabled] [nvarchar](6) NULL,
	[last_run_date] [datetime] NULL,
	[next_run_date] [datetime] NULL,
	[step_count] [int] NULL,
	[date_created] [datetime] NULL,
	[date_modified] [datetime] NULL,
	[InsDate] [datetime] NOT NULL,
 CONSTRAINT [PK_DBJobInfo] PRIMARY KEY CLUSTERED 
(
	[InsDate] ASC,
	[SQLServerID] ASC,
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
