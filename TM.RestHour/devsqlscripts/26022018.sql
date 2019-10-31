USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpSaveWorkSessions]    Script Date: 2/26/2018 9:19:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC stpSaveWorkSessions 10100,1048,'2018-02-23 00:00:00.000','000000111111001111111111111111111111111111100000',0,'test',0,'03:00,06:00,07:00,21:30','2018-02-23 00:00:00.000','<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus>Less than 10 hrs of rest in 24 hrs period</twentyfourhourresthoursstatus><minsevendaysrest>13</minsevendaysrest><mintwentyfourhoursrest>6</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>2</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>17</totalworkedhours><overtimeHours>9</overtimeHours></ncdetails>',0,'0',0


ALTER procedure [dbo].[stpSaveWorkSessions] 
  
( 
@ID int,
@CrewID int,
@ValidOn datetime,
@Hours nchar(48),
@Increment int,
@Comment nvarchar(200),
@Deleted bit,
@ActualHours nvarchar(200),
@OccuredOn datetime,
@ComplianceInfo xml,
@TotalNCHours float,
@AdjustmentFator varchar(10),
@Day1Update bit,
@NCDetailsID int

) 

AS 
BEGIN 
DECLARE @LastMinuSOneAdjustmentDate Datetime
DECLARE @BookCount INT
DECLARE @RowCount int 
DECLARE @WrkSessionId int
SET @RowCount = 0
SET @WrkSessionId = 0

Select @RowCount = COUNT(ValidOn) FROM  WorkSessions 
WHERE  CrewID = @CrewID 
And FLOOR(CAST(ValidOn as float)) = FLOOR(CAST(@ValidOn as float))

SELECT @LastMinuSOneAdjustmentDate = MAX(CONVERT(date,AdjustmentDate,110)) FROM TimeAdjustment
WHERE AdjustmentValue = '-1D'
AND CONVERT(DATE,AdjustmentDate,110) < CONVERT(DATE,@ValidOn,110)

IF @LastMinuSOneAdjustmentDate IS NOT NULL
BEGIN
	   SELECT  @BookCount = COUNT(*) 
		FROM WorkSessions 
		WHERE CONVERT(DATE,ValidOn,110) = CONVERT(DATE,@LastMinuSOneAdjustmentDate,110)
		AND CrewID = @CrewID
END
    
 IF @RowCount = 0 
BEGIN   

							BEGIN TRY

BEGIN TRAN

INSERT INTO WorkSessions 
           (CrewID, ValidOn, [Hours], Increment, Comment, LatestUpdate, [Deleted],ActualHours,AdjustmentFator)  
Values(@CrewID, @ValidOn, @Hours, @Increment, @Comment,GETDATE(), 1,@ActualHours,@AdjustmentFator) 

SET @WrkSessionId = @@IDENTITY


INSERT INTO NCDetails(CrewID,OccuredOn,ComplianceInfo,TotalNCHours,WorkSessionId)
VALUES(@CrewID,@OccuredOn,@ComplianceInfo,@TotalNCHours,@WrkSessionId) 


COMMIT TRAN

END TRY
BEGIN CATCH
	ROLLBACK TRAN
END CATCH

END
ELSE
BEGIN

							BEGIN TRY

BEGIN TRAN
IF (@LastMinuSOneAdjustmentDate IS NOT NULL AND @Day1Update = 0 )
	BEGIN
		print 'h1'
		
		--INSERT AGAIN A NEW ROW
		IF @BookCount = 1
			BEGIN
				INSERT INTO WorkSessions 
				(CrewID, ValidOn, [Hours], Increment, Comment, LatestUpdate, [Deleted],ActualHours,AdjustmentFator)  
				Values(@CrewID, @ValidOn, @Hours, @Increment, @Comment,GETDATE(), 1,@ActualHours,@AdjustmentFator)
				
				SET @WrkSessionId = @@IDENTITY 


				INSERT INTO NCDetails(CrewID,OccuredOn,ComplianceInfo,TotalNCHours,WorkSessionId)
				VALUES(@CrewID,@OccuredOn,@ComplianceInfo,@TotalNCHours,@WrkSessionId) 

			END
	END
ELSE IF (@LastMinuSOneAdjustmentDate IS NULL AND @Day1Update = 0 ) -- FIRST DAY2 SAVE CASE
	BEGIN
		
				print 'h2'
				
				INSERT INTO WorkSessions 
				(CrewID, ValidOn, [Hours], Increment, Comment, LatestUpdate, [Deleted],ActualHours,AdjustmentFator)  
				Values(@CrewID, @ValidOn, @Hours, @Increment, @Comment,GETDATE(), 1,@ActualHours,@AdjustmentFator) 

				SET @WrkSessionId = @@IDENTITY 


				INSERT INTO NCDetails(CrewID,OccuredOn,ComplianceInfo,TotalNCHours,WorkSessionId)
				VALUES(@CrewID,@OccuredOn,@ComplianceInfo,@TotalNCHours,@WrkSessionId) 

			

	END
ELSE IF @Day1Update = 1
	BEGIN
			
			print 'h3'
			
			UPDATE WorkSessions
			SET CrewID=@CrewID, ValidOn=@ValidOn, [Hours]=@Hours, Increment=@Increment, Comment=@Comment,
				LatestUpdate=GETDATE(), Deleted=@Deleted, ActualHours=@ActualHours, AdjustmentFator=@AdjustmentFator
			WHERE ID = @ID 
			
			--CrewID = @CrewID 
			--And FLOOR(CAST(ValidOn as float)) = FLOOR(CAST(@ValidOn as float))


			UPDATE NCDetails 
			SET ComplianceInfo = @ComplianceInfo,
			  TotalNCHours = @TotalNCHours 
			  WHERE NCDetailsID = @NCDetailsID
			  
			  --CrewID  =  @CrewID 
			  --AND  FLOOR(CAST(OccuredOn as float)) = FLOOR(CAST(@OccuredOn as float))
	END




COMMIT TRAN

END TRY
BEGIN CATCH
SELECT ERROR_MESSAGE() AS ErrorMessage
ROLLBACK TRAN
END CATCH

END
END



