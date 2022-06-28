USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create function [dbo].[encrypt_string_hmac]
( 
	  @i_owner  nvarchar(300) 
	, @i_table  nvarchar(300) 
	, @i_column nvarchar(300) 
	, @i_data   nvarchar(max) 
) 
returns nvarchar(128) 
as 
begin 
	declare  
		 @ret int 
		,@out nvarchar(128) 
	select @ret = damo.dbo.checkLicenseInfo() 
	if ( @i_data is NULL ) 
		return NULL 
	select  
		@ret = 1, 
		@out = NULL	 
	 
		declare @v_in varbinary(8000) 
if ( len(@i_data) > 4000) 
begin
	declare @error_result int
	select @error_result = damo.dbo.throwErrorVti('damo.dbo.encrypt_string_hmac', @i_owner, @i_table, @i_column, 'data', 'ENCRYPTION ERROR : OVER 4000 CHARACTERS','ENC') 
end
		select @v_in = convert(varbinary(8000), convert(varchar(8000), @i_data)) 
		return damo.dbo.hmac_str_fast_data3('B64', @i_owner, @i_table, @i_column, @v_in ) 
end 
GO
