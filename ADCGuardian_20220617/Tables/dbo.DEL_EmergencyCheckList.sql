USE [ADCGuardian_20220617]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DEL_EmergencyCheckList](
	[EmergencyID] [int] NOT NULL,
	[DataListID] [int] NOT NULL,
 CONSTRAINT [PK_EmergencyCheckList] PRIMARY KEY NONCLUSTERED 
(
	[EmergencyID] ASC,
	[DataListID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO