
-- exec stpGetCrewIDFromWorkSessions '19' ,'11','2017', '9876543'



ALTER PROCEDURE [dbo].[stpGetDataForVarianceReport]

(

	@CrewId int,
	@Month int,
	@Year int,
    @PageIndex INT = 1,
	@PageSize INT = 31,
	@RecordCount INT OUTPUT,
	@VesselID int

)

AS

BEGIN

		

		

		SET NOCOUNT ON;

      SELECT ROW_NUMBER() OVER

      (

            ORDER BY WS.ID ASC

      )AS RowNumber

      ,WS.ID

	  ,Hours

	  ,DAY(ValidOn) AS BookDate

	  ,FirstName

	  ,LastName

	  ,RankName

	  --,ISNULL(CONVERT(varchar(12),ValidOn,dbo.ufunc_GetDateFormat()), '') AS WorkDate
	   ,ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),ValidOn,dbo.ufunc_GetDateFormat()), ' ','/'), ',',''), '/') WorkDate

	  ,ComplianceInfo

	  ,TotalNCHours

	  ,Comment

	  ,AdjustmentFator AS 'AdjustmentFactor'

	  ,C.VesselID

	 -- ,C.ID        --------------------------------------------------------------------------------------

     INTO #Results

       FROM WorkSessions WS

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

		



		SELECT @RecordCount = COUNT(*)

      FROM #Results



	   SELECT  * FROM #Results

      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

	  AND VesselID=@VesselID

	  ORDER BY WorkDate ASC

     

      DROP TABLE #Results

		

	--	SELECT Hours,DAY(ValidOn) AS BookDate,C.FirstName,C.LastName,R.RankName,ISNULL(CONVERT(varchar(12),ValidOn,103), '') AS WorkDate,ComplianceInfo,TotalNCHours,WS.Comment

	--	FROM WorkSessions WS

	--	LEFT OUTER JOIN Crew C

	--	ON C.ID = WS.CrewID

	--	INNER JOIN NCDetails NCD

	--	ON WS.CrewId= NCD.CrewID 

	--	AND  WS.ValidOn = NCD.OccuredOn

	--	INNER JOIN Ranks R

	--	ON R.ID = C.RankID

		

	

END

















