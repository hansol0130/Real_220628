USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COM_BBS_FILE](
	[MASTER_SEQ] [int] NOT NULL,
	[BOARD_SEQ] [int] NOT NULL,
	[FILE_SEQ] [int] NOT NULL,
	[FILE_NAME] [nvarchar](255) NULL,
	[FILE_PATH] [varchar](200) NULL,
 CONSTRAINT [PK_COM_BBS_FILE] PRIMARY KEY CLUSTERED 
(
	[MASTER_SEQ] ASC,
	[BOARD_SEQ] ASC,
	[FILE_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
