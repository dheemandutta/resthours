USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetWrokSessionsByCrewandDate]    Script Date: 11/4/2018 9:18:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[stpGetWrokSessionsByCrewandDate]

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
	ORDER BY Timestamp 



END












