USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EVT_ROULETTE_SMS_TEMP](
	[SEQ] [int] IDENTITY(1,1) NOT NULL,
	[CUS_NAME] [varchar](30) NOT NULL,
	[NOR_TEL1] [char](3) NOT NULL,
	[NOR_TEL2] [char](4) NOT NULL,
	[NOR_TEL3] [char](4) NOT NULL,
	[NEW_DATE] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EVT_ROULETTE_SMS_TEMP] ADD  DEFAULT (getdate()) FOR [NEW_DATE]
GO