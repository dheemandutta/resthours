USE [RestHourDemo]
GO
/****** Object:  StoredProcedure [dbo].[stpSaveCrew]    Script Date: 11/17/2018 8:02:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- DECLARE @NewCrewId int    exec stpSaveCrew NULL, trt, ggh, gfgf, 1052, 1, '2018-06-01 00:00:00.000', India, ghjhj, juhjh, '2018-06-14 00:00:00.000', '2018-06-14 00:00:00.000', gfgfg, 0,1,@NewCrewId OUTPUT ,9876543,5
ALTER procedure [dbo].[stpSaveCrew] 
( 
@ID int,
@FirstName nvarchar(100),
@MiddleName nvarchar(100),
@LastName nvarchar(50),
@Gender varchar(30),
@RankID int,
@CountryID int,

@DOB datetime,
@POB nvarchar(20),
--@CrewIdentity nvarchar(20),
@PassportSeamanPassportBook nvarchar(20),
@Seaman nvarchar(20),
@CreatedOn datetime,
@ActiveTo datetime,
---@PayNum nvarchar(25),
--@EmployeeNumber nvarchar(25),
@Notes ntext,
@Watchkeeper bit,
@OvertimeEnabled bit,
@NewCrewId int OUTPUT,
@VesselID int,
@DepartmentMasterID int
) 
AS 
BEGIN 
 IF @ID IS NULL
BEGIN   
BEGIN TRY  
BEGIN TRAN
DECLARE @YearValue varchar(4)
DECLARE @MAXCREWVAL int
DECLARE @EmployeeNum varchar(25)
SET @YearValue = ''
SELECT @YearValue = YEAR(GETDATE()) 
SELECT @MAXCREWVAL =  COUNT(*) FROM Crew
IF @MAXCREWVAL = 0
BEGIN
	SET @MAXCREWVAL = 1
END
ELSE
BEGIN
	SET @MAXCREWVAL = @MAXCREWVAL + 1
END
SET @EmployeeNum = CAST(@MAXCREWVAL AS VARCHAR(4)) + '/' + CAST(@YearValue AS VARCHAR(4))
INSERT INTO Crew 
           (FirstName,MiddleName,LastName,Gender,RankID,CreatedOn,LatestUpdate,CountryID,DOB,POB,PassportSeamanPassportBook,Seaman,Notes,Watchkeeper,OvertimeEnabled,EmployeeNumber,VesselID,DepartmentMasterID,DeactivationDate,DeletionDate)  
Values(@FirstName,@MiddleName,@LastName,@Gender,@RankID,@CreatedOn,@ActiveTo,@CountryID,@DOB,@POB,@PassportSeamanPassportBook,@Seaman,@Notes,@Watchkeeper,@OvertimeEnabled,@EmployeeNum,@VesselID,@DepartmentMasterID,'12/31/9999','12/31/9999') 
DECLARE @CrewId int
SET @CrewId = @@IDENTITY
SET @NewCrewId = @@IDENTITY
--UPDATE Crew
--SET EmployeeNumber = @CrewId + '/' + @YearValue
--WHERE ID = @CrewId
INSERT INTO ServiceTerms(ActiveFrom,ActiveTo,CrewID,RankID,Deleted,VesselID) VALUES
(@CreatedOn,@ActiveTo,@CrewId,@RankID,0,@VesselID)
COMMIT TRAN
END TRY
BEGIN CATCH
	print Error_Message()
	ROLLBACK TRAN 
END CATCH
END
ELSE
BEGIN
BEGIN TRY  
BEGIN TRAN
UPDATE Crew
    SET FirstName=@FirstName,MiddleName=@MiddleName,LastName=@LastName,Gender=@Gender,RankID=@RankID,CreatedOn=@CreatedOn,LatestUpdate=@ActiveTo,
    --PayNum=@PayNum,
	CountryID=@CountryID,
    Notes=@Notes,Watchkeeper=@Watchkeeper,OvertimeEnabled=@OvertimeEnabled,
	PassportSeamanPassportBook=@PassportSeamanPassportBook,Seaman=@Seaman,DOB=@DOB,DepartmentMasterID=@DepartmentMasterID
	WHERE ID=@ID

	declare @SeviceCount int
	set @SeviceCount = 0
	SELECT @SeviceCount = COUNT(*) FROM ServiceTerms WHERE CrewID = @ID 
	IF @SeviceCount > 0
	BEGIN
		UPDATE ServiceTerms SET ActiveFrom = @CreatedOn,ActiveTo = @ActiveTo 
		WHERE CrewId = @ID
	END
	ELSE
	BEGIN
		INSERT INTO ServiceTerms(ActiveFrom,ActiveTo,CrewID,RankID,Deleted,VesselID) VALUES
		(@CreatedOn,@ActiveTo,@ID,@RankID,0,@VesselID)
	END
	SET @NewCrewId = @ID
  COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRAN 
END CATCH
END
END







