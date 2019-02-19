USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpSaveCrew]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpSaveCrew]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpSaveCrew]
GO
/****** Object:  StoredProcedure [dbo].[stpSaveCrew]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpSaveCrew]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE procedure [dbo].[stpSaveCrew] 

  

( 

@ID int,

@FirstName nvarchar(100),

@MiddleName nvarchar(100),

@LastName nvarchar(50),

@RankID int,



@Nationality nvarchar(20),

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

@NewCrewId int OUTPUT

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

SET @YearValue = ''''



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



SET @EmployeeNum = CAST(@MAXCREWVAL AS VARCHAR(4)) + ''/'' + CAST(@YearValue AS VARCHAR(4))



INSERT INTO Crew 

           (FirstName,MiddleName,LastName,RankID,CreatedOn,LatestUpdate,Nationality,DOB,POB,PassportSeamanPassportBook,Seaman,Notes,Watchkeeper,OvertimeEnabled,EmployeeNumber)  

Values(@FirstName,@MiddleName,@LastName,@RankID,@CreatedOn,@ActiveTo,@Nationality,@DOB,@POB,@PassportSeamanPassportBook,@Seaman,@Notes,@Watchkeeper,@OvertimeEnabled,@EmployeeNum) 



DECLARE @CrewId int

SET @CrewId = @@IDENTITY



SET @NewCrewId = @@IDENTITY



--UPDATE Crew

--SET EmployeeNumber = @CrewId + ''/'' + @YearValue

--WHERE ID = @CrewId



INSERT INTO ServiceTerms(ActiveFrom,ActiveTo,CrewID,RankID,Deleted) VALUES

(@CreatedOn,@ActiveTo,@CrewId,@RankID,0)





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

    SET FirstName=@FirstName,MiddleName=@MiddleName,LastName=@LastName,RankID=@RankID,CreatedOn=@CreatedOn,LatestUpdate=@ActiveTo,

    --PayNum=@PayNum,

    Notes=@Notes,Watchkeeper=@Watchkeeper,OvertimeEnabled=@OvertimeEnabled,

	PassportSeamanPassportBook=@PassportSeamanPassportBook,Seaman=@Seaman,DOB=@DOB

	WHERE ID=@ID



	UPDATE ServiceTerms SET ActiveFrom = @CreatedOn,ActiveTo = @ActiveTo 

	WHERE CrewId = @ID



	SET @NewCrewId = @ID

	

  COMMIT TRAN



END TRY

BEGIN CATCH



	ROLLBACK TRAN 

END CATCH

   



END

END' 
END
GO
