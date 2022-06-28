USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExecQueryCostPlan](
	[SQLServerID] [smallint] NOT NULL,
	[session_id] [smallint] NOT NULL,
	[start_time] [datetime] NOT NULL,
	[query_plan] [xml] NULL,
 CONSTRAINT [PK_ExecQueryCostPlan] PRIMARY KEY CLUSTERED 
(
	[start_time] ASC,
	[SQLServerID] ASC,
	[session_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
