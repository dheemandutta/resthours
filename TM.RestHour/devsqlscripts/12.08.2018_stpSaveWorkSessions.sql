USE [RestHourDemo]
GO
/****** Object:  StoredProcedure [dbo].[stpSaveWorkSessions]    Script Date: 12/8/2018 3:40:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


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
@RegimeID int,
@WorkSessionId int OUTPUT,
@NewNCDetailsId int OUTPUT,
@IsTechnicalNC bit,
@Is24HoursCompliant bit,
@IsSevenDaysCompliant bit,
@PaintOrange bit

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
AND MONTH(ValidON) = MONTH(@ValidOn)
AND DAY(ValidON) = DAY(@ValidOn)
AND YEAR(ValidOn) = YEAR(@ValidOn)
--And FLOOR(CAST(ValidOn as float)) = FLOOR(CAST(@ValidOn as float))
--AND CONVERT(VARCHAR(10),ValidOn,102) = CONVERT(VARCHAR(10),@ValidOn,102)



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
			SET @WorkSessionId = @WrkSessionId

			INSERT INTO NCDetails(CrewID,OccuredOn,ComplianceInfo,TotalNCHours,WorkSessionId,isNC,VesselID,isTNC,isSevenDaysCompliant,is24HoursCompliant,PaintOrange)
			VALUES(@CrewID,@OccuredOn,@ComplianceInfo,@TotalNCHours,@WrkSessionId,@isNonCompliant,@VesselID,@IsTechnicalNC,@IsSevenDaysCompliant,@Is24HoursCompliant,@PaintOrange) 

			SET @NewNCDetailsId = @@IDENTITY


			


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


								INSERT INTO NCDetails(CrewID,OccuredOn,ComplianceInfo,TotalNCHours,WorkSessionId,VesselID,isNC,isTNC,isSevenDaysCompliant,is24HoursCompliant,PaintOrange)
								VALUES(@CrewID,@OccuredOn,@ComplianceInfo,@TotalNCHours,@WrkSessionId,@VesselID,@isNonCompliant,@IsTechnicalNC,@IsSevenDaysCompliant,@Is24HoursCompliant,@PaintOrange) 

								SET @NewNCDetailsId = @@IDENTITY
							END

				END 
				ELSE IF (@LastMinuSOneAdjustmentDate IS NULL AND @Day1Update = 0 ) -- FIRST DAY2 SAVE CASE
				BEGIN

						INSERT INTO WorkSessions(CrewID, ValidOn, [Hours], Increment, Comment, LatestUpdate, [Deleted],ActualHours,AdjustmentFator,VesselID,RegimeID)  
						Values(@CrewID, @ValidOn, @Hours, @Increment, @Comment,GETDATE(), 1,@ActualHours,@AdjustmentFator,@VesselID,@RegimeID) 

						SET @WrkSessionId = @@IDENTITY 

						INSERT INTO NCDetails(CrewID,OccuredOn,ComplianceInfo,TotalNCHours,WorkSessionId,VesselID,isNC,isTNC,isSevenDaysCompliant,is24HoursCompliant,PaintOrange)
						VALUES(@CrewID,@OccuredOn,@ComplianceInfo,@TotalNCHours,@WrkSessionId,@VesselID,@isNonCompliant,@IsTechnicalNC,@IsSevenDaysCompliant,@Is24HoursCompliant,@PaintOrange) 

						SET @NewNCDetailsId = @@IDENTITY
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

						SET @WrkSessionId = @ID

						UPDATE NCDetails SET ComplianceInfo = @ComplianceInfo,
										 TotalNCHours = @TotalNCHours,
										 isNC = @isNonCompliant,
										 isTNC = @IsTechnicalNC,
										 isSevenDaysCompliant = @IsSevenDaysCompliant,
										 is24HoursCompliant = @Is24HoursCompliant,
										 PaintOrange = @PaintOrange 
										 WHERE NCDetailsID = @NCDetailsID

						SET @NewNCDetailsId = @NCDetailsID

				END

				SET @WorkSessionId = @WrkSessionId

COMMIT TRAN



END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE() AS ErrorMessage
	ROLLBACK TRAN
END CATCH



END

END


















