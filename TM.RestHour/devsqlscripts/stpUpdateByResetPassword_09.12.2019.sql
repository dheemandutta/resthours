-- UpdateResetPassword 'AMIT'
create PROCEDURE [dbo].[stpUpdateByResetPassword]
(
    --@ID int,
	@UserName varchar(21)
) 
AS
BEGIN

	UPDATE Users SET Password = 12345
	WHERE Username = @Username

END