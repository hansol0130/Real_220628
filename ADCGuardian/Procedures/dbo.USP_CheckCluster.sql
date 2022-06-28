USE [ADCGuardian]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
해당 서버가 클러스터 노드인지 확인하여
클러스터이면 ServerList 테이블의 ClusterYN 컬럼을 Y로 아니면 N으로 변경해준다
SERVERPROPERTY('IsHadrEnabled')는 2012부터 유효. 이전 버전은 NULL로 리턴함
사용예) 
Exec USP_CheckCluster @SQLServerID=1, @ClusterYN='N'
Exec USP_CheckCluster @SQLServerID=1, @ClusterYN='Y'
SELECT * FROM ADCGuardian.dbo.ServerList
*/
CREATE PROC [dbo].[USP_CheckCluster]
@SQLServerID int,
@ClusterYN char(1)
AS
--GuardianQuery
SET NOCOUNT ON
DECLARE @ServerID INT
SELECT @ServerID=ServerID FROM SQLServerList 
WHERE SQLServerID=@SQLServerID
UPDATE ADCGuardian.dbo.ServerList
SET ClusterYN=@ClusterYN
WHERE ServerID=@ServerID
GO
