USE [RestHourDemo]
GO
/****** Object:  StoredProcedure [dbo].[stpGetDepartmentPageWise]    Script Date: 11/14/2018 10:00:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  declare @x int Exec stpGetDepartmentPageWise 1,15, @x out, 9876543
ALTER PROCEDURE [dbo].[stpGetDepartmentPageWise]
 (
      @PageIndex INT = 1,
      @PageSize INT = 15,
      @RecordCount INT OUTPUT,
	  @VesselID int
)
AS
BEGIN
      SET NOCOUNT ON;
      SELECT ROW_NUMBER() OVER
      (
            ORDER BY [DepartmentMasterName] ASC
      )AS RowNumber
      ,DM.DepartmentMasterID
      ,DepartmentMasterName
	 -- ,DepartmentMasterCode
	  ,FirstName + '  ' +LastName AS CrewName
	 -- ,Scheduled
	  ,DM.VesselID
     INTO #Results
      FROM DepartmentMaster DM  
	  LEFT OUTER JOIN DepartmentAdmin DA
	  ON DM.DepartmentMasterID = DA.DepartmentMasterID
	  LEFT OUTER JOIN Crew C
	  ON DA.CrewID=C.ID               
	    Where DM.VesselID = @VesselID
		AND DM.IsActive=1
      SELECT @RecordCount = COUNT(*)
      FROM #Results
      SELECT * FROM #Results
      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

	  AND VesselID=@VesselID
	 -- ORDER BY [Order] ASC
      DROP TABLE #Results
END













