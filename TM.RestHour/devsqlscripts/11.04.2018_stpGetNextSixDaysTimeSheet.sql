USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetNextSixDaysTimeSheet]    Script Date: 11/6/2018 2:15:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[stpGetNextSixDaysTimeSheet]
(
	@BookDate Datetime,
	@CrewId int,
	@VesselId int
	
)
AS
BEGIN

	SELECT ID,ActualHours,AdjustmentFator,RegimeID,CONVERT(varchar(12),ValidOn,101) As ValidOn
	 FROM WorkSessions
	 WHERE CrewID = @CrewId
	 AND ValidOn BETWEEN DATEADD(day,1,@BookDate) AND DATEADD(day,6,@BookDate)
	 AND VesselID = @VesselId
	 ORDER BY ValidOn
END