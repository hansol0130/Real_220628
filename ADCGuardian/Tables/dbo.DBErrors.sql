USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DBErrors](
	[SEQ] [bigint] IDENTITY(1,1) NOT NULL,
	[SQLServerID] [smallint] NOT NULL,
	[error_date] [datetime] NOT NULL,
	[error_number] [int] NULL,
	[level] [int] NULL,
	[state] [int] NULL,
	[message] [nvarchar](2048) NULL,
	[session_id] [int] NULL,
	[database_name] [nvarchar](128) NULL,
	[client_hostname] [nvarchar](128) NULL,
	[username] [nvarchar](128) NULL,
	[client_app_name] [nvarchar](128) NULL,
	[sql_text] [nvarchar](4000) NULL,
 CONSTRAINT [PK_DBErrors] PRIMARY KEY NONCLUSTERED 
(
	[SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
