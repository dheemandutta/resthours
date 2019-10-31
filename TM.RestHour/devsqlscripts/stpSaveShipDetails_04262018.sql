USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpSaveShipDetails]    Script Date: 4/26/2018 9:18:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[stpSaveShipDetails] 
  
( 
@ID int,
@ShipName nvarchar(21),
@IMONumber nvarchar(8),
@FlagOfShip nvarchar(50)
--@Regime nvarchar(50)
) 

AS 
BEGIN 
    
 IF @ID IS NULL
BEGIN   
  
IF NOT EXISTS(SELECT COUNT(*) FROM Ship)
BEGIN
	INSERT INTO Ship 
			   (ShipName,IMONumber,FlagOfShip)  
	Values(@ShipName,@IMONumber,@FlagOfShip) 
END 
 
END
ELSE
BEGIN

UPDATE Ship
SET ShipName=@ShipName,IMONumber=@IMONumber,FlagOfShip=@FlagOfShip--,Regime=@Regime
Where ID=@ID

END
END






