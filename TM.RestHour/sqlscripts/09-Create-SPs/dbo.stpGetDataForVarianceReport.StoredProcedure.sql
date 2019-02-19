USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetDataForVarianceReport]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetDataForVarianceReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpGetDataForVarianceReport]
GO
/****** Object:  StoredProcedure [dbo].[stpGetDataForVarianceReport]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetDataForVarianceReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- exec stpGetCrewIDFromWorkSessions ''19'' ,''11'',''2017''



CREATE PROCEDURE [dbo].[stpGetDataForVarianceReport]

(

	@CrewId int,

	@Month int,

	@Year int,

	 @PageIndex INT = 1,

      @PageSize INT = 31,

      @RecordCount INT OUTPUT

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

	  ,ISNULL(CONVERT(varchar(12),ValidOn,103), '''') AS WorkDate

	  ,ComplianceInfo

	  ,TotalNCHours

	  ,Comment

	  ,AdjustmentFator AS ''AdjustmentFactor''

	

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

	  ORDER BY WorkDate ASC

     

      DROP TABLE #Results

		

	--	SELECT Hours,DAY(ValidOn) AS BookDate,C.FirstName,C.LastName,R.RankName,ISNULL(CONVERT(varchar(12),ValidOn,103), '''') AS WorkDate,ComplianceInfo,TotalNCHours,WS.Comment

	--	FROM WorkSessions WS

	--	LEFT OUTER JOIN Crew C

	--	ON C.ID = WS.CrewID

	--	INNER JOIN NCDetails NCD

	--	ON WS.CrewId= NCD.CrewID 

	--	AND  WS.ValidOn = NCD.OccuredOn

	--	INNER JOIN Ranks R

	--	ON R.ID = C.RankID

		

	

END' 
END
GO
