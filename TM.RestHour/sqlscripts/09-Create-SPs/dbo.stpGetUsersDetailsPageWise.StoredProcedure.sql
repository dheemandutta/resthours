USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetUsersDetailsPageWise]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetUsersDetailsPageWise]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpGetUsersDetailsPageWise]
GO
/****** Object:  StoredProcedure [dbo].[stpGetUsersDetailsPageWise]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetUsersDetailsPageWise]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[stpGetUsersDetailsPageWise]

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

            ORDER BY [Username] ASC

      )AS RowNumber

      ,ID

      ,Username

	  ,Active

	

     INTO #Results

      FROM Users

     

      SELECT @RecordCount = COUNT(*)

      FROM #Results

           

      SELECT * FROM #Results

      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

     

      DROP TABLE #Results

END' 
END
GO
