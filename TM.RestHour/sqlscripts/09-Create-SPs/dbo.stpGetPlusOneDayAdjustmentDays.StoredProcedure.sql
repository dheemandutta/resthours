USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetPlusOneDayAdjustmentDays]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetPlusOneDayAdjustmentDays]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpGetPlusOneDayAdjustmentDays]
GO
/****** Object:  StoredProcedure [dbo].[stpGetPlusOneDayAdjustmentDays]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetPlusOneDayAdjustmentDays]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[stpGetPlusOneDayAdjustmentDays]



(

	@Month int,

	@Year int

)

AS

BEGIN



	SELECT ISNULL(CONVERT(varchar(12),AdjustmentDate,103), '''') AS AdjustmentDate, NULL as MinusAdjustmentDate

	FROM TimeAdjustment

	WHERE AdjustmentValue = ''+1D''

	AND MONTH(AdjustmentDate) = @Month

	AND YEAR(AdjustmentDate) = @Year



END' 
END
GO
