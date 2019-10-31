--exec stpGetLastSevenDaysWorkScheduleForComplianceCheck 4,'11/07/2018',9876543,7

CREATE PROCEDURE [dbo].[stpGetLastSevenDaysWorkScheduleForComplianceCheck]

(

	@CrewId int,
	@BookDate datetime,
	@VesselID int,
	@NumDays int 

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
		

		IF @NumDays = 7
		BEGIN

		 --SET @ChangedBookDate = dateadd(day,-1 ,@ChangedBookDate)

		 print @ChangedBookDate

		 WHILE (DATEDIFF(day,@BookDate, @ChangedBookDate) >= -6)
		 BEGIN

				--print DATEDIFF(day,@BookDate, @ChangedBookDate)

				--SET @NegativeCounter = @Counter * -1

				IF EXISTS(SELECT 1 FROM WorkSessions WHERE CrewId = @CrewId 
						  AND ValidOn = @ChangedBookDate AND VesselID = @VesselID )
					BEGIN
							
							
									INSERT INTO @ScheduleTable(BookDate,Schedule,VesselID) 
									SELECT @ChangedBookDate,Hours,VesselID
									FROM WorkSessions 
									WHERE CrewID = @CrewId
									AND VesselID = @VesselID
									AND ValidOn = @ChangedBookDate 
							
							
							        print @ChangedBookDate
									SET @isFilled = 1

					END

					ELSE 

					BEGIN

							INSERT INTO @ScheduleTable(BookDate,Schedule,VesselID) 
							SELECT @ChangedBookDate,@ZeroSchedule,@VesselID


							print @ChangedBookDate
							SET @isFilled = 0

					END
					

				--select *,'op' from @ScheduleTable

				SET @ChangedBookDate = dateadd(day,-1 ,@ChangedBookDate)
				--print @ChangedBookDate

		 END  

		 
		 SELECT TOP 7 CONVERT(date,BookDate,110) AS [ValidOn],Schedule AS [Hours] FROM @ScheduleTable  
		 Where VesselID = @VesselID
		 ORDER BY BookDate ASC

		END -- main if
		ELSE
		BEGIN

				SET @ChangedBookDate = dateadd(day,-6 ,@ChangedBookDate)
				print @ChangedBookDate

		 WHILE (DATEDIFF(day,@ChangedBookDate,@BookDate) > -1)
		 BEGIN

				--print DATEDIFF(day,@BookDate, @ChangedBookDate)

				--SET @NegativeCounter = @Counter * -1

				IF EXISTS(SELECT 1 FROM WorkSessions WHERE CrewId = @CrewId 
						  AND ValidOn = @ChangedBookDate AND VesselID = @VesselID )
					BEGIN
							
							
									INSERT INTO @ScheduleTable(BookDate,Schedule,VesselID) 
									SELECT @ChangedBookDate,Hours,VesselID
									FROM WorkSessions 
									WHERE CrewID = @CrewId
									AND VesselID = @VesselID
									AND ValidOn = @ChangedBookDate 
							
							
							        print @ChangedBookDate
									SET @isFilled = 1

					END

					ELSE 

					BEGIN

								INSERT INTO @ScheduleTable(BookDate,Schedule,VesselID) 
								SELECT @ChangedBookDate,@ZeroSchedule,@VesselID


								print @ChangedBookDate
								SET @isFilled = 0

					END
					

				--select *,'op' from @ScheduleTable

				SET @ChangedBookDate = dateadd(day,1 ,@ChangedBookDate)
				--print @ChangedBookDate

		 END  

		 
		 SELECT TOP 6 CONVERT(date,BookDate,110) AS [ValidOn],Schedule AS [Hours] FROM @ScheduleTable  
		 Where VesselID = @VesselID
		 ORDER BY BookDate ASC



		END -- main else

 END
















