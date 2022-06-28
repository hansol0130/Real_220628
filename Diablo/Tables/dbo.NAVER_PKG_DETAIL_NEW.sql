USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NAVER_PKG_DETAIL_NEW](
	[mstCode] [varchar](20) NOT NULL,
	[mstTitle] [nvarchar](2000) NOT NULL,
	[childCode] [varchar](30) NOT NULL,
	[childTitle] [nvarchar](2000) NOT NULL,
	[createdDate] [datetime] NOT NULL,
	[updatedDate] [datetime] NULL,
	[isEmergency] [varchar](5) NOT NULL,
	[urlInfo_landingPc] [varchar](500) NOT NULL,
	[urlInfo_landingMobile] [varchar](500) NOT NULL,
	[urlInfo_imageS] [nvarchar](max) NULL,
	[countryList] [nvarchar](200) NULL,
	[cityList] [nvarchar](500) NULL,
	[beginDate] [varchar](10) NULL,
	[beginCityCode] [char](3) NULL,
	[beginRideType] [varchar](10) NULL,
	[beginFlight_airlineCode] [char](2) NULL,
	[beginFlight_flightName] [varchar](10) NULL,
	[beginFlight_codeShareName] [varchar](10) NULL,
	[beginFlight_departureDate] [datetime] NULL,
	[beginFlight_transfer] [int] NULL,
	[beginFlight_seatGrade] [varchar](20) NULL,
	[beginFlight_upgradable] [varchar](5) NULL,
	[beginFlight_durationTime] [int] NULL,
	[beginFlight_isMileage] [varchar](5) NULL,
	[beginFlight_mileageAirline] [varchar](10) NULL,
	[beginFlight_mileageCost] [int] NULL,
	[beginFlight_mileageDescription] [varchar](50) NULL,
	[beginShip_shipCode] [varchar](3) NULL,
	[beginShip_durationTime] [int] NULL,
	[beginShip_departureDate] [datetime] NULL,
	[endDate] [varchar](10) NULL,
	[endCityCode] [char](3) NULL,
	[endRideType] [varchar](10) NULL,
	[endFlight_airlineCode] [char](2) NULL,
	[endFlight_flightName] [varchar](10) NULL,
	[endFlight_codeShareName] [varchar](10) NULL,
	[endFlight_arriveDate] [datetime] NULL,
	[endFlight_transfer] [int] NULL,
	[endFlight_seatGrade] [varchar](20) NULL,
	[endFlight_upgradable] [varchar](5) NULL,
	[endFlight_durationTime] [int] NULL,
	[endFlight_isMileage] [varchar](5) NULL,
	[endFlight_mileageAirline] [varchar](10) NULL,
	[endFlight_mileageCost] [int] NULL,
	[endFlight_mileageDescription] [varchar](50) NULL,
	[endShip_shipCode] [varchar](3) NULL,
	[endShip_durationTime] [int] NULL,
	[endShip_arriveDate] [datetime] NULL,
	[travelPeriod_night] [int] NULL,
	[travelPeriod_day] [int] NULL,
	[priceInfo_adult_basePrice] [int] NULL,
	[priceInfo_adult_surcharge] [int] NULL,
	[priceInfo_adult_total] [int] NULL,
	[priceInfo_adult_localPrice] [int] NULL,
	[priceInfo_adult_localCurrency] [varchar](3) NULL,
	[priceInfo_child_basePrice] [int] NULL,
	[priceInfo_child_surcharge] [int] NULL,
	[priceInfo_child_total] [int] NULL,
	[priceInfo_child_localPrice] [int] NULL,
	[priceInfo_child_localCurrency] [varchar](3) NULL,
	[priceInfo_infant_basePrice] [int] NULL,
	[priceInfo_infant_surcharge] [int] NOT NULL,
	[priceInfo_infant_total] [int] NULL,
	[priceInfo_infant_localPrice] [int] NULL,
	[priceInfo_infant_localCurrency] [varchar](3) NULL,
	[priceInfo_infant_description] [varchar](10) NOT NULL,
	[priceInfo_serviceCharge_serviceName] [varchar](50) NOT NULL,
	[priceInfo_serviceCharge_price] [int] NULL,
	[priceInfo_serviceCharge_currency] [varchar](3) NULL,
	[productIn] [nvarchar](300) NULL,
	[productOut] [nvarchar](300) NULL,
	[productSellingPoints] [nvarchar](2000) NULL,
	[productPoints_traffic] [nvarchar](2000) NULL,
	[productPoints_stay] [nvarchar](2000) NULL,
	[productPoints_tour] [nvarchar](2000) NULL,
	[productPoints_eat] [nvarchar](2000) NULL,
	[productPoints_discount] [nvarchar](2000) NULL,
	[productPoints_other] [nvarchar](2000) NULL,
	[tourOption_isOptionalTour] [varchar](5) NOT NULL,
	[tourOption_isFreeSchedule] [varchar](5) NOT NULL,
	[shoppingTimeNum] [int] NULL,
	[bookingStatus_seatAll] [int] NULL,
	[bookingStatus_seatMin] [int] NULL,
	[bookingStatus_seatNow] [int] NOT NULL,
	[bookingStatus_bookingCode] [varchar](5) NOT NULL,
	[productType] [varchar](10) NOT NULL,
	[productThemeList] [varchar](200) NOT NULL,
	[reviewCount] [int] NULL,
	[gradeCount] [int] NULL,
	[guideStatus] [varchar](10) NULL,
	[hashtag] [nvarchar](4000) NULL,
	[isCombine] [varchar](5) NOT NULL,
	[NEW_DATE] [datetime] NOT NULL,
	[productRank] [int] NULL,
	[callNumber] [varchar](10) NULL,
	[isNoTips] [varchar](5) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
