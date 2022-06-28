USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Report](
	[ReportID] [int] IDENTITY(1,1) NOT NULL,
	[ReportName] [varchar](100) NULL,
	[ReportAlias] [varchar](50) NULL
) ON [PRIMARY]
GO
