USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create function [dbo].[parse_damosa_version](@version varchar(16))
returns @retVersionTable TABLE
(
  is_4digits bit ,major varchar(4), minor varchar(4), newfeature varchar(4), bugfix varchar(4)
)
as
begin
  declare @major varchar(4), @minor varchar(4), @newfeature varchar(4), @bugfix varchar(4)
  declare @start_position int, @index int
  
  select @major = null, @minor = null, @newfeature = null, @bugfix = null
  
  set @start_position = 0

  set @index = CHARINDEX('.', @version)
  if (@index <= 0) 
  BEGIN
    INSERT @retVersionTable
      SELECT 0, @major, @minor, @newfeature, @bugfix;
    RETURN
  END
  set @major = SUBSTRING(@version, 0, @index)
  set @version = SUBSTRING(@version, @index+1, LEN(@version)-@index)

  set @index = CHARINDEX('.', @version)
  if (@index <= 0) 
  BEGIN
    INSERT @retVersionTable
      SELECT 0, @major, @minor, @newfeature, @bugfix;
    RETURN
  END
  set @minor = SUBSTRING(@version, 0, @index)
  set @version = SUBSTRING(@version, @index+1, LEN(@version)-@index)

  set @index = CHARINDEX('.', @version)
  if (@index <= 0) 
  BEGIN
    INSERT @retVersionTable
      SELECT 0, @major, @minor, @newfeature, @bugfix;
    RETURN
  END
  set @newfeature = SUBSTRING(@version, 0, @index)
  set @version = SUBSTRING(@version, @index+1, LEN(@version)-@index)

  set @bugfix = SUBSTRING(@version, 0, @index)

  INSERT @retVersionTable
          SELECT 1, @major, @minor, @newfeature, @bugfix;  
  return
end
GO
