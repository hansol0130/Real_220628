USE [ADCGuardian_20220617]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CounterListTemplate](
	[DataListID] [int] NOT NULL,
	[Object] [varchar](100) NOT NULL,
	[Counter] [varchar](100) NOT NULL,
	[Instance] [varchar](100) NOT NULL,
	[DispYN] [char](1) NOT NULL,
	[UseYN] [char](1) NOT NULL,
	[Min] [float] NULL,
	[Max] [float] NULL,
	[Frequency] [smallint] NULL,
	[QueueSecond] [int] NULL,
 CONSTRAINT [PK_CounterListTemplate] PRIMARY KEY NONCLUSTERED 
(
	[DataListID] ASC,
	[Object] ASC,
	[Counter] ASC,
	[Instance] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
