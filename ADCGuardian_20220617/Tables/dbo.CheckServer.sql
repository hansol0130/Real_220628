USE [ADCGuardian_20220617]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CheckServer](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Type] [varchar](1) NOT NULL,
	[ServerIP] [varchar](128) NOT NULL,
	[UserID] [varchar](100) NOT NULL,
	[Password] [varchar](100) NOT NULL,
	[Confirm] [varchar](1) NOT NULL,
	[Reg_date] [datetime] NOT NULL,
	[errormsg] [varchar](4000) NULL,
	[OptionData] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CheckServer] ADD  DEFAULT ('N') FOR [Confirm]
GO
ALTER TABLE [dbo].[CheckServer] ADD  DEFAULT (getdate()) FOR [Reg_date]
GO
