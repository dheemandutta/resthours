USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetPlusOneDayAdjustmentDays]    Script Date: 3/1/2018 1:08:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetPlusOneDayAdjustmentDays]

(
	@Month int,
	@Year int
)
AS
BEGIN

	SELECT ISNULL(CONVERT(varchar(12),AdjustmentDate,103), '') AS AdjustmentDate
	FROM TimeAdjustment
	WHERE AdjustmentValue = '+1D'
	AND MONTH(AdjustmentDate) = @Month
	AND YEAR(AdjustmentDate) = @Year

END
GO
