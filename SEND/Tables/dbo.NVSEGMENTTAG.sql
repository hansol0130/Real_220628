USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NVSEGMENTTAG](
	[TAG_NO] [numeric](10, 0) NOT NULL,
	[TAG_NM] [varchar](50) NULL,
 CONSTRAINT [PK_NVSEGMENTTAG] PRIMARY KEY CLUSTERED 
(
	[TAG_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
