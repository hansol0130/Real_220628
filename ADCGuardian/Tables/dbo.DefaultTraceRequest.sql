USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DefaultTraceRequest](
	[Request_ID] [int] IDENTITY(1,1) NOT NULL,
	[SQLServerID] [smallint] NOT NULL,
	[Request_Time] [datetime] NULL,
	[Complete_YN] [nvarchar](1) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DefaultTraceRequest] ADD  DEFAULT (getdate()) FOR [Request_Time]
GO
ALTER TABLE [dbo].[DefaultTraceRequest] ADD  DEFAULT ('N') FOR [Complete_YN]
GO
