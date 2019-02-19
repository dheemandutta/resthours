USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetAllRegimes]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetAllRegimes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpGetAllRegimes]
GO
/****** Object:  StoredProcedure [dbo].[stpGetAllRegimes]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetAllRegimes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE procedure [dbo].[stpGetAllRegimes]

AS



Begin

SELECT [ID]

      ,[RegimeName]

      ,[Description]

      ,[Basis]

      ,[MinTotalRestIn7Days]

      ,[MaxTotalWorkIn24Hours]

      ,[MinContRestIn24Hours]

      ,[MinTotalRestIn24Hours]

      ,[MaxTotalWorkIn7Days]

      ,[CheckFor2Days]

      ,[OPA90]

     -- ,[Timestamp]

      ,[ManilaExceptions]

      ,[UseHistCalculationOnly]

      ,[CheckOnlyWorkHours]

  FROM [dbo].[Regimes] 

End' 
END
GO
