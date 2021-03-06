USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NV_PERMISSION_TEMPLATE](
	[PERMISSION_TEMPLATE_NO] [numeric](8, 0) NOT NULL,
	[PERMISSION_TEMPLATE_NM] [varchar](50) NULL,
	[PERMISSION_DESC] [varchar](100) NULL,
	[USER_ID] [varchar](15) NULL,
	[CREATE_DT] [char](8) NULL,
	[CREATE_TM] [char](6) NULL,
	[TAG_NO] [numeric](10, 0) NULL,
	[PERMISSION_MENUROLE_NO] [varchar](30) NULL,
	[AUTH_TYPE] [char](1) NULL,
 CONSTRAINT [PK_NV_PERMISSION_TEMPLATE] PRIMARY KEY CLUSTERED 
(
	[PERMISSION_TEMPLATE_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
