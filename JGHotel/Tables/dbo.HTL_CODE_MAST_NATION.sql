USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_CODE_MAST_NATION](
	[NATION_CODE] [varchar](2) NOT NULL,
	[NATION_NAME] [varchar](50) NULL,
	[NATION_ENAME] [varchar](50) NULL,
	[REGION_CODE] [varchar](4) NULL,
	[REGION_NAME] [varchar](50) NULL,
	[REGION_ENAME] [varchar](50) NULL,
	[USE_YN] [varchar](1) NULL,
	[CREATE_DATE] [datetime] NULL,
	[CREATE_USER] [varchar](7) NULL,
	[UPDATE_DATE] [datetime] NULL,
	[UPDATE_USER] [varchar](7) NULL,
 CONSTRAINT [PK_HTL_CODE_MAST_NATION] PRIMARY KEY CLUSTERED 
(
	[NATION_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO