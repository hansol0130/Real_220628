USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SQLProperty](
	[SQLServerID] [smallint] NOT NULL,
	[PropertyName] [varchar](30) NOT NULL,
	[PropertyValue] [nvarchar](128) NULL,
	[ModDate] [datetime] NOT NULL,
	[InsDate] [datetime] NOT NULL,
 CONSTRAINT [PK_SQLProperty] PRIMARY KEY CLUSTERED 
(
	[SQLServerID] ASC,
	[PropertyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SQLProperty]  WITH CHECK ADD  CONSTRAINT [FK_SQLProperty_SQLServerID_for_SQLServerList] FOREIGN KEY([SQLServerID])
REFERENCES [dbo].[SQLServerList] ([SQLServerID])
GO
ALTER TABLE [dbo].[SQLProperty] CHECK CONSTRAINT [FK_SQLProperty_SQLServerID_for_SQLServerList]
GO
