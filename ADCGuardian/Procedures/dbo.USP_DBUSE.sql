USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
DB 사용량을 조사. 운영 서버에서 조회해야 하나 ADCGuardian DB에 만들어짐. 흑흑흑
2016-10-18 신대경
사용예) 
Exec USP_DBUSE @SQLServerID=1
*/
CREATE PROCEDURE [dbo].[USP_DBUSE]
@SQLServerID int
AS
/*
declare @SQLServerId int
set @SQLServerId=1
*/
SET NOCOUNT ON; 
declare @version varchar(30), @dbname sysname, @Readonly char(1)
set @Readonly='N'
select @version = CAST(Serverproperty('ProductVersion') as varchar(30))
	IF OBJECT_ID('tempdb.dbo.#tempReadonly') IS NOT NULL 
		drop table #tempReadonly; 
	create table #tempReadonly
	(
		ReadonlyYn char(1)
	)
	insert into #tempReadonly values('N')
	IF OBJECT_ID('tempdb.dbo.#sizeinfo') IS NOT NULL 
		drop table #sizeinfo; 
	--declare @dbname sysname;
	create table #sizeinfo (
		db_name varchar(128) not null primary key clustered , 
		total dec (15, 1) null,
		data dec (15, 1) null, 
		data_used dec (15, 1) null,
		[data (%)] dec (15, 1) null,
		data_free dec (15, 1) null, 
		[data_free (%)] dec (15, 1) null,
		log dec (15, 1) null, 
		log_used dec (15, 1) null, 
		[log (%)] dec (15, 1) null,
		log_free dec (15, 1) null,
		[log_free (%)] dec (15, 1) null,
		status dec (15, 1) null
	)
	insert #sizeinfo ( db_name, log, [log (%)], status ) 
	exec ('dbcc sqlperf(logspace) with no_infomsgs')
	declare dbname cursor for select name from master.dbo.sysdatabases where mode = 0 and databasepropertyex(name, 'Status') = N'ONLINE' order by name asc
	open dbname
	fetch next from dbname into @dbname
	while @@fetch_status = 0
	begin
		--print @dbname
		--AO의 접근 불가능한 보조복제본 DB 걸러내는 쿼리 (2016-02-24 백도훈)
		--버그로 인한 재수정 (2016-04-28 백도훈)
		DECLARE @sql varchar(3000), @sql2 varchar(1000)
		set @sql2=''
		set @sql = ' use [' + @dbname + '] declare @total dec(15, 1),
		@data dec (15, 1),
		@data_used dec (15, 1),
		@data_percent dec (15, 1),
		@data_free dec (15, 1),
		@data_free_percent dec (15, 1),
		@log dec (15, 1),
		@log_used dec (15, 1),
		@log_used_percent dec (15, 1),
		@log_free dec (15, 1),
		@log_free_percent dec (15, 1) 
		set @total = (select sum(convert(dec(15),size)) from dbo.sysfiles) * 8192.0 / 1048576.0
		set @data = (select sum(size) from dbo.sysfiles where (status & 64 = 0)) * 8192.0 / 1048576.0
		set @data_used = (select sum(convert(dec(15),reserved)) from dbo.sysindexes where indid in (0, 1, 255)) * 8192.0 / 1048576.0
		set @data_percent = (@data_used * 100.0 / @data)
		set @data_free = (@data - @data_used)
		set @data_free_percent = (@data_free * 100.0 / @data )
		set @log = (select log from #sizeinfo where db_name = '''+@dbname+''')
		set @log_used_percent = (select [log (%)] from #sizeinfo where db_name = '''+@dbname+''')
		set @log_used = @log * @log_used_percent / 100.0
		set @log_free = @log - @log_used
		set @log_free_percent = @log_free * 100.0 / @log
		update #sizeinfo set total = @total, 
		data = @data , 
		data_used = @data_used, 
		[data (%)] = @data_percent,
		data_free = @data_free,
		[data_free (%)] = @data_free_percent,
		log_used = @log_used, 
		log_free = @log_free,
		[log_free (%)] = @log_free_percent
		where db_name = '''+@dbname+''''
		if substring(@version, 1, charindex('.',@version,1)-1)>=11
		begin
			set @sql2=@sql2 + '
			IF SERVERPROPERTY(''IsHadrEnabled'') IS NOT NULL
			IF (SELECT 1 FROM sys.dm_hadr_database_replica_states AS hdrs
			INNER JOIN sys.dm_hadr_availability_replica_states AS hars ON hdrs.group_id = hars.group_id AND hdrs.replica_id = hars.replica_id
			INNER JOIN sys.availability_replicas AS ar ON ar.group_id = hdrs.group_id AND ar.replica_id = hdrs.replica_id
			WHERE hars.is_local = 1 AND hars.role = 2 AND ar.secondary_role_allow_connections_desc IN (''READ_ONLY'', ''NO'') AND hdrs.database_id = db_id('''+@dbname+''')) IS NOT NULL
			
			update #tempReadOnly set ReadonlyYn=''Y''
			'
			exec (@sql2)
			if Exists (select 1 from #tempReadonly where ReadonlyYn='Y')
			begin
				set @sql=''
				exec(@sql)
			end
			else
			begin
				exec(@sql)
			end
		end
		else	
		begin	
			--print @sql
			exec (@sql)
		end
		--여기까지
		fetch next from dbname into @dbname
	end
	close dbname
	deallocate dbname
	select 
	@SQLServerID  as SQLServerID, 
	db_name as DBName, 
	--CONVERT(CHAR(16), getdate(), 121) as InsDate, 
	CONVERT(CHAR(23), getdate(), 121) as insdate, 
	data, 
	data_used, 
	[data (%)] as Data_Percent, 
	data_free, 
	[data_free (%)] as Data_Free_Percent, 
	log, 
	log_used, 
	[log (%)] as Log_Percent, 
	log_free, 
	[log_free (%)] as Log_Free_Percent 
	from #sizeinfo
	--WHERE db_name not in ('master', 'model','msdb','pubs','Northwind','AdverntureWorks','AdventureWorksDW')
	order by db_name asc  --GuardianQuery 
GO
