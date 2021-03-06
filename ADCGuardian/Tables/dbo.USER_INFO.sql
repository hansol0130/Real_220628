USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[USER_INFO](
	[USER_ID] [varchar](30) NOT NULL,
	[USER_NAME] [varchar](60) NULL,
	[PWD] [varchar](60) NULL,
	[ORG] [varchar](100) NULL,
	[TITLE] [varchar](20) NULL,
	[TELNUM] [varchar](30) NULL,
	[MOBILE] [varchar](30) NULL,
	[EMAIL] [varchar](50) NULL,
	[ROLE_ID] [varchar](10) NULL,
	[ACTIVE_YN] [varchar](1) NULL,
	[DEL_YN] [varchar](1) NULL,
	[DESCRT] [text] NULL,
	[INS_DATE] [varchar](30) NULL,
	[UPD_DATE] [varchar](30) NULL,
	[USER_OPTIONS] [varchar](8000) NULL,
PRIMARY KEY CLUSTERED 
(
	[USER_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[USER_INFO]  WITH CHECK ADD  CONSTRAINT [FK_USER_INFO_ROLE_ID] FOREIGN KEY([ROLE_ID])
REFERENCES [dbo].[ROLE_INFO] ([ROLE_ID])
GO
ALTER TABLE [dbo].[USER_INFO] CHECK CONSTRAINT [FK_USER_INFO_ROLE_ID]
GO
