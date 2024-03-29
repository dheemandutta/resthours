USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpAddUsers]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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

			UPDATE Users SET Username = @UserName , Password = @Password ,Active = @Active 

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










GO
/****** Object:  StoredProcedure [dbo].[stpDeleteDepartment]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpDeleteShipDetails]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpDetleteRanks]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportCrew]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportCrewRegimeTR]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportDepartmentAdmin]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportDepartmentMaster]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportFirstRun]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportGroupRank]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportGroups]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportNCDetails]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportRanks]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportRegimes]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportServiceTerms]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportShip]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExporttblRegime]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportTimeAdjustment]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportUserGroups]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportUsers]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportWorkSessions]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stpExportWorkSessions]
AS
Begin


Select * from WorkSessions 
--Select * from tblRegime FOR XML AUTO
End

GO
/****** Object:  StoredProcedure [dbo].[stpGetAllCrewByCrewID]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--   exec stpGetAllCrewByCrewID 17, 9876543
CREATE PROCEDURE [dbo].[stpGetAllCrewByCrewID]
(
	@ID int,
	@VesselID int
)
AS
Begin
Select  C.ID ,FirstName + '  ' +LastName AS Name, RankName, ISNULL(Notes,' ') Notes , C.VesselID,
ISNULL(CONVERT(varchar(12),ST.ActiveFrom,101), '-') ActiveFrom1,
ISNULL(CONVERT(varchar(12),ST.ActiveTo,101), '-') ActiveTo1,
C.FirstName,C.LastName,
ISNULL(CONVERT(varchar(12),DOB,101), '-') DOB1,
ISNULL(C.CountryID,'') CountryID,
ISNULL(CM.CountryName,'') CountryName,
--ISNULL(C.Nationality,'') Nationality,
ISNULL(C.POB,'') POB, 
ISNULL(C.CrewIdentity,'') CrewIdentity,ISNULL(C.PassportSeamanPassportBook,'') PassportSeamanPassportBook,
ISNULL(C.Seaman,'') Seaman,
--
ISNULL(CONVERT(varchar(12),C.CreatedOn,101), '-') CreatedOn,
ISNULL(CONVERT(varchar(12),C.LatestUpdate,101), '-') LatestUpdate,
--
C.OvertimeEnabled,C.Watchkeeper,C.RankID


,C.DepartmentMasterID, DM.DepartmentMasterName


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


GO
/****** Object:  StoredProcedure [dbo].[stpGetAllCrewForAssign]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetAllRanks]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetAllRegimes]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetAllShipDetails]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetAlltblConfig]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
Select *
from tblConfig
WHERE UPPER(LTRIM(RTRIM(KeyName))) = UPPER(RTRIM(LTRIM(@KeyName)))
AND IsActive=1
End 
GO
/****** Object:  StoredProcedure [dbo].[stpGetAllUsersForDrp]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetChildNodes]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetCrewByDepartmentAdmin]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec stpGetCrewByDepartmentAdmin 5, 11, 9876543
CREATE procedure [dbo].[stpGetCrewByDepartmentAdmin]
(
@DepartmentMasterID int,
@DepartmentAdminID int,
@VesselID int
)
AS
Begin
Select C.ID
from Crew C
INNER JOIN DepartmentAdmin DA 
ON C.ID = DA.CrewID
INNER JOIN DepartmentMaster DM
ON DA.DepartmentMasterID = DM.DepartmentMasterID
Where C.VesselID = @VesselID
AND DM.DepartmentMasterID =@DepartmentMasterID
AND C.DepartmentAdminId =@DepartmentAdminID
End
GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewByID]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- stpGetCrewByID 18

CREATE PROCEDURE [dbo].[stpGetCrewByID]
(
	@ID int
)
AS
Begin
Select  DOB
FROM Crew
WHERE ID= @ID
End
GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewByRankID]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetCrewByUserID]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetCrewDetailsForHealthByID]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetCrewDetailsForHealthByIDNew]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  Exec stpGetCrewDetailsForHealthByIDNew 18
create PROCEDURE [dbo].[stpGetCrewDetailsForHealthByIDNew]
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
/****** Object:  StoredProcedure [dbo].[stpGetCrewDetailsPageWise]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetCrewIDFromWorkSessions]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec stpGetCrewIDFromWorkSessions '1048' ,'02','2018'



CREATE PROCEDURE [dbo].[stpGetCrewIDFromWorkSessions]

(

	@CrewId int,

	@Month int,

	@Year int,

	@VesselID int

)

AS

BEGIN

		

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

		  AdjustmentFactor varchar(10),
		  VesselID int



		)



		INSERT INTO @TimeTab

		SELECT WS.ID,Hours,DAY(ValidOn) AS BookDate,C.FirstName,C.LastName,R.RankName,ISNULL(CONVERT(varchar(12),ValidOn,103), '') AS WorkDate,ComplianceInfo,TotalNCHours,WS.Comment,AdjustmentFator As AdjustmentFactor, WS.VesselID

		FROM WorkSessions WS

		LEFT OUTER JOIN Crew C

		ON C.ID = WS.CrewID

		LEFT OUTER JOIN NCDetails NCD

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

		ORDER BY ValidOn,WS.Timestamp

	

		

		DECLARE @id int

		DECLARE @bdate varchar(10)

		DECLARE @nextval varchar(10)



		SET @nextval =''

					

		DECLARE db_cursor CURSOR FOR 

		SELECT ID,BookDate FROm @TimeTab

		

		OPEN db_cursor  

		FETCH NEXT FROM db_cursor INTO @id,@bdate

		

		WHILE @@FETCH_STATUS = 0  

		BEGIN  

			 

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
/****** Object:  StoredProcedure [dbo].[stpGetCrewListingPageWise]    Script Date: 12-Aug-18 10:24:23 PM ******/
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

	 ,CONVERT(varchar(12),CreatedOn,103) StartDate

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

--GROUP BY Name,RankName,CreatedOn,C.LatestUpdate

	

     

      SELECT @RecordCount = COUNT(*)

      FROM #Results

           

      SELECT * FROM #Results

      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

     AND VesselID = @VesselID

      DROP TABLE #Results

END










GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewOvertimeValue]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetCrewPageWise]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetCrewReportListPageWise]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


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

	 ,(ISNULL(CONVERT(VARCHAR(12),C.DOB,103),'') +' '+ISNULL(C.POB,'') ) AS DOB1

	 ,C.ID

	 ,CM.CountryName AS Nationality

	 ,C.EmployeeNumber

	 ,C.DOB

	 ,C.PassportSeamanPassportBook

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
/****** Object:  StoredProcedure [dbo].[stpGetDataForVarianceReport]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec stpGetCrewIDFromWorkSessions '19' ,'11','2017'



CREATE PROCEDURE [dbo].[stpGetDataForVarianceReport]

(

	@CrewId int,
	@Month int,
	@Year int,
    @PageIndex INT = 1,
	@PageSize INT = 31,
	@RecordCount INT OUTPUT,
	@VesselID int

)

AS

BEGIN

		

		

		SET NOCOUNT ON;

      SELECT ROW_NUMBER() OVER

      (

            ORDER BY WS.ID ASC

      )AS RowNumber

      ,WS.ID

	  ,Hours

	  ,DAY(ValidOn) AS BookDate

	  ,FirstName

	  ,LastName

	  ,RankName

	  ,ISNULL(CONVERT(varchar(12),ValidOn,103), '') AS WorkDate

	  ,ComplianceInfo

	  ,TotalNCHours

	  ,Comment

	  ,AdjustmentFator AS 'AdjustmentFactor'

	  ,C.VesselID

     INTO #Results

       FROM WorkSessions WS

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

		



		SELECT @RecordCount = COUNT(*)

      FROM #Results



	   SELECT  * FROM #Results

      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

	  AND VesselID=@VesselID

	  ORDER BY WorkDate ASC

     

      DROP TABLE #Results

		

	--	SELECT Hours,DAY(ValidOn) AS BookDate,C.FirstName,C.LastName,R.RankName,ISNULL(CONVERT(varchar(12),ValidOn,103), '') AS WorkDate,ComplianceInfo,TotalNCHours,WS.Comment

	--	FROM WorkSessions WS

	--	LEFT OUTER JOIN Crew C

	--	ON C.ID = WS.CrewID

	--	INNER JOIN NCDetails NCD

	--	ON WS.CrewId= NCD.CrewID 

	--	AND  WS.ValidOn = NCD.OccuredOn

	--	INNER JOIN Ranks R

	--	ON R.ID = C.RankID

		

	

END










GO
/****** Object:  StoredProcedure [dbo].[stpGetDayWiseCrewBookingData]    Script Date: 12-Aug-18 10:24:23 PM ******/
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



SELECT Hours,CrewID, C.FirstName,C.LastName,CM.CountryName AS Nationality,R.RankName,Comment,AdjustmentFator As AdjustmentFactor, C.VesselID

FROM WorkSessions W

INNER JOIN Crew C

ON C.ID= W.CrewID

INNER JOIN CountryMaster CM

ON CM.CountryID = c.CountryID

INNER JOIN Ranks R

ON C.RankID = R.ID 

WHERE CONVERT(varchar(12),ValidOn,103) = CONVERT(varchar(12),@BookDate,103)
AND C.VesselID=@VesselID

ORDER BY CrewID



END
GO
/****** Object:  StoredProcedure [dbo].[stpGetDepartmentByID]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetDepartmentByIDForAssignAdmin]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetDepartmentByIDForAssignCrew]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetDepartmentPageWise]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
	  INNER JOIN DepartmentAdmin DA
	  ON DM.DepartmentMasterID = DA.DepartmentMasterID
	  INNER JOIN Crew C
	  ON DA.CrewID=C.ID               
	    Where DM.VesselID = @VesselID
		AND DM.IsActive=1
      SELECT @RecordCount = COUNT(*)
      FROM #Results
      SELECT * FROM #Results
      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

	  AND VesselID=@VesselID
	 -- ORDER BY [Order] ASC
      DROP TABLE #Results
END








GO
/****** Object:  StoredProcedure [dbo].[stpGetDoctorEmailByID]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetEquipmentsPageWise]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
	 --,ExpiryDate
	  , SUBSTRING(ExpiryDate, 1, 10)as ExpiryDate
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
/****** Object:  StoredProcedure [dbo].[stpGetFirstLastNameByUserId]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec stpGetFirstLastNameByUserId 34

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

	Select  C.FirstName, C.LastName,C.ID AS CrewId, C.VesselID

	FROM Crew C

	INNER JOIN Users U

	ON C.ID = U.CrewId

	WHERE U.ID= @UserId
	AND C.VesselID=@VesselID

END

ELSE IF @CrewId IS NULL

BEGIN

	SELECT 'Admin' FirstName,'Admin' LastName,0 CrewId

	FROM Users WHERE ID = @UserId

	 

END









End










GO
/****** Object:  StoredProcedure [dbo].[stpGetFirstRun]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetFleetMasterPageWise]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetLastAdjustmentBookedStatus]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetLastSevenDaysWorkSchedule]    Script Date: 12-Aug-18 10:24:23 PM ******/
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

		 WHILE (DATEDIFF(day,@BookDate, @ChangedBookDate) >= -7)


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


		 SELECT TOP 7 CONVERT(date,BookDate,110) AS [ValidOn],Schedule AS [Hours] FROM @ScheduleTable  
		 Where VesselID = @VesselID
		 ORDER BY BookDate DESC



 END









GO
/****** Object:  StoredProcedure [dbo].[stpGetLastSixDaysWorkSchedule]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetMedicalAdvisoryPageWise]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
     INTO #Results
      FROM MedicalAdvisory
      where CrewID=@LoggedInUserId
      SELECT @RecordCount = COUNT(*)
      FROM #Results
      SELECT * FROM #Results
      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1
      DROP TABLE #Results
END
GO
/****** Object:  StoredProcedure [dbo].[stpGetMedicinePageWise]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
	 --,ExpiryDate
	 , SUBSTRING(ExpiryDate, 1, 10)as ExpiryDate
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
/****** Object:  StoredProcedure [dbo].[stpGetMinusOneDayAdjustmentDays]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetNCForMonth]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetNonComplianceByCrewId]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetNonComplianceInfo]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetParentNodes]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetPlusOneDayAdjustmentDays]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetRankFromGroup]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [dbo].[stpGetRanksByID]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetRanksPageWise]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetRegimeById]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetShipDetailsByID]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetShipDetailsByID]



AS



Begin

Select  ID,ShipName,IMONumber,FlagOfShip,Regime,IMONumber

FROM dbo.Ship

	  

--WHERE ID= @ID

End










GO
/****** Object:  StoredProcedure [dbo].[stpGetShipDetailsPageWise]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetShipMaster]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetTimeAdjustment]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetTimeAdjustmentDetailsPageWise]    Script Date: 12-Aug-18 10:24:23 PM ******/
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

	,CONVERT(varchar(12),AdjustmentDate,101) AdjustmentDate
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
/****** Object:  StoredProcedure [dbo].[stpGetUserGroupsByUserID]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetUsersDetailsPageWise]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetWrokSessionsByCrewandDate]    Script Date: 12-Aug-18 10:24:23 PM ******/
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



	SELECT *,NCD.NCDetailsID, NCD.VesselID FROM WorkSessions WS

	INNER JOIN NCDetails NCD

	ON WS.ID = NCD.WorkSessionId 

	WHERE WS.CrewId = @CrewId

	AND CONVERT(varchar(12),ValidOn,103) = CONVERT(varchar(12),@BookDate,103)
	AND NCD.VesselID=@VesselID
	ORDER BY Timestamp 



END










GO
/****** Object:  StoredProcedure [dbo].[stpGetWrokSessionsByDate]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec stpGetWrokSessionsByDate 7,2018,9876543

CREATE PROCEDURE [dbo].[stpGetWrokSessionsByDate]

(

	@Month int,

	@Year int,
	@VesselID int

)

AS

BEGIN



	DECLARE @SelectedDay DateTime



	SET @SelectedDay =  datefromparts(@Year, @Month, 1)

	



	SELECT *,NCD.NCDetailsID,C.FirstName + ' ' + C.LastName AS CrewName, WS.VesselID,

	 CASE 

	   WHEN DAY(ValidOn) < 10 THEN '0' + DAY(ValidOn)

	   ELSE DAY(ValidOn)

	END As DateNumber FROM WorkSessions WS

	INNER JOIN NCDetails NCD

	ON WS.ID = NCD.WorkSessionId 

	INNER JOIN Crew C

	ON C.ID = NCD.CrewID

	WHERE MONTH(@SelectedDay) = MONTH(ValidOn)

	AND YEAR(@SelectedDay) =  YEAR(ValidOn)
	AND WS.VesselID=@VesselID
	ORDER BY NCD.CrewID,WS.Timestamp DESC



END










GO
/****** Object:  StoredProcedure [dbo].[stpImportCrew]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpImportCrew] 
( 
@ID int,
@Name nvarchar(100),
@Watchkeeper bit,
@Notes ntext,
@Deleted bit,
@LatestUpdate datetime,
@CompleteHistory bit,
@PayNum nvarchar(25),
@CreatedOn datetime,
@OvertimeEnabled bit,
@EmployeeNumber nvarchar(25),
@NWKHoursMayVary bit,
@RankID int,
@FirstName varchar(100),
@LastName varchar(50),
@Nationality nvarchar(20),
@DOB datetime,
@POB nvarchar(20),
@CrewIdentity nvarchar(20),
@PassportSeamanPassportBook nvarchar(20),
@Seaman nvarchar(20),
@MiddleName varchar(100),
@IsActive bit,
@VesselID int
) 
AS 
BEGIN 
IF NOT EXISTS(SELECT 1 from Crew Where ID=@ID) 
BEGIN   
SET IDENTITY_INSERT Crew ON
INSERT INTO Crew 
            (ID,Name,Watchkeeper,Notes,Deleted ,LatestUpdate,CompleteHistory,PayNum,CreatedOn,OvertimeEnabled,EmployeeNumber,
			NWKHoursMayVary,RankID,FirstName,LastName,Nationality,DOB,POB,CrewIdentity,PassportSeamanPassportBook,Seaman ,
			MiddleName,IsActive,VesselID)

Values(@ID,@Name,@Watchkeeper,@Notes,@Deleted ,@LatestUpdate,@CompleteHistory,@PayNum,@CreatedOn,@OvertimeEnabled,@EmployeeNumber,
			@NWKHoursMayVary,@RankID,@FirstName,@LastName,@Nationality,@DOB,@POB,@CrewIdentity,@PassportSeamanPassportBook,@Seaman ,
			@MiddleName,@IsActive,@VesselID)
SET IDENTITY_INSERT Crew OFF
END

ELSE 

BEGIN
UPDATE Crew
SET Name=@Name,Watchkeeper=@Watchkeeper,Notes=@Notes,Deleted=@Deleted ,LatestUpdate=@LatestUpdate,CompleteHistory=@CompleteHistory,
    PayNum=@PayNum,CreatedOn=@CreatedOn,OvertimeEnabled=@OvertimeEnabled,EmployeeNumber=@EmployeeNumber,NWKHoursMayVary=@NWKHoursMayVary,
	RankID=@RankID,FirstName=@FirstName,LastName=@LastName,Nationality=@Nationality,DOB=@DOB,POB=@POB,CrewIdentity=@CrewIdentity,
	PassportSeamanPassportBook=@PassportSeamanPassportBook,Seaman=@Seaman ,MiddleName=@MiddleName,IsActive=@IsActive,VesselID=@VesselID
Where ID=@ID
END




END
GO
/****** Object:  StoredProcedure [dbo].[stpImportCrewRegimeTR]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpImportDepartmentAdmin]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpImportDepartmentMaster]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpImportFirstRun]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpImportGroupRank]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpImportGroups]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpImportNCDetails]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpImportRank]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpImportRegimes]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpImportServiceTerms]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpImportShip]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpImportUserGroups]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpImportUsers]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpImportWorkSessions]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpInsertEquipmentStock]    Script Date: 12-Aug-18 10:24:23 PM ******/
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


		INSERT INTO tblEquipments(EquipmentsName,Comment,Quantity,ExpiryDate)
		SELECT EquipmentsName,Comment,Quantity,ExpiryDate
		FROM OPENXML(@XMLDocPointer,'/NewDataSet/Equipments',2)
		WITH
		(
			EquipmentsName varchar(500),
	        Comment varchar(500),
	        Quantity varchar(50),
         	ExpiryDate varchar(50)
		)


END

GO
/****** Object:  StoredProcedure [dbo].[stpInsertMedicineStock]    Script Date: 12-Aug-18 10:24:23 PM ******/
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


		INSERT INTO tblMedicine(MedicineName,Quantity,ExpiryDate)
		SELECT MedicineName,Quantity,ExpiryDate
		FROM OPENXML(@XMLDocPointer,'/NewDataSet/Medicine',2)
		WITH
		(
			MedicineName varchar(500),
			Quantity varchar(500),
			ExpiryDate varchar(50)

		)


END

GO
/****** Object:  StoredProcedure [dbo].[stpLastBookedSession]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[stpLastBookedSession]

(

	@CrewId int,
	@VesselID int

	

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

	ORDER BY ValidOn DESC

	)



END










GO
/****** Object:  StoredProcedure [dbo].[stpResetPassword]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveConsultation]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveCrew]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- DECLARE @NewCrewId int    exec stpSaveCrew NULL, trt, ggh, gfgf, 1052, 1, '2018-06-01 00:00:00.000', India, ghjhj, juhjh, '2018-06-14 00:00:00.000', '2018-06-14 00:00:00.000', gfgfg, 0,1,@NewCrewId OUTPUT ,9876543,5
CREATE procedure [dbo].[stpSaveCrew] 
( 
@ID int,
@FirstName nvarchar(100),
@MiddleName nvarchar(100),
@LastName nvarchar(50),
@RankID int,
@CountryID int,
--@Nationality nvarchar(20),
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
@DepartmentMasterID int
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
           (FirstName,MiddleName,LastName,RankID,CreatedOn,LatestUpdate,CountryID,DOB,POB,PassportSeamanPassportBook,Seaman,Notes,Watchkeeper,OvertimeEnabled,EmployeeNumber,VesselID,DepartmentMasterID)  
Values(@FirstName,@MiddleName,@LastName,@RankID,@CreatedOn,@ActiveTo,@CountryID,@DOB,@POB,@PassportSeamanPassportBook,@Seaman,@Notes,@Watchkeeper,@OvertimeEnabled,@EmployeeNum,@VesselID,@DepartmentMasterID) 
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
UPDATE Crew
    SET FirstName=@FirstName,MiddleName=@MiddleName,LastName=@LastName,RankID=@RankID,CreatedOn=@CreatedOn,LatestUpdate=@ActiveTo,
    --PayNum=@PayNum,
	CountryID=@CountryID,
    Notes=@Notes,Watchkeeper=@Watchkeeper,OvertimeEnabled=@OvertimeEnabled,
	PassportSeamanPassportBook=@PassportSeamanPassportBook,Seaman=@Seaman,DOB=@DOB,DepartmentMasterID=@DepartmentMasterID
	WHERE ID=@ID
	UPDATE ServiceTerms SET ActiveFrom = @CreatedOn,ActiveTo = @ActiveTo 
	WHERE CrewId = @ID
	SET @NewCrewId = @ID
  COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRAN 
END CATCH
END
END
GO
/****** Object:  StoredProcedure [dbo].[stpSaveDepartment]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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

END



	COMMIT TRAN
 END TRY 

 BEGIN CATCH
	ROLLBACK TRAN
	SELECT ERROR_MESSAGE() AS ErrorMessage;  
 END CATCH



END
GO
/****** Object:  StoredProcedure [dbo].[stpSaveDoctorMaster]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveGroups]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveMedicalAdvisory]    Script Date: 12-Aug-18 10:24:23 PM ******/
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

	@LoggedInUserId int 
)
AS
BEGIN
	INSERT INTO MedicalAdvisory(Weight,BMI,BloodSugarLevel,UrineTest,
	            Height,Age,BloodSugarUnit,BloodSugarTestType,Systolic,Diastolic,CrewID)
	VALUES  (@Weight,@BMI,@BloodSugarLevel,@UrineTest,
	 @Height,@Age,@BloodSugarUnit,@BloodSugarTestType,@Systolic,@Diastolic,@LoggedInUserId)
END
GO
/****** Object:  StoredProcedure [dbo].[stpSaveMedicine]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  exec stpSaveMedicine 'A Das' , 3

CREATE PROCEDURE [dbo].[stpSaveMedicine]
(
	--@EquipmentsID int,
	@MedicineName varchar(500),
	@Quantity varchar(500)
)
AS
BEGIN
	INSERT INTO tblMedicine(MedicineName,Quantity)
	VALUES (@MedicineName,@Quantity)
END
GO
/****** Object:  StoredProcedure [dbo].[stpSaveNewShipDetails]    Script Date: 12-Aug-18 10:24:23 PM ******/
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

	COMMIT TRAN
 END TRY 

 BEGIN CATCH
	ROLLBACK TRAN
 END CATCH
END 




GO
/****** Object:  StoredProcedure [dbo].[stpSaveRankGroups]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveRanks]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveRanksForXmlProject]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveRegimes]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveShipDetails]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
			VALUES ( N'Chief Off / SDPO', N'Chief Off / SDPO', 2, NULL, 0, NULL, NULL, 1, @VesselId)

			INSERT INTO [Ranks] ([RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
			VALUES ( N'Master / SDPO', N'Master / SDPO', 1, NULL, 0, NULL, NULL, 1, @VesselId)

			INSERT INTO [Ranks] ( [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) 
			VALUES (N'2nd Off / DPO', N'2nd Off / DPO', 3, NULL, 0, NULL, NULL, 1, @VesselId)

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
/****** Object:  StoredProcedure [dbo].[stpSaveShipTab]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSavetblEquipments]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  exec stpSavetblEquipments 'EquipmentsName', 'Comment' , 3

CREATE PROCEDURE [dbo].[stpSavetblEquipments]
(
	--@EquipmentsID int,
	@EquipmentsName varchar(500),
	@Comment varchar(500),
	@Quantity int
)
AS
BEGIN
	INSERT INTO tblEquipments(EquipmentsName,Comment,Quantity)
	VALUES (@EquipmentsName,@Comment,@Quantity)
END
GO
/****** Object:  StoredProcedure [dbo].[stpSavetblRegime]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec stpSavetblRegime '1','2018-06-01 00:00:00.000','9876543','5'

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
	Values(@RegimeID,@RegimeStartDate,1,@VesselID,NULL) 

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
/****** Object:  StoredProcedure [dbo].[stpSaveTimeAdjustment]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveWorkSessions]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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

@AdjustmentFator varchar(10),

@Day1Update bit,

@NCDetailsID int,

@isNonCompliant bit,

@VesselID int,

@RegimeID int

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

And FLOOR(CAST(ValidOn as float)) = FLOOR(CAST(@ValidOn as float))



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



INSERT INTO WorkSessions 

           (CrewID, ValidOn, [Hours], Increment, Comment, LatestUpdate, [Deleted],ActualHours,AdjustmentFator,VesselID,RegimeID)  

Values(@CrewID, @ValidOn, @Hours, @Increment, @Comment,GETDATE(), 1,@ActualHours,@AdjustmentFator,@VesselID,@RegimeID) 



SET @WrkSessionId = @@IDENTITY





INSERT INTO NCDetails(CrewID,OccuredOn,ComplianceInfo,TotalNCHours,WorkSessionId,isNC,VesselID)

VALUES(@CrewID,@OccuredOn,@ComplianceInfo,@TotalNCHours,@WrkSessionId,@isNonCompliant,@VesselID) 





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

		print 'h1'

		

		--INSERT AGAIN A NEW ROW

		IF @BookCount = 1

			BEGIN

				INSERT INTO WorkSessions 

				(CrewID, ValidOn, [Hours], Increment, Comment, LatestUpdate, [Deleted],ActualHours,AdjustmentFator,VesselID,RegimeID)  

				Values(@CrewID, @ValidOn, @Hours, @Increment, @Comment,GETDATE(), 1,@ActualHours,@AdjustmentFator,@VesselID,@RegimeID)

				

				SET @WrkSessionId = @@IDENTITY 





				INSERT INTO NCDetails(CrewID,OccuredOn,ComplianceInfo,TotalNCHours,WorkSessionId,VesselID)

				VALUES(@CrewID,@OccuredOn,@ComplianceInfo,@TotalNCHours,@WrkSessionId,@VesselID) 



			END

	END

ELSE IF (@LastMinuSOneAdjustmentDate IS NULL AND @Day1Update = 0 ) -- FIRST DAY2 SAVE CASE

	BEGIN

		

				print 'h2'

				

				INSERT INTO WorkSessions 

				(CrewID, ValidOn, [Hours], Increment, Comment, LatestUpdate, [Deleted],ActualHours,AdjustmentFator,VesselID,RegimeID)  

				Values(@CrewID, @ValidOn, @Hours, @Increment, @Comment,GETDATE(), 1,@ActualHours,@AdjustmentFator,@VesselID,@RegimeID) 



				SET @WrkSessionId = @@IDENTITY 





				INSERT INTO NCDetails(CrewID,OccuredOn,ComplianceInfo,TotalNCHours,WorkSessionId,VesselID)

				VALUES(@CrewID,@OccuredOn,@ComplianceInfo,@TotalNCHours,@WrkSessionId,@VesselID) 



			



	END

ELSE IF @Day1Update = 1

	BEGIN

			

			print 'h3'

			

			UPDATE WorkSessions

			SET CrewID=@CrewID, ValidOn=@ValidOn, [Hours]=@Hours, Increment=@Increment, Comment=@Comment,

				LatestUpdate=GETDATE(), Deleted=@Deleted, ActualHours=@ActualHours, AdjustmentFator=@AdjustmentFator, RegimeID=@RegimeID

			WHERE ID = @ID 

			

			--CrewID = @CrewID 

			--And FLOOR(CAST(ValidOn as float)) = FLOOR(CAST(@ValidOn as float))





			UPDATE NCDetails 

			SET ComplianceInfo = @ComplianceInfo,

			  TotalNCHours = @TotalNCHours 

			  WHERE NCDetailsID = @NCDetailsID

			  

			  --CrewID  =  @CrewID 

			  --AND  FLOOR(CAST(OccuredOn as float)) = FLOOR(CAST(@OccuredOn as float))

	END









COMMIT TRAN



END TRY

BEGIN CATCH

SELECT ERROR_MESSAGE() AS ErrorMessage

ROLLBACK TRAN

END CATCH



END

END










GO
/****** Object:  StoredProcedure [dbo].[stpUpdateCrewAdmin]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[stpUpdateCrewAdmin]
(
	@SelectedAdminId int,
	@SelectedCrewIds varchar(100),
	@VesselID int
)
AS
BEGIN

	DECLARE @CrewId int


	BEGIN TRY

	BEGIN TRAN

	UPDATE Crew SET DepartmentAdminId = NULL 
	WHERE DepartmentAdminId = @SelectedAdminId
	AND VesselID = @VesselID
	
	DECLARE crewcursor CURSOR FOR 
	SELECT String FROM ufn_CSVToTable(@SelectedCrewIds,',')

	OPEN crewcursor

	FETCH NEXT FROM crewcursor INTO @CrewId

	WHILE @@FETCH_STATUS = 0
	BEGIN

		UPDATE Crew SET DepartmentAdminId = @SelectedAdminId 
		WHERE ID = @CrewId
		AND VesselID = @VesselID

		FETCH NEXT FROM crewcursor INTO @CrewId
	END


	COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		PRINT ERROR_MESSAGE()
	END CATCH

END
GO
/****** Object:  StoredProcedure [dbo].[stpUpdateInActive]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
  SET IsActive= 0
WHERE ID= @ID AND IsActive = 1

End










GO
/****** Object:  StoredProcedure [dbo].[stpUpdateRanks]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpUpdateTimeEntry]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpUserAuthentication]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec stpUserAuthentication 'u52', 'u5'

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
/****** Object:  StoredProcedure [dbo].[usp_GetAllAdminCrewForDrp]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
End
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllCountryForDrp]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_GetAllCrewForDrp]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_GetAllCrewForDrp]
(

	@VesselID int

)
AS



Begin

Select ID, FirstName + '  ' +LastName AS Name, VesselID

from dbo.Crew
Where VesselID=@VesselID
End










GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllDepartmentForDrp]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_GetAllGroupsForDrp]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_GetAllRanksForDrp]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_GetAllShipForDrp]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_GetAllSpecialityForDrp]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_GetAllUserCrewForDrp]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_GetAllUsersForDrp]    Script Date: 12-Aug-18 10:24:23 PM ******/
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










GO
/****** Object:  StoredProcedure [dbo].[usp_GetDoctorBySpecialityID]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[ufn_CSVToTable]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  Table [dbo].[Consultation]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  Table [dbo].[CountryMaster]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CountryMaster](
	[CountryID] [int] IDENTITY(1,1) NOT NULL,
	[CountryName] [varchar](200) NOT NULL,
 CONSTRAINT [PK_CountryMaster] PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Crew]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
	[NWKHoursMayVary] [bit] NULL,
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
 CONSTRAINT [PK_dbo.Crew] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[VesselID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CrewRegimeTR]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  Table [dbo].[Customers]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  Table [dbo].[Demo]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Demo](
	[DemoID] [int] NOT NULL,
	[DemoName] [varchar](500) NOT NULL,
	[DemoDate] [datetime] NOT NULL,
	[IsDemo] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DepartmentAdmin]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  Table [dbo].[DepartmentMaster]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  Table [dbo].[DoctorMaster]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  Table [dbo].[FirstRun]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FirstRun](
	[RunCount] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GroupPermission]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  Table [dbo].[GroupRank]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  Table [dbo].[Groups]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Groups](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GroupName] [nvarchar](50) NOT NULL,
	[Timestamp] [timestamp] NOT NULL,
	[AllowDelete] [bit] NOT NULL,
	[VesselID] [int] NOT NULL,
 CONSTRAINT [PK_dbo.Groups] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[VesselID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MedicalAdvisory]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
 CONSTRAINT [PK_MedicalAdvisory] PRIMARY KEY CLUSTERED 
(
	[MedicalAdvisoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[NCDetails]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
 CONSTRAINT [PK_dbo.NCDetails] PRIMARY KEY CLUSTERED 
(
	[NCDetailsID] ASC,
	[VesselID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Permissions]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  Table [dbo].[Ranks]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
	[Deleted] [bit] NULL,
	[LatestUpdate] [datetime] NULL,
	[DefaultScheduleComments] [nvarchar](200) NULL,
	[Scheduled] [bit] NOT NULL,
	[VesselID] [int] NOT NULL,
 CONSTRAINT [PK_dbo.Ranks] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[VesselID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Regimes]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
	[UseHistCalculationOnly] [bit] NULL,
	[CheckOnlyWorkHours] [bit] NULL,
	[VesselID] [int] NULL,
 CONSTRAINT [PK_RegimeID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ServiceTerms]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
	[RankID] [int] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[VesselID] [int] NOT NULL,
 CONSTRAINT [PK_dbo.ServiceTerms] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[VesselID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Ship]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ship](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ShipName] [nvarchar](21) NOT NULL,
	[IMONumber] [int] NOT NULL,
	[FlagOfShip] [nvarchar](50) NOT NULL,
	[Regime] [int] NULL,
	[TimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_dbo.Ship] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[IMONumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SpecialityMaster]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  Table [dbo].[tblConfig]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblConfig](
	[KeyName] [varchar](20) NOT NULL,
	[ConfigValue] [varchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_tblConfig] PRIMARY KEY CLUSTERED 
(
	[KeyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblEquipments]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblEquipments](
	[EquipmentsID] [int] IDENTITY(1,1) NOT NULL,
	[EquipmentsName] [varchar](500) NOT NULL,
	[Comment] [varchar](500) NULL,
	[Quantity] [varchar](50) NOT NULL,
	[ExpiryDate] [varchar](50) NULL,
 CONSTRAINT [PK_tblEquipments] PRIMARY KEY CLUSTERED 
(
	[EquipmentsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblMedicine]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblMedicine](
	[MedicineID] [int] IDENTITY(1,1) NOT NULL,
	[MedicineName] [varchar](500) NOT NULL,
	[Quantity] [varchar](500) NOT NULL,
	[ExpiryDate] [varchar](50) NULL,
 CONSTRAINT [PK_Medicine] PRIMARY KEY CLUSTERED 
(
	[MedicineID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblRegime]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  Table [dbo].[TimeAdjustment]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  Table [dbo].[UserGroups]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  Table [dbo].[Users]    Script Date: 12-Aug-18 10:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](200) NOT NULL,
	[Password] [nvarchar](200) NOT NULL,
	[Active] [bit] NOT NULL,
	[Timestamp] [timestamp] NOT NULL,
	[AllowDelete] [bit] NOT NULL,
	[CrewId] [int] NULL,
	[VesselID] [int] NOT NULL,
 CONSTRAINT [PK_dbo.Users] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[VesselID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkSchedules]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
/****** Object:  Table [dbo].[WorkSessions]    Script Date: 12-Aug-18 10:24:23 PM ******/
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
	[Deleted] [bit] NOT NULL,
	[ActualHours] [nvarchar](200) NULL,
	[TimeAdjustment] [nvarchar](50) NULL,
	[AdjustmentFator] [varchar](10) NULL,
	[VesselID] [int] NOT NULL,
	[RegimeID] [int] NULL,
 CONSTRAINT [PK_dbo.WorkSessions] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[VesselID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[Consultation] ([DoctorID], [Problem]) VALUES (2, N'xyzzzzz')
INSERT [dbo].[Consultation] ([DoctorID], [Problem]) VALUES (8, N'ghjh')
SET IDENTITY_INSERT [dbo].[CountryMaster] ON 

INSERT [dbo].[CountryMaster] ([CountryID], [CountryName]) VALUES (1, N'India')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName]) VALUES (2, N'Bangladesh')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName]) VALUES (3, N'Pakistan')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName]) VALUES (4, N'China')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName]) VALUES (5, N'Sri Lanka')
SET IDENTITY_INSERT [dbo].[CountryMaster] OFF
SET IDENTITY_INSERT [dbo].[Crew] ON 

INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID]) VALUES (17, NULL, 0, N' ', NULL, CAST(0x0000A90500000000 AS DateTime), NULL, NULL, CAST(0x0000A8D300000000 AS DateTime), 1, N'1/2018', 0, 1047, N'Manoj', N'Kumar', CAST(0x0000A8F200000000 AS DateTime), N'Liberia', NULL, NULL, N'AS244', NULL, NULL, 9876543, NULL, 1)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID]) VALUES (18, NULL, 0, NULL, NULL, CAST(0x0000A8FF00000000 AS DateTime), NULL, NULL, CAST(0x0000A8F200000000 AS DateTime), 1, N'2/2018', 0, 1049, N'Yeshwant', N'Dessai', CAST(0x0000A8F200000000 AS DateTime), N'Liberia', NULL, NULL, N'XC23132', NULL, NULL, 9876543, NULL, 1)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID]) VALUES (19, NULL, 0, NULL, NULL, CAST(0x0000A90C00000000 AS DateTime), NULL, NULL, CAST(0x0000A8FF00000000 AS DateTime), 1, N'3/2018', 0, 1063, N'Olga', N'Olianova', CAST(0x0000A8F700000000 AS DateTime), N'Liberia', NULL, NULL, N'CV5445', NULL, NULL, 9876543, NULL, 1)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID]) VALUES (20, NULL, 0, NULL, NULL, CAST(0x0000A90D00000000 AS DateTime), NULL, NULL, CAST(0x0000A8F200000000 AS DateTime), 1, N'4/2018', 0, 1056, N'Musmadi', N'Musmadi', CAST(0x0000A8F300000000 AS DateTime), N'Liberia', NULL, NULL, N'XQ6464', NULL, NULL, 9876543, NULL, 1)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID]) VALUES (21, NULL, 0, NULL, NULL, CAST(0x0000A90600000000 AS DateTime), NULL, NULL, CAST(0x0000A8F700000000 AS DateTime), 1, N'5/2018', 0, 1056, N'Pius', N'Romadi', CAST(0x0000A8F300000000 AS DateTime), N'Liberia', NULL, NULL, N'ASS5656', NULL, NULL, 9876543, NULL, 1)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID]) VALUES (22, NULL, 0, NULL, NULL, CAST(0x0000A90C00000000 AS DateTime), NULL, NULL, CAST(0x0000A8F700000000 AS DateTime), 1, N'6/2018', 0, 1061, N'Kishan', N'Kumar', CAST(0x0000A8F700000000 AS DateTime), N'Liberia', NULL, NULL, N'KK7667', NULL, NULL, 9876543, NULL, 1)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID]) VALUES (23, NULL, 0, NULL, NULL, CAST(0x0000A90500000000 AS DateTime), NULL, NULL, CAST(0x0000A8F600000000 AS DateTime), 1, N'7/2018', 0, 1061, N'Haryadi', N'Haryadi', CAST(0x0000A8F600000000 AS DateTime), N'Liberia', NULL, NULL, N'XQ7667', NULL, NULL, 9876543, NULL, 1)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID]) VALUES (24, NULL, 0, NULL, NULL, CAST(0x0000A90500000000 AS DateTime), NULL, NULL, CAST(0x0000A8F600000000 AS DateTime), 1, N'8/2018', 0, 1050, N'Paras Pratap', N'Patil', CAST(0x0000A8F500000000 AS DateTime), N'Liberia', NULL, NULL, N'BQ7676', NULL, NULL, 9876543, NULL, 1)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID]) VALUES (25, NULL, 0, NULL, NULL, CAST(0x0000A90C00000000 AS DateTime), NULL, NULL, CAST(0x0000A8FE00000000 AS DateTime), 1, N'9/2018', 0, 1053, N'Hadi Siswoyo', N'Suko', CAST(0x0000A8F700000000 AS DateTime), N'Liberia', NULL, NULL, N'BQ7576', NULL, NULL, 9876543, NULL, 1)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID]) VALUES (26, NULL, 0, NULL, NULL, CAST(0x0000A90D00000000 AS DateTime), NULL, NULL, CAST(0x0000A8FE00000000 AS DateTime), 1, N'10/2018', 0, 1058, N'Keswanto', N'Heri', CAST(0x0000A8F200000000 AS DateTime), N'Liberia', NULL, NULL, N'BQ7576', NULL, NULL, 9876543, NULL, 1)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID]) VALUES (27, NULL, 0, NULL, NULL, CAST(0x0000A90D00000000 AS DateTime), NULL, NULL, CAST(0x0000A8F700000000 AS DateTime), 1, N'11/2018', 0, 1058, N'Sayuti', N'Supardi', CAST(0x0000A8F300000000 AS DateTime), N'Liberia', NULL, NULL, N'NQ888787', NULL, NULL, 9876543, NULL, 1)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID]) VALUES (28, NULL, 0, NULL, NULL, CAST(0x0000A90D00000000 AS DateTime), NULL, NULL, CAST(0x0000A8F700000000 AS DateTime), 1, N'12/2018', 0, 1059, N'Jana Avijit', N'Kumar', CAST(0x0000A8F300000000 AS DateTime), N'Liberia', NULL, NULL, N'SK65565', NULL, NULL, 9876543, NULL, 1)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID]) VALUES (29, NULL, 0, NULL, NULL, CAST(0x0000A90C00000000 AS DateTime), NULL, NULL, CAST(0x0000A8F700000000 AS DateTime), 1, N'13/2018', 0, 1062, N'John Welem', N'Mare', CAST(0x0000A8F300000000 AS DateTime), N'Liberia', NULL, NULL, N'MM798789', NULL, NULL, 9876543, NULL, 1)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID]) VALUES (30, NULL, 0, NULL, NULL, CAST(0x0000A90F00000000 AS DateTime), NULL, NULL, CAST(0x0000A8F700000000 AS DateTime), 1, N'14/2018', 0, 1060, N'Muhamad', N'Mulyadi', CAST(0x0000A8F600000000 AS DateTime), N'Liberia', NULL, NULL, N'BT7887', NULL, NULL, 9876543, NULL, 1)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID]) VALUES (32, NULL, 0, N'ddddd1', NULL, CAST(0x0000A92900000000 AS DateTime), NULL, NULL, CAST(0x0000A91200000000 AS DateTime), 1, N'15/2018', 0, 1060, N'dddd1', N'ddd1', CAST(0x0000A91400000000 AS DateTime), N'ddddd', NULL, NULL, N'111111', NULL, NULL, 9876543, 5, 1)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID]) VALUES (33, NULL, 0, N'ghgh', NULL, CAST(0x0000A92800000000 AS DateTime), NULL, NULL, CAST(0x0000A91A00000000 AS DateTime), 0, N'16/2018', 0, 1058, N'ghghgh', N'ghgh', CAST(0x0000A91B00000000 AS DateTime), N'hghghg', NULL, NULL, N'ghgh', N'ghghgh', NULL, 9876543, 5, 1)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID]) VALUES (35, NULL, 0, N'rtrrr', NULL, CAST(0x0000A92E00000000 AS DateTime), NULL, NULL, CAST(0x0000A91A00000000 AS DateTime), 0, N'17/2018', 0, 1059, N'rtrtr', N'rrtr', CAST(0x0000A91A00000000 AS DateTime), N'trtrt', NULL, NULL, N'k', NULL, NULL, 9876543, 5, 1)
SET IDENTITY_INSERT [dbo].[Crew] OFF
SET IDENTITY_INSERT [dbo].[DepartmentAdmin] ON 

INSERT [dbo].[DepartmentAdmin] ([DepartmentAdminID], [DepartmentMasterID], [CrewID], [IsActive], [PositionEndDate], [IsAdmin], [VesselID], [ReportsTo]) VALUES (11, 5, 17, 1, NULL, 1, 9876543, NULL)
INSERT [dbo].[DepartmentAdmin] ([DepartmentAdminID], [DepartmentMasterID], [CrewID], [IsActive], [PositionEndDate], [IsAdmin], [VesselID], [ReportsTo]) VALUES (12, 5, 21, 1, NULL, 1, 9876543, NULL)
INSERT [dbo].[DepartmentAdmin] ([DepartmentAdminID], [DepartmentMasterID], [CrewID], [IsActive], [PositionEndDate], [IsAdmin], [VesselID], [ReportsTo]) VALUES (1032, 1015, 17, 1, NULL, 1, 9876543, NULL)
INSERT [dbo].[DepartmentAdmin] ([DepartmentAdminID], [DepartmentMasterID], [CrewID], [IsActive], [PositionEndDate], [IsAdmin], [VesselID], [ReportsTo]) VALUES (1033, 1015, 23, 1, NULL, 1, 9876543, NULL)
SET IDENTITY_INSERT [dbo].[DepartmentAdmin] OFF
SET IDENTITY_INSERT [dbo].[DepartmentMaster] ON 

INSERT [dbo].[DepartmentMaster] ([DepartmentMasterID], [DepartmentMasterName], [DepartmentMasterCode], [IsActive], [VesselID]) VALUES (5, N'Engine Room', N'DC1', 1, 9876543)
INSERT [dbo].[DepartmentMaster] ([DepartmentMasterID], [DepartmentMasterName], [DepartmentMasterCode], [IsActive], [VesselID]) VALUES (1015, N'DS12', N'DC12', 1, 9876543)
SET IDENTITY_INSERT [dbo].[DepartmentMaster] OFF
SET IDENTITY_INSERT [dbo].[DoctorMaster] ON 

INSERT [dbo].[DoctorMaster] ([DoctorID], [DoctorName], [DoctorEmail], [SpecialityID], [Comment]) VALUES (2, N'Abir Ray', N'abr@gmail.com', 1, N'xyz1')
INSERT [dbo].[DoctorMaster] ([DoctorID], [DoctorName], [DoctorEmail], [SpecialityID], [Comment]) VALUES (8, N'PranabPaul', N'prp@gmail.com', 2, N'zyx2')
INSERT [dbo].[DoctorMaster] ([DoctorID], [DoctorName], [DoctorEmail], [SpecialityID], [Comment]) VALUES (2004, N'ddnnn', N'ee@@gmail.com', 1, N'ccooomm')
SET IDENTITY_INSERT [dbo].[DoctorMaster] OFF
INSERT [dbo].[FirstRun] ([RunCount]) VALUES (1)
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
SET IDENTITY_INSERT [dbo].[MedicalAdvisory] ON 

INSERT [dbo].[MedicalAdvisory] ([MedicalAdvisoryID], [Weight], [BMI], [BP], [BloodSugarLevel], [UrineTest], [CrewID], [Height], [Age], [BloodSugarUnit], [BloodSugarTestType], [Systolic], [Diastolic]) VALUES (1008, N'65', N'6.94', NULL, N'120', 1, 0, N'306', N'46', N'mmol/L', N'2', N'160', N'200')
INSERT [dbo].[MedicalAdvisory] ([MedicalAdvisoryID], [Weight], [BMI], [BP], [BloodSugarLevel], [UrineTest], [CrewID], [Height], [Age], [BloodSugarUnit], [BloodSugarTestType], [Systolic], [Diastolic]) VALUES (1009, N'55', N'5.05', NULL, N'100', 1, 0, N'330', N'29', N'mmol/L', N'3', N'80', N'90')
SET IDENTITY_INSERT [dbo].[MedicalAdvisory] OFF
SET IDENTITY_INSERT [dbo].[NCDetails] ON 

INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (4, 17, CAST(0x0000A8F200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>19.5</minsevendaysrest><mintwentyfourhoursrest>19.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>14</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>4.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 4, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (5, 17, CAST(0x0000A8F300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>38.5</minsevendaysrest><mintwentyfourhoursrest>20.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>15</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 5, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (6, 17, CAST(0x0000A8F400000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>59.5</minsevendaysrest><mintwentyfourhoursrest>19</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>16</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>3</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 6, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (7, 17, CAST(0x0000A8F500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>82</minsevendaysrest><mintwentyfourhoursrest>20.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>17</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>1.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 7, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (8, 17, CAST(0x0000A8F600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>102.5</minsevendaysrest><mintwentyfourhoursrest>22.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>0</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>3.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 8, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (9, 17, CAST(0x0000A8F700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>122</minsevendaysrest><mintwentyfourhoursrest>23</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>1</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>4.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 9, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (10, 17, CAST(0x0000A8F800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus>Less than 10 hrs of rest in 24 hrs period</twentyfourhourresthoursstatus><minsevendaysrest>129</minsevendaysrest><mintwentyfourhoursrest>7</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>3</maxrestperiodintewntyfourhours><maxnrofrestperiod>4</maxnrofrestperiod><totalworkedhours>17</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 10, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (11, 18, CAST(0x0000A8F800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>15</minsevendaysrest><mintwentyfourhoursrest>15</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>9</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>9</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 11, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (12, 18, CAST(0x0000A8F600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>17.5</minsevendaysrest><mintwentyfourhoursrest>17.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>5</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>6.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 12, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (16, 17, CAST(0x0000A8EF00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>17.5</minsevendaysrest><mintwentyfourhoursrest>17.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>5</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>6.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 13, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (17, 17, CAST(0x0000A8FE00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus>Less than 10 hrs of rest in 24 hrs period</twentyfourhourresthoursstatus><minsevendaysrest>33.5</minsevendaysrest><mintwentyfourhoursrest>7</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>3</maxrestperiodintewntyfourhours><maxnrofrestperiod>4</maxnrofrestperiod><totalworkedhours>17</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 14, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (18, 18, CAST(0x0000A90600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>11.5</minsevendaysrest><mintwentyfourhoursrest>11.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>7</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>12.5</totalworkedhours><overtimeHours>2.5</overtimeHours></ncdetails>', 0, 15, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (19, 18, CAST(0x0000A90A00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>26.5</minsevendaysrest><mintwentyfourhoursrest>22.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>19</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>9</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 16, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (20, 18, CAST(0x0000A90A00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>22.5</minsevendaysrest><mintwentyfourhoursrest>12.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>5</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>13</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 17, NULL, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (21, 17, CAST(0x0000A91000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>23</minsevendaysrest><mintwentyfourhoursrest>23</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>22</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>1</totalworkedhours><overtimeHours>1</overtimeHours></ncdetails>', 0, 18, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (22, 17, CAST(0x0000A92600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>23</minsevendaysrest><mintwentyfourhoursrest>23</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>22</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>1</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 19, 0, 9876543)
SET IDENTITY_INSERT [dbo].[NCDetails] OFF
SET IDENTITY_INSERT [dbo].[Ranks] ON 

INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1047, N'Master / SDPO', N'Master / SDPO', 1, NULL, 0, NULL, NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1048, N'Chief Off / SDPO', N'Chief Off / SDPO', 5, NULL, 0, NULL, NULL, 0, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1049, N'2nd Off / DPO', N'2nd Off / DPO', 2, NULL, 0, NULL, NULL, 0, 9876543)
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
SET IDENTITY_INSERT [dbo].[ServiceTerms] ON 

INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (17, CAST(0x0000A8D300000000 AS DateTime), CAST(0x0000A90500000000 AS DateTime), 17, NULL, NULL, 1047, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (18, CAST(0x0000A8F200000000 AS DateTime), CAST(0x0000A8FF00000000 AS DateTime), 18, NULL, NULL, 1049, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (19, CAST(0x0000A8FF00000000 AS DateTime), CAST(0x0000A90C00000000 AS DateTime), 19, NULL, NULL, 1063, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (20, CAST(0x0000A8F200000000 AS DateTime), CAST(0x0000A90D00000000 AS DateTime), 20, NULL, NULL, 1056, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (21, CAST(0x0000A8F700000000 AS DateTime), CAST(0x0000A90600000000 AS DateTime), 21, NULL, NULL, 1056, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (22, CAST(0x0000A8F700000000 AS DateTime), CAST(0x0000A90C00000000 AS DateTime), 22, NULL, NULL, 1061, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (23, CAST(0x0000A8F600000000 AS DateTime), CAST(0x0000A90500000000 AS DateTime), 23, NULL, NULL, 1061, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (24, CAST(0x0000A8F600000000 AS DateTime), CAST(0x0000A90500000000 AS DateTime), 24, NULL, NULL, 1050, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (25, CAST(0x0000A8FE00000000 AS DateTime), CAST(0x0000A90C00000000 AS DateTime), 25, NULL, NULL, 1053, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (26, CAST(0x0000A8FE00000000 AS DateTime), CAST(0x0000A90D00000000 AS DateTime), 26, NULL, NULL, 1058, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (27, CAST(0x0000A8F700000000 AS DateTime), CAST(0x0000A90D00000000 AS DateTime), 27, NULL, NULL, 1058, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (28, CAST(0x0000A8F700000000 AS DateTime), CAST(0x0000A90D00000000 AS DateTime), 28, NULL, NULL, 1059, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (29, CAST(0x0000A8F700000000 AS DateTime), CAST(0x0000A90C00000000 AS DateTime), 29, NULL, NULL, 1062, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (30, CAST(0x0000A8F700000000 AS DateTime), CAST(0x0000A90F00000000 AS DateTime), 30, NULL, NULL, 1060, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (32, CAST(0x0000A91200000000 AS DateTime), CAST(0x0000A92900000000 AS DateTime), 32, NULL, NULL, 1061, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (33, CAST(0x0000A91A00000000 AS DateTime), CAST(0x0000A92800000000 AS DateTime), 33, NULL, NULL, 1058, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (35, CAST(0x0000A91A00000000 AS DateTime), CAST(0x0000A92E00000000 AS DateTime), 35, NULL, NULL, 1059, 0, 9876543)
SET IDENTITY_INSERT [dbo].[ServiceTerms] OFF
SET IDENTITY_INSERT [dbo].[Ship] ON 

INSERT [dbo].[Ship] ([ID], [ShipName], [IMONumber], [FlagOfShip], [Regime]) VALUES (3014, N'INS Vikramaditya', 9876543, N'India', 1)
SET IDENTITY_INSERT [dbo].[Ship] OFF
SET IDENTITY_INSERT [dbo].[SpecialityMaster] ON 

INSERT [dbo].[SpecialityMaster] ([SpecialityID], [SpecialityName]) VALUES (1, N'Anesthesiologists')
INSERT [dbo].[SpecialityMaster] ([SpecialityID], [SpecialityName]) VALUES (2, N'Cardiologists ')
INSERT [dbo].[SpecialityMaster] ([SpecialityID], [SpecialityName]) VALUES (3, N'Dermatologists ')
INSERT [dbo].[SpecialityMaster] ([SpecialityID], [SpecialityName]) VALUES (4, N'Endocrinologists ')
INSERT [dbo].[SpecialityMaster] ([SpecialityID], [SpecialityName]) VALUES (5, N'Gastroenterologists ')
INSERT [dbo].[SpecialityMaster] ([SpecialityID], [SpecialityName]) VALUES (6, N'Hematologists ')
INSERT [dbo].[SpecialityMaster] ([SpecialityID], [SpecialityName]) VALUES (7, N'Neurologists ')
INSERT [dbo].[SpecialityMaster] ([SpecialityID], [SpecialityName]) VALUES (8, N'Oncologists ')
INSERT [dbo].[SpecialityMaster] ([SpecialityID], [SpecialityName]) VALUES (9, N'Osteopaths ')
INSERT [dbo].[SpecialityMaster] ([SpecialityID], [SpecialityName]) VALUES (10, N'Plastic Surgeons')
SET IDENTITY_INSERT [dbo].[SpecialityMaster] OFF
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'frompwd', N'Resthours@2018', 1)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'mailfrom', N'tmresthours@gmail.com', 1)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'mailto', N'prasenjitpaul100@hotmail.com', 1)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'port', N'587', 1)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'smtp', N'smtp.gmail.com', 1)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'subject', N'Zip File', 1)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'zipoutputsize', N'1000', 1)
SET IDENTITY_INSERT [dbo].[tblEquipments] ON 

INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (7, N'A Das', N'ok', N'3', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (8, N'D Sen', NULL, N'9', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (9, N'BASIN EMESIS KIDNEY SHAPE', NULL, N'1 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (10, N'BAISIN WASH WITH RIM', NULL, N'1 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (11, N'BEDPAN PVC', NULL, N'1 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (12, N'URINAL MALE', NULL, N'1 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (13, N'CRUTCHADJUSTABLE WOOD WITH RUBBER TIP', NULL, N'1 PAIR', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (14, N'EYE CUP', NULL, N'2 SET', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (15, N'FUNNEL PLASTIC 12CM', NULL, N'1 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (16, N'GLASS CYLINDER 50ML', NULL, N'1 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (17, N'GLASS CYLINDER 500ML', NULL, N'1 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (18, N'HEATING PAD ELECTRIC AC/DC', NULL, N'1 PKT', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (19, N'HOT WATER BAG', NULL, N'1 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (20, N'LITTER STOCKET', NULL, N'1 SET', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (21, N'MAGNIFYING GLASS 8 LOUPE', NULL, N'1 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (22, N'NEIL ROBERTSON STRETCHER', NULL, N'1 SET', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (23, N'REFRIGERATOR AUTOMATIC', NULL, N'2 SET', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (24, N'CUFFS', NULL, N'1 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (25, N'MUMMY RESTRAINT', NULL, N'1 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (26, N'SIDE BOARD', NULL, N'2 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (27, N'RESUSCITATOR HAND OPERATED', NULL, N'1 SET', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (28, N'RUBBER INFLATABLE RING PAD', NULL, N'1 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (29, N'SCALES ADULT WEIGHING 150KG', NULL, N'1 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (30, N'SPHYGMOMANMETER ANAROID', NULL, N'1 SET', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (31, N'SPLINTS ARM FOR ABOVE/BELOW 6''S', NULL, N'1 SET', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (32, N'SPLINTS LEG FOR ABOVE/BELOW KNEE 6''S', NULL, N'1 SET', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (33, N'SPLINTS FINGER 6''S', NULL, N'1 SET', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (34, N'STERILIZER STEAM PRESSURE TYPE', NULL, N'1 SET', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (35, N'STERILIZER WATER TYPE ELECTRIC', NULL, N'1 SET', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (36, N'STETHOSCOPE DISC DIPHRAM TYPE', NULL, N'1 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (37, N'THERMOMETER BATH', NULL, N'2 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (38, N'TRAY WITH COVER', NULL, N'2 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (39, N'URINAL MALE', NULL, N'2 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (40, N'RECEPTACLE 12L WITH PEDAL OPERATED', NULL, N'1 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (41, N'MEDICAL FIRST AID GUIDE', NULL, N'1 VOL', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (42, N'INT HEALTH REGULATION', NULL, N'1 VOL', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (43, N'VACCINATION CERTIFICATE', NULL, N'1 VOL', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (44, N'AIRWAY PHARYGEL PLASTIC 2''S', NULL, N'2 SET', N'2021-09-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (45, N'BLADE SUGICAL KNIFE', NULL, N'10 PC', N'2019-04-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (46, N'BLADE SUGICAL KNIFE 11', NULL, N'10 PC', N'2019-10-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (47, N'FORCEPS DRESSING BAYONET 18CM', NULL, N'1 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (48, N'FORCEPS HAEMOSTAT CURVED', NULL, N'2 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (49, N'FORCEPS HAEMOSTAT SPENCER WELLS', NULL, N'2 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (50, N'FORCEPS HAEMOSTAT CURVED KELLY', NULL, N'2 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (51, N'FORCEPS SPLINTER TWEEZERS', NULL, N'1 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (52, N'FORCEPS TISSUE 13CM', NULL, N'1 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (53, N'FORCEPS TISSUE 18CM', NULL, N'1 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (54, N'HANDLE KNIFE NO 3', NULL, N'2 PC', N'2019-11-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (55, N'SCISSORS BANDAGE 20CM', NULL, N'3 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (56, N'SCISSORS SURGICAL 15CM', NULL, N'2 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (57, N'HAMMER REFLEX TESTING 20CM', NULL, N'1 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (58, N'NEEDLE HOLDER 14CM', NULL, N'2 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (59, N'ADHESIVE TAPE SUGICAL 5CM X 5M', NULL, N'6 PKT', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (60, N'ADHESIVE TAPE SUGICAL 2CM X 5M', NULL, N'6 PKT', N'2019-06-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (61, N'ADMINSTRATION SET', NULL, N'6 PKT', N'2018-12-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (62, N'APPLICATOR WOOD 2MM X 15 CM, 40''S', NULL, N'4 PKT', N'2019-02-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (63, N'BANDAGE ELASTIC COTTON 12''S 10CM X 5M', NULL, N'1 BOX', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (64, N'BANDAGE ELASTIC COTTON 8CM X 5M', NULL, N'1 BOX', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (65, N'BANDAGE ELASTIC COTTON 5CM X 5M', NULL, N'0 BOX', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (66, N'BANDAGE GAUZE 7.5 X 9M, 12 ROLLS-PLY SAFETY PIN', NULL, N'1 PKT', N'2019-05-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (67, N'BANDAGE COTTON ADHESIVE PLASTER 2.5 X 3.3 M 100''', NULL, N'1 BOX', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (68, N'BANDAGE GAUZE ROLLER 10 X 5.4M', NULL, N'60 ROLL', N'2019-12-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (69, N'BANDAGE GAUZE ROLLER 7.5 X 5.4M', NULL, N'40 ROLL', N'2019-05-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (70, N'CASUALITY DRESSING ADHESIVE 9 X 6CM', NULL, N'30 PC', N'2019-02-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (71, N'CASUALITY DRESSING ADHESIVE 18 X 9CM', NULL, N'20 PC', N'2019-02-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (72, N'BANDAGE TRINGULAR 90 X 130CM', NULL, N'4 PC', N'2019-05-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (73, N'TUBE GUAGE TYPE BANDAGEFOR FINGERS', NULL, N'10 PKT', N'2019-05-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (74, N'SPRAY DRESSING 50ML', NULL, N'4 TIN', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (75, N'PETROLATUM GUAZE', NULL, N'20 PKT', N'2019-03-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (76, N'FIRST AID EMERGENCY DRESSING', NULL, N'10 PKT', N'2019-05-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (77, N'FIRST AID EMERGENCY DRESSING NO .14', NULL, N'20 PKT', N'2019-07-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (78, N'FIRST AID EMERGENCY DRESSING NO.15', NULL, N'20 PKT', N'2019-05-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (79, N'PLASTIC BOTTEL 50 ML', NULL, N'50 BTL', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (80, N'CATHETER DOUBLE EYE POINTED AND FRENCH', NULL, N'1 PC', N'2020-02-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (81, N'CATHETER DOUBLE EYE POINTED AND FRENCH 8 FRENCH', NULL, N'1 PC', N'2020-02-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (82, N'CATHETER DOUBLE EYE POINTED AND FRENCH 12 FRENCH', NULL, N'1 PC', N'2020-02-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (83, N'CATHETER DOUBLE EYE POINTED AND FRENCH 14 FRENCH', NULL, N'1 PC', N'2019-11-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (84, N'CATHETER DOUBLE EYE POINTED AND FRENCH 16 FRENCH', NULL, N'1 PC', N'2019-10-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (85, N'CATHETERIZATION TRAY REGULAR TYPE SET', NULL, N'3 SET', N'2019-01-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (86, N'CLINICAL RECORD CHART', NULL, N'50 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (87, N'TEMP RECORD CHART', NULL, N'50 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (88, N'MEDICAL REPORT FORM', NULL, N'100 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (89, N'CLINICAL RECORD CHART', NULL, N'1 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (90, N'COLLAR CERVICAL WITH SRTAP', NULL, N'1 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (91, N'COTTON ABSORBENT 100G', NULL, N'3 PKT', N'2020-04-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (92, N'COTTON ABSRBENT 50G', NULL, N'20 PKT', N'2020-04-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (93, N'COTTON ABSRBENT 450G', NULL, N'10 PKT', N'2020-04-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (94, N'FINGER COTS RUBBER 12.S', NULL, N'1 PKT', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (95, N'FLASH LIGHT PENLIGHT', NULL, N'1 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (96, N'TUBULAR GAUZE BANDAGE 2CM X 5M', NULL, N'5 PKT', N'2019-05-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (97, N'GLOVE SURGICAL', NULL, N'12 PAIR', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (98, N'GOWNS SURGICAL', NULL, N'5 SET', N'2018-11-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (99, N'MASK FACE DISPOSABLE', NULL, N'50 PC', N'2019-05-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (100, N'MEDICINE CUP 30ML DISPOSABLE', NULL, N'100 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (101, N'MICROSCOPE SLID 100S', NULL, N'1 PKT', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (102, N'MORUTARY TRANSFER BAG', NULL, N'2 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (103, N'NEEDLE HYPODERMIC 12.S', NULL, N'3 PKT', N'2019-12-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (104, N'NEEDEL INTRAMUSCOLAR 12.S', NULL, N'2 PKT', N'2020-01-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (105, N'NEEDEL INTRAVENOUS 12.S', NULL, N'1 PKT', N'2019-03-01T00:00:00+05:30')
GO
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (106, N'OCCULT BLOOD DETECTION PAPER 50.S', NULL, N'1 PKT', N'2019-02-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (107, N'PAD ABDOMINAL 20CM X 20CM', NULL, N'6 PC', N'2019-05-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (108, N'PAD COTTON EYE 10.S', NULL, N'1 PKT', N'2020-10-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (109, N'PAD NON ABSORBENT 8 X 10CM', NULL, N'100 PC', N'2019-05-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (110, N'SAFETY PIN RUSTLESS 100.S', NULL, N'100 PKT', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (111, N'SCRUBBING BRUSH HAND', NULL, N'2 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (112, N'CONDOM 10S', NULL, N'10 PKT', N'2020-02-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (113, N'SHEET WATERPROOF  110CM X 180CM', NULL, N'2 PKT', N'2021-12-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (114, N'SKIN CLOSURE SURGICAL 6MM', NULL, N'25 PC', N'2019-11-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (115, N'SKIT CLOSURE STERILE 10CM X 8CM', NULL, N'10 PC', N'2020-05-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (116, N'SUTURE TAPERED 28MM 12S', NULL, N'1 PKT', N'2020-01-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (117, N'SUTURE ARMED 12MM 12S', NULL, N'2 PKT', N'2020-01-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (118, N'SUTURE ARMED 13MM', NULL, N'1 PKT', N'2019-07-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (119, N'SUTURE ARMED CATGUT 12S', NULL, N'1 PKT', N'2019-07-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (120, N'SUTURE REMOVAL KIT', NULL, N'1 SET', N'2019-04-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (121, N'SYRINGE GLASS 2ML', NULL, N'4 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (122, N'SYRINGE GLASS 5ML', NULL, N'4 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (123, N'SYRINGE GLASS 20ML', NULL, N'2 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (124, N'SYRINGEHYPODERMIC PLASTIC DISPOSABLE 2ML', NULL, N'50 SET', N'2019-12-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (125, N'SYRINGE INTRAMUSCULAR 2ML', NULL, N'50 SET', N'2019-12-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (126, N'SYRINGE GLASS 5ML', NULL, N'30 SET', N'2019-12-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (127, N'TEST STRIP COMBTEST 100S', NULL, N'1 PKT', N'2020-05-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (128, N'TEST TABLE GLUCOSE IN URINE 50S', NULL, N'2 PKT', N'2019-04-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (129, N'TISSUE FACIAL', NULL, N'6 BOX', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (130, N'THERMOMETER CLINICAL FEVER', NULL, N'6 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (131, N'TOURNIQUET 3', NULL, N'1 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (132, N'TONGUE DEPRESSOR WOODEN 100S', NULL, N'1 PKT', N'2018-11-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (133, N'TOWEL PAPER 100PC', NULL, N'2 PKT', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (134, N'TOWELS SURGICAL COTTON 12S', NULL, N'2 PKT', N'2019-03-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (135, N'WARPPING MATERIAL 20S', NULL, N'1 PKT', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (136, N'PARAFINE GAUGE DRESSING 10X10CM STERILE', NULL, N'20 PCS', N'2019-05-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (137, N'ELASTIC FIXATION BANDAGE 4MX6CM', NULL, N'9 PCS', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (138, N'APLICATOR FOR FIBGER BANDAGE', NULL, N'1 PCS', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (139, N'ADHESIVE ELASTIC BANDAGE 4MX6CM', NULL, N'10 PCS', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (140, N'HONEY FOR DRESSING BURNS 1KG', NULL, N'2 PCS', N'2020-03-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (141, N'Q TIPS WOODEN', NULL, N'100 PCS', N'2019-02-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (142, N'BUTTERFLY SUTURES STERISTRIP', NULL, N'50 PCS', N'2019-11-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (143, N'2-OCTYL CYANOACRYLATE LIQUID 0.5ML', NULL, N'1 PCS', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (144, N'DISPOSABLE EXAMINATION GLOVES M', NULL, N'100 PCS', N'2019-06-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (145, N'DISPOSABLE EXAMINATION GLOVES L', NULL, N'100 PCS', N'2019-04-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (146, N'HAEMOSTATIC CLAMP HALSTEAD MOSQUITO 125MM', NULL, N'2 PCS', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (147, N'RAZOR DISPOSABLE', NULL, N'5 PCS', N'2019-04-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (148, N'TOUNGE DEPRESORS DISPOSABLE', NULL, N'100 PCS', N'2018-11-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (149, N'THERMOMETER', NULL, N'1 PCS', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (150, N'SYRINGES LUER CONNECTION 10ML, STERILE DISPOSABLE', NULL, N'20 PCS', N'2019-09-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (151, N'NEEDLES 19G', NULL, N'40 PCS', N'2019-03-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (152, N'INTRAVENOUS INFUSION CANNULA 16G', NULL, N'30 PCS', N'2018-10-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (153, N'INTRAVENOUS INFUSION CANNULA 22G', NULL, N'30 PCS', N'2018-12-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (154, N'INTRAVENOUS GIVING SET, LUER LOCK CONNECTION, STERILE + 3 WAY V/V CONNECTION', NULL, N'10 PCS', N'2018-12-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (155, N'URINE COLLECTION BAG', NULL, N'2 PCS', N'2019-01-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (156, N'PLASTIC GOOGLES', NULL, N'1 PCS', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (157, N'DISPOSABLE PLASTIC APRON', NULL, N'10 PCS', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (158, N'KIDENY DISH, STAINLESS STEEL 825ML', NULL, N'2 PCS', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (159, N'MASK DUCKBIL TYPE DISPOSABLE', NULL, N'50 PCS', N'2019-05-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (160, N'TAPE MEASURING , VINYL COATED1.5M', NULL, N'1 PCS', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (161, N'COLD HOT PACK', NULL, N'4 PCS', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (162, N'ALUMINIUM FOIL BLANCKET', NULL, N'1 PCS', N'2019-12-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (163, N'MALE CONDOMS', NULL, N'200 PCS', N'2020-02-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (164, N'PLASTIC WASH BOTTLE 250ML', NULL, N'1 PCS', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (165, N'BOTTEL, 1L PLASTIC WITH SCREW TOP', NULL, N'1 PCS', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (166, N'BOWL STAINLESS STEEL 180ML', NULL, N'1 PCS', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (167, N'ALCOHOL SWBS', NULL, N'100 PCS', N'2022-04-01T00:00:00+05:30')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate]) VALUES (168, N'NAIL BRUSH', NULL, N'1 PCS', NULL)
SET IDENTITY_INSERT [dbo].[tblEquipments] OFF
SET IDENTITY_INSERT [dbo].[tblMedicine] ON 

INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1004, N'ASPIRIN 500MG , 100TAB', N'6 PKT', N'2018-12-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1005, N'ACICOLOVIR 400 MG TAB', N'70 PCS', N'2020-01-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1006, N'EPHEDRINE, 100TAB - MASTER', N'1 PKT', N'2018-12-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1007, N'ERYTHROMYCINE 250MG, 100CAP', N'3 PKT', N'2019-09-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1008, N'ARTEMETHER AMP 1ML , 80 MG', N'5 PCS', N'2020-08-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1009, N'ARTEMETHER + LUMEFANTRINE TAB 20 MG + 120 MG', N'48 PCS', N'2019-09-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1010, N'ATROPINE INJ 1ML/10 AMP - MASTER', N'6 PKT', N'2019-08-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1011, N'AMINOTHYLINE 100 TAB', N'1 PKT', N'2019-02-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1012, N'CEFTRIAXONE AMP 1 G POWDER FOR INJ', N'45 PCS', N'2019-02-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1013, N'CETRIZINE', N'180 TAB', N'2020-05-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1014, N'CHARCOAL ACTIVATED 120G POWDER', N'1 PKT', N'2019-01-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1015, N'CIPROFLOXACIN TAB 250 MG', N'0', N'2019-11-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1016, N'CLOVE OIL 3ML', N'8 BTL', N'2019-01-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1017, N'CLOVE OIL 3ML', N'3 BTL', N'2020-03-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1018, N'EPINEPHRINE INJ 1:1000, 10AMP - MASTER', N'2 PKT', N'2018-11-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1019, N'DECADROM , ( Tetracycline HCL tab)', N'120 PCS', N'2019-06-15T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1020, N'DIAZEPAM, 100TAB - (Chlorpromazine HCL tab) MASTER', N'400 TAB', N'2019-01-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1021, N'DUCUSATE WITH SENNA TAB', N'100 PCS', N'2019-12-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1022, N'TETRACYCLINE 250MG , 100 CAP', N'3 PKT', N'2018-11-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1023, N'ETHANOL 70 % GEL, 500 ML', N'6 BTL', N'2020-11-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1024, N'DISINFECTANT SOL FOR MEDICAL INSTRUMENTS 1000ML', N'1 PCS', N'2019-01-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1025, N'FLUORESCEIN SODIUM EYE STRIP, 100S', N'1 PKT', N'2019-02-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1026, N'FUROSEMIDE 40MG, 100TAB', N'1 PKT', N'2019-03-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1027, N'GLUCAGON AMP 1 MG', N'1 PCS', N'2019-03-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1028, N'CHLORPHENAMINE INJ, 20 AMP - MASTER', N'1 PKT', N'2019-01-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1029, N'HYDROCORTISONE OINT 10G', N'4 TUB', N'2018-12-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1030, N'HYDROCORTISONE OINT 15G', N'6 TUB', N'2019-11-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1031, N'IBUPROFEN 400 MG', N'300 TAB', N'2020-08-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1032, N'ISOSORBIDE DINITRATE TAB 5MG SUBLINGULA - MASTER', N'100 PCS', N'2019-05-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1033, N'LIDOCAINE INJ AMP', N'12 BTL', N'2018-12-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1034, N'LIDOCANE HCL 2%', N'10 AMP', N'2019-06-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1035, N'LIDOCAINE CREAM 25G', N'1 BTL', N'2020-04-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1036, N'IMODIUM , LOPERIMIDE-WSM', N'38 PCS', N'2021-06-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1037, N'METOPROLOL 100 MG', N'60 PCS', N'2020-02-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1038, N'METRONIDAZOLE 250MG, 100TAB', N'5 BTL', N'2020-01-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1039, N'MICONAZOLE VAGINAL CREAM 20G', N'1 TUB', N'2019-08-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1040, N'PESSARIES CONTAINING POVIDONE IODINE 200 MG', N'6 PCS', N'2019-11-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1041, N'MICONAZOLE PESSARY 100MG, 6TAB', N'4 PKT', N'2019-04-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1042, N'MIDAZOLAM AMP 1 ML (25 MG) - MASTER', N'10 PCS', N'2020-04-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1043, N'MISOPROSTOL 100 TAB', N'3 PCS', N'2019-11-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1044, N'ORS 27G', N'50 PKT', N'2019-02-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1045, N'ORS', N'100 PCS', N'2019-02-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1046, N'OXYMETAZOLINE 0.5 %', N'6 PCS', N'2019-03-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1047, N'MORPHINE SULFATE 10 AMP - MASTER', N'2 PKT', N'2019-01-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1048, N'MORPHINE INJ AMP 1 ML = 50 MG - MASTER', N'30 PCS', N'2019-01-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1049, N'MORPHINE ORAL LIQUID 1 MG / 100 ML - MASTER', N'1 PCS', N'2019-12-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1050, N'NALOXONE INJ 1ML, 05AMP - MASTER', N'1 PKT', N'2018-10-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1051, N'OMEPRAZOLE TAB 20 MG', N'50 PCS', N'2019-03-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1052, N'CYCLIZINE, 100TAB', N'4 BTL', N'2018-09-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1053, N'PARACETAMOL 500MG, 100TAB', N'200 TAB', N'2019-09-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1054, N'PARACETAMOL 500MG', N'350 TAB', N'2022-09-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1055, N'PERMETHRIN 1 % LOTION 250 ML', N'2 PCS', N'2019-05-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1056, N'PERMETHRIN 5 % LOTION 250 ML', N'2 PCS', N'2020-07-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1057, N'NEOMYCIN AND BACTRIACIN OINT 20G', N'26 TUB', N'2020-06-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1058, N'IODINE 2.5% SOLUTION 100ML', N'4 BTL', N'2019-05-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1059, N'POVIDINE IODINE SOL 10 % 30 ML TO 100 ML', N'4 PCS', N'2019-06-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1060, N'PREDNISINE TAB 5 MG', N'36 PCS', N'2020-02-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1061, N'PREDBISOLONE 5 MG', N'40 TAB', N'2022-09-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1062, N'SALBUTAMOL INHAILER 200 DOSE - MASTER', N'4 TIN', N'2019-04-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1063, N'SODIUM CHLORIDE 0.9% 1000ML INJ', N'6 BTL', N'2019-02-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1064, N'SODIUM CHLORIDE 0.9 % INFUSION PLASTIC BOTTEL 1 LTR', N'2 PCS', N'2019-02-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1065, N'SODIUM CHLORID 0.9 % INFUSION PLASTIC BOTTEL 10 ML', N'2 PCS', N'2019-02-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1066, N'EYE ANAESTHETIC DROP 8ML', N'2 BTL', N'2019-05-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1067, N'EYE ANTIINFECTIVE  DROP 8ML', N'2BTL', N'2019-04-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1068, N'TETRACYCLINE EAR DROP 50 ML', N'09 BTL', N'2019-01-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1069, N'AMETHOMICAINE EYE DROP, 0.5%, SINGLE USE VIAL - 1ML', N'12 PCS', N'2022-02-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1070, N'EYE OINT. TETRACYCLINE 2G', N'6 PCS', N'2022-02-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1071, N'TETRACYCLINE 1% EYE OINT 2G', N'1 PCS', N'2022-02-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1072, N'TETRACYCLINE 1% EYE OINT 5G', N'6 PCS', N'2020-04-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1073, N'VITAMIK K AMP 1ML = 10MG', N'2 PCS', N'2019-01-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1074, N'WATER STERILE FOR INJ 5 ML/50 AMP', N'1 PKT', N'2020-04-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1075, N'ZIDOVUDINE PLUS LAMIVUDINE TAB, 300 MG + 150 MG', N'60 PCS', N'2019-01-01T00:00:00+05:30')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate]) VALUES (1076, N'ZINC OXIDE PASTE 30 G', N'12 TUB', N'2020-03-01T00:00:00+05:30')
SET IDENTITY_INSERT [dbo].[tblMedicine] OFF
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 0, 9876543, CAST(0x0000A92600000000 AS DateTime))
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 0, 9876543, CAST(0x0000A92600000000 AS DateTime))
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 0, 9876543, CAST(0x0000A92600000000 AS DateTime))
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 0, 9876543, CAST(0x0000A92600000000 AS DateTime))
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 0, 9876543, CAST(0x0000A92600000000 AS DateTime))
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 0, 9876543, CAST(0x0000A92600000000 AS DateTime))
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 0, 9876543, CAST(0x0000A92600000000 AS DateTime))
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 0, 9876543, CAST(0x0000A92600000000 AS DateTime))
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 0, 9876543, CAST(0x0000A92600000000 AS DateTime))
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 0, 9876543, CAST(0x0000A92600000000 AS DateTime))
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 0, 9876543, CAST(0x0000A92600000000 AS DateTime))
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 0, 9876543, CAST(0x0000A92600000000 AS DateTime))
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 0, 9876543, CAST(0x0000A92600000000 AS DateTime))
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 0, 9876543, CAST(0x0000A92600000000 AS DateTime))
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 0, 9876543, CAST(0x0000A92600000000 AS DateTime))
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 0, 9876543, CAST(0x0000A92600000000 AS DateTime))
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 0, 9876543, CAST(0x0000A92600000000 AS DateTime))
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 0, 9876543, CAST(0x0000A92600000000 AS DateTime))
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 0, 9876543, CAST(0x0000A92600000000 AS DateTime))
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 0, 9876543, CAST(0x0000A92600000000 AS DateTime))
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 0, 9876543, CAST(0x0000A92600000000 AS DateTime))
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 0, 9876543, CAST(0x0000A92600000000 AS DateTime))
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 0, 9876543, CAST(0x0000A92600000000 AS DateTime))
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 0, 9876543, CAST(0x0000A92600000000 AS DateTime))
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 0, 9876543, CAST(0x0000A92600000000 AS DateTime))
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 0, 9876543, CAST(0x0000A92600000000 AS DateTime))
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 0, 9876543, CAST(0x0000A92600000000 AS DateTime))
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 0, 9876543, CAST(0x0000A92600000000 AS DateTime))
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 0, 9876543, CAST(0x0000A92600000000 AS DateTime))
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 1, 9876543, NULL)
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (0, CAST(0x0000A92600000000 AS DateTime), 0, 9876543, CAST(0x0000A92600000000 AS DateTime))
SET IDENTITY_INSERT [dbo].[TimeAdjustment] ON 

INSERT [dbo].[TimeAdjustment] ([AdjustmentDate], [AdjustmentValue], [VesselID], [TimeAdjustmentID]) VALUES (CAST(0x0000A90600000000 AS DateTime), N'+1', 9876543, 1)
INSERT [dbo].[TimeAdjustment] ([AdjustmentDate], [AdjustmentValue], [VesselID], [TimeAdjustmentID]) VALUES (CAST(0x0000A90700000000 AS DateTime), N'+30', 9876543, 1001)
INSERT [dbo].[TimeAdjustment] ([AdjustmentDate], [AdjustmentValue], [VesselID], [TimeAdjustmentID]) VALUES (CAST(0x0000A90800000000 AS DateTime), N'-1', 9876543, 1002)
INSERT [dbo].[TimeAdjustment] ([AdjustmentDate], [AdjustmentValue], [VesselID], [TimeAdjustmentID]) VALUES (CAST(0x0000A90900000000 AS DateTime), N'-30', 9876543, 1003)
INSERT [dbo].[TimeAdjustment] ([AdjustmentDate], [AdjustmentValue], [VesselID], [TimeAdjustmentID]) VALUES (CAST(0x0000A90A00000000 AS DateTime), N'-1D', 9876543, 1004)
INSERT [dbo].[TimeAdjustment] ([AdjustmentDate], [AdjustmentValue], [VesselID], [TimeAdjustmentID]) VALUES (CAST(0x0000A90B00000000 AS DateTime), N'+1D', 9876543, 1005)
SET IDENTITY_INSERT [dbo].[TimeAdjustment] OFF
SET IDENTITY_INSERT [dbo].[UserGroups] ON 

INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (47, 42, 13, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (1045, 1040, 14, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (1046, 1041, 15, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (1047, 1042, 15, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (1048, 1043, 15, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (1049, 1044, 14, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (1050, 1045, 15, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (1051, 1046, 14, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (1052, 1047, 15, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (1053, 1048, 15, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (1054, 1049, 15, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (1055, 1050, 15, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (1056, 1051, 15, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (1057, 1052, 15, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (1058, 1053, 15, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (1059, 1054, 15, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (2059, 2054, 15, 9876543)
SET IDENTITY_INSERT [dbo].[UserGroups] OFF
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (42, N'sa', N'12345', 1, 1, NULL, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (1040, N'ManKum67', N'12345', 1, 1, 17, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (1041, N'YesDes82', N'12345', 1, 1, 18, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (1042, N'OlgOli66', N'12345', 1, 1, 19, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (1043, N'MusMus20', N'12345', 1, 1, 20, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (1044, N'PiuRom2', N'12345', 1, 1, 21, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (1045, N'KisKum35', N'12345', 1, 1, 22, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (1046, N'HarHar25', N'12345', 1, 1, 23, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (1047, N'ParPat12', N'12345', 1, 1, 24, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (1048, N'HadSuk55', N'12345', 1, 1, 25, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (1049, N'KesHer30', N'12345', 1, 1, 26, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (1050, N'SaySup86', N'12345', 1, 1, 27, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (1051, N'JanKum80', N'12345', 1, 1, 28, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (1052, N'JohMar96', N'12345', 1, 1, 29, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (1053, N'MuhMul45', N'12345', 1, 1, 30, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (1054, N'dddddd97', N'12345', 1, 1, 32, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (2054, N'rtrrrt71', N'12345', 1, 1, 35, 9876543)
SET IDENTITY_INSERT [dbo].[Users] OFF
SET IDENTITY_INSERT [dbo].[WorkSessions] ON 

INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (4, 17, CAST(0x0000A8F200000000 AS DateTime), N'111001111100000000100000000000000000000000000000', 0, N'', CAST(0x0000A8F801802D22 AS DateTime), 1, N'0000,0130,0230,0500,0900,0930', NULL, N'', 9876543, 1)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (5, 17, CAST(0x0000A8F300000000 AS DateTime), N'001100111100001111000000000000000000000000000000', 0, N'', CAST(0x0000A8F80180873D AS DateTime), 1, N'0100,0200,0300,0500,0700,0900', NULL, N'', 9876543, 1)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (6, 17, CAST(0x0000A8F400000000 AS DateTime), N'001100001100110000000000000000000000000000000000', 0, N'', CAST(0x0000A8F8018134AD AS DateTime), 1, N'0100,0200,0400,0500,0600,0700', NULL, N'', 9876543, 1)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (7, 17, CAST(0x0000A8F500000000 AS DateTime), N'101100000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A8F8018171CE AS DateTime), 1, N'0000,0030,0100,0200', NULL, N'', 9876543, 1)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (8, 17, CAST(0x0000A8F600000000 AS DateTime), N'111101110000000000000000000000000000000000000000', 0, N'', CAST(0x0000A8F801818C96 AS DateTime), 1, N'0000,0200,0230,0400', NULL, N'', 9876543, 1)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (9, 17, CAST(0x0000A8F700000000 AS DateTime), N'000000110100111111000000000000000000000000000000', 0, N'', CAST(0x0000A8F80181B83E AS DateTime), 1, N'0300,0400,0430,0500,0600,0900', NULL, N'', 9876543, 1)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (10, 17, CAST(0x0000A8F800000000 AS DateTime), N'001111000011111111111100000011111111111111110110', 0, N'', CAST(0x0000A90901603DEE AS DateTime), 1, N'0100,0300,1400,2200,2230,2330,0500,1100', NULL, N'', 9876543, 1)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (11, 18, CAST(0x0000A8F800000000 AS DateTime), N'000000000000111111111111111111000000000000000000', 0, N'', CAST(0x0000A8F900DB76F0 AS DateTime), 1, N'0600,1500', NULL, N'', 9876543, 1)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (12, 18, CAST(0x0000A8F600000000 AS DateTime), N'000000000000000000000000111111111111100000000000', 0, N'', CAST(0x0000A8F900DB971A AS DateTime), 1, N'1200,1830', NULL, N'', 9876543, 1)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (13, 17, CAST(0x0000A8EF00000000 AS DateTime), N'000000000000000000000000111111111111100000000000', 0, N'', CAST(0x0000A8F900DB971A AS DateTime), 1, N'1200,1830', NULL, N'', 9876543, 1)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (14, 17, CAST(0x0000A8FE00000000 AS DateTime), N'001111000011111111111100000011111111111111110110', 0, N'', CAST(0x0000A9090168D46C AS DateTime), 1, N'0100,0300,1400,2200,2230,2330,0500,1100', NULL, N'', 9876543, 1)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (15, 18, CAST(0x0000A90600000000 AS DateTime), N'001111111111111111111111100000001100000000000000', 0, N'', CAST(0x0000A90B00A11BFE AS DateTime), 1, N'0100,1230,1600,1700', NULL, N'+1', 9876543, 1)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (16, 18, CAST(0x0000A90A00000000 AS DateTime), N'000000000000000000000000111111111111111111000000', 0, N'', CAST(0x0000A90C0175E2F4 AS DateTime), 1, N'1200,2100', NULL, N'-1D', 9876543, 1)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (17, 18, CAST(0x0000A90A00000000 AS DateTime), N'000011111111111000111111111111000000000111000000', 0, N'', CAST(0x0000A90D009206A5 AS DateTime), 1, N'0200,0730,0900,1500,1930,2100', NULL, N'-1D', 9876543, 1)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (18, 17, CAST(0x0000A91000000000 AS DateTime), N'001100000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A91C014481F6 AS DateTime), 1, N'0100,0200', NULL, N'0', 9876543, 1)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (19, 17, CAST(0x0000A92600000000 AS DateTime), N'001100000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A92601243190 AS DateTime), 1, N'0100,0200', NULL, N'0', 9876543, 1)
SET IDENTITY_INSERT [dbo].[WorkSessions] OFF
SET ANSI_PADDING ON

GO
/****** Object:  Index [UK_RegimeName]    Script Date: 12-Aug-18 10:24:23 PM ******/
ALTER TABLE [dbo].[Regimes] ADD  CONSTRAINT [UK_RegimeName] UNIQUE NONCLUSTERED 
(
	[RegimeName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Ship]    Script Date: 12-Aug-18 10:24:23 PM ******/
ALTER TABLE [dbo].[Ship] ADD  CONSTRAINT [IX_Ship] UNIQUE NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Crew] ADD  CONSTRAINT [DF_Crew_NWKHoursMayVary]  DEFAULT ((0)) FOR [NWKHoursMayVary]
GO
ALTER TABLE [dbo].[Groups] ADD  CONSTRAINT [DF_Groups_AllowDelete]  DEFAULT ((1)) FOR [AllowDelete]
GO
ALTER TABLE [dbo].[Ranks] ADD  CONSTRAINT [DF_Ranks_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[Ranks] ADD  CONSTRAINT [DF_Ranks_Scheduled]  DEFAULT ((1)) FOR [Scheduled]
GO
ALTER TABLE [dbo].[Regimes] ADD  CONSTRAINT [DF_Regimes_UseHistCalculationOnly]  DEFAULT ((0)) FOR [UseHistCalculationOnly]
GO
ALTER TABLE [dbo].[Regimes] ADD  CONSTRAINT [DF_Regimes_CheckOnlyWorkHours]  DEFAULT ((1)) FOR [CheckOnlyWorkHours]
GO
ALTER TABLE [dbo].[ServiceTerms] ADD  CONSTRAINT [DF_ServiceTerms_RankID]  DEFAULT ((0)) FOR [RankID]
GO
ALTER TABLE [dbo].[ServiceTerms] ADD  CONSTRAINT [DF_ServiceTerms_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_AllowDelete]  DEFAULT ((1)) FOR [AllowDelete]
GO
ALTER TABLE [dbo].[WorkSchedules] ADD  CONSTRAINT [DF_WorkSchedules_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[WorkSessions] ADD  CONSTRAINT [DF_WorkSessions_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[DoctorMaster]  WITH CHECK ADD  CONSTRAINT [FK_DoctorMaster_SpecialityMaster] FOREIGN KEY([SpecialityID])
REFERENCES [dbo].[SpecialityMaster] ([SpecialityID])
GO
ALTER TABLE [dbo].[DoctorMaster] CHECK CONSTRAINT [FK_DoctorMaster_SpecialityMaster]
GO
