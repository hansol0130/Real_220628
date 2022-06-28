USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DataList](
	[DataListCode] [char](17) NOT NULL,
	[DataListGroup] [varchar](32) NULL,
	[DataListName] [varchar](64) NULL,
	[DashBoardYN] [char](1) NULL,
 CONSTRAINT [PK_DataList] PRIMARY KEY NONCLUSTERED 
(
	[DataListCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
