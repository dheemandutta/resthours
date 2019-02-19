CREATE PROCEDURE stpUpdateVessel
(
	@ShipName varchar(21),
	@FlagOfShip varchar(50),
	@IMONumber int
) 
AS
BEGIN

	UPDATE Ship SET ShipName = @ShipName , FlagOfShip = @FlagOfShip WHERE IMONumber = @IMONumber

END