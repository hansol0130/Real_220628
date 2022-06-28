USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_job_detail](
	[job_number] [int] NULL,
	[sequence] [int] NULL,
	[column_name] [varchar](4000) NULL,
	[group_id] [int] NULL,
	[work_type] [varchar](64) NULL,
	[algorithm] [int] NULL,
	[opmode] [int] NULL,
	[ivtype] [int] NULL,
	[drop_remain] [varchar](12) NULL,
	[enc_mode] [varchar](2) NULL
) ON [PRIMARY]
GO
