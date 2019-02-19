USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpSaveRegimes]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpSaveRegimes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpSaveRegimes]
GO
/****** Object:  StoredProcedure [dbo].[stpSaveRegimes]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpSaveRegimes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[stpSaveRegimes] 

  

( 

@ID int,

@RegimeName nvarchar(50),

@Description ntext,

@Basis nvarchar(50),

@MinTotalRestIn7Days float,

@MaxTotalWorkIn24Hours float,

@MinContRestIn24Hours float,

@MinTotalRestIn24Hours float,

@MaxTotalWorkIn7Days float,

@CheckFor2Days bit,

@OPA90 bit,

--@Timestamp timestamp,

@ManilaExceptions bit,

@UseHistCalculationOnly bit,

@CheckOnlyWorkHours bit

) 



AS 

BEGIN 

    

 IF @ID IS NULL

BEGIN   

  

INSERT INTO Regimes 

            (RegimeName, [Description], Basis, MinTotalRestIn7Days, MaxTotalWorkIn24Hours, MinContRestIn24Hours, MinTotalRestIn24Hours,

			MaxTotalWorkIn7Days, CheckFor2Days, OPA90, ManilaExceptions, UseHistCalculationOnly, CheckOnlyWorkHours)



Values(@RegimeName, @Description, @Basis, @MinTotalRestIn7Days, @MaxTotalWorkIn24Hours, @MinContRestIn24Hours, @MinTotalRestIn24Hours,

			@MaxTotalWorkIn7Days, @CheckFor2Days, @OPA90, @ManilaExceptions, @UseHistCalculationOnly, @CheckOnlyWorkHours)

  

 

END

ELSE

BEGIN



UPDATE Regimes

SET RegimeName=@RegimeName, [Description]=@Description, Basis=@Basis, MinTotalRestIn7Days=@MinTotalRestIn7Days,

    MaxTotalWorkIn24Hours=@MaxTotalWorkIn24Hours, MinContRestIn24Hours=@MinContRestIn24Hours, MinTotalRestIn24Hours=@MinTotalRestIn24Hours,

    MaxTotalWorkIn7Days=@MaxTotalWorkIn7Days, CheckFor2Days=@CheckFor2Days, OPA90=@OPA90, ManilaExceptions=@ManilaExceptions, 

	UseHistCalculationOnly=@UseHistCalculationOnly, CheckOnlyWorkHours=@CheckOnlyWorkHours

Where ID=@ID



END

END' 
END
GO
