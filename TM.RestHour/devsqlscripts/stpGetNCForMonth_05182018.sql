--exec stpGetNCForMonth 04,2018

ALTER PROCEDURE stpGetNCForMonth
(
	@Month int,
	@Year int,
	@CrewId int
)
AS
BEGIN

	SELECT DAY(OccuredOn) As NcDay
	FROM NCDetails
	WHERE CrewID = @CrewId
	AND MONTH(OccuredOn) = @Month
	AND YEAR(OccuredOn) = @Year
	AND isNC=1
	ORDER BY DAY(OccuredOn) ASC
	


END