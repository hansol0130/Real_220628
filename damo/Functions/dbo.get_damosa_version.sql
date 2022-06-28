USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create function [dbo].[get_damosa_version]()
returns varchar(128)
as
begin
	declare @version varchar(16)

  select @version = value
    from damo.dbo.secure_cfg
   where section   = 'SYSTEM'
     and parameter = 'SA_VERSION_DCC'

  return @version
end
GO
