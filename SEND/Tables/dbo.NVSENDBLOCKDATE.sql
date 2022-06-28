USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NVSENDBLOCKDATE](
	[CHK_YEAR] [char](4) NOT NULL,
	[BLOCK_DT] [char](4) NOT NULL,
	[CHANNEL_TYPE] [char](1) NOT NULL,
 CONSTRAINT [PK_NVSENDBLOCKDATE] PRIMARY KEY CLUSTERED 
(
	[CHK_YEAR] ASC,
	[BLOCK_DT] ASC,
	[CHANNEL_TYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NVSENDBLOCKDATE] ADD  DEFAULT ('M') FOR [CHANNEL_TYPE]
GO
