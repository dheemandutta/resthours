USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetAllShipDetails]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetAllShipDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpGetAllShipDetails]
GO
/****** Object:  StoredProcedure [dbo].[stpGetAllShipDetails]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetAllShipDetails]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create procedure [dbo].[stpGetAllShipDetails]

AS



Begin

Select ID,ShipName,IMONumber,FlagOfShip,Regime

from dbo.Ship  

End' 
END
GO
