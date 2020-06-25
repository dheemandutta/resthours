USE [RestHourClient]
GO
/****** Object:  StoredProcedure [dbo].[stpSaveCrewTemperature]    Script Date: 25-Jun-20 12:51:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpSaveCrewTemperature]
(
	@CrewID	int,
	@Temperature	decimal,
	@Unit	varchar(5),
	@ReadingDate	datetime,
	@ReadingTime	varchar(5),
	@Comment		varchar(500)
)
AS
BEGIN
	INSERT INTO CrewTemperature(CrewID, Temperature, Unit, ReadingDate, ReadingTime, Comment) VALUES
	(@CrewID, @Temperature, @Unit, @ReadingDate, @ReadingTime,@Comment)
END