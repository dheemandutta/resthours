--  declare @x int Exec stpGetMedicalAdvisoryListPageWise  1,20, @x out
create PROCEDURE [dbo].[stpGetMedicalAdvisoryListPageWise]
(
      @PageIndex INT = 1,
      @PageSize INT = 10,
      @RecordCount INT OUTPUT
)
AS
BEGIN
      SET NOCOUNT ON;
      SELECT ROW_NUMBER() OVER
      (
            ORDER BY [CrewName] ASC

      )AS RowNumber

     ,CrewName
	 ,[Weight]
	 ,BMI
	 ,BloodSugarLevel
	 ,Systolic
	 ,Diastolic
	 ,UrineTest
	 ,UnannouncedAlcohol
	 ,AnnualDH
	 ,[Month]

 INTO #Results

FROM MedicalAdvisory 

--GROUP BY Name,RankName,CreatedOn,C.LatestUpdate
      SELECT @RecordCount = COUNT(*)

      FROM #Results

      SELECT * FROM #Results

      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

      DROP TABLE #Results
END
