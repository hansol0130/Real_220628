USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DBIdentityCheck](
	[SQLServerID] [smallint] NOT NULL,
	[DBName] [nvarchar](128) NOT NULL,
	[InsDate] [datetime] NOT NULL,
	[SchemaName] [nvarchar](128) NOT NULL,
	[TabName] [nvarchar](128) NOT NULL,
	[ColName] [nvarchar](128) NOT NULL,
	[DataType] [varchar](20) NULL,
	[MaxVal] [numeric](38, 0) NULL,
	[CurMax] [numeric](38, 0) NULL,
	[Seed] [numeric](38, 0) NULL,
	[Incr] [numeric](38, 0) NULL,
	[Rate] [numeric](5, 2) NULL,
 CONSTRAINT [PK_DBIdentityCheck] PRIMARY KEY CLUSTERED 
(
	[InsDate] ASC,
	[SQLServerID] ASC,
	[DBName] ASC,
	[SchemaName] ASC,
	[TabName] ASC,
	[ColName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
