
 --  exec stpAddUsers 'DipDeb81', '123','14', true, '2057', '38', '9876543'
ALTER PROCEDURE [dbo].[stpAddUsers]

(

	@UserName varchar(200),

	@Password nvarchar(200),

	@GroupIds varchar(1000),

	@Active bit,

	@ID int,

	@CrewId int	,
	@VesselID int


)

AS

BEGIN



	BEGIN TRY

		BEGIN TRAN



		DECLARE @UserId int

		DECLARE @GroupTab TABLE

		  (

			GrpId int,

			UserId int

		  )





	    IF @ID IS NULL

		BEGIN

			INSERT INTO Users(Username,Password,Active,CrewId,VesselID) VALUES

			(@UserName,@Password,1,@CrewId,@VesselID)



			SET @UserId = @@IDENTITY



			INSERT INTO @GroupTab(GrpId,UserId) 

			SELECT String,@UserId FROM ufn_CSVToTable(@GroupIds,',')





			INSERT INTO UserGroups(UserID,GroupID,VesselID)

			SELECT UserId,GrpId,@VesselID FROM @GroupTab



		END

		ELSE

		BEGIN

			UPDATE Users SET  Password = @Password ,Active = @Active 

			WHERE ID = @ID



			DELETE FROM UserGroups WHERE UserID  = @ID 



			INSERT INTO @GroupTab(GrpId,UserId) 

			SELECT String,@ID FROM ufn_CSVToTable(@GroupIds,',')



			INSERT INTO UserGroups(UserID,GroupID,VesselID)

			SELECT UserId,GrpId,@VesselID FROM @GroupTab

		END





		COMMIT TRAN

	END TRY

	BEGIN CATCH

		ROLLBACK TRAN

	END CATCH



END

















