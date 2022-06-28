USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RES_SVC_REQ_DATA](
	[SEQ_NO] [int] IDENTITY(1,1) NOT NULL,
	[RES_KEY] [varchar](200) NULL,
	[PRO_TYPE] [int] NULL,
	[RES_CODE] [dbo].[RES_CODE] NULL,
	[CUS_NO] [int] NULL,
	[LOGIN_INFO] [varchar](2000) NULL,
	[SERVER_IP] [varchar](100) NULL,
	[CLIENT_IP] [varchar](100) NULL,
	[INPUT_DATA] [varchar](max) NULL,
	[REQ_DATA] [varchar](max) NULL,
	[RES_DATA] [varchar](max) NULL,
	[USER_AGENT] [varchar](max) NULL,
	[COOKIE_DATA] [varchar](max) NULL,
	[PG_APP_NO] [varchar](1000) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[SUCC_YN] [char](1) NULL,
	[COMP_YN] [char](1) NULL,
	[COMP_DATE] [datetime] NULL,
	[REMARK] [varchar](2000) NULL,
	[TYPE_CODE] [varchar](3) NULL,
	[PARAM_DATA] [varchar](max) NULL,
 CONSTRAINT [PK_RES_SVC_REQ_DATA] PRIMARY KEY CLUSTERED 
(
	[SEQ_NO] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO