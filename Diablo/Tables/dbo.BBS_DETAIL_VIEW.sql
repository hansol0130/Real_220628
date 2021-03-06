USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BBS_DETAIL_VIEW](
	[MASTER_SEQ] [dbo].[SEQ_NO] NOT NULL,
	[BBS_SEQ] [int] NOT NULL,
	[COM_TYPE] [int] NOT NULL,
 CONSTRAINT [PK_BBS_DETAIL_VIEW] PRIMARY KEY CLUSTERED 
(
	[MASTER_SEQ] ASC,
	[BBS_SEQ] ASC,
	[COM_TYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BBS_DETAIL_VIEW]  WITH CHECK ADD  CONSTRAINT [R_394] FOREIGN KEY([MASTER_SEQ], [BBS_SEQ])
REFERENCES [dbo].[BBS_DETAIL] ([MASTER_SEQ], [BBS_SEQ])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BBS_DETAIL_VIEW] CHECK CONSTRAINT [R_394]
GO
