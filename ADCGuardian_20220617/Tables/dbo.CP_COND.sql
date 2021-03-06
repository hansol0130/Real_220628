USE [ADCGuardian_20220617]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CP_COND](
	[CPID] [smallint] IDENTITY(1,1) NOT NULL,
	[DataListCode] [char](17) NOT NULL,
	[DataListSubCode] [varchar](128) NULL,
	[ServerID] [smallint] NOT NULL,
	[SQLServerID] [smallint] NULL,
	[CounterID] [int] NULL,
	[CP] [float] NULL,
	[CP_TYPE] [char](1) NULL,
	[USE_YN] [char](1) NOT NULL,
	[USER_ID] [varchar](30) NOT NULL,
	[INS_DATE] [datetime] NULL,
	[UPD_DATE] [datetime] NULL,
 CONSTRAINT [PK_CP_COND] PRIMARY KEY NONCLUSTERED 
(
	[CPID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CP_COND] ADD  DEFAULT ('Y') FOR [USE_YN]
GO
ALTER TABLE [dbo].[CP_COND] ADD  DEFAULT (getdate()) FOR [INS_DATE]
GO
ALTER TABLE [dbo].[CP_COND] ADD  DEFAULT (getdate()) FOR [UPD_DATE]
GO
ALTER TABLE [dbo].[CP_COND]  WITH CHECK ADD CHECK  (([CP_TYPE]='E' OR ([CP_TYPE]='L' OR ([CP_TYPE]='H' OR [CP_TYPE]=NULL))))
GO
ALTER TABLE [dbo].[CP_COND]  WITH CHECK ADD CHECK  (([USE_YN]='N' OR [USE_YN]='Y'))
GO
