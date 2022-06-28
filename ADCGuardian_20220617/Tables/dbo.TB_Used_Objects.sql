USE [ADCGuardian_20220617]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TB_Used_Objects](
	[DBName] [nvarchar](128) NOT NULL,
	[ObjType] [nchar](2) NOT NULL,
	[SchemaName] [nvarchar](128) NOT NULL,
	[ObjName] [nvarchar](128) NOT NULL,
	[FirstCaptureDate] [datetime] NULL,
	[LastCaptureDate] [datetime] NULL,
	[CaptureCount] [bigint] NULL,
 CONSTRAINT [PK_TB_Used_Objects] PRIMARY KEY CLUSTERED 
(
	[DBName] ASC,
	[ObjType] ASC,
	[SchemaName] ASC,
	[ObjName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
