
ALTER PROCEDURE [dbo].[stpGetShipDetailsByID]



AS



Begin

Select  ID,ShipName,RIGHT('000000'+CAST(IMONumber AS VARCHAR(7)),6),FlagOfShip,Regime,IMONumber

FROM dbo.Ship

	  

--WHERE ID= @ID

End













