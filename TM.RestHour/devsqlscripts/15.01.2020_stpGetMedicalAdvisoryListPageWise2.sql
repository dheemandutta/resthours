USE [RestHourClient]
GO
/****** Object:  StoredProcedure [dbo].[stpGetMedicalAdvisoryListPageWise2]    Script Date: 15/01/2020 12:08:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  declare @x int Exec stpGetMedicalAdvisoryListPageWise2  1,20, @x out
create PROCEDURE [dbo].[stpGetMedicalAdvisoryListPageWise2]
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
            ORDER BY [MedicalAdvisoryID] ASC

      )AS RowNumber
	  
	  ,MedicalAdvisoryID
     --,CrewName
	 ,[Weight]
	 ,BMI
	  ,BloodSugarLevel + ' ' + BloodSugarUnit AS BloodSugarLevel
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
