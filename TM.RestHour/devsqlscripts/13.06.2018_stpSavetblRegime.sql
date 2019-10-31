USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpSavetblRegime]    Script Date: 13-Jun-18 7:33:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec stpSavetblRegime '1','2018-06-01 00:00:00.000','9876543','5'

ALTER procedure [dbo].[stpSavetblRegime] 
( 
@RegimeID int,
@RegimeStartDate datetime,
--@IsActiveRegime bit,
@VesselID int,
--@RegimeEndDate datetime
@Regime int
) 
AS 
BEGIN

 BEGIN TRY
    BEGIN TRAN

	Update tblRegime
	SET IsActiveRegime = 0, RegimeEndDate = @RegimeStartDate
	Where VesselID = @VesselID

	INSERT INTO tblRegime (RegimeID,RegimeStartDate,IsActiveRegime,VesselID,RegimeEndDate)
	Values(@RegimeID,@RegimeStartDate,1,@VesselID,NULL) 

	UPDATE Ship
    SET Regime=@Regime
    Where IMONumber = @VesselID

	COMMIT TRAN
 END TRY 

 BEGIN CATCH
	ROLLBACK TRAN
	SELECT ERROR_MESSAGE() AS ErrorMessage;  
 END CATCH
END 

