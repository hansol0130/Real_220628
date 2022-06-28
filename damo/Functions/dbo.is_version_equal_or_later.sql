USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create function [dbo].[is_version_equal_or_later](@version_to_check varchar(16))
returns varchar(128)
as
begin
	declare @version varchar(16)
  select @version = damo.dbo.get_damosa_version()

  ----- -- -- ----  
  declare @is_4digits bit, @major varchar(4), @minor varchar(4), @newfeature varchar(4), @bugfix varchar(4)
  select @is_4digits=is_4digits, 
         @major=major, 
         @minor=minor, 
         @newfeature=newfeature, 
         @bugfix=bugfix 
    from damo.dbo.parse_damosa_version(@version)
    
  -- --- -- -- ----
  declare @is_4digits_to_check bit, 
          @major_to_check varchar(4), 
          @minor_to_check varchar(4), 
          @newfeature_to_check varchar(4), 
          @bugfix_to_check varchar(4)
          
  select @is_4digits_to_check = is_4digits, 
         @major_to_check = major, 
         @minor_to_check = minor, 
         @newfeature_to_check=newfeature, 
         @bugfix_to_check=bugfix 
    from damo.dbo.parse_damosa_version(@version_to_check)


  -- -- 4-- --- --
  if @is_4digits = 1 and @is_4digits_to_check = 1
  begin
    if @major >= @major_to_check 
       and @major >= @major_to_check
       and @major >= @major_to_check
       and @major >= @major_to_check
      return 1
  end

  -- --- --- 4-- --- --
  if @is_4digits = 1 and @is_4digits_to_check = 0
  begin
    return 1
  end
  
  -- -- 4-- --- -- --
  if @is_4digits = 0 and @is_4digits_to_check = 0 and @version >= @version_to_check
    return 1

	return 0
end
GO
