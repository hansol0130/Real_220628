USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServerList](
	[ServerID] [smallint] IDENTITY(1,1) NOT NULL,
	[ServerGroupID] [smallint] NOT NULL,
	[ServerIP] [varchar](128) NULL,
	[ServerName] [varchar](128) NOT NULL,
	[ActiveNode] [varchar](128) NULL,
	[ClusterYN] [char](1) NOT NULL,
	[UserID] [varchar](100) NOT NULL,
	[Password] [varchar](100) NOT NULL,
	[Remarks] [varchar](256) NULL,
	[DispYN] [char](1) NOT NULL,
	[UseYN] [char](1) NOT NULL,
 CONSTRAINT [PK_ServerList] PRIMARY KEY CLUSTERED 
(
	[ServerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_ServerList_ServerName] UNIQUE NONCLUSTERED 
(
	[ServerName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ServerList] ADD  CONSTRAINT [DF_ServerList_ServerGroup]  DEFAULT ((1)) FOR [ServerGroupID]
GO
ALTER TABLE [dbo].[ServerList] ADD  CONSTRAINT [DF__ServerList_ClusterYN]  DEFAULT ('N') FOR [ClusterYN]
GO
ALTER TABLE [dbo].[ServerList] ADD  CONSTRAINT [DF__ServerList_DispYN]  DEFAULT ('N') FOR [DispYN]
GO
ALTER TABLE [dbo].[ServerList] ADD  CONSTRAINT [DF__ServerList_UseYN]  DEFAULT ('Y') FOR [UseYN]
GO
