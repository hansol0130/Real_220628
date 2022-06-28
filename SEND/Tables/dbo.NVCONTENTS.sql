USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NVCONTENTS](
	[CONTS_NO] [numeric](8, 0) NOT NULL,
	[GRP_CD] [varchar](12) NULL,
	[CATEGORY_CD] [varchar](12) NULL,
	[USER_ID] [varchar](15) NULL,
	[CONTS_NM] [varchar](50) NULL,
	[CONTS_DESC] [varchar](100) NULL,
	[FILE_URL_NAME] [varchar](500) NULL,
	[FILE_TYPE] [char](1) NULL,
	[FILE_NAME] [varchar](250) NULL,
	[CREATE_DT] [char](8) NULL,
	[CREATE_TM] [char](6) NULL,
	[AUTH_TYPE] [char](1) NULL,
	[TAG_NO] [numeric](10, 0) NULL,
 CONSTRAINT [PK_NVCONTENTS] PRIMARY KEY CLUSTERED 
(
	[CONTS_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NVCONTENTS]  WITH CHECK ADD  CONSTRAINT [FK_USER_CONTENTS] FOREIGN KEY([USER_ID])
REFERENCES [dbo].[NVUSER] ([USER_ID])
GO
ALTER TABLE [dbo].[NVCONTENTS] CHECK CONSTRAINT [FK_USER_CONTENTS]
GO
ALTER TABLE [dbo].[NVCONTENTS]  WITH CHECK ADD  CONSTRAINT [FK_USERGRP_CONTENTS] FOREIGN KEY([GRP_CD])
REFERENCES [dbo].[NVUSERGRP] ([GRP_CD])
GO
ALTER TABLE [dbo].[NVCONTENTS] CHECK CONSTRAINT [FK_USERGRP_CONTENTS]
GO
