USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create function [dbo].[damosa_version]()
returns varchar(128)
as
begin
	return 'D''Amo Sqlserver SA v' + damo.dbo.get_damosa_version()+ ' Release'
end
GO
