USE [ADCGuardian_20220617]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CounterListTmp](
	[TmpID] [int] NOT NULL,
	[Object] [nvarchar](128) NOT NULL,
	[Counter] [nvarchar](128) NOT NULL,
	[Instance] [nvarchar](128) NOT NULL,
	[DispYN] [char](1) NOT NULL,
	[UseYN] [char](1) NOT NULL,
	[Min] [float] NULL,
	[Max] [float] NULL,
	[Frequency] [int] NOT NULL,
	[QueueSecond] [int] NULL,
 CONSTRAINT [PK_CounterListTmp] PRIMARY KEY NONCLUSTERED 
(
	[TmpID] ASC,
	[Object] ASC,
	[Counter] ASC,
	[Instance] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CounterListTmp]  WITH CHECK ADD  CONSTRAINT [FK_CounterListTmp_TmpID] FOREIGN KEY([TmpID])
REFERENCES [dbo].[CounterListTmpHeader] ([TmpID])
GO
ALTER TABLE [dbo].[CounterListTmp] CHECK CONSTRAINT [FK_CounterListTmp_TmpID]
GO
