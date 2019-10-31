

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
@NCDetailsID int,
@isNonCompliant bit,
@VesselID int,
@RegimeID int

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
--And FLOOR(CAST(ValidOn as float)) = FLOOR(CAST(@ValidOn as float))
AND CONVERT(VARCHAR(10),ValidOn,102) = CONVERT(VARCHAR(10),@ValidOn,102)



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


			INSERT INTO WorkSessions(CrewID, ValidOn, [Hours], Increment, Comment, LatestUpdate, [Deleted],ActualHours,AdjustmentFator,VesselID,RegimeID)  
			Values(@CrewID, @ValidOn, @Hours, @Increment, @Comment,GETDATE(), 1,@ActualHours,@AdjustmentFator,@VesselID,@RegimeID) 


			SET @WrkSessionId = @@IDENTITY

			INSERT INTO NCDetails(CrewID,OccuredOn,ComplianceInfo,TotalNCHours,WorkSessionId,isNC,VesselID)
			VALUES(@CrewID,@OccuredOn,@ComplianceInfo,@TotalNCHours,@WrkSessionId,@isNonCompliant,@VesselID) 





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
						--INSERT AGAIN A NEW ROW
						IF @BookCount = 1
							BEGIN

								INSERT INTO WorkSessions(CrewID, ValidOn, [Hours], Increment, Comment, LatestUpdate, [Deleted],ActualHours,AdjustmentFator,VesselID,RegimeID)  
								Values(@CrewID, @ValidOn, @Hours, @Increment, @Comment,GETDATE(), 1,@ActualHours,@AdjustmentFator,@VesselID,@RegimeID)


								SET @WrkSessionId = @@IDENTITY 


								INSERT INTO NCDetails(CrewID,OccuredOn,ComplianceInfo,TotalNCHours,WorkSessionId,VesselID,isNC)
								VALUES(@CrewID,@OccuredOn,@ComplianceInfo,@TotalNCHours,@WrkSessionId,@VesselID,@isNonCompliant) 

							END

				END 
				ELSE IF (@LastMinuSOneAdjustmentDate IS NULL AND @Day1Update = 0 ) -- FIRST DAY2 SAVE CASE
				BEGIN

						INSERT INTO WorkSessions(CrewID, ValidOn, [Hours], Increment, Comment, LatestUpdate, [Deleted],ActualHours,AdjustmentFator,VesselID,RegimeID)  
						Values(@CrewID, @ValidOn, @Hours, @Increment, @Comment,GETDATE(), 1,@ActualHours,@AdjustmentFator,@VesselID,@RegimeID) 

						SET @WrkSessionId = @@IDENTITY 

						INSERT INTO NCDetails(CrewID,OccuredOn,ComplianceInfo,TotalNCHours,WorkSessionId,VesselID,isNC)
						VALUES(@CrewID,@OccuredOn,@ComplianceInfo,@TotalNCHours,@WrkSessionId,@VesselID,@isNonCompliant) 

				END
				ELSE IF @Day1Update = 1
				BEGIN

						UPDATE WorkSessions	SET CrewID=@CrewID,
										    ValidOn=@ValidOn,
											[Hours]=@Hours,
											Increment=@Increment,
											Comment=@Comment,
											LatestUpdate=GETDATE(),
											Deleted=@Deleted,
											ActualHours=@ActualHours,
											AdjustmentFator=@AdjustmentFator,
											RegimeID=@RegimeID
											WHERE ID = @ID 



						UPDATE NCDetails SET ComplianceInfo = @ComplianceInfo,
										 TotalNCHours = @TotalNCHours,
										 isNC = @isNonCompliant 
										 WHERE NCDetailsID = @NCDetailsID



				END


COMMIT TRAN
END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE() AS ErrorMessage
	ROLLBACK TRAN
END CATCH



END

END


















