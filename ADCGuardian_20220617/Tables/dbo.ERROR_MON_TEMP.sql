USE [ADCGuardian_20220617]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ERROR_MON_TEMP](
	[EtlFileName] [nvarchar](512) NOT NULL,
	[ReadPos] [int] NOT NULL,
	[ServerID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ERROR_MON_TEMP] ADD  DEFAULT ((0)) FOR [ReadPos]
GO
ALTER TABLE [dbo].[ERROR_MON_TEMP] ADD  DEFAULT ((0)) FOR [ServerID]
GO
