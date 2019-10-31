alter PROCEDURE [dbo].[stpGetTimeAdjustmentDetailsPageWise]
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
            ORDER BY [AdjustmentDate] ASC
      )AS RowNumber
     -- ,AdjustmentDate
      ,AdjustmentValue
	,CONVERT(varchar(12),AdjustmentDate,101) AdjustmentDate
     INTO #Results
      FROM TimeAdjustment
	
     
      SELECT @RecordCount = COUNT(*)
      FROM #Results
           
      SELECT * FROM #Results
      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1
     
      DROP TABLE #Results
END






