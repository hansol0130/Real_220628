USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cti].[CTI_LOG](
	[LOG_SEQ] [char](16) NOT NULL,
	[LOG_DATE] [datetime] NULL,
	[LOG_TYPE] [varchar](20) NULL,
	[LOG_CODE] [char](7) NULL,
	[LOG_DESCRIPT] [text] NULL,
	[LOG_IP] [varchar](20) NULL,
 CONSTRAINT [PK_CTI_LOG] PRIMARY KEY CLUSTERED 
(
	[LOG_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
