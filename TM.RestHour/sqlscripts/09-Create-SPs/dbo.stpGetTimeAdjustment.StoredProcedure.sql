USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetTimeAdjustment]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetTimeAdjustment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpGetTimeAdjustment]
GO
/****** Object:  StoredProcedure [dbo].[stpGetTimeAdjustment]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetTimeAdjustment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[stpGetTimeAdjustment]

(

	@BookDate Datetime

)

AS



Begin







IF EXISTS (SELECT 1 FROM TimeAdjustment WHERE  CONVERT(varchar(12),AdjustmentDate,103)=  CONVERT(varchar(12),@BookDate,103) )

BEGIN

		Select isnull(AdjustmentValue,0) AS AdjustmentValue

		from dbo.TimeAdjustment  

		WHERE  CONVERT(varchar(12),AdjustmentDate,101) =  CONVERT(varchar(12),@BookDate,101) 

END

ELSE

BEGIN

	if exists (select top 1 ''a'' from TimeAdjustment where DATEADD(day,1, CONVERT(date, CONVERT(varchar(12),AdjustmentDate,106))) =  (convert(date,CONVERT(varchar(12),@BookDate,106)) ) and AdjustmentValue = ''+1d'')

	begin

		SELECT ''BOOKING_NOT_ALLOWED'' AS AdjustmentValue

	end

	else

	begin

		SELECT 0 AS AdjustmentValue

	end

END

End' 
END
GO
