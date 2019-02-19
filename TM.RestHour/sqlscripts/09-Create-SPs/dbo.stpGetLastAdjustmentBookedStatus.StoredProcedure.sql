USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetLastAdjustmentBookedStatus]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetLastAdjustmentBookedStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpGetLastAdjustmentBookedStatus]
GO
/****** Object:  StoredProcedure [dbo].[stpGetLastAdjustmentBookedStatus]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetLastAdjustmentBookedStatus]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[stpGetLastAdjustmentBookedStatus]

(

	@BookDate datetime,

	@CrewID int

)

AS

BEGIN

	DECLARE @LastMinuSOneAdjustmentDate Datetime



	SELECT @LastMinuSOneAdjustmentDate = MAX(CONVERT(date,AdjustmentDate,110)) FROM TimeAdjustment

	WHERE AdjustmentValue = ''-1D''

	AND CONVERT(DATE,AdjustmentDate,110) < CONVERT(DATE,@BookDate,110)



	IF @LastMinuSOneAdjustmentDate IS NOT NULL

		BEGIN



		SELECT COUNT(*) AS ''BookCount'',CONVERT(DATE,@LastMinuSOneAdjustmentDate,113) AS ''LastBookDate''

		FROM WorkSessions 

		WHERE CONVERT(DATE,ValidOn,110) = CONVERT(DATE,@LastMinuSOneAdjustmentDate,110)

		AND CrewID = @CrewID



		END

	ELSE

		BEGIN

			SELECT 0 AS ''BookCount'' ,CONVERT(DATE,@LastMinuSOneAdjustmentDate,113) AS ''LastBookDate''  

		END



END' 
END
GO
