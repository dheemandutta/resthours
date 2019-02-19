USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpSaveCrew]    Script Date: 4/27/2018 9:51:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[stpSaveCrew] 
  
( 
@ID int,
@FirstName nvarchar(100),
@MiddleName nvarchar(100),
@LastName nvarchar(50),
@RankID int,

@Nationality nvarchar(20),
@DOB datetime,
@POB nvarchar(20),
@CrewIdentity nvarchar(20),
@PassportSeamanPassportBook nvarchar(20),
@Seaman nvarchar(20),

@CreatedOn datetime,
@ActiveTo datetime,
@PayNum nvarchar(25),
--@EmployeeNumber nvarchar(25),
@Notes ntext,
@Watchkeeper bit,
@OvertimeEnabled bit
) 

AS 
BEGIN 
    
 IF @ID IS NULL
BEGIN   

BEGIN TRY  

BEGIN TRAN

DECLARE @YearValue varchar(4)
SET @YearValue = ''

SELECT @YearValue = YEAR(GETDATE()) 

INSERT INTO Crew 
           (FirstName,MiddleName,LastName,RankID,CreatedOn,LatestUpdate,Nationality,DOB,POB,CrewIdentity,PassportSeamanPassportBook,Seaman,PayNum,Notes,Watchkeeper,OvertimeEnabled)  
Values(@FirstName,@MiddleName,@LastName,@RankID,@CreatedOn,@ActiveTo,@Nationality,@DOB,@POB,@CrewIdentity,@PassportSeamanPassportBook,@Seaman,@PayNum,@Notes,@Watchkeeper,@OvertimeEnabled) 

DECLARE @CrewId int
SET @CrewId = @@IDENTITY

UPDATE Crew
SET EmployeeNumber = @CrewId + '/' + @YearValue
WHERE ID = @CrewId

INSERT INTO ServiceTerms(ActiveFrom,ActiveTo,CrewID,RankID,Deleted) VALUES
(@CreatedOn,@ActiveTo,@CrewId,@RankID,0)


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

UPDATE Crew
    SET FirstName=@FirstName,MiddleName=@MiddleName,LastName=@LastName,RankID=@RankID,CreatedOn=@CreatedOn,LatestUpdate=@ActiveTo,
    PayNum=@PayNum,
    Notes=@Notes,Watchkeeper=@Watchkeeper,OvertimeEnabled=@OvertimeEnabled,
	CrewIdentity=@CrewIdentity,PassportSeamanPassportBook=@PassportSeamanPassportBook,Seaman=@Seaman,DOB=@DOB
	WHERE ID=@ID

	UPDATE ServiceTerms SET ActiveFrom = @CreatedOn,ActiveTo = @ActiveTo 
	WHERE CrewId = @ID
	
  COMMIT TRAN

END TRY
BEGIN CATCH

	ROLLBACK TRAN 
END CATCH
   

END
END







