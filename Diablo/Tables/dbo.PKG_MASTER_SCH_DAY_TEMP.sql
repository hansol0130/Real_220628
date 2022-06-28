USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_MASTER_SCH_DAY_TEMP](
	[MASTER_CODE] [dbo].[MASTER_CODE] NOT NULL,
	[DAY_SEQ] [int] NOT NULL,
	[DAY_NUMBER] [int] NULL,
 CONSTRAINT [PK_PKG_MASTER_SCH_DAY_TEMP] PRIMARY KEY CLUSTERED 
(
	[MASTER_CODE] ASC,
	[DAY_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
