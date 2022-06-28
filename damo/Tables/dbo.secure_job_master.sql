USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_job_master](
	[job_number] [int] NULL,
	[sequence] [int] NULL,
	[job_name] [nvarchar](128) NULL,
	[owner] [varchar](128) NULL,
	[table_name] [varchar](300) NULL,
	[job_type] [varchar](1) NULL,
	[status] [varchar](1) NULL,
	[job_future_exec_date] [varchar](14) NULL,
	[sqlcode] [int] NULL,
	[sqlerrm] [varchar](1024) NULL,
	[job_start_date] [datetime] NULL,
	[job_end_date] [datetime] NULL
) ON [PRIMARY]
GO
