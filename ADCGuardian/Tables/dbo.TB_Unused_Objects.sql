USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TB_Unused_Objects](
	[InsDate] [datetime] NOT NULL,
	[DBName] [nvarchar](128) NOT NULL,
	[ObjType] [nchar](2) NOT NULL,
	[SchemaName] [nvarchar](128) NOT NULL,
	[ObjName] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_TB_Unused_Objects] PRIMARY KEY CLUSTERED 
(
	[InsDate] ASC,
	[DBName] ASC,
	[ObjType] ASC,
	[SchemaName] ASC,
	[ObjName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
