USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SQLPropertyHistory](
	[SQLServerID] [smallint] NOT NULL,
	[ModDate] [datetime] NOT NULL,
	[PropertyName] [varchar](30) NOT NULL,
	[BeforePropertyValue] [nvarchar](128) NULL,
	[AfterPropertyValue] [nvarchar](128) NULL,
 CONSTRAINT [PK_SQLPropertyHistory] PRIMARY KEY NONCLUSTERED 
(
	[SQLServerID] ASC,
	[ModDate] ASC,
	[PropertyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SQLPropertyHistory]  WITH CHECK ADD  CONSTRAINT [FK_SQLPropertyHistory_SQLServerIDPropertyName_for_SQLProperty] FOREIGN KEY([SQLServerID], [PropertyName])
REFERENCES [dbo].[SQLProperty] ([SQLServerID], [PropertyName])
GO
ALTER TABLE [dbo].[SQLPropertyHistory] CHECK CONSTRAINT [FK_SQLPropertyHistory_SQLServerIDPropertyName_for_SQLProperty]
GO
