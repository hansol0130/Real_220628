USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_INFO_MAST_ROOMTYPE_IMAGE](
	[IMG_SEQ] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[IMG_NO] [int] NULL,
	[HOTEL_CODE] [int] NULL,
	[ROOMTYPE_ID] [varchar](10) NULL,
	[PICTURE_TYPE_ID] [varchar](10) NULL,
	[CAPTION] [varchar](200) NULL,
	[CAPTION_TRANSLATED] [varchar](200) NULL,
	[IMG_THUMB] [varchar](200) NULL,
	[IMG_URL] [varchar](200) NULL,
	[MAIN_YN] [varchar](10) NULL,
	[USE_YN] [varchar](10) NULL,
	[CREATE_DATE] [datetime] NULL,
	[CREATE_USER] [varchar](30) NULL,
	[UPDATE_DATE] [datetime] NULL,
	[UPDATE_USER] [varchar](30) NULL,
 CONSTRAINT [PK_HTL_INFO_MAST__ROOMTYPE_IMAGE_1] PRIMARY KEY CLUSTERED 
(
	[IMG_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HTL_INFO_MAST_ROOMTYPE_IMAGE] ADD  CONSTRAINT [DF_HTL_INFO_MAST_ROOMTYPE_IMAGE_MAIN_YN]  DEFAULT ('N') FOR [MAIN_YN]
GO
ALTER TABLE [dbo].[HTL_INFO_MAST_ROOMTYPE_IMAGE] ADD  CONSTRAINT [DF_HTL_INFO_MAST_ROOMTYPE_IMAGE_USE_YN]  DEFAULT ('Y') FOR [USE_YN]
GO
ALTER TABLE [dbo].[HTL_INFO_MAST_ROOMTYPE_IMAGE] ADD  CONSTRAINT [DF_HTL_INFO_MAST_ROOMTYPE_IMAGE_CREATE_DATE]  DEFAULT (getdate()) FOR [CREATE_DATE]
GO
ALTER TABLE [dbo].[HTL_INFO_MAST_ROOMTYPE_IMAGE] ADD  CONSTRAINT [DF_HTL_INFO_MAST_ROOMTYPE_IMAGE_CREATE_USER]  DEFAULT ('SYSTEM') FOR [CREATE_USER]
GO