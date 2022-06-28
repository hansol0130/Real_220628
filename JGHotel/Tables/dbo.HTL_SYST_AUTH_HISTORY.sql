USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_SYST_AUTH_HISTORY](
	[AUTH_KEY] [int] NOT NULL,
	[AUTH_ADMIN] [varchar](50) NULL,
	[AUTH_IP] [varchar](50) NULL,
	[AUTH_TIME] [datetime] NULL,
	[AUTH_USER] [varchar](50) NULL,
	[AUTH_TYPE] [varchar](50) NULL,
	[AUTH_DETAIL] [varchar](50) NULL,
	[AUTH_GRADE] [varchar](50) NULL,
 CONSTRAINT [PK_HTL_SYST_AUTH_HISTORY] PRIMARY KEY CLUSTERED 
(
	[AUTH_KEY] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO