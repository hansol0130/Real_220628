USE [VGLog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MEM_CERT_LOG](
	[CERT_SEQ] [int] IDENTITY(1,1) NOT NULL,
	[REQ_NO] [varchar](50) NULL,
	[CERT_TYPE] [int] NULL,
	[PAGE_TYPE] [int] NULL,
	[SERVER_IP] [varchar](50) NULL,
	[CLIENT_IP] [varchar](50) NULL,
	[USER_AGENT] [varchar](1000) NULL,
	[CERT_XML_DATA] [varchar](4000) NULL,
	[RESULT_CODE] [varchar](10) NULL,
	[RESULT_MSG] [varchar](1000) NULL,
	[AUTH_TYPE] [varchar](2) NULL,
	[CUS_NAME] [varchar](50) NULL,
	[BIRTH_DATE] [datetime] NULL,
	[GENDER] [char](1) NULL,
	[IPIN_DUP_INFO] [char](64) NULL,
	[IPIN_CONN_INFO] [char](88) NULL,
	[VSOC_NUM] [char](13) NULL,
	[FOREIGNER_YN] [char](1) NULL,
	[CUS_ID] [varchar](20) NULL,
	[NEW_DATE] [datetime] NULL,
	[CERT_DATE] [datetime] NULL,
 CONSTRAINT [PK_MEM_CERT_LOG] PRIMARY KEY CLUSTERED 
(
	[CERT_SEQ] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
