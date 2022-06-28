USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_SYST_USER](
	[USER_ID] [varchar](30) NOT NULL,
	[COMPANY_ID] [varchar](20) NULL,
	[USER_NAME] [varchar](20) NULL,
	[PASSWORD] [varchar](100) NULL,
	[USE_YN] [varchar](1) NULL,
	[CONTACT_TEL] [varchar](20) NULL,
	[CONTACT_FAX] [varchar](20) NULL,
	[CONTACT_EMAIL] [varchar](50) NULL,
	[BIGO] [varchar](500) NULL,
	[USER_RANK] [varchar](50) NULL,
	[CREATE_USER] [varchar](20) NULL,
	[CREATE_DATE] [datetime] NULL,
	[UPDATE_USER] [varchar](20) NULL,
	[UPDATE_DATE] [datetime] NULL,
	[DEPARTMENT_CODE] [varchar](20) NULL,
	[DEPARTMENT_NAME] [varchar](50) NULL,
	[POSITION_CODE] [varchar](20) NULL,
	[POSITION_NAME] [varchar](50) NULL,
	[ACC_ID] [varchar](30) NULL,
	[USER_TYPE] [varchar](4) NULL,
	[PWD_CREATE_DATE] [datetime] NULL,
	[PWD_CREATE_USER] [varchar](50) NULL,
	[PWD_UPDATE_DATE] [datetime] NULL,
	[PWD_UPDATE_USER] [varchar](50) NULL,
 CONSTRAINT [PK_HTL_SYST_USER] PRIMARY KEY CLUSTERED 
(
	[USER_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO