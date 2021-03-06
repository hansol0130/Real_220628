USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NVECAREMULTIPARTFILE](
	[ECARE_NO] [numeric](15, 0) NOT NULL,
	[SEQ] [numeric](10, 0) NOT NULL,
	[FILE_ALIAS] [varchar](100) NOT NULL,
	[FILE_PATH] [varchar](250) NOT NULL,
	[FILE_SIZE] [numeric](15, 0) NOT NULL,
	[FILE_NAME] [varchar](100) NOT NULL,
 CONSTRAINT [PK_NVECAREMLTPARTFILE] PRIMARY KEY CLUSTERED 
(
	[ECARE_NO] ASC,
	[SEQ] ASC,
	[FILE_ALIAS] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NVECAREMULTIPARTFILE]  WITH CHECK ADD  CONSTRAINT [FK_NVECAREMSG_FILE] FOREIGN KEY([ECARE_NO])
REFERENCES [dbo].[NVECAREMSG] ([ECARE_NO])
GO
ALTER TABLE [dbo].[NVECAREMULTIPARTFILE] CHECK CONSTRAINT [FK_NVECAREMSG_FILE]
GO
