USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetLastSixDaysWorkSchedule]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetLastSixDaysWorkSchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpGetLastSixDaysWorkSchedule]
GO
/****** Object:  StoredProcedure [dbo].[stpGetLastSixDaysWorkSchedule]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetLastSixDaysWorkSchedule]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[stpGetLastSixDaysWorkSchedule]

(

	@CrewId int,

	@BookDate datetime

)

AS

BEGIN

		 

		 DECLARE @ScheduleTable TABLE

		 (

			BookDate Datetime,

			Schedule varchar(1000)

		 )

		 

		 DECLARE @RowCount int

		 DECLARE @Counter int

		 DECLARE @NegativeCounter int

		 DECLARE @ZeroSchedule nchar(48)

		 DECLARE @ChangedBookDate datetime



		 SET @ZeroSchedule = ''000000000000000000000000000000000000000000000000''

		 SET @ChangedBookDate = @BookDate 



		

		 

		 --SELECT @RowCount = COUNT(ValidOn) 

		 --FROM  WorkSessions

		 --WHERE CrewID = @CrewId

		 --AND ValidOn BETWEEN dateadd(day,-6,@BookDate) AND dateadd(day,-1,@BookDate)



		 SET @Counter=1



		 --print DATEDIFF(day,@BookDate, dateadd(day,-6 ,@BookDate))



		 SET @ChangedBookDate = dateadd(day,-1 ,@ChangedBookDate)



		 WHILE (DATEDIFF(day,@BookDate, @ChangedBookDate) >= -6)

		 BEGIN

				print DATEDIFF(day,@BookDate, @ChangedBookDate)





				SET @NegativeCounter = @Counter * -1

				IF EXISTS(SELECT 1 FROM WorkSessions WHERE CrewId = @CrewId AND ValidOn = @ChangedBookDate )

					BEGIN

							INSERT INTO @ScheduleTable(BookDate,Schedule) 

							SELECT @ChangedBookDate,Hours

							FROM WorkSessions 

							WHERE CrewID = @CrewId

							AND ValidOn = @ChangedBookDate 

					END

				ELSE

					BEGIN

							INSERT INTO @ScheduleTable(BookDate,Schedule) 

							SELECT @ChangedBookDate,@ZeroSchedule

							

					END

				SET @Counter = @Counter + 1

				SET @ChangedBookDate = dateadd(day,-1 ,@ChangedBookDate)

		 END  



		 SELECT BookDate AS [ValidOn],Schedule AS [Hours] FROM @ScheduleTable  

		 ORDER BY BookDate





 END' 
END
GO
