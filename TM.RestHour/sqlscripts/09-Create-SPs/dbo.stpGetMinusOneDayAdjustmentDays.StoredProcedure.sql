USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetMinusOneDayAdjustmentDays]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetMinusOneDayAdjustmentDays]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpGetMinusOneDayAdjustmentDays]
GO
/****** Object:  StoredProcedure [dbo].[stpGetMinusOneDayAdjustmentDays]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetMinusOneDayAdjustmentDays]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

---EXEC stpGetMinusOneDayAdjustmentDays 2,2018,1048

CREATE PROCEDURE [dbo].[stpGetMinusOneDayAdjustmentDays]



(

	@Month int,

	@Year int,

	@CrewId int

)

AS

BEGIN



	SELECT ISNULL(DAY(AdjustmentDate), '''') AS MinusAdjustmentDate,NULL AS AdjustmentDate

	FROM TimeAdjustment 

	WHERE AdjustmentValue = ''-1D''

	AND MONTH(AdjustmentDate) = @Month

	AND YEAR(AdjustmentDate) = @Year

	AND AdjustmentDate IN (SELECT ValidOn 

							FROM WorkSessions WHERE CrewID = @CrewId 

							AND MONTH(ValidOn)= @Month

						    AND YEAR(ValidOn) = @Year

							AND AdjustmentFator = ''-1D'' )

END' 
END
GO
