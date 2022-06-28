USE [ADCGuardian_20220617]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AliveWatchHistory](
	[ServerID] [smallint] NOT NULL,
	[SQLServerID] [smallint] NOT NULL,
	[StatusFlag] [char](1) NULL,
	[SQLYN] [char](1) NOT NULL,
	[InsDate] [datetime] NOT NULL,
 CONSTRAINT [PK__AliveWatchHistory] PRIMARY KEY NONCLUSTERED 
(
	[ServerID] ASC,
	[SQLServerID] ASC,
	[SQLYN] ASC,
	[InsDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AliveWatchHistory] ADD  CONSTRAINT [DF__AliveWatchHistory_InsDate]  DEFAULT (getdate()) FOR [InsDate]
GO
ALTER TABLE [dbo].[AliveWatchHistory]  WITH CHECK ADD  CONSTRAINT [CK__AliveWatchHistory_SQLYN] CHECK  (([SQLYN]='N' OR [SQLYN]='Y'))
GO
ALTER TABLE [dbo].[AliveWatchHistory] CHECK CONSTRAINT [CK__AliveWatchHistory_SQLYN]
GO
ALTER TABLE [dbo].[AliveWatchHistory]  WITH CHECK ADD  CONSTRAINT [CK__AliveWatchHistory_StatusFlag] CHECK  (([StatusFlag]='N' OR [StatusFlag]='Y'))
GO
ALTER TABLE [dbo].[AliveWatchHistory] CHECK CONSTRAINT [CK__AliveWatchHistory_StatusFlag]
GO
