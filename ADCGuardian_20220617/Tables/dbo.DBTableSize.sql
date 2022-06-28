USE [ADCGuardian_20220617]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DBTableSize](
	[SQLServerID] [smallint] NOT NULL,
	[DBName] [nvarchar](128) NOT NULL,
	[InsDate] [datetime] NOT NULL,
	[SchemaName] [nvarchar](128) NOT NULL,
	[TableName] [nvarchar](128) NOT NULL,
	[Rows] [bigint] NULL,
	[Reserved] [bigint] NULL,
	[Data] [bigint] NULL,
	[IndexSize] [bigint] NULL,
	[Unused] [bigint] NULL,
 CONSTRAINT [PK_DBTableSize] PRIMARY KEY CLUSTERED 
(
	[SQLServerID] ASC,
	[DBName] ASC,
	[InsDate] ASC,
	[SchemaName] ASC,
	[TableName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DBTableSize] ADD  CONSTRAINT [DF_DBTableSize_OwnerName]  DEFAULT ('') FOR [SchemaName]
GO
