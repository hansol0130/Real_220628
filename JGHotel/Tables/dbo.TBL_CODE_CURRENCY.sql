USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_CODE_CURRENCY](
	[SEQ_NO] [bigint] IDENTITY(1,1) NOT NULL,
	[CURRENCY_CODE] [varchar](3) NOT NULL,
	[CURRENCY_DESC] [varchar](200) NULL,
	[BUY_CASH] [decimal](14, 4) NULL,
	[SELL_CASH] [decimal](14, 4) NULL,
	[SEND_CASH] [decimal](14, 4) NULL,
	[RECV_CASH] [decimal](14, 4) NULL,
	[SELL_CHECK] [decimal](14, 4) NULL,
	[EXCHANGE_RATE] [decimal](14, 4) NULL,
	[USD_RATE] [decimal](12, 6) NULL,
	[CONVERT_RATE] [decimal](12, 6) NULL,
	[USE_YN] [varchar](1) NULL,
	[UPDATE_DATE] [datetime] NULL,
 CONSTRAINT [PK_TBL_CODE_CURRENCY] PRIMARY KEY CLUSTERED 
(
	[SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
