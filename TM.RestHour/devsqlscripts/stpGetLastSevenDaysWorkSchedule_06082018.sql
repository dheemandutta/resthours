USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetLastSevenDaysWorkSchedule]    Script Date: 6/8/2018 12:10:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[stpGetLastSevenDaysWorkSchedule]

(

	@CrewId int,

	@BookDate datetime,
	@VesselID int 

)

AS

BEGIN

		 

		 DECLARE @ScheduleTable TABLE

		 (

			BookDate Datetime,

			Schedule varchar(1000),
			VesselID int

		 )

		 

		 DECLARE @RowCount int

		 DECLARE @Counter int

		 DECLARE @NegativeCounter int

		 DECLARE @ZeroSchedule nchar(48)
		 DECLARE @NullSchedule nchar(48)

		 DECLARE @ChangedBookDate datetime



		 SET @ZeroSchedule = '000000000000000000000000000000000000000000000000'
		 SET @NullSchedule = '999999999999999999999999999999999999999999999999'
		 SET @ChangedBookDate = @BookDate 



		

		 

		 --SELECT @RowCount = COUNT(ValidOn) 

		 --FROM  WorkSessions

		 --WHERE CrewID = @CrewId

		 --AND ValidOn BETWEEN dateadd(day,-6,@BookDate) AND dateadd(day,-1,@BookDate)



		--SET @Counter=1



		 --print DATEDIFF(day,@BookDate, dateadd(day,-6 ,@BookDate))



		 SET @ChangedBookDate = dateadd(day,-1 ,@ChangedBookDate)

		 print @ChangedBookDate

		 WHILE (DATEDIFF(day,@BookDate, @ChangedBookDate) >= -7)


		 BEGIN

				print DATEDIFF(day,@BookDate, @ChangedBookDate)





				--SET @NegativeCounter = @Counter * -1

				IF EXISTS(SELECT 1 FROM WorkSessions WHERE CrewId = @CrewId AND ValidOn = @ChangedBookDate AND VesselID = @VesselID )


					BEGIN

							INSERT INTO @ScheduleTable(BookDate,Schedule,VesselID) 

							SELECT @ChangedBookDate,Hours,VesselID

							FROM WorkSessions 

							WHERE CrewID = @CrewId
							AND VesselID = @VesselID

							AND ValidOn = @ChangedBookDate 

					END

				ELSE

					BEGIN

							INSERT INTO @ScheduleTable(BookDate,Schedule,VesselID) 

							SELECT @ChangedBookDate,@NullSchedule,@VesselID

							

					END

				--SET @Counter = @Counter + 1

				SET @ChangedBookDate = dateadd(day,-1 ,@ChangedBookDate)

				print @ChangedBookDate

		 END  

		  

		 SELECT TOP 7 BookDate AS [ValidOn],Schedule AS [Hours] FROM @ScheduleTable  
		 Where VesselID = @VesselID
		 ORDER BY BookDate desc



 END






