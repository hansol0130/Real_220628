USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create procedure [dbo].[mod_secure_kms_policy_iv](
							@i_pid_iv			varchar(64)
							,@i_mod_pid_iv	varchar(64)
							,@i_mod_desc	varchar(64) = ''
							,@o_sqlcode		int output
							,@o_sqlerrm 	varchar(8000) output
)
as
	declare @v_use_count		int
begin
begin try
begin tran
	select @v_use_count =0
	---------------------------------------------------------------------------------------------------------------
        -- -- --- PID_IV- --- -- -- --- -- --- -- --
  ---------------------------------------------------------------------------------------------------------------
	
	select @v_use_count=count(1)
	from damo.dbo.secure_kms_policy_iv
	where pid_iv= @i_mod_pid_iv

	if(@v_use_count!=0)
	begin
		update damo.dbo.secure_kms_policy_iv
		set descript = @i_mod_desc
		where pid_iv=@i_pid_iv 
	end
	else
	begin
		insert into damo.dbo.secure_kms_policy_iv (pid_iv, iv_type, iv_value, descript, time)
		select @i_mod_pid_iv,   iv_type, iv_value, @i_mod_desc, time
		from damo.dbo.secure_kms_policy_iv
		where pid_iv=@i_pid_iv
		
		update damo.dbo.secure_kms_service_column
		set pid_iv = @i_mod_pid_iv
		where pid_iv=@i_pid_iv
	end
	
	 ---------------------------------------------------------------------------------------------------------------
        -- -- --- -- -- KEY --
   ---------------------------------------------------------------------------------------------------------------
	if(@v_use_count = 0)
	begin
		delete 
		from damo.dbo.secure_kms_policy_iv
		 where pid_iv=@i_pid_iv
	end
	
	select @o_sqlcode = 0
	select @o_sqlerrm = 'SUCCESSFUL COMPLETION'
  
  commit tran
  
  return 0
end try
begin catch
  /*
    -- -- --
  CATCH --- ---- -- --- --- ---- CATCH --- ----- -- --- -- --- -- - ----.
  ERROR_NUMBER()- -- --- -----.
  ERROR_SEVERITY()- ---- -----.
  ERROR_STATE()- -- -- --- -----.
  ERROR_PROCEDURE()- --- --- -- ---- -- ---- --- -----.
  ERROR_LINE()- --- --- -- -- - --- -----.
  ERROR_MESSAGE()- -- ---- -- ---- -----. - ---- --, -- -- -- --- -- -- --- -- --- --- -- -----.
  */
  select @o_sqlcode = ERROR_NUMBER()
  select @o_sqlerrm = substring('Msg ' + convert(varchar,ERROR_NUMBER()) +', Level '+ convert(varchar,ERROR_SEVERITY())+', State '+ convert(varchar,ERROR_STATE()) + ', Line ' + convert(varchar,ERROR_LINE()) +'  //  ' + ERROR_MESSAGE(), 1, 8000)
        
  if (xact_state()) = -1
  begin
    rollback tran
  end
  
  if (xact_state()) = 1
  begin
    commit tran
  end
  
  return @o_sqlcode
end catch
end --mod_secure_kms_policy_iv
GO
