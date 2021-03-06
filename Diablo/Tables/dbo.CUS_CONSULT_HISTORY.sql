USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUS_CONSULT_HISTORY](
	[CON_NO] [int] NOT NULL,
	[SEQ_NO] [int] NOT NULL,
	[CITY_CODE] [char](3) NULL,
	[START_DATE] [datetime] NULL,
	[END_DATE] [datetime] NULL,
	[PRO_CODE] [varchar](20) NULL,
	[NEW_DATE] [datetime] NULL,
 CONSTRAINT [PK_CUS_CONSULT_HISTORY] PRIMARY KEY CLUSTERED 
(
	[CON_NO] ASC,
	[SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CUS_CONSULT_HISTORY]  WITH CHECK ADD  CONSTRAINT [FK__CUS_CONSU__CON_N__2779CBAB] FOREIGN KEY([CON_NO])
REFERENCES [dbo].[CUS_CONSULT] ([CON_NO])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CUS_CONSULT_HISTORY] CHECK CONSTRAINT [FK__CUS_CONSU__CON_N__2779CBAB]
GO
