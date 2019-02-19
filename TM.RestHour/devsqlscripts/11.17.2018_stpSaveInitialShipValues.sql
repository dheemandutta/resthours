
ALTER procedure [dbo].[stpSaveInitialShipValues]
(
@Vessel nvarchar(21),
@Flag varchar(50),
@IMO int,
@AdminUser varchar(50),
@AdminPassword varchar(50)

--@VesselID int
)
AS 
Begin

DECLARE @ShipCount int
SET @ShipCount = 0

SELECT  @ShipCount = COUNT(*) FROM Ship

IF @ShipCount = 0
BEGIN
Begin Try
Begin Tran
Insert into Ship ([ShipName],FlagOfShip,IMONumber)
 Values(@Vessel,@Flag,@IMO)

 Declare @SuperAdminGroupID int
 Declare @UserId int
 Set @SuperAdminGroupID = 0
 Select @SuperAdminGroupID = ID from Groups
 Where GroupName = 'Super Admin'
 Insert into Users(UserName,Password,Active,AllowDelete,CrewId,VesselID)
 Values(@AdminUser,@AdminPassword,1,1,NULL,@IMO)
 Set @UserId = @@IDENTITY
 Insert into UserGroups (UserID,GroupID,VesselID)
 Values (@UserId,@SuperAdminGroupID,@IMO)

 INSERT INTO FirstRun(RunCount)  
	Values(1) 




UPDATE GroupRank
SET VesselID=@IMO
--Where ID=@ID

UPDATE Groups
SET VesselID=@IMO

UPDATE Regimes
SET VesselID=@IMO

UPDATE Ranks
SET VesselID=@IMO

INSERT INTO tblRegime(RegimeID,RegimeStartDate,IsActiveRegime,VesselID,RegimeEndDate)
	VALUES(5,GETDATE(),1,@IMO,'12/31/9999')

UPDATE DepartmentMaster SET VesselID =  @IMO
UPDATE Ship SET Regime = 5

DECLARE @CompanyId int
SET @CompanyId = 0

IF EXISTS(SELECT COUNT(*) FROM CompanyDetails)
BEGIN
SELECT TOP 1  @CompanyId = CompanyId FROm CompanyDetails
END
 

IF @CompanyId > 0
BEGIN
	
	UPDATE Ship Set CompanyID = @CompanyId

END


Commit Tran
End Try
Begin Catch
Rollback Tran 
End Catch
END

End





