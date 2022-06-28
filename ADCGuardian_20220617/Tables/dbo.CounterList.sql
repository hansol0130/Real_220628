USE [ADCGuardian_20220617]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CounterList](
	[CounterID] [int] IDENTITY(1,1) NOT NULL,
	[ServerID] [smallint] NOT NULL,
	[Object] [nvarchar](128) NOT NULL,
	[Counter] [nvarchar](128) NOT NULL,
	[Instance] [nvarchar](128) NOT NULL,
	[DispYN] [char](1) NOT NULL,
	[UseYN] [char](1) NOT NULL,
	[Min] [float] NULL,
	[Max] [float] NULL,
	[Frequency] [int] NOT NULL,
	[QueueSecond] [int] NULL,
	[InsDate] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_CounterList] PRIMARY KEY CLUSTERED 
(
	[CounterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CounterList] ADD  CONSTRAINT [DF_CounterList_DispYN]  DEFAULT ('Y') FOR [DispYN]
GO
ALTER TABLE [dbo].[CounterList] ADD  CONSTRAINT [DF__CounterLi__UseYN__239E4DCF]  DEFAULT ('Y') FOR [UseYN]
GO
ALTER TABLE [dbo].[CounterList] ADD  CONSTRAINT [DF__CounterLi__InsDa__24927208]  DEFAULT (getdate()) FOR [InsDate]
GO
