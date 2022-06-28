USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COM_RECEIVE_EMAIL](
	[AGT_CODE] [varchar](10) NOT NULL,
	[EMAIL_SEQ] [int] NOT NULL,
	[TITLE] [varchar](100) NULL,
	[MAIL_TYPE] [int] NULL,
	[SND_EMAIL] [varchar](50) NULL,
	[RCV_EMAIL] [varchar](50) NULL,
	[RCV_NAME] [varchar](20) NULL,
	[EMP_SEQ] [int] NULL,
	[BODY] [nvarchar](max) NULL,
	[RES_CODE] [char](12) NULL,
	[RCV_STATE] [int] NULL,
	[RCV_DATE] [datetime] NULL,
	[CFM_DATE] [datetime] NULL,
	[SND_EMP_CODE] [char](7) NULL,
 CONSTRAINT [PK_COM_RECEIVE_EMAIL] PRIMARY KEY CLUSTERED 
(
	[AGT_CODE] ASC,
	[EMAIL_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_RECEIVE_EMAIL', @level2type=N'COLUMN',@level2name=N'AGT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Email순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_RECEIVE_EMAIL', @level2type=N'COLUMN',@level2name=N'EMAIL_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_RECEIVE_EMAIL', @level2type=N'COLUMN',@level2name=N'TITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메일타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_RECEIVE_EMAIL', @level2type=N'COLUMN',@level2name=N'MAIL_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발신이메일주소' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_RECEIVE_EMAIL', @level2type=N'COLUMN',@level2name=N'SND_EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신이메일주소' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_RECEIVE_EMAIL', @level2type=N'COLUMN',@level2name=N'RCV_EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신자명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_RECEIVE_EMAIL', @level2type=N'COLUMN',@level2name=N'RCV_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'직원번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_RECEIVE_EMAIL', @level2type=N'COLUMN',@level2name=N'EMP_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_RECEIVE_EMAIL', @level2type=N'COLUMN',@level2name=N'BODY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_RECEIVE_EMAIL', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전송결과' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_RECEIVE_EMAIL', @level2type=N'COLUMN',@level2name=N'RCV_STATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전송일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_RECEIVE_EMAIL', @level2type=N'COLUMN',@level2name=N'RCV_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'확인일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_RECEIVE_EMAIL', @level2type=N'COLUMN',@level2name=N'CFM_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발신자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_RECEIVE_EMAIL', @level2type=N'COLUMN',@level2name=N'SND_EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객사직원이메일수신정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_RECEIVE_EMAIL'
GO
