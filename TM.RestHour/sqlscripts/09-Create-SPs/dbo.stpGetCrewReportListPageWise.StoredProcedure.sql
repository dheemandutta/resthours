USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewReportListPageWise]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetCrewReportListPageWise]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpGetCrewReportListPageWise]
GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewReportListPageWise]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetCrewReportListPageWise]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[stpGetCrewReportListPageWise]

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

            ORDER BY [FirstName] ASC

      )AS RowNumber

     ,FirstName + '' '' +LastName AS Name

	 ,R.RankName

	 ,(ISNULL(CONVERT(VARCHAR(12),C.DOB,103),'''') +'' ''+ISNULL(C.POB,'''') ) AS DOB1

	 ,C.ID

	 ,C.Nationality

	 ,C.EmployeeNumber

	 ,C.DOB

	 ,C.PassportSeamanPassportBook



 INTO #Results

FROM Crew C INNER JOIN Ranks R

ON C.RankID = R.ID

--GROUP BY Name,RankName,CreatedOn,C.LatestUpdate

	

     

      SELECT @RecordCount = COUNT(*)

      FROM #Results

           

      SELECT * FROM #Results

      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

     

      DROP TABLE #Results

END' 
END
GO
