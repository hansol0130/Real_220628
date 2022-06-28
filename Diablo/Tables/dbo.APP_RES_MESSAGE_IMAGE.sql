USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[APP_RES_MESSAGE_IMAGE](
	[IMG_SEQ_NO] [int] NOT NULL,
	[RES_SEQ_NO] [int] NOT NULL,
	[IMG_TYPE] [int] NULL,
	[FILENAME] [varchar](200) NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[NEW_DATE] [datetime] NULL,
 CONSTRAINT [PK_APP_RES_MESSAGE_IMAGE] PRIMARY KEY CLUSTERED 
(
	[IMG_SEQ_NO] ASC,
	[RES_SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[APP_RES_MESSAGE_IMAGE]  WITH CHECK ADD  CONSTRAINT [R_APP_RES_MESSAGE_TO_APP_RES_MESSAGE_IMAGE] FOREIGN KEY([RES_SEQ_NO])
REFERENCES [dbo].[APP_RES_MESSAGE] ([RES_SEQ_NO])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[APP_RES_MESSAGE_IMAGE] CHECK CONSTRAINT [R_APP_RES_MESSAGE_TO_APP_RES_MESSAGE_IMAGE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이미지순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RES_MESSAGE_IMAGE', @level2type=N'COLUMN',@level2name=N'IMG_SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RES_MESSAGE_IMAGE', @level2type=N'COLUMN',@level2name=N'RES_SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이미지종류' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RES_MESSAGE_IMAGE', @level2type=N'COLUMN',@level2name=N'IMG_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RES_MESSAGE_IMAGE', @level2type=N'COLUMN',@level2name=N'FILENAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RES_MESSAGE_IMAGE', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RES_MESSAGE_IMAGE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객알림예약이미지' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RES_MESSAGE_IMAGE'
GO
