USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpSaveShipDetails]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpSaveShipDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpSaveShipDetails]
GO
/****** Object:  StoredProcedure [dbo].[stpSaveShipDetails]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpSaveShipDetails]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[stpSaveShipDetails] 

  

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

END' 
END
GO
