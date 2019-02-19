

ALTER PROCEDURE [dbo].[stpGetNoNCForMonth]
(
	@Month int,
	@Year int,
	@CrewId int,
	@VesselID int
)
AS
BEGIN

	SELECT DAY(NC.OccuredOn) As NcDay, NC.VesselID
	FROM NCDetails NC
	INNER JOIN WorkSessions WS
	ON NC.WorkSessionId = WS.ID
	WHERE NC.CrewID = @CrewId
	AND MONTH(OccuredOn) = @Month
	AND YEAR(OccuredOn) = @Year

	AND NC.VesselID=@VesselID
	AND WS.ActualHours <> '0000,0000,0000,0000,0000,0000'
	AND NC.isNC=0
	ORDER BY DAY(OccuredOn) ASC
	


END










