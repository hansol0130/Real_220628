USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServiceInfo](
	[ServerID] [smallint] NOT NULL,
	[InsDate] [datetime] NOT NULL,
	[SvcName] [varchar](100) NOT NULL,
	[ProcessId] [int] NULL,
	[State] [varchar](30) NULL,
	[Status] [varchar](15) NULL,
	[DisplayName] [varchar](300) NULL,
 CONSTRAINT [PK_ServiceInfo] PRIMARY KEY CLUSTERED 
(
	[InsDate] ASC,
	[ServerID] ASC,
	[SvcName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
