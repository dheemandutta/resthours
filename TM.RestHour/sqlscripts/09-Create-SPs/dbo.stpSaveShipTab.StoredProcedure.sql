USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpSaveShipTab]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpSaveShipTab]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpSaveShipTab]
GO
/****** Object:  StoredProcedure [dbo].[stpSaveShipTab]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpSaveShipTab]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[stpSaveShipTab] 

  

( 

@Regime nvarchar(50)

) 



AS 

BEGIN 



UPDATE Ship

SET Regime=@Regime

Where ID=1



END' 
END
GO
