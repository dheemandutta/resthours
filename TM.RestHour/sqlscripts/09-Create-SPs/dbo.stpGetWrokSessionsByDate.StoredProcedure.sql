USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetWrokSessionsByDate]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetWrokSessionsByDate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpGetWrokSessionsByDate]
GO
/****** Object:  StoredProcedure [dbo].[stpGetWrokSessionsByDate]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetWrokSessionsByDate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- exec stpGetWrokSessionsByDate 2,2018

CREATE PROCEDURE [dbo].[stpGetWrokSessionsByDate]

(

	@Month int,

	@Year int

)

AS

BEGIN



	DECLARE @SelectedDay DateTime



	SET @SelectedDay =  datefromparts(@Year, @Month, 1)

	



	SELECT *,NCD.NCDetailsID,C.FirstName + '' '' + C.LastName AS CrewName,

	 CASE 

	   WHEN DAY(ValidOn) < 10 THEN ''0'' + DAY(ValidOn)

	   ELSE DAY(ValidOn)

	END As DateNumber FROM WorkSessions WS

	INNER JOIN NCDetails NCD

	ON WS.ID = NCD.WorkSessionId 

	INNER JOIN Crew C

	ON C.ID = NCD.CrewID

	WHERE MONTH(@SelectedDay) = MONTH(ValidOn)

	AND YEAR(@SelectedDay) =  YEAR(ValidOn)

	ORDER BY NCD.CrewID,WS.Timestamp DESC



END' 
END
GO
