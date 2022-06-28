USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[_PKG_DETAIL_UPDATE_NAVER_HISTORY](
	[SEQ_NO] [int] IDENTITY(1,1) NOT NULL,
	[MASTER_CODE] [varchar](10) NULL,
	[PRO_CODE] [varchar](20) NULL,
	[UPDATE_TYPE] [varchar](20) NULL,
	[UPDATE_TARGET] [varchar](20) NULL,
	[RESULT_CODE] [varchar](20) NULL,
	[RESULT_TEXT] [varchar](1000) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[EMP_CODE] NULL,
	[EDT_DATE] [datetime] NULL
) ON [PRIMARY]
GO
