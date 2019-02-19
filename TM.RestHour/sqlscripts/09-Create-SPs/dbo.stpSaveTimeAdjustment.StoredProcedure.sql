USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpSaveTimeAdjustment]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpSaveTimeAdjustment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpSaveTimeAdjustment]
GO
/****** Object:  StoredProcedure [dbo].[stpSaveTimeAdjustment]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpSaveTimeAdjustment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[stpSaveTimeAdjustment] 

  

( 

@AdjustmentDate datetime,

@AdjustmentValue varchar(30)

) 



AS 

BEGIN 



BEGIN TRY



BEGIN TRAN



IF EXISTS (SELECT 1 FROM TimeAdjustment WHERE  CONVERT(varchar(12),AdjustmentDate,103)=  CONVERT(varchar(12),@AdjustmentDate,103) )



	BEGIN



		UPDATE TimeAdjustment

		SET AdjustmentValue = @AdjustmentValue

		WHERE CONVERT(varchar(12),AdjustmentDate,101) =  CONVERT(varchar(12),@AdjustmentDate,101) 





	END

ELSE

	BEGIN

			INSERT INTO TimeAdjustment 

			   (AdjustmentDate, AdjustmentValue)  

		Values(@AdjustmentDate,@AdjustmentValue)



	END



EXEC stpUpdateTimeEntry  @AdjustmentDate,@AdjustmentValue

 

 



 COMMIT TRAN



 END TRY

 BEGIN CATCH

	ROLLBACK TRAN



	PRINT @@ERROR



 END CATCH

 



 END' 
END
GO
