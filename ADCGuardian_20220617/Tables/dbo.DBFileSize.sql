USE [ADCGuardian_20220617]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DBFileSize](
	[SQLServerID] [smallint] NOT NULL,
	[DBName] [varchar](128) NOT NULL,
	[InsDate] [datetime] NOT NULL,
	[Name] [varchar](128) NOT NULL,
	[FileSize] [int] NULL,
	[FileName] [nvarchar](512) NULL,
	[FileGroup] [varchar](100) NULL,
 CONSTRAINT [PK_DBFileSize] PRIMARY KEY CLUSTERED 
(
	[InsDate] ASC,
	[SQLServerID] ASC,
	[DBName] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
