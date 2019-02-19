--CompanyDetails
--Ship
--FirstRun

CREATE PROCEDURE stpValidateFirstRun
(
	@Msg varchar(100) OUTPUT
)
AS
BEGIN

	DECLARE @isFirstUser Bit
	DECLARE @CompanyCount int
	DECLARE @ShipCount int

	SET @isFirstUser = 1
	SET @CompanyCount = 0
	SET @ShipCount = 0

	SELECT @CompanyCount =  COUNT(*) FROM CompanyDetails

	if @CompanyCount = 1
	BEGIN
		SET @isFirstUser = 0
		SET @Msg = 'Cannot Set Multiple Values For Company Or Ship'
	END

	SELECT @ShipCount = COUNT(*) FROM Ship
			
	IF @ShipCount = 1
	BEGIN

		SET @isFirstUser = 0
		SET @Msg = 'Cannot Set Multiple Values For Company Or Ship'	

	END



END