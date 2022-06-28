USE [ADCGuardian_20220617]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AliveWatch](
	[ServerID] [smallint] NOT NULL,
	[SQLServerID] [smallint] NOT NULL,
	[ALiveYN] [char](1) NOT NULL,
	[SQLALiveYN] [char](1) NOT NULL,
	[LastCheckTime] [datetime] NOT NULL,
	[SQLLastCheckTime] [datetime] NOT NULL,
 CONSTRAINT [PK_AliveWatch] PRIMARY KEY NONCLUSTERED 
(
	[ServerID] ASC,
	[SQLServerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AliveWatch] ADD  CONSTRAINT [DF_AliveWatch_ALiveYN]  DEFAULT ('N') FOR [ALiveYN]
GO
ALTER TABLE [dbo].[AliveWatch] ADD  CONSTRAINT [DF_AliveWatch_SQLALiveYN]  DEFAULT ('N') FOR [SQLALiveYN]
GO
ALTER TABLE [dbo].[AliveWatch] ADD  CONSTRAINT [DF_AliveWatch_LastCheckTime]  DEFAULT (getdate()) FOR [LastCheckTime]
GO
ALTER TABLE [dbo].[AliveWatch] ADD  CONSTRAINT [DF_AliveWatch_SQLLastCheckTime]  DEFAULT (getdate()) FOR [SQLLastCheckTime]
GO
