USE [ADCGuardian_20220617]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SQLConfigHistory](
	[SQLServerID] [smallint] NOT NULL,
	[ModDate] [datetime] NOT NULL,
	[Name] [nvarchar](35) NOT NULL,
	[BeforeRunValue] [int] NOT NULL,
	[AfterRunValue] [int] NOT NULL,
 CONSTRAINT [PK_SQLConfigHistory] PRIMARY KEY NONCLUSTERED 
(
	[SQLServerID] ASC,
	[ModDate] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SQLConfigHistory]  WITH CHECK ADD  CONSTRAINT [FK_SQLConfigHistory_SQLServerIDName_for_SQLConfig] FOREIGN KEY([SQLServerID], [Name])
REFERENCES [dbo].[SQLConfig] ([SQLServerID], [Name])
GO
ALTER TABLE [dbo].[SQLConfigHistory] CHECK CONSTRAINT [FK_SQLConfigHistory_SQLServerIDName_for_SQLConfig]
GO
