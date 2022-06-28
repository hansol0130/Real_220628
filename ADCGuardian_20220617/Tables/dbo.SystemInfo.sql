USE [ADCGuardian_20220617]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SystemInfo](
	[ServerID] [smallint] NOT NULL,
	[Item] [varchar](45) NOT NULL,
	[DataValue] [varchar](100) NULL,
	[ModDate] [datetime] NOT NULL,
	[InsDate] [datetime] NOT NULL,
 CONSTRAINT [PK_SystemInfo] PRIMARY KEY CLUSTERED 
(
	[ServerID] ASC,
	[Item] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SystemInfo]  WITH CHECK ADD  CONSTRAINT [FK_SystemInfo_ServerID_for_ServerList] FOREIGN KEY([ServerID])
REFERENCES [dbo].[ServerList] ([ServerID])
GO
ALTER TABLE [dbo].[SystemInfo] CHECK CONSTRAINT [FK_SystemInfo_ServerID_for_ServerList]
GO
