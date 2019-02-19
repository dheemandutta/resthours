
ALTER PROCEDURE [dbo].[stpGetDayWiseCrewBookingData]

(

	@BookDate DateTime,
	@VesselID int

)

AS

BEGIN



SELECT Hours,W.CrewID, C.FirstName,C.LastName,CM.CountryName AS Nationality,ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),ValidOn,dbo.ufunc_GetDateFormat()), ' ','/'), ',',''), '/') WorkDate,
R.RankName,Comment,AdjustmentFator As AdjustmentFactor, C.VesselID,RegimeName,NC.ComplianceInfo

FROM WorkSessions W
INNER JOIN NCDetails NC
ON W.CrewID = NC.CrewID
INNER JOIN Crew C
ON C.ID= W.CrewID
INNER JOIN CountryMaster CM
ON CM.CountryID = c.CountryID
INNER JOIN Ranks R
ON C.RankID = R.ID 
INNER JOIN Regimes REG
ON W.RegimeID = REG.ID
WHERE CONVERT(varchar(12),ValidOn,103) = CONVERT(varchar(12),@BookDate,103)
AND CONVERT(varchar(12),OccuredOn,103) = CONVERT(varchar(12),@BookDate,103)
AND C.VesselID=@VesselID

ORDER BY CrewID



END








