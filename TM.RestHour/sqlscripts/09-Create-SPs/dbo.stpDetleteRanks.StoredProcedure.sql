USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpDetleteRanks]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpDetleteRanks]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpDetleteRanks]
GO
/****** Object:  StoredProcedure [dbo].[stpDetleteRanks]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpDetleteRanks]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[stpDetleteRanks]

( 

@ID int

)

AS

BEGIN

DECLARE @CrewId AS INT = (SELECT DISTINCT ISNULL(RankID,0) FROM Crew WHERE RankID=@ID )

  

--select previd  from #temp

  --IF ISNULL(@CrewId,0)=@ID 

  --SELECT ISNULL(@CrewId,0) AS CrewId

IF @ID <> ISNULL(@CrewId,0)  

  BEGIN

 IF OBJECT_ID(''tempdb..#temp'') IS NOT NULL

   DROP TABLE #temp

   SELECT [Order] as previd INTO #temp

   FROM   Ranks  WHERE ID=@ID  

   BEGIN TRY

   BEGIN TRAN

   DELETE FROM Ranks WHERE ID=@ID

   SET NOCOUNT ON

   DECLARE @REC_ID        AS INT

   DECLARE @MaxCount      AS INT

   

  IF OBJECT_ID(''tempdb..#temp2'') IS NOT NULL

   DROP TABLE #temp2

   SELECT ROW_NUMBER() OVER

      (

            ORDER BY [ID] ASC

      )AS OrderNumber,Id,[Order] as orderno

	  into #temp2

	  from Ranks 

   

    SET @MaxCount = (SELECT MAX(OrderNumber) FROM #temp2 a where a.orderno >(select previd FROM #temp))

	--select @MaxCount

    SET @REC_ID = (SELECT previd FROM #temp)

	DECLARE @Prv_ID AS INT 

	SET @Prv_ID = (SELECT previd-1 FROM #temp)

	--select @Prv_ID

	WHILE ( @REC_ID <= @MaxCount )

    BEGIN

	--print ''ssg''

     UPDATE Ranks SET [Order] = @REC_ID

	 WHERE [Order] = @REC_ID+1

            

     --SELECT @REC_ID,NULL

	 IF(@REC_ID > @Prv_ID AND @REC_ID <= @MaxCount)

    BEGIN

        SET @REC_ID = @REC_ID + 1

        CONTINUE

    END

    

    ELSE

    BEGIN

        BREAK

    END

END

SET NOCOUNT OFF 

        COMMIT TRAN

END TRY

 BEGIN CATCH

		ROLLBACK TRAN

 END CATCH





  END

  

END



/*

begin tran

exec stpDetleteRanks 

@ID=1020

select * from Ranks



rollback

*/' 
END
GO
