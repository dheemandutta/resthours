USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetShipDetailsByID]    Script Date: 29-May-18 8:36:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[stpGetShipDetailsByID]

(

	@ID int

)

AS



Begin

Select  ID,ShipName,IMONumber,FlagOfShip,Regime,IMONumber

FROM dbo.Ship

	  

WHERE ID= @ID

End





