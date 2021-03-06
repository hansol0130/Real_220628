USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NVADMINLOG](
	[SESSION_TIME] [varchar](14) NOT NULL,
	[USER_ID] [varchar](15) NOT NULL,
	[ADMINLOG_TYPE] [char](1) NOT NULL,
	[SOEID] [varchar](7) NULL,
	[USER_NM] [varchar](50) NULL,
	[JOB_DOC] [varchar](100) NULL,
	[GRP_CD] [varchar](12) NULL,
	[USERTYPE_CD] [char](1) NULL,
	[MAKER_ID] [varchar](50) NULL,
	[STATUS] [char](1) NULL,
	[CHECKER_ID] [varchar](50) NULL,
 CONSTRAINT [PK_NVADMINLOG] PRIMARY KEY CLUSTERED 
(
	[SESSION_TIME] ASC,
	[USER_ID] ASC,
	[ADMINLOG_TYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
