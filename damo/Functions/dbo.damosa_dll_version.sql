USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create function [dbo].[damosa_dll_version]()
returns varchar(8000)
as
begin
  declare @version varchar(8000), @ret int, @message varchar(8000)

  	if ( damo.dbo.is_version_equal_or_later('3.1001105') = 1 )
  begin
    exec @ret = master..xp_P5_GetVersionInfo @version output
    if @ret = 0
      select @message = 'D''Amo Sqlserver SA: damosa.dll version is ' + @version
  end
  else
    select @message = damo.dbo.get_damosa_version() + ': Not Supported Version'
    
    return @message
  
end
GO
