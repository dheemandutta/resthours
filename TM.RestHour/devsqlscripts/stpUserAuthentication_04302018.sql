USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpUserAuthentication]    Script Date: 4/30/2018 11:27:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec stpUserAuthentication 'u52', 'u5'
ALTER procedure [dbo].[stpUserAuthentication]
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

End




