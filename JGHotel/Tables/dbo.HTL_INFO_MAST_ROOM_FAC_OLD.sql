USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_INFO_MAST_ROOM_FAC_OLD](
	[HOTEL_CODE] [int] NOT NULL,
	[ROOM_CODE] [varchar](50) NOT NULL,
	[AMEN_CODE] [varchar](50) NOT NULL,
	[AMEN_NAME] [varchar](500) NULL,
	[CREATE_DATE] [datetime] NULL,
 CONSTRAINT [PK_HTL_INFO_MAST_ROOM_FAC] PRIMARY KEY CLUSTERED 
(
	[HOTEL_CODE] ASC,
	[ROOM_CODE] ASC,
	[AMEN_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
