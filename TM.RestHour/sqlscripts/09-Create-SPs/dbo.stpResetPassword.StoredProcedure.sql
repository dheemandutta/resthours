USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpResetPassword]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpResetPassword]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpResetPassword]
GO
/****** Object:  StoredProcedure [dbo].[stpResetPassword]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpResetPassword]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[stpResetPassword]

(

	@OldPassword nvarchar(200),

	@NewPassword nvarchar(200),

	@UserName nvarchar(200)



)

AS

BEGIN



	BEGIN TRY

		BEGIN TRAN



		DECLARE @UserId int



		BEGIN

			UPDATE Users SET Password = @NewPassword 

			WHERE Username = @UserName AND Password = @OldPassword



			--DELETE FROM UserGroups WHERE UserID  = @ID 



		END



		COMMIT TRAN

	END TRY

	BEGIN CATCH

		ROLLBACK TRAN

	END CATCH



END' 
END
GO
