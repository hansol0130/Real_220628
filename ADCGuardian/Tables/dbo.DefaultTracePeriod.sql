USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DefaultTracePeriod](
	[SQLServerID] [smallint] NOT NULL,
	[SyncTime] [datetime] NULL,
	[Request] [nvarchar](1) NOT NULL,
	[LastFile] [nvarchar](256) NULL,
	[Delete_Day] [int] NOT NULL,
	[Use_YN] [nvarchar](1) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DefaultTracePeriod] ADD  DEFAULT (N'N') FOR [Request]
GO
ALTER TABLE [dbo].[DefaultTracePeriod] ADD  DEFAULT (N'N') FOR [Use_YN]
GO
