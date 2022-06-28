USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
-- 2012-03-02 WITH(NOLOCK) 추가 	
*/
CREATE PROCEDURE [dbo].[SP_OPT_MASTER_SELECT_LIST]    
 @MASTER_CODE VARCHAR(10),    
 @MASTER_NAME VARCHAR(50),    
 @REGION_CODE VARCHAR(3),    
 @NATION_CODE VARCHAR(3),    
 @STATE_CODE VARCHAR(4),    
 @CITY_CODE VARCHAR(3),    
 @OPT_TYPE INT  
AS    
BEGIN    
 DECLARE @SQLSTRING NVARCHAR(4000), @PARMDEFINITION NVARCHAR(1000)    
    
 -- WHERE 조건 만들기  
 IF ISNULL(@MASTER_CODE, '') <> ''    
 BEGIN    
  SET @SQLSTRING = ' AND A.MASTER_CODE = @MASTER_CODE';    
 END    
 ELSE    
 BEGIN    
  SET @SQLSTRING = ''    
    
  -- 상품명    
  IF ISNULL(@MASTER_NAME, '') <> ''    
   SET @SQLSTRING = @SQLSTRING + ' AND A.MASTER_NAME LIKE (''%'' + @MASTER_NAME + ''%'')'    
  
  -- 유입처    
  IF ISNULL(@OPT_TYPE, 0) <> 0    
   SET @SQLSTRING = @SQLSTRING + ' AND A.OPT_TYPE = @OPT_TYPE'    
  
  -- 도시코드  
  IF ISNULL(@REGION_CODE, '') <> ''  
   SET @SQLSTRING = @SQLSTRING + ' AND A.REGION_CODE = @REGION_CODE'  
  IF ISNULL(@NATION_CODE, '') <> ''  
   SET @SQLSTRING = @SQLSTRING + ' AND A.NATION_CODE = @NATION_CODE'  
  IF ISNULL(@STATE_CODE, '') <> ''  
   SET @SQLSTRING = @SQLSTRING + ' AND A.STATE_CODE = @STATE_CODE'  
  IF ISNULL(@CITY_CODE, '') <> ''  
   SET @SQLSTRING = @SQLSTRING + ' AND A.CITY_CODE = @CITY_CODE'  
  
--  IF ISNULL(@CITY_CODE, '') <> ''    
--   SET @SQLSTRING = @SQLSTRING + ' AND A.REGION_CODE = @REGION_CODE AND A.NATION_CODE = @NATION_CODE AND A.STATE_CODE = @STATE_CODE AND A.CITY_CODE = @CITY_CODE'    
--  ELSE IF ISNULL(@STATE_CODE, '') <> ''    
--   SET @SQLSTRING = @SQLSTRING + ' AND A.REGION_CODE = @REGION_CODE AND A.NATION_CODE = @NATION_CODE AND A.STATE_CODE = @STATE_CODE'    
--  ELSE IF ISNULL(@NATION_CODE, '') <> ''  
--   SET @SQLSTRING = @SQLSTRING + ' AND A.REGION_CODE = @REGION_CODE AND A.NATION_CODE = @NATION_CODE'    
--  ELSE IF ISNULL(@REGION_CODE, '') <> ''    
--   SET @SQLSTRING = @SQLSTRING + ' AND A.REGION_CODE = @REGION_CODE'    
    
 END  
    
 SET @SQLSTRING = N'    
 SELECT A.MASTER_CODE, A.MASTER_NAME, A.OPT_TYPE    
  , ISNULL((SELECT KOR_NAME FROM PUB_REGION WITH(NOLOCK) WHERE REGION_CODE = A.REGION_CODE), '''') AS [REGION_NAME]    
  , ISNULL((SELECT KOR_NAME FROM PUB_NATION WITH(NOLOCK) WHERE NATION_CODE = A.NATION_CODE), '''') AS [NATION_NAME]    
  , ISNULL((SELECT KOR_NAME FROM PUB_STATE WITH(NOLOCK) WHERE STATE_CODE = A.STATE_CODE AND NATION_CODE = A.NATION_CODE), '''') AS [STATE_NAME]    
  , ISNULL((SELECT KOR_NAME FROM PUB_CITY WITH(NOLOCK) WHERE CITY_CODE = A.CITY_CODE), '''') AS [CITY_NAME]    
  , ISNULL((SELECT [DESCRIPTION] FROM INF_MASTER WITH(NOLOCK) WHERE CNT_CODE = A.CNT_CODE), '''') AS [DESCRIPTION]    
 FROM OPT_MASTER A  WITH(NOLOCK) 
 WHERE 1 = 1    
 ' + @SQLSTRING + '';    
  
 SET @PARMDEFINITION = N'@MASTER_CODE VARCHAR(10), @MASTER_NAME VARCHAR(50), @REGION_CODE VARCHAR(3), @NATION_CODE VARCHAR(3), @STATE_CODE VARCHAR(4), @CITY_CODE VARCHAR(3), @OPT_TYPE INT'    
    
 --PRINT @SQLSTRING    
 EXEC SP_EXECUTESQL @SQLSTRING, @PARMDEFINITION, @MASTER_CODE, @MASTER_NAME, @REGION_CODE, @NATION_CODE, @STATE_CODE, @CITY_CODE, @OPT_TYPE    
    
END    
  
  
GO