ALTER PROCEDURE [dbo].[stpGetDayWiseCrewBookingData]

(

	@BookDate DateTime,
	@VesselID int

)

AS

BEGIN



SELECT Hours,CrewID, C.FirstName,C.LastName,CM.CountryName AS Nationality,R.RankName,Comment,AdjustmentFator As AdjustmentFactor, C.VesselID

FROM WorkSessions W

INNER JOIN Crew C

ON C.ID= W.CrewID

INNER JOIN CountryMaster CM

ON CM.CountryID = c.CountryID

INNER JOIN Ranks R

ON C.RankID = R.ID 

WHERE CONVERT(varchar(12),ValidOn,103) = CONVERT(varchar(12),@BookDate,103)
AND C.VesselID=@VesselID

ORDER BY CrewID



END