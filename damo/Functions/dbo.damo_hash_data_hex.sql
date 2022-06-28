USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create function [dbo].[damo_hash_data_hex]
( 
	  @inData varchar(max) 
	, @inAlgo varchar(256) 
) 
returns varchar(256) 
as 
begin 
	declare  
		 @ret int 
		,@out varchar(256) 
		,@hashMode varchar(2) 
 
	select  
		@ret = 1, 
		@out = NULL	 
	 
	if ( @inAlgo = 'HAS160' ) 
	  select @hashMode = '1' 
	else if ( @inAlgo = 'SHA1' ) 
	  select @hashMode = '2' 
	else if ( @inAlgo = 'SHA256' ) 
	  select @hashMode = '3' 
	else if ( @inAlgo = 'SHA512' ) 
	  select @hashMode = '4' 
	else 
	  return NULL 
	select @ret = damo.dbo.checkLicenseInfo() 
	if ( @inData is NULL ) 
		set @out = NULL 
	else 
	begin 
if ( len(@inData) > 256) 
begin
	declare @error_result int
	select @error_result = damo.dbo.throwErrorApi('damo.dbo.damo_hash_data_hex', '', '', 'data', 'ENCRYPTION ERROR : OVER 256 CHARACTERS','ENC') 
end
		declare @inBinaryData varbinary(8000) 
		select @inBinaryData = convert(varbinary(8000), @inData) 
		return damo.dbo.hash_str_fast_data3('HEX', @inAlgo, @inBinaryData ) 
	end 
	 
	return @out 
end 
GO
