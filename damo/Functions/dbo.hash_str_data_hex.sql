USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create function [dbo].[hash_str_data_hex]
( 
	@inData varchar(max) 
) 
returns varchar(256) 
as 
begin 
	declare  
		 @ret int 
		,@out varchar(256) 
 
	select  
		@ret = 1, 
		@out = NULL	 
	 select @ret = damo.dbo.checkLicenseInfo()
	 
	if ( @inData is NULL ) 
		set @out = NULL 
	else 
	begin 
if ( len(@inData) > 256) 
begin
	declare @error_result int
	select @error_result = damo.dbo.throwErrorApi('damo.dbo.hash_str_data_hex', '', '', 'data', 'ENCRYPTION ERROR : OVER 256 CHARACTERS','ENC') 
end
		declare @inBinaryData varbinary(8000) 
		select @inBinaryData = convert(varbinary(8000), @inData) 
		select @out = damo.dbo.hash_str_fast_data3('HEX', '3' , @inBinaryData  ) 
	end 
	 
	return @out 
end 
GO
