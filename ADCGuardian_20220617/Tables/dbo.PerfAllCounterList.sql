USE [ADCGuardian_20220617]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PerfAllCounterList](
	[CounterID] [int] IDENTITY(1,1) NOT NULL,
	[ServerID] [smallint] NOT NULL,
	[Object] [nvarchar](128) NOT NULL,
	[Counter] [nvarchar](128) NOT NULL,
	[Instance] [nvarchar](128) NOT NULL,
	[InsDate] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_PerfAllCounterList] PRIMARY KEY NONCLUSTERED 
(
	[CounterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PerfAllCounterList] ADD  CONSTRAINT [DF__PerfAllCo__InsDa__2E1BDC42]  DEFAULT (getdate()) FOR [InsDate]
GO
