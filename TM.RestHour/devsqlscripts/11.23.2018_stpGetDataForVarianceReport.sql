
-- declare @x int  exec stpGetDataForVarianceReport '1' ,'10','2018', 1,39,@x out,9876543



ALTER PROCEDURE [dbo].[stpGetDataForVarianceReport]

(

	@CrewId int,
	@Month int,
	@Year int,
    @PageIndex INT = 1,
	@PageSize INT = 39,
	@RecordCount INT OUTPUT,
	@VesselID int

)

AS

BEGIN

		
	   DECLARE @ResultTab TABLE
	   (

			ID int,
			Hours nchar(48),
			BookDate int,
			FirstName varchar(50),
			LastName varchar(50),
			RankName varchar(50),
			WorkDate varchar(12),
			ComplianceInfo xml,
			TotalNCHours float,
			Comment nvarchar(150),
			AdjustmentFactor varchar(10),
			VesselID int,
			MinTotalRestIn7Days float,
			SevenDaysRest varchar(10),
			ValidOnDt datetime

	   )

		DECLARE @id int
		DECLARE @bdate varchar(11)
		DECLARE @workdy int
		DECLARE @workmon int
		DECLARE @workyr int
		DECLARE @sevendaysrest varchar(10)

		SET NOCOUNT ON;

 --     SELECT ROW_NUMBER() OVER

 --     (

 --           ORDER BY WS.ID ASC

 --     )AS RowNumber
 --     ,WS.ID
	--  ,Hours
	--  ,DAY(ValidOn) AS BookDate
	--  ,FirstName
	--  ,LastName
	--  ,RankName
	--  --,ISNULL(CONVERT(varchar(12),ValidOn,dbo.ufunc_GetDateFormat()), '') AS WorkDate
	--   ,ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),ValidOn,dbo.ufunc_GetDateFormat()), ' ','/'), ',',''), '/') WorkDate
	--  ,ComplianceInfo
	--  ,TotalNCHours
	--  ,Comment
	--  ,AdjustmentFator AS 'AdjustmentFactor'
	--  ,C.VesselID
	--  ,REG.MinTotalRestIn7Days
	-- -- ,C.ID        --------------------------------------------------------------------------------------
 --    INTO #Results
 --      FROM WorkSessions WS
	--    INNER JOIN Regimes REG
	--	ON WS.RegimeID = REG.ID
	--	LEFT OUTER JOIN Crew C
	--	ON C.ID = WS.CrewID
	--	LEFT OUTER  JOIN NCDetails NCD
	--	ON WS.ID= NCD.WorkSessionId 
	--	AND  WS.ValidOn = NCD.OccuredOn
	--	LEFT OUTER JOIN Ranks R
	--	ON R.ID = C.RankID
	--	WHERE WS.CrewId = @CrewId
	--	--AND NCD.CrewID = @CrewId
	--	 AND MONTH(ValidON) = @Month
	--	 AND YEAR(ValidOn) = @Year
	--	AND MONTH(OccuredOn) = @Month
	--	AND YEAR(OccuredOn) = @Year
	--AND isNC = 1

	 SET @sevendaysrest = '-'

	  INSERT INTO @ResultTab(ID,Hours,BookDate,FirstName,LastName,RankName,WorkDate,ComplianceInfo,TotalNCHours,Comment,AdjustmentFactor,VesselID,MinTotalRestIn7Days,ValidOnDt)
	  SELECT WS.ID,Hours,DAY(ValidOn) AS BookDate,FirstName,LastName,RankName,ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),ValidOn,dbo.ufunc_GetDateFormat()), ' ','/'), ',',''), '/') WorkDate
	  ,ComplianceInfo,TotalNCHours,Comment,AdjustmentFator AS 'AdjustmentFactor',C.VesselID,REG.MinTotalRestIn7Days,ValidOn
      FROM WorkSessions WS
	    INNER JOIN Regimes REG
		ON WS.RegimeID = REG.ID
		LEFT OUTER JOIN Crew C
		ON C.ID = WS.CrewID
		LEFT OUTER  JOIN NCDetails NCD
		ON WS.ID= NCD.WorkSessionId 
		AND  WS.ValidOn = NCD.OccuredOn
		LEFT OUTER JOIN Ranks R
		ON R.ID = C.RankID
		WHERE WS.CrewId = @CrewId
		--AND NCD.CrewID = @CrewId
		 AND MONTH(ValidON) = @Month
		 AND YEAR(ValidOn) = @Year
		AND MONTH(OccuredOn) = @Month
		AND YEAR(OccuredOn) = @Year
		AND isNC = 1


		--select * from @ResultTab


	    DECLARE db_cursor CURSOR FOR 
		SELECT ID,ValidOnDt FROM @ResultTab

		OPEN db_cursor  
		FETCH NEXT FROM db_cursor INTO @id,@bdate

		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			
			  set @workdy = DAY(@bdate)
			  set @workmon = MONTH(@bdate)
			  set @workyr =  YEAR(@bdate)	

			  EXEC stpGetWorkSessionsByValidOn @workdy,
											   @workmon,
											   @workyr,
											    @CrewId,
												@sevendaysrest OUTPUT
			 print @workdy
			 print @workmon
			 print @workyr

			  UPDATE @ResultTab SET SevenDaysRest= CONVERT(varchar,@sevendaysrest) WHERE ID  = @id

			  SET @sevendaysrest = '-'

			FETCH NEXT FROM db_cursor INTO @id,@bdate
		END  

		
		CLOSE db_cursor
		DEALLOCATE db_cursor

	SELECT ROW_NUMBER() OVER
		(
            ORDER BY ID ASC

      )AS RowNumber
      ,ID
	  ,Hours
	  ,BookDate
	  ,FirstName
	  ,LastName
	  ,RankName
	  ,WorkDate
	  ,ComplianceInfo
	  ,TotalNCHours
	  ,Comment
	  ,AdjustmentFactor
	  ,VesselID
	  ,MinTotalRestIn7Days
	  ,SevenDaysRest
      INTO #Results
      FROM @ResultTab


		
		SELECT @RecordCount = COUNT(*) FROM #Results



	   SELECT  * FROM #Results
       WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1
	   AND VesselID=@VesselID
	   ORDER BY WorkDate ASC

     

      DROP TABLE #Results

		

	

		

	

END

















