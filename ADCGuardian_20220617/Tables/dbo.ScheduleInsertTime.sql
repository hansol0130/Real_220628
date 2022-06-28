USE [ADCGuardian_20220617]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ScheduleInsertTime](
	[ScheduledInsertID] [int] IDENTITY(1,1) NOT NULL,
	[CounterID] [int] NOT NULL,
	[ServerID] [smallint] NOT NULL,
	[SQLServerID] [smallint] NOT NULL,
	[DataListCode] [char](17) NOT NULL,
	[InsType] [char](1) NOT NULL,
	[InsFrequency] [int] NULL,
	[InsDayTime] [char](8) NULL,
	[InsWeekDay] [tinyint] NULL,
	[InsMonthDay] [tinyint] NULL,
	[LastInsDate] [datetime] NULL,
 CONSTRAINT [PK_ScheduleInsertTime] PRIMARY KEY CLUSTERED 
(
	[ScheduledInsertID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ScheduleInsertTime] ADD  DEFAULT ((0)) FOR [CounterID]
GO
ALTER TABLE [dbo].[ScheduleInsertTime] ADD  DEFAULT ((0)) FOR [ServerID]
GO
ALTER TABLE [dbo].[ScheduleInsertTime] ADD  DEFAULT ((0)) FOR [SQLServerID]
GO
ALTER TABLE [dbo].[ScheduleInsertTime] ADD  CONSTRAINT [DF_ScheduleInsertTime_InsType]  DEFAULT ('F') FOR [InsType]
GO
