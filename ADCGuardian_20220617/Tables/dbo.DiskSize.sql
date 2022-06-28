USE [ADCGuardian_20220617]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DiskSize](
	[ServerID] [smallint] NOT NULL,
	[InsDate] [datetime] NOT NULL,
	[Drive] [char](1) NOT NULL,
	[TotalSize] [bigint] NULL,
	[FreeSpace] [bigint] NULL,
 CONSTRAINT [PK_DiskSize] PRIMARY KEY CLUSTERED 
(
	[InsDate] ASC,
	[ServerID] ASC,
	[Drive] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO