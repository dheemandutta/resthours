USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpAddUsers]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpAddUsers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpAddUsers]
GO
/****** Object:  StoredProcedure [dbo].[stpAddUsers]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpAddUsers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[stpAddUsers]

(

	@UserName varchar(200),

	@Password nvarchar(200),

	@GroupIds varchar(1000),

	@Active bit,

	@ID int,

	@CrewId int	



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

			INSERT INTO Users(Username,Password,Active,CrewId) VALUES

			(@UserName,@Password,1,@CrewId)



			SET @UserId = @@IDENTITY



			INSERT INTO @GroupTab(GrpId,UserId) 

			SELECT String,@UserId FROM ufn_CSVToTable(@GroupIds,'','')





			INSERT INTO UserGroups(UserID,GroupID)

			SELECT UserId,GrpId FROM @GroupTab



		END

		ELSE

		BEGIN

			UPDATE Users SET Username = @UserName , Password = @Password ,Active = @Active 

			WHERE ID = @ID



			DELETE FROM UserGroups WHERE UserID  = @ID 



			INSERT INTO @GroupTab(GrpId,UserId) 

			SELECT String,@ID FROM ufn_CSVToTable(@GroupIds,'','')



			INSERT INTO UserGroups(UserID,GroupID)

			SELECT UserId,GrpId FROM @GroupTab

		END





		COMMIT TRAN

	END TRY

	BEGIN CATCH

		ROLLBACK TRAN

	END CATCH



END' 
END
GO
