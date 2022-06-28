USE [ADCGuardian_20220617]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SQLServerList](
	[SQLServerID] [smallint] IDENTITY(1,1) NOT NULL,
	[ServerID] [smallint] NOT NULL,
	[ServerFullName] [varchar](128) NULL,
	[ServerName] [varchar](128) NULL,
	[LoginID] [varchar](100) NOT NULL,
	[Password] [varchar](100) NOT NULL,
	[ServerMajorVersion] [tinyint] NULL,
	[Remarks] [varchar](256) NULL,
	[UseYN] [char](1) NOT NULL,
	[DispYN] [char](1) NOT NULL,
 CONSTRAINT [PK_SQLServerList] PRIMARY KEY CLUSTERED 
(
	[SQLServerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SQLServerList] ADD  CONSTRAINT [DF_SQLServer_UseYN]  DEFAULT ('Y') FOR [UseYN]
GO
ALTER TABLE [dbo].[SQLServerList] ADD  CONSTRAINT [DF_SQLServerList_DispYN]  DEFAULT ('Y') FOR [DispYN]
GO
