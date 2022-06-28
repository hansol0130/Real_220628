USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DBTableSizeLog](
	[SQLServerID] [smallint] NOT NULL,
	[DBName] [nvarchar](128) NOT NULL,
	[SchemaName] [nvarchar](128) NOT NULL,
	[TableName] [nvarchar](128) NOT NULL,
	[type] [char](1) NOT NULL,
	[actDateFrom] [datetime] NOT NULL,
	[actDateTo] [datetime] NOT NULL,
 CONSTRAINT [PK_DBTableSizeLog] PRIMARY KEY CLUSTERED 
(
	[actDateTo] ASC,
	[SQLServerID] ASC,
	[DBName] ASC,
	[type] ASC,
	[SchemaName] ASC,
	[TableName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
