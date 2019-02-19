USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpUserAuthentication]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpUserAuthentication]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpUserAuthentication]
GO
/****** Object:  StoredProcedure [dbo].[stpUserAuthentication]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpUserAuthentication]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--exec stpUserAuthentication ''u52'', ''u5''

CREATE procedure [dbo].[stpUserAuthentication]

(

	@Username nvarchar(200),

	@Password nvarchar(200)

)

AS



Begin



SELECT ISNULL(

(Select ID 

from Users  

Where Username=@Username 

AND [Password]=@Password 

AND Active= 1),0)    



End' 
END
GO
