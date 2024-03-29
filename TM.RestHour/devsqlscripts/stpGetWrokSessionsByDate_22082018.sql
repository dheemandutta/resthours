USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetWrokSessionsByDate]    Script Date: 8/22/2018 4:38:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec stpGetWrokSessionsByDate 7,2018,9876543

ALTER PROCEDURE [dbo].[stpGetWrokSessionsByDate]

(

	@Month int,

	@Year int,
	@VesselID int

)

AS

BEGIN



	DECLARE @SelectedDay DateTime



	SET @SelectedDay =  datefromparts(@Year, @Month, 1)

	



	SELECT *,NCD.NCDetailsID,C.FirstName + ' ' + C.LastName AS CrewName, WS.VesselID,RegimeName,

	 CASE 

	   WHEN DAY(ValidOn) < 10 THEN '0' + DAY(ValidOn)

	   ELSE DAY(ValidOn)

	END As DateNumber FROM WorkSessions WS

	INNER JOIN NCDetails NCD

	ON WS.ID = NCD.WorkSessionId 

	INNER JOIN Crew C

	ON C.ID = NCD.CrewID

	INNER JOIN Regimes REG

	ON REG.ID = WS.RegimeID

	WHERE MONTH(@SelectedDay) = MONTH(ValidOn)

	AND YEAR(@SelectedDay) =  YEAR(ValidOn)
	AND WS.VesselID=@VesselID
	ORDER BY NCD.CrewID,WS.Timestamp DESC



END










