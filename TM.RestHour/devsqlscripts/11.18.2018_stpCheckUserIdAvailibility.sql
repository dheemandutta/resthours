-- exec stpCheckUserIdAvailibility 'JohWoo72'
CREATE PROCEDURE stpCheckUserIdAvailibility
(
	@UserId varchar(50)
)
AS
BEGIN
	SELECT count(*) from Users 
	WHERE LTRIM(RTRIM(UPPER(Username))) = LTRIM(RTRIM(UPPER(@UserId))) 
END