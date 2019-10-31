
ALTER PROCEDURE [dbo].[stpImportCrew]
(
	@WatchKeeper bit,
	@notes varchar(2000),
	@Overtime bit,
	@EmployeeNum nvarchar(25),
	@Rank nvarchar(50),
	@FirstName varchar(100),
	@MiddleName varchar(100),
	@LastName varchar(50),
	@DOB datetime,
	@POB nvarchar(20),
	@PassportBook nvarchar(20),
	@Seaman nvarchar(20),
	@Country varchar(20),
	@VesselId int
)
AS
BEGIN

DECLARE @RecCnt int
SET @RecCnt = 0 

SELECT @RecCnt = COUNT(*) FROM Crew 
WHERE LTRIM(RTRIM(UPPER(FirstName))) = LTRIM(RTRIM(UPPER(@FirstName)))
AND LTRIM(RTRIM(UPPER(LastName))) = LTRIM(RTRIM(UPPER(@LastName)))
AND CONVERT(VARCHAR(10),DOB,102) = CONVERT(VARCHAR(10),@DOB,102)
AND  LTRIM(RTRIM(UPPER(PassportSeamanPassportBook))) = LTRIM(RTRIM(UPPER(@PassportBook))) 
--AND LTRIM(RTRIM(UPPER(Seaman))) = LTRIM(RTRIM(UPPER(@Seaman))) 




IF @RecCnt = 0
BEGIN
BEGIN TRY
	BEGIN TRAN

   DECLARE @RankId int
   DECLARE @RankOrder int
   DECLARE @MAXCREWVAL int
   DECLARE @YearValue varchar(4)
   SET @RankId = 0
   SET @RankOrder = 0


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

   SELECT @RankId FROM Ranks WHERE RTRIM(LTRIM(UPPER(RankName))) = RTRIM(LTRIM(UPPER(@Rank)))
   SELECT @RankOrder = MAX([Order]) FROM Ranks 

   SET @RankOrder = @RankOrder + 1

   IF @RankId <= 0 OR @RankId IS NULL
   BEGIN

    INSERT INTO Ranks(RankName,[Order],Deleted,LatestUpdate,VesselID) VALUES (@Rank,@RankOrder,0,getdate(),@VesselId)
	SET @RankId = @@IDENTITY

	INSERT INTO GroupRank(GroupID,RankID,VesselID)
	VALUES (15,@RankId,@VesselId)

   END


   DECLARE @CountryID int
   SET @CountryID = 0 

   SELECT @CountryID = CountryID FROM CountryMaster WHERE LTRIM(RTRIM(UPPER(CountryName))) = LTRIM(RTRIM(UPPER(@Country)))

   IF @CountryID <=0 OR @CountryID IS NULL
   BEGIN

   INSERT INTO CountryMaster(CountryName,CountryCode) VALUES (@Country,'ZZZ')
   SET @CountryID = @@IDENTITY
   END


   INSERT INTO Crew(Watchkeeper,Notes,Deleted,LatestUpdate,CreatedOn,OvertimeEnabled,EmployeeNumber,RankID,FirstName,MiddleName,LastName,DOB,POB,PassportSeamanPassportBook,Seaman,IsActive,VesselID,CountryID,DeactivationDate,DeletionDate)
   VALUES(@WatchKeeper,@notes,0,getdate(),getdate(),@Overtime,@EmployeeNum,@RankId,@FirstName,@MiddleName,@LastName,@DOB,@POB,@PassportBook,@Seaman,1,@VesselId,@CountryID,'9999-12-31 00:00:00.000','9999-12-31 00:00:00.000')

   COMMIT TRAN

END TRY
BEGIN CATCH
	ROLLBACK TRAN
END CATCH
END
END

