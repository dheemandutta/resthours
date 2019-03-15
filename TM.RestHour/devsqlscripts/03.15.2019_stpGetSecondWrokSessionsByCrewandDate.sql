
CREATE PROCEDURE [dbo].[stpGetSecondWrokSessionsByCrewandDate]

(

	@CrewId int,
	@BookDate DateTime, 
	@VesselID int 

)

AS

BEGIN



	SELECT TOP 1 *,NCD.NCDetailsID, NCD.VesselID,WS.ID,WS.Comment,WS.RegimeID FROM WorkSessions WS

	INNER JOIN NCDetails NCD

	ON WS.ID = NCD.WorkSessionId 

	WHERE WS.CrewId = @CrewId

	AND CONVERT(varchar(12),ValidOn,103) = CONVERT(varchar(12),@BookDate,103)
	AND NCD.VesselID=@VesselID
	ORDER BY Timestamp DESC



END