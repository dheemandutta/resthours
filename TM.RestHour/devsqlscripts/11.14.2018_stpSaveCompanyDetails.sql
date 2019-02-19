

--exec stpSaveCompanyDetails Null,'test', 'add1','www.x.com','PP','pp@gmail.com','4545','Shipping','abcd',@x out,2

ALTER procedure [dbo].[stpSaveCompanyDetails] 
( 
@ID int,
@Name varchar(100),
@Address varchar(1000),
@Website varchar(1000),
@AdminContact varchar(1000),
@AdminContactEmail varchar(100),
@ContactNumber varchar(50),
@Domain varchar(100),
@SecureKey varchar(2000),
@CompanyId int OUTPUT,
@CId int
) 
AS 
BEGIN 

DECLARE @CompanyCount int
SET @CompanyCount = 0

SELECT @CompanyCount = COUNT(*) FROM CompanyDetails

IF @CompanyCount = 0
BEGIN
 BEGIN TRY
    BEGIN TRAN

 IF @ID IS NULL

BEGIN   
	 print 'INSERT'
	INSERT INTO CompanyDetails 
		   (Name, [Address], Website, AdminContact, AdminContactEmail, ContactNumber, Domain, SecureKey, CompanyID)
	Values(@Name, @Address, @Website, @AdminContact, @AdminContactEmail, @ContactNumber, @Domain, @SecureKey, @CId)

	DECLARE @VesselId int
	SET @VesselId = 0

	IF EXISTS (SELECT COUNT(*) FROM Ship)
	BEGIN

		SELECT TOP 1 @VesselId = ID FROM Ship

	END

	IF @VesselId > 0
	BEGIN

		UPDATE Ship SET CompanyID = @CId WHERE ID = @VesselId

	END

	SET @ID = @@IDENTITY
	SET @CompanyId  = @ID

END
ELSE
BEGIN
	print 'UPDATE'
	UPDATE CompanyDetails
	SET Name=@Name, [Address]=@Address, Website=@Website, AdminContact=@AdminContact, AdminContactEmail=@AdminContactEmail, 
		ContactNumber=@ContactNumber, Domain=@Domain, SecureKey=@SecureKey, CompanyID=@CId
	Where ID=@ID

	SET @CompanyId  = @ID

END
	COMMIT TRAN
 END TRY 

 BEGIN CATCH
	ROLLBACK TRAN
	SELECT ERROR_MESSAGE() AS ErrorMessage;  
 END CATCH
END
END
