USE [ADCGuardian_20220617]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServerGroup](
	[ServerGroupID] [int] IDENTITY(1,1) NOT NULL,
	[ServerGroupName] [varchar](30) NOT NULL
) ON [PRIMARY]
GO
