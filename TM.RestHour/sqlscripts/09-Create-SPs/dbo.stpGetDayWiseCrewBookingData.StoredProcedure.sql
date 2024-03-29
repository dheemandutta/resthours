USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetDayWiseCrewBookingData]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetDayWiseCrewBookingData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpGetDayWiseCrewBookingData]
GO
/****** Object:  StoredProcedure [dbo].[stpGetDayWiseCrewBookingData]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetDayWiseCrewBookingData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[stpGetDayWiseCrewBookingData]

(

	@BookDate DateTime

)

AS

BEGIN



SELECT Hours,CrewID, C.FirstName,C.LastName,C.Nationality,R.RankName,Comment,AdjustmentFator As AdjustmentFactor

FROM WorkSessions W

INNER JOIN Crew C

ON C.ID= W.CrewID

INNER JOIN Ranks R

ON C.RankID = R.ID 

WHERE CONVERT(varchar(12),ValidOn,103) = CONVERT(varchar(12),@BookDate,103)

ORDER BY CrewID



END' 
END
GO
