USE [ADCGuardian_20220617]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DBLockInfo](
	[seq] [int] IDENTITY(1,1) NOT NULL,
	[SQLServerID] [smallint] NOT NULL,
	[spid] [smallint] NULL,
	[dbid] [smallint] NULL,
	[objid] [bigint] NULL,
	[indid] [int] NULL,
	[type] [nvarchar](120) NULL,
	[resource] [nvarchar](512) NULL,
	[mode] [nvarchar](120) NULL,
	[status] [nvarchar](120) NULL,
	[InsDate] [datetime] NOT NULL,
	[lockcount] [int] NULL,
 CONSTRAINT [PK_DBLockInfo] PRIMARY KEY NONCLUSTERED 
(
	[seq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DBLockInfo] ADD  DEFAULT (getdate()) FOR [InsDate]
GO
