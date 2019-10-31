

ALTER PROCEDURE [dbo].[stpGetCrewReportListPageWise]

 (

      @PageIndex INT = 1,

      @PageSize INT = 10,

      @RecordCount INT OUTPUT,

	  @VesselID int

)

AS

BEGIN

      SET NOCOUNT ON;

      SELECT ROW_NUMBER() OVER

      (

            ORDER BY [FirstName] ASC

      )AS RowNumber

     ,FirstName + ' ' +LastName AS Name

	 ,R.RankName

	 ,(ISNULL(CONVERT(VARCHAR(12),C.DOB,103),'') +' '+ISNULL(C.POB,'') ) AS DOB1

	 ,C.ID

	 ,CM.CountryName AS Nationality

	 ,C.EmployeeNumber

	 ,C.DOB

	 ,C.PassportSeamanPassportBook

	 ,C.VesselID

 INTO #Results

FROM Crew C INNER JOIN Ranks R

ON C.RankID = R.ID
INNER JOIN CountryMaster CM
ON C.CountryID = CM.CountryID

--GROUP BY Name,RankName,CreatedOn,C.LatestUpdate

	

     

      SELECT @RecordCount = COUNT(*)

      FROM #Results

           

      SELECT * FROM #Results

      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

     AND VesselID=@VesselID

      DROP TABLE #Results

END