USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetRegimeById]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetRegimeById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpGetRegimeById]
GO
/****** Object:  StoredProcedure [dbo].[stpGetRegimeById]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetRegimeById]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'







CREATE procedure [dbo].[stpGetRegimeById]

(

	@RegimeId int

)

AS



Begin

SELECT [ID]

      ,[RegimeName]

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

	  ,[Description]

      ,[Basis]

  FROM [dbo].[Regimes] 

  WHERE

		[ID] = @RegimeId

		

End' 
END
GO
