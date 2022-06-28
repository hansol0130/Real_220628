USE [VGLog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYS_APP_ACCESS_LOG](
	[SEQ_NO] [int] IDENTITY(1,1) NOT NULL,
	[LOG_TYPE] [int] NULL,
	[CLIENT_IP] [varchar](15) NULL,
	[EMP_NAME] [varchar](20) NULL,
	[EMP_CODE] [char](7) NULL,
	[URL] [varchar](200) NULL,
	[TITLE] [varchar](200) NULL,
	[BODY] [varchar](max) NULL,
	[ALLOW_YN] [char](1) NULL,
	[NEW_DATE] [datetime] NULL,
 CONSTRAINT [PK_SYS_APP_ACCESS_LOG] PRIMARY KEY CLUSTERED 
(
	[SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYS_APP_ACCESS_LOG] ADD  DEFAULT (getdate()) FOR [NEW_DATE]
GO