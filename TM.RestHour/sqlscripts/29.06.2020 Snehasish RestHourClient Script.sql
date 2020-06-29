USE [RestHourClient]
GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewTemperaturePageWieByCrewID]    Script Date: 29-Jun-20 11:54:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[stpGetCrewTemperaturePageWieByCrewID]
(
@CrewID int,	
      @PageIndex INT = 1,
      @PageSize INT = 15,
      @RecordCount INT OUTPUT
)
AS
BEGIN
      SET NOCOUNT ON;
      SELECT ROW_NUMBER() OVER
      (
            ORDER BY [CrewID]ASC
      )AS RowNumber,
ct.ID, ct.CrewID, ct.Temperature, ct.Unit, ct.ReadingDate, ct.ReadingTime, ct.Comment, ct.TemperatureModeID, tm.Mode, c.Name

     INTO #Results
FROM CrewTemperature CT
INNER JOIN TemperatureMode TM
ON ct.TemperatureModeID= tm.ID
INNER JOIN Crew C
ON ct.CrewID= C.ID
WHERE ct.CrewID= @CrewID
      SELECT @RecordCount = COUNT(*)
      FROM #Results
      SELECT * FROM #Results
      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1
	 -- ORDER BY [Order] ASC
      DROP TABLE #Results
END
