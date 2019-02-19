CREATE PROCEDURE stpGetCrewOvertimeValue

(
	@CrewId int
)
AS
BEGIN
	SELECT OvertimeEnabled FROM Crew WHERE ID = @CrewId
END