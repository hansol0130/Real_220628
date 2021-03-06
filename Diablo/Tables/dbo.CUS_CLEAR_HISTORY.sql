USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUS_CLEAR_HISTORY](
	[CUS_SEQ] [int] NOT NULL,
	[CUS_NO] [int] NOT NULL,
	[CUS_NAME] [varchar](20) NOT NULL,
	[CUS_GRADE] [int] NULL,
	[BIRTH_DATE] [datetime] NULL,
	[GENDER] [char](1) NULL,
	[EMAIL] [varchar](40) NULL,
	[NOR_TEL1] [varchar](6) NULL,
	[NOR_TEL2] [varchar](5) NULL,
	[NOR_TEL3] [varchar](4) NULL,
	[COM_TEL1] [varchar](6) NULL,
	[COM_TEL2] [varchar](5) NULL,
	[COM_TEL3] [varchar](4) NULL,
	[HOM_TEL1] [varchar](6) NULL,
	[HOM_TEL2] [varchar](5) NULL,
	[HOM_TEL3] [varchar](4) NULL,
 CONSTRAINT [PK_CUS_CLEAR_HISTORY] PRIMARY KEY CLUSTERED 
(
	[CUS_SEQ] ASC,
	[CUS_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
