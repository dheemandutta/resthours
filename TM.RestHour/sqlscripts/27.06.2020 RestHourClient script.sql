USE [RestHourClient]
GO
/****** Object:  StoredProcedure [dbo].[stpSaveCrewTemperature]    Script Date: 27-Jun-20 8:09:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[stpSaveCrewTemperature]
(
	@CrewID	int,
	@Temperature	decimal,
	@Unit	varchar(5),
	@ReadingDate	varchar(50),
	@ReadingTime	varchar(5),
	@Comment		varchar(500),
	@TemperatureModeID INT
)
AS
BEGIN
	INSERT INTO CrewTemperature(CrewID, Temperature, Unit, ReadingDate, ReadingTime, Comment,TemperatureModeID) VALUES
	(@CrewID, @Temperature, @Unit, @ReadingDate, @ReadingTime,@Comment,@TemperatureModeID)
END




USE [RestHourClient]
GO
/****** Object:  StoredProcedure [dbo].[stpGetFirstRun]    Script Date: 27-Jun-20 6:20:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpGetTemperatureMode]

AS
Begin

Select ID,  Mode 
from TemperatureMode
End
