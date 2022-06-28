USE [ADCGuardian_20220617]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SystemInfoHistory](
	[ServerID] [smallint] NOT NULL,
	[ModDate] [datetime] NOT NULL,
	[Item] [varchar](45) NOT NULL,
	[BeforeDataValue] [varchar](100) NULL,
	[AfterDataValue] [varchar](100) NULL,
 CONSTRAINT [PK_SystemInfoHistory] PRIMARY KEY CLUSTERED 
(
	[ServerID] ASC,
	[ModDate] ASC,
	[Item] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SystemInfoHistory]  WITH CHECK ADD  CONSTRAINT [FK_SystemInfoHistory_ServerIDItem_for_SystemInfo] FOREIGN KEY([ServerID], [Item])
REFERENCES [dbo].[SystemInfo] ([ServerID], [Item])
GO
ALTER TABLE [dbo].[SystemInfoHistory] CHECK CONSTRAINT [FK_SystemInfoHistory_ServerIDItem_for_SystemInfo]
GO
