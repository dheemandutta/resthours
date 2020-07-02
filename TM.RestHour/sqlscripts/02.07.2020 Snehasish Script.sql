USE [RestHourClient]
GO
/****** Object:  StoredProcedure [dbo].[stpSaveCrewTemperature]    Script Date: 02-Jul-20 9:27:26 PM ******/
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
	@TemperatureModeID INT,
	@VesselID int
)
AS
BEGIN
	INSERT INTO CrewTemperature(CrewID, Temperature, Unit, ReadingDate, ReadingTime, Comment,TemperatureModeID,VesselID) VALUES
	(@CrewID, @Temperature, @Unit, @ReadingDate, @ReadingTime,@Comment,@TemperatureModeID,@VesselID)
END
