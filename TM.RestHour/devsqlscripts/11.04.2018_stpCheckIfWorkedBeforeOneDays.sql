--exec stpCheckIfWorkedBeforeSevenDays '09/07/2018',23,9876543
CREATE PROCEDURE [dbo].[stpCheckIfWorkedBeforeOneDays]
(
	@BookDate datetime,
	@CrewId int,
	@VesselID int
)
AS
BEGIN
	
	DECLARE @ServiceStartDate datetime

	SELECT @ServiceStartDate = ActiveFrom 
	FROM ServiceTerms
	WHERE CrewID= @CrewID
	AND VesselID = @VesselID

	SELECT COUNT(*) 
	FROM WorkSessions 
	WHERE ValidOn BETWEEN @ServiceStartDate AND DATEADD(day,-1,@BookDate)
	AND CrewID =  @CrewId
	And VesselID = @VesselID

END
