USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetWrokSessionsByCrewandDate]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetWrokSessionsByCrewandDate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpGetWrokSessionsByCrewandDate]
GO
/****** Object:  StoredProcedure [dbo].[stpGetWrokSessionsByCrewandDate]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetWrokSessionsByCrewandDate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[stpGetWrokSessionsByCrewandDate]

(

	@CrewId int,

	@BookDate DateTime

)

AS

BEGIN



	SELECT *,NCD.NCDetailsID FROM WorkSessions WS

	INNER JOIN NCDetails NCD

	ON WS.ID = NCD.WorkSessionId 

	WHERE WS.CrewId = @CrewId

	AND CONVERT(varchar(12),ValidOn,103) = CONVERT(varchar(12),@BookDate,103)

	ORDER BY Timestamp 



END' 
END
GO
