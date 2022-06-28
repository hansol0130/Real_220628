USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DBSize](
	[SQLServerID] [smallint] NOT NULL,
	[DBName] [varchar](128) NOT NULL,
	[InsDate] [datetime] NOT NULL,
	[Data] [decimal](9, 1) NULL,
	[Data_Used] [decimal](9, 1) NULL,
	[Data_Percent] [decimal](9, 1) NULL,
	[Data_Free] [decimal](9, 1) NULL,
	[Data_Free_Percent] [decimal](9, 1) NULL,
	[Log] [decimal](9, 1) NULL,
	[Log_Used] [decimal](9, 1) NULL,
	[Log_Percent] [decimal](9, 1) NULL,
	[Log_Free] [decimal](9, 1) NULL,
	[Log_Free_Percent] [decimal](9, 1) NULL,
 CONSTRAINT [PK_DBSize] PRIMARY KEY CLUSTERED 
(
	[InsDate] ASC,
	[SQLServerID] ASC,
	[DBName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
