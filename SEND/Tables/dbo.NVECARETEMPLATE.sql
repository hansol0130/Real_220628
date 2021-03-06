USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NVECARETEMPLATE](
	[ECARE_NO] [numeric](15, 0) NOT NULL,
	[SEG] [varchar](20) NOT NULL,
	[TEMPLATE] [text] NULL,
 CONSTRAINT [PK_NVECARETEMPLATE] PRIMARY KEY CLUSTERED 
(
	[ECARE_NO] ASC,
	[SEG] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[NVECARETEMPLATE]  WITH CHECK ADD  CONSTRAINT [FK_ECAREMSG_ECARETEMPLATE] FOREIGN KEY([ECARE_NO])
REFERENCES [dbo].[NVECAREMSG] ([ECARE_NO])
GO
ALTER TABLE [dbo].[NVECARETEMPLATE] CHECK CONSTRAINT [FK_ECAREMSG_ECARETEMPLATE]
GO
