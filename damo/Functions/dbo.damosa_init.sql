USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create function [dbo].[damosa_init]()
returns int
as
begin
  declare @ret int
  --Initialize Function
  exec @ret = master..xp_P5_InitSecureInfos
  
  if(@ret != 0)
  begin
	return @ret
  end
  
  --Memory Sync Function
  exec master..xp_P5_MemorySync
  
  return @ret
end
GO
