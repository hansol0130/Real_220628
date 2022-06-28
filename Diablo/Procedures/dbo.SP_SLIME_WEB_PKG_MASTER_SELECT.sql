USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


                                                        
/*================================================================================================================                                                        
■ USP_NAME     : SP_SLIME_WEB_PKG_MASTER_SELECT ( <= XP_WEB_PKG_MASTER_LIST_SELECT 에 정렬방식 추가)                                                         
■ DESCRIPTION    : 마스터 리스트 검색                                                        
■ INPUT PARAMETER   :                                                         
 @PAGE_INDEX  INT  : 현재 페이지                                                        
 @PAGE_SIZE  INT   : 한 페이지 표시 게시물 수                                                        
 @KEY  VARCHAR(400): 검색 키                                                        
 @ORDER_BY INT   : 정렬 순서                                                        
■ OUTPUT PARAMETER   :                                                         
 @TOTAL_COUNT INT OUTPUT : 총 메일 수                                                               
■ EXEC      :                                                         
                                                        
 DECLARE @PAGE_INDEX INT,                                                        
 @PAGE_SIZE  INT,                                                        
 @TOTAL_COUNT INT,                                                         
 @KEY  VARCHAR(400),                                                        
 @ORDER_BY INT                                                        
                                                        
 SELECT @PAGE_INDEX=1,@PAGE_SIZE=30,@KEY=N'Provider=0&RegionCode=A&AttCode=W&MinPrice=&MaxPrice=',@ORDER_BY=9                                                        
                                                        
 exec SP_MOV2_WEB_PKG_MASTER_LIST_SELECT @page_index, @page_size, @total_count output, @key, @order_by                                                        
 SELECT @TOTAL_COUNT                                                        
                                                        
 declare @p5 int                                                        
 set @p5=NULL                                                        
 exec SP_MOV2_WEB_PKG_MASTER_LIST_SELECT @PAGE_INDEX=1,@PAGE_SIZE=20,@KEY=N'Provider=0&RegionCode=E',@ORDER_BY=6,@TOTAL_COUNT=@p5 output                                                        
 select @p5                                                        
                                                        
 declare @p5 int                                                        
 set @p5=849                                                        
 exec SP_MOV2_WEB_PKG_MASTER_LIST_SELECT @PAGE_INDEX=1,@PAGE_SIZE=20,@KEY=N'Provider=0&RegionCode=E',@ORDER_BY=1,@TOTAL_COUNT=@p5 output                                                        
 select @p5                                                        
                                                        
                                                        
■ MEMO      : 수정 시 XP_WEB_PKG_MASTER_CATEGORY_LIST_SELECT 프로시저와 검색 조건 동기화 해야함                                                        
------------------------------------------------------------------------------------------------------------------                                                        
■ CHANGE HISTORY                                                                           
------------------------------------------------------------------------------------------------------------------                                                        
   DATE    AUTHOR   DESCRIPTION                                                                   
------------------------------------------------------------------------------------------------------------------                                                        
   2013-03-20  김성호   최초생성                                                      
   2013-05-20  김성호   날짜가 없을때 LAST_DATE >= GETDATE() 조건 추가                                                        
   2013-05-24  김성호   정렬 순서 변경                                                        
   2013-06-05  김성호   검색 조건 수정 (도시코드, 국가코드, 날짜)                                                        
   2013-06-09  김성호   PRO_CODE 검색 추가                                                        
   2013-06-10  김성호   WITH(NOLOCK) 추가                                                        
   2013-06-18  김성호   @SQLSTRING NVARCHAR(MAX)로 수정 및 @PROVIDER 부분 수정                                                        
   2013-07-09  김성호   BranchCode 검색어 추가                                                        
   2013-07-29  김성호   @BRAND_TYPE VARCHAR(1) 선언                                                        
   2013-09-11  이동호   REGION_NAME 지역명 추가 불러옴                                     
   2014-12-08  김성호   일본 자전가 상품 키워드 치환 작업                                                        
   2015-03-25  박형만   크루즈 불교상품 제외                                                        
   2017-04-04  정지용   MIN_PRICE / MAX_PRICE CONVERT시에 INT -> BIGINT로 변경                                                        
   2017-07-11  오준욱   XP_WEB_PKG_MASTER_LIST_SELECT 에 필터/정렬방식추가                                                        
   2017-10-27  김성호   변수 파라메터처리 및 동반자 테이블 변경에 따른 전체적인 수정 작업                                         
   2017-10-31  김성호   동반자 정렬 시 여권 정보 배제                                                        
   2017-11-03  김성호   동반자 정렬 시 상품속성(허니문) 무조건 뒤로 (동반자 커플은 제외)                                                        
   2017-11-15  박형만   대표속성 ATT_NAME 추가                                                         
   2017-11-17  김성호   이벤트명, 이벤트행사 출발일자 항목 추가                                                        
   2017-11-24  박형만   REGION_NAME 속성 변경 REGION_CODE -> SIGN                                                         
   2017-11-28  정지용   실시간 항공 마스터 조회되는 경우 때문에 ATT_CODE가 조건에 없을 경우 ATT_CODE R:실시간항공 제외하도록..                                                  
   2017-11-28  정지용   @KEYWORD NVARCHAR(2000) 으로 변경                                                        
   2017-01-18  정지용   MIN_DAY / MAX_DAY / CFM_YN 추가                                                        
   2017-01-19  정지용   조건 쿼리 정리                                                         
   2019-01-22  이명훈   라르고 페이지 라르고 상품만 나오게(BRAND_TYPE = '2')                                                        
   2019-05-13  이명훈   REGION_CODE = 'U'(미주일 때) R, S 남미 중미 추가                                                        
   2019-11-27  박형만   CFM_YN 일때 출발확정 전체 DEP_CFM_YN IN (Y,F인것)                                                        
   2019-11-28  임검제   리뉴얼 선호항공, 호텔등급, 가격범위, 출발지역 조회조건 추가                                                        
   2019-12-20  김성호   정렬조건 '상품평 많은순' 추가                                                        
   2019-12-27  임검제   상품평 내용 조회 Select 항목 추가 ( MASTER_BO )                                                      
   2019-12-31  임검제   여행일자 갯수 카운트를 위한 필드 추가 TOUR_DAY_COUNT             삭제
   2020-02-24  지니웍스 SUMMARY_D_TOURDAY 여행일자 SUMMARY 수정 
   2020-06-22  EHD(김영민) CLEAN_YN 컬럼추가
================================================================================================================*/                                                         
CREATE PROCEDURE [dbo].[SP_SLIME_WEB_PKG_MASTER_SELECT] 
(
	@PAGE_INDEX INT ,
	@PAGE_SIZE INT ,
	@TOTAL_COUNT INT OUTPUT ,
	@KEY NVARCHAR(MAX) ,
	@ORDER_BY INT
)
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                                                        
	
	DECLARE @SQLSTRING          NVARCHAR(MAX)
	       ,@PARMDEFINITION     NVARCHAR(1000);                                                        
	DECLARE @INNER_TABLE     NVARCHAR(1000)
	       ,@WHERE           NVARCHAR(MAX)
	       ,@SORT_STRING     VARCHAR(50);                                                        
	DECLARE @PUSAN_TEAM_CODE     VARCHAR(100)
	       ,@TEMP                NVARCHAR(2000);                                                        
	
	DECLARE @PROVIDER        VARCHAR(3)
	       ,@BRAND_TYPE      VARCHAR(1)
	       ,@REGION_CODE     VARCHAR(50)
	       ,@CITY_CODE       VARCHAR(50)
	       ,@NATION_CODE     VARCHAR(50)
	       ,@ATT_CODE        VARCHAR(50)
	       ,@GROUP_CODE      NVARCHAR(MAX);                                                        
	DECLARE @MIN_PRICE         VARCHAR(10)
	       ,@MAX_PRICE         VARCHAR(10)
	       ,@DEP_DATE          VARCHAR(10)
	       ,@BRANCH_CODE       VARCHAR(1)
	       ,@KEYWORD           NVARCHAR(2000)
	       ,@MAIN_ATT_CODE     VARCHAR(10)
	       ,@WEEKDAY           VARCHAR(50)
	       ,@AIRLINE_TYPE      VARCHAR(50)
	       ,@HOTEL_GRADE       VARCHAR(50)
	       ,@PRICE             VARCHAR(50);                                                        
	DECLARE @MIN_DAY              VARCHAR(5)
	       ,@MAX_DAY              VARCHAR(5)
	       ,@CFM_YN               CHAR(1)
	       ,@BRANCH_CODES         VARCHAR(50)
	       ,@TYPE                 VARCHAR(50)
	       ,@RESEARCH_KEYWORD     VARCHAR(2000)
	       ,@DAY                  VARCHAR(10); 
	
	-- 검색 제외팀
	--SET @PUSAN_TEAM_CODE = '''514'', ''515'', ''516'', ''524'', ''531''';                                                        
	
	SELECT @PROVIDER = DBO.FN_PARAM(@KEY ,'Provider')
	      ,@BRAND_TYPE = DBO.FN_PARAM(@KEY ,'BrandType')
	      ,@REGION_CODE = DBO.FN_PARAM(@KEY ,'RegionCode')
	      ,@CITY_CODE = DBO.FN_PARAM(@KEY ,'CityCode')
	      ,@NATION_CODE = DBO.FN_PARAM(@KEY ,'NationCode')
	      ,@MAIN_ATT_CODE = DBO.FN_PARAM(@KEY ,'MainAttCode')
	      ,@ATT_CODE = DBO.FN_PARAM(@KEY ,'AttCode')
	      ,@GROUP_CODE = DBO.FN_PARAM(@KEY ,'GroupCode')
	      ,@MIN_PRICE = DBO.FN_PARAM(@KEY ,'MinPrice')
	      ,@MAX_PRICE = DBO.FN_PARAM(@KEY ,'MaxPrice')
	      ,@DEP_DATE = DBO.FN_PARAM(@KEY ,'DepDate')
	      ,@DAY = DBO.FN_PARAM(@KEY ,'Day')
	      ,@BRANCH_CODE = DBO.FN_PARAM(@KEY ,'BranchCode')
	      ,@KEYWORD = DBO.FN_PARAM(@KEY ,'Keyword')
	      ,@WEEKDAY = DBO.FN_PARAM(@KEY ,'Weekday')
	      ,@MIN_DAY = DBO.FN_PARAM(@KEY ,'MinDay')
	      ,@MAX_DAY = DBO.FN_PARAM(@KEY ,'MaxDay')
	      ,@CFM_YN = DBO.FN_PARAM(@KEY ,'CfmYN')
	      ,-- 20191128 리뉴얼 선호항공, 호텔등급, 가격범위, 출발지역 조회조건 추가                                                                      
	       @AIRLINE_TYPE = DBO.FN_PARAM(@KEY ,'AirlineType')
	      ,@HOTEL_GRADE = DBO.FN_PARAM(@KEY ,'HotelGrade')
	      ,@PRICE = DBO.FN_PARAM(@KEY ,'PRICE')
	      ,@BRANCH_CODES = DBO.FN_PARAM(@KEY ,'BranchCodes')
	      ,@TYPE = DBO.FN_PARAM(@KEY ,'Type')
	      ,@RESEARCH_KEYWORD = dbo.FN_PARAM(@KEY ,'ResearchKeyword')
	      ,@WHERE = ''                                           
	
	
	
	SET @WHERE = DBO.FN_SLIME_WEB_PKG_MASTER_SELECT_WHERE(@KEY); -- 해당 함수에서 공통으로 WHERE 절을 만들어줍니다.(COUNT, LIST , FILTER)
	                                                             --PRINT @WHERE
	                                                             -- SORT 조건 만들기                                                          
	SELECT @SORT_STRING = (
	           CASE @ORDER_BY
	                WHEN 1 THEN 'A.REGION_ORDER, TOTAL_COUNT DESC' -- PC 기본
	                WHEN 2 THEN 'A.THEME_ORDER' -- 모바일 카테고리 접근 기본 (추천상품)
	                WHEN 3 THEN 'A.GROUP_ORDER' -- 그룹 정렬
	                WHEN 4 THEN 'TOTAL_COUNT DESC' -- 총여행수
	                WHEN 5 THEN 'STAR_POINT DESC' -- 평점높은순
	                WHEN 6 THEN 'STAR_COUNT DESC' -- 평점많은순
	                WHEN 7 THEN 'A.LOW_PRICE' -- 낮은 가격순
	                WHEN 8 THEN 'A.LOW_PRICE DESC' -- 높은 가격순
	                WHEN 9 THEN 'ATT_ORDER, FAMILY_PERCENT DESC, TOTAL_COUNT DESC' -- 가족과함께
	                WHEN 10 THEN 'ATT_ORDER, MEETING_PERCENT DESC, TOTAL_COUNT DESC' -- 단체모임
	                WHEN 11 THEN 'COUPLE_PERCENT DESC, TOTAL_COUNT DESC' -- 커플
	                WHEN 12 THEN 'ATT_ORDER, FRIEND_PERCENT DESC, TOTAL_COUNT DESC' -- 친구와함께
	                WHEN 13 THEN 'ATT_ORDER, ALONE_PERCENT DESC, TOTAL_COUNT DESC' -- 나홀로
	                ELSE 'A.REGION_ORDER, TOTAL_COUNT DESC' -- 기본
	           END
	       )                                                        
	
	SET @SQLSTRING = N'                                               
 -- 전체 마스터 수                                
 SELECT @TOTAL_COUNT = COUNT(*)                                                        
 FROM PKG_MASTER A WITH(NOLOCK)    
'
	
	IF @PROVIDER NOT IN ('0' ,'5' ,'16' ,'18' ,'25')
	    SET @SQLSTRING = @SQLSTRING + N'INNER JOIN PKG_MASTER_AFFILIATE Z WITH(NOLOCK) ON Z.PROVIDER = CONVERT(INT, @PROVIDER) AND A.MASTER_CODE = Z.MASTER_CODE AND Z.USE_YN=''Y''                                                        
 ' 
	--print @TOTAL_COUNT                                                        
	SET @SQLSTRING = @SQLSTRING + N'' + @WHERE; 
	--SET @SQLSTRING = @SQLSTRING + N';
	---- 최소, 최대값
	--SELECT MIN(LOW_PRICE) AS [LOW_PRICE], MAX(HIGH_PRICE) AS [HIGH_PRICE]
	--FROM PKG_MASTER A WITH(NOLOCK)
	--'
	----IF @PROVIDER NOT IN('0','5','16','18')
	---- SET @SQLSTRING = @SQLSTRING + N'INNER JOIN PKG_MASTER_AFFILIATE Z WITH(NOLOCK) ON Z.PROVIDER = CONVERT(INT, @PROVIDER) AND A.MASTER_CODE = Z.MASTER_CODE AND Z.USE_YN=''Y''
	----'
	--SET @SQLSTRING = @SQLSTRING + N'
	--' + @WHERE;                      
	SET @SQLSTRING = @SQLSTRING + N';                                          
 -- 최소, 최대값                                                        
 SELECT 0 AS [LOW_PRICE], 0 AS [HIGH_PRICE]'                                                        
	
	SET @SQLSTRING = @SQLSTRING + 
	    N';                                                        
                                                        
 WITH LIST AS                                             
 (                                       
  SELECT A.MASTER_CODE                  
   , B.ALONE_PERCENT, B.FRIEND_PERCENT, B.FAMILY_PERCENT, B.COUPLE_PERCENT, B.MEETING_PERCENT, B.ETC_PERCENT, B.TOTAL_COUNT                                                        
   , (CASE WHEN A.ATT_CODE = ''W'' THEN 2 ELSE 1 END) AS [ATT_ORDER]                                                        
   --, (SELECT COUNT(*) FROM RES_MASTER_DAMO A2 WITH(NOLOCK) WHERE A2.MASTER_CODE = B.MASTER_CODE AND A2.NEW_DATE > DATEADD(dd, -7, GETDATE())) AS [RESERVE_COUNT]                                                        
   , B.STAR_POINT, B.STAR_COUNT' 
	
	--IF @ORDER_BY = 3
	--BEGIN
	-- SET @SQLSTRING = @SQLSTRING + N'
	--  , (SELECT ISNULL(AVG(A2.GRADE), 0) FROM PRO_COMMENT A2 WITH(NOLOCK) WHERE A2.MASTER_CODE = B.MASTER_CODE) AS [STAR_POINT]'
	--END                                                        
	
	SET @SQLSTRING = @SQLSTRING + N'                                                        
  FROM PKG_MASTER A WITH(NOLOCK)                                                        
  LEFT JOIN PKG_MASTER_PARTNER B WITH(NOLOCK) ON A.MASTER_CODE = B.MASTER_CODE                                              
  '
	
	IF @PROVIDER NOT IN ('0' ,'5' ,'16' ,'18' ,'25')
	    SET @SQLSTRING = @SQLSTRING + N'INNER JOIN PKG_MASTER_AFFILIATE Z WITH(NOLOCK) ON Z.PROVIDER = CONVERT(INT, @PROVIDER) AND A.MASTER_CODE = Z.MASTER_CODE AND Z.USE_YN = ''Y''                                                        
  '
	
	SET @SQLSTRING = @SQLSTRING + N'                                                        
  ' + @WHERE;                                
	SET @SQLSTRING = @SQLSTRING + N'                                             
  ORDER BY ' + @SORT_STRING + 
	    ', A.MASTER_CODE                                                        
  OFFSET ((@PAGE_INDEX - 1) * @PAGE_SIZE) ROWS FETCH NEXT @PAGE_SIZE                                                        
  ROWS ONLY                                                        
 )                                                        
 SELECT                                     
  A.MASTER_CODE, A.MASTER_NAME, A.PKG_COMMENT, A.PKG_SUMMARY, A.LOW_PRICE, A.HIGH_PRICE, A.NEXT_DATE                                                        
  , A.EVENT_NAME                               
  , A.EVENT_PRO_CODE                                                        
                                  
  , A.EVENT_DEP_DATE                                                        
                                    
  , A.ATT_CODE, A.BRANCH_CODE, A.SIGN_CODE, A.BRAND_TYPE, A.CLEAN_YN                                                       
  , DBO.FN_GET_TOUR_NIGHY_DAY_TEXT(A.MASTER_CODE,0) AS TOUR_NIGHT_DAY                                                        
  , (SELECT SUM(GRADE) / COUNT(GRADE) FROM PRO_COMMENT WITH(NOLOCK) WHERE MASTER_CODE = A.MASTER_CODE) AS [GRADE]                                                        
  , (SELECT COUNT(*) FROM HBS_DETAIL WITH(NOLOCK) WHERE MASTER_SEQ = ''1'' AND MASTER_CODE = A.MASTER_CODE) AS [TRAVEL]                                                        
  , B.*                                                        
  , (SELECT TOP 1 PUB_VALUE FROM COD_PUBLIC AA WITH(NOLOCK) WHERE PUB_TYPE = ''PKG.ATTRIBUTE'' AND AA.PUB_CODE = A.ATT_CODE) AS [ATT_NAME]                                                        
                
  , (SELECT TOP 1 KOR_NAME FROM PUB_REGION AA WITH(NOLOCK) WHERE AA.SIGN = A.SIGN_CODE) AS [REGION_NAME]                           
  , (SELECT COUNT(*) FROM VR_CONTENT V2 WITH(NOLOCK) INNER JOIN VR_MASTER VM WITH(NOLOCK) ON V2.VR_NO = VM.VR_NO WHERE A.MASTER_CODE = V2.MASTER_CODE AND VM.VR_TYPE = 1) AS [VR_COUNT]                                                        
 -- , (SELECT COUNT(*) FROM PUB_EVENT_DATA A2 WITH(NOLOCK) INNER JOIN PUB_EVENT B2 WITH(NOLOCK)                                                         
 --  ON A2.EVT_SEQ = B2.EVT_SEQ WHERE B2.EVT_YN = ''Y'' AND A2.SHOW_YN = ''Y'' AND B2.SHOW_YN = ''Y'' AND A2.MASTER_CODE = A.MASTER_CODE AND B2.END_DATE >= GETDATE()) AS [EVENT_COUNT]                                                        
 -- , (                                                        
 --   SELECT TOP 1 B1.EVT_NAME                                                        
 --   FROM PUB_EVENT_DATA A1 WITH(NOLOCK)                                                        
 --   INNER JOIN PUB_EVENT B1 WITH(NOLOCK) ON A1.EVT_SEQ = B1.EVT_SEQ AND B1.EVT_YN = ''Y''                                                       
 --   WHERE A1.MASTER_CODE = A.MASTER_CODE AND A1.SHOW_YN = ''Y'' AND B1.SHOW_YN = ''Y'' AND (B1.END_DATE IS NULL OR B1.END_DATE >= GETDATE())                            
 --   ORDER BY B1.EVT_SEQ DESC                                                        
 --) AS [EVENT_NAME]                                                        
  , 0 AS [EVENT_COUNT]              
  , '''' AS [EVENT_NAME]              
  , (                                                        
    SELECT CONVERT(VARCHAR(10), A1.DEP_DATE, 120)                                                        
    FROM PKG_DETAIL A1 WITH(NOLOCK)                                                        
    WHERE A1.PRO_CODE = A.EVENT_PRO_CODE AND A1.DEP_DATE >= GETDATE()                                                        
 ) AS [EVENT_PRO_DATE]                                                        
  , A.TAG AS [TAG]                                                   
                 '
	
	SET @SQLSTRING = @SQLSTRING + 
	    N'                                  
  -- 2019 10 리뉴얼 WEEK_DAY 부터 추가                                                                 
  , DBO.FN_GET_MASTER_SUMMARY(Z.MASTER_CODE, ''W'') AS SUMMARY_WEEK_DAY                                                        
  , DBO.FN_GET_MASTER_SUMMARY(Z.MASTER_CODE, ''T'') AS SUMMARY_TYPE                                    
  , DBO.FN_GET_MASTER_SUMMARY(Z.MASTER_CODE, ''D'') AS SUMMARY_TOUR_DAY                                                        
  , DBO.FN_GET_MASTER_SUMMARY(Z.MASTER_CODE, ''P'') AS SUMMARY_PRICE                                                        
  , DBO.FN_GET_MASTER_SUMMARY(Z.MASTER_CODE, ''A'') AS SUMMARY_AIRLINE                                           
  , DBO.FN_GET_MASTER_SUMMARY(Z.MASTER_CODE, ''G'') AS SUMMARY_HOTEL_GRADE                                    
  , DBO.FN_GET_MASTER_SUMMARY(Z.MASTER_CODE, ''S'') AS SUMMARY_STARTING              
  , DBO.FN_GET_MASTER_SUMMARY(Z.MASTER_CODE, ''D.TOURDAY'') AS SUMMARY_D_TOURDAY
  , A.AIRLINE_CODE                                        
  , (SELECT TOP 1 KOR_NAME FROM PUB_AIRLINE WHERE AIRLINE_CODE = A.AIRLINE_CODE) AS AIRLINE_NAME                                                        
  , DBO.FN_GET_MASTER_TRANS_SELECT(Z.MASTER_CODE) AS MASTER_TRANS                                 
  , DBO.FN_GET_MASTER_COMMENT_SELECT(Z.MASTER_CODE) AS MASTER_BO       -- 상품평 , 작성자 , 별점                                                                  
  , DBO.FN_GET_PACKAGE(Z.MASTER_CODE) AS PRO_CODE                                    
  , KEYWORD AS MASTER_KEYWORD                              
  , A.REGION_ORDER,A.THEME_ORDER,A.GROUP_ORDER, Z.ALONE_PERCENT, Z.FRIEND_PERCENT, Z.FAMILY_PERCENT, Z.COUPLE_PERCENT, Z.MEETING_PERCENT, Z.ETC_PERCENT, Z.TOTAL_COUNT,Z.ATT_ORDER                              
  '                                                   
	
	SET @SQLSTRING = @SQLSTRING + N'                                                        
 FROM LIST Z                                                          
 INNER JOIN PKG_MASTER A WITH(NOLOCK) ON Z.MASTER_CODE = A.MASTER_CODE                                                          
 LEFT OUTER JOIN INF_FILE_MASTER B WITH(NOLOCK) ON A.MAIN_FILE_CODE = B.FILE_CODE    
 ORDER BY ' + @SORT_STRING + ', A.MASTER_CODE;' 
	
	PRINT CAST(@SQLSTRING AS NTEXT)                          
	
	SET @PARMDEFINITION = N'
  @PAGE_INDEX INT,
  @PAGE_SIZE INT,
  @TOTAL_COUNT INT OUTPUT,
  @BRAND_TYPE VARCHAR(1),
  @DEP_DATE VARCHAR(10),
  @PROVIDER VARCHAR(3),
  @MIN_PRICE VARCHAR(10),
  @MAX_PRICE VARCHAR(10)';
	
	
	EXEC SP_EXECUTESQL @SQLSTRING
	    ,@PARMDEFINITION
	    ,@PAGE_INDEX
	    ,@PAGE_SIZE
	    ,@TOTAL_COUNT OUTPUT
	    ,@BRAND_TYPE
	    ,@DEP_DATE
	    ,@PROVIDER
	    ,@MIN_PRICE
	    ,@MAX_PRICE;
END
GO
