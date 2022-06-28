USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_RESV_SEND](
	[SEND_NO] [int] NOT NULL,
	[SEND_TYPE] [varchar](1) NULL,
	[SEND_FROM] [varchar](100) NULL,
	[SEND_TO] [varchar](100) NULL,
	[RESV_TYPE] [varchar](3) NULL,
	[RESV_NO] [int] NULL,
	[SEND_MSG] [varchar](4000) NULL,
	[CREATE_DATE] [datetime] NULL,
	[CREATE_USER] [varchar](30) NULL,
 CONSTRAINT [PK_TBL_RESV_SEND] PRIMARY KEY CLUSTERED 
(
	[SEND_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
