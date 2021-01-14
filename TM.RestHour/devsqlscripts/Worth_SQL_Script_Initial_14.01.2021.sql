Use [master]
CREATE LOGIN rhadmin
WITH PASSWORD = N'P@ssw0rd',
	CHECK_POLICY  = OFF,
	CHECK_EXPIRATION  = OFF;
EXEC sp_addsrvrolemember
	@loginame  = N'rhadmin',
	@rolename  = N'sysadmin'

USE [resthoursclient]
GO



/*#########################################STORED PROCEDURES ###############################################*/

/****** Object:  UserDefinedFunction [dbo].[ufn_CSVToTable]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ufn_CSVToTable] ( @StringInput VARCHAR(8000), @Delimiter nvarchar(1))
RETURNS @OutputTable TABLE ( [String] VARCHAR(10) )
AS
BEGIN

    DECLARE @String    VARCHAR(10)

    WHILE LEN(@StringInput) > 0
    BEGIN
        SET @String      = LEFT(@StringInput, 
                                ISNULL(NULLIF(CHARINDEX(@Delimiter, @StringInput) - 1, -1),
                                LEN(@StringInput)))
        SET @StringInput = SUBSTRING(@StringInput,
                                     ISNULL(NULLIF(CHARINDEX(@Delimiter, @StringInput), 0),
                                     LEN(@StringInput)) + 1, LEN(@StringInput))

        INSERT INTO @OutputTable ( [String] )
        VALUES ( @String )
    END

    RETURN
END

GO
/****** Object:  UserDefinedFunction [dbo].[ufunc_GetDateFormat]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[ufunc_GetDateFormat]()    
returns int     
Begin 
declare @x int 
select @x = convert(int,ConfigValue) from tblConfig Where KeyName = 'dateformat' 
return @x 
End

GO
/****** Object:  StoredProcedure [dbo].[GetShipEmail]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetShipEmail]
(
	@VesselId int
)
AS
BEGIN
	SELECT ShipEmail FROM Ship WHERE IMONumber = @VesselId
END

GO
/****** Object:  StoredProcedure [dbo].[GetShipEmailWithOutIMO]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetShipEmailWithOutIMO]
AS
BEGIN
	SELECT ShipEmail FROM Ship 
END

GO
/****** Object:  StoredProcedure [dbo].[stpAddUsers]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------
----------------------Updated 20 11 2018

 --  exec stpAddUsers 'DipDeb81', '123','14', true, '2057', '38', '9876543'
CREATE PROCEDURE [dbo].[stpAddUsers]

(

	@UserName varchar(200),

	@Password nvarchar(200),

	@GroupIds varchar(1000),

	@Active bit,

	@ID int,

	@CrewId int	,
	@VesselID int


)

AS

BEGIN



	BEGIN TRY

		BEGIN TRAN



		DECLARE @UserId int

		DECLARE @GroupTab TABLE

		  (

			GrpId int,

			UserId int

		  )





	    IF @ID IS NULL

		BEGIN

			INSERT INTO Users(Username,Password,Active,CrewId,VesselID) VALUES

			(@UserName,@Password,1,@CrewId,@VesselID)



			SET @UserId = @@IDENTITY



			INSERT INTO @GroupTab(GrpId,UserId) 

			SELECT String,@UserId FROM ufn_CSVToTable(@GroupIds,',')





			INSERT INTO UserGroups(UserID,GroupID,VesselID)

			SELECT UserId,GrpId,@VesselID FROM @GroupTab



		END

		ELSE

		BEGIN

			UPDATE Users SET  Password = @Password ,Active = @Active 

			WHERE ID = @ID



			DELETE FROM UserGroups WHERE UserID  = @ID 



			INSERT INTO @GroupTab(GrpId,UserId) 

			SELECT String,@ID FROM ufn_CSVToTable(@GroupIds,',')



			INSERT INTO UserGroups(UserID,GroupID,VesselID)

			SELECT UserId,GrpId,@VesselID FROM @GroupTab

		END





		COMMIT TRAN

	END TRY

	BEGIN CATCH

		ROLLBACK TRAN

	END CATCH



END
---------------------------------------------
-----------------------Added 21 11 2018 ----------

GO
/****** Object:  StoredProcedure [dbo].[stpCheckIfWorkedBeforeOneDays]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec stpCheckIfWorkedBeforeSevenDays '09/07/2018',23,9876543
CREATE PROCEDURE [dbo].[stpCheckIfWorkedBeforeOneDays]
(
	@BookDate datetime,
	@CrewId int,
	@VesselID int
)
AS
BEGIN
	
	DECLARE @ServiceStartDate datetime

	SELECT @ServiceStartDate = ActiveFrom 
	FROM ServiceTerms
	WHERE CrewID= @CrewID
	AND VesselID = @VesselID

	SELECT COUNT(*) 
	FROM WorkSessions 
	WHERE ValidOn BETWEEN @ServiceStartDate AND DATEADD(day,-1,@BookDate)
	AND CrewID =  @CrewId
	And VesselID = @VesselID

END

GO
/****** Object:  StoredProcedure [dbo].[stpCheckIfWorkedBeforeSevenDays]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec stpCheckIfWorkedBeforeSevenDays '09/07/2018',23,9876543
CREATE PROCEDURE [dbo].[stpCheckIfWorkedBeforeSevenDays]
(
	@BookDate datetime,
	@CrewId int,
	@VesselID int
)
AS
BEGIN
	
	DECLARE @ServiceStartDate datetime

	SELECT @ServiceStartDate = ActiveFrom 
	FROM ServiceTerms
	WHERE CrewID= @CrewID
	AND VesselID = @VesselID

	SELECT COUNT(*) 
	FROM WorkSessions 
	WHERE ValidOn BETWEEN @ServiceStartDate AND DATEADD(day,-6,@BookDate)
	AND CrewID =  @CrewId
	And VesselID = @VesselID

END

GO
/****** Object:  StoredProcedure [dbo].[stpCheckUserIdAvailibility]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------------------------------------



-- exec stpCheckUserIdAvailibility 'JohWoo72'
CREATE PROCEDURE [dbo].[stpCheckUserIdAvailibility]
(
	@UserId varchar(50)
)
AS
BEGIN
	SELECT count(*) from Users 
	WHERE LTRIM(RTRIM(UPPER(Username))) = LTRIM(RTRIM(UPPER(@UserId))) 
END

GO
/****** Object:  StoredProcedure [dbo].[stpDeleteDepartment]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpDeleteDepartment] 
( 
@DepartmentMasterID int
) 
AS 
BEGIN 

DECLARE @DepartmentCrewCount int
SET @DepartmentCrewCount =0

SELECT @DepartmentCrewCount = COUNT(*) FROM DepartmentAdmin 
WHERE DepartmentMasterID = @DepartmentMasterID

IF @DepartmentCrewCount = 0
BEGIN
UPDATE DepartmentMaster SET IsActive = 0
WHERE DepartmentMasterID = @DepartmentMasterID
 
END


RETURN  
END

GO
/****** Object:  StoredProcedure [dbo].[stpDeleteShipDetails]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[stpDeleteShipDetails] 

  

( 

@ID int

) 



AS 

BEGIN 

    

   

  

DELETE FROM Ship where ID=@ID

RETURN  

 

END

GO
/****** Object:  StoredProcedure [dbo].[stpDetleteRanks]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpDetleteRanks]

( 

@ID int

)

AS

BEGIN

DECLARE @CrewId AS INT = (SELECT DISTINCT ISNULL(RankID,0) FROM Crew WHERE RankID=@ID )

  

--select previd  from #temp

  --IF ISNULL(@CrewId,0)=@ID 

  --SELECT ISNULL(@CrewId,0) AS CrewId

IF @ID <> ISNULL(@CrewId,0)  

  BEGIN

 IF OBJECT_ID('tempdb..#temp') IS NOT NULL

   DROP TABLE #temp

   SELECT [Order] as previd INTO #temp

   FROM   Ranks  WHERE ID=@ID  

   BEGIN TRY

   BEGIN TRAN

   DELETE FROM Ranks WHERE ID=@ID

   SET NOCOUNT ON

   DECLARE @REC_ID        AS INT

   DECLARE @MaxCount      AS INT

   

  IF OBJECT_ID('tempdb..#temp2') IS NOT NULL

   DROP TABLE #temp2

   SELECT ROW_NUMBER() OVER

      (

            ORDER BY [ID] ASC

      )AS OrderNumber,Id,[Order] as orderno

	  into #temp2

	  from Ranks 

   

    SET @MaxCount = (SELECT MAX(OrderNumber) FROM #temp2 a where a.orderno >(select previd FROM #temp))

	--select @MaxCount

    SET @REC_ID = (SELECT previd FROM #temp)

	DECLARE @Prv_ID AS INT 

	SET @Prv_ID = (SELECT previd-1 FROM #temp)

	--select @Prv_ID

	WHILE ( @REC_ID <= @MaxCount )

    BEGIN

	--print 'ssg'

     UPDATE Ranks SET [Order] = @REC_ID

	 WHERE [Order] = @REC_ID+1

            

     --SELECT @REC_ID,NULL

	 IF(@REC_ID > @Prv_ID AND @REC_ID <= @MaxCount)

    BEGIN

        SET @REC_ID = @REC_ID + 1

        CONTINUE

    END

    

    ELSE

    BEGIN

        BREAK

    END

END

SET NOCOUNT OFF 

        COMMIT TRAN

END TRY

 BEGIN CATCH

		ROLLBACK TRAN

 END CATCH





  END

  

END



/*

begin tran

exec stpDetleteRanks 

@ID=1020

select * from Ranks



rollback

*/

GO
/****** Object:  StoredProcedure [dbo].[stpExportCrew]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--   exec stpExportData

create procedure [dbo].[stpExportCrew]
--(
-- @Parameter DataType
--)
AS

Begin

Select * from Crew -- FOR XML AUTO
--Select * from DepartmentAdmin FOR XML AUTO
--Select * from DepartmentMaster FOR XML AUTO
--Select * from FirstRun FOR XML AUTO
--Select * from GroupRank FOR XML AUTO
--Select * from Groups FOR XML AUTO
--Select * from NCDetails FOR XML AUTO
--Select * from Ranks FOR XML AUTO
--Select * from Regimes FOR XML AUTO
--Select * from ServiceTerms FOR XML AUTO
--Select * from Ship FOR XML AUTO
--Select * from TimeAdjustment FOR XML AUTO
--Select * from UserGroups FOR XML AUTO
--Select * from Users FOR XML AUTO
--Select * from WorkSessions FOR XML AUTO
--Select * from tblRegime FOR XML AUTO
End

GO
/****** Object:  StoredProcedure [dbo].[stpExportCrewRegimeTR]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--   exec stpExportCrewRegimeTR

Create procedure [dbo].[stpExportCrewRegimeTR]
--(
-- @Parameter DataType
--)
AS

Begin

Select * from CrewRegimeTR -- FOR XML AUTO
--Select * from DepartmentAdmin FOR XML AUTO
--Select * from DepartmentMaster FOR XML AUTO
--Select * from FirstRun FOR XML AUTO
--Select * from GroupRank FOR XML AUTO
--Select * from Groups FOR XML AUTO
--Select * from NCDetails FOR XML AUTO
--Select * from Ranks FOR XML AUTO
--Select * from Regimes FOR XML AUTO
--Select * from ServiceTerms FOR XML AUTO
--Select * from Ship FOR XML AUTO
--Select * from TimeAdjustment FOR XML AUTO
--Select * from UserGroups FOR XML AUTO
--Select * from Users FOR XML AUTO
--Select * from WorkSessions FOR XML AUTO
--Select * from tblRegime FOR XML AUTO
End

GO
/****** Object:  StoredProcedure [dbo].[stpExportDepartmentAdmin]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stpExportDepartmentAdmin]
AS
Begin

Select * from DepartmentAdmin 
--Select * from DepartmentMaster FOR XML AUTO
--Select * from FirstRun FOR XML AUTO
--Select * from GroupRank FOR XML AUTO
--Select * from Groups FOR XML AUTO
--Select * from NCDetails FOR XML AUTO
--Select * from Ranks FOR XML AUTO
--Select * from Regimes FOR XML AUTO
--Select * from ServiceTerms FOR XML AUTO
--Select * from Ship FOR XML AUTO
--Select * from TimeAdjustment FOR XML AUTO
--Select * from UserGroups FOR XML AUTO
--Select * from Users FOR XML AUTO
--Select * from WorkSessions FOR XML AUTO
--Select * from tblRegime FOR XML AUTO
End

GO
/****** Object:  StoredProcedure [dbo].[stpExportDepartmentMaster]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stpExportDepartmentMaster]
AS
Begin

Select * from DepartmentMaster 
--Select * from FirstRun FOR XML AUTO
--Select * from GroupRank FOR XML AUTO
--Select * from Groups FOR XML AUTO
--Select * from NCDetails FOR XML AUTO
--Select * from Ranks FOR XML AUTO
--Select * from Regimes FOR XML AUTO
--Select * from ServiceTerms FOR XML AUTO
--Select * from Ship FOR XML AUTO
--Select * from TimeAdjustment FOR XML AUTO
--Select * from UserGroups FOR XML AUTO
--Select * from Users FOR XML AUTO
--Select * from WorkSessions FOR XML AUTO
--Select * from tblRegime FOR XML AUTO
End

GO
/****** Object:  StoredProcedure [dbo].[stpExportFirstRun]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stpExportFirstRun]
AS
Begin

Select * from FirstRun
--Select * from GroupRank FOR XML AUTO
--Select * from Groups FOR XML AUTO
--Select * from NCDetails FOR XML AUTO
--Select * from Ranks FOR XML AUTO
--Select * from Regimes FOR XML AUTO
--Select * from ServiceTerms FOR XML AUTO
--Select * from Ship FOR XML AUTO
--Select * from TimeAdjustment FOR XML AUTO
--Select * from UserGroups FOR XML AUTO
--Select * from Users FOR XML AUTO
--Select * from WorkSessions FOR XML AUTO
--Select * from tblRegime FOR XML AUTO
End

GO
/****** Object:  StoredProcedure [dbo].[stpExportGroupRank]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stpExportGroupRank]
AS
Begin

Select * from GroupRank 
--Select * from Groups FOR XML AUTO
--Select * from NCDetails FOR XML AUTO
--Select * from Ranks FOR XML AUTO
--Select * from Regimes FOR XML AUTO
--Select * from ServiceTerms FOR XML AUTO
--Select * from Ship FOR XML AUTO
--Select * from TimeAdjustment FOR XML AUTO
--Select * from UserGroups FOR XML AUTO
--Select * from Users FOR XML AUTO
--Select * from WorkSessions FOR XML AUTO
--Select * from tblRegime FOR XML AUTO
End

GO
/****** Object:  StoredProcedure [dbo].[stpExportGroups]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stpExportGroups]
AS
Begin

Select * from Groups 
--Select * from NCDetails FOR XML AUTO
--Select * from Ranks FOR XML AUTO
--Select * from Regimes FOR XML AUTO
--Select * from ServiceTerms FOR XML AUTO
--Select * from Ship FOR XML AUTO
--Select * from TimeAdjustment FOR XML AUTO
--Select * from UserGroups FOR XML AUTO
--Select * from Users FOR XML AUTO
--Select * from WorkSessions FOR XML AUTO
--Select * from tblRegime FOR XML AUTO
End

GO
/****** Object:  StoredProcedure [dbo].[stpExportNCDetails]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stpExportNCDetails]
AS
Begin

Select * from NCDetails 
--Select * from Ranks FOR XML AUTO
--Select * from Regimes FOR XML AUTO
--Select * from ServiceTerms FOR XML AUTO
--Select * from Ship FOR XML AUTO
--Select * from TimeAdjustment FOR XML AUTO
--Select * from UserGroups FOR XML AUTO
--Select * from Users FOR XML AUTO
--Select * from WorkSessions FOR XML AUTO
--Select * from tblRegime FOR XML AUTO
End

GO
/****** Object:  StoredProcedure [dbo].[stpExportRanks]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stpExportRanks]
AS
Begin

Select * from Ranks 
--Select * from Regimes FOR XML AUTO
--Select * from ServiceTerms FOR XML AUTO
--Select * from Ship FOR XML AUTO
--Select * from TimeAdjustment FOR XML AUTO
--Select * from UserGroups FOR XML AUTO
--Select * from Users FOR XML AUTO
--Select * from WorkSessions FOR XML AUTO
--Select * from tblRegime FOR XML AUTO
End

GO
/****** Object:  StoredProcedure [dbo].[stpExportRegimes]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stpExportRegimes]
AS
Begin

Select * from Regimes 
--Select * from ServiceTerms FOR XML AUTO
--Select * from Ship FOR XML AUTO
--Select * from TimeAdjustment FOR XML AUTO
--Select * from UserGroups FOR XML AUTO
--Select * from Users FOR XML AUTO
--Select * from WorkSessions FOR XML AUTO
--Select * from tblRegime FOR XML AUTO
End

GO
/****** Object:  StoredProcedure [dbo].[stpExportServiceTerms]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stpExportServiceTerms]
AS
Begin

Select * from ServiceTerms 
--Select * from Ship FOR XML AUTO
--Select * from TimeAdjustment FOR XML AUTO
--Select * from UserGroups FOR XML AUTO
--Select * from Users FOR XML AUTO
--Select * from WorkSessions FOR XML AUTO
--Select * from tblRegime FOR XML AUTO
End

GO
/****** Object:  StoredProcedure [dbo].[stpExportShip]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stpExportShip]
AS
Begin

Select * from Ship 
--Select * from TimeAdjustment FOR XML AUTO
--Select * from UserGroups FOR XML AUTO
--Select * from Users FOR XML AUTO
--Select * from WorkSessions FOR XML AUTO
--Select * from tblRegime FOR XML AUTO
End

GO
/****** Object:  StoredProcedure [dbo].[stpExporttblRegime]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stpExporttblRegime]
AS
Begin

Select * from tblRegime 
End

GO
/****** Object:  StoredProcedure [dbo].[stpExportTimeAdjustment]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stpExportTimeAdjustment]
AS
Begin

Select * from TimeAdjustment 
--Select * from UserGroups FOR XML AUTO
--Select * from Users FOR XML AUTO
--Select * from WorkSessions FOR XML AUTO
--Select * from tblRegime FOR XML AUTO
End

GO
/****** Object:  StoredProcedure [dbo].[stpExportUserGroups]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stpExportUserGroups]
AS
Begin

Select * from UserGroups
--Select * from Users FOR XML AUTO
--Select * from WorkSessions FOR XML AUTO
--Select * from tblRegime FOR XML AUTO
End

GO
/****** Object:  StoredProcedure [dbo].[stpExportUsers]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stpExportUsers]
AS
Begin


Select * from Users 
--Select * from WorkSessions FOR XML AUTO
--Select * from tblRegime FOR XML AUTO
End

GO
/****** Object:  StoredProcedure [dbo].[stpExportWorkSessions]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpExportWorkSessions]
AS
Begin


Select Id,CrewID,ValidOn,[Hours],Increment,Comment,[Timestamp],Deleted,ActualHours,TimeAdjustment,AdjustmentFator,VesselID,RegimeID,LatestUpdate from WorkSessions 
--Select * from tblRegime FOR XML AUTO
End

GO
/****** Object:  StoredProcedure [dbo].[stpGetAllCrewByCrewID]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--   exec stpGetAllCrewByCrewID 9, 9876543
CREATE PROCEDURE [dbo].[stpGetAllCrewByCrewID]
(
	@ID int,
	@VesselID int
)
AS
Begin
Select  C.ID ,FirstName + '  ' +LastName AS Name,MiddleName,Gender ,
RankName, ISNULL(Notes,' ') Notes , C.VesselID,
--ISNULL(CONVERT(varchar(12),ST.ActiveFrom,dbo.ufunc_GetDateFormat()), '-') ActiveFrom1,
  ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),ST.ActiveFrom,dbo.ufunc_GetDateFormat()), ' ','-'), ',',''), '-') ActiveFrom1,
--ISNULL(CONVERT(varchar(12),ST.ActiveTo,dbo.ufunc_GetDateFormat()), '-') ActiveTo1,
 ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),ST.ActiveTo,dbo.ufunc_GetDateFormat()), ' ','-'), ',',''), '-') ActiveTo1,
C.FirstName,C.LastName,
--ISNULL(CONVERT(varchar(12),DOB,dbo.ufunc_GetDateFormat()), '-') DOB1,
 ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),DOB,dbo.ufunc_GetDateFormat()), ' ','-'), ',',''), '-') DOB1,
ISNULL(C.CountryID,'') CountryID,
ISNULL(CM.CountryName,'') CountryName,

ISNULL(C.POB,'') POB, 
ISNULL(C.CrewIdentity,'') CrewIdentity,ISNULL(C.PassportSeamanPassportBook,'') PassportSeamanPassportBook,
ISNULL(C.Seaman,'') Seaman,

--ISNULL(CONVERT(varchar(12),C.CreatedOn,dbo.ufunc_GetDateFormat()), '-') CreatedOn,
ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),C.CreatedOn,dbo.ufunc_GetDateFormat()), ' ','-'), ',',''), '-') CreatedOn,
--ISNULL(CONVERT(varchar(12),C.LatestUpdate,dbo.ufunc_GetDateFormat()), '-') LatestUpdate,
ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),C.LatestUpdate,dbo.ufunc_GetDateFormat()), ' ','-'), ',',''), '-') LatestUpdate,

C.OvertimeEnabled,C.Watchkeeper,C.RankID


,C.DepartmentMasterID, DM.DepartmentMasterName




,C.IssuingStateOfIdentityDocument
,ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),C.ExpiryDateOfIdentityDocument,dbo.ufunc_GetDateFormat()), ' ','-'), ',',''), '-') ExpiryDateOfIdentityDocument1
FROM dbo.Crew C 
LEFT OUTER JOIN ServiceTerms ST
ON C.ID = ST.CrewID
INNER JOIN Ranks R 
ON R.ID = C.RankID


LEFT OUTER JOIN DepartmentMaster DM
ON DM.DepartmentMasterID = C.DepartmentMasterID


INNER JOIN CountryMaster CM 
ON CM.CountryID = C.CountryID

WHERE C.ID= @ID AND C.VesselID=@VesselID
End

-------------------------------------------------------------------------------------------------------------------------------------

GO
/****** Object:  StoredProcedure [dbo].[stpGetAllCrewForAssign]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec stpGetAllCrewForAssign 9876543

CREATE procedure [dbo].[stpGetAllCrewForAssign]
(
--@ID int,
@VesselID int
)
AS
Begin
Select  ID, FirstName + '  ' +LastName AS Name
from Crew 
Where VesselID = @VesselID -- AND ID = @ID
End

GO
/****** Object:  StoredProcedure [dbo].[stpGetAllCrewServiceTerms]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- stpGetAllCrewServiceTerms 1042
CREATE procedure [dbo].[stpGetAllCrewServiceTerms]
(
@ID varchar(20)
)
AS
Begin
Select *
from Crew
WHERE ID = @ID
--AND IsActive=1
End

GO
/****** Object:  StoredProcedure [dbo].[stpGetAllRanks]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpGetAllRanks]
(

@VesselID int
)


AS



Begin

Select ID,RankName,[Description],Scheduled,VesselID

from dbo.Ranks R  
Where R.VesselID = @VesselID
End

GO
/****** Object:  StoredProcedure [dbo].[stpGetAllRegimes]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
	  ,VesselID

  FROM [dbo].[Regimes] 
End

GO
/****** Object:  StoredProcedure [dbo].[stpGetAllShipDetails]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[stpGetAllShipDetails]

AS



Begin

Select ID,ShipName,IMONumber,FlagOfShip,Regime

from dbo.Ship  

End

GO
/****** Object:  StoredProcedure [dbo].[stpGetAlltblConfig]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpGetAlltblConfig]
(
@KeyName varchar(20)
)
AS
Begin
DECLARE @Cnt int
SET @Cnt = 0 

SELECT @Cnt = COUNT(*) from tblConfig
WHERE UPPER(LTRIM(RTRIM(KeyName))) = UPPER(RTRIM(LTRIM(@KeyName)))

IF @Cnt > 0
BEGIN
	Select *
	from tblConfig
	WHERE UPPER(LTRIM(RTRIM(KeyName))) = UPPER(RTRIM(LTRIM(@KeyName)))
	AND IsActive=1
END
ELSE
BEGIN
	SELECT ' ' AS ConfigValue
END
End

GO
/****** Object:  StoredProcedure [dbo].[stpGetAllUsersForDrp]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stpGetAllUsersForDrp]
(
@KeyName varchar(20)
)
AS
Begin
Select *
from dbo.tblConfig
Where KeyName=@KeyName AND IsActive=1
End

GO
/****** Object:  StoredProcedure [dbo].[stpGetChildNodes]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetChildNodes]

(

	@ID int,
	@VesselID int
)

AS



Begin

Select  ID,PermissionName, VesselID

FROM dbo.[Permissions]   

Where ParentPermissionID  = @ID AND VesselID =@VesselID

End

GO
/****** Object:  StoredProcedure [dbo].[stpGetCompanyDetailsByID]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec stpGetFleetMasterByID 5

create PROCEDURE [dbo].[stpGetCompanyDetailsByID]
(
	@ID int
)
AS
Begin
Select ID, Name, [Address], Website, AdminContact, AdminContactEmail, ContactNumber, Domain, SecureKey
FROM CompanyDetails
WHERE ID = @ID
End

GO
/****** Object:  StoredProcedure [dbo].[stpGetCompanyDetailsNew]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[stpGetCompanyDetailsNew]
--(
	--@ID int
--)
AS
Begin
Select Name, [Address], Website, AdminContact, AdminContactEmail, ContactNumber, Domain, SecureKey
FROM CompanyDetails
--WHERE ID = @ID
End

GO
/****** Object:  StoredProcedure [dbo].[stpGetConfigValues]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetConfigValues]
(
	@KeyVal varchar(20)
)
AS
BEGIN

	SELECT ConfigValue FROM tblConfig WHERE KeyName =  @KeyVal

END

GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewByID]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------

-------------------- 26 11 2018 ------------------
-- stpGetCrewByID 18

CREATE PROCEDURE [dbo].[stpGetCrewByID]
(
	@ID int
)
AS
Begin
Select  DOB,FirstName + ' ' + LastName As Name
FROM Crew
WHERE ID= @ID
End

GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewByRankID]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetCrewByRankID]

(

	@RankID int, 
	@VesselID int
)

AS



Begin

Select  *, VesselID

FROM dbo.Crew

	  

WHERE RankID= @RankID AND VesselID=@VesselID

End

GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewByUserID]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetCrewByUserID]

(

	@UserID int, 
	@VesselID int

)

AS



Begin

Select  GroupID,G.GroupName, G.VesselID

FROM UserGroups UG

INNER JOIN Groups G

ON UG.ID = G.ID

	  

WHERE UserID= @UserID AND G.VesselID = @VesselID

End

GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewDetailsForHealthByID]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  Exec stpGetCrewDetailsForHealthByID 18
CREATE PROCEDURE [dbo].[stpGetCrewDetailsForHealthByID]
(
@LoggedInUserId int
)
AS
Begin
Select ISNULL(FirstName,' ')+'  '+ISNULL(LastName,' ') AS Name, CONVERT(varchar(12),DOB,103)DOB, R.RankName,  CONVERT(varchar(12),ST.ActiveFrom,103)ActiveFrom
FROM Crew C

INNER JOIN Ranks R

ON R.ID = C.RankID

INNER JOIN ServiceTerms ST

ON ST.CrewID = C.ID



WHERE C.ID= @LoggedInUserId
End

GO
/****** Object:  StoredProcedure [dbo].[stpGetJoiningMedicalFileDatawByID]    Script Date: 12/23/2019 6:07:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- stpGetJoiningMedicalFileDatawByID 1

create PROCEDURE [dbo].[stpGetJoiningMedicalFileDatawByID]
(
	@CrewId int
)
AS
Begin
Select  JoiningMedicalFile
FROM JoiningMedicalFileData
WHERE CrewId= @CrewId
End
GO
/****** Object:  StoredProcedure [dbo].[stpSaveJoiningMedicalFilePath]    Script Date: 12/23/2019 6:05:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpSaveJoiningMedicalFilePath]
(
	@CrewId int,
	@File varchar(500)
)
AS
BEGIN
	DECLARE @FCnt int
	SET @FCnt =0
	SELECT @FCnt = COUNT(*) FROM JoiningMedicalFileData WHERE CrewId = @CrewId

	IF @FCnt = 0 OR @FCnt IS NULL
	BEGIN
		INSERT INTO JoiningMedicalFileData(CrewId,JoiningMedicalFile,UploadDate) VALUES
		(@CrewId,@File,GETDATE())
	END
	IF @FCnt > 0
	BEGIN
		UPDATE JoiningMedicalFileData
		SET JoiningMedicalFile = @File,
			UploadDate = GETDATE()
		WHERE CrewId = @CrewId
	END
	 
END
GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewDetailsForHealthByIDNew]    Script Date: 12/23/2019 6:04:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  Exec stpGetCrewDetailsForHealthByIDNew 3
CREATE PROCEDURE [dbo].[stpGetCrewDetailsForHealthByIDNew]
(
@LoggedInUserId int
)
AS
Begin
Select ISNULL(FirstName,' ')+'  '+ISNULL(LastName,' ') AS Name, 
--CONVERT(varchar(12),DOB,dbo.ufunc_GetDateFormat())DOB, 
ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),DOB,dbo.ufunc_GetDateFormat()), ' ','-'), ',',''), '-') DOB,
R.RankName,  
--CONVERT(varchar(12),ST.ActiveFrom,dbo.ufunc_GetDateFormat())ActiveFrom
ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),ST.ActiveFrom,dbo.ufunc_GetDateFormat()), ' ','-'), ',',''), '-') ActiveFrom
FROM Crew C
LEFT OUTER JOIN Ranks R
ON R.ID = C.RankID
LEFT OUTER JOIN ServiceTerms ST
ON ST.CrewID = C.ID
WHERE C.ID= @LoggedInUserId
End

GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewDetailsForHealthByIDNew2]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  Exec stpGetCrewDetailsForHealthByIDNew2 17
CREATE PROCEDURE [dbo].[stpGetCrewDetailsForHealthByIDNew2]
(
@LoggedInUserId int
)
AS
Begin
Select ISNULL(FirstName,' ')+'  '+ISNULL(LastName,' ') AS Name, 
--CONVERT(varchar(12),DOB,dbo.ufunc_GetDateFormat())DOB, 
ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),DOB,dbo.ufunc_GetDateFormat()), ' ','-'), ',',''), '-') DOB,
R.RankName,  
--CONVERT(varchar(12),ST.ActiveFrom,dbo.ufunc_GetDateFormat())ActiveFrom
ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),ST.ActiveFrom,dbo.ufunc_GetDateFormat()), ' ','-'), ',',''), '-') ActiveFrom,
--CONVERT(varchar(12),ST.ActiveFrom,dbo.ufunc_GetDateFormat())ActiveFrom
ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),ST.ActiveTo,dbo.ufunc_GetDateFormat()), ' ','-'), ',',''), '-') LatestUpdate,

FirstName,MiddleName,LastName,PassportSeamanPassportBook,Seaman,POB


FROM Crew C

INNER JOIN Ranks R

ON R.ID = C.RankID

INNER JOIN ServiceTerms ST

ON ST.CrewID = C.ID



WHERE C.ID= @LoggedInUserId
End

GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewDetailsPageWise]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetCrewDetailsPageWise]

 (

      @PageIndex INT = 1,

      @PageSize INT = 10,

      @RecordCount INT OUTPUT,

	  @VesselID int

)

AS

BEGIN

      SET NOCOUNT ON;

      SELECT ROW_NUMBER() OVER

      (

            ORDER BY [Name] ASC

      )AS RowNumber

     ,Name,RankName,CreatedOn As StartDate,ISNULL(C.LatestUpdate,'') As EndDate, DateDIFF(day , GETDATE(), C.LatestUpdate ) AS DiffDays,COUNT(R.ID) AS TotCount , C.VesselID,

CASE

	WHEN  datediff(day , GETDATE(), C.LatestUpdate ) > 0 THEN 1

	ELSE 0

END As Active

 INTO #Results

FROM Crew C INNER JOIN Ranks R 

ON C.RankID = R.ID

-- Where C.VesselID = @VesselID

GROUP BY Name,RankName,CreatedOn,C.LatestUpdate,C.VesselID

	
	
     

      SELECT @RecordCount = COUNT(*)

      FROM #Results

           

      SELECT * FROM #Results

      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

      AND VesselID = @VesselID

      DROP TABLE #Results

END

GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewIDFromWorkSessions]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[stpGetCrewIDFromWorkSessions]

(

	@CrewId int,

	@Month int,

	@Year int,

	@VesselID int

)

AS

BEGIN

		DECLARE @zerotime nchar(48) = '000000000000000000000000000000000000000000000000'

		DECLARE @TimeTab TABLE

		(

		  ID int, 
		  Hours nchar(48),
		  BookDate varchar(10),
		  FirstName varchar(100),
		  LastName varchar(100),
		  RankName nvarchar(50),
		  WorkDate varchar(10),
		  ComplianceInfo xml,
		  TotalNCHours float,
		  Comment nvarchar(200),
		  AdjustmentFactor varchar(20),
		  VesselID int,
		  RegimeSymbol char(1),    ----------
		  SevenDaysRest varchar(10),
		  IsWithinFiveDays bit,
		   Comments varchar(500),
		  IsApproved bit

		)



		INSERT INTO @TimeTab(ID,Hours,BookDate,FirstName,LastName,RankName,WorkDate,ComplianceInfo,TotalNCHours,Comment,AdjustmentFactor,VesselID,RegimeSymbol,IsWithinFiveDays,Comments,IsApproved)

		SELECT WS.ID,Hours,DAY(ValidOn) AS BookDate,C.FirstName,C.LastName,R.RankName,ISNULL(CONVERT(varchar(12),ValidOn,103), '') AS WorkDate,ComplianceInfo,TotalNCHours,WS.Comment,AdjustmentFator As AdjustmentFactor, WS.VesselID,
				
			CASE RegimeName
				WHEN 'IMO STCW' THEN              '~'
				WHEN 'ILO Rest (Flexible)' THEN '@'
				WHEN 'ILO Work' THEN '#'
				WHEN 'Customised' THEN '$'
				WHEN 'ILO Rest' THEN '^'
				WHEN 'IMO STCW 2010' THEN '&'
				WHEN 'OCIMF' THEN '*'
		END As RegimeSymbol,0,ISNULL(WS.Comments,'') , ISNULL(WS.isApproved,0)

		FROM WorkSessions WS

		LEFT OUTER JOIN Crew C

		ON C.ID = WS.CrewID

		LEFT OUTER JOIN NCDetails NCD

		ON WS.ID= NCD.WorkSessionId 

		AND  WS.ValidOn = NCD.OccuredOn

		LEFT OUTER JOIN Ranks R

		ON R.ID = C.RankID

		INNER JOIN Regimes REG

		ON REG.ID = WS.RegimeID

		WHERE WS.CrewId = @CrewId

		--AND NCD.CrewID = @CrewId

		 AND MONTH(ValidON) = @Month

		 AND YEAR(ValidOn) = @Year

		AND MONTH(OccuredOn) = @Month

		AND YEAR(OccuredOn) = @Year

		--AND WS.Hours <> @zerotime

		ORDER BY ValidOn,WS.Timestamp

	

		

		DECLARE @id int

		DECLARE @bdate varchar(10)
		DECLARE @wdate varchar(10)
		DECLARE @workdy int
		DECLARE @workmon int
		DECLARE @workyr int
		DECLARE @nextval varchar(10)
        DECLARE @sevendaysrest varchar(10)
		DECLARE @isservicetermperiod bit



		SET @nextval =''
		SET @sevendaysrest = 0
		SET @isservicetermperiod = 0
					

		DECLARE db_cursor CURSOR FOR 

		SELECT ID,BookDate FROM @TimeTab

		

		OPEN db_cursor  
		FETCH NEXT FROM db_cursor INTO @id,@bdate

		

		WHILE @@FETCH_STATUS = 0  

		BEGIN  

			  
			  set @workdy = CONVERT(int,@bdate)
			
			  set @workmon = CAST(@Month AS int)

			  set @workyr =  CAST(@Year as int)

			  EXEC stpGetFirstFiveDays @workdy,@workmon,@workyr,@CrewId,@isservicetermperiod OUTPUT
			  
			  EXEC stpGetWorkSessionsByValidOn @workdy,
											   @workmon,
											   @workyr,
											    @CrewId,
												@sevendaysrest OUTPUT

			  UPDATE @TimeTab SET SevenDaysRest= CONVERT(varchar,@sevendaysrest), @isservicetermperiod = @isservicetermperiod WHERE ID  = @id

			  SET @sevendaysrest = '-'

			  IF (@bdate != @nextval)

			  BEGIN

				SET @nextval = @bdate

			  END

			  ELSE

			  BEGIN

			  

			  UPDATE @TimeTab SET BookDate = @bdate + '_dup' WHERE ID=@id



			  END





			  FETCH NEXT FROM db_cursor INTO @id,@bdate

		END 



		CLOSE db_cursor  

		DEALLOCATE db_cursor    

	





	   SELECT * FROM @TimeTab 
	   Where VesselID = @VesselID
	   ORDER BY BookDate



END





















GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewListingPageWise2]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--   declare @x int Exec stpGetCrewListingPageWise2 1,10, @x out, 9876543
CREATE PROCEDURE [dbo].[stpGetCrewListingPageWise2]

 (

      @PageIndex INT = 1,

      @PageSize INT = 10,

      @RecordCount INT OUTPUT,

	  @VesselID int

)

AS

BEGIN

      SET NOCOUNT ON;

      SELECT ROW_NUMBER() OVER

      (

            ORDER BY [FirstName] ASC

      )AS RowNumber

     ,FirstName + '  ' +LastName AS Name

	 ,RankName

	 --,CreatedOn As StartDate

	-- ,CONVERT(varchar(12),CreatedOn,dbo.ufunc_GetDateFormat()) StartDate
	 ,ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),CreatedOn,dbo.ufunc_GetDateFormat()), ' ','-'), ',',''), '-') StartDate

	 --,ISNULL(C.LatestUpdate,'') As EndDate

	  ,CONVERT(varchar(12),C.LatestUpdate,103) EndDate

	 ,C.ID,C.VesselID,

CASE

	WHEN  datediff(day , GETDATE(), C.LatestUpdate ) > 0 THEN 1

	ELSE 0

END As Active

 INTO #Results

FROM Crew C INNER JOIN Ranks R

ON C.RankID = R.ID
Where C.DeactivationDate >= GetDate()
--GROUP BY Name,RankName,CreatedOn,C.LatestUpdate

	

     

      SELECT @RecordCount = COUNT(*)

      FROM #Results

           

      SELECT * FROM #Results

      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

     AND VesselID = @VesselID

      DROP TABLE #Results

END






















GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewListingForInactivPageWise]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  declare @x int Exec stpGetCrewListingPageWise 1,10, @x out, 9876543
CREATE PROCEDURE [dbo].[stpGetCrewListingForInactivPageWise]

 (

      @PageIndex INT = 1,

      @PageSize INT = 10,

      @RecordCount INT OUTPUT,

	  @VesselID int

)

AS

BEGIN

      SET NOCOUNT ON;

      SELECT ROW_NUMBER() OVER

      (

            ORDER BY [FirstName] ASC

      )AS RowNumber

     ,FirstName + '  ' +LastName AS Name

	 ,RankName

	 --,CreatedOn As StartDate

	-- ,CONVERT(varchar(12),CreatedOn,dbo.ufunc_GetDateFormat()) StartDate
	 ,ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),CreatedOn,dbo.ufunc_GetDateFormat()), ' ','-'), ',',''), '-') StartDate

	 --,ISNULL(C.LatestUpdate,'') As EndDate

	  ,CONVERT(varchar(12),C.LatestUpdate,103) EndDate

	 ,C.ID,C.VesselID,

CASE

	WHEN  datediff(day , GETDATE(), C.LatestUpdate ) > 0 THEN 1

	ELSE 0

END As Active

 INTO #Results

FROM Crew C INNER JOIN Ranks R

ON C.RankID = R.ID
--Where C.DeactivationDate >= GetDate()
Where C.DeletionDate >= GetDate() 
AND C.DeactivationDate <= GetDate() 
--GROUP BY Name,RankName,CreatedOn,C.LatestUpdate

	

     

      SELECT @RecordCount = COUNT(*)

      FROM #Results

           

      SELECT * FROM #Results

      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

     AND VesselID = @VesselID

      DROP TABLE #Results

END



GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewListingPageWise]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  declare @x int Exec stpGetCrewListingPageWise 1,10, @x out, 9876543
CREATE PROCEDURE [dbo].[stpGetCrewListingPageWise]

 (

      @PageIndex INT = 1,

      @PageSize INT = 10,

      @RecordCount INT OUTPUT,

	  @VesselID int

)

AS

BEGIN

      SET NOCOUNT ON;

      SELECT ROW_NUMBER() OVER

      (

            ORDER BY [FirstName] ASC

      )AS RowNumber

     ,FirstName + '  ' +LastName AS Name

	 ,RankName

	 --,CreatedOn As StartDate

	-- ,CONVERT(varchar(12),CreatedOn,dbo.ufunc_GetDateFormat()) StartDate
	 ,ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),CreatedOn,dbo.ufunc_GetDateFormat()), ' ','-'), ',',''), '-') StartDate

	 --,ISNULL(C.LatestUpdate,'') As EndDate

	  ,CONVERT(varchar(12),C.LatestUpdate,103) EndDate

	 ,C.ID,C.VesselID,

CASE

	WHEN  datediff(day , GETDATE(), C.LatestUpdate ) > 0 THEN 1

	ELSE 0

END As Active

 INTO #Results

FROM Crew C INNER JOIN Ranks R

ON C.RankID = R.ID
Where C.DeactivationDate >= GetDate()
--GROUP BY Name,RankName,CreatedOn,C.LatestUpdate

	

     

      SELECT @RecordCount = COUNT(*)

      FROM #Results

           

      SELECT * FROM #Results

      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

     AND VesselID = @VesselID

      DROP TABLE #Results

END

GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewOverTime]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetCrewOverTime]
(
	@CrewId int
)
AS
BEGIN
	SELECT OverTimeEnabled FROM Crew WHERE ID = @CrewId
END

GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewOvertimeValue]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetCrewOvertimeValue]
(
	@CrewId int,
	@VesselID int
)
AS
BEGIN
	SELECT OvertimeEnabled,VesselID FROM Crew WHERE ID = @CrewId AND VesselID=@VesselID
END

GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewPageWise]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  declare @x int Exec stpGetCrewPageWise 1047, 1,10, @x out, 9876543
CREATE PROCEDURE [dbo].[stpGetCrewPageWise]
 (
      @ID int,
      @PageIndex INT = 1,
      @PageSize INT = 10,
      @RecordCount INT OUTPUT,
	  @VesselID int
)
AS
BEGIN
      SET NOCOUNT ON;
      SELECT ROW_NUMBER() OVER
      (
            ORDER BY [ID] ASC
      )AS RowNumber
      ,RankID AS ID
     ,FirstName + '  ' +LastName AS Name
	 ,VesselID
     INTO #Results
      FROM Crew
    where RankID=@ID AND VesselID=@VesselID
      SELECT @RecordCount = COUNT(*)
      FROM #Results
      SELECT * FROM #Results
      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1
      AND VesselID=@VesselID
      DROP TABLE #Results
END

GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewReportList]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  declare @x int Exec stpGetCrewReportList  1,1000, @x out, 9876543
CREATE PROCEDURE [dbo].[stpGetCrewReportList]

 (

      @PageIndex INT = 1,

      @PageSize INT = 10,

      @RecordCount INT OUTPUT,

	  @VesselID int

)

AS

BEGIN

      SET NOCOUNT ON;

      SELECT ROW_NUMBER() OVER

      (

            ORDER BY [FirstName] ASC

      )AS RowNumber

     ,FirstName + ' ' +LastName AS Name

	 ,R.RankName

	-- ,(ISNULL(CONVERT(VARCHAR(12),C.DOB,dbo.ufunc_GetDateFormat()),'') +' '+ISNULL(C.POB,'') ) AS DOB1
	 ,ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),C.DOB,dbo.ufunc_GetDateFormat()), ' ','-'), ',',''), '-') DOB1

	 ,C.ID

	 ,CM.CountryName AS Nationality

	 ,C.EmployeeNumber

	 ,C.DOB

	 ,C.PassportSeamanPassportBook

	 ,C.Seaman

	 ,C.VesselID

 INTO #Results

FROM Crew C INNER JOIN Ranks R

ON C.RankID = R.ID
INNER JOIN CountryMaster CM
ON C.CountryID = CM.CountryID
WHERE C.IsActive=1

--GROUP BY Name,RankName,CreatedOn,C.LatestUpdate

	

     

      SELECT @RecordCount = COUNT(*)

      FROM #Results

           

      SELECT * FROM #Results

      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

     AND VesselID=@VesselID

      DROP TABLE #Results

END

GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewReportListPageWise]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  declare @x int Exec stpGetCrewReportListPageWise  1,20, @x out, 9876543
CREATE PROCEDURE [dbo].[stpGetCrewReportListPageWise]

 (

      @PageIndex INT = 1,

      @PageSize INT = 10,

      @RecordCount INT OUTPUT,

	  @VesselID int

)

AS

BEGIN

      SET NOCOUNT ON;

      SELECT ROW_NUMBER() OVER

      (

            ORDER BY [FirstName] ASC

      )AS RowNumber

     ,FirstName + ' ' +LastName AS Name

	 ,R.RankName

	-- ,(ISNULL(CONVERT(VARCHAR(12),C.DOB,dbo.ufunc_GetDateFormat()),'') +' '+ISNULL(C.POB,'') ) AS DOB1
	 ,ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),C.DOB,dbo.ufunc_GetDateFormat()), ' ','-'), ',',''), '-') DOB1

	 ,C.ID

	 ,CM.CountryName AS Nationality

	 ,C.EmployeeNumber

	 ,C.DOB

	 ,C.PassportSeamanPassportBook

	 ,C.Seaman

	 ,C.VesselID

 INTO #Results

FROM Crew C INNER JOIN Ranks R

ON C.RankID = R.ID
INNER JOIN CountryMaster CM
ON C.CountryID = CM.CountryID

WHERE C.IsActive=1

--GROUP BY Name,RankName,CreatedOn,C.LatestUpdate

	

     

      SELECT @RecordCount = COUNT(*)

      FROM #Results

           

      SELECT * FROM #Results

      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

     AND VesselID=@VesselID

      DROP TABLE #Results

END

GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewReportListPageWise2]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  declare @x int Exec stpGetCrewReportListPageWise  1,20, @x out, 9876543
Create PROCEDURE [dbo].[stpGetCrewReportListPageWise2]

 (

      @PageIndex INT = 1,

      @PageSize INT = 10,

      @RecordCount INT OUTPUT,

	  @VesselID int

)

AS

BEGIN

      SET NOCOUNT ON;

      SELECT ROW_NUMBER() OVER

      (

            ORDER BY [FirstName] ASC

      )AS RowNumber

     ,FirstName + ' ' +LastName AS Name

	 ,R.RankName

	-- ,(ISNULL(CONVERT(VARCHAR(12),C.DOB,dbo.ufunc_GetDateFormat()),'') +' '+ISNULL(C.POB,'') ) AS DOB1
	 ,ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),C.DOB,dbo.ufunc_GetDateFormat()), ' ','-'), ',',''), '-') DOB1

	 ,C.ID

	 ,CM.CountryName AS Nationality

	 ,C.EmployeeNumber

	 ,C.DOB

	 ,C.PassportSeamanPassportBook

	 ,C.Seaman

	 ,C.VesselID

 INTO #Results

FROM Crew C INNER JOIN Ranks R

ON C.RankID = R.ID
INNER JOIN CountryMaster CM
ON C.CountryID = CM.CountryID

--GROUP BY Name,RankName,CreatedOn,C.LatestUpdate

	

     

      SELECT @RecordCount = COUNT(*)

      FROM #Results

           

      SELECT * FROM #Results

      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

     AND VesselID=@VesselID

      DROP TABLE #Results

END

GO
/****** Object:  StoredProcedure [dbo].[stpGetDataForVarianceReport]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------
----------------23 11 2018------------------------


-- declare @x int  exec stpGetDataForVarianceReport '1' ,'10','2018', 1,39,@x out,9876543



CREATE PROCEDURE [dbo].[stpGetDataForVarianceReport]

(

	@CrewId int,
	@Month int,
	@Year int,
    @PageIndex INT = 1,
	@PageSize INT = 39,
	@RecordCount INT OUTPUT,
	@VesselID int

)

AS

BEGIN

		
	   DECLARE @ResultTab TABLE
	   (

			ID int,
			Hours nchar(48),
			BookDate int,
			FirstName varchar(50),
			LastName varchar(50),
			RankName varchar(50),
			WorkDate varchar(12),
			ComplianceInfo xml,
			TotalNCHours float,
			Comment nvarchar(150),
			AdjustmentFactor varchar(20),
			VesselID int,
			MinTotalRestIn7Days float,
			SevenDaysRest varchar(10),
			ValidOnDt datetime

	   )

		DECLARE @id int
		DECLARE @bdate varchar(11)
		DECLARE @workdy int
		DECLARE @workmon int
		DECLARE @workyr int
		DECLARE @sevendaysrest varchar(10)

		SET NOCOUNT ON;

 --     SELECT ROW_NUMBER() OVER

 --     (

 --           ORDER BY WS.ID ASC

 --     )AS RowNumber
 --     ,WS.ID
	--  ,Hours
	--  ,DAY(ValidOn) AS BookDate
	--  ,FirstName
	--  ,LastName
	--  ,RankName
	--  --,ISNULL(CONVERT(varchar(12),ValidOn,dbo.ufunc_GetDateFormat()), '') AS WorkDate
	--   ,ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),ValidOn,dbo.ufunc_GetDateFormat()), ' ','/'), ',',''), '/') WorkDate
	--  ,ComplianceInfo
	--  ,TotalNCHours
	--  ,Comment
	--  ,AdjustmentFator AS 'AdjustmentFactor'
	--  ,C.VesselID
	--  ,REG.MinTotalRestIn7Days
	-- -- ,C.ID        --------------------------------------------------------------------------------------
 --    INTO #Results
 --      FROM WorkSessions WS
	--    INNER JOIN Regimes REG
	--	ON WS.RegimeID = REG.ID
	--	LEFT OUTER JOIN Crew C
	--	ON C.ID = WS.CrewID
	--	LEFT OUTER  JOIN NCDetails NCD
	--	ON WS.ID= NCD.WorkSessionId 
	--	AND  WS.ValidOn = NCD.OccuredOn
	--	LEFT OUTER JOIN Ranks R
	--	ON R.ID = C.RankID
	--	WHERE WS.CrewId = @CrewId
	--	--AND NCD.CrewID = @CrewId
	--	 AND MONTH(ValidON) = @Month
	--	 AND YEAR(ValidOn) = @Year
	--	AND MONTH(OccuredOn) = @Month
	--	AND YEAR(OccuredOn) = @Year
	--AND isNC = 1

	 SET @sevendaysrest = '-'

	  INSERT INTO @ResultTab(ID,Hours,BookDate,FirstName,LastName,RankName,WorkDate,ComplianceInfo,TotalNCHours,Comment,AdjustmentFactor,VesselID,MinTotalRestIn7Days,ValidOnDt)
	  SELECT WS.ID,Hours,DAY(ValidOn) AS BookDate,FirstName,LastName,RankName,ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),ValidOn,dbo.ufunc_GetDateFormat()), ' ','/'), ',',''), '/') WorkDate
	  ,ComplianceInfo,TotalNCHours,Comment,AdjustmentFator AS 'AdjustmentFactor',C.VesselID,REG.MinTotalRestIn7Days,ValidOn
      FROM WorkSessions WS
	    INNER JOIN Regimes REG
		ON WS.RegimeID = REG.ID
		LEFT OUTER JOIN Crew C
		ON C.ID = WS.CrewID
		LEFT OUTER  JOIN NCDetails NCD
		ON WS.ID= NCD.WorkSessionId 
		AND  WS.ValidOn = NCD.OccuredOn
		LEFT OUTER JOIN Ranks R
		ON R.ID = C.RankID
		WHERE WS.CrewId = @CrewId
		--AND NCD.CrewID = @CrewId
		 AND MONTH(ValidON) = @Month
		 AND YEAR(ValidOn) = @Year
		AND MONTH(OccuredOn) = @Month
		AND YEAR(OccuredOn) = @Year
		AND isNC = 1


		--select * from @ResultTab


	    DECLARE db_cursor CURSOR FOR 
		SELECT ID,ValidOnDt FROM @ResultTab

		OPEN db_cursor  
		FETCH NEXT FROM db_cursor INTO @id,@bdate

		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			
			  set @workdy = DAY(@bdate)
			  set @workmon = MONTH(@bdate)
			  set @workyr =  YEAR(@bdate)	

			  EXEC stpGetWorkSessionsByValidOn @workdy,
											   @workmon,
											   @workyr,
											    @CrewId,
												@sevendaysrest OUTPUT
			 print @workdy
			 print @workmon
			 print @workyr

			  UPDATE @ResultTab SET SevenDaysRest= CONVERT(varchar,@sevendaysrest) WHERE ID  = @id

			  SET @sevendaysrest = '-'

			FETCH NEXT FROM db_cursor INTO @id,@bdate
		END  

		
		CLOSE db_cursor
		DEALLOCATE db_cursor

	SELECT ROW_NUMBER() OVER
		(
            ORDER BY ID ASC

      )AS RowNumber
      ,ID
	  ,Hours
	  ,BookDate
	  ,FirstName
	  ,LastName
	  ,RankName
	  ,WorkDate
	  ,ComplianceInfo
	  ,TotalNCHours
	  ,Comment
	  ,AdjustmentFactor
	  ,VesselID
	  ,MinTotalRestIn7Days
	  ,SevenDaysRest
      INTO #Results
      FROM @ResultTab


		
		SELECT @RecordCount = COUNT(*) FROM #Results



	   SELECT  * FROM #Results
       WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1
	   AND VesselID=@VesselID
	   ORDER BY WorkDate ASC

     

      DROP TABLE #Results


END

GO
/****** Object:  StoredProcedure [dbo].[stpGetDayWiseCrewBookingData]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetDayWiseCrewBookingData]

(

	@BookDate DateTime,
	@VesselID int

)

AS

BEGIN



SELECT Hours,W.CrewID, C.FirstName,C.LastName,CM.CountryName AS Nationality,ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),ValidOn,dbo.ufunc_GetDateFormat()), ' ','/'), ',',''), '/') WorkDate,
R.RankName,Comment,AdjustmentFator As AdjustmentFactor, C.VesselID,RegimeName,NC.ComplianceInfo

FROM WorkSessions W
INNER JOIN NCDetails NC
ON W.CrewID = NC.CrewID
INNER JOIN Crew C
ON C.ID= W.CrewID
INNER JOIN CountryMaster CM
ON CM.CountryID = c.CountryID
INNER JOIN Ranks R
ON C.RankID = R.ID 
INNER JOIN Regimes REG
ON W.RegimeID = REG.ID
WHERE CONVERT(varchar(12),ValidOn,103) = CONVERT(varchar(12),@BookDate,103)
AND CONVERT(varchar(12),OccuredOn,103) = CONVERT(varchar(12),@BookDate,103)
AND C.VesselID=@VesselID

AND C.IsActive=1
ORDER BY CrewID



END

GO
/****** Object:  StoredProcedure [dbo].[stpGetDepartmentByID]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec stpGetDepartmentByID 5, 9876543

CREATE PROCEDURE [dbo].[stpGetDepartmentByID]
(
	@DepartmentMasterID int,
	@VesselID int
)
AS
Begin

DECLARE @DepartmentAdminIds varchar(500)
SET @DepartmentAdminIds = ''

SELECT @DepartmentAdminIds = COALESCE(@DepartmentAdminIds + ',','') + CAST(C.ID AS varchar(4))
FROM DepartmentAdmin DA
INNER JOIN DepartmentMaster DM
ON DM.DepartmentMasterID = DA.DepartmentMasterID
INNER JOIN Crew C
ON  DA.CrewID=C.ID 
AND DM.DepartmentMasterID = @DepartmentMasterID
AND DM.VesselID=@VesselID   

--SELECT @DepartmentAdminIds

Select DM.DepartmentMasterID,DepartmentMasterName,DepartmentMasterCode,@DepartmentAdminIds AS DepartmentAdmin
FROM dbo.DepartmentMaster DM
WHERE DM.DepartmentMasterID = @DepartmentMasterID
AND DM.VesselID=@VesselID


End

GO
/****** Object:  StoredProcedure [dbo].[stpGetDepartmentByIDForAssignAdmin]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec stpGetDepartmentByIDForAssignAdmin 5, 9876543
CREATE procedure [dbo].[stpGetDepartmentByIDForAssignAdmin]
(
    @DepartmentMasterID int,
	@VesselID int
	
)
AS
Begin

 Select C.ID, FirstName + '  ' +LastName AS Name
 from Crew C
 inner join DepartmentAdmin DA
 ON C.ID = DA.crewID
 inner JOIN Users U
   ON C.ID = U.CrewId
   inner JOIN UserGroups UG
   ON U.ID=UG.UserID 

     inner JOIN DepartmentMaster DM
   ON DA.DepartmentMasterID=DM.DepartmentMasterID

 WHERE DA.DepartmentMasterID = @DepartmentMasterID
 AND  C.VesselID=@VesselID
 AND UG.GroupID = 14
End

GO
/****** Object:  StoredProcedure [dbo].[stpGetDepartmentByIDForAssignCrew]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec stpGetDepartmentByIDForAssignCrew '5', 9876543
CREATE procedure [dbo].[stpGetDepartmentByIDForAssignCrew]
(
    @DepartmentMasterID int,
	@VesselID int
	
)
AS
Begin
Select C.ID, FirstName + '  ' +LastName AS Name, C.VesselID
from Crew C
    LEFT OUTER JOIN Users U
   ON C.ID = U.CrewId
   LEFT OUTER JOIN UserGroups UG
   ON U.ID=UG.UserID    
    Where GroupID = 15   
   AND C.VesselID=@VesselID
 
 UNION 

 Select C.ID, FirstName + '  ' +LastName AS Name, C.VesselID
 from Crew C
 left outer join DepartmentAdmin DA
 ON C.ID = DA.crewID
 LEFT OUTER JOIN Users U
   ON C.ID = U.CrewId
   LEFT OUTER JOIN UserGroups UG
   ON U.ID=UG.UserID 
 WHERE DA.DepartmentMasterID = @DepartmentMasterID
 AND  C.VesselID=@VesselID
 AND GroupID = 15   
End

GO
/****** Object:  StoredProcedure [dbo].[stpGetDepartmentPageWise]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-----Patch 18-11-2018


--  declare @x int Exec stpGetDepartmentPageWise 1,15, @x out, 9876543
CREATE PROCEDURE [dbo].[stpGetDepartmentPageWise]
 (
      @PageIndex INT = 1,
      @PageSize INT = 15,
      @RecordCount INT OUTPUT,
	  @VesselID int
)
AS
BEGIN
      SET NOCOUNT ON;
      SELECT ROW_NUMBER() OVER
      (
            ORDER BY [DepartmentMasterName] ASC
      )AS RowNumber
      ,DM.DepartmentMasterID
      ,DepartmentMasterName
	 -- ,DepartmentMasterCode
	  ,FirstName + '  ' +LastName AS CrewName
	 -- ,Scheduled
	  ,DM.VesselID
     INTO #Results
      FROM DepartmentMaster DM  
	  LEFT OUTER JOIN DepartmentAdmin DA
	  ON DM.DepartmentMasterID = DA.DepartmentMasterID
	  LEFT OUTER JOIN Crew C
	  ON DA.CrewID=C.ID               
	    Where DM.VesselID = @VesselID
		AND DM.IsActive=1
      SELECT @RecordCount = COUNT(*)
      FROM #Results

	  SELECT DISTINCT DepartmentMasterID,DepartmentMasterName,VesselID, CrewName = 
     STUFF((SELECT ', ' + CrewName
           FROM #Results b 
           WHERE b.DepartmentMasterID = a.DepartmentMasterID 
          FOR XML PATH('')), 1, 2, '')
		FROM #Results a
		WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1
		GROUP BY DepartmentMasterID,DepartmentMasterName,VesselID
    	HAVING VesselID=@VesselID



      --SELECT * FROM #Results
      --WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

	  AND VesselID=@VesselID
	 -- ORDER BY [Order] ASC
      DROP TABLE #Results
END

GO
/****** Object:  StoredProcedure [dbo].[stpGetDoctorEmailByID]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[stpGetDoctorEmailByID]
(
	@DoctorID int
)
AS
Begin
Select  DoctorEmail
FROM DoctorMaster
WHERE DoctorID= @DoctorID
End

GO
/****** Object:  StoredProcedure [dbo].[stpGetEquipmentsPageWise]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  declare @x int Exec stpGetEquipmentsPageWise  1,10, @x out
CREATE PROCEDURE [dbo].[stpGetEquipmentsPageWise]
 (
     -- @EquipmentsID int,
      @PageIndex INT = 1,
      @PageSize INT = 10,
      @RecordCount INT OUTPUT
)
AS
BEGIN
      SET NOCOUNT ON;
      SELECT ROW_NUMBER() OVER
      (
            ORDER BY [EquipmentsID] ASC
      )AS RowNumber
      ,EquipmentsID 
     ,EquipmentsName
	 ,Comment
	 ,Quantity
	 ,Location
	 --,ExpiryDate
	  , SUBSTRING(ExpiryDate, 1, 11)as ExpiryDate
     INTO #Results
      FROM tblEquipments
    --where EquipmentsID=@EquipmentsID
      SELECT @RecordCount = COUNT(*)
      FROM #Results
      SELECT * FROM #Results
      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1
      DROP TABLE #Results
END

GO
/****** Object:  StoredProcedure [dbo].[stpGetFirstFiveDays]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetFirstFiveDays]
(
	@wday int,
	@wmon int,
	@wyear int,
	@CrewID int,
	@isWithinFirstFiveDays bit OUTPUT
)
AS
BEGIN

	DECLARE @RecCount int
	DECLARE @ValidOn datetime
	SET @ValidOn = dateadd(mm, (@wyear - 1900) * 12 + @wmon - 1 , @wday - 1)
	
	SELECT @RecCount = COUNT(*) FROM ServiceTerms 
	WHERE CrewID = @CrewID
	AND @ValidOn BETWEEN ActiveFrom AND ActiveTo

	IF @RecCount >= 1
	BEGIN
		SET @isWithinFirstFiveDays = 1
	END
	ELSE
	BEGIN
		SET @isWithinFirstFiveDays = 0
	END



END

GO
/****** Object:  StoredProcedure [dbo].[stpGetFirstLastNameByUserId]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec stpGetFirstLastNameByUserId 3,9876543

CREATE PROCEDURE [dbo].[stpGetFirstLastNameByUserId]

(

	@UserId int,
	@VesselID int

)

AS



Begin



DECLARE @CrewId int

SET @CrewId = 0

IF EXISTS(SELECT COUNT(*) FROM Users WHERE ID = @UserId)

	begin

		SELECT @CrewId = CrewID FROM Users WHERE ID = @UserId

	end

IF @CrewId IS NOT NULL

BEGIN

	Select  C.FirstName, C.LastName,C.ID AS CrewId, C.VesselID,
	CASE 
		WHEN UG.GroupId = 14 Then 'A'
		WHEN UG.GroupId = 15 Then 'U'
		WHEN UG.GroupId = 13 Then 'S'
	END AS AdminGroup

	FROM Crew C

	INNER JOIN Users U

	ON C.ID = U.CrewId
	INNER JOIN UserGroups UG
	ON U.ID = UG.UserID
	WHERE U.ID= @UserId
	AND C.VesselID=@VesselID

END

ELSE IF @CrewId IS NULL

BEGIN

	SELECT 'Admin' FirstName,'Admin' LastName,0 CrewId,VesselId,'S' AS AdminGroup

	FROM Users WHERE ID = @UserId

	 

END









End

GO
/****** Object:  StoredProcedure [dbo].[stpGetFirstRun]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpGetFirstRun]

AS
Begin

Select RunCount

from FirstRun

End

GO
/****** Object:  StoredProcedure [dbo].[stpGetFleetMasterPageWise]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  declare @x int Exec stpGetDepartmentPageWise 1,15, @x out, 9876543
Create PROCEDURE [dbo].[stpGetFleetMasterPageWise]
 (
      @PageIndex INT = 1,
      @PageSize INT = 15,
      @RecordCount INT OUTPUT,
	  @VesselID int
)
AS
BEGIN
      SET NOCOUNT ON;
      SELECT ROW_NUMBER() OVER
      (
            ORDER BY [FleetName] ASC
      )AS RowNumber
      ,FleetID
      ,FleetName
	  ,FleetCode
	  ,VesselID
     INTO #Results
      FROM FleetMaster  
	 
	    Where VesselID = @VesselID
		AND IsActive=1
      SELECT @RecordCount = COUNT(*)
      FROM #Results
      SELECT * FROM #Results
      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

	  AND VesselID=@VesselID
	 -- ORDER BY [Order] ASC
      DROP TABLE #Results
END

GO
/****** Object:  StoredProcedure [dbo].[stpGetIsActiveRegime]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpGetIsActiveRegime]
--(
--@VesselID int
--)
AS
Begin
DECLARE @ActiveRegimeCnt int
SET @ActiveRegimeCnt = 0

SELECT @ActiveRegimeCnt = COUNT(RegimeID) FROM tblRegime WHERE IsActiveRegime=1

IF @ActiveRegimeCnt = 1
BEGIN
	select RegimeID from tblRegime 
	Where IsActiveRegime = 1
END
ELSE
BEGIN
	SELECT 0 RegimeID
END

End

GO
/****** Object:  StoredProcedure [dbo].[stpGetLastAdjustmentBookedStatus]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetLastAdjustmentBookedStatus]

(

	@BookDate datetime,

	@CrewID int,
	@VesselID int 

)

AS

BEGIN

	DECLARE @LastMinuSOneAdjustmentDate Datetime



	SELECT @LastMinuSOneAdjustmentDate = MAX(CONVERT(date,AdjustmentDate,110)) FROM TimeAdjustment

	WHERE AdjustmentValue = '-1D'
	AND VesselID = @VesselID

	AND CONVERT(DATE,AdjustmentDate,110) < CONVERT(DATE,@BookDate,110)



	IF @LastMinuSOneAdjustmentDate IS NOT NULL

		BEGIN



		SELECT COUNT(*) AS 'BookCount',CONVERT(DATE,@LastMinuSOneAdjustmentDate,113) AS 'LastBookDate'

		FROM WorkSessions 

		WHERE CONVERT(DATE,ValidOn,110) = CONVERT(DATE,@LastMinuSOneAdjustmentDate,110)
		AND VesselID = @VesselID
		AND CrewID = @CrewID



		END

	ELSE

		BEGIN

			SELECT 0 AS 'BookCount' ,CONVERT(DATE,@LastMinuSOneAdjustmentDate,113) AS 'LastBookDate'  

		END



END

GO
/****** Object:  StoredProcedure [dbo].[stpGetLastSevenDaysWorkSchedule]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetLastSevenDaysWorkSchedule]

(

	@CrewId int,

	@BookDate datetime,
	@VesselID int 

)

AS

BEGIN

		 

		 DECLARE @ScheduleTable TABLE

		 (

			BookDate Datetime,
			Schedule varchar(1000),
			VesselID int

		 )

		 

		 DECLARE @RowCount int

		 DECLARE @Counter int

		 DECLARE @NegativeCounter int

		 DECLARE @ZeroSchedule nchar(48)
		 DECLARE @NullSchedule nchar(48)
		 DECLARE @isFilled bit
		 DECLARE @ChangedBookDate datetime
		 DECLARE @ScheduleRow  nchar(48)
		 DECLARE @TobeDeletedBookDate datetime
		 

		 SET @ZeroSchedule = '000000000000000000000000000000000000000000000000'
		 SET @NullSchedule = '999999999999999999999999999999999999999999999999'
		 SET @ChangedBookDate = @BookDate 
		 SET @isFilled = 0
		

		


		 SET @ChangedBookDate = dateadd(day,-1 ,@ChangedBookDate)

		 print @ChangedBookDate

		 WHILE (DATEDIFF(day,@BookDate, @ChangedBookDate) >= -6)


		 BEGIN

				print DATEDIFF(day,@BookDate, @ChangedBookDate)

				--SET @NegativeCounter = @Counter * -1

				IF EXISTS(SELECT 1 FROM WorkSessions WHERE CrewId = @CrewId AND ValidOn = @ChangedBookDate AND VesselID = @VesselID )


					BEGIN
							
							
									INSERT INTO @ScheduleTable(BookDate,Schedule,VesselID) 
									SELECT @ChangedBookDate,Hours,VesselID
									FROM WorkSessions 
									WHERE CrewID = @CrewId
									AND VesselID = @VesselID
									AND ValidOn = @ChangedBookDate 
							
							

							SET @isFilled = 1

					END

					--ELSE IF (@isFilled = 1)

					--BEGIN

					--		INSERT INTO @ScheduleTable(BookDate,Schedule,VesselID) 
					--		SELECT @ChangedBookDate,@NullSchedule,@VesselID

					--		SET @isFilled = 0

					--END
					

				--select *,'op' from @ScheduleTable

				SET @ChangedBookDate = dateadd(day,-1 ,@ChangedBookDate)
				print @ChangedBookDate

		 END  

		  
		  --check last row for null
		  --SELECT  TOP 1 @ScheduleRow = Schedule , @TobeDeletedBookDate = BookDate 
		  --FROM @ScheduleTable 
		  --ORDER BY BookDate asc

		 

		  ----delete if it exists
		  --IF (CHARINDEX('9', @ScheduleRow) > 0)
		  --BEGIN
				--DELETE FROM @ScheduleTable
				--WHERE BookDate = @TobeDeletedBookDate
		  --END  CONVERT(date,AdjustmentDate,110)


		 SELECT TOP 6 CONVERT(date,BookDate,110) AS [ValidOn],Schedule AS [Hours] FROM @ScheduleTable  
		 Where VesselID = @VesselID
		 ORDER BY BookDate DESC



 END

GO
/****** Object:  StoredProcedure [dbo].[stpGetLastSevenDaysWorkScheduleForComplianceCheck]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec stpGetLastSevenDaysWorkScheduleForComplianceCheck 15,'01/08/2019',8940557,7

CREATE PROCEDURE [dbo].[stpGetLastSevenDaysWorkScheduleForComplianceCheck]

(

	@CrewId int,
	@BookDate datetime,
	@VesselID int,
	@NumDays int 

)

AS

BEGIN

		 

		 DECLARE @ScheduleTable TABLE

		 (
			BookDate Datetime,
			Schedule varchar(1000),
			VesselID int
		 )

		 

		 DECLARE @RowCount int
		 DECLARE @Counter int
		 DECLARE @NegativeCounter int
		 DECLARE @ZeroSchedule nchar(48)
		 DECLARE @NullSchedule nchar(48)
		 DECLARE @isFilled bit
		 DECLARE @ChangedBookDate datetime
		 DECLARE @ScheduleRow  nchar(48)
		 DECLARE @TobeDeletedBookDate datetime
		 DECLARE @NegativeSevenDays int
		 DECLARE @NegativeSixDays int
		 DECLARE @PlusTimeAdjustmentDayCount int
		 

		 SET @ZeroSchedule = '000000000000000000000000000000000000000000000000'
		 SET @NullSchedule = '999999999999999999999999999999999999999999999999'
		 SET @ChangedBookDate = @BookDate 
		 SET @isFilled = 0
		 SET @NegativeSevenDays=-6
		 SET @NegativeSixDays=-5
		 SET @PlusTimeAdjustmentDayCount=0



		IF @NumDays = 7
		BEGIN

		SELECT @PlusTimeAdjustmentDayCount = COUNT(*) 
		FROM WorkSessions
		WHERE CrewID = @CrewId
		AND VesselID = @VesselID
		AND ValidOn BETWEEN DATEADD(DAY,@NegativeSevenDays,@BookDate) AND @BookDate
		AND AdjustmentFator = 'BOOKING_NOT_ALLOWED'

		IF @PlusTimeAdjustmentDayCount > 0 
			BEGIN
				SET @NegativeSevenDays = @NegativeSevenDays + (-1 * @PlusTimeAdjustmentDayCount)
			END


		 --SET @ChangedBookDate = dateadd(day,-1 ,@ChangedBookDate)

		 --print @PlusTimeAdjustmentDayCount

		 WHILE (DATEDIFF(day,@BookDate, @ChangedBookDate) >= @NegativeSevenDays)
		 BEGIN

				--print DATEDIFF(day,@BookDate, @ChangedBookDate)

				--SET @NegativeCounter = @Counter * -1

				IF EXISTS(SELECT 1 FROM WorkSessions WHERE CrewId = @CrewId 
						  AND ValidOn = @ChangedBookDate AND VesselID = @VesselID )
					BEGIN
							
							
									INSERT INTO @ScheduleTable(BookDate,Schedule,VesselID) 
									SELECT @ChangedBookDate,Hours,VesselID
									FROM WorkSessions 
									WHERE CrewID = @CrewId
									AND VesselID = @VesselID
									AND ValidOn = @ChangedBookDate 
									AND CONVERT(date,ValidOn,110) NOT IN (SELECT  CONVERT(date,DATEADD(DAY,-1,ValidOn),110) FROM WorkSessions WHERE CrewID=@CrewId AND  VesselID = @VesselID AND AdjustmentFator='BOOKING_NOT_ALLOWED')
							
							
							        print @ChangedBookDate
									SET @isFilled = 1

					END

					ELSE 

					BEGIN

							INSERT INTO @ScheduleTable(BookDate,Schedule,VesselID) 
							SELECT @ChangedBookDate,@ZeroSchedule,@VesselID


							print @ChangedBookDate
							SET @isFilled = 0

					END
					

				--select *,'op' from @ScheduleTable

				SET @ChangedBookDate = dateadd(day,-1 ,@ChangedBookDate)
				--print @ChangedBookDate

		 END  

		 
		 SELECT TOP 7 CONVERT(date,BookDate,110) AS [ValidOn],Schedule AS [Hours] FROM @ScheduleTable  
		 Where VesselID = @VesselID
		 ORDER BY BookDate ASC

		END -- main if
		ELSE
		BEGIN

				DECLARE @negDays int
				SET @negDays = -6
				
				SELECT @PlusTimeAdjustmentDayCount = COUNT(*) 
				FROM WorkSessions
				WHERE CrewID = @CrewId
				AND VesselID = @VesselID
				AND ValidOn BETWEEN DATEADD(DAY,@NegativeSixDays,@BookDate) AND @BookDate
				AND AdjustmentFator = 'BOOKING_NOT_ALLOWED'

			  IF @PlusTimeAdjustmentDayCount > 0 
				BEGIN
					SET @negDays =  @negDays + (-1 * @PlusTimeAdjustmentDayCount)
				END
				
				
				SET @ChangedBookDate = dateadd(day,@negDays ,@ChangedBookDate)
				print @ChangedBookDate

		 WHILE (DATEDIFF(day,@ChangedBookDate,@BookDate) > -1)
		 BEGIN

				--print DATEDIFF(day,@BookDate, @ChangedBookDate)

				--SET @NegativeCounter = @Counter * -1

				IF EXISTS(SELECT 1 FROM WorkSessions WHERE CrewId = @CrewId 
						  AND ValidOn = @ChangedBookDate AND VesselID = @VesselID )
					BEGIN
							
							
									INSERT INTO @ScheduleTable(BookDate,Schedule,VesselID) 
									SELECT @ChangedBookDate,Hours,VesselID
									FROM WorkSessions 
									WHERE CrewID = @CrewId
									AND VesselID = @VesselID
									AND ValidOn = @ChangedBookDate 
									AND CONVERT(date,ValidOn,110) NOT IN (SELECT CONVERT(date,DATEADD(DAY,-1,ValidOn),110) FROM WorkSessions WHERE CrewID=@CrewId AND  VesselID = @VesselID AND AdjustmentFator='BOOKING_NOT_ALLOWED')
							
							        print @ChangedBookDate
									SET @isFilled = 1

					END

					ELSE 

					BEGIN

								INSERT INTO @ScheduleTable(BookDate,Schedule,VesselID) 
								SELECT @ChangedBookDate,@ZeroSchedule,@VesselID


								print @ChangedBookDate
								SET @isFilled = 0

					END
					

				--select *,'op' from @ScheduleTable

				SET @ChangedBookDate = dateadd(day,1 ,@ChangedBookDate)
				--print @ChangedBookDate

		 END  

		 
		 SELECT TOP 6 CONVERT(date,BookDate,110) AS [ValidOn],Schedule AS [Hours] FROM @ScheduleTable  
		 Where VesselID = @VesselID
		 ORDER BY BookDate ASC



		END -- main else

 END

GO
/****** Object:  StoredProcedure [dbo].[stpGetLastSixDaysWorkSchedule]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetLastSixDaysWorkSchedule]

(

	@CrewId int,

	@BookDate datetime,
	@VesselID int

)

AS

BEGIN

		 

		 DECLARE @ScheduleTable TABLE

		 (

			BookDate Datetime,

			Schedule varchar(1000),
			VesselID int

		 )

		 

		 DECLARE @RowCount int

		 DECLARE @Counter int

		 DECLARE @NegativeCounter int

		 DECLARE @ZeroSchedule nchar(48)

		 DECLARE @ChangedBookDate datetime



		 SET @ZeroSchedule = '000000000000000000000000000000000000000000000000'

		 SET @ChangedBookDate = @BookDate 



		

		 

		 --SELECT @RowCount = COUNT(ValidOn) 

		 --FROM  WorkSessions

		 --WHERE CrewID = @CrewId

		 --AND ValidOn BETWEEN dateadd(day,-6,@BookDate) AND dateadd(day,-1,@BookDate)



		 SET @Counter=1



		 --print DATEDIFF(day,@BookDate, dateadd(day,-6 ,@BookDate))



		 SET @ChangedBookDate = dateadd(day,-1 ,@ChangedBookDate)



		 WHILE (DATEDIFF(day,@BookDate, @ChangedBookDate) >= -6)

		 BEGIN

				print DATEDIFF(day,@BookDate, @ChangedBookDate)





				SET @NegativeCounter = @Counter * -1

				IF EXISTS(SELECT 1 FROM WorkSessions WHERE CrewId = @CrewId AND ValidOn = @ChangedBookDate AND VesselID = @VesselID)

					BEGIN

							INSERT INTO @ScheduleTable(BookDate,Schedule,VesselID) 

							SELECT @ChangedBookDate,Hours,VesselID

							FROM WorkSessions 

							WHERE CrewID = @CrewId
							AND VesselID = @VesselID

							AND ValidOn = @ChangedBookDate 

					END

				ELSE

					BEGIN

							INSERT INTO @ScheduleTable(BookDate,Schedule,VesselID) 

							SELECT @ChangedBookDate,@ZeroSchedule,@VesselID

							

					END

				SET @Counter = @Counter + 1

				SET @ChangedBookDate = dateadd(day,-1 ,@ChangedBookDate)

		 END  



		 SELECT BookDate AS [ValidOn],Schedule AS [Hours] FROM @ScheduleTable  
		 Where VesselID = @VesselID
		 ORDER BY BookDate





 END

GO
/****** Object:  StoredProcedure [dbo].[stpGetMedicalAdvisoryPageWise]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  declare @x int Exec stpGetMedicalAdvisoryPageWise  1,10, @x out, 18
CREATE PROCEDURE [dbo].[stpGetMedicalAdvisoryPageWise]
 (
     -- @EquipmentsID int,
      @PageIndex INT = 1,
      @PageSize INT = 10,
      @RecordCount INT OUTPUT,

	  @LoggedInUserId int
)
AS
BEGIN
      SET NOCOUNT ON;
      SELECT ROW_NUMBER() OVER
      (
            ORDER BY [MedicalAdvisoryID] ASC
      )AS RowNumber
      ,MedicalAdvisoryID
	 ,Weight
	 ,BMI
	 ,BP
	 ,BloodSugarLevel + ' ' + BloodSugarUnit AS BloodSugarLevel
	 ,UrineTest
	 ,Systolic
	 ,Diastolic
	 ,UnannouncedAlcohol
	 ,AnnualDH
	 ,[Month]
	 ,CrewName
     INTO #Results
      FROM MedicalAdvisory
      --where CrewID=@LoggedInUserId
      SELECT @RecordCount = COUNT(*)
      FROM #Results
      SELECT * FROM #Results
      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1
      DROP TABLE #Results
END

GO
/****** Object:  StoredProcedure [dbo].[stpGetMedicinePageWise]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  declare @x int Exec stpGetMedicinePageWise  1,10, @x out
CREATE PROCEDURE [dbo].[stpGetMedicinePageWise]
 (
     -- @EquipmentsID int,
      @PageIndex INT = 1,
      @PageSize INT = 10,
      @RecordCount INT OUTPUT
)
AS
BEGIN
      SET NOCOUNT ON;
      SELECT ROW_NUMBER() OVER
      (
            ORDER BY [MedicineID] ASC
      )AS RowNumber
      ,MedicineID 
     ,MedicineName
	 ,Quantity
	 ,Location
	 --,ExpiryDate
	 , SUBSTRING(ExpiryDate, 1, 11)as ExpiryDate
     INTO #Results
      FROM tblMedicine
    --where EquipmentsID=@EquipmentsID
      SELECT @RecordCount = COUNT(*)
      FROM #Results
      SELECT * FROM #Results
      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1
      DROP TABLE #Results
END

GO
/****** Object:  StoredProcedure [dbo].[stpGetMinusOneDayAdjustmentDays]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---EXEC stpGetMinusOneDayAdjustmentDays 2,2018,1048

CREATE PROCEDURE [dbo].[stpGetMinusOneDayAdjustmentDays]



(

	@Month int,

	@Year int,

	@CrewId int,

	@VesselID int

)

AS

BEGIN



	SELECT ISNULL(DAY(AdjustmentDate), '') AS MinusAdjustmentDate,NULL AS AdjustmentDate, VesselID

	FROM TimeAdjustment 

	WHERE AdjustmentValue = '-1D'

	AND MONTH(AdjustmentDate) = @Month

	AND YEAR(AdjustmentDate) = @Year

	AND AdjustmentDate IN (SELECT ValidOn 

							FROM WorkSessions WHERE CrewID = @CrewId 

							AND MONTH(ValidOn)= @Month

						    AND YEAR(ValidOn) = @Year

							AND AdjustmentFator = '-1D' )


							AND VesselID=@VesselID

END

GO
/****** Object:  StoredProcedure [dbo].[stpGetNCForMonth]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec stpGetNCForMonth 04,2018

CREATE PROCEDURE [dbo].[stpGetNCForMonth]
(
	@Month int,
	@Year int,
	@CrewId int,
	@VesselID int
)
AS
BEGIN

	SELECT DAY(OccuredOn) As NcDay, VesselID
	FROM NCDetails
	WHERE CrewID = @CrewId
	AND MONTH(OccuredOn) = @Month
	AND YEAR(OccuredOn) = @Year

	AND VesselID=@VesselID

	AND isNC=1
	ORDER BY DAY(OccuredOn) ASC
	


END

GO
/****** Object:  StoredProcedure [dbo].[stpGetNextSixDaysTimeSheet]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[stpGetNextSixDaysTimeSheet]
(
	@BookDate Datetime,
	@CrewId int,
	@VesselId int
	
)
AS
BEGIN

	SELECT ID,ActualHours,AdjustmentFator,RegimeID,CONVERT(varchar(12),ValidOn,101) As ValidOn
	 FROM WorkSessions
	 WHERE CrewID = @CrewId
	 AND ValidOn BETWEEN DATEADD(day,1,@BookDate) AND DATEADD(day,6,@BookDate)
	 AND VesselID = @VesselId
	 ORDER BY ValidOn
END

GO
/****** Object:  StoredProcedure [dbo].[stpGetNoNCForMonth]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetNoNCForMonth]
(
	@Month int,
	@Year int,
	@CrewId int,
	@VesselID int
)
AS
BEGIN

	SELECT DAY(ValidOn) As NcDay, NC.VesselID
	FROM NCDetails NC
	INNER JOIN WorkSessions WS
	ON NC.WorkSessionId = WS.ID
	WHERE NC.CrewID = @CrewId
	AND MONTH(ValidOn) = @Month
	AND YEAR(ValidOn) = @Year

	AND NC.VesselID=@VesselID
	AND WS.ActualHours <> '0000,0000,0000,0000,0000,0000'
	AND NC.isNC=0
	ORDER BY DAY(ValidOn) ASC
	


END

GO
/****** Object:  StoredProcedure [dbo].[stpGetNonComplianceByCrewId]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec stpGetNonComplianceByCrewId 19,11,2017



CREATE PROCEDURE [dbo].[stpGetNonComplianceByCrewId]

(

	@CrewId int,

	@Month int,

	@Year int,

	@VesselID int

)

AS

BEGIN



	SELECT ComplianceInfo,TotalNCHours, VesselID

	FROM NCDetails

	WHERE CrewId = @CrewId

	AND MONTH(OccuredOn) = @Month

	AND YEAR(OccuredOn) = @Year

	AND VesselID=@VesselID

END

GO
/****** Object:  StoredProcedure [dbo].[stpGetNonComplianceInfo]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetNonComplianceInfo]

(

	@NCDetailsID int,
	@VesselID int

)

AS



Begin

Select  ComplianceInfo, VesselID

FROM NCDetails

  

WHERE NCDetailsID= @NCDetailsID
AND VesselID=@VesselID
End

GO
/****** Object:  StoredProcedure [dbo].[stpGetParentNodes]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpGetParentNodes]
(

	@VesselID int

)
AS



Begin

Select ID,PermissionName , VesselID

from dbo.[Permissions]  

Where ParentPermissionID IS NULL
AND VesselID=@VesselID
End

GO
/****** Object:  StoredProcedure [dbo].[stpGetPlusOneDayAdjustmentDays]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetPlusOneDayAdjustmentDays]



(

	@Month int,

	@Year int,
	@VesselID int

)

AS

BEGIN



	SELECT ISNULL(CONVERT(varchar(12),AdjustmentDate,103), '') AS AdjustmentDate, NULL as MinusAdjustmentDate, VesselID

	FROM TimeAdjustment

	WHERE AdjustmentValue = '+1D'

	AND MONTH(AdjustmentDate) = @Month

	AND YEAR(AdjustmentDate) = @Year

	AND VesselID=@VesselID

END

GO
/****** Object:  StoredProcedure [dbo].[stpGetPreviousBlankDates]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec stpGetPreviousBlankDates 15,'03/07/2019',8940557
CREATE PROCEDURE [dbo].[stpGetPreviousBlankDates]
(
	@CrewId int,
	@BookDate Datetime,
	@VesselId int
)
AS
BEGIN
DECLARE @MinDate DATETIME = DATEADD(day,-14,@BookDate),
        @MaxDate DATETIME = @BookDate ; --GETDATE();

DECLARE @PlusOneDayAdvCnt int
 SET @PlusOneDayAdvCnt =0

SELECT @PlusOneDayAdvCnt = COUNT(*) FROM TimeAdjustment
 WHERE AdjustmentValue = '+1D'
 AND CONVERT(varchar,AdjustmentDate,101) >= CONVERT(varchar,@MinDate,101)
 AND CONVERT(varchar,AdjustmentDate,101) <= CONVERT(varchar,@MaxDate,101)

 PRINT @PlusOneDayAdvCnt
 PRINT @MinDate

IF @PlusOneDayAdvCnt >= 1
BEGIN
	
	SET @MinDate = DATEADD(day,(@PlusOneDayAdvCnt*-1),@MinDate)

END

PRINT @MinDate


--print @MinDate

DECLARE @TempTab TABLE
(
	Dt VARCHAR(10)
)
DECLARE @Counter int 
SET @Counter = -14 + ( @PlusOneDayAdvCnt * -1)
WHILE @MinDate < @MaxDate
BEGIN

	INSERT INTO @TempTab(Dt) VALUES (CONVERT(varchar,@MinDate,101))

	SET @Counter =  @Counter +1 
	SET @MinDate = DATEADD(day,@Counter,@BookDate)
	

END

DELETE FROM @TempTab 
WHERE Dt IN (
SELECT CONVERT(varchar,AdjustmentDate,101) FROM TimeAdjustment
 WHERE AdjustmentValue = '+1D'
 AND CONVERT(varchar,AdjustmentDate,101) >= CONVERT(varchar,@MinDate,101)
 AND CONVERT(varchar,AdjustmentDate,101) <= CONVERT(varchar,@MaxDate,101))


DELETE FROM @TempTab
WHERE Dt IN (
			SELECT CONVERT(varchar,ValidOn,101) FROM WorkSessions 
			WHERE CONVERT(varchar,ValidOn,101) IN (SELECT Dt FROM @TempTab) AND CrewID = @CrewId 
			And VesselID = @VesselId)


DECLARE @RowCount int
SELECT @RowCount = COUNT(*) FROM @TempTab
IF( @RowCount = 14 )
BEGIN
	DELETE FROM @TempTab
END

SET @MinDate = DATEADD(day,-14,@BookDate)

print 'here'
print @MinDate
print @BookDate

DELETE FROM @TempTab
WHERE Dt <
(SELECT CONVERT(VARCHAR(10),MIN(ValidOn),101) FROM WorkSessions 
WHERE ValidOn <= CONVERT(DATETIME,@BookDate) 
AND ValidOn >= CONVERT(DATETIME,@MinDate)
AND Hours <> '000000000000000000000000000000000000000000000000'
AND CrewID =  @CrewId)


 

 








--SELECT * FROM @TempTab
---***********READING FORWARD DATES******************

DECLARE @ForwardMinDate Datetime
DECLARE @ForwardMaxDate Datetime
DECLARE @MaxBookDate Datetime


SET @ForwardMinDate = DATEADD(day,1,@BookDate)
SET @ForwardMaxDate = DATEADD(day,6,@BookDate)
SET @PlusOneDayAdvCnt =0


SELECT @PlusOneDayAdvCnt = COUNT(*) FROM TimeAdjustment
WHERE CONVERT(varchar,AdjustmentDate,101) >= CONVERT(varchar,@ForwardMinDate,101)
AND  CONVERT(varchar,AdjustmentDate,101) <= CONVERT(varchar,@ForwardMaxDate,101)

print @PlusOneDayAdvCnt
print @ForwardMaxDate

IF @PlusOneDayAdvCnt >=1 
BEGIN
	
	SET @ForwardMaxDate = DATEADD(day,@PlusOneDayAdvCnt,@ForwardMaxDate)

END
print @ForwardMaxDate


SELECT @MaxBookDate = MAX(ValidOn) FROM WorkSessions 
WHERE CrewID = @CrewId 
AND VesselID = @VesselId 
AND ValidOn <= @ForwardMaxDate

--print @MaxBookDate

IF @MaxBookDate < @ForwardMaxDate
BEGIN
	SET @ForwardMaxDate = @MaxBookDate
END
print @ForwardMaxDate
print @ForwardMinDate
SET @Counter = 1

WHILE @ForwardMinDate <= @ForwardMaxDate
BEGIN
    print CONVERT(varchar,@ForwardMinDate,110)
	print @Counter
	IF NOT EXISTS (SELECT * FROM WorkSessions WHERE CONVERT(varchar,ValidOn,101) = CONVERT(varchar,@ForwardMinDate,101) AND ActualHours NOT LIKE '0000,0000,0000,0000,0000,0000')
	BEGIN
	    
		INSERT INTO @TempTab(Dt) VALUES (CONVERT(varchar,@ForwardMinDate,101))
	END

	SET @Counter =  @Counter +1 
	SET @ForwardMinDate = DATEADD(day,@Counter,@BookDate)
	

END

IF @PlusOneDayAdvCnt >=1 
BEGIN

	DELETE FROM @TempTab WHERE Dt IN
	(SELECT CONVERT(varchar,AdjustmentDate,101) FROM TimeAdjustment
	 WHERE CONVERT(varchar,AdjustmentDate,101) >= CONVERT(varchar,@ForwardMinDate,101)
	 AND  CONVERT(varchar,AdjustmentDate,101) <= CONVERT(varchar,@ForwardMaxDate,101)) 

END


---*************************************************

SELECT Dt AS BlankDate FROM @TempTab

END

GO
/****** Object:  StoredProcedure [dbo].[stpGetRankFromGroup]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec stpGetRankFromGroup
CREATE PROCEDURE [dbo].[stpGetRankFromGroup]

(

	@RankId int, 
	@VesselID int

)

AS

BEGIN

	SELECT GroupId,VesselID FROM GroupRank

	WHERE RankID = @RankId
	AND VesselID=@VesselID
END

GO
/****** Object:  StoredProcedure [dbo].[stpGetRanksByID]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetRanksByID]
(
	@ID int,
	@VesselID int
)
AS
Begin
Select  ID,RankName,[Description],Scheduled, VesselID
FROM dbo.Ranks
WHERE ID= @ID
AND VesselID=@VesselID
End

GO
/****** Object:  StoredProcedure [dbo].[stpGetRanksPageWise]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetRanksPageWise]

 (

      @PageIndex INT = 1,

      @PageSize INT = 15,

      @RecordCount INT OUTPUT,

	  @VesselID int

)

AS

BEGIN

      SET NOCOUNT ON;

      SELECT ROW_NUMBER() OVER

      (

            ORDER BY [ID] ASC

      )AS RowNumber

      ,ID

      ,RankName

	  ,[Description]

	  ,Scheduled

	  ,[Order]
	  ,VesselID
	

     INTO #Results

      FROM Ranks

	

     

      SELECT @RecordCount = COUNT(*)

      FROM #Results

           

      SELECT * FROM #Results

      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1
	  AND VesselID=@VesselID

	  ORDER BY [Order] ASC

     

      DROP TABLE #Results

END

GO
/****** Object:  StoredProcedure [dbo].[stpGetRegimeById]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
		
End

GO
/****** Object:  StoredProcedure [dbo].[stpGetSecondWrokSessionsByCrewandDate]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetSecondWrokSessionsByCrewandDate]

(

	@CrewId int,
	@BookDate DateTime, 
	@VesselID int 

)

AS

BEGIN

   DECLARE @RowCnt INT
   SET @RowCnt = 0

    SELECT @RowCnt =  COUNT(*) FROM WorkSessions WS
	INNER JOIN NCDetails NCD
	ON WS.ID = NCD.WorkSessionId 
	WHERE WS.CrewId = @CrewId
	AND CONVERT(varchar(12),ValidOn,103) = CONVERT(varchar(12),@BookDate,103)
	AND NCD.VesselID=@VesselID


	IF @RowCnt = 2
	BEGIN

	SELECT TOP 1 *,NCD.NCDetailsID, NCD.VesselID,WS.ID,WS.Comment,WS.RegimeID FROM WorkSessions WS
	INNER JOIN NCDetails NCD
	ON WS.ID = NCD.WorkSessionId 
	WHERE WS.CrewId = @CrewId
	AND CONVERT(varchar(12),ValidOn,103) = CONVERT(varchar(12),@BookDate,103)
	AND NCD.VesselID=@VesselID
	ORDER BY Timestamp DESC

	END
	ELSE
	BEGIN

	SELECT '0000,0000,0000,0000,0000,0000' AS ActualHours, '' AS Comment, 0 AS ID,0 AS NCDetailsID,WS.RegimeID 
	FROM WorkSessions WS
	INNER JOIN NCDetails NCD
	ON WS.ID = NCD.WorkSessionId 
	WHERE WS.CrewId = @CrewId
	AND CONVERT(varchar(12),ValidOn,103) = CONVERT(varchar(12),@BookDate,103)
	AND NCD.VesselID=@VesselID
	ORDER BY Timestamp DESC


	END



END

GO
/****** Object:  StoredProcedure [dbo].[stpGetServiceTermsListPageWise]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  declare @x int Exec stpGetServiceTermsListPageWise  1,20, @x out           , 9876543
CREATE PROCEDURE [dbo].[stpGetServiceTermsListPageWise]
(
      @PageIndex INT = 1,
      @PageSize INT = 10,
      @RecordCount INT OUTPUT --,
	  --@VesselID int
)
AS
BEGIN
      SET NOCOUNT ON;
      SELECT ROW_NUMBER() OVER
      (
            ORDER BY [FirstName] ASC
      )AS RowNumber
      ,C.FirstName + ' ' +C.LastName AS Name
	  ,ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),STH.ActiveFrom,dbo.ufunc_GetDateFormat()), ' ','-'), ',',''), '-') ActiveFrom
	  ,ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),STH.ActiveTo,dbo.ufunc_GetDateFormat()), ' ','-'), ',',''), '-') ActiveTo
	 --,C.VesselID
INTO #Results
FROM Crew C INNER JOIN ServiceTermsHistory STH
ON C.ID = STH.CrewID




      SELECT @RecordCount = COUNT(*)
      FROM #Results           
      SELECT * FROM #Results
      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1
      --AND VesselID=@VesselID
      DROP TABLE #Results
END

GO
/****** Object:  StoredProcedure [dbo].[stpGetShipDetailsByID]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetShipDetailsByID]
AS
Begin
--Select  ID,ShipName,RIGHT('000000'+CAST(IMONumber AS VARCHAR(7)),7) AS IMONumber,FlagOfShip,Regime,RIGHT('000000'+CAST(IMONumber AS VARCHAR(7)),7) AS IMONumber
--,ShipEmail
--FROM dbo.Ship
Select  ID,

        ShipName,
	    FlagOfShip,
		RIGHT('000000'+CAST(IMONumber AS VARCHAR(7)),7) AS IMONumber,       
		Regime,

		VesselTypeID,
		VesselSubTypeID,
		VesselSubSubTypeID,

        ShipEmail,
		ShipEmail2,
		Voices1,
		Voices2,
		Fax1,
		Fax2,
		VOIP1,
		VOIP2,
		Mobile1,
		Mobile2

FROM dbo.Ship
	  

--WHERE ID= @ID

End


GO
/****** Object:  StoredProcedure [dbo].[stpGetShipDetailsPageWise]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetShipDetailsPageWise]

 (

      @PageIndex INT = 1,

      @PageSize INT = 10,

      @RecordCount INT OUTPUT

)

AS

BEGIN

      SET NOCOUNT ON;

      SELECT ROW_NUMBER() OVER

      (

            ORDER BY [ShipName] ASC

      )AS RowNumber

      ,ID

      ,ShipName

	  ,IMONumber

	  ,FlagOfShip

	  --,Regime

	

     INTO #Results

      FROM Ship

	

     

      SELECT @RecordCount = COUNT(*)

      FROM #Results

           

      SELECT * FROM #Results

      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

     

      DROP TABLE #Results

END

GO
/****** Object:  StoredProcedure [dbo].[stpGetShipMaster]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpGetShipMaster]

AS
Begin
select FirstName + ' ' + LastName As MName, RankName from Crew C
Inner join Ranks R
On C.RankId = R.ID
WHERE UPPER(RankName) LIKE '%MASTER%'
End

GO
/****** Object:  StoredProcedure [dbo].[stpGetTimeAdjustment]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpGetTimeAdjustment]

(

	@BookDate Datetime,
	@VesselID int

)

AS



Begin







IF EXISTS (SELECT 1 FROM TimeAdjustment WHERE  CONVERT(varchar(12),AdjustmentDate,103)=  CONVERT(varchar(12),@BookDate,103) AND VesselID = @VesselID )

BEGIN

		Select isnull(AdjustmentValue,0) AS AdjustmentValue

		from dbo.TimeAdjustment  

		WHERE  CONVERT(varchar(12),AdjustmentDate,101) =  CONVERT(varchar(12),@BookDate,101) 
		AND VesselID = @VesselID

END

ELSE

BEGIN

	if exists (select top 1 'a' from TimeAdjustment where DATEADD(day,1, CONVERT(date, CONVERT(varchar(12),AdjustmentDate,106))) =  (convert(date,CONVERT(varchar(12),@BookDate,106)) ) and AdjustmentValue = '+1d')

	begin

		SELECT 'BOOKING_NOT_ALLOWED' AS AdjustmentValue

	end

	else

	begin

		SELECT 0 AS AdjustmentValue

	end

END

End

GO
/****** Object:  StoredProcedure [dbo].[stpGetTimeAdjustmentDetailsPageWise]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetTimeAdjustmentDetailsPageWise]

 (

      @PageIndex INT = 1,

      @PageSize INT = 10,

      @RecordCount INT OUTPUT,
	  @VesselID int

)

AS

BEGIN

      SET NOCOUNT ON;

      SELECT ROW_NUMBER() OVER

      (

            ORDER BY [AdjustmentDate] ASC

      )AS RowNumber

     -- ,AdjustmentDate

      ,AdjustmentValue

	--,CONVERT(varchar(12),AdjustmentDate,dbo.ufunc_GetDateFormat()) AdjustmentDate
	 ,ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),AdjustmentDate,dbo.ufunc_GetDateFormat()), ' ','-'), ',',''), '-') AdjustmentDate
	,VesselID

     INTO #Results

      FROM TimeAdjustment

	

     

      SELECT @RecordCount = COUNT(*)

      FROM #Results

           

      SELECT * FROM #Results

      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

     AND VesselID=@VesselID

      DROP TABLE #Results

END

GO
/****** Object:  StoredProcedure [dbo].[stpGetUserDetailsByCrewID]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetUserDetailsByCrewID]
(
   @CrewID int
   
)
AS
BEGIN

	IF EXISTS(SELECT 1 FROM Users WHERE CrewId = @CrewID)
	BEGIN
		SELECT UserName,Password,ID 
		FROM Users
		WHERE CrewId= @CrewID
		--AND Active=1
	END

END

GO
/****** Object:  StoredProcedure [dbo].[stpGetUserGroupsByUserID]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetUserGroupsByUserID]

(

	@UserID int
	--@VesselID int

)

AS



Begin



Select  GroupID,G.GroupName--, G.VesselID

FROM UserGroups UG

INNER JOIN Groups G

ON UG.GroupID = G.ID

WHERE UserID= @UserID
--AND G.VesselID=@VesselID

End

GO
/****** Object:  StoredProcedure [dbo].[stpGetUsersDetailsPageWise]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetUsersDetailsPageWise]

 (

      @PageIndex INT = 1,

      @PageSize INT = 10,

      @RecordCount INT OUTPUT,

	  @VesselID int

)

AS

BEGIN

      SET NOCOUNT ON;

      SELECT ROW_NUMBER() OVER

      (

            ORDER BY [Username] ASC

      )AS RowNumber

      ,ID

      ,Username

	  ,Active

	,VesselID

     INTO #Results

      FROM Users

     

      SELECT @RecordCount = COUNT(*)

      FROM #Results

           

      SELECT * FROM #Results

      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

     AND VesselID=@VesselID

      DROP TABLE #Results

END

GO
/****** Object:  StoredProcedure [dbo].[stpGetWorkingHours]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec stpGetWorkingHours 5, 2
--ALTER PROCEDURE [dbo].[stpGetRanksByID]
CREATE PROCEDURE [dbo].[stpGetWorkingHours]
(
	@DayNumber int,
	@RegimeID int
)
AS
Begin
Select WorkHours
FROM dbo.WorkingHours
WHERE DayNumber= @DayNumber
--AND RegimeID=@RegimeID
End

GO
/****** Object:  StoredProcedure [dbo].[stpGetWorkSessionsByValidOn]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DECLARE @X DECIMAL(5,2)
--EXEC stpGetWorkSessionsByValidOn 08,10,2018,19,@X OUTPUT
--PRINT @X
CREATE PROCEDURE [dbo].[stpGetWorkSessionsByValidOn]
(
	@day int,
	@month int,
	@year int,
	@CrewId int,
	@SevenDayRest varchar(10) OUTPUT
)
AS
Begin

--DECLARE @day int 
--SET @day =1

DECLARE @ValidOn datetime
DECLARE @SubstractedDate datetime
DECLARE @SubstractorFactor int
DECLARE @RecordCount int

SET @ValidOn = dateadd(mm, (@year - 1900) * 12 + @month - 1 , @day - 1)

SET @RecordCount =0
/*
DECLARE @RestHoursTab TABLE
(
	_id int IDENTITY ,
	_ValidOn datetime,
	_hours nchar(48),
	_zerocnt int,
	_resthours decimal(5,2)
)

--DECLARE @TempTabRecordCount int
--DECLARE @RecordDifference int
--DECLARE @FurthestDate datetime
--DECLARE @NewCheckDate datetime
--DECLARE @Counter int



IF @day >= 1 AND @day <8
BEGIN
	SET @SubstractorFactor = 1
END
ELSE
BEGIN
	SET @SubstractorFactor =@day - 6
END

--print @month
SET @SubstractedDate = datefromparts(@year,@month,@SubstractorFactor)
print @SubstractedDate

IF @SubstractorFactor = 1
BEGIN

	SELECT @RecordCount = COUNT(s.CrewID)
	from NCDetails s
	WHERE s.CrewID=@CrewId
	AND OccuredOn BETWEEN  DATEADD(day,-6,@SubstractedDate) AND @SubstractedDate

	--SELECT COUNT(s.CrewID)
	--from NCDetails s
	--WHERE s.CrewID=@CrewId
	--AND OccuredOn BETWEEN  DATEADD(day,-6,@SubstractedDate) AND @SubstractedDate

	
	IF @RecordCount > 1
	BEGIN
		INSERT INTO @RestHoursTab(_resthours,_ValidOn)
		SELECT 
		CONVERT(decimal(5,2),m.c.value('.','varchar(max)')) ,s.OccuredOn
		from NCDetails s
		cross apply s.ComplianceInfo.nodes('//ncdetails/minsevendaysrest') as m(c)
		WHERE s.CrewID=@CrewId
		AND OccuredOn BETWEEN  DATEADD(day,-6, @ValidOn) AND @ValidOn
		ORDER BY s.OccuredOn

		

		
		

			

	END
	ELSE
	BEGIN
		INSERT INTO @RestHoursTab(_resthours,_ValidOn) VALUES (0.0,@ValidOn)
	END


	
END
ELSE
BEGIN
	SELECT @RecordCount = COUNT(s.CrewID)
	from NCDetails s
	WHERE s.CrewID=@CrewId
	AND OccuredOn BETWEEN  DATEADD(day,-6,@SubstractedDate) AND @ValidOn

	
	IF @RecordCount <> 0
	BEGIN
	INSERT INTO @RestHoursTab(_resthours,_ValidOn)
		SELECT 
		CONVERT(decimal(5,2),m.c.value('.','varchar(max)')) ,s.OccuredOn
		from NCDetails s
		cross apply s.ComplianceInfo.nodes('//ncdetails/minsevendaysrest') as m(c)
		WHERE s.CrewID=@CrewId
		AND OccuredOn BETWEEN  DATEADD(day,-6, @ValidOn) AND @ValidOn
		ORDER BY s.OccuredOn

		

	END
	ELSE
	BEGIN
		INSERT INTO @RestHoursTab(_resthours,_ValidOn) VALUES (0.0,@ValidOn)
	END

END

UPDATE @RestHoursTab SET _resthours=0 WHERE _resthours=200


SELECT TOP 1  @SevenDayRest = _resthours 
 FROM @RestHoursTab a
 ORDER BY _ValidOn DESC



		


         --SELECT * FROM @RestHoursTab ORDER BY _ValidOn DESC

		 */



		SELECT @SevenDayRest=
		CASE
			WHEN ComplianceInfo.value('(/ncdetails/minsevendaysrest)[1]','varchar(10)') = '200' Then '-'
			ELSE ComplianceInfo.value('(/ncdetails/minsevendaysrest)[1]','varchar(10)')
		END 
		from NCDetails s
		WHERE s.CrewID=@CrewId
		--AND OccuredOn = @ValidOn
		AND ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),OccuredOn,dbo.ufunc_GetDateFormat()), ' ','-'), ',',''), '-') = ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),@ValidOn,dbo.ufunc_GetDateFormat()), ' ','-'), ',',''), '-')
		ORDER BY s.OccuredOn



END

GO
/****** Object:  StoredProcedure [dbo].[stpGetWrokSessionsByCrewandDate]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetWrokSessionsByCrewandDate]

(

	@CrewId int,
	@BookDate DateTime, 
	@VesselID int 

)

AS

BEGIN



	SELECT TOP 1 *,NCD.NCDetailsID, NCD.VesselID,WS.ID,WS.Comment,WS.RegimeID FROM WorkSessions WS

	INNER JOIN NCDetails NCD

	ON WS.ID = NCD.WorkSessionId 

	WHERE WS.CrewId = @CrewId

	AND CONVERT(varchar(12),ValidOn,103) = CONVERT(varchar(12),@BookDate,103)
	AND NCD.VesselID=@VesselID
	ORDER BY Timestamp 



END

GO
/****** Object:  StoredProcedure [dbo].[stpGetWrokSessionsByDate]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec stpGetWrokSessionsByDate 12,2018,8940557,1

CREATE PROCEDURE [dbo].[stpGetWrokSessionsByDate]

(

	@Month int,
	@Year int,
	@VesselID int,
	@UserID int

)

AS

BEGIN

	Declare @SuperAdminID int
	Declare @UserGroupID int 
	DECLARE @Crewtab TABLE
	(
		CrewId int
	)

	Select @SuperAdminID = ID from Groups Where GroupName = 'Super Admin'

	Select @UserGroupID = GroupID from UserGroups Where UserID = @UserID

	if @UserGroupID = @SuperAdminID
	Begin

	INSERT INTO @Crewtab(CrewId)
	Select DISTINCT ID --, FirstName + '  ' +LastName AS Name, VesselID
	from dbo.Crew
	Where VesselID=@VesselID 
	--and ID IN (8,10)
	
    AND C.IsActive=1
	End
	Else 
	Begin

	INSERT INTO @Crewtab(CrewId)
	Select ID --, FirstName + '  ' +LastName AS Name, C.VesselID
	from dbo.Crew C
	Left Outer Join DepartmentAdmin DA
	ON C.ID = DA.CrewID
	Where C.VesselID= @VesselID 
	And DA.CrewID = (Select CrewID From Users Where ID = @UserID)
	AND Deletiondate >= GetDate()

	AND C.IsActive=1

	Union 

	Select ID --, FirstName + '  ' +LastName AS Name, C.VesselID
	from dbo.Crew C
	Left Outer Join DepartmentAdmin DA
	ON C.ID = DA.CrewID
	Where C.VesselID= @VesselID 
	And C.DepartmentMasterID IN (Select DepartmentMasterID From DepartmentAdmin Where CrewID = (Select CrewID From Users Where ID = @UserID))
	  AND Deletiondate >= GetDate()

	  AND C.IsActive=1

	Union

	Select ID --, FirstName + '  ' +LastName AS Name, C.VesselID
	from dbo.Crew C
	--Left Outer Join DepartmentAdmin DA
	--ON C.ID = DA.CrewID
	Where C.VesselID= @VesselID 
	--And C.DepartmentMasterID = (Select DepartmentMasterID From DepartmentAdmin Where CrewID = 5)
	And C.ID = (Select CrewID From Users Where ID = @UserID)
	  AND Deletiondate >= GetDate()

	  AND C.IsActive=1
	End
    

	DECLARE @SelectedDay DateTime
	SET @SelectedDay =  datefromparts(@Year, @Month, 1)

	SELECT *,NCD.NCDetailsID,C.FirstName + ' ' + C.LastName AS CrewName, WS.VesselID,RegimeName,
	 CASE 
	   WHEN DAY(ValidOn) < 10 THEN '0' + DAY(ValidOn)
	   ELSE DAY(ValidOn)
	END As DateNumber FROM WorkSessions WS
	INNER JOIN NCDetails NCD
	ON WS.ID = NCD.WorkSessionId 
	INNER JOIN Crew C
	ON C.ID = NCD.CrewID
	INNER JOIN Regimes REG
	ON REG.ID = WS.RegimeID
	WHERE MONTH(@SelectedDay) = MONTH(ValidOn)
	AND YEAR(@SelectedDay) =  YEAR(ValidOn)
	AND WS.VesselID=@VesselID
	AND C.ID IN (SELECT CrewId FROm @Crewtab)

	AND C.IsActive=1
	ORDER BY NCD.CrewID,DateNumber,WS.Timestamp DESC



END

GO
/****** Object:  StoredProcedure [dbo].[stpImportCrew]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpImportCrew]
(
	@WatchKeeper bit,
	@notes varchar(2000),
	@Overtime bit,
	@EmployeeNum nvarchar(25),
	@Rank nvarchar(50),
	@FirstName varchar(100),
	@MiddleName varchar(100),
	@LastName varchar(50),
	@DOB datetime,
	@POB nvarchar(20),
	@PassportBook nvarchar(20),
	@Seaman nvarchar(20),
	@Country varchar(20),
	@VesselId int,
	@Gender varchar(20),
	@IssuingStateOfIdentityDocument varchar(500),
	@ExpiryDateOfIdentityDocument datetime,
	@CreatedOn datetime,
	@LatestUpdate datetime,
	@Department varchar(500)
)
AS
BEGIN

DECLARE @RecCnt int
SET @RecCnt = 0 

SELECT @RecCnt = COUNT(*) FROM Crew 
WHERE LTRIM(RTRIM(UPPER(FirstName))) = LTRIM(RTRIM(UPPER(@FirstName)))
AND LTRIM(RTRIM(UPPER(LastName))) = LTRIM(RTRIM(UPPER(@LastName)))
AND CONVERT(VARCHAR(10),DOB,102) = CONVERT(VARCHAR(10),@DOB,102)
AND  LTRIM(RTRIM(UPPER(PassportSeamanPassportBook))) = LTRIM(RTRIM(UPPER(@PassportBook))) 
--AND LTRIM(RTRIM(UPPER(Seaman))) = LTRIM(RTRIM(UPPER(@Seaman))) 




IF @RecCnt = 0
BEGIN
BEGIN TRY
	BEGIN TRAN

   DECLARE @RankId int
   DECLARE @RankOrder int
   DECLARE @MAXCREWVAL int
   DECLARE @YearValue varchar(4)
   SET @RankId = 0
   SET @RankOrder = 0


   SELECT @YearValue = YEAR(GETDATE()) 
   SELECT @MAXCREWVAL =  COUNT(*) FROM Crew
	IF @MAXCREWVAL = 0
	BEGIN
		SET @MAXCREWVAL = 1
	END
	ELSE
	BEGIN
		SET @MAXCREWVAL = @MAXCREWVAL + 1
	END
	SET @EmployeeNum = CAST(@MAXCREWVAL AS VARCHAR(4)) + '/' + CAST(@YearValue AS VARCHAR(4))

   SELECT @RankId = ID FROM Ranks WHERE RTRIM(LTRIM(UPPER(RankName))) = RTRIM(LTRIM(UPPER(@Rank)))
   SELECT @RankOrder = MAX([Order]) FROM Ranks 

   SET @RankOrder = @RankOrder + 1

   IF @RankId <= 0 OR @RankId IS NULL
   BEGIN

    INSERT INTO Ranks(RankName,[Order],Deleted,LatestUpdate,VesselID) VALUES (@Rank,@RankOrder,0,getdate(),@VesselId)
	SET @RankId = @@IDENTITY

	INSERT INTO GroupRank(GroupID,RankID,VesselID)
	VALUES (15,@RankId,@VesselId)

   END


   DECLARE @CountryID int
   SET @CountryID = 0 

   SELECT @CountryID = CountryID FROM CountryMaster WHERE LTRIM(RTRIM(UPPER(CountryName))) = LTRIM(RTRIM(UPPER(@Country)))

   IF @CountryID <=0 OR @CountryID IS NULL
   BEGIN

   INSERT INTO CountryMaster(CountryName,CountryCode) VALUES (@Country,'ZZZ')
   SET @CountryID = @@IDENTITY
   END


   --------------------------------
      DECLARE @DepartmentMasterID int
   SET @DepartmentMasterID = 0 

   SELECT @DepartmentMasterID = DepartmentMasterID FROM DepartmentMaster WHERE LTRIM(RTRIM(UPPER(DepartmentMasterName))) = LTRIM(RTRIM(UPPER(@Department)))

   IF @DepartmentMasterID <=0 OR @DepartmentMasterID IS NULL
   BEGIN

   INSERT INTO DepartmentMaster(DepartmentMasterName,DepartmentMasterCode,IsActive,VesselID) VALUES (@Department,'ZZZ',1,@VesselId)
   SET @DepartmentMasterID = @@IDENTITY
   END
   ---------------------------------


   INSERT INTO Crew(Watchkeeper,Notes,Deleted,LatestUpdate,CreatedOn,OvertimeEnabled,EmployeeNumber,RankID,FirstName,MiddleName,LastName,DOB,POB,PassportSeamanPassportBook,Seaman,IsActive,VesselID,CountryID,DeactivationDate,DeletionDate,Gender,  IssuingStateOfIdentityDocument, ExpiryDateOfIdentityDocument, DepartmentMasterID)
   VALUES(@WatchKeeper,@notes,0,@LatestUpdate,@CreatedOn,@Overtime,@EmployeeNum,@RankId,@FirstName,@MiddleName,@LastName,@DOB,@POB,@PassportBook,@Seaman,1,@VesselId,@CountryID,'9999-12-31 00:00:00.000','9999-12-31 00:00:00.000',@Gender,  @IssuingStateOfIdentityDocument, @ExpiryDateOfIdentityDocument, @DepartmentMasterID)
  

  ------------------------------
   DECLARE @CrewId int
SET @CrewId = @@IDENTITY
INSERT INTO ServiceTerms(ActiveFrom,ActiveTo,CrewID,RankID,Deleted,VesselID) VALUES
(@CreatedOn,@LatestUpdate,@CrewId,@RankID,0,@VesselID)
   ------------------------------


   COMMIT TRAN

END TRY
BEGIN CATCH
	ROLLBACK TRAN
END CATCH
END
END

GO
/****** Object:  StoredProcedure [dbo].[stpImportCrewRegimeTR]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpImportCrewRegimeTR]
( 
@CrewID int,
@RegimeID int,
@StartDate datetime,
@EndDate datetime,
@VesselID int
) 
AS 
BEGIN 
IF NOT EXISTS(SELECT 1 from CrewRegimeTR Where CrewID=@CrewID) 
BEGIN   
SET IDENTITY_INSERT CrewRegimeTR ON
INSERT INTO CrewRegimeTR 
            (CrewID,RegimeID,StartDate,EndDate  ,VesselID)

Values(@CrewID,@RegimeID,@StartDate,@EndDate  ,@VesselID)
SET IDENTITY_INSERT CrewRegimeTR OFF
END
Else
BEGIN
UPDATE CrewRegimeTR
SET CrewID=@CrewID,RegimeID=@RegimeID,StartDate=@StartDate,EndDate=@EndDate,VesselID=@VesselID
Where CrewID=@CrewID
END
END

GO
/****** Object:  StoredProcedure [dbo].[stpImportDepartmentAdmin]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpImportDepartmentAdmin] 
( 
@DepartmentAdminID int,
@DepartmentMasterID int,
@CrewID int,
@IsActive bit,
@PositionEndDate datetime,
@IsAdmin bit,
@ReportsTo int,
@VesselID int
) 
AS 
BEGIN 
IF NOT EXISTS(SELECT 1 from DepartmentAdmin Where DepartmentAdminID=@DepartmentAdminID) 
BEGIN   
SET IDENTITY_INSERT DepartmentAdmin ON
INSERT INTO DepartmentAdmin 
            (DepartmentAdminID,DepartmentMasterID,CrewID,IsActive,PositionEndDate,IsAdmin,ReportsTo,VesselID)

Values(@DepartmentAdminID,@DepartmentMasterID,@CrewID,@IsActive,@PositionEndDate,@IsAdmin,@ReportsTo,@VesselID)
SET IDENTITY_INSERT DepartmentAdmin OFF
END
ELSE
BEGIN
UPDATE DepartmentAdmin
SET DepartmentMasterID=@DepartmentMasterID,CrewID=@CrewID,IsActive=@IsActive,
    PositionEndDate=@PositionEndDate,IsAdmin=@IsAdmin,ReportsTo=@ReportsTo,VesselID=@VesselID
Where DepartmentAdminID=@DepartmentAdminID
END
END

GO
/****** Object:  StoredProcedure [dbo].[stpImportDepartmentMaster]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpImportDepartmentMaster] 
( 
@DepartmentMasterID int,
@DepartmentMasterName varchar(50),
@DepartmentMasterCode varchar(10),
@IsActive bit,
@VesselID int
) 
AS 
BEGIN 
IF NOT EXISTS(SELECT 1 from DepartmentMaster Where DepartmentMasterID=@DepartmentMasterID) 
BEGIN   
SET IDENTITY_INSERT DepartmentMaster ON
INSERT INTO DepartmentMaster 
            (DepartmentMasterID,DepartmentMasterName,DepartmentMasterCode,IsActive,VesselID)

Values(@DepartmentMasterID,@DepartmentMasterName,@DepartmentMasterCode,@IsActive,@VesselID)
SET IDENTITY_INSERT DepartmentMaster OFF
END
Else
BEGIN
UPDATE DepartmentMaster
SET DepartmentMasterName=@DepartmentMasterName,DepartmentMasterCode=@DepartmentMasterCode,IsActive=@IsActive,VesselID=@VesselID
Where DepartmentMasterID=DepartmentMasterID
END
END

GO
/****** Object:  StoredProcedure [dbo].[stpImportFirstRun]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpImportFirstRun]
( 
@RunCount int
) 
AS 
BEGIN 
--IF @ID IS NULL
BEGIN   
--SET IDENTITY_INSERT FirstRun ON
INSERT INTO FirstRun 
            (RunCount)

Values(@RunCount)
--SET IDENTITY_INSERT FirstRun OFF
END

BEGIN
UPDATE FirstRun
SET RunCount=@RunCount
--Where DepartmentMasterID=DepartmentMasterID
END

END

GO
/****** Object:  StoredProcedure [dbo].[stpImportGroupRank]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpImportGroupRank]
( 
@ID int,
@GroupID int,
@RankID int,
@VesselID int
) 
AS 
BEGIN 
IF NOT EXISTS(SELECT 1 from GroupRank Where ID=@ID) 
BEGIN   
SET IDENTITY_INSERT GroupRank ON
INSERT INTO GroupRank 
            (ID,GroupID,RankID,VesselID)

Values(@ID,@GroupID,@RankID,@VesselID)
SET IDENTITY_INSERT GroupRank OFF
END
Else
BEGIN
UPDATE GroupRank
SET GroupID=@GroupID,RankID=@RankID,VesselID=@VesselID
Where ID=@ID
END

END

GO
/****** Object:  StoredProcedure [dbo].[stpImportGroups]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpImportGroups]
( 
@ID int,
@GroupName nvarchar(50),
@AllowDelete bit,
@VesselID int
) 
AS 
BEGIN 
IF NOT EXISTS(SELECT 1 from Groups Where ID=@ID) 
BEGIN   
SET IDENTITY_INSERT Groups ON
INSERT INTO Groups 
            (ID,GroupName,AllowDelete,VesselID)

Values(@ID,@GroupName,@AllowDelete,@VesselID)
SET IDENTITY_INSERT Groups OFF
END
Else
BEGIN
UPDATE Groups
SET GroupName=@GroupName,AllowDelete=@AllowDelete,VesselID=@VesselID
Where ID=@ID
END

END

GO
/****** Object:  StoredProcedure [dbo].[stpImportNCDetails]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpImportNCDetails] 
( 
@NCDetailsID int,
@CrewID int,
@OccuredOn datetime,
@ComplianceInfo xml,
@TotalNCHours float,
@WorkSessionId int,
@isNC bit,
@VesselID int
) 
AS 
BEGIN 
IF NOT EXISTS(SELECT 1 from NCDetails Where NCDetailsID=@NCDetailsID) 
BEGIN   
SET IDENTITY_INSERT NCDetails ON
INSERT INTO NCDetails 
            (NCDetailsID,CrewID,OccuredOn,ComplianceInfo,TotalNCHours,WorkSessionId,isNC,VesselID)

Values(@NCDetailsID,@CrewID,@OccuredOn,@ComplianceInfo,@TotalNCHours,@WorkSessionId,@isNC,@VesselID)
SET IDENTITY_INSERT NCDetails OFF
END
else
BEGIN
UPDATE NCDetails
SET CrewID=@CrewID,OccuredOn=@OccuredOn,ComplianceInfo=@ComplianceInfo,TotalNCHours=@TotalNCHours,WorkSessionId=@WorkSessionId,isNC=@isNC,VesselID=@VesselID
Where NCDetailsID=@NCDetailsID
END

END

GO
/****** Object:  StoredProcedure [dbo].[stpImportRank]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpImportRank] 
( 
@ID int,
@RankName nvarchar(50),
@Description nvarchar(200),
@Order int,
@ScheduleID int,
@Deleted bit,
@LatestUpdate datetime,
@DefaultScheduleComments nvarchar(200),
@Scheduled bit,
@VesselID int
) 
AS 
BEGIN 
IF NOT EXISTS(SELECT 1 from Ranks Where ID=@ID) 
BEGIN   
SET IDENTITY_INSERT Ranks ON
INSERT INTO Ranks 
            (ID,RankName,[Description],[Order],ScheduleID,Deleted,LatestUpdate,DefaultScheduleComments,Scheduled,VesselID)

Values(@ID,@RankName,@Description,@Order,@ScheduleID,@Deleted,@LatestUpdate,@DefaultScheduleComments,@Scheduled,@VesselID)
SET IDENTITY_INSERT Ranks OFF
END
else
BEGIN
UPDATE Ranks
SET RankName=@RankName,Description=@Description,[Order]=@Order,ScheduleID=@ScheduleID,Deleted=@Deleted,LatestUpdate=@LatestUpdate,DefaultScheduleComments=@DefaultScheduleComments,Scheduled=@Scheduled,VesselID=@VesselID
Where ID=@ID
END

END

GO
/****** Object:  StoredProcedure [dbo].[stpImportRegimes]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpImportRegimes]
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
@ManilaExceptions bit,
@UseHistCalculationOnly bit,
@CheckOnlyWorkHours bit,
@VesselID int
) 
AS 
BEGIN 
IF NOT EXISTS(SELECT 1 from Regimes Where ID=@ID) 
BEGIN   
SET IDENTITY_INSERT Regimes ON
INSERT INTO Regimes 
            (ID,RegimeName,Description,Basis,MinTotalRestIn7Days,MaxTotalWorkIn24Hours,MinContRestIn24Hours,MinTotalRestIn24Hours,
			MaxTotalWorkIn7Days,CheckFor2Days,OPA90,ManilaExceptions,UseHistCalculationOnly,CheckOnlyWorkHours,VesselID)

Values(@ID,@RegimeName,@Description,@Basis,@MinTotalRestIn7Days,@MaxTotalWorkIn24Hours,@MinContRestIn24Hours,@MinTotalRestIn24Hours,
			@MaxTotalWorkIn7Days,@CheckFor2Days,@OPA90,@ManilaExceptions,@UseHistCalculationOnly,@CheckOnlyWorkHours,@VesselID)
SET IDENTITY_INSERT Regimes OFF
END
else
BEGIN
UPDATE Regimes
SET RegimeName=@RegimeName,Description=@Description,Basis=@Basis,MinTotalRestIn7Days=@MinTotalRestIn7Days,MaxTotalWorkIn24Hours=@MaxTotalWorkIn24Hours,MinContRestIn24Hours=@MinContRestIn24Hours,MinTotalRestIn24Hours=@MinTotalRestIn24Hours,
			MaxTotalWorkIn7Days=@MaxTotalWorkIn7Days,CheckFor2Days=@CheckFor2Days,OPA90=@OPA90,ManilaExceptions=@ManilaExceptions,UseHistCalculationOnly=@UseHistCalculationOnly,CheckOnlyWorkHours=@CheckOnlyWorkHours,VesselID=@VesselID
Where ID=@ID
END

END

GO
/****** Object:  StoredProcedure [dbo].[stpImportServiceTerms]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpImportServiceTerms]
( 
@ID int,
@ActiveFrom datetime,
@ActiveTo datetime,
@CrewID int,
@OvertimeID int,
@ScheduleID int,
@RankID int,
@Deleted bit,
@VesselID int
) 
AS 
BEGIN 
IF NOT EXISTS(SELECT 1 from ServiceTerms Where ID=@ID) 
BEGIN   
SET IDENTITY_INSERT ServiceTerms ON
INSERT INTO ServiceTerms 
            (ID,ActiveFrom,ActiveTo,CrewID,OvertimeID,ScheduleID,RankID,Deleted,VesselID)

Values(@ID,@ActiveFrom,@ActiveTo,@CrewID,@OvertimeID,@ScheduleID,@RankID,@Deleted,@VesselID)
SET IDENTITY_INSERT ServiceTerms OFF
END
else
BEGIN
UPDATE ServiceTerms
SET ActiveFrom=@ActiveFrom,ActiveTo=@ActiveTo,CrewID=@CrewID,OvertimeID=@OvertimeID,ScheduleID=@ScheduleID,RankID=@RankID,Deleted=@Deleted,VesselID=@VesselID
Where ID=@ID
END

END

GO
/****** Object:  StoredProcedure [dbo].[stpImportShip]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpImportShip]
( 
@ID int,
@ShipName nvarchar(21),
@IMONumber int,
@FlagOfShip nvarchar(50),
@Regime int
) 
AS 
BEGIN 
IF NOT EXISTS(SELECT 1 from Ship Where ID=@ID) 
BEGIN   
SET IDENTITY_INSERT Ship ON
INSERT INTO Ship 
            (ID,ShipName,IMONumber,FlagOfShip,Regime)

Values(@ID,@ShipName,@IMONumber,@FlagOfShip,@Regime)
SET IDENTITY_INSERT Ship OFF
END
else
BEGIN
UPDATE Ship
SET ShipName=@ShipName,IMONumber=@IMONumber,FlagOfShip=@FlagOfShip,Regime=@Regime
Where ID=@ID
END

END

GO
/****** Object:  StoredProcedure [dbo].[stpImportUserGroups]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpImportUserGroups]
( 
@ID int,
@UserID int,
@GroupID int,
@VesselID int
) 
AS 
BEGIN 
IF NOT EXISTS(SELECT 1 from UserGroups Where ID=@ID) 
BEGIN   
SET IDENTITY_INSERT UserGroups ON
INSERT INTO UserGroups 
            (ID,UserID,GroupID,VesselID)

Values(@ID,@UserID,@GroupID,@VesselID)
SET IDENTITY_INSERT UserGroups OFF
END
else
BEGIN
UPDATE UserGroups
SET UserID=@UserID,GroupID=@UserID,VesselID=@VesselID
Where ID=@ID
END

END

GO
/****** Object:  StoredProcedure [dbo].[stpImportUsers]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpImportUsers]
( 
@ID int,
@Username nvarchar(200),
@Password nvarchar(200),
@Active bit,
@AllowDelete bit,
@CrewId int,
@VesselID int
) 
AS 
BEGIN 
IF NOT EXISTS(SELECT 1 from Users Where ID=@ID) 
BEGIN   
SET IDENTITY_INSERT Users ON
INSERT INTO Users 
            (ID,Username,Password,Active,AllowDelete,CrewId,VesselID)

Values(@ID,@Username,@Password,@Active,@AllowDelete,@CrewId,@VesselID)
SET IDENTITY_INSERT Users OFF
END
else
BEGIN
UPDATE Users
SET Username=@Username,Password=@Password,Active=@Active,AllowDelete=@AllowDelete,CrewId=@CrewId,VesselID=@VesselID
Where ID=@ID
END

END

GO
/****** Object:  StoredProcedure [dbo].[stpImportWorkSessions]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpImportWorkSessions] 
( 
@ID int,
@CrewID int,
@ValidOn datetime,
@Hours nchar(48),
@Increment int,
@Comment nvarchar(200),
@LatestUpdate datetime,
@Deleted bit,
@ActualHours nvarchar(200),
@TimeAdjustment nvarchar(50),
@AdjustmentFator varchar(10),
@VesselID int
) 
AS 
BEGIN 
IF NOT EXISTS(SELECT 1 from WorkSessions Where ID=@ID) 
BEGIN   
SET IDENTITY_INSERT WorkSessions ON
INSERT INTO WorkSessions 
            (ID,CrewID,ValidOn,Hours,Increment,Comment,LatestUpdate,Deleted,ActualHours,TimeAdjustment,
			AdjustmentFator,VesselID)

Values(@ID,@CrewID,@ValidOn,@Hours,@Increment,@Comment,@LatestUpdate,@Deleted,@ActualHours,@TimeAdjustment,
			@AdjustmentFator,@VesselID)
SET IDENTITY_INSERT WorkSessions OFF
END
else
BEGIN
UPDATE WorkSessions
SET CrewID=@CrewID,ValidOn=@ValidOn,Hours=@Hours,Increment=@Increment,Comment=@Comment,LatestUpdate=@LatestUpdate,Deleted=@Deleted,ActualHours=@ActualHours,TimeAdjustment=@TimeAdjustment,
			AdjustmentFator=@AdjustmentFator,VesselID=@VesselID
Where ID=@ID
END

END

GO
/****** Object:  StoredProcedure [dbo].[stpImportWorkSessionsApprovalData]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[stpImportWorkSessionsApprovalData]
( 
@Comments varchar(500),
@isApproved bit,
@VesselID int,
@CrewID int,
@ID int
) 
AS 
BEGIN 

UPDATE WorkSessions
SET Comments=@Comments,isApproved=@isApproved
Where ID = @ID
-- VesselID=@VesselID
AND CrewID=@CrewID 
--AND ValidOn=@ValidOn
--END
END

GO
/****** Object:  StoredProcedure [dbo].[stpInsertEquipmentStock]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpInsertEquipmentStock]
(
	@XMLDoc XML
)
AS
BEGIN
	
		DECLARE @XMLDocPointer INT      

        EXEC sp_xml_preparedocument @XMLDocPointer OUTPUT, @XMLDoc


		INSERT INTO tblEquipments(EquipmentsName,Comment,Quantity,ExpiryDate,Location)
		SELECT EquipmentsName,Comment,Quantity,ExpiryDate,Location
		FROM OPENXML(@XMLDocPointer,'/NewDataSet/Equipments',2)
		WITH
		(
			EquipmentsName varchar(500),
	        Comment varchar(500),
	        Quantity varchar(50),
         	ExpiryDate varchar(50),
			Location varchar(50)
		)


END

GO
/****** Object:  StoredProcedure [dbo].[stpInsertMedicineStock]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpInsertMedicineStock]
(
	@XMLDoc XML
)
AS
BEGIN
	
		DECLARE @XMLDocPointer INT      

        EXEC sp_xml_preparedocument @XMLDocPointer OUTPUT, @XMLDoc


		INSERT INTO tblMedicine(MedicineName,Quantity,ExpiryDate,Location)
		SELECT MedicineName,Quantity,ExpiryDate,Location
		FROM OPENXML(@XMLDocPointer,'/NewDataSet/Medicine',2)
		WITH
		(
			MedicineName varchar(500),
			Quantity varchar(500),
			ExpiryDate varchar(50),
			Location varchar(50)

		)


END

GO
/****** Object:  StoredProcedure [dbo].[stpLastBookedSession]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec stpLastBookedSession 18,9876543,'07/10/2018'

CREATE PROCEDURE [dbo].[stpLastBookedSession]
(
	@CrewId int,
	@VesselID int,
	@CopyDate datetime
)
AS
BEGIN
	SELECT * FROM WorkSessions
	WHERE CrewId = @CrewId
	AND VesselID=@VesselID
	AND CONVERT(varchar(12),ValidOn,103) = (
		SELECT TOP 1 CONVERT(varchar(12),VAlidOn,103)  
	FROM WorkSessions 
	WHERE CrewID = @CrewId
	AND VesselID=@VesselID
	AND ValidOn = @CopyDate
	ORDER BY ValidOn DESC
	)
END

GO
/****** Object:  StoredProcedure [dbo].[stpResetPassword]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpResetPassword]

(

	@OldPassword nvarchar(200),

	@NewPassword nvarchar(200),

	@UserName nvarchar(200)



)

AS

BEGIN



	BEGIN TRY

		BEGIN TRAN



		DECLARE @UserId int



		BEGIN

			UPDATE Users SET Password = @NewPassword 

			WHERE Username = @UserName AND Password = @OldPassword



			--DELETE FROM UserGroups WHERE UserID  = @ID 



		END



		COMMIT TRAN

	END TRY

	BEGIN CATCH

		ROLLBACK TRAN

	END CATCH



END

GO
/****** Object:  StoredProcedure [dbo].[stpSaveApprovalComments]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpSaveApprovalComments]
--(
--	--@Comments XML,
--	--@Approval XML
--)
AS
BEGIN

		DECLARE @XMLDocPointer INT  
		DECLARE @Comments XML
		
		SET @Comments = '<ApprovalComments>


<CommentsList>

<Comments>dummy comment</Comments>

<DayNum>1</DayNum>

<CrewId>1</CrewId>

<ShipId>8940557</ShipId>

<month>2</month>

<Year>2019</Year>

<BookDate>2019-02-01T00:00:00</BookDate>

</CommentsList><CommentsList>

<Comments>dummy comment</Comments>

<DayNum>1</DayNum>

<CrewId>1</CrewId>

<ShipId>8940557</ShipId>

<month>2</month>

<Year>2019</Year>

<BookDate>2019-02-01T00:00:00</BookDate>

</CommentsList></ApprovalComments>'    

        EXEC sp_xml_preparedocument @XMLDocPointer OUTPUT, @Comments

		SELECT Comments,CrewId,ShipId,BookDate
		FROM OPENXML(@XMLDocPointer,'/ApprovalComments/CommentsList',2)
		WITH
		(
			Comments varchar(500),
	        CrewId int,
	        ShipId int,
         	BookDate datetime
			
		)



END

GO
/****** Object:  StoredProcedure [dbo].[stpSaveCIRM]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  exec stpSaveCIRM .......................

create PROCEDURE [dbo].[stpSaveCIRM]
(
  @CIRMId int,

  @CrewId int,
  @Nationality varchar(50),
  @Addiction varchar(20), --
  @RankID int,  --
  @Ethinicity varchar(50), --
  @Frequency varchar(20), --
  @Sex varchar(5), --
  @Age varchar(5), --
  @JoiningDate varchar(20), --

  @Category varchar(50), --
  @SubCategory varchar(50), --

  @Pulse varchar(50),
  @OxygenSaturation varchar(50), --
  @RespiratoryRate varchar(50),
  @Systolic varchar(50),
  @Diastolic varchar(50),
  @SymptomatologyDate varchar(50), --
  @SymptomatologyTime varchar(50), --
  @Vomiting varchar(10), --
  @FrequencyOfVomiting varchar(50), --
  @Fits varchar(10), --
  @FrequencyOfFits varchar(50), --
  @SymptomatologyDetails varchar(500), --
  @MedicinesAdministered varchar(500), --
  @RelevantInformationForDesease varchar(50),

  @WhereAndHowAccidentOccured varchar(500), --
  --@NoHurt bit, --
  --@HurtLittleBit bit, --
  --@HurtsLittleMore bit, --
  --@HurtsEvenMore bit, --
  --@HurtsWholeLot bit, --
  --@HurtsWoest bit, --
  @JoiningMedical bit, --
  @MedicineAvailableOnBoard bit, --
  @MedicalEquipmentOnBoard bit, --
  @MedicalHistoryUpload bit, --
  @WorkAndRestHourLatestRecord bit, --
  @PreExistingMedicationPrescription bit, --
  @LocationAndTypeOfInjuryOrBurn varchar(500), --
  @FrequencyOfPain varchar(50), --
  @PictureUploadPath varchar(1000), --
  @FirstAidGiven varchar(500), --
  @PercentageOfBurn varchar(50), --
  @VesselID int --




  --------------- Old Unused Parameter ---------------
  --@NameOfVessel varchar(50),
  --@RadioCallSign varchar(50),
  --@PortofDestination varchar(50),
  --@Route varchar(50),
  --@LocationOfShip varchar(50),
  --@PortofDeparture varchar(50),
  --@EstimatedTimeOfarrivalhrs varchar(50),
  --@Speed varchar(50),
  --@Qualification varchar(50),
  --@Temperature varchar(50),
  --@UploadMedicalHistory varchar(500),
  --@UploadMedicinesAvailable varchar(500),
  --@MedicalProductsAdministered varchar(500),
  --@WhereAndHowAccidentIsausedARA varchar(500),
  --@IsEquipmentUploaded bit,
  --@IsJoiningReportUloaded bit,
  --@IsMedicalHistoryUploaded bit,
  --@IsmedicineUploaded bit
)

AS
BEGIN

 IF @CIRMId IS NULL

BEGIN 
    Insert into CIRM (CrewId,Nationality,Addiction,RankID,Ethinicity,Frequency,Sex,Age,JoiningDate,Category,SubCategory,Pulse,
	                  OxygenSaturation,RespiratoryRate,Systolic,Diastolic,SymptomatologyDate,SymptomatologyTime,Vomiting,
					  FrequencyOfVomiting,Fits,FrequencyOfFits,SymptomatologyDetails,MedicinesAdministered,
					  RelevantInformationForDesease,WhereAndHowAccidentOccured,
					  --NoHurt,HurtLittleBit,HurtsLittleMore,HurtsEvenMore,HurtsWholeLot,HurtsWoest,
					  JoiningMedical,MedicineAvailableOnBoard,MedicalEquipmentOnBoard,
					  MedicalHistoryUpload,WorkAndRestHourLatestRecord,PreExistingMedicationPrescription,
					  LocationAndTypeOfInjuryOrBurn,FrequencyOfPain,PictureUploadPath,FirstAidGiven,PercentageOfBurn,VesselID)

	values(@CrewId,@Nationality,@Addiction,@RankID,@Ethinicity,@Frequency,@Sex,@Age,@JoiningDate,@Category,@SubCategory,@Pulse,
	                  @OxygenSaturation,@RespiratoryRate,@Systolic,@Diastolic,@SymptomatologyDate,@SymptomatologyTime,@Vomiting,
					  @FrequencyOfVomiting,@Fits,@FrequencyOfFits,@SymptomatologyDetails,@MedicinesAdministered,
					  @RelevantInformationForDesease,@WhereAndHowAccidentOccured,
					  --@NoHurt,@HurtLittleBit,@HurtsLittleMore,@HurtsEvenMore,@HurtsWholeLot,@HurtsWoest,
					  @JoiningMedical,@MedicineAvailableOnBoard,@MedicalEquipmentOnBoard,
					  @MedicalHistoryUpload,@WorkAndRestHourLatestRecord,@PreExistingMedicationPrescription,
					  @LocationAndTypeOfInjuryOrBurn,@FrequencyOfPain,@PictureUploadPath,@FirstAidGiven,@PercentageOfBurn,@VesselID)

END
END

GO
/****** Object:  StoredProcedure [dbo].[stpSaveCompanyDetails]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec stpSaveCompanyDetails Null,'test', 'add1','www.x.com','PP','pp@gmail.com','4545','Shipping','abcd',@x out,2

CREATE procedure [dbo].[stpSaveCompanyDetails] 
( 
@ID int,
@Name varchar(100),
@Address varchar(1000),
@Website varchar(1000),
@AdminContact varchar(1000),
@AdminContactEmail varchar(100),
@ContactNumber varchar(50),
@Domain varchar(100),
@SecureKey varchar(2000),
@CompanyId int OUTPUT,
@CId int
) 
AS 
BEGIN 

DECLARE @CompanyCount int
SET @CompanyCount = 0

SELECT @CompanyCount = COUNT(*) FROM CompanyDetails

IF @CompanyCount = 0
BEGIN
 BEGIN TRY
    BEGIN TRAN

 IF @ID IS NULL

BEGIN   
	 print 'INSERT'
	INSERT INTO CompanyDetails 
		   (Name, [Address], Website, AdminContact, AdminContactEmail, ContactNumber, Domain, SecureKey, CompanyID)
	Values(@Name, @Address, @Website, @AdminContact, @AdminContactEmail, @ContactNumber, @Domain, @SecureKey, @CId)

	DECLARE @VesselId int
	SET @VesselId = 0

	IF EXISTS (SELECT COUNT(*) FROM Ship)
	BEGIN

		SELECT TOP 1 @VesselId = ID FROM Ship

	END

	IF @VesselId > 0
	BEGIN

		UPDATE Ship SET CompanyID = @CId WHERE ID = @VesselId

	END

	SET @ID = @@IDENTITY
	SET @CompanyId  = @ID

END
ELSE
BEGIN
	print 'UPDATE'
	UPDATE CompanyDetails
	SET Name=@Name, [Address]=@Address, Website=@Website, AdminContact=@AdminContact, AdminContactEmail=@AdminContactEmail, 
		ContactNumber=@ContactNumber, Domain=@Domain, SecureKey=@SecureKey, CompanyID=@CId
	Where ID=@ID

	SET @CompanyId  = @ID

END
	COMMIT TRAN
 END TRY 

 BEGIN CATCH
	ROLLBACK TRAN
	SELECT ERROR_MESSAGE() AS ErrorMessage;  
 END CATCH
END
END

GO
/****** Object:  StoredProcedure [dbo].[stpSaveConfigData]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec stpSaveConfigData 'smtptest','1000','d@d.com','f@f.com','qwerty'
CREATE Procedure [dbo].[stpSaveConfigData]
(
@SmtpServer varchar(100),
@Port varchar(100),
@MailFrom varchar(100),
@MailTo varchar(100),
@MailPassword varchar(100),
@ShipEmail varchar(100),
@ShipEmailPwd varchar(100),
@AdminCenterEmail varchar(100),
@Pop varchar(100),
@PopPort varchar(100)
--@AttachmentSize varchar(100)
)
AS 
Begin
Begin Try
Begin Tran
Update tblConfig Set IsActive = 0 Where KeyName = 'smtp'
Insert into tblConfig (KeyName,ConfigValue,IsActive) Values ('smtp',@SmtpServer,1)
Update tblConfig Set IsActive = 0 Where KeyName = 'port'
Insert into tblConfig (KeyName,ConfigValue,IsActive) Values ('port',@Port,1)
Update tblConfig Set IsActive = 0 Where KeyName = 'mailfrom'
Insert into tblConfig (KeyName,ConfigValue,IsActive) Values ('mailfrom',@MailFrom,1)
Update tblConfig Set IsActive = 0 Where KeyName = 'mailto'
Insert into tblConfig (KeyName,ConfigValue,IsActive) Values ('mailto',@MailTo,1)
Update tblConfig Set IsActive = 0 Where KeyName = 'frompwd'
Insert into tblConfig (KeyName,ConfigValue,IsActive) Values ('frompwd',@MailPassword,1)
Update tblConfig Set IsActive = 0 Where KeyName = 'shipemail'
Insert into tblConfig (KeyName,ConfigValue,IsActive) Values ('shipemail',@ShipEmail,1)
Update tblConfig Set IsActive = 0 Where KeyName = 'shipemailpwd'
Insert into tblConfig (KeyName,ConfigValue,IsActive) Values ('shipemailpwd',@ShipEmailPwd,1)
Update tblConfig Set IsActive = 0 Where KeyName = 'admincenteremail'
Insert into tblConfig (KeyName,ConfigValue,IsActive) Values ('admincenteremail',@AdminCenterEmail,1)
Update tblConfig Set IsActive = 0 Where KeyName = 'pop'
Insert into tblConfig (KeyName,ConfigValue,IsActive) Values ('pop3',@Pop,1)
Update tblConfig Set IsActive = 0 Where KeyName = 'pop3port'
Insert into tblConfig (KeyName,ConfigValue,IsActive) Values ('pop3port',@PopPort,1)
--Insert into tblConfig (KeyName,ConfigValue,IsActive) Values ('outputsize',@AttachmentSize,1)
Commit Tran
End Try
Begin Catch
Rollback Tran
Print error_message()
End Catch
End


GO
/****** Object:  StoredProcedure [dbo].[stpSaveConsultation]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  exec stpSaveConsultation 2, 'xyzzzzz'

CREATE PROCEDURE [dbo].[stpSaveConsultation]
(
	@DoctorID int,
	@Problem varchar(500)
)
AS
BEGIN
	INSERT INTO Consultation(DoctorID,Problem)
	VALUES (@DoctorID,@Problem)
END

GO
/****** Object:  StoredProcedure [dbo].[stpSaveCrew]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------
------------ 27 11 2018 --------------------------

-- DECLARE @NewCrewId int    exec stpSaveCrew NULL, trt, ggh, gfgf, 1052, 1, '2018-06-01 00:00:00.000', India, ghjhj, juhjh, '2018-06-14 00:00:00.000', '2018-06-14 00:00:00.000', gfgfg, 0,1,@NewCrewId OUTPUT ,9876543,5
CREATE procedure [dbo].[stpSaveCrew] 
( 
@ID int,
@FirstName nvarchar(100),
@MiddleName nvarchar(100),
@LastName nvarchar(50),
@Gender varchar(30),
@RankID int,
@CountryID int,

@DOB datetime,
@POB nvarchar(20),
--@CrewIdentity nvarchar(20),
@PassportSeamanPassportBook nvarchar(20),
@Seaman nvarchar(20),
@CreatedOn datetime,
@ActiveTo datetime,
---@PayNum nvarchar(25),
--@EmployeeNumber nvarchar(25),
@Notes ntext,
@Watchkeeper bit,
@OvertimeEnabled bit,
@NewCrewId int OUTPUT,
@VesselID int,
@DepartmentMasterID int,
@IssuingStateOfIdentityDocument nvarchar(500),
@ExpiryDateOfIdentityDocument datetime
) 
AS 
BEGIN 
 IF @ID IS NULL
BEGIN   
BEGIN TRY  
BEGIN TRAN
DECLARE @YearValue varchar(4)
DECLARE @MAXCREWVAL int
DECLARE @EmployeeNum varchar(25)
SET @YearValue = ''
SELECT @YearValue = YEAR(GETDATE()) 
SELECT @MAXCREWVAL =  COUNT(*) FROM Crew
IF @MAXCREWVAL = 0
BEGIN
	SET @MAXCREWVAL = 1
END
ELSE
BEGIN
	SET @MAXCREWVAL = @MAXCREWVAL + 1
END
SET @EmployeeNum = CAST(@MAXCREWVAL AS VARCHAR(4)) + '/' + CAST(@YearValue AS VARCHAR(4))
INSERT INTO Crew 
           (FirstName,MiddleName,LastName,Gender,RankID,CreatedOn,LatestUpdate,CountryID,DOB,POB,PassportSeamanPassportBook,Seaman,Notes,Watchkeeper,OvertimeEnabled,EmployeeNumber,VesselID,DepartmentMasterID,DeactivationDate,DeletionDate, IssuingStateOfIdentityDocument, ExpiryDateOfIdentityDocument)  
Values(@FirstName,@MiddleName,@LastName,@Gender,@RankID,@CreatedOn,@ActiveTo,@CountryID,@DOB,@POB,@PassportSeamanPassportBook,@Seaman,@Notes,@Watchkeeper,@OvertimeEnabled,@EmployeeNum,@VesselID,@DepartmentMasterID,'12/31/9999','12/31/9999', @IssuingStateOfIdentityDocument, @ExpiryDateOfIdentityDocument)  
DECLARE @CrewId int
SET @CrewId = @@IDENTITY
SET @NewCrewId = @@IDENTITY
--UPDATE Crew
--SET EmployeeNumber = @CrewId + '/' + @YearValue
--WHERE ID = @CrewId
INSERT INTO ServiceTerms(ActiveFrom,ActiveTo,CrewID,RankID,Deleted,VesselID) VALUES
(@CreatedOn,@ActiveTo,@CrewId,@RankID,0,@VesselID)
COMMIT TRAN
END TRY
BEGIN CATCH
	print Error_Message()
	ROLLBACK TRAN 
END CATCH
END
ELSE
BEGIN
BEGIN TRY  
BEGIN TRAN

UPDATE Crew SET Seaman = NULL , PassportSeamanPassportBook = NULL WHERE ID=@ID

UPDATE Crew
    SET FirstName=@FirstName,MiddleName=@MiddleName,LastName=@LastName,Gender=@Gender,RankID=@RankID,CreatedOn=@CreatedOn,LatestUpdate=@ActiveTo,
    --PayNum=@PayNum,
	CountryID=@CountryID,
    Notes=@Notes,Watchkeeper=@Watchkeeper,OvertimeEnabled=@OvertimeEnabled,
	PassportSeamanPassportBook=@PassportSeamanPassportBook,Seaman=@Seaman,DOB=@DOB,DepartmentMasterID=@DepartmentMasterID
	,IssuingStateOfIdentityDocument=@IssuingStateOfIdentityDocument, ExpiryDateOfIdentityDocument=@ExpiryDateOfIdentityDocument
	WHERE ID=@ID

	declare @SeviceCount int
	set @SeviceCount = 0
	SELECT @SeviceCount = COUNT(*) FROM ServiceTerms WHERE CrewID = @ID 
	IF @SeviceCount > 0
	BEGIN
		UPDATE ServiceTerms SET ActiveFrom = @CreatedOn,ActiveTo = @ActiveTo 
		WHERE CrewId = @ID
	END
	ELSE
	BEGIN
		INSERT INTO ServiceTerms(ActiveFrom,ActiveTo,CrewID,RankID,Deleted,VesselID) VALUES
		(@CreatedOn,@ActiveTo,@ID,@RankID,0,@VesselID)
	END
	SET @NewCrewId = @ID
  COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRAN 
END CATCH
END
END

GO
/****** Object:  StoredProcedure [dbo].[stpSaveDepartment]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------

--exec stpSaveDepartment '1008','DN12', 'DC12', '17', 9876543

CREATE procedure [dbo].[stpSaveDepartment] 
( 
@DepartmentMasterID int,
@DepartmentMasterName varchar(50),
@DepartmentMasterCode varchar(10),

@CrewID varchar(1000),
@VesselID int
) 
AS 
BEGIN 

DECLARE @DepartmentID int

 BEGIN TRY
    BEGIN TRAN

 IF @DepartmentMasterID IS NULL

BEGIN   
 print 'INSERT'
INSERT INTO DepartmentMaster 
       (DepartmentMasterName,  DepartmentMasterCode, IsActive,VesselID)
Values(@DepartmentMasterName, @DepartmentMasterCode, 1,@VesselID)

SET @DepartmentID = @@IDENTITY

INSERT INTO DepartmentAdmin 
       (DepartmentMasterID, CrewID,IsAdmin,IsActive,VesselID)
	   SELECT @DepartmentID,String,1,1,@VesselID FROM ufn_CSVToTable(@CrewID,',')
--Values(@DepartmentID, @CrewID,1,1,@VesselID)


UPDATE Crew SET DepartmentMasterID = @DepartmentID

END
ELSE
BEGIN
print 'UPDATE'
UPDATE DepartmentMaster
SET DepartmentMasterName=@DepartmentMasterName, DepartmentMasterCode=@DepartmentMasterCode  
Where DepartmentMasterID=@DepartmentMasterID

--UPDATE DepartmentAdmin
--SET DepartmentMasterID=@DepartmentMasterID, CrewID=@CrewID  
--Where DepartmentMasterID=@DepartmentMasterID


DELETE From DepartmentAdmin Where DepartmentMasterID=@DepartmentMasterID

INSERT INTO DepartmentAdmin 
       (DepartmentMasterID, CrewID,IsAdmin,IsActive,VesselID)
	   SELECT @DepartmentMasterID,String,1,1,@VesselID FROM ufn_CSVToTable(@CrewID,',')

UPDATE Crew SET DepartmentMasterID = @DepartmentMasterID WHERE ID IN (SELECT String FROM ufn_CSVToTable(@CrewID,','))

END



	COMMIT TRAN
 END TRY 

 BEGIN CATCH
	ROLLBACK TRAN
	SELECT ERROR_MESSAGE() AS ErrorMessage;  
 END CATCH



END

GO
/****** Object:  StoredProcedure [dbo].[stpSaveDepartmentMaster]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec stpSaveDepartmentMaster 'dfsdf','CODE gf', '7654321'
CREATE procedure [dbo].[stpSaveDepartmentMaster] 
( 
--@DepartmentMasterID int,
@DepartmentMasterName varchar(50),
@DepartmentMasterCode varchar(10),
@VesselID int
) 
AS 
BEGIN 

INSERT INTO DepartmentMaster 
       (DepartmentMasterName,  DepartmentMasterCode, IsActive,VesselID)
Values(@DepartmentMasterName, @DepartmentMasterCode, 1,@VesselID)

END

GO
/****** Object:  StoredProcedure [dbo].[stpSaveDoctorMaster]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  exec stpSaveDoctorMaster 'name', '@gfg', 1, 'zzzzzzzz'

CREATE PROCEDURE [dbo].[stpSaveDoctorMaster]
(
	--@DoctorID int,
	@DoctorName varchar(100),
	@DoctorEmail varchar(100),
	@SpecialityID int,
	@Comment varchar(500)
)
AS
BEGIN
	INSERT INTO DoctorMaster(DoctorName,DoctorEmail,SpecialityID,Comment)
	VALUES  (@DoctorName,@DoctorEmail,@SpecialityID,@Comment)
END

GO
/****** Object:  StoredProcedure [dbo].[stpSaveGroups]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpSaveGroups] 

  

( 

@ID int,

@GroupName nvarchar(50),

@PermissionIds varchar(1000),

@VesselID int

) 



AS 

BEGIN 

    

 IF @ID IS NULL

BEGIN   

  

  DECLARE @GroupId int

  DECLARE @PermissionTab TABLE

  (

	GrpId int,

	PermissionId int

  )



  BEGIN TRY



	BEGIN TRAN



	INSERT INTO Groups(GroupName,AllowDelete,VesselID)  

	Values(@GroupName,0,@VesselID) 

  

	SET @GroupId = @@IDENTITY 



	INSERT INTO @PermissionTab(GrpId,PermissionId)

	SELECT @GroupId,String FROM ufn_CSVToTable(@PermissionIds,',')





	INSERT INTO GroupPermission(GroupID,PermissionID)

	SELECT GrpId,PermissionId FROM @PermissionTab  



	COMMIT TRAN

 END TRY 

 BEGIN CATCH

	ROLLBACK TRAN

 END CATCH





END

ELSE

BEGIN



UPDATE Groups

SET GroupName=@GroupName,AllowDelete=0

Where ID=@ID



END

END

GO
/****** Object:  StoredProcedure [dbo].[stpSaveInitialShipValues]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpSaveInitialShipValues]
(
@Vessel nvarchar(21),
@Flag varchar(50),
@IMO int,
@AdminUser varchar(50),
@AdminPassword varchar(50),
@DeactivationDate varchar(100)

--------------new------------------
    ,
    @VesselTypeID int,
    @VesselSubTypeID int,
    @VesselSubSubTypeID int,

	@ShipEmail varchar(200),
	@ShipEmail2 varchar(100),
    @Voices1 varchar(100),
    @Voices2 varchar(100),
    @Fax1 varchar(100),
    @Fax2 varchar(100),
    @VOIP1 varchar(100),
    @VOIP2 varchar(100),
    @Mobile1 varchar(100),
    @Mobile2 varchar(100)
--------------------------------
)
AS 
Begin

DECLARE @ShipCount int
SET @ShipCount = 0

SELECT  @ShipCount = COUNT(*) FROM Ship

IF @ShipCount = 0
BEGIN
Begin Try
Begin Tran
--Insert into Ship ([ShipName],FlagOfShip,IMONumber)
-- Values(@Vessel,@Flag,@IMO)
--------------------------------new-------------------------------------------------
Insert into Ship ([ShipName],FlagOfShip,IMONumber,VesselTypeID,VesselSubTypeID,VesselSubSubTypeID,ShipEmail,ShipEmail2,Voices1,Voices2,Fax1,Fax2,VOIP1,VOIP2,Mobile1,Mobile2)
 Values(@Vessel,@Flag,@IMO,@VesselTypeID,@VesselSubTypeID,@VesselSubSubTypeID,@ShipEmail,@ShipEmail2,@Voices1,@Voices2,@Fax1,@Fax2,@VOIP1,@VOIP2,@Mobile1,@Mobile2)
 ----------------------------------------------------------------------------------
 Declare @SuperAdminGroupID int
 Declare @UserId int
 Set @SuperAdminGroupID = 0
 Select @SuperAdminGroupID = ID from Groups
 Where GroupName = 'Super Admin'
 Insert into Users(UserName,Password,Active,AllowDelete,CrewId,VesselID)
 Values(@AdminUser,@AdminPassword,1,1,NULL,@IMO)
 Set @UserId = @@IDENTITY
 Insert into UserGroups (UserID,GroupID,VesselID)
 Values (@UserId,@SuperAdminGroupID,@IMO)

 INSERT INTO FirstRun(RunCount)  
	Values(1) 

INSERT INTO tblConfig(KeyName,ConfigValue,IsActive) VALUES ('InstallationHash',@DeactivationDate,1)


UPDATE GroupRank
SET VesselID=@IMO


UPDATE Groups
SET VesselID=@IMO

UPDATE Regimes
SET VesselID=@IMO

UPDATE Ranks
SET VesselID=@IMO

INSERT INTO tblRegime(RegimeID,RegimeStartDate,IsActiveRegime,VesselID,RegimeEndDate)
	VALUES(5,GETDATE(),1,@IMO,'12/31/9999')

UPDATE DepartmentMaster SET VesselID =  @IMO
UPDATE Ship SET Regime = 5

DECLARE @CompanyId int
SET @CompanyId = 0

IF EXISTS(SELECT COUNT(*) FROM CompanyDetails)
BEGIN
SELECT TOP 1  @CompanyId = CompanyId FROm CompanyDetails
END
 

IF @CompanyId > 0
BEGIN
	
	UPDATE Ship Set CompanyID = @CompanyId

END


Commit Tran
End Try
Begin Catch
Rollback Tran 
End Catch
END

End
GO
/****** Object:  StoredProcedure [dbo].[stpSaveMedicalAdvisory]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  exec stpSaveMedicalAdvisory 'name', '@gfg', 1, 'zzzzzzzz'

CREATE PROCEDURE [dbo].[stpSaveMedicalAdvisory]
(
	--@MedicalAdvisoryID int,

	@Weight varchar(500),
	@BMI varchar(500),
	--@BP varchar(500),
	@BloodSugarLevel varchar(500),
	@UrineTest bit,

	@Height varchar(20),
	@Age varchar(20),
	@BloodSugarUnit varchar(20),
	@BloodSugarTestType varchar(20),
	@Systolic varchar(20),
	@Diastolic varchar(20),

	@UnannouncedAlcohol bit,
	@AnnualDH bit,
	@Month varchar(20),
	@CrewName varchar(20),
	@CrewNameID int,
	@PulseRatebpm varchar(20),
	@AnyDietaryRestrictions varchar(50),
	@MedicalProductsAdministered varchar(50),
	@UploadExistingPrescriptions varchar(100),
	@UploadUrineReport varchar(100),

	@LoggedInUserId int 
)
AS
BEGIN
	INSERT INTO MedicalAdvisory(Weight,BMI,BloodSugarLevel,UrineTest,
	            Height,Age,BloodSugarUnit,BloodSugarTestType,Systolic,Diastolic,CrewID,
				UnannouncedAlcohol,AnnualDH,[Month],CrewName,CrewNameID,PulseRatebpm,AnyDietaryRestrictions,MedicalProductsAdministered,UploadExistingPrescriptions,UploadUrineReport)
	VALUES  (@Weight,@BMI,@BloodSugarLevel,@UrineTest,
	 @Height,@Age,@BloodSugarUnit,@BloodSugarTestType,@Systolic,@Diastolic,@LoggedInUserId,
	@UnannouncedAlcohol,@AnnualDH,@Month,@CrewName,@CrewNameID,@PulseRatebpm,@AnyDietaryRestrictions,@MedicalProductsAdministered,@UploadExistingPrescriptions,@UploadUrineReport)
END



GO
/****** Object:  StoredProcedure [dbo].[stpSaveMedicine]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--  exec stpSaveMedicine NULL,'A Das' , 3, '17-Dec-2019', 'Kolkata'

CREATE PROCEDURE [dbo].[stpSaveMedicine]
(
	@MedicineID int,
	@MedicineName varchar(500),
	@Quantity varchar(500),
    @ExpiryDate varchar(50),
	@Location varchar(50)
)
AS
BEGIN
IF @MedicineID IS NULL
 BEGIN
	INSERT INTO tblMedicine(MedicineName,Quantity,ExpiryDate,Location)
	VALUES (@MedicineName,@Quantity,@ExpiryDate,@Location)
END
ELSE
BEGIN
UPDATE tblMedicine
SET MedicineName=@MedicineName,Quantity=@Quantity,ExpiryDate=@ExpiryDate,Location=@Location
Where MedicineID=@MedicineID
END
END
GO
/****** Object:  StoredProcedure [dbo].[stpGetMedicineByID]    Script Date: 12/23/2019 5:59:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec stpGetMedicineByID 11

create PROCEDURE [dbo].[stpGetMedicineByID]
(
	@MedicineID int
	--,@VesselID int
)
AS
Begin
Select  MedicineID,MedicineName,Quantity, ExpiryDate, Location
FROM dbo.tblMedicine
WHERE MedicineID= @MedicineID
--AND VesselID=@VesselID
End
GO
/****** Object:  StoredProcedure [dbo].[stpGetMedicalEquipmentByID]    Script Date: 12/23/2019 5:58:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[stpDeleteEquipments]    Script Date: 12/23/2019 6:00:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- stpDeleteEquipments 25

create procedure [dbo].[stpDeleteEquipments] 
( 
@EquipmentsID int
) 
AS 
BEGIN 
DELETE FROM tblEquipments where EquipmentsID=@EquipmentsID
RETURN  
END
GO

/****** Object:  StoredProcedure [dbo].[stpDeleteMedicine]    Script Date: 12/23/2019 6:01:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- stpDeleteMedicine 9

create procedure [dbo].[stpDeleteMedicine] 
( 
@MedicineID int
) 
AS 
BEGIN 
DELETE FROM tblMedicine where MedicineID=@MedicineID
RETURN  
END
GO
-- exec stpGetMedicalEquipmentByID 11

CREATE PROCEDURE [dbo].[stpGetMedicalEquipmentByID]
(
	@EquipmentsID int
	--,@VesselID int
)
AS
Begin
Select  EquipmentsID,EquipmentsName,Comment,Quantity, ExpiryDate, Location
FROM dbo.tblEquipments
WHERE EquipmentsID= @EquipmentsID
--AND VesselID=@VesselID
End
GO
/****** Object:  StoredProcedure [dbo].[stpSaveNewShipDetails]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[stpSaveNewShipDetails] 
( 
@ShipName nvarchar(21),
@IMONumber int,
@FlagOfShip nvarchar(50),
@SuperAdminUserName nvarchar(200),
@SuperAdminPassword nvarchar(200)
) 
AS 
BEGIN

DECLARE @GroupId int
DECLARE @NewUserId int

Select @GroupId = Id From Groups Where GroupName = 'Super Admin'

 BEGIN TRY
    BEGIN TRAN

	INSERT INTO Ship (ShipName,IMONumber,FlagOfShip,Regime)
	Values(@ShipName,@IMONumber,@FlagOfShip,5)

	INSERT INTO FirstRun(RunCount)  
	Values(1) 

	Update Groups
	SET VesselID = @IMONumber

	INSERT INTO Users (Username,Password,Active,AllowDelete,CrewId,VesselID)
	Values(@SuperAdminUserName,@SuperAdminPassword,1,1,NULL,@IMONumber) 

	SET @NewUserId = @@IDENTITY

	INSERT INTO UserGroups (UserID,GroupID,VesselID)
	Values(@NewUserId,@GroupId,@IMONumber)

	INSERT INTO tblRegime(RegimeID,RegimeStartDate,IsActiveRegime,VesselID,RegimeEndDate)
	VALUES(5,GETDATE(),1,@IMONumber,NULL)

	COMMIT TRAN
 END TRY 

 BEGIN CATCH
	ROLLBACK TRAN
 END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[stpSaveRankGroups]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpSaveRankGroups]

(

	@RankId int,

	@Groups varchar(1000),
	@VesselID int

)

AS

BEGIN



	DECLARE @GroupTab TABLE

  (

	RankId int,

	GrpId int
	

	

  )







  INSERT INTO @GroupTab(RankId,GrpId)

	SELECT @RankId,String FROM ufn_CSVToTable(@Groups,',')



	--select * from @GroupTab



	INSERT INTO GroupRank(GroupId,RankID,VesselID)

	SELECT GrpId,RankId,@VesselID FROM @GroupTab



END

GO
/****** Object:  StoredProcedure [dbo].[stpSaveRanks]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec stpSaveRanks NULL,'Captain','Captain Of Ship',true

CREATE procedure [dbo].[stpSaveRanks] 

  

( 

@ID int,

@RankName nvarchar(50),

@Description nvarchar(200),

@Scheduled bit,
@VesselID int

--@Regime nvarchar(50)

) 



AS 

BEGIN 

    

 IF @ID IS NULL

BEGIN  



DECLARE @MaxRankOrder int



SELECT @MaxRankOrder = ISNULL(MAX([Order]),0) FROM Ranks 





   SET @MaxRankOrder = @MaxRankOrder + 1







--print @MaxRankOrder

 

  

INSERT INTO Ranks 

           (RankName,[Description],Scheduled,[Order] ,VesselID) 

Values(@RankName,@Description,@Scheduled,@MaxRankOrder,@VesselID) 

  

 

END

ELSE

BEGIN



UPDATE Ranks

SET RankName=@RankName,[Description]=@Description,Scheduled=@Scheduled--,Regime=@Regime

Where ID=@ID



END

END

GO
/****** Object:  StoredProcedure [dbo].[stpSaveRanksForXmlProject]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpSaveRanksForXmlProject] 
( 
@ID int,
@RankName nvarchar(50),
@Description nvarchar(200),
@Order int,
@ScheduleID int,
@Deleted bit,
@LatestUpdate datetime,
@DefaultScheduleComments nvarchar(200),
@Scheduled bit,
@VesselID int
) 
AS 
BEGIN 
--IF @ID IS NULL
BEGIN   
SET IDENTITY_INSERT Ranks ON
INSERT INTO Ranks 
            (ID,RankName,[Description],[Order],ScheduleID,Deleted,LatestUpdate,DefaultScheduleComments,Scheduled,VesselID)

Values(@ID,@RankName,@Description,@Order,@ScheduleID,@Deleted,@LatestUpdate,@DefaultScheduleComments,@Scheduled,@VesselID)
SET IDENTITY_INSERT Ranks OFF
END
END

GO
/****** Object:  StoredProcedure [dbo].[stpSaveRegimes]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpSaveRegimes] 

  

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

END

GO
/****** Object:  StoredProcedure [dbo].[stpSaveServiceTerms]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec stpSaveServiceTerms 9876543, 18, '2018-06-14'
CREATE PROCEDURE [dbo].[stpSaveServiceTerms]
(
	@VesselID int,
	@CrewID int,
	@ActiveTo datetime
)
AS 
BEGIN 
BEGIN TRY
BEGIN TRAN
	INSERT INTO ServiceTermsHistory (ActiveFrom,ActiveTo,CrewID,OvertimeID,ScheduleID,RankID,Deleted,VesselID)
	Select ActiveFrom,ActiveTo,CrewID,OvertimeID,ScheduleID,RankID,Deleted,VesselID
	From ServiceTerms Where CrewID = @CrewID
	Update ServiceTerms Set ActiveTo = @ActiveTo Where CrewID = @CrewID
	Update Crew Set LatestUpdate = @ActiveTo Where ID = @CrewID
COMMIT TRAN
 END TRY
 BEGIN CATCH
	ROLLBACK TRAN
	PRINT @@ERROR
 END CATCH
 END

GO
/****** Object:  StoredProcedure [dbo].[stpSaveShipDetails]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpSaveShipDetails] 
( 

@ID int,
@ShipName nvarchar(21),
@IMONumber nvarchar(8),
@FlafShip nvarchar(50)

) 

AS 
BEGIN 

    

 IF @ID IS NULL

BEGIN   

  

IF NOT EXISTS(SELECT COUNT(*) FROM Ship)

BEGIN

			DECLARE @VesselId int
			DECLARE @UserId int
			DECLARE @GroupId int
			
			INSERT INTO Ship(ShipName,IMONumber,FlagOfShip,ID)  
			Values(@ShipName,@IMONumber,@FlafShip,@ID) 

			SET @VesselId = @@IDENTITY

			INSERT INTO [Users] ([Username],[Password],[Active],[AllowDelete],[CrewId],[VesselID])
			VALUES('sa','admin',1,1,NULL,@VesselId)

			SET @UserId = @@IDENTITY

			INSERT INTO [Groups] ([GroupName],[AllowDelete],[VesselID])
			VALUES('Super Admin',1,1)

			SET @GroupId = @@IDENTITY

			INSERT INTO [UserGroups]([UserID],[GroupID],[VesselID]) 
			VALUES(@UserId,@GroupId,@VesselId)

			SET @UserId =''
			SET @GroupId = ''

			INSERT INTO [Groups] ([GroupName],[AllowDelete],[VesselID])
			VALUES('Admin',1,1)

			INSERT INTO [Groups] ([GroupName],[AllowDelete],[VesselID])
			VALUES('User',1,1)


			-----------Adding Regimes-----------------------
			INSERT INTO [Regimes] ([RegimeName], [Description], [Basis], [MinTotalRestIn7Days], [MaxTotalWorkIn24Hours], [MinContRestIn24Hours], [MinTotalRestIn24Hours], [MaxTotalWorkIn7Days], [CheckFor2Days], [OPA90], [ManilaExceptions], [UseHistCalculationOnly], [CheckOnlyWorkHours], [VesselID]) 
			VALUES ( N'IMO STCW', N'IMO STCW Convention (Regulation VIII/1) concerning minimum rest hours', N'rest', 70, 14, 6, 10, 98, 0, 1, NULL, 1, 1, @VesselId)

			INSERT INTO [Regimes] ([RegimeName], [Description], [Basis], [MinTotalRestIn7Days], [MaxTotalWorkIn24Hours], [MinContRestIn24Hours], [MinTotalRestIn24Hours], [MaxTotalWorkIn7Days], [CheckFor2Days], [OPA90], [ManilaExceptions], [UseHistCalculationOnly], [CheckOnlyWorkHours], [VesselID]) 
			VALUES (N'ILO Rest (Flexible)', N'ILO Convention No 180 based on minimum rest hours (Article 5 1b)', N'rest', 77, 14, 6, 10, 91, 0, 0, NULL, 1, 1, @VesselId)

			INSERT INTO [Regimes] ([RegimeName], [Description], [Basis], [MinTotalRestIn7Days], [MaxTotalWorkIn24Hours], [MinContRestIn24Hours], [MinTotalRestIn24Hours], [MaxTotalWorkIn7Days], [CheckFor2Days], [OPA90], [ManilaExceptions], [UseHistCalculationOnly], [CheckOnlyWorkHours], [VesselID]) 
			VALUES (N'ILO Work', N'ILO Convention No 180 based on maximum hours of work (Article 5 1a)', N'work', 96, 14, 6, 10, 72, 0, 1, NULL, 0, 1, @VesselId)

			INSERT INTO [Regimes] ([RegimeName], [Description], [Basis], [MinTotalRestIn7Days], [MaxTotalWorkIn24Hours], [MinContRestIn24Hours], [MinTotalRestIn24Hours], [MaxTotalWorkIn7Days], [CheckFor2Days], [OPA90], [ManilaExceptions], [UseHistCalculationOnly], [CheckOnlyWorkHours], [VesselID]) 
			VALUES (N'Customised', N'Based on collective agreement or national regulations', N'rest', 70, 14, 6, 10, 93, 0, 1, NULL, 1, 1, @VesselId)

			INSERT INTO [Regimes] ([RegimeName], [Description], [Basis], [MinTotalRestIn7Days], [MaxTotalWorkIn24Hours], [MinContRestIn24Hours], [MinTotalRestIn24Hours], [MaxTotalWorkIn7Days], [CheckFor2Days], [OPA90], [ManilaExceptions], [UseHistCalculationOnly], [CheckOnlyWorkHours], [VesselID]) 
			VALUES ( N'ILO Rest', N'ILO Convention No 180 based on minimum rest hours (Article 5 1b)', N'rest', 77, 14, 6, 10, 91, 0, 0, NULL, 1, 1, @VesselId)

			INSERT INTO [Regimes] ([RegimeName], [Description], [Basis], [MinTotalRestIn7Days], [MaxTotalWorkIn24Hours], [MinContRestIn24Hours], [MinTotalRestIn24Hours], [MaxTotalWorkIn7Days], [CheckFor2Days], [OPA90], [ManilaExceptions], [UseHistCalculationOnly], [CheckOnlyWorkHours], [VesselID]) 
			VALUES (N'IMO STCW 2010', N'IMO STCW 2010 Convention (Regulation VIII/1) concerning minimum rest hours', N'rest', 77, 14, 6, 10, 91, 0, 0, 0, 1, 1, @VesselId)

			INSERT INTO [Regimes] ([RegimeName], [Description], [Basis], [MinTotalRestIn7Days], [MaxTotalWorkIn24Hours], [MinContRestIn24Hours], [MinTotalRestIn24Hours], [MaxTotalWorkIn7Days], [CheckFor2Days], [OPA90], [ManilaExceptions], [UseHistCalculationOnly], [CheckOnlyWorkHours], [VesselID]) 
			VALUES ( N'OCIMF', N'OCIMF Historical Regime', N'rest', 77, 14, 6, 10, 91, 0, 0, 0, 1, 0, @VesselId)

			-----------------Adding Ranks-------------------------

			
			INSERT INTO [Ranks] ([RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
			VALUES ( N'Chief Off', N'Chief Off', 2, NULL, 0, NULL, NULL, 1, @VesselId)

			INSERT INTO [Ranks] ([RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
			VALUES ( N'Master', N'Master', 1, NULL, 0, NULL, NULL, 1, @VesselId)

			INSERT INTO [Ranks] ( [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
			VALUES (N'2nd Off', N'2nd Off', 3, NULL, 0, NULL, NULL, 1, @VesselId)

			INSERT INTO [Ranks] ([RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
			VALUES (N'Chief Engineer', N'Chief Engineer', 4, NULL, 0, NULL, NULL, 1, @VesselId)

			INSERT INTO [Ranks] ( [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
			VALUES ( N'1st Engineer', N'1st Engineer', 5, NULL, 0, NULL, NULL, 1, @VesselId)

			INSERT INTO [Ranks] ([RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
			VALUES ( N'ETO', N'ETO', 6, NULL, 0, NULL, NULL, 1, @VesselId)

			INSERT INTO [Ranks] ([RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
			VALUES ( N'3rd Engineer', N'3rd Engineer', 7, NULL, 0, NULL, NULL, 1, @VesselId)

			INSERT INTO [Ranks] ([RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
			VALUES (N'Bosun / Crane', N'Bosun / Crane', 8, NULL, 0, NULL, NULL, 1, @VesselId)

			INSERT INTO [Ranks] ([RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
			VALUES ( N'Crane Operator', N'Crane Operator', 9, NULL, 0, NULL, NULL, 1, @VesselId)

			INSERT INTO [Ranks] ([RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
			VALUES ( N'AB', N'AB', 10, NULL, 0, NULL, NULL, 1, @VesselId)

			INSERT INTO [Ranks] ( [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
			VALUES ( N'Fitter', N'Fitter', 11, NULL, 0, NULL, NULL, 1, @VesselId)

			INSERT INTO [Ranks] ( [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
			VALUES ( N'Oiler', N'Oiler', 12, NULL, 0, NULL, NULL, 1, @VesselId)

			INSERT INTO [Ranks] ( [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
			VALUES ( N'Cook', N'Cook', 13, NULL, 0, NULL, NULL, 1, @VesselId)

			INSERT INTO [Ranks] ( [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
			VALUES ( N'Steward', N'Steward', 14, NULL, 0, NULL, NULL, 1, @VesselId)

			INSERT INTO [Ranks] ( [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
			VALUES ( N'R Test ', N'D Test', 15, NULL, 0, NULL, NULL, 0, @VesselId)

			INSERT INTO [Ranks] ( [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
			VALUES (N'O/S', N'New', 16, NULL, 0, NULL, NULL, 0, @VesselId)

			INSERT INTO [Ranks] ([RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
			VALUES (N'2nd Cook', N'2nd Cook', 17, NULL, 0, NULL, NULL, 0, @VesselId)
			
			INSERT INTO [Ranks] ([RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID])
			VALUES (N'SDPO', N'SDPO', 18, NULL, 0, NULL, NULL, 0, @VesselId)

			INSERT INTO [Ranks] ([RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID])
			VALUES (N'DPO', N'DPO', 19, NULL, 0, NULL, NULL, 0, @VesselId)
			
END 

 

END

ELSE

BEGIN



UPDATE Ship

SET ShipName=@ShipName,IMONumber=@IMONumber,FlagOfShip=@FlafShip--,Regime=@Regime

Where ID=@ID



END

END

GO
/****** Object:  StoredProcedure [dbo].[stpSaveShipTab]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpSaveShipTab] 

  

( 

@Regime nvarchar(50)

) 



AS 

BEGIN 



UPDATE Ship

SET Regime=@Regime

Where ID=1



END

GO
/****** Object:  StoredProcedure [dbo].[stpSavetblEquipments]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--  exec stpSavetblEquipments NULL,'EquipmentsName', 'Comment' , 2, '24-Dec-2019', 'Kolkata555'

CREATE PROCEDURE [dbo].[stpSavetblEquipments]
(
	@EquipmentsID int,
	@EquipmentsName varchar(500),
	@Comment varchar(500),
	@Quantity int,
	@ExpiryDate varchar(50),
	@Location varchar(50)
)
AS
BEGIN
 IF @EquipmentsID IS NULL
 BEGIN
	INSERT INTO tblEquipments(EquipmentsName,Comment,Quantity,ExpiryDate,Location)
	VALUES (@EquipmentsName,@Comment,@Quantity,@ExpiryDate,@Location)
END
ELSE
BEGIN
UPDATE tblEquipments
SET EquipmentsName=@EquipmentsName,Comment=@Comment,Quantity=@Quantity,ExpiryDate=@ExpiryDate,Location=@Location
Where EquipmentsID=@EquipmentsID
END
END
GO

/****** Object:  StoredProcedure [dbo].[stpSavetblRegime]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec stpSavetblRegime '1','2018-06-01 00:00:00.000','9876543','3'

CREATE procedure [dbo].[stpSavetblRegime] 
( 
@RegimeID int,
@RegimeStartDate datetime,
--@IsActiveRegime bit,
@VesselID int,
--@RegimeEndDate datetime
@Regime int
) 
AS 
BEGIN

 BEGIN TRY
    BEGIN TRAN

	Update tblRegime
	SET IsActiveRegime = 0, RegimeEndDate = @RegimeStartDate
	Where VesselID = @VesselID

	INSERT INTO tblRegime (RegimeID,RegimeStartDate,IsActiveRegime,VesselID,RegimeEndDate)
	Values(@Regime,@RegimeStartDate,1,@VesselID,NULL) 

	UPDATE Ship
    SET Regime=@Regime
    Where IMONumber = @VesselID

	COMMIT TRAN
 END TRY 

 BEGIN CATCH
	ROLLBACK TRAN
	SELECT ERROR_MESSAGE() AS ErrorMessage;  
 END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[stpSaveTimeAdjustment]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpSaveTimeAdjustment] 

  

( 

@AdjustmentDate datetime,

@AdjustmentValue varchar(30),
@VesselID int

) 



AS 

BEGIN 



BEGIN TRY



BEGIN TRAN



IF EXISTS (SELECT 1 FROM TimeAdjustment WHERE  CONVERT(varchar(12),AdjustmentDate,103)=  CONVERT(varchar(12),@AdjustmentDate,103) AND VesselID = @VesselID )



	BEGIN



		UPDATE TimeAdjustment

		SET AdjustmentValue = @AdjustmentValue

		WHERE CONVERT(varchar(12),AdjustmentDate,101) =  CONVERT(varchar(12),@AdjustmentDate,101) 





	END

ELSE

	BEGIN

			INSERT INTO TimeAdjustment 

			   (AdjustmentDate, AdjustmentValue,VesselID)  

		Values(@AdjustmentDate,@AdjustmentValue,@VesselID)



	END



EXEC stpUpdateTimeEntry  @AdjustmentDate,@AdjustmentValue,@VesselID

 

 



 COMMIT TRAN



 END TRY

 BEGIN CATCH

	ROLLBACK TRAN



	PRINT @@ERROR



 END CATCH

 



 END

GO
/****** Object:  StoredProcedure [dbo].[stpSaveWorkSessions]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-----
CREATE procedure [dbo].[stpSaveWorkSessions] 
( 

@ID int,
@CrewID int,
@ValidOn datetime,
@Hours nchar(48),
@Increment int,
@Comment nvarchar(200),
@Deleted bit,
@ActualHours nvarchar(200),
@OccuredOn datetime,
@ComplianceInfo xml,
@TotalNCHours float,
@AdjustmentFator varchar(20),
@Day1Update bit,
@NCDetailsID int,
@isNonCompliant bit,
@VesselID int,
@RegimeID int,
@WorkSessionId int OUTPUT,
@NewNCDetailsId int OUTPUT,
@IsTechnicalNC bit,
@Is24HoursCompliant bit,
@IsSevenDaysCompliant bit,
@PaintOrange bit

) 
AS 

BEGIN 

DECLARE @LastMinuSOneAdjustmentDate Datetime
DECLARE @BookCount INT
DECLARE @RowCount int 
DECLARE @WrkSessionId int

SET @RowCount = 0
SET @WrkSessionId = 0



Select @RowCount = COUNT(ValidOn) FROM  WorkSessions 
WHERE  CrewID = @CrewID 
AND MONTH(ValidON) = MONTH(@ValidOn)
AND DAY(ValidON) = DAY(@ValidOn)
AND YEAR(ValidOn) = YEAR(@ValidOn)
--And FLOOR(CAST(ValidOn as float)) = FLOOR(CAST(@ValidOn as float))
--AND CONVERT(VARCHAR(10),ValidOn,102) = CONVERT(VARCHAR(10),@ValidOn,102)



SELECT @LastMinuSOneAdjustmentDate = MAX(CONVERT(date,AdjustmentDate,110)) FROM TimeAdjustment
WHERE AdjustmentValue = '-1D'
AND CONVERT(DATE,AdjustmentDate,110) < CONVERT(DATE,@ValidOn,110)



IF @LastMinuSOneAdjustmentDate IS NOT NULL

BEGIN

	   SELECT  @BookCount = COUNT(*) 
		FROM WorkSessions 
		WHERE CONVERT(DATE,ValidOn,110) = CONVERT(DATE,@LastMinuSOneAdjustmentDate,110)
		AND CrewID = @CrewID

END

    

 IF @RowCount = 0 

BEGIN   



	BEGIN TRY
		BEGIN TRAN


			INSERT INTO WorkSessions(CrewID, ValidOn, [Hours], Increment, Comment, LatestUpdate, [Deleted],ActualHours,AdjustmentFator,VesselID,RegimeID)  
			Values(@CrewID, @ValidOn, @Hours, @Increment, @Comment,GETDATE(), 1,@ActualHours,@AdjustmentFator,@VesselID,@RegimeID) 


			SET @WrkSessionId = @@IDENTITY
			SET @WorkSessionId = @WrkSessionId

			INSERT INTO NCDetails(CrewID,OccuredOn,ComplianceInfo,TotalNCHours,WorkSessionId,isNC,VesselID,isTNC,isSevenDaysCompliant,is24HoursCompliant,PaintOrange)
			VALUES(@CrewID,@OccuredOn,@ComplianceInfo,@TotalNCHours,@WrkSessionId,@isNonCompliant,@VesselID,@IsTechnicalNC,@IsSevenDaysCompliant,@Is24HoursCompliant,@PaintOrange) 

			SET @NewNCDetailsId = @@IDENTITY


			


		COMMIT TRAN
	END TRY

BEGIN CATCH

	ROLLBACK TRAN

END CATCH
END
ELSE
BEGIN

		BEGIN TRY
			BEGIN TRAN

				IF (@LastMinuSOneAdjustmentDate IS NOT NULL AND @Day1Update = 0 )
					BEGIN
						--INSERT AGAIN A NEW ROW
						IF @BookCount = 1
							BEGIN

								INSERT INTO WorkSessions(CrewID, ValidOn, [Hours], Increment, Comment, LatestUpdate, [Deleted],ActualHours,AdjustmentFator,VesselID,RegimeID)  
								Values(@CrewID, @ValidOn, @Hours, @Increment, @Comment,GETDATE(), 1,@ActualHours,@AdjustmentFator,@VesselID,@RegimeID)


								SET @WrkSessionId = @@IDENTITY 


								INSERT INTO NCDetails(CrewID,OccuredOn,ComplianceInfo,TotalNCHours,WorkSessionId,VesselID,isNC,isTNC,isSevenDaysCompliant,is24HoursCompliant,PaintOrange)
								VALUES(@CrewID,@OccuredOn,@ComplianceInfo,@TotalNCHours,@WrkSessionId,@VesselID,@isNonCompliant,@IsTechnicalNC,@IsSevenDaysCompliant,@Is24HoursCompliant,@PaintOrange) 

								SET @NewNCDetailsId = @@IDENTITY
							END

				END 
				ELSE IF (@LastMinuSOneAdjustmentDate IS NULL AND @Day1Update = 0 ) -- FIRST DAY2 SAVE CASE
				BEGIN

						INSERT INTO WorkSessions(CrewID, ValidOn, [Hours], Increment, Comment, LatestUpdate, [Deleted],ActualHours,AdjustmentFator,VesselID,RegimeID)  
						Values(@CrewID, @ValidOn, @Hours, @Increment, @Comment,GETDATE(), 1,@ActualHours,@AdjustmentFator,@VesselID,@RegimeID) 

						SET @WrkSessionId = @@IDENTITY 

						INSERT INTO NCDetails(CrewID,OccuredOn,ComplianceInfo,TotalNCHours,WorkSessionId,VesselID,isNC,isTNC,isSevenDaysCompliant,is24HoursCompliant,PaintOrange)
						VALUES(@CrewID,@OccuredOn,@ComplianceInfo,@TotalNCHours,@WrkSessionId,@VesselID,@isNonCompliant,@IsTechnicalNC,@IsSevenDaysCompliant,@Is24HoursCompliant,@PaintOrange) 

						SET @NewNCDetailsId = @@IDENTITY
				END
				ELSE IF @Day1Update = 1
				BEGIN

						UPDATE WorkSessions	SET CrewID=@CrewID,
										    ValidOn=@ValidOn,
											[Hours]=@Hours,
											Increment=@Increment,
											Comment=@Comment,
											LatestUpdate=GETDATE(),
											Deleted=@Deleted,
											ActualHours=@ActualHours,
											AdjustmentFator=@AdjustmentFator,
											RegimeID=@RegimeID
											WHERE ID = @ID 

						SET @WrkSessionId = @ID

						UPDATE NCDetails SET ComplianceInfo = @ComplianceInfo,
										 TotalNCHours = @TotalNCHours,
										 isNC = @isNonCompliant,
										 isTNC = @IsTechnicalNC,
										 isSevenDaysCompliant = @IsSevenDaysCompliant,
										 is24HoursCompliant = @Is24HoursCompliant,
										 PaintOrange = @PaintOrange 
										 WHERE NCDetailsID = @NCDetailsID

						SET @NewNCDetailsId = @NCDetailsID

				END

				SET @WorkSessionId = @WrkSessionId

COMMIT TRAN



END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE() AS ErrorMessage
	ROLLBACK TRAN
END CATCH



END

END

GO
/****** Object:  StoredProcedure [dbo].[stpUpdateByResetPassword]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- UpdateResetPassword 'AMIT'
create PROCEDURE [dbo].[stpUpdateByResetPassword]
(
    --@ID int,
	@UserName varchar(21)
) 
AS
BEGIN

	UPDATE Users SET Password = 12345
	WHERE Username = @Username

END
GO
/****** Object:  StoredProcedure [dbo].[stpUpdateInActive]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpUpdateInActive]
(
	@ID int
)
AS
Begin
UPDATE Crew 
  SET IsActive= 0,
      DeactivationDate=GETDATE(),
	  DeletionDate = DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0))
WHERE ID= @ID 

UPDATE U
SET U.Active = 0
FROM Users U
Inner Join Crew C ON 
C.ID=U.CrewId

--AND DeactivationDate=GETDATE() 
--AND DeletionDate = DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0))
--AND IsActive = 1
End

GO
/****** Object:  StoredProcedure [dbo].[stpUpdateRanks]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpUpdateRanks]

(

	@RankOrder AS XML,
	@VesselID int

)

AS

BEGIN



	DECLARE @RankTab TABLE

	  (

		RankOrder int,

		RankName varchar(50)

	  )



	  INSERT INTO @RankTab(RankOrder,RankName)

	  SELECT DISTINCT

			'RankOrder' = x.v.value('rankid[1]','INT'),

			'RankName' = x.v.value('rankname[1]','VARCHAR(50)')

			 FROM @RankOrder.nodes('/root/row') x(v)





	 UPDATE r

	 SET r.[Order] = rt.RankOrder

	 from Ranks r

	 INNER JOIN @RankTab rt 

	 ON r.RankName = rt.RankName

	 Where r.VesselID = @VesselID

	

END

GO
/****** Object:  StoredProcedure [dbo].[stpUpdateShipByLastSyncDate]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--      Exec stpUpdateShipByLastSyncDate 10003
--      Exec stpUpdateShipByLastSyncDate 9876543
create PROCEDURE [dbo].[stpUpdateShipByLastSyncDate]
(
	@IMONumber int
)
AS
Begin

 BEGIN TRY 
    BEGIN TRAN

UPDATE Ship 
  SET LastSyncDate= GETDATE()
WHERE IMONumber= @IMONumber 
--AND IsActive = 1


INSERT INTO SyncData 
       (SyncDate,IMONumber)
SELECT GETDATE() ,@IMONumber


--End


COMMIT TRAN
 END TRY 

 BEGIN CATCH
	ROLLBACK TRAN
	SELECT ERROR_MESSAGE() AS ErrorMessage;  
 END CATCH

END

GO
/****** Object:  StoredProcedure [dbo].[stpUpdateTimeEntry]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpUpdateTimeEntry]

(

	@BookDate datetime,

	@AdjustmentFactor varchar(3),
	@VesselID int

)

AS

BEGIN



DECLARE @TimeSheet TABLE

(

  _ID int,

  _CrewID int,

  _ValidOn datetime,

  _hours nchar(48),

  _actualhours nvarchar(200),

  _adjustmentfactor varchar(10),
  VesselID int

)



DECLARE @actualhrs NVARCHAR(200)

DECLARE @hours NCHAR(48)

DECLARE @adjfactor VARCHAR(10)

DECLARE @id int



DECLARE @TimeTab TABLE

		  (

			ActHrs varchar(5)

		  )

	

	IF(@BookDate < GETDATE())

		BEGIN



			BEGIN TRY



					BEGIN TRAN



					IF(@AdjustmentFactor = '+1')

						BEGIN



						   DELETE FROM @TimeSheet



							INSERT INTO @TimeSheet(_ID,_CrewID,_ValidOn,_hours,_actualhours,_adjustmentfactor,VesselID) 

							SELECT ID,CrewID,ValidOn,Hours,ActualHours,AdjustmentFator,@VesselID

							FROM WorkSessions 

							WHERE FLOOR(CAST(ValidOn as float)) = FLOOR(CAST(@BookDate as float))

							AND VesselID = @VesselID

							SET @actualhrs = ''

							SET @hours = ''

							SET @adjfactor =''

							SET @id = 0



							

							

							DECLARE DB_CURSOR CURSOR FOR

							SELECT _actualhours,_hours,_adjustmentfactor,_id

							FROM  @TimeSheet

							Where VesselID = @VesselID

							OPEN DB_CURSOR

							FETCH NEXT FROM DB_CURSOR INTO @actualhrs,@hours,@adjfactor,@id



							WHILE @@FETCH_STATUS = 0

							BEGIN



								DELETE FROM   @TimeTab



								INSERT INTO @TimeTab(ActHrs)

								SELECT String FROM ufn_CSVToTable(@actualhrs,',')

								



								IF EXISTS(SELECT 1 FROM @TimeTab WHERE ActHrs = '00:00')

									BEGIN

										UPDATE @TimeSheet SET _actualhours = REPLACE(_actualhours,'00:00','01:00') WHERE _id = @id

										UPDATE @TimeSheet SET _hours = '00' + SUBSTRING(_hours,3,LEN(_hours)-3+1)

										,_adjustmentfactor= '+1' 

										WHERE _id = @id



									END



								FETCH NEXT FROM DB_CURSOR INTO @actualhrs,@hours,@adjfactor,@id

							END



							CLOSE DB_CURSOR

							DEALLOCATE DB_CURSOR



							UPDATE W 

							SET W.ActualHours = T._actualhours,

							W.Hours = T._hours,

							W.AdjustmentFator = T._adjustmentfactor

							FROM WorkSessions W

							INNER JOIN @TimeSheet T

							ON W.ID = T._ID

							AND W.VesselID = @VesselID

						END

					IF(@AdjustmentFactor = '+30')

						BEGIN

							print  '+30'



							DELETE FROM @TimeSheet

						    

							INSERT INTO @TimeSheet(_ID,_CrewID,_ValidOn,_hours,_actualhours,_adjustmentfactor,VesselID) 

							SELECT ID,CrewID,ValidOn,Hours,ActualHours,AdjustmentFator,@VesselID

							FROM WorkSessions 

							WHERE FLOOR(CAST(ValidOn as float)) = FLOOR(CAST(@BookDate as float))

							AND VesselID = @VesselID

							SET @actualhrs = ''

							SET @hours = ''

							SET @adjfactor =''

							SET @id = 0



							

							

							DECLARE DB_CURSOR30 CURSOR FOR

							SELECT _actualhours,_hours,_adjustmentfactor,_id

							FROM  @TimeSheet



							OPEN DB_CURSOR30

							FETCH NEXT FROM DB_CURSOR30 INTO @actualhrs,@hours,@adjfactor,@id



							WHILE @@FETCH_STATUS = 0

							BEGIN



								DELETE FROM   @TimeTab



								INSERT INTO @TimeTab(ActHrs)

								SELECT String FROM ufn_CSVToTable(@actualhrs,',')

								



								IF EXISTS(SELECT 1 FROM @TimeTab WHERE ActHrs = '00:00')

									BEGIN

										UPDATE @TimeSheet SET _actualhours = REPLACE(_actualhours,'00:00','00:30') WHERE _id = @id

										UPDATE @TimeSheet SET _hours = '01' + SUBSTRING(_hours,3,LEN(_hours)-3+1)

										,_adjustmentfactor= '+30'

										WHERE _id = @id



									END



								FETCH NEXT FROM DB_CURSOR30 INTO @actualhrs,@hours,@adjfactor,@id

							END



							CLOSE DB_CURSOR30

							DEALLOCATE DB_CURSOR30



							UPDATE W 

							SET W.ActualHours = T._actualhours,

							W.Hours = T._hours,

							W.AdjustmentFator = T._adjustmentfactor

							FROM WorkSessions W

							INNER JOIN @TimeSheet T

							ON W.ID = T._ID

							AND W.VesselID = @VesselID

						END

					IF(@AdjustmentFactor = '+1D')

						BEGIN

							print  '+1D'



							DELETE FROM @TimeSheet

						    

							INSERT INTO @TimeSheet(_ID,_CrewID,_ValidOn,_hours,_actualhours,_adjustmentfactor,VesselID) 

							SELECT ID,CrewID,ValidOn,Hours,ActualHours,AdjustmentFator,@VesselID

							FROM WorkSessions 

							WHERE FLOOR(CAST(ValidOn as float)) = FLOOR(CAST(@BookDate as float))


							AND VesselID = @VesselID
							



							DELETE FROM  WorkSessions

							WHERE ID IN ( SELECT _ID FROM @TimeSheet)



						END

				    IF(@AdjustmentFactor = '-1')

						BEGIN

							print  '-1'



							DELETE FROM @TimeSheet

						    

							INSERT INTO @TimeSheet(_ID,_CrewID,_ValidOn,_hours,_actualhours,_adjustmentfactor,VesselID) 

							SELECT ID,CrewID,ValidOn,Hours,ActualHours,AdjustmentFator,@VesselID

							FROM WorkSessions 

							WHERE FLOOR(CAST(ValidOn as float)) = FLOOR(CAST(@BookDate as float))

							AND VesselID = @VesselID

							SET @actualhrs = ''

							SET @hours = ''

							SET @adjfactor =''

							SET @id = 0



							

							

							DECLARE DB_CURSORM30 CURSOR FOR

							SELECT _actualhours,_hours,_adjustmentfactor,_id

							FROM  @TimeSheet



							OPEN DB_CURSORM30

							FETCH NEXT FROM DB_CURSORM30 INTO @actualhrs,@hours,@adjfactor,@id



							WHILE @@FETCH_STATUS = 0

							BEGIN

				

										UPDATE @TimeSheet SET 

										_adjustmentfactor= '-1'

										WHERE _id = @id



									



								FETCH NEXT FROM DB_CURSORM30 INTO @actualhrs,@hours,@adjfactor,@id

							END



							CLOSE DB_CURSORM30

							DEALLOCATE DB_CURSORM30



							UPDATE W 

							SET W.AdjustmentFator = T._adjustmentfactor

							FROM WorkSessions W

							INNER JOIN @TimeSheet T

							ON W.ID = T._ID

							AND W.VesselID = @VesselID

						END

				    IF(@AdjustmentFactor = '-30')

						BEGIN

							print  '-30'



							DELETE FROM @TimeSheet

						    

							INSERT INTO @TimeSheet(_ID,_CrewID,_ValidOn,_hours,_actualhours,_adjustmentfactor,VesselID) 

							SELECT ID,CrewID,ValidOn,Hours,ActualHours,AdjustmentFator,@VesselID

							FROM WorkSessions 

							WHERE FLOOR(CAST(ValidOn as float)) = FLOOR(CAST(@BookDate as float))

							AND VesselID = @VesselID

							SET @actualhrs = ''

							SET @hours = ''

							SET @adjfactor =''

							SET @id = 0



							

							

							DECLARE DB_CURSORM300 CURSOR FOR

							SELECT _actualhours,_hours,_adjustmentfactor,_id

							FROM  @TimeSheet



							OPEN DB_CURSORM300

							FETCH NEXT FROM DB_CURSORM300 INTO @actualhrs,@hours,@adjfactor,@id



							WHILE @@FETCH_STATUS = 0

							BEGIN

				

										UPDATE @TimeSheet SET 

										_adjustmentfactor= '-30'

										WHERE _id = @id



									



								FETCH NEXT FROM DB_CURSORM300 INTO @actualhrs,@hours,@adjfactor,@id

							END



							CLOSE DB_CURSORM300

							DEALLOCATE DB_CURSORM300



							UPDATE W 

							SET W.AdjustmentFator = T._adjustmentfactor

							FROM WorkSessions W

							INNER JOIN @TimeSheet T

							ON W.ID = T._ID

							AND W.VesselID = @VesselID

						END

                    IF(@AdjustmentFactor = '-1D')

						BEGIN

							print  '-1D'



							DELETE FROM @TimeSheet

						    

							INSERT INTO @TimeSheet(_ID,_CrewID,_ValidOn,_hours,_actualhours,_adjustmentfactor,VesselID) 

							SELECT ID,CrewID,ValidOn,Hours,ActualHours,AdjustmentFator,@VesselID

							FROM WorkSessions 

							WHERE FLOOR(CAST(ValidOn as float)) = FLOOR(CAST(@BookDate as float))

							AND VesselID = @VesselID

							SET @actualhrs = ''

							SET @hours = ''

							SET @adjfactor =''

							SET @id = 0



							

							

							DECLARE DB_CURSORM1D CURSOR FOR

							SELECT _actualhours,_hours,_adjustmentfactor,_id

							FROM  @TimeSheet



							OPEN DB_CURSORM1D

							FETCH NEXT FROM DB_CURSORM1D INTO @actualhrs,@hours,@adjfactor,@id



							WHILE @@FETCH_STATUS = 0

							BEGIN



								

										UPDATE @TimeSheet SET _adjustmentfactor= '-1D'

										WHERE _id = @id



									



								FETCH NEXT FROM DB_CURSORM1D INTO @actualhrs,@hours,@adjfactor,@id

							END



							CLOSE DB_CURSORM1D

							DEALLOCATE DB_CURSORM1D



							UPDATE W 

							SET W.ActualHours = T._actualhours,

							W.Hours = T._hours,

							W.AdjustmentFator = T._adjustmentfactor

							FROM WorkSessions W

							INNER JOIN @TimeSheet T

							ON W.ID = T._ID

							AND W.VesselID = @VesselID



							INSERT INTO WorkSessions(CrewID,ValidOn,Hours,Increment,Comment,LatestUpdate,Deleted,ActualHours,TimeAdjustment,AdjustmentFator, VesselID)

							SELECT CrewID,ValidOn,Hours,Increment,Comment,LatestUpdate,Deleted,ActualHours,TimeAdjustment,AdjustmentFator , VesselID

							FROM WorkSessions

							WHERE FLOOR(CAST(ValidOn as float)) = FLOOR(CAST(@BookDate as float))

							AND VesselID = @VesselID

						END

					COMMIT TRAN

			END TRY

			BEGIN CATCH

					ROLLBACK TRAN

					PRINT @@ERROR

			END CATCH





		END



END

GO
/****** Object:  StoredProcedure [dbo].[stpUpdateVessel]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[stpUpdateVessel]
(
    @VesselTypeID int,
    @VesselSubTypeID int,
    @VesselSubSubTypeID int,

	@ShipName varchar(21),
	@FlagOfShip varchar(50),
	@IMONumber int, -----------

	@ShipEmail varchar(200),
	@ShipEmail2 varchar(100),
    @Voices1 varchar(100),
    @Voices2 varchar(100),
    @Fax1 varchar(100),
    @Fax2 varchar(100),
    @VOIP1 varchar(100),
    @VOIP2 varchar(100),
    @Mobile1 varchar(100),
    @Mobile2 varchar(100)
) 
AS
BEGIN

	UPDATE Ship SET VesselTypeID=@VesselTypeID, VesselSubTypeID=@VesselSubTypeID, VesselSubSubTypeID=@VesselSubSubTypeID, 
                        ShipName=@ShipName, FlagOfShip=@FlagOfShip, ShipEmail=@ShipEmail, ShipEmail2=@ShipEmail2,
                        Voices1=@Voices1, Voices2=@Voices2, Fax1=@Fax1, Fax2=@Fax2, VOIP1=@VOIP1, VOIP2=@VOIP2,
                        Mobile1=@Mobile1, Mobile2=@Mobile2 
	WHERE IMONumber = @IMONumber

END


GO
/****** Object:  StoredProcedure [dbo].[stpUserAuthentication]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec stpUserAuthentication 'sa', '12345'

CREATE procedure [dbo].[stpUserAuthentication]

(

	@Username nvarchar(200),

	@Password nvarchar(200)
	--@VesselID  int

)

AS



Begin



SELECT ISNULL(

(Select ID 

from Users  

Where Username=@Username 

AND [Password]=@Password 
--AND VesselID = @VesselID
AND Active= 1),0)



End

GO
/****** Object:  StoredProcedure [dbo].[stpValidateFirstRun]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--CompanyDetails
--Ship
--FirstRun

CREATE PROCEDURE [dbo].[stpValidateFirstRun]
(
	@Msg varchar(100) OUTPUT
)
AS
BEGIN

	DECLARE @isFirstUser Bit
	DECLARE @CompanyCount int
	DECLARE @ShipCount int

	SET @isFirstUser = 1
	SET @CompanyCount = 0
	SET @ShipCount = 0

	SELECT @CompanyCount =  COUNT(*) FROM CompanyDetails

	if @CompanyCount = 1
	BEGIN
		SET @isFirstUser = 0
		SET @Msg = 'Cannot Set Multiple Values For Company Or Ship'
	END

	SELECT @ShipCount = COUNT(*) FROM Ship
			
	IF @ShipCount = 1
	BEGIN

		SET @isFirstUser = 0
		SET @Msg = 'Cannot Set Multiple Values For Company Or Ship'	

	END



END

GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllAdminCrewForDrp]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec usp_GetAllAdminCrewForDrp 9876543
CREATE procedure [dbo].[usp_GetAllAdminCrewForDrp]
(

	@VesselID int

)
AS
Begin
Select C.ID, FirstName + '  ' +LastName AS Name, C.VesselID
from Crew C
      INNER JOIN Users U
	  ON C.ID = U.CrewId
	  INNER JOIN UserGroups UG
	  ON U.ID=UG.UserID    
	  Where GroupID = 14   AND C.VesselID=@VesselID 
	  AND Deletiondate >= GetDate()
End

GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllCountryForDrp]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  exec usp_GetAllCountryForDrp
CREATE procedure [dbo].[usp_GetAllCountryForDrp]
--(
--@VesselID int
--)
AS
Begin
Select CountryID, CountryName--,VesselID
from dbo.CountryMaster
--Where VesselID=@VesselID
End

GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllCrewForDrp]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec usp_GetAllCrewForDrp 9876543, 42
CREATE procedure [dbo].[usp_GetAllCrewForDrp]
(
	@VesselID int,
	@UserID int
)
AS

Begin
Declare @SuperAdminID int
Declare @UserGroupID int 

Select @SuperAdminID = ID from Groups Where GroupName = 'Super Admin'

Select @UserGroupID = GroupID from UserGroups Where UserID = @UserID

if @UserGroupID = @SuperAdminID
Begin

Select DISTINCT ID, FirstName + '  ' +LastName AS Name, VesselID
from dbo.Crew
Where VesselID=@VesselID

AND IsActive=1
End
Else 
Begin
Select ID, FirstName + '  ' +LastName AS Name, C.VesselID
from dbo.Crew C
Left Outer Join DepartmentAdmin DA
ON C.ID = DA.CrewID
Where C.VesselID= @VesselID 
And DA.CrewID = (Select CrewID From Users Where ID = @UserID)
  AND Deletiondate >= GetDate()

  AND IsActive=1

Union 

Select ID, FirstName + '  ' +LastName AS Name, C.VesselID
from dbo.Crew C
Left Outer Join DepartmentAdmin DA
ON C.ID = DA.CrewID
Where C.VesselID= @VesselID 
And C.DepartmentMasterID IN (Select DepartmentMasterID From DepartmentAdmin Where CrewID = (Select CrewID From Users Where ID = @UserID))
  AND Deletiondate >= GetDate()

  AND IsActive=1

Union

Select ID, FirstName + '  ' +LastName AS Name, C.VesselID
from dbo.Crew C
--Left Outer Join DepartmentAdmin DA
--ON C.ID = DA.CrewID
Where C.VesselID= @VesselID 
--And C.DepartmentMasterID = (Select DepartmentMasterID From DepartmentAdmin Where CrewID = 5)
And C.ID = (Select CrewID From Users Where ID = @UserID)
  AND Deletiondate >= GetDate()

  AND IsActive=1
End
End

GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllCrewForTimeSheet]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec usp_GetAllCrewForTimeSheet 9876543, 1
CREATE procedure [dbo].[usp_GetAllCrewForTimeSheet]
(
	@VesselID int,
	@UserID int
)
AS

Begin
Declare @SuperAdminID int
Declare @UserGroupID int 
DECLARE @CrewTab TABLE
(
	ID int,
	Name varchar(100),
	VesselID int
)

Select @SuperAdminID = ID from Groups Where GroupName = 'Super Admin'

Select @UserGroupID = GroupID from UserGroups Where UserID = @UserID

IF @UserGroupID = @SuperAdminID
Begin

Select DISTINCT C.ID, FirstName + '  ' +LastName AS Name, C.VesselID
from dbo.Crew C
INNER JOIN ServiceTerms ST
ON C.ID = ST.CrewID

Where C.VesselID=@VesselID
and C.IsActive =  1  ----------------------------------------- deep
or C.IsActive is NULL  ----------------------------------------- deep
End
Else 
Begin

Select DISTINCT c.ID, FirstName + '  ' +LastName AS Name, C.VesselID
from dbo.Crew C
INNER JOIN ServiceTerms ST
ON C.ID = ST.CrewID
Left Outer Join DepartmentAdmin DA
ON C.ID = DA.CrewID
Where C.VesselID= @VesselID 
And DA.CrewID = (Select CrewID From Users Where ID = @UserID)
  AND Deletiondate >= GetDate()
 

Union 

Select C.ID, FirstName + '  ' +LastName AS Name, C.VesselID
from dbo.Crew C
INNER JOIN ServiceTerms ST
ON C.ID = ST.CrewID
Left Outer Join DepartmentAdmin DA
ON C.ID = DA.CrewID
Where C.VesselID= @VesselID 
And C.DepartmentMasterID IN (Select DepartmentMasterID From DepartmentAdmin Where CrewID = (Select CrewID From Users Where ID = @UserID))
  AND Deletiondate >= GetDate()
  
Union

Select C.ID, FirstName + '  ' +LastName AS Name, C.VesselID
from dbo.Crew C
INNER JOIN ServiceTerms ST
ON C.ID = ST.CrewID
Where C.VesselID= @VesselID 
And C.ID = (Select CrewID From Users Where ID = @UserID)
  AND Deletiondate >= GetDate()
 
End
End

GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllDepartmentForDrp]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  exec usp_GetAllDepartmentForDrp '9876543'

CREATE procedure [dbo].[usp_GetAllDepartmentForDrp]
(
@VesselID int
)
AS
Begin
Select DepartmentMasterID, DepartmentMasterName, VesselID
from dbo.DepartmentMaster
Where VesselID=@VesselID
End

GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllGroupsForDrp]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_GetAllGroupsForDrp]
(
@VesselID int
)
AS



Begin

Select ID, GroupName,VesselID

from dbo.Groups
Where VesselID=@VesselID
End

GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllRanksForDrp]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_GetAllRanksForDrp]
(
@VesselID int
)
AS



Begin

Select ID AS RankID, RankName, VesselID

from dbo.Ranks
Where VesselID=@VesselID
End

GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllShipForDrp]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_GetAllShipForDrp]

AS



Begin

Select ID , ShipName

from dbo.Ship

End

GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllSpecialityForDrp]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--   exec usp_GetAllSpecialityForDrp

CREATE procedure [dbo].[usp_GetAllSpecialityForDrp]
--(
--@VesselID int
--)
AS
Begin
Select SpecialityID, SpecialityName
from SpecialityMaster
--Where VesselID=@VesselID
End

GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllUserCrewForDrp]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec usp_GetAllUserCrewForDrp 9876543
CREATE procedure [dbo].[usp_GetAllUserCrewForDrp]
(

	@VesselID int

)
AS
Begin
Select C.ID, FirstName + '  ' +LastName AS Name, C.VesselID
from Crew C
      INNER JOIN Users U
	  ON C.ID = U.CrewId
	  INNER JOIN UserGroups UG
	  ON U.ID=UG.UserID    
	  Where GroupID = 15   AND C.VesselID=@VesselID
End

GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllUsersForDrp]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_GetAllUsersForDrp]
(
@VesselID int
)
AS



Begin

Select ID, Username, VesselID

from dbo.Users
Where VesselID=@VesselID
End




/********* Strat Tag ************** New SP Deep 02.09.2020 ******/
GO
/****** Object:  StoredProcedure [dbo].[stpGetVesselTypeIDFromShip]    Script Date: 02/09/2020 11:17:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- stpGetVesselTypeIDFromShip

create PROCEDURE [dbo].[stpGetVesselTypeIDFromShip]
--(
	--@ID int
--)
AS
Begin
Select isnull(VesselTypeID,0)  as VesselTypeID
FROM Ship
--WHERE ID= @ID
End


GO
/****** Object:  StoredProcedure [dbo].[stpGetVesselSubTypeIDFromShip]    Script Date: 02/09/2020 11:23:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- stpGetVesselSubTypeIDFromShip

create PROCEDURE [dbo].[stpGetVesselSubTypeIDFromShip]
--(
	--@ID int
--)
AS
Begin
Select isnull(VesselSubTypeID,0)  as VesselSubTypeID
FROM Ship
--WHERE ID= @ID
End


GO
/****** Object:  StoredProcedure [dbo].[stpGetVesselSubSubTypeIDFromShip]    Script Date: 02/09/2020 11:24:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- stpGetVesselSubSubTypeIDFromShip

create PROCEDURE [dbo].[stpGetVesselSubSubTypeIDFromShip]
--(
	--@ID int
--)
AS
Begin
Select isnull(VesselSubSubTypeID,0)  as VesselSubSubTypeID
FROM Ship
--WHERE ID= @ID
End


GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewTemperaturePageWieByCrewID2]    Script Date: 02/09/2020 11:25:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--  declare @x int Exec stpGetCrewTemperaturePageWieByCrewID2  1, 1,10, @x out

create procedure [dbo].[stpGetCrewTemperaturePageWieByCrewID2]
(
      @CrewID int,	
      @PageIndex INT = 1,
      @PageSize INT = 10,
      @RecordCount INT OUTPUT
)
AS
BEGIN
      SET NOCOUNT ON;
      SELECT ROW_NUMBER() OVER
      (
            ORDER BY [CrewID]ASC
      )AS RowNumber
            --,CT.ID
	   --,CT.CrewID
	   --,C.Name AS Crew
	   ,CT.ReadingDate
	   ,CT.ReadingTime
	   ,C.FirstName + ' ' + C.LastName AS CrewName
	   ,R.RankName
	   ,CT.Place
	   ,TM.Mode AS TemperatureMode
	   ,CT.Temperature
	   ,CT.Unit
	   ,CT.Means
	   	  
     INTO #Results
FROM CrewTemperature CT
inner JOIN TemperatureMode TM
ON CT.TemperatureModeID= TM.ID
inner JOIN Crew C
ON CT.CrewID= C.ID

inner JOIN Ranks R
ON C.RankID= R.ID
WHERE CT.CrewID= @CrewID
      SELECT @RecordCount = COUNT(*)
      FROM #Results
      SELECT * FROM #Results
      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1
	 -- ORDER BY [Order] ASC
      DROP TABLE #Results
END


GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewForCIRMPatientDetails]    Script Date: 02/09/2020 11:27:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec stpGetCrewForCIRMPatientDetails

create PROCEDURE [dbo].[stpGetCrewForCIRMPatientDetails]
AS
Begin
Select  ID,

        FirstName + ' ' + LastName As CrewName,
	    RankID,
		Gender,
		CountryID,
		DOB,
		CreatedOn

FROM dbo.Crew

--WHERE ID= @ID

End


GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewForCIRMPatientDetailsByCrew]    Script Date: 02/09/2020 11:27:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec stpGetCrewForCIRMPatientDetailsByCrew 1

create PROCEDURE [dbo].[stpGetCrewForCIRMPatientDetailsByCrew]
(
  @ID int
)
AS
Begin
Select  ID,

        --FirstName + ' ' + LastName As CrewName,
	    RankID,
		Gender,
		CountryID,
		DOB,
	    CreatedOn

FROM dbo.Crew

WHERE ID= @ID

End


GO
/****** Object:  StoredProcedure [dbo].[stpSaveCrewTemperature]    Script Date: 02/09/2020 11:27:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[stpSaveCrewTemperature]
(
	@CrewID	int,
	@Temperature	decimal,
	@Unit	varchar(5),
	@ReadingDate	varchar(50),
	@ReadingTime	varchar(5),
	@Comment		varchar(500),
	@TemperatureModeID INT,
	@VesselID int,
		@Place		varchar(100),
			@Means		varchar(100)
)
AS
BEGIN
	INSERT INTO CrewTemperature(CrewID, Temperature, Unit, ReadingDate, ReadingTime, Comment,TemperatureModeID,VesselID,Place,Means) VALUES
	(@CrewID, @Temperature, @Unit, @ReadingDate, @ReadingTime,@Comment,@TemperatureModeID,@VesselID,@Place,@Means)
END

GO
/****** Object:  StoredProcedure [dbo].[stpSaveVesselDetails]    Script Date: 02/09/2020 11:30:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  exec stpSaveVesselDetails 1, 'xyzzzzz'

create PROCEDURE [dbo].[stpSaveVesselDetails]
(
  @ID int,
  @VesselName varchar(50),
@CallSign varchar(50),
@DateOfReportingGMT varchar(50),
@TimeOfReportingGMT varchar(5),
@PresentLocation varchar(50),
@Course varchar(50),
@Speed varchar(50),
@PortOfDeparture varchar(50),
@PortOfArrival varchar(50),
@ETADateGMT varchar(50),
@ETATimeGMT varchar(5),
@AgentDetails varchar(500),
@NearestPortETADateGMT varchar(50),
@NearestPortETATimeGMT varchar(5),
@WindSpeed varchar(20),
@Sea varchar(20),
@Visibility varchar(20),
@Swell varchar(20)  
)

AS
BEGIN

 IF @ID IS NULL

BEGIN 
	INSERT INTO VesselDetails( VesselName,CallSign,DateOfReportingGMT,TimeOfReportingGMT,PresentLocation,Course,Speed,
	PortOfDeparture,PortOfArrival,ETADateGMT,ETATimeGMT,AgentDetails,NearestPortETADateGMT,NearestPortETATimeGMT,
	WindSpeed,Sea,Visibility,Swell)

	VALUES (@VesselName,@CallSign,@DateOfReportingGMT,@TimeOfReportingGMT,@PresentLocation,@Course,@Speed,
	@PortOfDeparture,@PortOfArrival,@ETADateGMT,@ETATimeGMT,@AgentDetails,@NearestPortETADateGMT,@NearestPortETATimeGMT,
	@WindSpeed,@Sea,@Visibility,@Swell)

END

END


GO
/****** Object:  StoredProcedure [dbo].[SPROC_Builder]    Script Date: 02/09/2020 11:52:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec SPROC_Builder 'stpInsertUpdateAdmissionForm', 'INSERT'
--exec SPROC_Builder 'stpGetActualAdmissionByID', 'Get'
create PROCEDURE [dbo].[SPROC_Builder] 
(
@objName nvarchar(100),
@spType nvarchar(10)
)
AS
/*
___________________________________________________________________
Name:  		CS SPROC Builder
Version: 	1
Date:    	10/18/2019
Author:  	Dheeman Dutta

SET NOCOUNT ON
*/
DECLARE @parameterCount int
DECLARE @errMsg varchar(100)
DECLARE @parameterAt varchar(1)
DECLARE @connName varchar(100)
DECLARE @outputValues varchar(100)
--Change the following variable to the name of your connection instance
SET @connName='conn.Connection'
SET @parameterAt=''
SET @outputValues=''
SELECT 
 	dbo.sysobjects.name AS ObjName, 
 	dbo.sysobjects.xtype AS ObjType,
 	dbo.syscolumns.name AS ColName, 
 	dbo.syscolumns.colorder AS ColOrder, 
 	dbo.syscolumns.length AS ColLen, 
 	dbo.syscolumns.colstat AS ColKey, 
 	dbo.syscolumns.isoutparam AS ColIsOut,
 	dbo.systypes.xtype
INTO #t_obj
FROM         
 	dbo.syscolumns INNER JOIN
 	dbo.sysobjects ON dbo.syscolumns.id = dbo.sysobjects.id INNER JOIN
 	dbo.systypes ON dbo.syscolumns.xtype = dbo.systypes.xtype
WHERE     
 	(dbo.sysobjects.name = @objName) 
 	AND 
 	(dbo.systypes.status <> 1) 
ORDER BY 
 	--dbo.sysobjects.name, 
 	dbo.syscolumns.colorder

SET @parameterCount=(SELECT count(*) FROM #t_obj)
IF(@parameterCount<1) SET @errMsg='No Parameters/Fields found for ' + @objName
IF(@errMsg is null)
	BEGIN
  		PRINT 'try'
  		PRINT '   {'
  		/*PRINT '   SqlParameter[] paramsToStore = new SqlParameter[' + cast(@parameterCount as varchar) + '];'*/
  		PRINT ''
  
  		DECLARE @source_name nvarchar,@source_type varchar,
    			@col_name nvarchar(100),@col_order int,@col_type varchar(20),
    			@col_len int,@col_key int,@col_xtype int,@col_redef varchar(20), @col_isout tinyint
 
  		DECLARE cur CURSOR FOR
  		SELECT * FROM #t_obj 
		ORDER BY ColOrder
  		OPEN cur
  		-- Perform the first fetch.
  		FETCH NEXT FROM cur INTO @source_name,@source_type,@col_name,@col_order,@col_len,@col_key,@col_isout,@col_xtype
 
  			if(@source_type=N'U') SET @parameterAt='@'
  			-- Check @@FETCH_STATUS to see if there are any more rows to fetch.
  			WHILE @@FETCH_STATUS = 0
  				BEGIN
   				SET @col_redef=(SELECT CASE @col_xtype
					WHEN 34 THEN 'Image'
					WHEN 35 THEN 'Text'
					WHEN 36 THEN 'UniqueIdentifier'
					WHEN 48 THEN 'TinyInt'
					WHEN 52 THEN 'SmallInt'
					WHEN 56 THEN 'Int'
					WHEN 58 THEN 'SmallDateTime'
					WHEN 59 THEN 'Real'
					WHEN 60 THEN 'Money'
					WHEN 61 THEN 'DateTime'
					WHEN 62 THEN 'Float'
					WHEN 99 THEN 'NText'
					WHEN 104 THEN 'Bit'
					WHEN 106 THEN 'Decimal'
					WHEN 122 THEN 'SmallMoney'
					WHEN 127 THEN 'BigInt'
					WHEN 165 THEN 'VarBinary'
					WHEN 167 THEN 'VarChar'
					WHEN 173 THEN 'Binary'
					WHEN 175 THEN 'Char'
					WHEN 231 THEN 'NVarChar'
					WHEN 239 THEN 'NChar'
					ELSE '!MISSING'
					END AS C) 

				--Write out the parameter
				
                PRINT 'cmd.Parameters.AddWithValue("' + @parameterAt + @col_name + '",'+ SUBSTRING(@col_name,2,LEN(@col_name)) +');'

				--Write out the parameter direction it is output
				IF(@col_isout=1)
					BEGIN
						PRINT '   paramsToStore['+ cast(@col_order-1 as varchar) +'].Direction=ParameterDirection.Output;'
						SET @outputValues=@outputValues+'   ?=paramsToStore['+ cast(@col_order-1 as varchar) +'].Value;'

						PRINT 'String outputVal = (String)(cmd.Parameters["' + @parameterAt + @col_name + '"].Value);'
					END
					

				 -- This is executed as long as the previous fetch succeeds.
      			FETCH NEXT FROM cur INTO @source_name,@source_type,@col_name,@col_order, @col_len,@col_key,@col_isout,@col_xtype 
  	END
  PRINT ''
  IF UPPER(LTRIM(RTRIM(@spType))) = 'INSERT' OR UPPER(LTRIM(RTRIM(@spType))) = 'UPDATE' OR UPPER(LTRIM(RTRIM(@spType))) = 'DELETE' 
  BEGIN
	PRINT 'int recordsAffected = cmd.ExecuteNonQuery();'
	PRINT 'conn.Close();'



  END
  ELSE IF UPPER(LTRIM(RTRIM(@spType))) = 'SELECT'
  BEGIN
	 PRINT 'DataSet ds = new DataSet();'
	 PRINT 'SqlDataAdapter da = new SqlDataAdapter(cmd);'
	 PRINT ' da.Fill(ds);'
	 PRINT 'con.Close();'
  END
  --PRINT @outputValues
  --PRINT '   }'
  PRINT 'catch(Exception excp)'
  PRINT '   {'
  PRINT '   }'
  --PRINT 'finally'
  --PRINT '   {'
  --PRINT '   ' + @connName + '.Dispose();'
  --PRINT '   ' + @connName + '.Close();'
  --PRINT '   }'  
  CLOSE cur
  DEALLOCATE cur
 END
if(LEN(@errMsg)>0) PRINT @errMsg
DROP TABLE #t_obj
SET NOCOUNT ON




GO
/****** Object:  StoredProcedure [dbo].[usp_GetVesselTypeForDrp]    Script Date: 02/09/2020 2:14:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec usp_GetVesselTypeForDrp
create procedure [dbo].[usp_GetVesselTypeForDrp]
AS

Begin
Select ID,[Description]
from VesselType
End



GO
/****** Object:  StoredProcedure [dbo].[usp_GetVesselSubTypeByVesselTypeIDForDrp]    Script Date: 02/09/2020 2:15:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec usp_GetVesselSubTypeByVesselTypeIDForDrp 1
create PROCEDURE [dbo].[usp_GetVesselSubTypeByVesselTypeIDForDrp]
(
	@VesselTypeID int
)
AS

Begin
Select ID, SubTypeDescription
FROM VesselSubType
WHERE VesselTypeID= @VesselTypeID
End



GO
/****** Object:  StoredProcedure [dbo].[usp_GetVesselSubSubTypeByVesselSubTypeIDForDrp]    Script Date: 02/09/2020 2:16:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec usp_GetVesselSubSubTypeByVesselSubTypeIDForDrp 1
create PROCEDURE [dbo].[usp_GetVesselSubSubTypeByVesselSubTypeIDForDrp]
(
	@VesselSubTypeID int
)
AS

Begin
Select ID, VesselSubSubTypeDecsription
FROM VesselSubSubType
WHERE VesselSubTypeID= @VesselSubTypeID
End



GO
/****** Object:  StoredProcedure [dbo].[stpGetTemperatureMode]    Script Date: 02/09/2020 2:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stpGetTemperatureMode]

AS
Begin

Select ID,  Mode 
from TemperatureMode
End



GO
/****** Object:  StoredProcedure [dbo].[stpGetMedicineAll]    Script Date: 02/09/2020 2:18:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[stpGetMedicineAll]
AS
BEGIN
Select MedicineID, MedicineName, Quantity, ExpiryDate, Location from tblMedicine
END




GO
/****** Object:  StoredProcedure [dbo].[stpGetEqipmentAll]    Script Date: 02/09/2020 2:19:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[stpGetEqipmentAll]
AS
BEGIN
Select EquipmentsID, EquipmentsName, Comment, Quantity, ExpiryDate, Location from tblEquipments
END



GO
/****** Object:  StoredProcedure [dbo].[stpSaveShip]    Script Date: 02/09/2020 2:20:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  exec stpSaveShips 1, 'xyzzzzz'

create PROCEDURE [dbo].[stpSaveShip]
(
@ID int,
@ShipName nvarchar(21),
@IMONumber int,
@FlagOfShip nvarchar(50),
--@Regime int,
--@LastSyncDate datetime,
--@CompanyID int,
@ShipEmail varchar(200),
@VesselTypeID int,
@VesselSubTypeID int,
@VesselSubSubTypeID int,
@ShipEmail2 varchar(100),
@Voices1 varchar(100),
@Voices2 varchar(100),
@Fax1 varchar(100),
@Fax2 varchar(100),
@VOIP1 varchar(100),
@VOIP2 varchar(100),
@Mobile1 varchar(100),
@Mobile2 varchar(100)
--@CommunicationsResources varchar(100),
--@HelicopterDeck int,
--@HelicopterWinchingArea int  
)

AS
BEGIN

 IF @ID IS NULL

BEGIN 
	Insert into Ship (ShipName,IMONumber,FlagOfShip,
	                  --Regime,LastSyncDate,CompanyID,
					  ShipEmail,VesselTypeID,VesselSubTypeID,
	                  VesselSubSubTypeID,ShipEmail2,Voices1,Voices2,Fax1,Fax2,VOIP1,VOIP2,Mobile1,Mobile2
					  --,CommunicationsResources,HelicopterDeck,HelicopterWinchingArea
					  )
	values(@ShipName,@IMONumber,@FlagOfShip,
	       --@Regime,@LastSyncDate,@CompanyID,
		   @ShipEmail,@VesselTypeID,@VesselSubTypeID,@VesselSubSubTypeID,@ShipEmail2,@Voices1,@Voices2,@Fax1,
		   @Fax2,@VOIP1,@VOIP2,@Mobile1,@Mobile2
		   --,@CommunicationsResources,@HelicopterDeck,@HelicopterWinchingArea
		   )
END

END





GO
/****** Object:  StoredProcedure [dbo].[stpSaveShipNew]    Script Date: 02/09/2020 2:22:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  exec stpSaveShips 1, 'xyzzzzz'

create PROCEDURE [dbo].[stpSaveShipNew]
(
@ID int,
@ShipName nvarchar(21),
@IMONumber int,
@FlagOfShip nvarchar(50),
--@Regime int,
--@LastSyncDate datetime,
--@CompanyID int,
@ShipEmail varchar(200),
@VesselTypeID int,
@VesselSubTypeID int,
@VesselSubSubTypeID int,
@ShipEmail2 varchar(100),
@Voices1 varchar(100),
@Voices2 varchar(100),
@Fax1 varchar(100),
@Fax2 varchar(100),
@VOIP1 varchar(100),
@VOIP2 varchar(100),
@Mobile1 varchar(100),
@Mobile2 varchar(100)
--@CommunicationsResources varchar(100),
--@HelicopterDeck int,
--@HelicopterWinchingArea int  
)

AS
BEGIN

 IF @ID IS NULL

BEGIN 
	Insert into Ship (ShipName,IMONumber,FlagOfShip,
	                  --Regime,LastSyncDate,CompanyID,
					  ShipEmail,VesselTypeID,VesselSubTypeID,
	                  VesselSubSubTypeID,ShipEmail2,Voices1,Voices2,Fax1,Fax2,VOIP1,VOIP2,Mobile1,Mobile2
					  --,CommunicationsResources,HelicopterDeck,HelicopterWinchingArea
					  )
	values(@ShipName,@IMONumber,@FlagOfShip,
	       --@Regime,@LastSyncDate,@CompanyID,
		   @ShipEmail,@VesselTypeID,@VesselSubTypeID,@VesselSubSubTypeID,@ShipEmail2,@Voices1,@Voices2,@Fax1,
		   @Fax2,@VOIP1,@VOIP2,@Mobile1,@Mobile2
		   --,@CommunicationsResources,@HelicopterDeck,@HelicopterWinchingArea
		   )
END

END





GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewTemperaturePageWieByCrewID]    Script Date: 02/09/2020 2:27:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--  declare @x int Exec stpGetCrewTemperaturePageWieByCrewID  1, 1,10, @x out

create procedure [dbo].[stpGetCrewTemperaturePageWieByCrewID]
(
      @CrewID int,	
      @PageIndex INT = 1,
      @PageSize INT = 10,
      @RecordCount INT OUTPUT
)
AS
BEGIN
      SET NOCOUNT ON;
      SELECT ROW_NUMBER() OVER
      (
            ORDER BY [CrewID]ASC
      )AS RowNumber
              --,CT.ID
	   --,CT.CrewID
	   --,C.Name AS Crew
	   ,CT.ReadingDate
	   ,CT.ReadingTime
	   ,C.FirstName + ' ' + C.LastName AS CrewName
	   ,R.RankName
	   ,CT.Place
	   ,TM.Mode AS TemperatureMode
	   ,CT.Temperature
	   ,CT.Unit
	   ,CT.Means
	   	  
     INTO #Results
FROM CrewTemperature CT
inner JOIN TemperatureMode TM
ON CT.TemperatureModeID= TM.ID
inner JOIN Crew C
ON CT.CrewID= C.ID

inner JOIN Ranks R
ON C.RankID= R.ID
WHERE CT.CrewID= @CrewID
      SELECT @RecordCount = COUNT(*)
      FROM #Results
      SELECT * FROM #Results
      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1
	 -- ORDER BY [Order] ASC
      DROP TABLE #Results
END



GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewTemperaturePageWie]    Script Date: 16-12-2020 12:40:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  declare @x int Exec stpGetCrewTemperaturePageWie  1,100, @x out

CREATE procedure [dbo].[stpGetCrewTemperaturePageWie]
(
    
      @PageIndex INT = 1,
      @PageSize INT = 10,
      @RecordCount INT OUTPUT
)
AS
BEGIN
      SET NOCOUNT ON;
      SELECT ROW_NUMBER() OVER
      (
            ORDER BY [CrewID]ASC
      )AS RowNumber
       --,CT.ID
	   --,CT.CrewID
	   --,C.Name AS Crew
	   ,CT.ReadingDate
	   ,CT.ReadingTime
	   ,C.FirstName + ' ' + C.LastName AS CrewName
	   ,R.RankName
	   ,CT.Place
	   ,TM.Mode AS TemperatureMode
	   ,CT.Temperature
	   ,CT.Unit
	   ,CT.Means
	   	  
     INTO #Results
FROM CrewTemperature CT
inner JOIN TemperatureMode TM
ON CT.TemperatureModeID= TM.ID
inner JOIN Crew C
ON CT.CrewID= C.ID

inner JOIN Ranks R
ON C.RankID= R.ID

WHERE CT.CrewID= CrewID
      SELECT @RecordCount = COUNT(*)
      FROM #Results
      SELECT * FROM #Results
      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1
	 -- ORDER BY [Order] ASC
      DROP TABLE #Results
END




GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewTemperaturePageWie2]    Script Date: 16-12-2020 12:40:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  declare @x int Exec stpGetCrewTemperaturePageWie2  1,100, @x out

CREATE procedure [dbo].[stpGetCrewTemperaturePageWie2]
(
    
      @PageIndex INT = 1,
      @PageSize INT = 10,
      @RecordCount INT OUTPUT
)
AS
BEGIN
      SET NOCOUNT ON;
      SELECT ROW_NUMBER() OVER
      (
            ORDER BY [CrewID]ASC
      )AS RowNumber
       --,CT.ID
	   --,CT.CrewID
	   --,C.Name AS Crew
	   ,CT.ReadingDate
	   ,CT.ReadingTime
	   ,C.FirstName + ' ' + C.LastName AS CrewName
	   ,R.RankName
	   ,CT.Place
	   ,TM.Mode AS TemperatureMode
	   ,CT.Temperature
	   ,CT.Unit
	   ,CT.Means
	   	  
     INTO #Results
FROM CrewTemperature CT
inner JOIN TemperatureMode TM
ON CT.TemperatureModeID= TM.ID
inner JOIN Crew C
ON CT.CrewID= C.ID

inner JOIN Ranks R
ON C.RankID= R.ID

WHERE CT.CrewID= CrewID
      SELECT @RecordCount = COUNT(*)
      FROM #Results
      SELECT * FROM #Results
      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1
	 -- ORDER BY [Order] ASC
      DROP TABLE #Results
END




GO
/****** Object:  StoredProcedure [dbo].[stpGetCIRMByCrewId]    Script Date: 03/09/2020 1:59:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec stpGetCIRMByCrewId 19

create PROCEDURE [dbo].[stpGetCIRMByCrewId]
(
	@CrewId int
)
AS
Begin
Select IsEquipmentUploaded, IsJoiningReportUloaded, IsMedicalHistoryUploaded, IsmedicineUploaded
FROM CIRM
WHERE CrewId = @CrewId
End




GO
/****** Object:  StoredProcedure [dbo].[stpGetMedicalAdvisoryListPageWise2]    Script Date: 03/09/2020 1:59:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  declare @x int Exec stpGetMedicalAdvisoryListPageWise2  1,20, @x out
create PROCEDURE [dbo].[stpGetMedicalAdvisoryListPageWise2]
(
      @PageIndex INT = 1,
      @PageSize INT = 10,
      @RecordCount INT OUTPUT
)
AS
BEGIN
      SET NOCOUNT ON;
      SELECT ROW_NUMBER() OVER
      (
            ORDER BY [MedicalAdvisoryID] ASC

      )AS RowNumber
	  
	  ,MedicalAdvisoryID
     --,CrewName
	 ,[Weight]
	 ,BMI
	  ,BloodSugarLevel + ' ' + BloodSugarUnit AS BloodSugarLevel
	 ,Systolic
	 ,Diastolic
	 ,UrineTest
	 ,UnannouncedAlcohol
	 ,AnnualDH
	 ,[Month]

 INTO #Results

FROM MedicalAdvisory 

--GROUP BY Name,RankName,CreatedOn,C.LatestUpdate
      SELECT @RecordCount = COUNT(*)

      FROM #Results

      SELECT * FROM #Results

      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

      DROP TABLE #Results
END





GO
/****** Object:  StoredProcedure [dbo].[UpdateResetPassword]    Script Date: 03/09/2020 2:00:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- UpdateResetPassword 'AMIT'
create PROCEDURE [dbo].[UpdateResetPassword]
(
    --@ID int,
	@UserName varchar(21)
) 
AS
BEGIN

	UPDATE Users SET Password = 123452
	WHERE Username = @Username

END






/********* End Tag ************** New SP Deep 02.09.2020 ******************************************/






























GO
/****** Object:  StoredProcedure [dbo].[usp_GetDoctorBySpecialityID]    Script Date: 12/11/2019 8:48:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  exec usp_GetDoctorBySpecialityID 1
CREATE PROCEDURE [dbo].[usp_GetDoctorBySpecialityID]
(
	@SpecialityID int
)
AS

Begin
Select DoctorID, DoctorName
FROM DoctorMaster
WHERE SpecialityID= @SpecialityID
End

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  declare @x int Exec stpGetMedicalAdvisoryListPageWise  1,20, @x out
create PROCEDURE [dbo].[stpGetMedicalAdvisoryListPageWise]
(
      @PageIndex INT = 1,
      @PageSize INT = 10,
      @RecordCount INT OUTPUT
)
AS
BEGIN
      SET NOCOUNT ON;
      SELECT ROW_NUMBER() OVER
      (
            ORDER BY [CrewName] ASC

      )AS RowNumber

     ,CrewName
	 ,[Weight]
	 ,BMI
	 ,BloodSugarLevel
	 ,Systolic
	 ,Diastolic
	 ,UrineTest
	 ,UnannouncedAlcohol
	 ,AnnualDH
	 ,[Month]

 INTO #Results

FROM MedicalAdvisory 

--GROUP BY Name,RankName,CreatedOn,C.LatestUpdate
      SELECT @RecordCount = COUNT(*)

      FROM #Results

      SELECT * FROM #Results

      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

      DROP TABLE #Results
END

GO





/*#########################################END STOTED PROCEDURES #################################*/


/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ TABLES @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/


/****** Object:  Table [dbo].[CIRM]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CIRM](
	[CIRMId] [int] IDENTITY(1,1) NOT NULL,
	[NameOfVessel] [varchar](50) NULL,
	[RadioCallSign] [varchar](50) NULL,
	[PortofDestination] [varchar](50) NULL,
	[Route] [varchar](50) NULL,
	[LocationOfShip] [varchar](50) NULL,
	[PortofDeparture] [varchar](50) NULL,
	[EstimatedTimeOfarrivalhrs] [varchar](50) NULL,
	[Speed] [varchar](50) NULL,
	[Nationality] [varchar](50) NULL,
	[Qualification] [varchar](50) NULL,
	[RespiratoryRate] [varchar](50) NULL,
	[Pulse] [varchar](50) NULL,
	[Temperature] [varchar](50) NULL,
	[Systolic] [varchar](50) NULL,
	[Diastolic] [varchar](50) NULL,
	[Symptomatology] [varchar](50) NULL,
	[LocationAndTypeOfPain] [varchar](50) NULL,
	[RelevantInformationForDesease] [varchar](50) NULL,
	[WhereAndHowAccidentIsCausedCHK] [bit] NULL,
	[UploadMedicalHistory] [varchar](500) NULL,
	[UploadMedicinesAvailable] [varchar](500) NULL,
	[MedicalProductsAdministered] [varchar](500) NULL,
	[WhereAndHowAccidentIsausedARA] [varchar](500) NULL,

	/********* Start Tag ************** Update Table Deep 02.09.2020 ******************************************/
	[CrewId] [int] NULL,
	[IsEquipmentUploaded] [bit] NULL,
	[IsJoiningReportUloaded] [bit] NULL,
	[IsMedicalHistoryUploaded] [bit] NULL,
	[IsmedicineUploaded] [bit] NULL,
	[Addiction] [varchar](20) NULL,
	[RankID] [int] NULL,
	[Ethinicity] [varchar](50) NULL,
	[Frequency] [varchar](20) NULL,
	[Sex] [varchar](5) NULL,
	[Age] [varchar](5) NULL,
	[JoiningDate] [varchar](20) NULL,
	[Category] [varchar](50) NULL,
	[SubCategory] [varchar](50) NULL,
	[OxygenSaturation] [varchar](50) NULL,
	[SymptomatologyDate] [varchar](50) NULL,
	[SymptomatologyTime] [varchar](50) NULL,
	[Vomiting] [varchar](10) NULL,
	[FrequencyOfVomiting] [varchar](50) NULL,
	[Fits] [varchar](10) NULL,
	[FrequencyOfFits] [varchar](50) NULL,
	[SymptomatologyDetails] [varchar](500) NULL,
	[MedicinesAdministered] [varchar](500) NULL,
	[WhereAndHowAccidentOccured] [varchar](500) NULL,
	[NoHurt] [bit] NULL,
	[HurtLittleBit] [bit] NULL,
	[HurtsLittleMore] [bit] NULL,
	[HurtsEvenMore] [bit] NULL,
	[HurtsWholeLot] [bit] NULL,
	[HurtsWoest] [bit] NULL,
	[JoiningMedical] [bit] NULL,
	[MedicineAvailableOnBoard] [bit] NULL,
	[MedicalEquipmentOnBoard] [bit] NULL,
	[MedicalHistoryUpload] [bit] NULL,
	[WorkAndRestHourLatestRecord] [bit] NULL,
	[PreExistingMedicationPrescription] [bit] NULL,
	[LocationAndTypeOfInjuryOrBurn] [varchar](500) NULL,
	[FrequencyOfPain] [varchar](50) NULL,
	[PictureUploadPath] [varchar](1000) NULL,
	[FirstAidGiven] [varchar](500) NULL,
	[PercentageOfBurn] [varchar](50) NULL,
	[VesselID] [int] NULL
	/********* End Tag ************** Update Table Deep 02.09.2020 ******************************************/

 CONSTRAINT [PK_CIRM] PRIMARY KEY CLUSTERED 
(
	[CIRMId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CompanyDetails]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CompanyDetails](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Address] [varchar](1000) NULL,
	[Website] [varchar](1000) NULL,
	[AdminContact] [varchar](1000) NULL,
	[AdminContactEmail] [varchar](100) NULL,
	[ContactNumber] [varchar](50) NULL,
	[Domain] [varchar](100) NULL,
	[SecureKey] [varchar](2000) NULL,
	[CompanyID] [int] NULL,
 CONSTRAINT [PK_CompanyDetails] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Consultation]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Consultation](
	[DoctorID] [int] NOT NULL,
	[Problem] [varchar](500) NOT NULL,
	[Timestamp] [timestamp] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CountryMaster]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CountryMaster](
	[CountryID] [int] IDENTITY(1,1) NOT NULL,
	[CountryName] [varchar](200) NOT NULL,
	[CountryCode] [varchar](50) NOT NULL,
 CONSTRAINT [PK_CountryMaster] PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Crew]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Crew](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NULL,
	[Watchkeeper] [bit] NULL,
	[Notes] [ntext] NULL,
	[Deleted] [bit] NULL,
	[LatestUpdate] [datetime] NULL,
	[CompleteHistory] [bit] NULL,
	[PayNum] [nvarchar](25) NULL,
	[Timestamp] [timestamp] NULL,
	[CreatedOn] [datetime] NULL,
	[OvertimeEnabled] [bit] NULL,
	[EmployeeNumber] [nvarchar](25) NULL,
	[NWKHoursMayVary] [bit] NULL CONSTRAINT [DF_Crew_NWKHoursMayVary]  DEFAULT ((0)),
	[RankID] [int] NOT NULL,
	[FirstName] [varchar](100) NULL,
	[LastName] [varchar](50) NULL,
	[DOB] [datetime] NULL,
	[POB] [nvarchar](20) NULL,
	[CrewIdentity] [nvarchar](20) NULL,
	[PassportSeamanPassportBook] [nvarchar](20) NULL,
	[Seaman] [nvarchar](20) NULL,
	[MiddleName] [varchar](100) NULL,
	[IsActive] [bit] NULL,
	[VesselID] [int] NOT NULL,
	[DepartmentMasterID] [int] NULL,
	[CountryID] [int] NULL,
	[DeactivationDate] [datetime] NULL,
	[DeletionDate] [datetime] NULL,
	[Gender] [varchar](50) NULL,
	[IssuingStateOfIdentityDocument] [varchar](500) NULL,
	[ExpiryDateOfIdentityDocument] [datetime] NULL,
 CONSTRAINT [PK_dbo.Crew] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[VesselID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CrewRegimeTR]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CrewRegimeTR](
	[CrewID] [int] NOT NULL,
	[RegimeID] [int] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[VesselID] [int] NOT NULL,
	[Timestamp] [timestamp] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Customers]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Customers](
	[Id] [int] NOT NULL,
	[Name] [varchar](500) NOT NULL,
	[Country] [varchar](500) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Demo]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Demo](
	[DemoID] [int] NULL,
	[DemoName] [varchar](500) NULL,
	[DemoDate] [datetime] NULL,
	[IsDemo] [sql_variant] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DepartmentAdmin]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DepartmentAdmin](
	[DepartmentAdminID] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentMasterID] [int] NOT NULL,
	[CrewID] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[PositionEndDate] [datetime] NULL,
	[IsAdmin] [bit] NOT NULL,
	[VesselID] [int] NOT NULL,
	[ReportsTo] [int] NULL,
 CONSTRAINT [PK_DepartmentAdmin] PRIMARY KEY CLUSTERED 
(
	[DepartmentAdminID] ASC,
	[VesselID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DepartmentMaster]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DepartmentMaster](
	[DepartmentMasterID] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentMasterName] [varchar](50) NOT NULL,
	[DepartmentMasterCode] [varchar](10) NULL,
	[IsActive] [bit] NOT NULL,
	[VesselID] [int] NOT NULL,
 CONSTRAINT [PK_DepartmentMaster] PRIMARY KEY CLUSTERED 
(
	[DepartmentMasterID] ASC,
	[VesselID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DoctorMaster]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DoctorMaster](
	[DoctorID] [int] IDENTITY(1,1) NOT NULL,
	[DoctorName] [varchar](100) NOT NULL,
	[DoctorEmail] [varchar](100) NOT NULL,
	[SpecialityID] [int] NOT NULL,
	[Comment] [varchar](500) NULL,
 CONSTRAINT [PK_DoctorMaster] PRIMARY KEY CLUSTERED 
(
	[DoctorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FirstRun]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FirstRun](
	[RunCount] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GroupPermission]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GroupPermission](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GroupID] [int] NOT NULL,
	[PermissionID] [int] NOT NULL,
	[TimeStamp] [timestamp] NOT NULL,
	[VesselID] [int] NOT NULL,
 CONSTRAINT [PK_dbo.GroupPermission] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[VesselID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GroupRank]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GroupRank](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GroupID] [int] NOT NULL,
	[RankID] [int] NOT NULL,
	[Timestamp] [timestamp] NULL,
	[VesselID] [int] NOT NULL,
 CONSTRAINT [PK_GroupRank] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[VesselID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Groups]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Groups](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GroupName] [nvarchar](50) NOT NULL,
	[Timestamp] [timestamp] NOT NULL,
	[AllowDelete] [bit] NOT NULL CONSTRAINT [DF_Groups_AllowDelete]  DEFAULT ((1)),
	[VesselID] [int] NOT NULL,
 CONSTRAINT [PK_dbo.Groups] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[VesselID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MedicalAdvisory]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MedicalAdvisory](
	[MedicalAdvisoryID] [int] IDENTITY(1,1) NOT NULL,
	[Weight] [varchar](500) NULL,
	[BMI] [varchar](500) NULL,
	[BP] [varchar](500) NULL,
	[BloodSugarLevel] [varchar](500) NULL,
	[UrineTest] [bit] NULL,
	[CrewID] [int] NULL,
	[Height] [varchar](20) NULL,
	[Age] [varchar](20) NULL,
	[BloodSugarUnit] [varchar](20) NULL,
	[BloodSugarTestType] [varchar](20) NULL,
	[Systolic] [varchar](20) NULL,
	[Diastolic] [varchar](20) NULL,
	[UnannouncedAlcohol] [bit] NULL,
	[AnnualDH] [bit] NULL,
	[Month] [varchar](20) NULL,
	[CrewName] [varchar](20) NULL,
	[PulseRatebpm] [varchar](20) NULL,
	[AnyDietaryRestrictions] [varchar](50) NULL,
	[MedicalProductsAdministered] [varchar](50) NULL,
	[UploadExistingPrescriptions] [varchar](100) NULL,
	[UploadUrineReport] [varchar](100) NULL,
 CONSTRAINT [PK_MedicalAdvisory] PRIMARY KEY CLUSTERED 
(
	[MedicalAdvisoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[NCDetails]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NCDetails](
	[NCDetailsID] [int] IDENTITY(1,1) NOT NULL,
	[CrewID] [int] NOT NULL,
	[OccuredOn] [datetime] NOT NULL,
	[ComplianceInfo] [xml] NOT NULL,
	[TotalNCHours] [float] NULL,
	[WorkSessionId] [int] NULL,
	[isNC] [bit] NULL,
	[VesselID] [int] NOT NULL,
	[isTNC] [bit] NULL,
	[isSevenDaysCompliant] [bit] NULL,
	[is24HoursCompliant] [bit] NULL,
	[PaintOrange] [bit] NULL,
 CONSTRAINT [PK_dbo.NCDetails] PRIMARY KEY CLUSTERED 
(
	[NCDetailsID] ASC,
	[VesselID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Permissions]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Permissions](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PermissionName] [nvarchar](50) NOT NULL,
	[ParentPermissionID] [int] NULL,
	[SplitByRank] [bit] NOT NULL,
	[Timestamp] [timestamp] NOT NULL,
	[VesselID] [int] NOT NULL,
 CONSTRAINT [PK_dbo.Permissions] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[VesselID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Ranks]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ranks](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RankName] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](200) NULL,
	[Order] [int] NOT NULL,
	[Timestamp] [timestamp] NULL,
	[ScheduleID] [int] NULL,
	[Deleted] [bit] NULL CONSTRAINT [DF_Ranks_Deleted]  DEFAULT ((0)),
	[LatestUpdate] [datetime] NULL,
	[DefaultScheduleComments] [nvarchar](200) NULL,
	[Scheduled] [bit] NOT NULL CONSTRAINT [DF_Ranks_Scheduled]  DEFAULT ((1)),
	[VesselID] [int] NOT NULL,
 CONSTRAINT [PK_dbo.Ranks] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[VesselID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Regimes]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Regimes](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RegimeName] [nvarchar](50) NOT NULL,
	[Description] [ntext] NULL,
	[Basis] [nvarchar](50) NULL,
	[MinTotalRestIn7Days] [float] NOT NULL,
	[MaxTotalWorkIn24Hours] [float] NOT NULL,
	[MinContRestIn24Hours] [float] NOT NULL,
	[MinTotalRestIn24Hours] [float] NOT NULL,
	[MaxTotalWorkIn7Days] [float] NOT NULL,
	[CheckFor2Days] [bit] NULL,
	[OPA90] [bit] NULL,
	[Timestamp] [timestamp] NULL,
	[ManilaExceptions] [bit] NULL,
	[UseHistCalculationOnly] [bit] NULL CONSTRAINT [DF_Regimes_UseHistCalculationOnly]  DEFAULT ((0)),
	[CheckOnlyWorkHours] [bit] NULL CONSTRAINT [DF_Regimes_CheckOnlyWorkHours]  DEFAULT ((1)),
	[VesselID] [int] NULL,
 CONSTRAINT [PK_RegimeID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_RegimeName] UNIQUE NONCLUSTERED 
(
	[RegimeName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ServiceTerms]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServiceTerms](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ActiveFrom] [datetime] NOT NULL,
	[ActiveTo] [datetime] NULL,
	[CrewID] [int] NOT NULL,
	[Timestamp] [timestamp] NOT NULL,
	[OvertimeID] [int] NULL,
	[ScheduleID] [int] NULL,
	[RankID] [int] NOT NULL CONSTRAINT [DF_ServiceTerms_RankID]  DEFAULT ((0)),
	[Deleted] [bit] NOT NULL CONSTRAINT [DF_ServiceTerms_Deleted]  DEFAULT ((0)),
	[VesselID] [int] NOT NULL,
 CONSTRAINT [PK_dbo.ServiceTerms] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[VesselID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ServiceTermsHistory]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServiceTermsHistory](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ActiveFrom] [datetime] NULL,
	[ActiveTo] [datetime] NULL,
	[CrewID] [int] NULL,
	[Timestamp] [timestamp] NULL,
	[OvertimeID] [int] NULL,
	[ScheduleID] [int] NULL,
	[RankID] [int] NULL,
	[Deleted] [bit] NULL,
	[VesselID] [int] NOT NULL,
 CONSTRAINT [PK_ServiceTermsHistory] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[VesselID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Ship]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Ship](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ShipName] [nvarchar](21) NULL,
	[IMONumber] [int] NOT NULL,
	[FlagOfShip] [nvarchar](50) NULL,
	[Regime] [int] NULL,
	[TimeStamp] [timestamp] NULL,
	[LastSyncDate] [datetime] NULL,
	[CompanyID] [int] NULL,
	[ShipEmail] [varchar](200) NULL,
	/********* Start Tag ************** Update Table Deep 02.09.2020 ******************************************/
	[VesselTypeID] [int] NULL,
	[VesselSubTypeID] [int] NULL,
	[VesselSubSubTypeID] [int] NULL,
	[ShipEmail2] [varchar](100) NULL,
	[Voices1] [varchar](100) NULL,
	[Voices2] [varchar](100) NULL,
	[Fax1] [varchar](100) NULL,
	[Fax2] [varchar](100) NULL,
	[VOIP1] [varchar](100) NULL,
	[VOIP2] [varchar](100) NULL,
	[Mobile1] [varchar](100) NULL,
	[Mobile2] [varchar](100) NULL,
	[CommunicationsResources] [varchar](100) NULL,
	[HelicopterDeck] [int] NULL,
	[HelicopterWinchingArea] [int] NULL
	)
	/********* End Tag ************** Update Table Deep 02.09.2020 ******************************************/
-- CONSTRAINT [PK_dbo.Ship] PRIMARY KEY CLUSTERED 
--(
--	[ID] ASC,
--	[IMONumber] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
-- CONSTRAINT [IX_Ship] UNIQUE NONCLUSTERED 
--(
--	[ID] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
--) ON [PRIMARY]

GO
SET ANSI_PADDING OFF


/********* Start Tag ************** Update Table Deep 02.09.2020 ******************************************/
--GO
--ALTER TABLE [dbo].[Ship]  WITH CHECK ADD  CONSTRAINT [FK_Ship_VesselSubSubType] FOREIGN KEY([VesselSubSubTypeID])
--REFERENCES [dbo].[VesselSubSubType] ([ID])
--GO
--ALTER TABLE [dbo].[Ship] CHECK CONSTRAINT [FK_Ship_VesselSubSubType]
--GO
--ALTER TABLE [dbo].[Ship]  WITH CHECK ADD  CONSTRAINT [FK_Ship_VesselSubType] FOREIGN KEY([VesselSubTypeID])
--REFERENCES [dbo].[VesselSubType] ([ID])
--GO
--ALTER TABLE [dbo].[Ship] CHECK CONSTRAINT [FK_Ship_VesselSubType]
--GO
--ALTER TABLE [dbo].[Ship]  WITH CHECK ADD  CONSTRAINT [FK_Ship_VesselType] FOREIGN KEY([VesselTypeID])
--REFERENCES [dbo].[VesselType] ([Id])
--GO
--ALTER TABLE [dbo].[Ship] CHECK CONSTRAINT [FK_Ship_VesselType]
--GO

-- Constraints and Indexes

ALTER TABLE [dbo].[Ship] ADD CONSTRAINT [PK_dbo.Ship] PRIMARY KEY CLUSTERED  ([ID], [IMONumber])
GO






/********* End Tag ************** Update Table Deep 02.09.2020 ******************************************/



GO
/****** Object:  Table [dbo].[SpecialityMaster]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SpecialityMaster](
	[SpecialityID] [int] IDENTITY(1,1) NOT NULL,
	[SpecialityName] [varchar](100) NOT NULL,
 CONSTRAINT [PK_SpecialityMaster] PRIMARY KEY CLUSTERED 
(
	[SpecialityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblConfig]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblConfig](
	[KeyName] [varchar](20) NOT NULL,
	[ConfigValue] [varchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblEquipments]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblEquipments](
	[EquipmentsID] [int] IDENTITY(1,1) NOT NULL,
	[EquipmentsName] [varchar](500) NULL,
	[Comment] [varchar](500) NULL,
	[Quantity] [varchar](50) NULL,
	[ExpiryDate] [varchar](50) NULL,
	[Location] [varchar](50) NULL,
 CONSTRAINT [PK_tblEquipments] PRIMARY KEY CLUSTERED 
(
	[EquipmentsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblMedicine]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblMedicine](
	[MedicineID] [int] IDENTITY(1,1) NOT NULL,
	[MedicineName] [varchar](500) NULL,
	[Quantity] [varchar](500) NULL,
	[ExpiryDate] [varchar](50) NULL,
	[Location] [varchar](50) NULL,
 CONSTRAINT [PK_Medicine] PRIMARY KEY CLUSTERED 
(
	[MedicineID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblRegime]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblRegime](
	[RegimeID] [int] NULL,
	[RegimeStartDate] [datetime] NULL,
	[IsActiveRegime] [bit] NULL,
	[VesselID] [int] NULL,
	[RegimeEndDate] [datetime] NULL,
	[Timestamp] [timestamp] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TimeAdjustment]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TimeAdjustment](
	[AdjustmentDate] [datetime] NULL,
	[AdjustmentValue] [varchar](30) NULL,
	[VesselID] [int] NOT NULL,
	[Timestamp] [timestamp] NULL,
	[TimeAdjustmentID] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_TimeAdjustment] PRIMARY KEY CLUSTERED 
(
	[VesselID] ASC,
	[TimeAdjustmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserGroups]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserGroups](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[GroupID] [int] NOT NULL,
	[Timestamp] [timestamp] NOT NULL,
	[VesselID] [int] NOT NULL,
 CONSTRAINT [PK_dbo.UserGroups] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[VesselID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Users]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](200) NULL,
	[Password] [nvarchar](200) NULL,
	[Active] [bit] NULL,
	[Timestamp] [timestamp] NULL,
	[AllowDelete] [bit] NULL CONSTRAINT [DF_Users_AllowDelete]  DEFAULT ((1)),
	[CrewId] [int] NULL,
	[VesselID] [int] NOT NULL,
 CONSTRAINT [PK_dbo.Users] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[VesselID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkingHours]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkingHours](
	[DayNumber] [int] NULL,
	[RegimeID] [int] NULL,
	[WorkHours] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkSchedules]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkSchedules](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PortScheduleAsSea] [bit] NOT NULL,
	[MonWKHours] [nchar](48) NOT NULL,
	[TueWKHours] [nchar](48) NOT NULL,
	[WedWKHours] [nchar](48) NOT NULL,
	[ThuWKHours] [nchar](48) NOT NULL,
	[FriWKHours] [nchar](48) NOT NULL,
	[SatWKHours] [nchar](48) NOT NULL,
	[SunWKHours] [nchar](48) NOT NULL,
	[MonNWKHours] [nchar](48) NOT NULL,
	[TueNWKHours] [nchar](48) NOT NULL,
	[WedNWKHours] [nchar](48) NOT NULL,
	[ThuNWKHours] [nchar](48) NOT NULL,
	[FriNWKHours] [nchar](48) NOT NULL,
	[SatNWKHours] [nchar](48) NOT NULL,
	[SunNWKHours] [nchar](48) NOT NULL,
	[MonWKPort] [nchar](48) NOT NULL,
	[TueWKPort] [nchar](48) NOT NULL,
	[WedWKPort] [nchar](48) NOT NULL,
	[ThuWKPort] [nchar](48) NOT NULL,
	[FriWKPort] [nchar](48) NOT NULL,
	[SatWKPort] [nchar](48) NOT NULL,
	[SunWKPort] [nchar](48) NOT NULL,
	[MonNWKPort] [nchar](48) NOT NULL,
	[TueNWKPort] [nchar](48) NOT NULL,
	[WedNWKPort] [nchar](48) NOT NULL,
	[ThuNWKPort] [nchar](48) NOT NULL,
	[FriNWKPort] [nchar](48) NOT NULL,
	[SatNWKPort] [nchar](48) NOT NULL,
	[SunNWKPort] [nchar](48) NOT NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsTechnical] [int] NULL,
	[Deleted] [bit] NOT NULL,
	[VesselID] [int] NOT NULL,
 CONSTRAINT [PK_dbo.WorkSchedules] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[VesselID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkSessions]    Script Date: 12/11/2019 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WorkSessions](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CrewID] [int] NOT NULL,
	[ValidOn] [datetime] NOT NULL,
	[Hours] [nchar](48) NOT NULL,
	[Increment] [int] NOT NULL,
	[Comment] [nvarchar](200) NULL,
	[Timestamp] [timestamp] NOT NULL,
	[LatestUpdate] [datetime] NULL,
	[Deleted] [bit] NOT NULL CONSTRAINT [DF_WorkSessions_Deleted]  DEFAULT ((0)),
	[ActualHours] [nvarchar](200) NULL,
	[TimeAdjustment] [nvarchar](50) NULL,
	[AdjustmentFator] [varchar](20) NULL,
	[VesselID] [int] NOT NULL,
	[RegimeID] [int] NULL,
	[Comments] [varchar](500) NULL,
	[isApproved] [bit] NULL,
 CONSTRAINT [PK_dbo.WorkSessions] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[VesselID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[WorkSchedules] ADD  CONSTRAINT [DF_WorkSchedules_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[DoctorMaster]  WITH CHECK ADD  CONSTRAINT [FK_DoctorMaster_SpecialityMaster] FOREIGN KEY([SpecialityID])
REFERENCES [dbo].[SpecialityMaster] ([SpecialityID])
GO
ALTER TABLE [dbo].[DoctorMaster] CHECK CONSTRAINT [FK_DoctorMaster_SpecialityMaster]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JoiningMedicalFileData](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CrewId] [int] NULL,
	[UploadDate] [DateTime] NULL,
	[JoiningMedicalFile] [nvarchar](500) NULL,
 CONSTRAINT [PK_JoiningMedicalFileData] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO









/********* Start Tag ************** New Table Deep 02.09.2020 ******************************************/

GO
/****** Object:  Table [dbo].[CrewTemperature]    Script Date: 02/09/2020 6:56:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CrewTemperature](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CrewID] [int] NOT NULL,
	[Temperature] [decimal](12, 3) NOT NULL,
	[Unit] [varchar](5) NULL,
	[ReadingDate] [varchar](50) NULL,
	[ReadingTime] [varchar](5) NULL,
	[Comment] [varchar](500) NULL,
	[TemperatureModeID] [int] NULL,
	[VesselID] [int] NOT NULL,
		[Place] [varchar](100) NULL,
			[Means] [varchar](100) NULL,
 CONSTRAINT [PK_CrewTemperature] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[VesselID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TemperatureMode]    Script Date: 02/09/2020 6:56:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TemperatureMode](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Mode] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TemperatureMode] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[VesselDetails]    Script Date: 02/09/2020 6:56:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VesselDetails](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[VesselName] [varchar](50) NOT NULL,
	[CallSign] [varchar](50) NULL,
	[DateOfReportingGMT] [varchar](50) NULL,
	[TimeOfReportingGMT] [varchar](5) NULL,
	[PresentLocation] [varchar](50) NULL,
	[Course] [varchar](50) NULL,
	[Speed] [varchar](50) NULL,
	[PortOfDeparture] [varchar](50) NULL,
	[PortOfArrival] [varchar](50) NULL,
	[ETADateGMT] [varchar](50) NULL,
	[ETATimeGMT] [varchar](5) NULL,
	[AgentDetails] [varchar](500) NULL,
	[NearestPortETADateGMT] [varchar](50) NULL,
	[NearestPortETATimeGMT] [varchar](5) NULL,
	[WindSpeed] [varchar](20) NULL,
	[Sea] [varchar](20) NULL,
	[Visibility] [varchar](20) NULL,
	[Swell] [varchar](20) NULL,
 CONSTRAINT [PK_VesselDetails] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[VesselSubSubType]    Script Date: 02/09/2020 6:56:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VesselSubSubType](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[VesselSubTypeID] [int] NOT NULL,
	[VesselSubSubTypeDecsription] [varchar](100) NULL,
 CONSTRAINT [PK_VesselSubSubType] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[VesselSubType]    Script Date: 02/09/2020 6:56:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VesselSubType](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[VesselTypeID] [int] NOT NULL,
	[SubTypeDescription] [varchar](100) NULL,
 CONSTRAINT [PK_VesselSubType] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[VesselType]    Script Date: 02/09/2020 6:56:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VesselType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NOT NULL,
 CONSTRAINT [PK_VesselType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[CrewTemperature]  WITH CHECK ADD  CONSTRAINT [FK_CrewTemperature_TemperatureMode] FOREIGN KEY([TemperatureModeID])
REFERENCES [dbo].[TemperatureMode] ([ID])
GO
ALTER TABLE [dbo].[CrewTemperature] CHECK CONSTRAINT [FK_CrewTemperature_TemperatureMode]
GO
ALTER TABLE [dbo].[VesselSubSubType]  WITH CHECK ADD  CONSTRAINT [FK_VesselSubSubType_VesselSubType] FOREIGN KEY([VesselSubTypeID])
REFERENCES [dbo].[VesselSubType] ([ID])
GO
ALTER TABLE [dbo].[VesselSubSubType] CHECK CONSTRAINT [FK_VesselSubSubType_VesselSubType]
GO
ALTER TABLE [dbo].[VesselSubType]  WITH CHECK ADD  CONSTRAINT [FK_VesselSubType_VesselType] FOREIGN KEY([VesselTypeID])
REFERENCES [dbo].[VesselType] ([Id])
GO
ALTER TABLE [dbo].[VesselSubType] CHECK CONSTRAINT [FK_VesselSubType_VesselType]
GO


/********* End Tag ************** New Table Deep 02.09.2020 ******************************************/





-- Foreign Keys

ALTER TABLE [dbo].[Ship] ADD CONSTRAINT [FK_Ship_VesselSubSubType] FOREIGN KEY ([VesselSubSubTypeID]) REFERENCES [dbo].[VesselSubSubType] ([ID])
GO
ALTER TABLE [dbo].[Ship] ADD CONSTRAINT [FK_Ship_VesselSubType] FOREIGN KEY ([VesselSubTypeID]) REFERENCES [dbo].[VesselSubType] ([ID])
GO
ALTER TABLE [dbo].[Ship] ADD CONSTRAINT [FK_Ship_VesselType] FOREIGN KEY ([VesselTypeID]) REFERENCES [dbo].[VesselType] ([Id])
GO







/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@END TABLES@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/

/*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ STARTUP DATA $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/


SET IDENTITY_INSERT [dbo].[CountryMaster] ON 

INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (1, N'Afghanistan', N'AF / AFG')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (2, N'Albania', N'AL / ALB')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (3, N'Algeria', N'DZ / DZA')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (4, N'American Samoa', N'AS / ASM')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (5, N'Andorra', N'AD / AND')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (6, N'Angola', N'AO / AGO')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (7, N'Anguilla', N'AI / AIA')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (8, N'Antarctica', N'AQ / ATA')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (9, N'Antigua and Barbuda', N'AG / ATG')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (10, N'Argentina', N'AR / ARG')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (11, N'Armenia', N'AM / ARM')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (12, N'Aruba', N'AW / ABW')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (13, N'Australia', N'AU / AUS')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (14, N'Austria', N'AT / AUT')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (15, N'Azerbaijan', N'AZ / AZE')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (16, N'Bahamas', N'BS / BHS')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (17, N'Bahrain', N'BH / BHR')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (18, N'Bangladesh', N'BD / BGD')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (19, N'Barbados', N'BB / BRB')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (20, N'Belarus', N'BY / BLR')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (21, N'Belgium', N'BE / BEL')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (22, N'Belize', N'BZ / BLZ')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (23, N'Benin', N'BJ / BEN')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (24, N'Bermuda', N'BM / BMU')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (25, N'Bhutan', N'BT / BTN')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (26, N'Bolivia', N'BO / BOL')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (27, N'Bosnia and Herzegovina', N'BA / BIH')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (28, N'Botswana', N'BW / BWA')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (29, N'Brazil', N'BR / BRA')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (30, N'British Indian Ocean Territory', N'IO / IOT')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (31, N'British Virgin Islands', N'VG / VGB')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (32, N'Brunei', N'BN / BRN')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (33, N'Bulgaria', N'BG / BGR')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (34, N'Burkina Faso', N'BF / BFA')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (35, N'Burundi', N'BI / BDI')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (36, N'Cambodia', N'KH / KHM')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (37, N'Cameroon', N'CM / CMR')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (38, N'Canada', N'CA / CAN')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (39, N'Cape Verde', N'CV / CPV')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (40, N'Cayman Islands', N'KY / CYM')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (41, N'Central African Republic', N'CF / CAF')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (42, N'Chad', N'TD / TCD')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (43, N'Chile', N'CL / CHL')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (44, N'China', N'CN / CHN')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (45, N'Christmas Island', N'CX / CXR')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (46, N'Cocos Islands', N'CC / CCK')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (47, N'Colombia', N'CO / COL')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (48, N'Comoros', N'KM / COM')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (49, N'Cook Islands', N'CK / COK')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (50, N'Costa Rica', N'CR / CRI')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (51, N'Croatia', N'HR / HRV')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (52, N'Cuba', N'CU / CUB')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (53, N'Curacao', N'CW / CUW')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (54, N'Cyprus', N'CY / CYP')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (55, N'Czech Republic', N'CZ / CZE')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (56, N'Democratic Republic of the Congo', N'CD / COD')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (57, N'Denmark', N'DK / DNK')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (58, N'Djibouti', N'DJ / DJI')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (59, N'Dominica', N'DM / DMA')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (60, N'Dominican Republic', N'DO / DOM')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (61, N'East Timor', N'TL / TLS')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (62, N'Ecuador', N'EC / ECU')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (63, N'Egypt', N'EG / EGY')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (64, N'El Salvador', N'SV / SLV')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (65, N'Equatorial Guinea', N'GQ / GNQ')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (66, N'Eritrea', N'ER / ERI')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (67, N'Estonia', N'EE / EST')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (68, N'Ethiopia', N'ET / ETH')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (69, N'Falkland Islands', N'FK / FLK')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (70, N'Faroe Islands', N'FO / FRO')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (71, N'Fiji', N'FJ / FJI')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (72, N'Finland', N'FI / FIN')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (73, N'France', N'FR / FRA')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (74, N'French Polynesia', N'PF / PYF')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (75, N'Gabon', N'GA / GAB')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (76, N'Gambia', N'GM / GMB')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (77, N'Georgia', N'GE / GEO')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (78, N'Germany', N'DE / DEU')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (79, N'Ghana', N'GH / GHA')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (80, N'Gibraltar', N'GI / GIB')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (81, N'Greece', N'GR / GRC')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (82, N'Greenland', N'GL / GRL')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (83, N'Grenada', N'GD / GRD')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (84, N'Guam', N'GU / GUM')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (85, N'Guatemala', N'GT / GTM')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (86, N'Guernsey', N'GG / GGY')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (87, N'Guinea', N'GN / GIN')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (88, N'Guinea-Bissau', N'GW / GNB')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (89, N'Guyana', N'GY / GUY')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (90, N'Haiti', N'HT / HTI')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (91, N'Honduras', N'HN / HND')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (92, N'Hong Kong', N'HK / HKG')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (93, N'Hungary', N'HU / HUN')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (94, N'Iceland', N'IS / ISL')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (95, N'India', N'IN / IND')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (96, N'Indonesia', N'ID / IDN')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (97, N'Iran', N'IR / IRN')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (98, N'Iraq', N'IQ / IRQ')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (99, N'Ireland', N'IE / IRL')
GO
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (100, N'Isle of Man', N'IM / IMN')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (101, N'Israel', N'IL / ISR')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (102, N'Italy', N'IT / ITA')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (103, N'Ivory Coast', N'CI / CIV')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (104, N'Jamaica', N'JM / JAM')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (105, N'Japan', N'JP / JPN')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (106, N'Jersey', N'JE / JEY')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (107, N'Jordan', N'JO / JOR')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (108, N'Kazakhstan', N'KZ / KAZ')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (109, N'Kenya', N'KE / KEN')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (110, N'Kiribati', N'KI / KIR')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (111, N'Kosovo', N'XK / XKX')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (112, N'Kuwait', N'KW / KWT')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (113, N'Kyrgyzstan', N'KG / KGZ')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (114, N'Laos', N'LA / LAO')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (115, N'Latvia', N'LV / LVA')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (116, N'Lebanon', N'LB / LBN')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (117, N'Lesotho', N'LS / LSO')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (118, N'Liberia', N'LR / LBR')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (119, N'Libya', N'LY / LBY')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (120, N'Liechtenstein', N'LI / LIE')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (121, N'Lithuania', N'LT / LTU')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (122, N'Luxembourg', N'LU / LUX')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (123, N'Macau', N'MO / MAC')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (124, N'Macedonia', N'MK / MKD')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (125, N'Madagascar', N'MG / MDG')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (126, N'Malawi', N'MW / MWI')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (127, N'Malaysia', N'MY / MYS')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (128, N'Maldives', N'MV / MDV')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (129, N'Mali', N'ML / MLI')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (130, N'Malta', N'MT / MLT')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (131, N'Marshall Islands', N'MH / MHL')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (132, N'Mauritania', N'MR / MRT')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (133, N'Mauritius', N'MU / MUS')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (134, N'Mayotte', N'YT / MYT')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (135, N'Mexico', N'MX / MEX')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (136, N'Micronesia', N'FM / FSM')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (137, N'Moldova', N'MD / MDA')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (138, N'Monaco', N'MC / MCO')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (139, N'Mongolia', N'MN / MNG')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (140, N'Montenegro', N'ME / MNE')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (141, N'Montserrat', N'MS / MSR')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (142, N'Morocco', N'MA / MAR')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (143, N'Mozambique', N'MZ / MOZ')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (144, N'Myanmar', N'MM / MMR')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (145, N'Namibia', N'NA / NAM')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (146, N'Nauru', N'NR / NRU')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (147, N'Nepal', N'NP / NPL')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (148, N'Netherlands', N'NL / NLD')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (149, N'Netherlands Antilles', N'AN / ANT')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (150, N'New Caledonia', N'NC / NCL')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (151, N'New Zealand', N'NZ / NZL')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (152, N'Nicaragua', N'NI / NIC')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (153, N'Niger', N'NE / NER')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (154, N'Nigeria', N'NG / NGA')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (155, N'Niue', N'NU / NIU')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (156, N'North Korea', N'KP / PRK')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (157, N'Northern Mariana Islands', N'MP / MNP')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (158, N'Norway', N'NO / NOR')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (159, N'Oman', N'OM / OMN')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (160, N'Pakistan', N'PK / PAK')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (161, N'Palau', N'PW / PLW')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (162, N'Palestine', N'PS / PSE')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (163, N'Panama', N'PA / PAN')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (164, N'Papua New Guinea', N'PG / PNG')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (165, N'Paraguay', N'PY / PRY')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (166, N'Peru', N'PE / PER')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (167, N'Philippines', N'PH / PHL')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (168, N'Pitcairn', N'PN / PCN')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (169, N'Poland', N'PL / POL')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (170, N'Portugal', N'PT / PRT')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (171, N'Puerto Rico', N'PR / PRI')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (172, N'Qatar', N'QA / QAT')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (173, N'Republic of the Congo', N'CG / COG')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (174, N'Reunion', N'RE / REU')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (175, N'Romania', N'RO / ROU')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (176, N'Russia', N'RU / RUS')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (177, N'Rwanda', N'RW / RWA')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (178, N'Saint Barthelemy', N'BL / BLM')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (179, N'Saint Helena', N'SH / SHN')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (180, N'Saint Kitts and Nevis', N'KN / KNA')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (181, N'Saint Lucia', N'LC / LCA')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (182, N'Saint Martin', N'MF / MAF')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (183, N'Saint Pierre and Miquelon', N'PM / SPM')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (184, N'Saint Vincent and the Grenadines', N'VC / VCT')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (185, N'Samoa', N'WS / WSM')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (186, N'San Marino', N'SM / SMR')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (187, N'Sao Tome and Principe', N'ST / STP')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (188, N'Saudi Arabia', N'SA / SAU')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (189, N'Senegal', N'SN / SEN')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (190, N'Serbia', N'RS / SRB')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (191, N'Seychelles', N'SC / SYC')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (192, N'Sierra Leone', N'SL / SLE')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (193, N'Singapore', N'SG / SGP')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (194, N'Sint Maarten', N'SX / SXM')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (195, N'Slovakia', N'SK / SVK')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (196, N'Slovenia', N'SI / SVN')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (197, N'Solomon Islands', N'SB / SLB')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (198, N'Somalia', N'SO / SOM')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (199, N'South Africa', N'ZA / ZAF')
GO
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (200, N'South Korea', N'KR / KOR')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (201, N'South Sudan', N'SS / SSD')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (202, N'Spain', N'ES / ESP')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (203, N'Sri Lanka', N'LK / LKA')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (204, N'Sudan', N'SD / SDN')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (205, N'Suriname', N'SR / SUR')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (206, N'Svalbard and Jan Mayen', N'SJ / SJM')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (207, N'Swaziland', N'SZ / SWZ')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (208, N'Sweden', N'SE / SWE')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (209, N'Switzerland', N'CH / CHE')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (210, N'Syria', N'SY / SYR')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (211, N'Taiwan', N'TW / TWN')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (212, N'Tajikistan', N'TJ / TJK')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (213, N'Tanzania', N'TZ / TZA')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (214, N'Thailand', N'TH / THA')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (215, N'Togo', N'TG / TGO')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (216, N'Tokelau', N'TK / TKL')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (217, N'Tonga', N'TO / TON')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (218, N'Trinidad and Tobago', N'TT / TTO')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (219, N'Tunisia', N'TN / TUN')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (220, N'Turkey', N'TR / TUR')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (221, N'Turkmenistan', N'TM / TKM')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (222, N'Turks and Caicos Islands', N'TC / TCA')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (223, N'Tuvalu', N'TV / TUV')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (224, N'U.S. Virgin Islands', N'VI / VIR')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (225, N'Uganda', N'UG / UGA')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (226, N'Ukraine', N'UA / UKR')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (227, N'United Arab Emirates', N'AE / ARE')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (228, N'United Kingdom', N'GB / GBR')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (229, N'United States', N'US / USA')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (230, N'Uruguay', N'UY / URY')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (231, N'Uzbekistan', N'UZ / UZB')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (232, N'Vanuatu', N'VU / VUT')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (233, N'Vatican', N'VA / VAT')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (234, N'Venezuela', N'VE / VEN')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (235, N'Vietnam', N'VN / VNM')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (236, N'Wallis and Futuna', N'WF / WLF')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (237, N'Western Sahara', N'EH / ESH')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (238, N'Yemen', N'YE / YEM')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (239, N'Zambia', N'ZM / ZMB')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (240, N'Zimbabwe', N'ZW / ZWE')
SET IDENTITY_INSERT [dbo].[CountryMaster] OFF
SET IDENTITY_INSERT [dbo].[GroupRank] ON 

INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (43, 14, 1047, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (44, 15, 1048, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (45, 15, 1049, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (46, 15, 1050, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (47, 15, 1051, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (48, 15, 1052, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (49, 15, 1053, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (50, 15, 1054, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (51, 15, 1055, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (52, 15, 1056, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (53, 15, 1057, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (54, 15, 1058, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (55, 15, 1059, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (56, 15, 1060, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (57, 15, 1061, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (58, 15, 1062, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (59, 15, 1063, 9876543)
SET IDENTITY_INSERT [dbo].[GroupRank] OFF
SET IDENTITY_INSERT [dbo].[Groups] ON 

INSERT [dbo].[Groups] ([ID], [GroupName], [AllowDelete], [VesselID]) VALUES (13, N'Super Admin', 1, 9876543)
INSERT [dbo].[Groups] ([ID], [GroupName], [AllowDelete], [VesselID]) VALUES (14, N'Admin', 1, 9876543)
INSERT [dbo].[Groups] ([ID], [GroupName], [AllowDelete], [VesselID]) VALUES (15, N'User', 1, 9876543)
SET IDENTITY_INSERT [dbo].[Groups] OFF
SET IDENTITY_INSERT [dbo].[Ranks] ON 

-- Dheeman da ----------------------------------------
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1047, N'Master', N'Master', 1, NULL, 0, NULL, NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1048, N'Chief Off', N'Chief Off', 5, NULL, 0, NULL, NULL, 0, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1049, N'2nd Off', N'2nd Off', 2, NULL, 0, NULL, NULL, 0, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1050, N'Chief Engineer', N'Chief Engineer', 3, NULL, 0, NULL, NULL, 0, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1051, N'1st Engineer', N'1st Engineer', 4, NULL, 0, NULL, NULL, 0, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1052, N'ETO', N'ETO', 6, NULL, 0, NULL, NULL, 0, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1053, N'3rd Engineer', N'3rd Engineer', 7, NULL, 0, NULL, NULL, 0, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1054, N'Bosun / Crane', N'Bosun / Crane', 8, NULL, 0, NULL, NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1055, N'Crane Operator', N'Crane Operator', 9, NULL, 0, NULL, NULL, 0, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1056, N'AB', N'AB', 10, NULL, 0, NULL, NULL, 0, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1057, N'Fitter', N'Fitter', 11, NULL, 0, NULL, NULL, 0, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1058, N'Oiler', N'Oiler', 12, NULL, 0, NULL, NULL, 0, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1059, N'Cook', N'Cook', 13, NULL, 0, NULL, NULL, 0, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1060, N'Steward', N'Steward', 14, NULL, 0, NULL, NULL, 0, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1061, N'O/S', N'O/S', 15, NULL, 0, NULL, NULL, 0, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1062, N'2nd Cook', N'2nd Cook', 16, NULL, 0, NULL, NULL, 0, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1063, N'Third Deck Officer', N'Third Deck Officer', 17, NULL, 0, NULL, NULL, 0, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1067, N'SDPO', N'SDPO', 18, NULL, 0, NULL, NULL, 0, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1068, N'DPO', N'DPO', 19, NULL, 0, NULL, NULL, 0, 9876543)

-- Deep ---------------------------------------------
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1070, 'Master / Captain',NULL, 25, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1071, 'Chief Officer/ Chief Mate',NULL, 26, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1072, 'Second Officer/ Second Mate',NULL, 27, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1073, 'Third Officer/Mate',NULL, 28, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1074, 'Fourth Officer / Junior Officer',NULL, 29, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1075, 'Deck Cadet  1',NULL, 30, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1076, 'Deck Cadet  2',NULL, 31, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1077, 'Radio Operator',NULL, 32, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1078, 'Ships Clerk',NULL, 33, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1079, 'Bosun',NULL, 34, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1080, 'Pumpman',NULL, 35, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1081, 'Welder/Fitter',NULL, 36, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1082, 'Able Bodied Seaman (AB)  1',NULL, 37, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1083, 'Able Bodied Seaman (AB)  2',NULL, 38, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1084, 'Able Bodied Seaman (AB)  3',NULL, 39, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1085, 'Ordinary Seaman ( OS)  1',NULL, 40, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1086, 'Ordinary Seaman ( OS)  2',NULL, 41, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1087, 'Ordinary Seaman ( OS)  3',NULL, 42, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1088, 'Trainee OS',NULL, 43, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1089, 'Chief Engineer',NULL, 44, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1090, 'Second Engineer/First Assistant Engineer',NULL, 45, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1091, 'Third Engineer/ Second Assistant Engineer',NULL, 46, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1092, 'Fourth Engineer/ Third Assistant Engineer',NULL, 47, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1093, 'Fifth Engineer/ Engine Cadet',NULL, 48, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1094, 'Electrical Officer',NULL, 49, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1095, 'Trainee Electrical Officer',NULL, 50, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1096, 'Fitter /Welder',NULL, 51, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1097, 'Motorman / Oiler   1',NULL, 52, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1098, 'Motorman / Oiler   2',NULL, 53, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1099, 'Motorman / Oiler   3',NULL, 54, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1100, 'Wiper 1',NULL, 55, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1101, 'Wiper 2',NULL, 56, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1102, 'Trainee Fitter / Welder',NULL, 57, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1103, 'Chief Cook',NULL, 58, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1104, '2nd  Cook',NULL, 59, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1105, 'Trainee Cook',NULL, 60, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1106, 'Steward / Mess Man',NULL, 61, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1107, 'Trainee Steward',NULL, 62, NULL, 0, NULL, NULL, 0, 9876543)
--INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
--VALUES (1108, 'Laundry man',NULL, 63, NULL, 0, NULL, NULL, 0, 9876543)

SET IDENTITY_INSERT [dbo].[Ranks] OFF
SET IDENTITY_INSERT [dbo].[Regimes] ON 

INSERT [dbo].[Regimes] ([ID], [RegimeName], [Description], [Basis], [MinTotalRestIn7Days], [MaxTotalWorkIn24Hours], [MinContRestIn24Hours], [MinTotalRestIn24Hours], [MaxTotalWorkIn7Days], [CheckFor2Days], [OPA90], [ManilaExceptions], [UseHistCalculationOnly], [CheckOnlyWorkHours], [VesselID]) VALUES (1, N'IMO STCW', N'IMO STCW Convention (Regulation VIII/1) concerning minimum rest hours', N'rest', 70, 14, 6, 10, 98, 0, 1, NULL, 1, 1, NULL)
INSERT [dbo].[Regimes] ([ID], [RegimeName], [Description], [Basis], [MinTotalRestIn7Days], [MaxTotalWorkIn24Hours], [MinContRestIn24Hours], [MinTotalRestIn24Hours], [MaxTotalWorkIn7Days], [CheckFor2Days], [OPA90], [ManilaExceptions], [UseHistCalculationOnly], [CheckOnlyWorkHours], [VesselID]) VALUES (2, N'ILO Rest (Flexible)', N'ILO Convention No 180 based on minimum rest hours (Article 5 1b)', N'rest', 77, 14, 6, 10, 91, 0, 0, NULL, 1, 1, NULL)
INSERT [dbo].[Regimes] ([ID], [RegimeName], [Description], [Basis], [MinTotalRestIn7Days], [MaxTotalWorkIn24Hours], [MinContRestIn24Hours], [MinTotalRestIn24Hours], [MaxTotalWorkIn7Days], [CheckFor2Days], [OPA90], [ManilaExceptions], [UseHistCalculationOnly], [CheckOnlyWorkHours], [VesselID]) VALUES (3, N'ILO Work', N'ILO Convention No 180 based on maximum hours of work (Article 5 1a)', N'work', 96, 14, 6, 10, 72, 0, 1, NULL, 0, 1, NULL)
INSERT [dbo].[Regimes] ([ID], [RegimeName], [Description], [Basis], [MinTotalRestIn7Days], [MaxTotalWorkIn24Hours], [MinContRestIn24Hours], [MinTotalRestIn24Hours], [MaxTotalWorkIn7Days], [CheckFor2Days], [OPA90], [ManilaExceptions], [UseHistCalculationOnly], [CheckOnlyWorkHours], [VesselID]) VALUES (4, N'Customised', N'Based on collective agreement or national regulations', N'rest', 70, 14, 6, 10, 93, 0, 1, NULL, 1, 1, NULL)
INSERT [dbo].[Regimes] ([ID], [RegimeName], [Description], [Basis], [MinTotalRestIn7Days], [MaxTotalWorkIn24Hours], [MinContRestIn24Hours], [MinTotalRestIn24Hours], [MaxTotalWorkIn7Days], [CheckFor2Days], [OPA90], [ManilaExceptions], [UseHistCalculationOnly], [CheckOnlyWorkHours], [VesselID]) VALUES (5, N'ILO Rest', N'ILO Convention No 180 based on minimum rest hours (Article 5 1b)', N'rest', 77, 14, 6, 10, 91, 0, 0, NULL, 1, 1, NULL)
INSERT [dbo].[Regimes] ([ID], [RegimeName], [Description], [Basis], [MinTotalRestIn7Days], [MaxTotalWorkIn24Hours], [MinContRestIn24Hours], [MinTotalRestIn24Hours], [MaxTotalWorkIn7Days], [CheckFor2Days], [OPA90], [ManilaExceptions], [UseHistCalculationOnly], [CheckOnlyWorkHours], [VesselID]) VALUES (6, N'IMO STCW 2010', N'IMO STCW 2010 Convention (Regulation VIII/1) concerning minimum rest hours', N'rest', 77, 14, 6, 10, 91, 0, 0, 0, 1, 1, NULL)
INSERT [dbo].[Regimes] ([ID], [RegimeName], [Description], [Basis], [MinTotalRestIn7Days], [MaxTotalWorkIn24Hours], [MinContRestIn24Hours], [MinTotalRestIn24Hours], [MaxTotalWorkIn7Days], [CheckFor2Days], [OPA90], [ManilaExceptions], [UseHistCalculationOnly], [CheckOnlyWorkHours], [VesselID]) VALUES (7, N'OCIMF', N'OCIMF Historical Regime', N'rest', 77, 14, 6, 10, 91, 0, 0, 0, 1, 0, NULL)
SET IDENTITY_INSERT [dbo].[Regimes] OFF

GO
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue],IsActive) VALUES (N'dateformat', N'106',1)
-- New 
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue],IsActive) VALUES (N'Subject', N'DATASYNCFILE',1)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue],IsActive) VALUES (N'zipoutputsize', N'1000',1)
























/********* Strat Tag ************** NewInitialData Deep 02.09.2020 ******/

GO
SET IDENTITY_INSERT [dbo].[VesselType] ON 

INSERT [dbo].[VesselType] ([Id], [Description]) VALUES (1, N'Dry Vessel')
INSERT [dbo].[VesselType] ([Id], [Description]) VALUES (2, N'Tanker  Vessel
')
INSERT [dbo].[VesselType] ([Id], [Description]) VALUES (3, N'Off Shore Vessel
')
INSERT [dbo].[VesselType] ([Id], [Description]) VALUES (4, N'Special Purpose Vessel 
')
INSERT [dbo].[VesselType] ([Id], [Description]) VALUES (5, N'Passenger Vessel 
')
SET IDENTITY_INSERT [dbo].[VesselType] OFF
SET IDENTITY_INSERT [dbo].[VesselSubType] ON 

INSERT [dbo].[VesselSubType] ([ID], [VesselTypeID], [SubTypeDescription]) VALUES (1, 1, N'Bulk Carrier 
')
INSERT [dbo].[VesselSubType] ([ID], [VesselTypeID], [SubTypeDescription]) VALUES (2, 1, N'Container 
')
INSERT [dbo].[VesselSubType] ([ID], [VesselTypeID], [SubTypeDescription]) VALUES (3, 1, N'Roll on Rol off
')
INSERT [dbo].[VesselSubType] ([ID], [VesselTypeID], [SubTypeDescription]) VALUES (4, 2, N'Oil Tanker 
')
INSERT [dbo].[VesselSubType] ([ID], [VesselTypeID], [SubTypeDescription]) VALUES (5, 2, N'Chemical  Tanker
')
INSERT [dbo].[VesselSubType] ([ID], [VesselTypeID], [SubTypeDescription]) VALUES (6, 2, N'Gas Tanker
')
INSERT [dbo].[VesselSubType] ([ID], [VesselTypeID], [SubTypeDescription]) VALUES (7, 3, N'Supply Ship')
INSERT [dbo].[VesselSubType] ([ID], [VesselTypeID], [SubTypeDescription]) VALUES (8, 3, N'Pipe Layers
')
INSERT [dbo].[VesselSubType] ([ID], [VesselTypeID], [SubTypeDescription]) VALUES (9, 3, N'Crane Barges or floating cranes
')
INSERT [dbo].[VesselSubType] ([ID], [VesselTypeID], [SubTypeDescription]) VALUES (10, 3, N'Semi-submersible Drill Rigs')
INSERT [dbo].[VesselSubType] ([ID], [VesselTypeID], [SubTypeDescription]) VALUES (11, 3, N'Drill Ships')
INSERT [dbo].[VesselSubType] ([ID], [VesselTypeID], [SubTypeDescription]) VALUES (12, 3, N'Accommodation Barges')
INSERT [dbo].[VesselSubType] ([ID], [VesselTypeID], [SubTypeDescription]) VALUES (13, 3, N'Production Platforms
')
INSERT [dbo].[VesselSubType] ([ID], [VesselTypeID], [SubTypeDescription]) VALUES (14, 3, N'Floating Storage Unit (FSU)
')
INSERT [dbo].[VesselSubType] ([ID], [VesselTypeID], [SubTypeDescription]) VALUES (15, 3, N'Anchor handling vessels
')
INSERT [dbo].[VesselSubType] ([ID], [VesselTypeID], [SubTypeDescription]) VALUES (16, 3, N'Diving vessels 
')
INSERT [dbo].[VesselSubType] ([ID], [VesselTypeID], [SubTypeDescription]) VALUES (17, 4, N'Tugs')
INSERT [dbo].[VesselSubType] ([ID], [VesselTypeID], [SubTypeDescription]) VALUES (18, 4, N'Cable Layers')
INSERT [dbo].[VesselSubType] ([ID], [VesselTypeID], [SubTypeDescription]) VALUES (19, 4, N'Research Vessels
')
INSERT [dbo].[VesselSubType] ([ID], [VesselTypeID], [SubTypeDescription]) VALUES (20, 4, N'Salvage Vessels
')
INSERT [dbo].[VesselSubType] ([ID], [VesselTypeID], [SubTypeDescription]) VALUES (21, 4, N'Barge Carriers')
INSERT [dbo].[VesselSubType] ([ID], [VesselTypeID], [SubTypeDescription]) VALUES (22, 4, N'Timber Carriers')
INSERT [dbo].[VesselSubType] ([ID], [VesselTypeID], [SubTypeDescription]) VALUES (23, 4, N'Livestock Carriers
')
INSERT [dbo].[VesselSubType] ([ID], [VesselTypeID], [SubTypeDescription]) VALUES (24, 4, N'Ice breaker ships')
INSERT [dbo].[VesselSubType] ([ID], [VesselTypeID], [SubTypeDescription]) VALUES (25, 5, N'Ferries 
')
INSERT [dbo].[VesselSubType] ([ID], [VesselTypeID], [SubTypeDescription]) VALUES (26, 5, N'Cruise Ship
')
SET IDENTITY_INSERT [dbo].[VesselSubType] OFF
SET IDENTITY_INSERT [dbo].[VesselSubSubType] ON 

INSERT [dbo].[VesselSubSubType] ([ID], [VesselSubTypeID], [VesselSubSubTypeDecsription]) VALUES (1, 1, N'VLOC
')
INSERT [dbo].[VesselSubSubType] ([ID], [VesselSubTypeID], [VesselSubSubTypeDecsription]) VALUES (2, 1, N'Cape size
')
INSERT [dbo].[VesselSubSubType] ([ID], [VesselSubTypeID], [VesselSubSubTypeDecsription]) VALUES (3, 1, N'Panamax
')
INSERT [dbo].[VesselSubSubType] ([ID], [VesselSubTypeID], [VesselSubSubTypeDecsription]) VALUES (4, 1, N'Handymax
')
INSERT [dbo].[VesselSubSubType] ([ID], [VesselSubTypeID], [VesselSubSubTypeDecsription]) VALUES (5, 1, N'Handy Size
')
INSERT [dbo].[VesselSubSubType] ([ID], [VesselSubTypeID], [VesselSubSubTypeDecsription]) VALUES (6, 2, N'Suezmax
')
INSERT [dbo].[VesselSubSubType] ([ID], [VesselSubTypeID], [VesselSubSubTypeDecsription]) VALUES (7, 2, N'Panamax
')
INSERT [dbo].[VesselSubSubType] ([ID], [VesselSubTypeID], [VesselSubSubTypeDecsription]) VALUES (8, 2, N'Post-Panamax
')
INSERT [dbo].[VesselSubSubType] ([ID], [VesselSubTypeID], [VesselSubSubTypeDecsription]) VALUES (9, 2, N'Post-Suezmax
')
INSERT [dbo].[VesselSubSubType] ([ID], [VesselSubTypeID], [VesselSubSubTypeDecsription]) VALUES (10, 2, N'Post-Malaccamax
')
INSERT [dbo].[VesselSubSubType] ([ID], [VesselSubTypeID], [VesselSubSubTypeDecsription]) VALUES (11, 3, N'Pure Car Carrier (PCC) and Pure Car and Truck Carrier (PCTC) RoRo Ships
')
INSERT [dbo].[VesselSubSubType] ([ID], [VesselSubTypeID], [VesselSubSubTypeDecsription]) VALUES (12, 3, N'Container Vessel + Ro-Ro (ConRo) Ship
')
INSERT [dbo].[VesselSubSubType] ([ID], [VesselSubTypeID], [VesselSubSubTypeDecsription]) VALUES (13, 3, N'General Cargo + Ro-Ro Ship (GenRo) Ships
')
INSERT [dbo].[VesselSubSubType] ([ID], [VesselSubTypeID], [VesselSubSubTypeDecsription]) VALUES (14, 3, N'RoPax
')
INSERT [dbo].[VesselSubSubType] ([ID], [VesselSubTypeID], [VesselSubSubTypeDecsription]) VALUES (15, 3, N'Complete RoRo Ship
')
INSERT [dbo].[VesselSubSubType] ([ID], [VesselSubTypeID], [VesselSubSubTypeDecsription]) VALUES (16, 4, N'ULCC
')
INSERT [dbo].[VesselSubSubType] ([ID], [VesselSubTypeID], [VesselSubSubTypeDecsription]) VALUES (17, 4, N'VLCC
')
INSERT [dbo].[VesselSubSubType] ([ID], [VesselSubTypeID], [VesselSubSubTypeDecsription]) VALUES (18, 4, N'Suezmax
')
INSERT [dbo].[VesselSubSubType] ([ID], [VesselSubTypeID], [VesselSubSubTypeDecsription]) VALUES (19, 4, N'Aframax
')
INSERT [dbo].[VesselSubSubType] ([ID], [VesselSubTypeID], [VesselSubSubTypeDecsription]) VALUES (20, 4, N'LR Tanker
')
INSERT [dbo].[VesselSubSubType] ([ID], [VesselSubTypeID], [VesselSubSubTypeDecsription]) VALUES (21, 4, N'MR Tanker
')
INSERT [dbo].[VesselSubSubType] ([ID], [VesselSubTypeID], [VesselSubSubTypeDecsription]) VALUES (22, 5, N'Type 1
')
INSERT [dbo].[VesselSubSubType] ([ID], [VesselSubTypeID], [VesselSubSubTypeDecsription]) VALUES (23, 5, N'Type 2')
INSERT [dbo].[VesselSubSubType] ([ID], [VesselSubTypeID], [VesselSubSubTypeDecsription]) VALUES (24, 5, N'Type 13')
INSERT [dbo].[VesselSubSubType] ([ID], [VesselSubTypeID], [VesselSubSubTypeDecsription]) VALUES (25, 6, N'Fully pressurized gas carrier.
')
INSERT [dbo].[VesselSubSubType] ([ID], [VesselSubTypeID], [VesselSubSubTypeDecsription]) VALUES (26, 6, N'Semi-pressurised ships.
')
INSERT [dbo].[VesselSubSubType] ([ID], [VesselSubTypeID], [VesselSubSubTypeDecsription]) VALUES (27, 6, N'Ethylene and gas/chemical carriers.
')
INSERT [dbo].[VesselSubSubType] ([ID], [VesselSubTypeID], [VesselSubSubTypeDecsription]) VALUES (28, 6, N'Fully refrigerated LPG Carrier
')
INSERT [dbo].[VesselSubSubType] ([ID], [VesselSubTypeID], [VesselSubSubTypeDecsription]) VALUES (29, 6, N'Liquefied Natural Gas (LNG carrier)
')
INSERT [dbo].[VesselSubSubType] ([ID], [VesselSubTypeID], [VesselSubSubTypeDecsription]) VALUES (30, 6, N'Compressed Natural Gas (CNG carrier)
')
SET IDENTITY_INSERT [dbo].[VesselSubSubType] OFF


SET IDENTITY_INSERT [dbo].[DepartmentAdmin] ON 

INSERT [dbo].[DepartmentAdmin] ([DepartmentAdminID], [DepartmentMasterID], [CrewID], [IsActive], [PositionEndDate], [IsAdmin], [VesselID], [ReportsTo]) VALUES (5, 8, 5, 1, NULL, 1, 8940557, NULL)
INSERT [dbo].[DepartmentAdmin] ([DepartmentAdminID], [DepartmentMasterID], [CrewID], [IsActive], [PositionEndDate], [IsAdmin], [VesselID], [ReportsTo]) VALUES (7, 9, 2, 1, NULL, 1, 8940557, NULL)
INSERT [dbo].[DepartmentAdmin] ([DepartmentAdminID], [DepartmentMasterID], [CrewID], [IsActive], [PositionEndDate], [IsAdmin], [VesselID], [ReportsTo]) VALUES (9, 7, 2, 1, NULL, 1, 8940557, NULL)
SET IDENTITY_INSERT [dbo].[DepartmentAdmin] OFF


SET IDENTITY_INSERT [dbo].[DepartmentMaster] ON 

INSERT [dbo].[DepartmentMaster] ([DepartmentMasterID], [DepartmentMasterName], [DepartmentMasterCode], [IsActive], [VesselID]) VALUES (7, N'Deck Department', NULL, 1, 8940557)
INSERT [dbo].[DepartmentMaster] ([DepartmentMasterID], [DepartmentMasterName], [DepartmentMasterCode], [IsActive], [VesselID]) VALUES (8, N'Engine Department', NULL, 1, 8940557)
INSERT [dbo].[DepartmentMaster] ([DepartmentMasterID], [DepartmentMasterName], [DepartmentMasterCode], [IsActive], [VesselID]) VALUES (9, N'Catering Department', NULL, 1, 8940557)
SET IDENTITY_INSERT [dbo].[DepartmentMaster] OFF


SET IDENTITY_INSERT [dbo].[TemperatureMode] ON 

INSERT [dbo].[TemperatureMode] ([ID], [Mode]) VALUES (1, N'Oral')
INSERT [dbo].[TemperatureMode] ([ID], [Mode]) VALUES (2, N'Rectum')
INSERT [dbo].[TemperatureMode] ([ID], [Mode]) VALUES (3, N'Armpit')
INSERT [dbo].[TemperatureMode] ([ID], [Mode]) VALUES (4, N'Forehead')
SET IDENTITY_INSERT [dbo].[TemperatureMode] OFF

INSERT [dbo].[WorkingHours] ([DayNumber], [RegimeID], [WorkHours]) VALUES (1, 2, 8)
INSERT [dbo].[WorkingHours] ([DayNumber], [RegimeID], [WorkHours]) VALUES (2, 2, 8)
INSERT [dbo].[WorkingHours] ([DayNumber], [RegimeID], [WorkHours]) VALUES (3, 2, 8)
INSERT [dbo].[WorkingHours] ([DayNumber], [RegimeID], [WorkHours]) VALUES (4, 2, 8)
INSERT [dbo].[WorkingHours] ([DayNumber], [RegimeID], [WorkHours]) VALUES (5, 2, 8)
INSERT [dbo].[WorkingHours] ([DayNumber], [RegimeID], [WorkHours]) VALUES (6, 2, 4)
INSERT [dbo].[WorkingHours] ([DayNumber], [RegimeID], [WorkHours]) VALUES (7, 2, 0)

/********* End Tag ************** New Initial Data Deep 02.09.2020 ******/