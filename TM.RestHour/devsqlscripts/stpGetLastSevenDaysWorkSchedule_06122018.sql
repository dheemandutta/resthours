USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetLastSevenDaysWorkSchedule]    Script Date: 6/12/2018 10:17:20 PM ******/
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
		 DECLARE @isFilled bit
		 DECLARE @ChangedBookDate datetime
		 DECLARE @ScheduleRow  nchar(48)
		 DECLARE @TobeDeletedBookDate datetime
		 

		 SET @ZeroSchedule = '000000000000000000000000000000000000000000000000'
		 SET @NullSchedule = '999999999999999999999999999999999999999999999999'
		 SET @ChangedBookDate = @BookDate 
		 SET @isFilled = 0
		

		


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
							
							

							SET @isFilled = 1

					END

					--ELSE IF (@isFilled = 1)

					--BEGIN

					--		INSERT INTO @ScheduleTable(BookDate,Schedule,VesselID) 
					--		SELECT @ChangedBookDate,@NullSchedule,@VesselID

					--		SET @isFilled = 0

					--END
					

				--select *,'op' from @ScheduleTable

				SET @ChangedBookDate = dateadd(day,-1 ,@ChangedBookDate)
				print @ChangedBookDate

		 END  

		  
		  --check last row for null
		  --SELECT  TOP 1 @ScheduleRow = Schedule , @TobeDeletedBookDate = BookDate 
		  --FROM @ScheduleTable 
		  --ORDER BY BookDate asc

		 

		  ----delete if it exists
		  --IF (CHARINDEX('9', @ScheduleRow) > 0)
		  --BEGIN
				--DELETE FROM @ScheduleTable
				--WHERE BookDate = @TobeDeletedBookDate
		  --END  CONVERT(date,AdjustmentDate,110)


		 SELECT TOP 7 CONVERT(date,BookDate,110) AS [ValidOn],Schedule AS [Hours] FROM @ScheduleTable  
		 Where VesselID = @VesselID
		 ORDER BY BookDate DESC



 END






