USE [ADCGuardian_20220617]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OldDataDelSchedule](
	[DelJobID] [smallint] NOT NULL,
	[DelJobIDName] [varchar](128) NULL,
	[NoUseDate] [int] NOT NULL,
 CONSTRAINT [PK_DelJobID] PRIMARY KEY CLUSTERED 
(
	[DelJobID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OldDataDelSchedule] ADD  DEFAULT ((100)) FOR [NoUseDate]
GO
