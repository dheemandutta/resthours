USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpAddTempRanks]    Script Date: 03-Dec-18 6:13:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpAddTempRanks]
(
	@RankName varchar(50)
)
AS
BEGIN

	BEGIN TRY

		BEGIN TRAN

			DECLARE @MAXoRDER INT
			DECLARE @NewRankId int

			SET @NewRankId = 0
			SELECT @MAXoRDER =  MAX([Order]) FROM Ranks
			SET @MAXoRDER = @MAXoRDER + 1

			insert into ranks(RankName,Description,[Order],Deleted,LatestUpdate,VesselID)
			values (@RankName,@RankName,@MAXoRDER,0,getdate(),9876543)

			SET @NewRankId = @@IDENTITY

			insert into GroupRank(GroupID,RankID,VesselID)
			VALUES(13,@NewRankId,9876543)

			insert into GroupRank(GroupID,RankID,VesselID)
			VALUES(14,@NewRankId,9876543)

			insert into GroupRank(GroupID,RankID,VesselID)
			VALUES(15,@NewRankId,9876543)


		COMMIT TRAN

	END TRY
	begin catch
		
		rollback tran
		

	end catch

END



GO
/****** Object:  StoredProcedure [dbo].[stpAddUsers]    Script Date: 03-Dec-18 6:13:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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




















GO
/****** Object:  StoredProcedure [dbo].[stpCheckIfValidRegime]    Script Date: 03-Dec-18 6:13:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec stpCheckIfValidRegime
CREATE PROCEDURE [dbo].[stpCheckIfValidRegime]
AS
BEGIN

	SELECT COUNT(*) FROM tblRegime WHERE IsActiveRegime=1 
	AND CONVERT(varchar(10),RegimeEndDate,101) >= CONVERT(varchar(10),GETDATE(),101)
	AND CONVERT(varchar(10),RegimeStartDate,101) <= CONVERT(varchar(10),GETDATE(),101)

END	


GO
/****** Object:  StoredProcedure [dbo].[stpCheckIfWorkedBeforeOneDays]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpCheckIfWorkedBeforeSevenDays]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpCheckUserIdAvailibility]    Script Date: 03-Dec-18 6:13:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [dbo].[stpDeleteDepartment]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpDeleteShipDetails]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpDetleteRanks]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportCrew]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportCrewRegimeTR]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportDepartmentAdmin]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportDepartmentMaster]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportFirstRun]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportGroupRank]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportGroups]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportNCDetails]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportRanks]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportRegimes]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportServiceTerms]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportShip]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExporttblRegime]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportTimeAdjustment]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportUserGroups]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportUsers]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpExportWorkSessions]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetAllCrewByCrewID]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetAllCrewForAssign]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetAllCrewServiceTerms]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetAllRanks]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetAllRegimes]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetAllShipDetails]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetAlltblConfig]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetAllUsersForDrp]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetChildNodes]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetCompanyDetailsByID]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetCompanyDetailsNew]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetCrewByID]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
Select  DOB,FirstName + ' ' + LastName As Name
FROM Crew
WHERE ID= @ID
End








GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewByRankID]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetCrewByUserID]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetCrewDetailsForHealthByID]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetCrewDetailsForHealthByIDNew]    Script Date: 03-Dec-18 6:13:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  Exec stpGetCrewDetailsForHealthByIDNew 18
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

INNER JOIN Ranks R

ON R.ID = C.RankID

INNER JOIN ServiceTerms ST

ON ST.CrewID = C.ID



WHERE C.ID= @LoggedInUserId
End










GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewDetailsForHealthByIDNew2]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetCrewDetailsPageWise]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetCrewIDFromWorkSessions]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
		  AdjustmentFactor varchar(10),
		  VesselID int,
		  RegimeSymbol char(1),    ----------deep
		  SevenDaysRest varchar(10),
		  IsWithinFiveDays bit

		)



		INSERT INTO @TimeTab(ID,Hours,BookDate,FirstName,LastName,RankName,WorkDate,ComplianceInfo,TotalNCHours,Comment,AdjustmentFactor,VesselID,RegimeSymbol,IsWithinFiveDays)

		SELECT WS.ID,Hours,DAY(ValidOn) AS BookDate,C.FirstName,C.LastName,R.RankName,ISNULL(CONVERT(varchar(12),ValidOn,103), '') AS WorkDate,ComplianceInfo,TotalNCHours,WS.Comment,AdjustmentFator As AdjustmentFactor, WS.VesselID,
				
			CASE RegimeName
				WHEN 'IMO STCW' THEN              '~'
				WHEN 'ILO Rest (Flexible)' THEN '@'
				WHEN 'ILO Work' THEN '#'
				WHEN 'Customised' THEN '$'
				WHEN 'ILO Rest' THEN '^'
				WHEN 'IMO STCW 2010' THEN '&'
				WHEN 'OCIMF' THEN '*'
		END As RegimeSymbol,0

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
/****** Object:  StoredProcedure [dbo].[stpGetCrewListingForInactivPageWise]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetCrewListingPageWise]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
	 ,ISNULL(REPLACE(REPLACE(CONVERT(varchar(12),CreatedOn,dbo.ufunc_GetDateFormat()), ' ','/'), ',',''), '/') StartDate

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
/****** Object:  StoredProcedure [dbo].[stpGetCrewOverTime]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetCrewOvertimeValue]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetCrewPageWise]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetCrewReportList]    Script Date: 03-Dec-18 6:13:32 PM ******/
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

--GROUP BY Name,RankName,CreatedOn,C.LatestUpdate

	

     

      SELECT @RecordCount = COUNT(*)

      FROM #Results

           

      SELECT * FROM #Results

      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

     AND VesselID=@VesselID

      DROP TABLE #Results

END









GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewReportListPageWise]    Script Date: 03-Dec-18 6:13:32 PM ******/
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

--GROUP BY Name,RankName,CreatedOn,C.LatestUpdate

	

     

      SELECT @RecordCount = COUNT(*)

      FROM #Results

           

      SELECT * FROM #Results

      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

     AND VesselID=@VesselID

      DROP TABLE #Results

END










GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewReportListPageWise2]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetDataForVarianceReport]    Script Date: 03-Dec-18 6:13:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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
			AdjustmentFactor varchar(10),
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
/****** Object:  StoredProcedure [dbo].[stpGetDayWiseCrewBookingData]    Script Date: 03-Dec-18 6:13:32 PM ******/
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

ORDER BY CrewID



END











GO
/****** Object:  StoredProcedure [dbo].[stpGetDepartmentByID]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetDepartmentByIDForAssignAdmin]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetDepartmentByIDForAssignCrew]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetDepartmentPageWise]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetDoctorEmailByID]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetEquipmentsPageWise]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetFirstFiveDays]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetFirstLastNameByUserId]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetFirstRun]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetFleetMasterPageWise]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetIsActiveRegime]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetLastAdjustmentBookedStatus]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetLastSevenDaysWorkSchedule]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
		

		


		 --SET @ChangedBookDate = dateadd(day,-1 ,@ChangedBookDate)

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
/****** Object:  StoredProcedure [dbo].[stpGetLastSevenDaysWorkScheduleForComplianceCheck]    Script Date: 03-Dec-18 6:13:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec stpGetLastSevenDaysWorkScheduleForComplianceCheck 4,'11/07/2018',9876543,6

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
		 

		 SET @ZeroSchedule = '000000000000000000000000000000000000000000000000'
		 SET @NullSchedule = '999999999999999999999999999999999999999999999999'
		 SET @ChangedBookDate = @BookDate 
		 SET @isFilled = 0
		

		IF @NumDays = 7
		BEGIN

		 --SET @ChangedBookDate = dateadd(day,-1 ,@ChangedBookDate)

		 print @ChangedBookDate

		 WHILE (DATEDIFF(day,@BookDate, @ChangedBookDate) >= -6)
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

				SET @ChangedBookDate = dateadd(day,-6 ,@ChangedBookDate)
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
/****** Object:  StoredProcedure [dbo].[stpGetLastSixDaysWorkSchedule]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetMedicalAdvisoryPageWise]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
      where CrewID=@LoggedInUserId
      SELECT @RecordCount = COUNT(*)
      FROM #Results
      SELECT * FROM #Results
      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1
      DROP TABLE #Results
END










GO
/****** Object:  StoredProcedure [dbo].[stpGetMedicinePageWise]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetMinusOneDayAdjustmentDays]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetNCForMonth]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetNextSixDaysTimeSheet]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetNoNCForMonth]    Script Date: 03-Dec-18 6:13:32 PM ******/
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

	SELECT DAY(NC.OccuredOn) As NcDay, NC.VesselID
	FROM NCDetails NC
	INNER JOIN WorkSessions WS
	ON NC.WorkSessionId = WS.ID
	WHERE NC.CrewID = @CrewId
	AND MONTH(OccuredOn) = @Month
	AND YEAR(OccuredOn) = @Year

	AND NC.VesselID=@VesselID
	AND WS.ActualHours <> '0000,0000,0000,0000,0000,0000'
	AND NC.isNC=0
	ORDER BY DAY(OccuredOn) ASC
	


END



















GO
/****** Object:  StoredProcedure [dbo].[stpGetNonComplianceByCrewId]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetNonComplianceInfo]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetParentNodes]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetPlusOneDayAdjustmentDays]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetPreviousBlankDates]    Script Date: 03-Dec-18 6:13:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec stpGetPreviousBlankDates 19,'11/01/2018',9876543
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


--print @MinDate

DECLARE @TempTab TABLE
(
	Dt VARCHAR(10)
)
DECLARE @Counter int 
SET @Counter = -14
WHILE @MinDate < @MaxDate
BEGIN

	INSERT INTO @TempTab(Dt) VALUES (CONVERT(varchar,@MinDate,101))

	SET @Counter =  @Counter +1 
	SET @MinDate = DATEADD(day,@Counter,@BookDate)
	

END

--SELECT CONVERT(DATE,ValidOn,110) FROM WorkSessions 
-- WHERE CONVERT(DATE,ValidOn,112) IN (SELECT Dt FROM @TempTab) 
-- AND CrewID = @CrewId

 --SELECT * FROM @TempTab


DELETE FROM @TempTab
WHERE Dt IN ( SELECT CONVERT(varchar,ValidOn,101) FROM WorkSessions 
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



---*************************************************

SELECT Dt AS BlankDate FROM @TempTab

END








GO
/****** Object:  StoredProcedure [dbo].[stpGetRankFromGroup]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetRanksByID]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetRanksPageWise]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetRegimeById]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetServiceTermsListPageWise]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetShipDetailsByID]    Script Date: 03-Dec-18 6:13:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[stpGetShipDetailsByID]
AS
Begin
Select  ID,ShipName,RIGHT('000000'+CAST(IMONumber AS VARCHAR(7)),7) AS IMONumber,FlagOfShip,Regime,RIGHT('000000'+CAST(IMONumber AS VARCHAR(7)),7) AS IMONumber
FROM dbo.Ship

	  

--WHERE ID= @ID

End























GO
/****** Object:  StoredProcedure [dbo].[stpGetShipDetailsPageWise]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetShipMaster]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetTimeAdjustment]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetTimeAdjustmentDetailsPageWise]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetUserDetailsByCrewID]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetUserGroupsByUserID]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetUsersDetailsPageWise]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetWorkingHours]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetWorkSessionsByValidOn]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetWrokSessionsByCrewandDate]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetWrokSessionsByDate]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
	ORDER BY NCD.CrewID,WS.Timestamp DESC



END





















GO
/****** Object:  StoredProcedure [dbo].[stpImportCrew]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
	@Gender varchar(20)
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


   INSERT INTO Crew(Watchkeeper,Notes,Deleted,LatestUpdate,CreatedOn,OvertimeEnabled,EmployeeNumber,RankID,FirstName,MiddleName,LastName,DOB,POB,PassportSeamanPassportBook,Seaman,IsActive,VesselID,CountryID,DeactivationDate,DeletionDate,Gender)
   VALUES(@WatchKeeper,@notes,0,getdate(),getdate(),@Overtime,@EmployeeNum,@RankId,@FirstName,@MiddleName,@LastName,@DOB,@POB,@PassportBook,@Seaman,1,@VesselId,@CountryID,'9999-12-31 00:00:00.000','9999-12-31 00:00:00.000',@Gender)

   COMMIT TRAN

END TRY
BEGIN CATCH
	ROLLBACK TRAN
END CATCH
END
END




GO
/****** Object:  StoredProcedure [dbo].[stpImportCrewRegimeTR]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpImportDepartmentAdmin]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpImportDepartmentMaster]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpImportFirstRun]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpImportGroupRank]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpImportGroups]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpImportNCDetails]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpImportRank]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpImportRegimes]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpImportServiceTerms]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpImportShip]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpImportUserGroups]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpImportUsers]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpImportWorkSessions]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpInsertEquipmentStock]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpInsertMedicineStock]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpLastBookedSession]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpResetPassword]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveCIRM]    Script Date: 03-Dec-18 6:13:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  exec stpSaveCIRM .......................

CREATE PROCEDURE [dbo].[stpSaveCIRM]
(
  @CIRMId int,
  @NameOfVessel varchar(50),
  @RadioCallSign varchar(50),
  @PortofDestination varchar(50),
  @Route varchar(50),
  @LocationOfShip varchar(50),
  @PortofDeparture varchar(50),
  @EstimatedTimeOfarrivalhrs varchar(50),
  @Speed varchar(50),
  @Nationality varchar(50),
  @Qualification varchar(50),
  @RespiratoryRate varchar(50),
  @Pulse varchar(50),
  @Temperature varchar(50),
  @Systolic varchar(50),
  @Diastolic varchar(50),
  @Symptomatology varchar(50),
  @LocationAndTypeOfPain varchar(50),
  @RelevantInformationForDesease varchar(50),
  @WhereAndHowAccidentIsCausedCHK bit,
  @UploadMedicalHistory varchar(500),
  @UploadMedicinesAvailable varchar(500),
  @MedicalProductsAdministered varchar(500),
  @WhereAndHowAccidentIsausedARA varchar(500)
)

AS
BEGIN

 IF @CIRMId IS NULL

BEGIN 
	INSERT INTO CIRM(NameOfVessel,RadioCallSign,PortofDestination,[Route],LocationOfShip,PortofDeparture,EstimatedTimeOfarrivalhrs,Speed,
	                 Nationality,Qualification,RespiratoryRate,Pulse,Temperature,Systolic,Diastolic,Symptomatology,
					 LocationAndTypeOfPain,RelevantInformationForDesease,WhereAndHowAccidentIsCausedCHK,UploadMedicalHistory,
					 UploadMedicinesAvailable,MedicalProductsAdministered,WhereAndHowAccidentIsausedARA)

	VALUES (@NameOfVessel,@RadioCallSign,@PortofDestination,@Route,@LocationOfShip,@PortofDeparture,@EstimatedTimeOfarrivalhrs,@Speed,
	        @Nationality,@Qualification,@RespiratoryRate,@Pulse,@Temperature,@Systolic,@Diastolic,@Symptomatology,
		    @LocationAndTypeOfPain,@RelevantInformationForDesease,@WhereAndHowAccidentIsCausedCHK,@UploadMedicalHistory,
		    @UploadMedicinesAvailable,@MedicalProductsAdministered,@WhereAndHowAccidentIsausedARA)
END

END








GO
/****** Object:  StoredProcedure [dbo].[stpSaveCompanyDetails]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveConfigData]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
@MailPassword varchar(100)
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
--Insert into tblConfig (KeyName,ConfigValue,IsActive) Values ('outputsize',@AttachmentSize,1)
Commit Tran
End Try
Begin Catch
Rollback Tran
Print error_message()
End Catch
End










GO
/****** Object:  StoredProcedure [dbo].[stpSaveConsultation]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveCrew]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
           (FirstName,MiddleName,LastName,Gender,RankID,CreatedOn,LatestUpdate,CountryID,DOB,POB,PassportSeamanPassportBook,Seaman,Notes,Watchkeeper,OvertimeEnabled,EmployeeNumber,VesselID,DepartmentMasterID,DeactivationDate,DeletionDate)  
Values(@FirstName,@MiddleName,@LastName,@Gender,@RankID,@CreatedOn,@ActiveTo,@CountryID,@DOB,@POB,@PassportSeamanPassportBook,@Seaman,@Notes,@Watchkeeper,@OvertimeEnabled,@EmployeeNum,@VesselID,@DepartmentMasterID,'12/31/9999','12/31/9999') 
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
/****** Object:  StoredProcedure [dbo].[stpSaveDepartment]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveDepartmentMaster]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveDoctorMaster]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveGroups]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveInitialShipValues]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
@AdminPassword varchar(50)

--@VesselID int
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
Insert into Ship ([ShipName],FlagOfShip,IMONumber)
 Values(@Vessel,@Flag,@IMO)

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




UPDATE GroupRank
SET VesselID=@IMO
--Where ID=@ID

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
/****** Object:  StoredProcedure [dbo].[stpSaveMedicalAdvisory]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
				UnannouncedAlcohol,AnnualDH,[Month],CrewName,PulseRatebpm,AnyDietaryRestrictions,MedicalProductsAdministered,UploadExistingPrescriptions,UploadUrineReport)
	VALUES  (@Weight,@BMI,@BloodSugarLevel,@UrineTest,
	 @Height,@Age,@BloodSugarUnit,@BloodSugarTestType,@Systolic,@Diastolic,@LoggedInUserId,
	@UnannouncedAlcohol,@AnnualDH,@Month,@CrewName,@PulseRatebpm,@AnyDietaryRestrictions,@MedicalProductsAdministered,@UploadExistingPrescriptions,@UploadUrineReport)
END










GO
/****** Object:  StoredProcedure [dbo].[stpSaveMedicine]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveNewShipDetails]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveRankGroups]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveRanks]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveRanksForXmlProject]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveRegimes]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveServiceTerms]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveShipDetails]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveShipTab]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSavetblEquipments]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSavetblRegime]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveTimeAdjustment]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveWorkSessions]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
@RegimeID int,
@WorkSessionId int OUTPUT,
@NewNCDetailsId int OUTPUT

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

			INSERT INTO NCDetails(CrewID,OccuredOn,ComplianceInfo,TotalNCHours,WorkSessionId,isNC,VesselID)
			VALUES(@CrewID,@OccuredOn,@ComplianceInfo,@TotalNCHours,@WrkSessionId,@isNonCompliant,@VesselID) 

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


								INSERT INTO NCDetails(CrewID,OccuredOn,ComplianceInfo,TotalNCHours,WorkSessionId,VesselID,isNC)
								VALUES(@CrewID,@OccuredOn,@ComplianceInfo,@TotalNCHours,@WrkSessionId,@VesselID,@isNonCompliant) 

								SET @NewNCDetailsId = @@IDENTITY
							END

				END 
				ELSE IF (@LastMinuSOneAdjustmentDate IS NULL AND @Day1Update = 0 ) -- FIRST DAY2 SAVE CASE
				BEGIN

						INSERT INTO WorkSessions(CrewID, ValidOn, [Hours], Increment, Comment, LatestUpdate, [Deleted],ActualHours,AdjustmentFator,VesselID,RegimeID)  
						Values(@CrewID, @ValidOn, @Hours, @Increment, @Comment,GETDATE(), 1,@ActualHours,@AdjustmentFator,@VesselID,@RegimeID) 

						SET @WrkSessionId = @@IDENTITY 

						INSERT INTO NCDetails(CrewID,OccuredOn,ComplianceInfo,TotalNCHours,WorkSessionId,VesselID,isNC)
						VALUES(@CrewID,@OccuredOn,@ComplianceInfo,@TotalNCHours,@WrkSessionId,@VesselID,@isNonCompliant) 

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
										 isNC = @isNonCompliant 
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
/****** Object:  StoredProcedure [dbo].[stpUpdateInActive]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpUpdateRanks]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpUpdateTimeEntry]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpUpdateVessel]    Script Date: 03-Dec-18 6:13:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpUpdateVessel]
(
	@ShipName varchar(21),
	@FlagOfShip varchar(50),
	@IMONumber int
) 
AS
BEGIN

	UPDATE Ship SET ShipName = @ShipName , FlagOfShip = @FlagOfShip WHERE IMONumber = @IMONumber

END








GO
/****** Object:  StoredProcedure [dbo].[stpUserAuthentication]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpValidateFirstRun]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_GetAllAdminCrewForDrp]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_GetAllCountryForDrp]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_GetAllCrewForDrp]    Script Date: 03-Dec-18 6:13:32 PM ******/
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

Union 

Select ID, FirstName + '  ' +LastName AS Name, C.VesselID
from dbo.Crew C
Left Outer Join DepartmentAdmin DA
ON C.ID = DA.CrewID
Where C.VesselID= @VesselID 
And C.DepartmentMasterID IN (Select DepartmentMasterID From DepartmentAdmin Where CrewID = (Select CrewID From Users Where ID = @UserID))
  AND Deletiondate >= GetDate()

Union

Select ID, FirstName + '  ' +LastName AS Name, C.VesselID
from dbo.Crew C
--Left Outer Join DepartmentAdmin DA
--ON C.ID = DA.CrewID
Where C.VesselID= @VesselID 
--And C.DepartmentMasterID = (Select DepartmentMasterID From DepartmentAdmin Where CrewID = 5)
And C.ID = (Select CrewID From Users Where ID = @UserID)
  AND Deletiondate >= GetDate()
End
End








GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllCrewForTimeSheet]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_GetAllDepartmentForDrp]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_GetAllGroupsForDrp]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_GetAllRanksForDrp]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_GetAllShipForDrp]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_GetAllSpecialityForDrp]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_GetAllUserCrewForDrp]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_GetAllUsersForDrp]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_GetDoctorBySpecialityID]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[ufn_CSVToTable]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[ufunc_GetDateFormat]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  Table [dbo].[CIRM]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
 CONSTRAINT [PK_CIRM] PRIMARY KEY CLUSTERED 
(
	[CIRMId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CompanyDetails]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  Table [dbo].[Consultation]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  Table [dbo].[CountryMaster]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  Table [dbo].[Crew]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
	[DeactivationDate] [datetime] NULL,
	[DeletionDate] [datetime] NULL,
	[Gender] [varchar](50) NULL,
 CONSTRAINT [PK_dbo.Crew] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[VesselID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CrewRegimeTR]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  Table [dbo].[Customers]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  Table [dbo].[Demo]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  Table [dbo].[DepartmentAdmin]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  Table [dbo].[DepartmentMaster]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  Table [dbo].[DoctorMaster]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  Table [dbo].[FirstRun]    Script Date: 03-Dec-18 6:13:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FirstRun](
	[RunCount] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GroupPermission]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  Table [dbo].[GroupRank]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  Table [dbo].[Groups]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  Table [dbo].[MedicalAdvisory]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  Table [dbo].[NCDetails]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  Table [dbo].[Permissions]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  Table [dbo].[Ranks]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  Table [dbo].[Regimes]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  Table [dbo].[ServiceTerms]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  Table [dbo].[ServiceTermsHistory]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  Table [dbo].[Ship]    Script Date: 03-Dec-18 6:13:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
 CONSTRAINT [PK_dbo.Ship] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[IMONumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SpecialityMaster]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  Table [dbo].[tblConfig]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  Table [dbo].[tblEquipments]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  Table [dbo].[tblMedicine]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  Table [dbo].[tblRegime]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  Table [dbo].[TimeAdjustment]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  Table [dbo].[UserGroups]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  Table [dbo].[Users]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
	[AllowDelete] [bit] NULL,
	[CrewId] [int] NULL,
	[VesselID] [int] NOT NULL,
 CONSTRAINT [PK_dbo.Users] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[VesselID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkingHours]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  Table [dbo].[WorkSchedules]    Script Date: 03-Dec-18 6:13:32 PM ******/
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
/****** Object:  Table [dbo].[WorkSessions]    Script Date: 03-Dec-18 6:13:33 PM ******/
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
SET IDENTITY_INSERT [dbo].[CompanyDetails] ON 

INSERT [dbo].[CompanyDetails] ([ID], [Name], [Address], [Website], [AdminContact], [AdminContactEmail], [ContactNumber], [Domain], [SecureKey], [CompanyID]) VALUES (4, N'Tech Vision Consulting', N'Ichapur, Delhi ', N'www.tvc.com', N'P Paul', N'ppaul@gmail.com', N'990328227', N'Shipping', N' UQGukSnWS2r+0p9h0Tfg7Av4/kWFpg5gJj2HfJk9ee/xXYik1qe0PFMQOFNG0a//zLs6Br8lKrp+pSUhKVdoJzz7AfieMzBcx7f/onTQOU8pYdOlKHpUHOv51hlPjbIU', 2)
INSERT [dbo].[CompanyDetails] ([ID], [Name], [Address], [Website], [AdminContact], [AdminContactEmail], [ContactNumber], [Domain], [SecureKey], [CompanyID]) VALUES (1004, N'Tech Vision Consulting', N'Ichapur, Delhi ', N'www.tvc.com', N'P Paul', N'ppaul@gmail.com', N'990328227', N'Shipping', N'UQGukSnWS2r+0p9h0Tfg7Av4/kWFpg5gJj2HfJk9ee/xXYik1qe0PFMQOFNG0a//zLs6Br8lKrp+pSUhKVdoJzz7AfieMzBcx7f/onTQOU8pYdOlKHpUHOv51hlPjbIU', 2)
INSERT [dbo].[CompanyDetails] ([ID], [Name], [Address], [Website], [AdminContact], [AdminContactEmail], [ContactNumber], [Domain], [SecureKey], [CompanyID]) VALUES (1005, N'Tech Vision Consulting', N'Ichapur, Delhi ', N'www.tvc.com', N'P Paul', N'ppaul@gmail.com', N'990328227', N'Shipping', N'UQGukSnWS2r+0p9h0Tfg7Av4/kWFpg5gJj2HfJk9ee/xXYik1qe0PFMQOFNG0a//zLs6Br8lKrp+pSUhKVdoJzz7AfieMzBcx7f/onTQOU8pYdOlKHpUHOv51hlPjbIU', 2)
SET IDENTITY_INSERT [dbo].[CompanyDetails] OFF
INSERT [dbo].[Consultation] ([DoctorID], [Problem]) VALUES (2, N'xyzzzzz')
INSERT [dbo].[Consultation] ([DoctorID], [Problem]) VALUES (8, N'ghjh')
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
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (241, N'Ind 2', N'ZZZ')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName], [CountryCode]) VALUES (242, N'Ind1', N'ZZZ')
SET IDENTITY_INSERT [dbo].[CountryMaster] OFF
SET IDENTITY_INSERT [dbo].[Crew] ON 

INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID], [DeactivationDate], [DeletionDate], [Gender]) VALUES (1, NULL, 0, NULL, NULL, CAST(0x0000A98C00000000 AS DateTime), NULL, NULL, CAST(0x0000A98B00000000 AS DateTime), 1, N'1/2018', 0, 1047, N'Yeshwant', N'Dessai', CAST(0x0000A98B00000000 AS DateTime), N'India', NULL, NULL, N'IND123', NULL, NULL, 9876543, 2, 95, CAST(0x002D247F00000000 AS DateTime), CAST(0x002D247F00000000 AS DateTime), NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID], [DeactivationDate], [DeletionDate], [Gender]) VALUES (2, NULL, 0, N' ', NULL, CAST(0x0000AC6B00000000 AS DateTime), NULL, NULL, CAST(0x0000A96F00000000 AS DateTime), 0, N'2/2018', 0, 1048, N'Manoj', N'Kumar', CAST(0x0000A98F00000000 AS DateTime), N'INdia', NULL, NULL, N'FR45646', NULL, NULL, 9876543, 3, 95, CAST(0x002D247F00000000 AS DateTime), CAST(0x002D247F00000000 AS DateTime), NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID], [DeactivationDate], [DeletionDate], [Gender]) VALUES (3, NULL, 0, NULL, NULL, CAST(0x0000A99100000000 AS DateTime), NULL, NULL, CAST(0x0000A98F00000000 AS DateTime), 0, N'3/2018', 0, 1051, N'Keswanto', N'Heri', CAST(0x0000A99000000000 AS DateTime), N'Delhi', NULL, NULL, N'SD3333', NULL, NULL, 9876543, 2, 95, CAST(0x002D247F00000000 AS DateTime), CAST(0x002D247F00000000 AS DateTime), NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID], [DeactivationDate], [DeletionDate], [Gender]) VALUES (4, NULL, 0, NULL, NULL, CAST(0x0000A98F00000000 AS DateTime), NULL, NULL, CAST(0x0000A98E00000000 AS DateTime), 0, N'4/2018', 0, 1051, N'Olga', N'Olianova', CAST(0x0000A99000000000 AS DateTime), N'Kol', NULL, NULL, N'SW34344', NULL, NULL, 9876543, 2, 95, CAST(0x002D247F00000000 AS DateTime), CAST(0x002D247F00000000 AS DateTime), NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID], [DeactivationDate], [DeletionDate], [Gender]) VALUES (5, NULL, 0, NULL, NULL, CAST(0x0000A99100000000 AS DateTime), NULL, NULL, CAST(0x0000A99000000000 AS DateTime), 0, N'5/2018', 0, 1062, N'Musmadi', N'Musmadi', CAST(0x0000A98C00000000 AS DateTime), N'Patna', NULL, NULL, N'GT4334', NULL, NULL, 9876543, 2, 95, CAST(0x002D247F00000000 AS DateTime), CAST(0x002D247F00000000 AS DateTime), NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID], [DeactivationDate], [DeletionDate], [Gender]) VALUES (6, NULL, 0, NULL, NULL, CAST(0x0000A9C700000000 AS DateTime), NULL, NULL, CAST(0x0000A93E00000000 AS DateTime), 1, N'6/2018', 0, 1063, N'Rocky ', N'Singh', CAST(0x00008A2D00000000 AS DateTime), N'Amritsar', NULL, NULL, N'ergh89', NULL, 0, 9876543, 2, 127, CAST(0x0000A99B013017CD AS DateTime), CAST(0x0000A9A800000000 AS DateTime), NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID], [DeactivationDate], [DeletionDate], [Gender]) VALUES (7, NULL, 0, NULL, NULL, CAST(0x0000A9C700000000 AS DateTime), NULL, NULL, CAST(0x0000A96C00000000 AS DateTime), 0, N'7/2018', 0, 1049, N'Prafull', N'Modi', CAST(0x0000A99100000000 AS DateTime), N'Riyadh', NULL, N'ee4334', NULL, NULL, NULL, 9876543, 2, 188, CAST(0x002D247F00000000 AS DateTime), CAST(0x002D247F00000000 AS DateTime), NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID], [DeactivationDate], [DeletionDate], [Gender]) VALUES (8, NULL, 1, N' ', NULL, CAST(0x0000A99700000000 AS DateTime), NULL, NULL, CAST(0x0000A98B00000000 AS DateTime), 1, N'8/2018', 0, 1047, N'Nirab', N'Modi', CAST(0x00007D5400000000 AS DateTime), N'Gujrat', NULL, NULL, N'PP0001', NULL, NULL, 9876543, 2, 95, CAST(0x002D247F00000000 AS DateTime), CAST(0x002D247F00000000 AS DateTime), NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID], [DeactivationDate], [DeletionDate], [Gender]) VALUES (9, NULL, 1, N'Comments', NULL, CAST(0x0000A98C00000000 AS DateTime), NULL, NULL, CAST(0x0000A98B00000000 AS DateTime), 1, N'9/2018', 0, 1047, N'Given Name', N'Family Name', CAST(0x0000A98B00000000 AS DateTime), N'Place Of Birth', NULL, NULL, N'56', N'Middle Name 1', NULL, 9876543, 6, 18, CAST(0x002D247F00000000 AS DateTime), CAST(0x002D247F00000000 AS DateTime), NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID], [DeactivationDate], [DeletionDate], [Gender]) VALUES (55, NULL, 0, NULL, 0, CAST(0x0000A99901886C92 AS DateTime), NULL, NULL, CAST(0x0000A99901886C92 AS DateTime), 0, N'2', 0, 1115, N'Mitesh Sanjay', N'Gawde', CAST(0x0000859500000000 AS DateTime), N'Indian', NULL, N'J8866042', NULL, NULL, 1, 9876543, 2, 95, CAST(0x002D247F00000000 AS DateTime), CAST(0x002D247F00000000 AS DateTime), NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID], [DeactivationDate], [DeletionDate], [Gender]) VALUES (56, NULL, 1, N' ', 0, CAST(0x0000A99F00000000 AS DateTime), NULL, NULL, CAST(0x0000A96C00000000 AS DateTime), 0, N'3', 0, 1116, N'Pratama', N'Satriya Yoga ', CAST(0x000086EF00000000 AS DateTime), N'Indonesian', NULL, NULL, N'B1150748', NULL, 1, 9876543, 2, 96, CAST(0x002D247F00000000 AS DateTime), CAST(0x002D247F00000000 AS DateTime), NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID], [DeactivationDate], [DeletionDate], [Gender]) VALUES (57, NULL, 0, N' ', 0, CAST(0x0000AC8300000000 AS DateTime), NULL, NULL, CAST(0x0000A98B00000000 AS DateTime), 1, N'12/2018', 0, 1117, N'Ravi', N'Ranatunga', CAST(0x000068F000000000 AS DateTime), N'Indian', NULL, NULL, N'Z2453211', NULL, 0, 9876543, 2, 95, CAST(0x0000A99B01302A73 AS DateTime), CAST(0x0000A9A800000000 AS DateTime), NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID], [DeactivationDate], [DeletionDate], [Gender]) VALUES (58, NULL, 0, N' ', 0, CAST(0x0000A99B00000000 AS DateTime), NULL, NULL, CAST(0x0000A98B00000000 AS DateTime), 0, N'13/2018', 0, 1118, N'Milind', N'Wadekar', CAST(0x0000859500000000 AS DateTime), N'Indian', NULL, NULL, N'J8866042', NULL, 1, 9876543, 2, 95, CAST(0x002D247F00000000 AS DateTime), CAST(0x002D247F00000000 AS DateTime), NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID], [DeactivationDate], [DeletionDate], [Gender]) VALUES (59, NULL, 0, NULL, 0, CAST(0x0000A99B009E990F AS DateTime), NULL, NULL, CAST(0x0000A99B009E990F AS DateTime), 0, N'14/2018', 0, 1119, N'Rajesh', N'Nambiyar', CAST(0x000086EF00000000 AS DateTime), N'Indonesian', NULL, N'B1150748', NULL, NULL, 1, 9876543, 2, 96, CAST(0x002D247F00000000 AS DateTime), CAST(0x002D247F00000000 AS DateTime), NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID], [DeactivationDate], [DeletionDate], [Gender]) VALUES (60, NULL, 0, NULL, 0, CAST(0x0000A99B012F2154 AS DateTime), NULL, NULL, CAST(0x0000A99B012F2154 AS DateTime), 0, N'15/2018', 0, 1120, N'Ravi', N'Ranatunga', CAST(0x000068F000000000 AS DateTime), N'Indian', NULL, N'Z2453211', NULL, NULL, 0, 9876543, 2, 95, CAST(0x0000A99B012F6346 AS DateTime), CAST(0x0000A9A800000000 AS DateTime), NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID], [DeactivationDate], [DeletionDate], [Gender]) VALUES (61, NULL, 0, NULL, 0, CAST(0x0000A99B012F215C AS DateTime), NULL, NULL, CAST(0x0000A99B012F215C AS DateTime), 0, N'16/2018', 0, 1121, N'Milind', N'Wadekar', CAST(0x0000859500000000 AS DateTime), N'Indian', NULL, N'J8866042', NULL, NULL, 0, 9876543, 2, 95, CAST(0x0000A99B012F5022 AS DateTime), CAST(0x0000A9A800000000 AS DateTime), NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID], [DeactivationDate], [DeletionDate], [Gender]) VALUES (62, NULL, 0, NULL, 0, CAST(0x0000A99B012FF4E8 AS DateTime), NULL, NULL, CAST(0x0000A99B012FF4E8 AS DateTime), 0, N'17/2018', 0, 1122, N'Ravi', N'Ranatunga', CAST(0x000068F000000000 AS DateTime), N'Indian', NULL, N'Z2453211', NULL, NULL, 1, 9876543, 2, 95, CAST(0x002D247F00000000 AS DateTime), CAST(0x002D247F00000000 AS DateTime), NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID], [DeactivationDate], [DeletionDate], [Gender]) VALUES (63, NULL, 0, NULL, 0, CAST(0x0000A99B012FF4EA AS DateTime), NULL, NULL, CAST(0x0000A99B012FF4EA AS DateTime), 0, N'18/2018', 0, 1123, N'Milind', N'Wadekar', CAST(0x0000859500000000 AS DateTime), N'Indian', NULL, N'J8866042', NULL, NULL, 0, 9876543, 2, 95, CAST(0x0000A99B01300265 AS DateTime), CAST(0x0000A9A800000000 AS DateTime), NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID], [DeactivationDate], [DeletionDate], [Gender]) VALUES (64, NULL, 0, NULL, 0, CAST(0x0000A99B012FF4EB AS DateTime), NULL, NULL, CAST(0x0000A99B012FF4EB AS DateTime), 0, N'19/2018', 0, 1124, N'Rajesh', N'Nambiyar', CAST(0x000086EF00000000 AS DateTime), N'Indonesian', NULL, N'B1150748', NULL, NULL, 0, 9876543, 2, 96, CAST(0x0000A99B01302014 AS DateTime), CAST(0x0000A9A800000000 AS DateTime), NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID], [DeactivationDate], [DeletionDate], [Gender]) VALUES (65, NULL, 0, N' ', 0, CAST(0x0000AC8300000000 AS DateTime), NULL, NULL, CAST(0x0000A85B00000000 AS DateTime), 1, N'20/2018', 0, 1125, N'John', N'Woo', CAST(0x000068F000000000 AS DateTime), N'Indian', NULL, NULL, N'Z2453217', NULL, 1, 9876543, 2, 95, CAST(0x002D247F00000000 AS DateTime), CAST(0x002D247F00000000 AS DateTime), NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID], [DeactivationDate], [DeletionDate], [Gender]) VALUES (66, NULL, 0, N' ', 0, CAST(0x0000A9C700000000 AS DateTime), NULL, NULL, CAST(0x0000A96C00000000 AS DateTime), 0, N'21/2018', 0, 1126, N'John', N'Doe', CAST(0x0000859500000000 AS DateTime), N'Indian', NULL, NULL, N'J8865042', NULL, 1, 9876543, 2, 95, CAST(0x002D247F00000000 AS DateTime), CAST(0x002D247F00000000 AS DateTime), NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID], [DeactivationDate], [DeletionDate], [Gender]) VALUES (67, NULL, 0, NULL, 0, CAST(0x0000A99B014C0F45 AS DateTime), NULL, NULL, CAST(0x0000A99B014C0F45 AS DateTime), 0, N'22/2018', 0, 1127, N'Shivaji', N'Rao', CAST(0x000086EF00000000 AS DateTime), N'Indonesian', NULL, N'B1150747', NULL, NULL, 1, 9876543, 2, 96, CAST(0x002D247F00000000 AS DateTime), CAST(0x002D247F00000000 AS DateTime), NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID], [DeactivationDate], [DeletionDate], [Gender]) VALUES (68, NULL, 0, N' ', NULL, CAST(0x0000A99F00000000 AS DateTime), NULL, NULL, CAST(0x0000A3B700000000 AS DateTime), 1, N'23/2018', 0, 1048, N'Septaban', N'Mahato', CAST(0x00004CDF00000000 AS DateTime), N'AddisAbaaba', NULL, NULL, N'SFU689', NULL, NULL, 9876543, 2, 2, CAST(0x002D247F00000000 AS DateTime), CAST(0x002D247F00000000 AS DateTime), N'Male')
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID], [DeactivationDate], [DeletionDate], [Gender]) VALUES (69, NULL, 0, N' ', NULL, CAST(0x0000A9A500000000 AS DateTime), NULL, NULL, CAST(0x0000A96C00000000 AS DateTime), 0, N'24/2018', 0, 1051, N'Shayamal', N'Shaw', CAST(0x0000540200000000 AS DateTime), N'Andorra City', NULL, NULL, N'JK6798322', NULL, NULL, 9876543, 2, 5, CAST(0x002D247F00000000 AS DateTime), CAST(0x002D247F00000000 AS DateTime), N'Male')
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID], [DeactivationDate], [DeletionDate], [Gender]) VALUES (70, NULL, 0, N' ', NULL, CAST(0x0000A9A500000000 AS DateTime), NULL, NULL, CAST(0x0000A98B00000000 AS DateTime), 0, N'25/2018', 0, 1053, N'Modon', N'Mitra', CAST(0x00004FB600000000 AS DateTime), N'Rome', NULL, NULL, N't5656722', NULL, NULL, 9876543, 2, 233, CAST(0x002D247F00000000 AS DateTime), CAST(0x002D247F00000000 AS DateTime), N'Male')
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID], [DeactivationDate], [DeletionDate], [Gender]) VALUES (71, NULL, 0, N' ', NULL, CAST(0x0000A9A800000000 AS DateTime), NULL, NULL, CAST(0x0000A98B00000000 AS DateTime), 0, N'26/2018', 0, 1072, N'MataHari', N'Lung', CAST(0x0000624100000000 AS DateTime), N'Bejing', NULL, NULL, N'3', NULL, NULL, 9876543, 2, 44, CAST(0x002D247F00000000 AS DateTime), CAST(0x002D247F00000000 AS DateTime), N'Female')
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID], [DeactivationDate], [DeletionDate], [Gender]) VALUES (72, NULL, 0, NULL, NULL, CAST(0x0000AC7E00000000 AS DateTime), NULL, NULL, CAST(0x0000A94E00000000 AS DateTime), 1, N'27/2018', 0, 1054, N'Masha', N'Perestrova', CAST(0x0000668500000000 AS DateTime), N'Moscow', NULL, N'R2356', NULL, NULL, NULL, 9876543, 2, 176, CAST(0x002D247F00000000 AS DateTime), CAST(0x002D247F00000000 AS DateTime), N'Female')
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID], [DeactivationDate], [DeletionDate], [Gender]) VALUES (73, NULL, 0, NULL, NULL, CAST(0x0000B39A00000000 AS DateTime), NULL, NULL, CAST(0x0000A98F00000000 AS DateTime), 0, N'28/2018', 0, 1050, N'Raymond', N'Reddington', CAST(0x00007EC500000000 AS DateTime), N'London', NULL, N'U4667', NULL, NULL, NULL, 9876543, 2, 228, CAST(0x002D247F00000000 AS DateTime), CAST(0x002D247F00000000 AS DateTime), N'Male')
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName], [IsActive], [VesselID], [DepartmentMasterID], [CountryID], [DeactivationDate], [DeletionDate], [Gender]) VALUES (74, NULL, 0, N' ', NULL, CAST(0x0000A9A800000000 AS DateTime), NULL, NULL, CAST(0x0000A98B00000000 AS DateTime), 0, N'29/2018', 0, 1049, N'Harold', N'Cooper', CAST(0x00005B1800000000 AS DateTime), N'LA', NULL, NULL, N'66', NULL, NULL, 9876543, 2, 16, CAST(0x002D247F00000000 AS DateTime), CAST(0x002D247F00000000 AS DateTime), N'Male')
SET IDENTITY_INSERT [dbo].[Crew] OFF
SET IDENTITY_INSERT [dbo].[DepartmentAdmin] ON 

INSERT [dbo].[DepartmentAdmin] ([DepartmentAdminID], [DepartmentMasterID], [CrewID], [IsActive], [PositionEndDate], [IsAdmin], [VesselID], [ReportsTo]) VALUES (23, 5, 7, 1, NULL, 1, 9876543, NULL)
INSERT [dbo].[DepartmentAdmin] ([DepartmentAdminID], [DepartmentMasterID], [CrewID], [IsActive], [PositionEndDate], [IsAdmin], [VesselID], [ReportsTo]) VALUES (24, 5, 58, 1, NULL, 1, 9876543, NULL)
INSERT [dbo].[DepartmentAdmin] ([DepartmentAdminID], [DepartmentMasterID], [CrewID], [IsActive], [PositionEndDate], [IsAdmin], [VesselID], [ReportsTo]) VALUES (28, 3, 58, 1, NULL, 1, 9876543, NULL)
INSERT [dbo].[DepartmentAdmin] ([DepartmentAdminID], [DepartmentMasterID], [CrewID], [IsActive], [PositionEndDate], [IsAdmin], [VesselID], [ReportsTo]) VALUES (31, 2, 8, 1, NULL, 1, 9876543, NULL)
INSERT [dbo].[DepartmentAdmin] ([DepartmentAdminID], [DepartmentMasterID], [CrewID], [IsActive], [PositionEndDate], [IsAdmin], [VesselID], [ReportsTo]) VALUES (32, 1, 2, 1, NULL, 1, 9876543, NULL)
SET IDENTITY_INSERT [dbo].[DepartmentAdmin] OFF
SET IDENTITY_INSERT [dbo].[DepartmentMaster] ON 

INSERT [dbo].[DepartmentMaster] ([DepartmentMasterID], [DepartmentMasterName], [DepartmentMasterCode], [IsActive], [VesselID]) VALUES (1, N'Engine Room', NULL, 1, 9876543)
INSERT [dbo].[DepartmentMaster] ([DepartmentMasterID], [DepartmentMasterName], [DepartmentMasterCode], [IsActive], [VesselID]) VALUES (2, N'Deck', NULL, 1, 9876543)
INSERT [dbo].[DepartmentMaster] ([DepartmentMasterID], [DepartmentMasterName], [DepartmentMasterCode], [IsActive], [VesselID]) VALUES (3, N'Deck Department', NULL, 1, 9876543)
INSERT [dbo].[DepartmentMaster] ([DepartmentMasterID], [DepartmentMasterName], [DepartmentMasterCode], [IsActive], [VesselID]) VALUES (4, N'Engine Department', NULL, 1, 9876543)
INSERT [dbo].[DepartmentMaster] ([DepartmentMasterID], [DepartmentMasterName], [DepartmentMasterCode], [IsActive], [VesselID]) VALUES (5, N'Catering Department', NULL, 1, 9876543)
INSERT [dbo].[DepartmentMaster] ([DepartmentMasterID], [DepartmentMasterName], [DepartmentMasterCode], [IsActive], [VesselID]) VALUES (6, N'Department Name', NULL, 1, 9876543)
SET IDENTITY_INSERT [dbo].[DepartmentMaster] OFF
SET IDENTITY_INSERT [dbo].[DoctorMaster] ON 

INSERT [dbo].[DoctorMaster] ([DoctorID], [DoctorName], [DoctorEmail], [SpecialityID], [Comment]) VALUES (2, N'Abir Ray', N'abr@gmail.com', 1, N'xyz1')
INSERT [dbo].[DoctorMaster] ([DoctorID], [DoctorName], [DoctorEmail], [SpecialityID], [Comment]) VALUES (8, N'PranabPaul', N'prp@gmail.com', 2, N'zyx2')
INSERT [dbo].[DoctorMaster] ([DoctorID], [DoctorName], [DoctorEmail], [SpecialityID], [Comment]) VALUES (2004, N'ddnnn', N'ee@@gmail.com', 1, N'ccooomm')
INSERT [dbo].[DoctorMaster] ([DoctorID], [DoctorName], [DoctorEmail], [SpecialityID], [Comment]) VALUES (2005, N'1', N'1@@gmail.com', 1, N'11')
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
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (60, 15, 1065, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (61, 15, 1066, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (62, 15, 1067, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (63, 15, 1068, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (64, 15, 1069, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (65, 15, 1070, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (66, 15, 1071, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (67, 15, 1072, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (68, 15, 1073, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (69, 15, 1074, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (70, 15, 1075, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (71, 15, 1076, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (72, 15, 1077, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (73, 15, 1078, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (74, 15, 1079, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (75, 15, 1080, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (76, 15, 1081, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (77, 15, 1082, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (78, 15, 1083, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (79, 15, 1084, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (80, 15, 1085, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (81, 15, 1086, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (82, 15, 1087, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (83, 15, 1088, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (84, 15, 1089, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (85, 15, 1090, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (86, 15, 1091, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (87, 15, 1092, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (88, 15, 1093, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (89, 15, 1094, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (90, 15, 1095, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (91, 15, 1096, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (92, 15, 1097, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (93, 15, 1098, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (94, 15, 1099, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (95, 15, 1100, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (96, 15, 1101, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (97, 15, 1102, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (98, 15, 1103, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (99, 15, 1104, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (100, 15, 1105, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (101, 15, 1106, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (102, 15, 1107, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (103, 15, 1108, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (104, 15, 1109, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (105, 15, 1110, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (106, 15, 1111, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (107, 15, 1112, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (108, 15, 1113, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (109, 15, 1114, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (110, 15, 1115, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (111, 15, 1116, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (112, 15, 1117, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (113, 15, 1118, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (114, 15, 1119, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (115, 15, 1120, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (116, 15, 1121, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (117, 15, 1122, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (118, 15, 1123, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (119, 15, 1124, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (120, 15, 1125, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (121, 15, 1126, 9876543)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID], [VesselID]) VALUES (122, 15, 1127, 9876543)
SET IDENTITY_INSERT [dbo].[GroupRank] OFF
SET IDENTITY_INSERT [dbo].[Groups] ON 

INSERT [dbo].[Groups] ([ID], [GroupName], [AllowDelete], [VesselID]) VALUES (13, N'Super Admin', 1, 9876543)
INSERT [dbo].[Groups] ([ID], [GroupName], [AllowDelete], [VesselID]) VALUES (14, N'Admin', 1, 9876543)
INSERT [dbo].[Groups] ([ID], [GroupName], [AllowDelete], [VesselID]) VALUES (15, N'User', 1, 9876543)
SET IDENTITY_INSERT [dbo].[Groups] OFF
SET IDENTITY_INSERT [dbo].[MedicalAdvisory] ON 

INSERT [dbo].[MedicalAdvisory] ([MedicalAdvisoryID], [Weight], [BMI], [BP], [BloodSugarLevel], [UrineTest], [CrewID], [Height], [Age], [BloodSugarUnit], [BloodSugarTestType], [Systolic], [Diastolic], [UnannouncedAlcohol], [AnnualDH], [Month], [CrewName], [PulseRatebpm], [AnyDietaryRestrictions], [MedicalProductsAdministered], [UploadExistingPrescriptions], [UploadUrineReport]) VALUES (1008, N'65', N'22.5', NULL, N'140', 1, 0, N'306', N'46', N'mmol/L', N'2', N'120', N'80', 1, 1, N'January', N'Manoj Kumar', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[MedicalAdvisory] ([MedicalAdvisoryID], [Weight], [BMI], [BP], [BloodSugarLevel], [UrineTest], [CrewID], [Height], [Age], [BloodSugarUnit], [BloodSugarTestType], [Systolic], [Diastolic], [UnannouncedAlcohol], [AnnualDH], [Month], [CrewName], [PulseRatebpm], [AnyDietaryRestrictions], [MedicalProductsAdministered], [UploadExistingPrescriptions], [UploadUrineReport]) VALUES (1009, N'55', N'23.5', NULL, N'145', 1, 0, N'330', N'29', N'mmol/L', N'3', N'122', N'90', 0, 0, N'February', N'Yeshwant Dessai', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[MedicalAdvisory] ([MedicalAdvisoryID], [Weight], [BMI], [BP], [BloodSugarLevel], [UrineTest], [CrewID], [Height], [Age], [BloodSugarUnit], [BloodSugarTestType], [Systolic], [Diastolic], [UnannouncedAlcohol], [AnnualDH], [Month], [CrewName], [PulseRatebpm], [AnyDietaryRestrictions], [MedicalProductsAdministered], [UploadExistingPrescriptions], [UploadUrineReport]) VALUES (2006, N'57', N'21.5', NULL, N'137', 1, 0, N'320', N'25', N'mmol/L', N'2', N'121', N'85', 1, 1, N'March', N'Olga Olianova', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[MedicalAdvisory] ([MedicalAdvisoryID], [Weight], [BMI], [BP], [BloodSugarLevel], [UrineTest], [CrewID], [Height], [Age], [BloodSugarUnit], [BloodSugarTestType], [Systolic], [Diastolic], [UnannouncedAlcohol], [AnnualDH], [Month], [CrewName], [PulseRatebpm], [AnyDietaryRestrictions], [MedicalProductsAdministered], [UploadExistingPrescriptions], [UploadUrineReport]) VALUES (2007, N'53', N'22.2', NULL, N'138', 1, 0, N'302', N'27', N'mmol/L', N'3', N'125', N'77', 0, 0, N'April', N'Musmadi Musmadi', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[MedicalAdvisory] ([MedicalAdvisoryID], [Weight], [BMI], [BP], [BloodSugarLevel], [UrineTest], [CrewID], [Height], [Age], [BloodSugarUnit], [BloodSugarTestType], [Systolic], [Diastolic], [UnannouncedAlcohol], [AnnualDH], [Month], [CrewName], [PulseRatebpm], [AnyDietaryRestrictions], [MedicalProductsAdministered], [UploadExistingPrescriptions], [UploadUrineReport]) VALUES (2009, N'45', N'222.22', NULL, N'45', 1, 0, N'45', N'45', N'mmol/L', N'2', N'45', N'45', 1, 1, NULL, NULL, N'45', N'455554555', N'455555', NULL, NULL)
SET IDENTITY_INSERT [dbo].[MedicalAdvisory] OFF
SET IDENTITY_INSERT [dbo].[NCDetails] ON 

INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1, 3, CAST(0x0000A98F00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>129.5</minsevendaysrest><mintwentyfourhoursrest>14</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>8</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>10</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (2, 3, CAST(0x0000A99200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>128</minsevendaysrest><mintwentyfourhoursrest>11</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>9</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>13</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 2, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (3, 3, CAST(0x0000A98400000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>25</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>25</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 3, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (4, 3, CAST(0x0000A98500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>25</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>25</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 4, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (5, 3, CAST(0x0000A98600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>25</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>25</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 5, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (6, 3, CAST(0x0000A98700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>157.5</minsevendaysrest><mintwentyfourhoursrest>13.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>10.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 6, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (7, 3, CAST(0x0000A98800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>157.5</minsevendaysrest><mintwentyfourhoursrest>13.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>13.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 7, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (8, 3, CAST(0x0000A98900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus>Less than 10 hrs of rest in 24 hrs period</twentyfourhourresthoursstatus><minsevendaysrest>139.5</minsevendaysrest><mintwentyfourhoursrest>6</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>2</maxrestperiodintewntyfourhours><maxnrofrestperiod>4</maxnrofrestperiod><totalworkedhours>18</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 8, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (9, 3, CAST(0x0000A98A00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus>Less than 10 hrs of rest in 24 hrs period</twentyfourhourresthoursstatus><minsevendaysrest>139.5</minsevendaysrest><mintwentyfourhoursrest>6</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>3</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 9, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (10, 3, CAST(0x0000A98B00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>139.5</minsevendaysrest><mintwentyfourhoursrest>24</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>24</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 10, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (11, 3, CAST(0x0000A98C00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>139.5</minsevendaysrest><mintwentyfourhoursrest>24</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>24</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 11, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (12, 3, CAST(0x0000A98D00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>129</minsevendaysrest><mintwentyfourhoursrest>13.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>7.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>10.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 12, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (13, 3, CAST(0x0000A98E00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>139.5</minsevendaysrest><mintwentyfourhoursrest>13.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>13.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 13, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (14, 3, CAST(0x0000A99000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus>Less than 10 hrs of rest in 24 hrs period</twentyfourhourresthoursstatus><minsevendaysrest>141</minsevendaysrest><mintwentyfourhoursrest>9</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>9</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>6.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 14, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (15, 3, CAST(0x0000A99100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>141</minsevendaysrest><mintwentyfourhoursrest>17.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>17.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 15, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (16, 3, CAST(0x0000A99300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus>Less than 10 hrs of rest in 24 hrs period</twentyfourhourresthoursstatus><minsevendaysrest>115</minsevendaysrest><mintwentyfourhoursrest>4</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>3</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>13</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 16, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (17, 3, CAST(0x0000A97F00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>25</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>25</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 17, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (18, 3, CAST(0x0000A98000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>24</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>24</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 18, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (19, 3, CAST(0x0000A98100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>24</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>24</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 19, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (20, 3, CAST(0x0000A98200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>24</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>24</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 20, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (21, 3, CAST(0x0000A98300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>24</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>24</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 21, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (22, 3, CAST(0x0000A97900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>25</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>25</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 22, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (23, 3, CAST(0x0000A97A00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>24</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>24</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 23, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (24, 3, CAST(0x0000A97B00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>24</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>24</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 24, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (25, 3, CAST(0x0000A97C00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>24</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>24</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 25, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (26, 3, CAST(0x0000A97D00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>24</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>24</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 26, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (27, 3, CAST(0x0000A97E00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>24</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>24</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 27, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (28, 1, CAST(0x0000A96C00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>25</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>25</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>3.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 28, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (29, 1, CAST(0x0000A96D00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>14</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>14</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>10</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 29, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (30, 1, CAST(0x0000A95F00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>24</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>24</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 30, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (31, 1, CAST(0x0000A96000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>24</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>24</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 31, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (32, 1, CAST(0x0000A96100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>24</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>24</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 32, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (33, 1, CAST(0x0000A96200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>24</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>24</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 33, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (34, 1, CAST(0x0000A96300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>24</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>24</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 34, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (35, 1, CAST(0x0000A96400000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>24</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>24</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 35, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (36, 1, CAST(0x0000A96500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>24</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>24</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 36, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (37, 1, CAST(0x0000A96600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>24</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>24</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 37, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (38, 1, CAST(0x0000A96700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>24</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>24</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 38, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (39, 1, CAST(0x0000A96800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>24</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>24</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 39, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (40, 1, CAST(0x0000A96900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>24</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>24</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 40, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (41, 1, CAST(0x0000A96A00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>24</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>24</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 41, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (42, 1, CAST(0x0000A96B00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>24</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>24</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 42, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (43, 1, CAST(0x0000A96E00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>13.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>13</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>0.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 43, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (44, 1, CAST(0x0000A96F00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>23.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>23.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>0.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 44, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (45, 1, CAST(0x0000A97000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>23</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>20.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>0.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 45, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (46, 1, CAST(0x0000A97100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>23</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>21.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>0.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 46, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (47, 1, CAST(0x0000A97200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>144.5</minsevendaysrest><mintwentyfourhoursrest>16</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>16</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>8</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 47, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (48, 1, CAST(0x0000A97300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>139</minsevendaysrest><mintwentyfourhoursrest>15</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>15</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>9</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 48, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (49, 1, CAST(0x0000A97400000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>139</minsevendaysrest><mintwentyfourhoursrest>14</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>14</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>10</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 49, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (50, 1, CAST(0x0000A97500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>135.5</minsevendaysrest><mintwentyfourhoursrest>11</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>11</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>4</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 50, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (51, 1, CAST(0x0000A97600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>134</minsevendaysrest><mintwentyfourhoursrest>19.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>19.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>2</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 51, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (52, 1, CAST(0x0000A97700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>132.5</minsevendaysrest><mintwentyfourhoursrest>22</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>22</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>2</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 52, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (53, 1, CAST(0x0000A97800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>131</minsevendaysrest><mintwentyfourhoursrest>22</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>22</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>2</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 53, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (54, 1, CAST(0x0000A97900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>130</minsevendaysrest><mintwentyfourhoursrest>15</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>15</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>9</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 54, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (55, 1, CAST(0x0000A97A00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>129</minsevendaysrest><mintwentyfourhoursrest>14</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>14</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>10</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 55, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (56, 1, CAST(0x0000A97B00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>130</minsevendaysrest><mintwentyfourhoursrest>13</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>13</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>9</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 56, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (57, 1, CAST(0x0000A97C00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>132</minsevendaysrest><mintwentyfourhoursrest>22</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>22</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>2</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 57, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (58, 1, CAST(0x0000A97D00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>124</minsevendaysrest><mintwentyfourhoursrest>14</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>14</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>10</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 58, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (59, 1, CAST(0x0000A97E00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>125.5</minsevendaysrest><mintwentyfourhoursrest>15</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>15</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>0.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 59, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (60, 1, CAST(0x0000A97F00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>124</minsevendaysrest><mintwentyfourhoursrest>20</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>18.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>3.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 60, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (61, 1, CAST(0x0000A98000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>131</minsevendaysrest><mintwentyfourhoursrest>24</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>24</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>2</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 61, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (62, 1, CAST(0x0000A98100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>132</minsevendaysrest><mintwentyfourhoursrest>15</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>15</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>9</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 62, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (63, 1, CAST(0x0000A98200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>132</minsevendaysrest><mintwentyfourhoursrest>15</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>15</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>9</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 63, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (64, 1, CAST(0x0000A98300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus>Less than 10 hrs of rest in 24 hrs period</twentyfourhourresthoursstatus><minsevendaysrest>117</minsevendaysrest><mintwentyfourhoursrest>7</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>3.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>17</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 64, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (65, 1, CAST(0x0000A98400000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus>Less than 10 hrs of rest in 24 hrs period</twentyfourhourresthoursstatus><minsevendaysrest>125</minsevendaysrest><mintwentyfourhoursrest>7</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>3.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>2</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 65, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (66, 1, CAST(0x0000A98500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>123.5</minsevendaysrest><mintwentyfourhoursrest>20</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>14</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>2</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 66, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (67, 1, CAST(0x0000A98600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>126</minsevendaysrest><mintwentyfourhoursrest>23</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>23</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>1</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 67, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (68, 1, CAST(0x0000A98700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>119</minsevendaysrest><mintwentyfourhoursrest>15</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>15</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>9</totalworkedhours><overtimeHours>9</overtimeHours></ncdetails>', 0, 68, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (69, 1, CAST(0x0000A98800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>127.5</minsevendaysrest><mintwentyfourhoursrest>16</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>16</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>0.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 69, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (70, 1, CAST(0x0000A98900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>134.5</minsevendaysrest><mintwentyfourhoursrest>22</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>22</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>2</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 70, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (71, 1, CAST(0x0000A98A00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>141.5</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>10</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 71, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (72, 2, CAST(0x0000A99000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>18</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>15</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>6</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 72, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1073, 4, CAST(0x0000A98C00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>24</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>24</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>14</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1073, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1074, 4, CAST(0x0000A98D00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>24</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>24</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>14</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1074, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1075, 4, CAST(0x0000A98E00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>11</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>5</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>13</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1075, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1076, 4, CAST(0x0000A98F00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>6</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1076, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1077, 4, CAST(0x0000A99000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>6</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1077, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1078, 4, CAST(0x0000A99100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus>Less than 10 hrs of rest in 24 hrs period</twentyfourhourresthoursstatus><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>9</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>15</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1078, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1079, 4, CAST(0x0000A99200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus /><sevendaysstatus>Less than 77 hours of rest in 7 days</sevendaysstatus><twentyfourhourresthoursstatus /><minsevendaysrest>74</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>6</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>14</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1079, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1080, 1, CAST(0x0000A99F00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>164.5</minsevendaysrest><mintwentyfourhoursrest>20.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>3.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1080, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1081, 5, CAST(0x0000A98B00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>23</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>22</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>1</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1081, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1082, 5, CAST(0x0000A98C00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>23.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>23.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>0.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1082, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1083, 5, CAST(0x0000A98D00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>18.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>18.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>5.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1083, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1084, 5, CAST(0x0000A98E00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>15</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>15</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>9</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1084, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1085, 5, CAST(0x0000A98F00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>13.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>10</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>1.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1085, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1086, 5, CAST(0x0000A99000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>14</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>14</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>10</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1086, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1087, 5, CAST(0x0000A99100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus>Less than 10 hrs of rest in 24 hrs period</twentyfourhourresthoursstatus><minsevendaysrest>123.5</minsevendaysrest><mintwentyfourhoursrest>7</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>7</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>17</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1087, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1088, 5, CAST(0x0000A99200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus>Less than 10 hrs of rest in 24 hrs period</twentyfourhourresthoursstatus><minsevendaysrest>124</minsevendaysrest><mintwentyfourhoursrest>6.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>3.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>0.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1088, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1089, 5, CAST(0x0000A99300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>124</minsevendaysrest><mintwentyfourhoursrest>23.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>23.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>0.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1089, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1090, 5, CAST(0x0000A99400000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>128.5</minsevendaysrest><mintwentyfourhoursrest>22.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>22</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>1</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1090, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1091, 5, CAST(0x0000A99500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>137</minsevendaysrest><mintwentyfourhoursrest>22.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>22.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>0.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1091, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1092, 5, CAST(0x0000A99600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>137.5</minsevendaysrest><mintwentyfourhoursrest>23</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>23</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>1</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1092, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1093, 5, CAST(0x0000A99700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>146.5</minsevendaysrest><mintwentyfourhoursrest>23</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>23</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>1</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1093, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1094, 5, CAST(0x0000A99800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>163</minsevendaysrest><mintwentyfourhoursrest>23.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>23.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>0.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1094, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1095, 5, CAST(0x0000A99900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>163</minsevendaysrest><mintwentyfourhoursrest>23</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>19.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>0.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1095, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1096, 5, CAST(0x0000A99A00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>162</minsevendaysrest><mintwentyfourhoursrest>22.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>22.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>1.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1096, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1097, 5, CAST(0x0000A99B00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>162.5</minsevendaysrest><mintwentyfourhoursrest>22</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>11.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>0.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1097, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1098, 5, CAST(0x0000A99B00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>162.5</minsevendaysrest><mintwentyfourhoursrest>22</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>11.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>0.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1098, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1099, 5, CAST(0x0000A99D00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>162.5</minsevendaysrest><mintwentyfourhoursrest>22.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>22.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>1</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1099, 0, 9876543)
GO
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1100, 5, CAST(0x0000A99C00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>162.5</minsevendaysrest><mintwentyfourhoursrest>23.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>23.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1100, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1101, 5, CAST(0x0000A99E00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>164</minsevendaysrest><mintwentyfourhoursrest>23.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>21.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>0.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1101, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1102, 5, CAST(0x0000A99F00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>163</minsevendaysrest><mintwentyfourhoursrest>23</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>23</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>1</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1102, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1103, 5, CAST(0x0000A9A000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>163</minsevendaysrest><mintwentyfourhoursrest>23</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>23</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>1</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1103, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1104, 5, CAST(0x0000A9A100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>163.5</minsevendaysrest><mintwentyfourhoursrest>23</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>23</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>1</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1104, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1105, 5, CAST(0x0000A9A200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>163</minsevendaysrest><mintwentyfourhoursrest>22.5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>22</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>0.5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1105, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1106, 65, CAST(0x0000A94E00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>14</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 1106, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1107, 65, CAST(0x0000A94E00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>14</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 1107, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1108, 65, CAST(0x0000A94E00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>14</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 1108, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1109, 65, CAST(0x0000A94F00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>6</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>14</totalworkedhours><overtimeHours>14</overtimeHours></ncdetails>', 0, 1109, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1110, 65, CAST(0x0000A95000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>6</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>2</overtimeHours></ncdetails>', 0, 1110, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1144, 59, CAST(0x0000A94F00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>14</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1144, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1145, 59, CAST(0x0000A95000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>14</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1145, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1146, 59, CAST(0x0000A95100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>6</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1146, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1147, 59, CAST(0x0000A95200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>6</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1147, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1148, 59, CAST(0x0000A95300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1148, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1149, 59, CAST(0x0000A95400000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>14</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1149, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1150, 59, CAST(0x0000A95500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>14</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1150, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1151, 59, CAST(0x0000A95600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>6</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1151, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1152, 59, CAST(0x0000A95700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>3</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>14</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1152, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1153, 59, CAST(0x0000A95800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>7</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1153, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1154, 59, CAST(0x0000A95900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>2</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>14</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1154, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1155, 59, CAST(0x0000A95A00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>2</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>14</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1155, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1156, 59, CAST(0x0000A95B00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>5</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1156, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1157, 59, CAST(0x0000A95C00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>5</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1157, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1158, 59, CAST(0x0000A95D00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>5</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1158, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1159, 59, CAST(0x0000A95E00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>6</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>14</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1159, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1160, 59, CAST(0x0000A95F00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>13</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1160, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1161, 59, CAST(0x0000A96000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>11</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1161, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1162, 59, CAST(0x0000A96100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>13</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>2</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1162, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1163, 59, CAST(0x0000A96200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus>Less than 10 hrs of rest in 24 hrs period</twentyfourhourresthoursstatus><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>7</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>2</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>14</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1163, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1164, 59, CAST(0x0000A96300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>10</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1164, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1165, 59, CAST(0x0000A96400000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus>Less than 10 hrs of rest in 24 hrs period</twentyfourhourresthoursstatus><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>9</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>2</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>13</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1165, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1166, 59, CAST(0x0000A96400000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus>Less than 10 hrs of rest in 24 hrs period</twentyfourhourresthoursstatus><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>9</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>2</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>13</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1166, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1167, 59, CAST(0x0000A96500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>3</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1167, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1168, 59, CAST(0x0000A96600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus>Less than 10 hrs of rest in 24 hrs period</twentyfourhourresthoursstatus><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>8</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>2</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>13</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1168, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1169, 59, CAST(0x0000A96700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>13</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1169, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1170, 59, CAST(0x0000A96800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>13</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1170, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1171, 59, CAST(0x0000A96900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>11</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>5</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>13</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1171, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1172, 59, CAST(0x0000A96A00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>11</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>8</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1172, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1173, 59, CAST(0x0000A96B00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1173, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1174, 61, CAST(0x0000A94E00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>14</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>9</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>10</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1174, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1175, 61, CAST(0x0000A94E00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>14</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>9</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>10</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1175, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1176, 60, CAST(0x0000A94E00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>16</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>13.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>8</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1176, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1177, 60, CAST(0x0000A94E00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>16</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>13.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>8</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1177, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1178, 60, CAST(0x0000A94E00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>16</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>13.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>8</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1178, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1179, 60, CAST(0x0000A94E00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>16</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>13.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>8</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1179, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1180, 60, CAST(0x0000A94E00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>16</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>13.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>8</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1180, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1181, 60, CAST(0x0000A94E00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>16</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>13.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>8</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1181, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1182, 60, CAST(0x0000A94E00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>16</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>13.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>8</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1182, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1183, 60, CAST(0x0000A94E00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>16</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>13.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>8</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1183, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1184, 60, CAST(0x0000A94E00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>16</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>13.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>8</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1184, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1185, 60, CAST(0x0000A94E00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>16</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>13.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>8</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1185, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1186, 60, CAST(0x0000A94E00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>16</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>13.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>8</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1186, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1208, 2, CAST(0x0000A98B00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>20</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>18</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>4</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1208, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1209, 2, CAST(0x0000A98E00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>17</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>15</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>7</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1209, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1210, 2, CAST(0x0000A98C00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>20</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>20</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1210, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1211, 2, CAST(0x0000A98D00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>24</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>24</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>0</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1211, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1214, 6, CAST(0x0000A94F00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>14</totalworkedhours><overtimeHours>14</overtimeHours></ncdetails>', 0, 1214, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1215, 6, CAST(0x0000A95000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>6</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>14</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 1215, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1216, 6, CAST(0x0000A95100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>6</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>2</overtimeHours></ncdetails>', 0, 1216, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1217, 6, CAST(0x0000A95200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>6</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>2</overtimeHours></ncdetails>', 0, 1217, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1218, 6, CAST(0x0000A95300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>8</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>2</overtimeHours></ncdetails>', 0, 1218, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1219, 6, CAST(0x0000A95400000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>200</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>6</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>14</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 1219, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1220, 6, CAST(0x0000A95500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus /><sevendaysstatus>Less than 77 hours of rest in 7 days</sevendaysstatus><twentyfourhourresthoursstatus /><minsevendaysrest>76</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>6</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>14</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 1220, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1221, 6, CAST(0x0000A95600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>79</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>6</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 1221, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1222, 6, CAST(0x0000A95700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>79</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>7</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>14</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 1222, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1223, 6, CAST(0x0000A95800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>80</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>7</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>1</overtimeHours></ncdetails>', 0, 1223, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1224, 6, CAST(0x0000A95900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>78</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>8</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>14</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 1224, 0, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1225, 6, CAST(0x0000A95A00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus /><sevendaysstatus>Less than 77 hours of rest in 7 days</sevendaysstatus><twentyfourhourresthoursstatus /><minsevendaysrest>76</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>8</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>14</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 1225, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1226, 6, CAST(0x0000A95B00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>77</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>6</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>13</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 1226, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1227, 6, CAST(0x0000A95C00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>78</minsevendaysrest><mintwentyfourhoursrest>11</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>6</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>13</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 1227, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1228, 6, CAST(0x0000A95D00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus /><sevendaysstatus>Less than 77 hours of rest in 7 days</sevendaysstatus><twentyfourhourresthoursstatus /><minsevendaysrest>76</minsevendaysrest><mintwentyfourhoursrest>11</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>6</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>13</totalworkedhours><overtimeHours>13</overtimeHours></ncdetails>', 0, 1228, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1229, 6, CAST(0x0000A95E00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus /><sevendaysstatus>Less than 77 hours of rest in 7 days</sevendaysstatus><twentyfourhourresthoursstatus /><minsevendaysrest>76</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>6</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>14</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 1229, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1230, 6, CAST(0x0000A95F00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus>Less than 77 hours of rest in 7 days</sevendaysstatus><twentyfourhourresthoursstatus /><minsevendaysrest>74</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>13</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 1230, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1231, 6, CAST(0x0000A96000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>77</minsevendaysrest><mintwentyfourhoursrest>11</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>1</overtimeHours></ncdetails>', 0, 1231, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1232, 6, CAST(0x0000A96100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus>Less than 10 hrs of rest in 24 hrs period</twentyfourhourresthoursstatus><minsevendaysrest>77</minsevendaysrest><mintwentyfourhoursrest>7</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>2.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>14</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 1232, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1233, 6, CAST(0x0000A96200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus>Less than 77 hours of rest in 7 days</sevendaysstatus><twentyfourhourresthoursstatus /><minsevendaysrest>76</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>14</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 1233, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1234, 6, CAST(0x0000A96300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>77</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>10</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>2</overtimeHours></ncdetails>', 0, 1234, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1235, 6, CAST(0x0000A96400000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus>Less than 10 hrs of rest in 24 hrs period</twentyfourhourresthoursstatus><minsevendaysrest>77</minsevendaysrest><mintwentyfourhoursrest>9</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>3.5</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>13</totalworkedhours><overtimeHours>13</overtimeHours></ncdetails>', 0, 1235, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1236, 6, CAST(0x0000A96500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>83</minsevendaysrest><mintwentyfourhoursrest>11</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>10</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>8</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 1236, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1237, 6, CAST(0x0000A96600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>84</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>6</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>2</overtimeHours></ncdetails>', 0, 1237, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1238, 6, CAST(0x0000A96700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>82</minsevendaysrest><mintwentyfourhoursrest>11</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>6</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>13</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 1238, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1239, 6, CAST(0x0000A96800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>83</minsevendaysrest><mintwentyfourhoursrest>11</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>6</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>13</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 1239, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1240, 6, CAST(0x0000A96900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>84</minsevendaysrest><mintwentyfourhoursrest>11</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>6</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>13</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 1240, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1241, 6, CAST(0x0000A96A00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>83</minsevendaysrest><mintwentyfourhoursrest>11</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>7</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>13</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 1241, 1, 9876543)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC], [VesselID]) VALUES (1242, 6, CAST(0x0000A96B00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>84</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 1242, 1, 9876543)
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
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1064, N'Master Chief', NULL, 18, NULL, 0, CAST(0x0000A96A00CBD31C AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1065, N'Master Chief', NULL, 19, NULL, 0, CAST(0x0000A96A00CE8ABA AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1066, N'Master Chief', NULL, 20, NULL, 0, CAST(0x0000A97F00AFD826 AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1067, N'Master Chief', NULL, 21, NULL, 0, CAST(0x0000A97F00B30357 AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1068, N'Master Chief', NULL, 22, NULL, 0, CAST(0x0000A97F00B84B3E AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1069, N'Master Chief', NULL, 23, NULL, 0, CAST(0x0000A97F00B89C58 AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1070, N'3/O', NULL, 24, NULL, 0, CAST(0x0000A9990151795E AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1071, N'J/O', NULL, 25, NULL, 0, CAST(0x0000A99901518B3A AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1072, N'Ch. Engr', NULL, 26, NULL, 0, CAST(0x0000A99901518C94 AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1073, N'3/engr', NULL, 27, NULL, 0, CAST(0x0000A99901518DDC AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1074, N'AB', NULL, 28, NULL, 0, CAST(0x0000A99901518EF4 AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1075, N'3/O', NULL, 29, NULL, 0, CAST(0x0000A9990154462A AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1076, N'J/O', NULL, 30, NULL, 0, CAST(0x0000A9990154462B AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1077, N'Ch. Engr', NULL, 31, NULL, 0, CAST(0x0000A9990154462B AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1078, N'3/engr', NULL, 32, NULL, 0, CAST(0x0000A9990154462B AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1079, N'AB', NULL, 33, NULL, 0, CAST(0x0000A9990154462C AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1080, N'Oiler', NULL, 34, NULL, 0, CAST(0x0000A9990154462C AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1081, N'Oiler', NULL, 35, NULL, 0, CAST(0x0000A9990154462C AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1082, N'AB', NULL, 36, NULL, 0, CAST(0x0000A9990154462D AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1083, N'OS/security ', NULL, 37, NULL, 0, CAST(0x0000A9990154462D AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1084, N'OS/security ', NULL, 38, NULL, 0, CAST(0x0000A9990154462D AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1085, N'C.Cook', NULL, 39, NULL, 0, CAST(0x0000A9990154462E AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1086, N'2nd Cook', NULL, 40, NULL, 0, CAST(0x0000A9990154462E AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1087, N'3/O', NULL, 41, NULL, 0, CAST(0x0000A9990157F5A7 AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1088, N'J/O', NULL, 42, NULL, 0, CAST(0x0000A9990158127B AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1089, N'Ch. Engr', NULL, 43, NULL, 0, CAST(0x0000A9990158283E AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1090, N'3/engr', NULL, 44, NULL, 0, CAST(0x0000A9990158283E AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1091, N'AB', NULL, 45, NULL, 0, CAST(0x0000A9990158283F AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1092, N'Oiler', NULL, 46, NULL, 0, CAST(0x0000A9990158283F AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1093, N'Oiler', NULL, 47, NULL, 0, CAST(0x0000A9990158283F AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1094, N'AB', NULL, 48, NULL, 0, CAST(0x0000A99901582840 AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1095, N'OS/security ', NULL, 49, NULL, 0, CAST(0x0000A99901582840 AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1096, N'OS/security ', NULL, 50, NULL, 0, CAST(0x0000A99901582840 AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1097, N'C.Cook', NULL, 51, NULL, 0, CAST(0x0000A99901582841 AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1098, N'2nd Cook', NULL, 52, NULL, 0, CAST(0x0000A99901582841 AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1099, N'3/O', NULL, 53, NULL, 0, CAST(0x0000A9990173200B AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1100, N'J/O', NULL, 54, NULL, 0, CAST(0x0000A99901732010 AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1101, N'Ch. Engr', NULL, 55, NULL, 0, CAST(0x0000A99901732010 AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1102, N'3/engr', NULL, 56, NULL, 0, CAST(0x0000A99901732010 AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1103, N'AB', NULL, 57, NULL, 0, CAST(0x0000A99901732010 AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1104, N'Oiler', NULL, 58, NULL, 0, CAST(0x0000A99901732011 AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1105, N'Oiler', NULL, 59, NULL, 0, CAST(0x0000A99901732011 AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1106, N'AB', NULL, 60, NULL, 0, CAST(0x0000A99901732011 AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1107, N'OS/security ', NULL, 61, NULL, 0, CAST(0x0000A99901732011 AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1108, N'OS/security ', NULL, 62, NULL, 0, CAST(0x0000A99901732011 AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1109, N'C.Cook', NULL, 63, NULL, 0, CAST(0x0000A99901732011 AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1110, N'2nd Cook', NULL, 64, NULL, 0, CAST(0x0000A99901732011 AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1111, N'3/O', NULL, 65, NULL, 0, CAST(0x0000A99901870E45 AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1112, N'J/O', NULL, 66, NULL, 0, CAST(0x0000A99901870E48 AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1113, N'3/O', NULL, 67, NULL, 0, CAST(0x0000A9990187BC84 AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1114, N'J/O', NULL, 68, NULL, 0, CAST(0x0000A9990187BC8C AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1115, N'3/O', NULL, 69, NULL, 0, CAST(0x0000A99901886C92 AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1116, N'J/O', NULL, 70, NULL, 0, CAST(0x0000A99901886C99 AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1117, N'Chef', NULL, 71, NULL, 0, CAST(0x0000A99B009E990D AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1118, N'3/O', NULL, 72, NULL, 0, CAST(0x0000A99B009E990E AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1119, N'J/O', NULL, 73, NULL, 0, CAST(0x0000A99B009E990F AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1120, N'Chef', NULL, 74, NULL, 0, CAST(0x0000A99B012F214D AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1121, N'3/O', NULL, 75, NULL, 0, CAST(0x0000A99B012F215C AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1122, N'Chef', NULL, 76, NULL, 0, CAST(0x0000A99B012FF4E8 AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1123, N'3/O', NULL, 77, NULL, 0, CAST(0x0000A99B012FF4EA AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1124, N'J/O', NULL, 78, NULL, 0, CAST(0x0000A99B012FF4EB AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1125, N'Chef', NULL, 79, NULL, 0, CAST(0x0000A99B014C0F3D AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1126, N'3/O', NULL, 80, NULL, 0, CAST(0x0000A99B014C0F44 AS DateTime), NULL, 1, 9876543)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled], [VesselID]) VALUES (1127, N'J/O', NULL, 81, NULL, 0, CAST(0x0000A99B014C0F44 AS DateTime), NULL, 1, 9876543)
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

INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (1, CAST(0x0000A96C00000000 AS DateTime), CAST(0x0000AC6700000000 AS DateTime), 1, NULL, NULL, 1047, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (2, CAST(0x0000A96F00000000 AS DateTime), CAST(0x0000AC6B00000000 AS DateTime), 2, NULL, NULL, 1048, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (3, CAST(0x0000A97000000000 AS DateTime), CAST(0x0000AC6C00000000 AS DateTime), 3, NULL, NULL, 1051, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (4, CAST(0x0000A96F00000000 AS DateTime), CAST(0x0000AC6A00000000 AS DateTime), 4, NULL, NULL, 1051, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (5, CAST(0x0000A97100000000 AS DateTime), CAST(0x0000AC6C00000000 AS DateTime), 5, NULL, NULL, 1062, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (6, CAST(0x0000A93E00000000 AS DateTime), CAST(0x0000A9C700000000 AS DateTime), 6, NULL, NULL, 1063, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (7, CAST(0x0000A96C00000000 AS DateTime), CAST(0x0000A9C700000000 AS DateTime), 7, NULL, NULL, 1049, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (8, CAST(0x0000A98B00000000 AS DateTime), CAST(0x0000A99700000000 AS DateTime), 8, NULL, NULL, 1047, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (9, CAST(0x0000A98B00000000 AS DateTime), CAST(0x0000A98C00000000 AS DateTime), 9, NULL, NULL, 1047, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (10, CAST(0x0000A96C00000000 AS DateTime), CAST(0x0000A99F00000000 AS DateTime), 56, NULL, NULL, 1116, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (11, CAST(0x0000A98B00000000 AS DateTime), CAST(0x0000A99B00000000 AS DateTime), 58, NULL, NULL, 1118, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (12, CAST(0x0000A98B00000000 AS DateTime), CAST(0x0000AC8300000000 AS DateTime), 57, NULL, NULL, 1117, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (13, CAST(0x0000A85B00000000 AS DateTime), CAST(0x0000AC8300000000 AS DateTime), 65, NULL, NULL, 1125, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (14, CAST(0x0000A96C00000000 AS DateTime), CAST(0x0000A9C700000000 AS DateTime), 66, NULL, NULL, 1126, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (15, CAST(0x0000A3B700000000 AS DateTime), CAST(0x0000A99F00000000 AS DateTime), 68, NULL, NULL, 1048, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (16, CAST(0x0000A96C00000000 AS DateTime), CAST(0x0000A9A500000000 AS DateTime), 69, NULL, NULL, 1051, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (17, CAST(0x0000A98B00000000 AS DateTime), CAST(0x0000A9A500000000 AS DateTime), 70, NULL, NULL, 1053, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (18, CAST(0x0000A98B00000000 AS DateTime), CAST(0x0000A9A800000000 AS DateTime), 71, NULL, NULL, 1072, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (19, CAST(0x0000A94E00000000 AS DateTime), CAST(0x0000AC7E00000000 AS DateTime), 72, NULL, NULL, 1054, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (20, CAST(0x0000A98F00000000 AS DateTime), CAST(0x0000B39A00000000 AS DateTime), 73, NULL, NULL, 1050, 0, 9876543)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted], [VesselID]) VALUES (21, CAST(0x0000A98B00000000 AS DateTime), CAST(0x0000A9A800000000 AS DateTime), 74, NULL, NULL, 1049, 0, 9876543)
SET IDENTITY_INSERT [dbo].[ServiceTerms] OFF
SET IDENTITY_INSERT [dbo].[Ship] ON 

INSERT [dbo].[Ship] ([ID], [ShipName], [IMONumber], [FlagOfShip], [Regime], [LastSyncDate], [CompanyID]) VALUES (3014, N'INS Vikramaditya', 9876543, N'India', 2, NULL, 2)
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
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'frompwd', N'Resthours@2018', 0)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'mailfrom', N'tmresthours@gmail.com', 0)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'mailto', N'prasenjitpaul100@hotmail.com', 0)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'port', N'587', 0)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'smtp', N'smtp.gmail.com', 0)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'subject', N'Zip File', 1)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'zipoutputsize', N'1000', 1)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'smtp', N'smtp.gmail.com', 0)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'port', N'587', 0)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'mailfrom', N'tmresthours@gmail.com', 0)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'mailto', N'prasenjitpaul1000@hotmail.com', 0)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'frompwd', N'Resthours@2018', 0)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'smtp', N'smtp.gmail.com', 0)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'port', N'587', 0)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'mailfrom', N'tmresthours@gmail.com', 0)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'mailto', N'prasenjitpaul100@hotmail.com', 0)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'frompwd', N'Resthours@2018', 0)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'dateformat', N'106', 1)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'smtp', N'smtp.gmail.com', 0)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'port', N'587', 0)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'mailfrom', N'tmresthours@gmail.com', 0)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'mailto', N'prasenjitpaul100@hotmail.com', 0)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'frompwd', N'Resthours@2018', 0)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'smtp', N'smtp.gmail.com', 1)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'port', N'587', 1)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'mailfrom', N'tmresthours@gmail.com', 1)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'mailto', N'prasenjitpaul100@hotmail.com', 1)
INSERT [dbo].[tblConfig] ([KeyName], [ConfigValue], [IsActive]) VALUES (N'frompwd', N'Resthours@2018', 1)
SET IDENTITY_INSERT [dbo].[tblEquipments] ON 

INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1311, N'A Das', NULL, N'ok', N'3', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1312, N'D Sen', NULL, NULL, N'9', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1313, N'BASIN EMESIS KIDNEY SHAPE', NULL, NULL, N'1 PC', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1314, N'BAISIN WASH WITH RIM', NULL, NULL, N'1 PC', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1315, N'BEDPAN PVC', NULL, NULL, N'1 PC', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1316, N'URINAL MALE', NULL, NULL, N'1 PC', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1317, N'CRUTCHADJUSTABLE WOOD WITH RUBBER TIP', NULL, NULL, N'1 PAIR', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1318, N'EYE CUP', NULL, NULL, N'2 SET', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1319, N'FUNNEL PLASTIC 12CM', NULL, NULL, N'1 PC', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1320, N'GLASS CYLINDER 50ML', NULL, NULL, N'1 PC', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1321, N'GLASS CYLINDER 500ML', NULL, NULL, N'1 PC', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1322, N'HEATING PAD ELECTRIC AC/DC', NULL, NULL, N'1 PKT', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1323, N'HOT WATER BAG', NULL, NULL, N'1 PC', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1324, N'LITTER STOCKET', NULL, NULL, N'1 SET', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1325, N'MAGNIFYING GLASS 8 LOUPE', NULL, NULL, N'1 PC', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1326, N'NEIL ROBERTSON STRETCHER', NULL, NULL, N'1 SET', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1327, N'REFRIGERATOR AUTOMATIC', NULL, NULL, N'2 SET', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1328, N'CUFFS', NULL, NULL, N'1 PC', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1329, N'MUMMY RESTRAINT', NULL, NULL, N'1 PC', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1330, N'SIDE BOARD', NULL, NULL, N'2 PC', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1331, N'RESUSCITATOR HAND OPERATED', NULL, NULL, N'1 SET', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1332, N'RUBBER INFLATABLE RING PAD', NULL, NULL, N'1 PC', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1333, N'SCALES ADULT WEIGHING 150KG', NULL, NULL, N'1 PC', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1334, N'SPHYGMOMANMETER ANAROID', NULL, NULL, N'1 SET', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1335, N'SPLINTS ARM FOR ABOVE/BELOW 6''S', NULL, NULL, N'1 SET', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1336, N'SPLINTS LEG FOR ABOVE/BELOW KNEE 6''S', NULL, NULL, N'1 SET', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1337, N'SPLINTS FINGER 6''S', NULL, NULL, N'1 SET', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1338, N'STERILIZER STEAM PRESSURE TYPE', NULL, NULL, N'1 SET', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1339, N'STERILIZER WATER TYPE ELECTRIC', NULL, NULL, N'1 SET', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1340, N'STETHOSCOPE DISC DIPHRAM TYPE', NULL, NULL, N'1 PC', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1341, N'THERMOMETER BATH', NULL, NULL, N'2 PC', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1342, N'TRAY WITH COVER', NULL, NULL, N'2 PC', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1343, N'URINAL MALE', NULL, NULL, N'2 PC', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1344, N'RECEPTACLE 12L WITH PEDAL OPERATED', NULL, NULL, N'1 PC', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1345, N'MEDICAL FIRST AID GUIDE', NULL, NULL, N'1 VOL', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1346, N'INT HEALTH REGULATION', NULL, NULL, N'1 VOL', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1347, N'VACCINATION CERTIFICATE', NULL, NULL, N'1 VOL', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1348, N'AIRWAY PHARYGEL PLASTIC 2''S', N'2021-09-01T00:00:00+05:30', NULL, N'2 SET', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1349, N'BLADE SUGICAL KNIFE', N'2019-04-01T00:00:00+05:30', NULL, N'10 PC', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1350, N'BLADE SUGICAL KNIFE 11', N'2019-10-01T00:00:00+05:30', NULL, N'10 PC', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1351, N'FORCEPS DRESSING BAYONET 18CM', NULL, NULL, N'1 PC', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1352, N'FORCEPS HAEMOSTAT CURVED', NULL, NULL, N'2 PC', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1353, N'FORCEPS HAEMOSTAT SPENCER WELLS', NULL, NULL, N'2 PC', N'Top Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1354, N'FORCEPS HAEMOSTAT CURVED KELLY', NULL, NULL, N'2 PC', NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1355, N'FORCEPS SPLINTER TWEEZERS', NULL, NULL, N'1 PC', N'Bottom Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1356, N'FORCEPS TISSUE 13CM', NULL, NULL, N'1 PC', N'Bottom Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1357, N'FORCEPS TISSUE 18CM', NULL, NULL, N'1 PC', N'Bottom Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1358, N'HANDLE KNIFE NO 3', N'2019-11-01T00:00:00+05:30', NULL, N'2 PC', N'Bottom Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1359, N'SCISSORS BANDAGE 20CM', NULL, NULL, N'3 PC', N'Bottom Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1360, N'SCISSORS SURGICAL 15CM', NULL, NULL, N'2 PC', N'Bottom Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1361, N'HAMMER REFLEX TESTING 20CM', NULL, NULL, N'1 PC', N'Bottom Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1362, N'NEEDLE HOLDER 14CM', NULL, NULL, N'2 PC', N'Bottom Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1363, N'ADHESIVE TAPE SUGICAL 5CM X 5M', NULL, NULL, N'6 PKT', N'Bottom Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1364, N'ADHESIVE TAPE SUGICAL 2CM X 5M', N'2019-06-01T00:00:00+05:30', NULL, N'6 PKT', N'Bottom Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1365, N'ADMINSTRATION SET', N'2018-12-01T00:00:00+05:30', NULL, N'6 PKT', N'Bottom Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1366, N'APPLICATOR WOOD 2MM X 15 CM, 40''S', N'2019-02-01T00:00:00+05:30', NULL, N'4 PKT', N'Bottom Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1367, N'BANDAGE ELASTIC COTTON 12''S 10CM X 5M', NULL, NULL, N'1 BOX', N'Bottom Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1368, N'BANDAGE ELASTIC COTTON 8CM X 5M', NULL, NULL, N'1 BOX', N'Bottom Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1369, N'BANDAGE ELASTIC COTTON 5CM X 5M', NULL, NULL, N'0 BOX', N'Bottom Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1370, N'BANDAGE GAUZE 7.5 X 9M, 12 ROLLS-PLY SAFETY PIN', N'2019-05-01T00:00:00+05:30', NULL, N'1 PKT', N'Bottom Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1371, N'BANDAGE COTTON ADHESIVE PLASTER 2.5 X 3.3 M 100''', NULL, NULL, N'1 BOX', N'Bottom Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1372, N'BANDAGE GAUZE ROLLER 10 X 5.4M', N'2019-12-01T00:00:00+05:30', NULL, N'60 ROLL', N'Bottom Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1373, N'BANDAGE GAUZE ROLLER 7.5 X 5.4M', N'2019-05-01T00:00:00+05:30', NULL, N'40 ROLL', N'Bottom Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1374, N'CASUALITY DRESSING ADHESIVE 9 X 6CM', N'2019-02-01T00:00:00+05:30', NULL, N'30 PC', N'Bottom Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1375, N'CASUALITY DRESSING ADHESIVE 18 X 9CM', N'2019-02-01T00:00:00+05:30', NULL, N'20 PC', N'Bottom Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1376, N'BANDAGE TRINGULAR 90 X 130CM', N'2019-05-01T00:00:00+05:30', NULL, N'4 PC', N'Bottom Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1377, N'TUBE GUAGE TYPE BANDAGEFOR FINGERS', N'2019-05-01T00:00:00+05:30', NULL, N'10 PKT', N'Bottom Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1378, N'SPRAY DRESSING 50ML', NULL, NULL, N'4 TIN', N'Bottom Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1379, N'PETROLATUM GUAZE', N'2019-03-01T00:00:00+05:30', NULL, N'20 PKT', N'Bottom Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1380, N'FIRST AID EMERGENCY DRESSING', N'2019-05-01T00:00:00+05:30', NULL, N'10 PKT', N'Bottom Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1381, N'FIRST AID EMERGENCY DRESSING NO .14', N'2019-07-01T00:00:00+05:30', NULL, N'20 PKT', N'Bottom Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1382, N'FIRST AID EMERGENCY DRESSING NO.15', N'2019-05-01T00:00:00+05:30', NULL, N'20 PKT', N'Bottom Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1383, N'PLASTIC BOTTEL 50 ML', NULL, NULL, N'50 BTL', N'Bottom Rack')
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1384, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1385, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1386, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1387, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1388, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1389, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1390, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1391, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1392, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1393, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1394, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1395, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1396, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1397, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1398, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1399, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1400, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1401, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1402, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1403, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1404, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1405, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1406, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1407, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1408, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1409, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1410, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1411, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1412, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1413, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1414, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1415, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1416, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1417, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1418, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1419, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1420, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1421, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1422, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1423, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1424, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1425, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1426, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1427, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1428, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1429, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1430, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1431, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1432, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1433, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1434, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1435, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1436, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1437, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1438, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1439, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1440, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1441, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1442, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1443, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1444, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1445, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1446, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1447, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1448, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1449, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1450, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1451, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1452, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1453, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1454, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1455, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1456, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1457, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1458, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1459, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1460, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1461, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1462, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1463, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1464, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1465, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1466, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1467, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1468, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1469, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblEquipments] ([EquipmentsID], [EquipmentsName], [Comment], [Quantity], [ExpiryDate], [Location]) VALUES (1470, NULL, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[tblEquipments] OFF
SET IDENTITY_INSERT [dbo].[tblMedicine] ON 

INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (1, N'ASPIRIN 500MG , 100TAB', N'6 PKT', N'Dec-1-2018', N'Top Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (2, N'ACICOLOVIR 400 MG TAB', N'70 PCS', N'Jan-1-2019', N'Top Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (3, N'EPHEDRINE, 100TAB - MASTER', N'1 PKT', N'Dec-1-2018', N'Top Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (4, N'ERYTHROMYCINE 250MG, 100CAP', N'3 PKT', N'Sep-1-2019', N'Top Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (5, N'ARTEMETHER AMP 1ML , 80 MG', N'5 PCS', N'Aug-1-2020', N'Top Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (6, N'ARTEMETHER + LUMEFANTRINE TAB 20 MG + 120 MG', N'48 PCS', N'Dec-1-2018', N'Top Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (7, N'ATROPINE INJ 1ML/10 AMP - MASTER', N'6 PKT', N'Aug-1-2019', N'Top Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (8, N'AMINOTHYLINE 100 TAB', N'1 PKT', N'Feb-1-2019', N'Top Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (9, N'CEFTRIAXONE AMP 1 G POWDER FOR INJ', N'45 PCS', N'Feb-1-2019', N'Top Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (10, N'CETRIZINE', N'180 TAB', N'May-1-2019', N'Top Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (11, N'CHARCOAL ACTIVATED 120G POWDER', N'1 PKT', N'Jan-1-2019', N'Top Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (12, N'CIPROFLOXACIN TAB 250 MG', N'0', N'Nov-1-2019', N'Top Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (13, N'CLOVE OIL 3ML', N'8 BTL', N'Jan-1-2019', N'Top Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (14, N'CLOVE OIL 3ML', N'3 BTL', N'Mar-1-2020', N'Top Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (15, N'EPINEPHRINE INJ 1:1000, 10AMP - MASTER', N'2 PKT', N'Nov-1-2019', N'Top Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (16, N'DECADROM , ( Tetracycline HCL tab)', N'120 PCS', N'Jun-15-2019', N'Top Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (17, N'DIAZEPAM, 100TAB - (Chlorpromazine HCL tab) MASTER', N'400 TAB', N'Nov-1-2019', NULL)
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (18, N'DUCUSATE WITH SENNA TAB', N'100 PCS', N'Dec-1-2019', N'Bottom Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (19, N'TETRACYCLINE 250MG , 100 CAP', N'3 PKT', N'Nov-1-2018', N'Bottom Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (20, N'ETHANOL 70 % GEL, 500 ML', N'6 BTL', N'Nov-1-2020', N'Bottom Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (21, N'DISINFECTANT SOL FOR MEDICAL INSTRUMENTS 1000ML', N'1 PCS', N'Jan-1-2019', N'Bottom Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (22, N'FLUORESCEIN SODIUM EYE STRIP, 100S', N'1 PKT', N'Feb-1-2019', N'Bottom Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (23, N'FUROSEMIDE 40MG, 100TAB', N'1 PKT', N'Mar-1-2019', N'Bottom Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (24, N'GLUCAGON AMP 1 MG', N'1 PCS', N'Mar-1-2019', N'Bottom Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (25, N'CHLORPHENAMINE INJ, 20 AMP - MASTER', N'1 PKT', N'Feb-1-2019', N'Bottom Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (26, N'HYDROCORTISONE OINT 10G', N'4 TUB', N'Dec-1-2018', N'Bottom Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (27, N'HYDROCORTISONE OINT 15G', N'6 TUB', N'Nov-1-2018', N'Bottom Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (28, N'IBUPROFEN 400 MG', N'300 TAB', N'Aug-1-2020', N'Bottom Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (29, N'ISOSORBIDE DINITRATE TAB 5MG SUBLINGULA - MASTER', N'100 PCS', N'May-1-2019', N'Bottom Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (30, N'LIDOCAINE INJ AMP', N'12 BTL', N'Dec-1-2019', N'Bottom Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (31, N'LIDOCANE HCL 2%', N'10 AMP', N'Jul-1-2019', N'Bottom Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (32, N'LIDOCAINE CREAM 25G', N'1 BTL', N'Apr-1-2019', N'Bottom Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (33, N'IMODIUM , LOPERIMIDE-WSM', N'38 PCS', N'Jun-1-2019', N'Bottom Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (34, N'METOPROLOL 100 MG', N'60 PCS', N'Feb-1-2020', N'Bottom Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (35, N'METRONIDAZOLE 250MG, 100TAB', N'5 BTL', N'Jan-1-2020', N'Bottom Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (36, N'MICONAZOLE VAGINAL CREAM 20G', N'1 TUB', N'Aug-1-2019', N'Bottom Rack')
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (37, N'PESSARIES CONTAINING POVIDONE IODINE 200 MG', N'6 PCS', N'Nov-1-2020', NULL)
INSERT [dbo].[tblMedicine] ([MedicineID], [MedicineName], [Quantity], [ExpiryDate], [Location]) VALUES (73, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[tblMedicine] OFF
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (5, CAST(0x0000A99200000000 AS DateTime), 1, 9876543, CAST(0x002D247F00000000 AS DateTime))
SET IDENTITY_INSERT [dbo].[UserGroups] ON 

INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (1, 1, 13, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (2, 2, 15, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (3, 3, 14, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (4, 4, 15, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (5, 5, 15, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (7, 6, 15, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (8, 7, 15, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (9, 8, 14, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (10, 9, 14, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (11, 10, 14, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (12, 11, 15, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (13, 12, 14, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (14, 13, 14, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (16, 15, 14, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (17, 16, 15, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (18, 17, 15, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (19, 18, 15, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (20, 19, 15, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (21, 20, 15, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (22, 21, 14, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (23, 14, 14, 9876543)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID], [VesselID]) VALUES (24, 22, 15, 9876543)
SET IDENTITY_INSERT [dbo].[UserGroups] OFF
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (1, N'sa', N'12345', 1, 1, NULL, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (2, N'YesDes65', N'12345', 1, 1, 1, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (3, N'ManKum78', N'12345', 1, 1, 2, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (4, N'KesHer83', N'12345', 1, 1, 3, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (5, N'OlgOli97', N'12345', 1, 1, 4, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (6, N'MusMus89', N'12345', 1, 1, 5, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (7, N'RocSin86', N'12345', 1, 1, 6, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (8, N'PraMod95', N'12345', 1, 1, 7, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (9, N'NirMod42', N'12345', 1, 1, 8, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (10, N'GivFam82', N'12345', 1, 1, 9, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (11, N'PraSat71', N'12345', 1, 1, 56, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (12, N'MilWad27', N'12345', 1, 1, 58, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (13, N'RavRan87', N'12345', 1, 1, 57, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (14, N'JohWoo72', N'12345', 1, 1, 65, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (15, N'JohDoe41', N'12345', 1, 1, 66, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (16, N'JohWoo720', N'12345', 1, 1, 68, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (17, N'YesDes650', N'12345', 1, 1, 69, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (18, N'YesDes651', N'12345', 1, 1, 70, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (19, N'YesDes652', N'12345', 1, 1, 71, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (20, N'MasPer23', N'56789', 1, 1, 72, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (21, N'YesDes653', N'12345', 1, 1, 73, 9876543)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId], [VesselID]) VALUES (22, N'HarCoo52', N'12345', 1, 1, 74, 9876543)
SET IDENTITY_INSERT [dbo].[Users] OFF
INSERT [dbo].[WorkingHours] ([DayNumber], [RegimeID], [WorkHours]) VALUES (1, 2, 8)
INSERT [dbo].[WorkingHours] ([DayNumber], [RegimeID], [WorkHours]) VALUES (2, 2, 8)
INSERT [dbo].[WorkingHours] ([DayNumber], [RegimeID], [WorkHours]) VALUES (3, 2, 8)
INSERT [dbo].[WorkingHours] ([DayNumber], [RegimeID], [WorkHours]) VALUES (4, 2, 8)
INSERT [dbo].[WorkingHours] ([DayNumber], [RegimeID], [WorkHours]) VALUES (5, 2, 8)
INSERT [dbo].[WorkingHours] ([DayNumber], [RegimeID], [WorkHours]) VALUES (6, 2, 4)
INSERT [dbo].[WorkingHours] ([DayNumber], [RegimeID], [WorkHours]) VALUES (7, 2, 0)
SET IDENTITY_INSERT [dbo].[WorkSessions] ON 

INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1, 3, CAST(0x0000A98F00000000 AS DateTime), N'000000000000111111111111111111110000000000000000', 0, N'test comments', CAST(0x0000A9960086F51F AS DateTime), 1, N'0600,1600', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (2, 3, CAST(0x0000A99200000000 AS DateTime), N'000000000000000000111111111111111111111100111100', 0, N'', CAST(0x0000A99C01045DC8 AS DateTime), 1, N'0900,2000,2100,2300', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (3, 3, CAST(0x0000A98400000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9930003DD34 AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (4, 3, CAST(0x0000A98500000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9930003DD35 AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (5, 3, CAST(0x0000A98600000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9930003DD37 AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (6, 3, CAST(0x0000A98700000000 AS DateTime), N'000000000000000000000000111111111111111111111000', 0, N'', CAST(0x0000A9930004D2CB AS DateTime), 1, N'1200,2230', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (7, 3, CAST(0x0000A98800000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9930004D2DB AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (8, 3, CAST(0x0000A98900000000 AS DateTime), N'001111111111111111111111110001100011111111110000', 0, N'', CAST(0x0000A9930004FADB AS DateTime), 1, N'0100,1300,1430,1530,1700,2200', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (9, 3, CAST(0x0000A98A00000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9930004FAE4 AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (10, 3, CAST(0x0000A98B00000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9930004FAE6 AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (11, 3, CAST(0x0000A98C00000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9930004FAE8 AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (12, 3, CAST(0x0000A98D00000000 AS DateTime), N'000000000000111111111111111111111000000000000000', 0, N'', CAST(0x0000A9930004FAE9 AS DateTime), 1, N'0600,1630', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (13, 3, CAST(0x0000A98E00000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9930004FAEA AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (14, 3, CAST(0x0000A99000000000 AS DateTime), N'001111111111111000000000000000000000000000000000', 0, N'', CAST(0x0000A99C01045D93 AS DateTime), 1, N'0100,0730', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (15, 3, CAST(0x0000A99100000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A99C01045DC0 AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (16, 3, CAST(0x0000A99300000000 AS DateTime), N'000011111111111111111111111111000000000000000000', 0, N'', CAST(0x0000A99C01045DCA AS DateTime), 1, N'0200,1500', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (17, 3, CAST(0x0000A97F00000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9930004BA16 AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (18, 3, CAST(0x0000A98000000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9930004BA17 AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (19, 3, CAST(0x0000A98100000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9930004BA26 AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (20, 3, CAST(0x0000A98200000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9930004BA30 AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (21, 3, CAST(0x0000A98300000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9930004BA32 AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (22, 3, CAST(0x0000A97900000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9930004D2CD AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (23, 3, CAST(0x0000A97A00000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9930004D2CE AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (24, 3, CAST(0x0000A97B00000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9930004D2D0 AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (25, 3, CAST(0x0000A97C00000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9930004D2D1 AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (26, 3, CAST(0x0000A97D00000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9930004D2D2 AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (27, 3, CAST(0x0000A97E00000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9930004D2D3 AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (28, 1, CAST(0x0000A96C00000000 AS DateTime), N'000111111100000000000000000000000000000000000000', 0, N'', CAST(0x0000A9950148A5C2 AS DateTime), 1, N'0130,0500', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (29, 1, CAST(0x0000A96D00000000 AS DateTime), N'000000000011111111111111111111000000000000000000', 0, N'', CAST(0x0000A9950148C086 AS DateTime), 1, N'0500,1500', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (30, 1, CAST(0x0000A95F00000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9950148B1AA AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (31, 1, CAST(0x0000A96000000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9950148B1AC AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (32, 1, CAST(0x0000A96100000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9950148B1B2 AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (33, 1, CAST(0x0000A96200000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9950148B1B4 AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (34, 1, CAST(0x0000A96300000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9950148B1B6 AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (35, 1, CAST(0x0000A96400000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9950148B1B9 AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (36, 1, CAST(0x0000A96500000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9950148B1BB AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (37, 1, CAST(0x0000A96600000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9950148B1BE AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (38, 1, CAST(0x0000A96700000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9950148B1C0 AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (39, 1, CAST(0x0000A96800000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9950148B1C2 AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (40, 1, CAST(0x0000A96900000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9950148B1C8 AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (41, 1, CAST(0x0000A96A00000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9950148B1CA AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (42, 1, CAST(0x0000A96B00000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9950148B1CC AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (43, 1, CAST(0x0000A96E00000000 AS DateTime), N'000000001000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9950148CFE6 AS DateTime), 1, N'0400,0430', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (44, 1, CAST(0x0000A96F00000000 AS DateTime), N'000000000000001000000000000000000000000000000000', 0, N'', CAST(0x0000A9950148DD36 AS DateTime), 1, N'0700,0730', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (45, 1, CAST(0x0000A97000000000 AS DateTime), N'000000001000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9950148EB13 AS DateTime), 1, N'0400,0430', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (46, 1, CAST(0x0000A97100000000 AS DateTime), N'000010000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A995014902A1 AS DateTime), 1, N'0200,0230', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (47, 1, CAST(0x0000A97200000000 AS DateTime), N'000011111111111111110000000000000000000000000000', 0, N'test', CAST(0x0000A99F0004AD42 AS DateTime), 1, N'0200,1000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (48, 1, CAST(0x0000A97300000000 AS DateTime), N'001111111111111111110000000000000000000000000000', 0, N'', CAST(0x0000A99F0004AD5A AS DateTime), 1, N'0100,1000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (49, 1, CAST(0x0000A97400000000 AS DateTime), N'000000001111111111111111111100000000000000000000', 0, N'', CAST(0x0000A99F0004AD5C AS DateTime), 1, N'0400,1400', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (50, 1, CAST(0x0000A97500000000 AS DateTime), N'001111111100000000000000000000000000000000000000', 0, N'', CAST(0x0000A99F0004AD5D AS DateTime), 1, N'0100,0500', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (51, 1, CAST(0x0000A97600000000 AS DateTime), N'011110000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A99F0004AD5F AS DateTime), 1, N'0030,0230', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (52, 1, CAST(0x0000A97700000000 AS DateTime), N'011110000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A99F0004AD60 AS DateTime), 1, N'0030,0230', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (53, 1, CAST(0x0000A97800000000 AS DateTime), N'011110000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A99F0004AD62 AS DateTime), 1, N'0030,0230', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (54, 1, CAST(0x0000A97900000000 AS DateTime), N'001111111111111111110000000000000000000000000000', 0, N'', CAST(0x0000A99501499824 AS DateTime), 1, N'0100,1000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (55, 1, CAST(0x0000A97A00000000 AS DateTime), N'000011111111111111111111000000000000000000000000', 0, N'', CAST(0x0000A9950149B5CA AS DateTime), 1, N'0200,1200', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (56, 1, CAST(0x0000A97B00000000 AS DateTime), N'001111111111111111110000000000000000000000000000', 0, N'', CAST(0x0000A995014A834F AS DateTime), 1, N'0100,1000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (57, 1, CAST(0x0000A97C00000000 AS DateTime), N'000000000000000000001111000000000000000000000000', 0, N'', CAST(0x0000A995014A8C13 AS DateTime), 1, N'1000,1200', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (58, 1, CAST(0x0000A97D00000000 AS DateTime), N'000000001111111111111111111100000000000000000000', 0, N'', CAST(0x0000A995014A96A3 AS DateTime), 1, N'0400,1400', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (59, 1, CAST(0x0000A97E00000000 AS DateTime), N'000000000010000000000000000000000000000000000000', 0, N'', CAST(0x0000A995014AA109 AS DateTime), 1, N'0500,0530', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (60, 1, CAST(0x0000A97F00000000 AS DateTime), N'111111100000000000000000000000000000000000000000', 0, N'', CAST(0x0000A995014AB414 AS DateTime), 1, N'0000,0330', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (61, 1, CAST(0x0000A98000000000 AS DateTime), N'011110000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A995014AC385 AS DateTime), 1, N'0030,0230', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (62, 1, CAST(0x0000A98100000000 AS DateTime), N'001111111111111111110000000000000000000000000000', 0, N'', CAST(0x0000A995014ACCD1 AS DateTime), 1, N'0100,1000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (63, 1, CAST(0x0000A98200000000 AS DateTime), N'001111111111111111110000000000000000000000000000', 0, N'', CAST(0x0000A995014AD72F AS DateTime), 1, N'0100,1000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (64, 1, CAST(0x0000A98300000000 AS DateTime), N'001000000011111111111111111111111111111111010000', 0, N'', CAST(0x0000A99F00072DC4 AS DateTime), 1, N'0100,0130,0500,2100,2130,2200', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (65, 1, CAST(0x0000A98400000000 AS DateTime), N'000000000000000000001111000000000000000000000000', 0, N'', CAST(0x0000A99F00072EC5 AS DateTime), 1, N'1000,1200', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (66, 1, CAST(0x0000A98500000000 AS DateTime), N'000011110000000000000000000000000000000000000000', 0, N'', CAST(0x0000A99F000731C0 AS DateTime), 1, N'0200,0400', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (67, 1, CAST(0x0000A98600000000 AS DateTime), N'000000001100000000000000000000000000000000000000', 0, N'', CAST(0x0000A99F000731C2 AS DateTime), 1, N'0400,0500', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (68, 1, CAST(0x0000A98700000000 AS DateTime), N'001111111111111111110000000000000000000000000000', 0, N'', CAST(0x0000A99F000731C4 AS DateTime), 1, N'0100,1000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (69, 1, CAST(0x0000A98800000000 AS DateTime), N'000010000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A99F000731C5 AS DateTime), 1, N'0200,0230', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (70, 1, CAST(0x0000A98900000000 AS DateTime), N'000000000000000000000000111100000000000000000000', 0, N'', CAST(0x0000A99F000731C6 AS DateTime), 1, N'1200,1400', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (71, 1, CAST(0x0000A98A00000000 AS DateTime), N'000011111111111111111111000000000000000000000000', 0, N'', CAST(0x0000A995014DB1CC AS DateTime), 1, N'0200,1200', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (72, 2, CAST(0x0000A99000000000 AS DateTime), N'000000000000000000000000000000111111111111000000', 0, N'', CAST(0x0000A9A400AA7617 AS DateTime), 1, N'1500,2100', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1073, 4, CAST(0x0000A98C00000000 AS DateTime), N'000011111111110000000011111111111111111100000000', 0, N'', CAST(0x0000A999000AD9C8 AS DateTime), 1, N'0200,0700,1100,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1074, 4, CAST(0x0000A98D00000000 AS DateTime), N'000011111111110000000011111111111111111100000000', 0, N'', CAST(0x0000A999000AEE3A AS DateTime), 1, N'0200,0700,1100,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1075, 4, CAST(0x0000A98E00000000 AS DateTime), N'000011111111111100000000001111111111111100000000', 0, N'', CAST(0x0000A999008CCC19 AS DateTime), 1, N'0200,0800,1300,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1076, 4, CAST(0x0000A98F00000000 AS DateTime), N'000011111111110000000011111111111111000000000000', 0, N'', CAST(0x0000A999008CCC1F AS DateTime), 1, N'0200,0700,1100,1800', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1077, 4, CAST(0x0000A99000000000 AS DateTime), N'000011111111110000000011111111111111000000000000', 0, N'', CAST(0x0000A999008CCC21 AS DateTime), 1, N'0200,0700,1100,1800', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1078, 4, CAST(0x0000A99100000000 AS DateTime), N'000011111111110000000011111111111111111111000000', 0, N'', CAST(0x0000A999008E36F8 AS DateTime), 1, N'0200,0700,1100,2100', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1079, 4, CAST(0x0000A99200000000 AS DateTime), N'000011111111110000000011111111111111111100000000', 0, N'', CAST(0x0000A999008E3994 AS DateTime), 1, N'0200,0700,1100,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1080, 1, CAST(0x0000A99F00000000 AS DateTime), N'000000000000000000000000111111100000000000000000', 0, N'', CAST(0x0000A9A00095AD68 AS DateTime), 1, N'1200,1530', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1081, 5, CAST(0x0000A98B00000000 AS DateTime), N'001100000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9A301450B06 AS DateTime), 1, N'0100,0200', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1082, 5, CAST(0x0000A98C00000000 AS DateTime), N'000010000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9A3014514B0 AS DateTime), 1, N'0200,0230', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1083, 5, CAST(0x0000A98D00000000 AS DateTime), N'011111111111000000000000000000000000000000000000', 0, N'', CAST(0x0000A9A301457C1C AS DateTime), 1, N'0030,0600', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1084, 5, CAST(0x0000A98E00000000 AS DateTime), N'000000000000111111111111111111000000000000000000', 0, N'', CAST(0x0000A9A3014585D2 AS DateTime), 1, N'0600,1500', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1085, 5, CAST(0x0000A98F00000000 AS DateTime), N'001110000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9A301460211 AS DateTime), 1, N'0100,0230', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1086, 5, CAST(0x0000A99000000000 AS DateTime), N'000000000000111111111111111111110000000000000000', 0, N'', CAST(0x0000A9A301460BC8 AS DateTime), 1, N'0600,1600', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1087, 5, CAST(0x0000A99100000000 AS DateTime), N'000000000000111111111111111111111111111111111100', 0, N'', CAST(0x0000A9A301462E71 AS DateTime), 1, N'0600,2300', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1088, 5, CAST(0x0000A99200000000 AS DateTime), N'000010000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9A3014655F0 AS DateTime), 1, N'0200,0230', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1089, 5, CAST(0x0000A99300000000 AS DateTime), N'000001000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9A301469143 AS DateTime), 1, N'0230,0300', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1090, 5, CAST(0x0000A99400000000 AS DateTime), N'001100000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9A30146B0B8 AS DateTime), 1, N'0100,0200', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1091, 5, CAST(0x0000A99500000000 AS DateTime), N'010000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9A30146D2D9 AS DateTime), 1, N'0030,0100', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1092, 5, CAST(0x0000A99600000000 AS DateTime), N'000000001100000000000000000000000000000000000000', 0, N'', CAST(0x0000A9A301473266 AS DateTime), 1, N'0400,0500', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1093, 5, CAST(0x0000A99700000000 AS DateTime), N'000000000000110000000000000000000000000000000000', 0, N'', CAST(0x0000A9A301473DBA AS DateTime), 1, N'0600,0700', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1094, 5, CAST(0x0000A99800000000 AS DateTime), N'000000000000000010000000000000000000000000000000', 0, N'', CAST(0x0000A9A301474C54 AS DateTime), 1, N'0800,0830', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1095, 5, CAST(0x0000A99900000000 AS DateTime), N'000000001000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9A301475EB7 AS DateTime), 1, N'0400,0430', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1096, 5, CAST(0x0000A99A00000000 AS DateTime), N'000000000000000000000000000011100000000000000000', 0, N'', CAST(0x0000A9A301476CC7 AS DateTime), 1, N'1400,1530', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1097, 5, CAST(0x0000A99B00000000 AS DateTime), N'000010000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9A301478739 AS DateTime), 1, N'0200,0230', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1098, 5, CAST(0x0000A99B00000000 AS DateTime), N'000010000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9A30147874B AS DateTime), 1, N'0200,0230', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1099, 5, CAST(0x0000A99D00000000 AS DateTime), N'001100000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9A30147A21A AS DateTime), 1, N'0100,0200', NULL, N'0', 9876543, 2)
GO
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1100, 5, CAST(0x0000A99C00000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9A30147A22A AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1101, 5, CAST(0x0000A99E00000000 AS DateTime), N'000010000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9A30147AE8F AS DateTime), 1, N'0200,0230', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1102, 5, CAST(0x0000A99F00000000 AS DateTime), N'000000000000000000000000110000000000000000000000', 0, N'', CAST(0x0000A9A30147BF2E AS DateTime), 1, N'1200,1300', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1103, 5, CAST(0x0000A9A000000000 AS DateTime), N'000000000000000000000000000011000000000000000000', 0, N'', CAST(0x0000A9A30147CE97 AS DateTime), 1, N'1400,1500', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1104, 5, CAST(0x0000A9A100000000 AS DateTime), N'000000000000000000000000110000000000000000000000', 0, N'', CAST(0x0000A9A30147DA88 AS DateTime), 1, N'1200,1300', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1105, 5, CAST(0x0000A9A200000000 AS DateTime), N'000000000000000000000010000000000000000000000000', 0, N'', CAST(0x0000A9A30147E670 AS DateTime), 1, N'1100,1130', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1106, 65, CAST(0x0000A94E00000000 AS DateTime), N'000011111111110000000011111111111111111100000000', 0, N'', CAST(0x0000A9A3015987D9 AS DateTime), 1, N'0200,0700,1100,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1107, 65, CAST(0x0000A94E00000000 AS DateTime), N'000011111111110000000011111111111111111100000000', 0, N'', CAST(0x0000A9A30159BCB6 AS DateTime), 1, N'0200,0700,1100,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1108, 65, CAST(0x0000A94E00000000 AS DateTime), N'000011111111110000000011111111111111111100000000', 0, N'', CAST(0x0000A9A301593845 AS DateTime), 1, N'0200,0700,1100,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1109, 65, CAST(0x0000A94F00000000 AS DateTime), N'000011111111110000000011111111111111111100000000', 0, N'', CAST(0x0000A9A30159FB5B AS DateTime), 1, N'0200,0700,1100,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1110, 65, CAST(0x0000A95000000000 AS DateTime), N'000011111111110000000000001111111111111100000000', 0, N'', CAST(0x0000A9A3015A4CAC AS DateTime), 1, N'0200,0700,1300,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1144, 59, CAST(0x0000A94F00000000 AS DateTime), N'000011111111110000000011111111111111111100000000', 0, N'', CAST(0x0000A9A4007BA41D AS DateTime), 1, N'0200,0700,1100,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1145, 59, CAST(0x0000A95000000000 AS DateTime), N'000011111111110000000011111111111111111100000000', 0, N'', CAST(0x0000A9A4007BC510 AS DateTime), 1, N'0200,0700,1100,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1146, 59, CAST(0x0000A95100000000 AS DateTime), N'000011111111110000000000001111111111111100000000', 0, N'', CAST(0x0000A9A4007BF2B7 AS DateTime), 1, N'0200,0700,1300,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1147, 59, CAST(0x0000A95200000000 AS DateTime), N'000011111111110000000011111111111111000000000000', 0, N'', CAST(0x0000A9A4007C4E27 AS DateTime), 1, N'0200,0700,1100,1800', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1148, 59, CAST(0x0000A95300000000 AS DateTime), N'000011111111110000000011111111111111000000000000', 0, N'', CAST(0x0000A9A4007C8010 AS DateTime), 1, N'0200,0700,1100,1800', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1149, 59, CAST(0x0000A95400000000 AS DateTime), N'000011111111110000000011111111111111111100000000', 0, N'', CAST(0x0000A9A4007CF3CC AS DateTime), 1, N'0200,0700,1100,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1150, 59, CAST(0x0000A95500000000 AS DateTime), N'000011111111110000000011111111111111111100000000', 0, N'', CAST(0x0000A9A400884218 AS DateTime), 1, N'0200,0700,1100,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1151, 59, CAST(0x0000A95600000000 AS DateTime), N'000011111111110000000011111111111100000000000000', 0, N'', CAST(0x0000A9A40088421E AS DateTime), 1, N'0200,0700,1100,1700', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1152, 59, CAST(0x0000A95700000000 AS DateTime), N'000011111111110000001111111111111111110000000000', 0, N'', CAST(0x0000A9A400884220 AS DateTime), 1, N'0200,0700,1000,1900', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1153, 59, CAST(0x0000A95800000000 AS DateTime), N'000011111111110000001111111111110000000000000000', 0, N'', CAST(0x0000A9A400884222 AS DateTime), 1, N'0200,0700,1000,1600', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1154, 59, CAST(0x0000A95900000000 AS DateTime), N'000011111111110000111111111111111111000000000000', 0, N'', CAST(0x0000A9A400884224 AS DateTime), 1, N'0200,0700,0900,1800', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1155, 59, CAST(0x0000A95A00000000 AS DateTime), N'000011111111110000111111111111111111000000000000', 0, N'', CAST(0x0000A9A400884226 AS DateTime), 1, N'0200,0700,0900,1800', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1156, 59, CAST(0x0000A95B00000000 AS DateTime), N'000011111111110000000000111111111111110000000000', 0, N'', CAST(0x0000A9A400884229 AS DateTime), 1, N'0200,0700,1200,1900', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1157, 59, CAST(0x0000A95C00000000 AS DateTime), N'000011111111110000000000111111111111110000000000', 0, N'', CAST(0x0000A9A400836EC9 AS DateTime), 1, N'0200,0700,1200,1900', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1158, 59, CAST(0x0000A95D00000000 AS DateTime), N'000011111111110000000000111111111111110000000000', 0, N'', CAST(0x0000A9A400838F99 AS DateTime), 1, N'0200,0700,1200,1900', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1159, 59, CAST(0x0000A95E00000000 AS DateTime), N'000011111111110000000000001111111111111111110000', 0, N'', CAST(0x0000A9A40083E85D AS DateTime), 1, N'0200,0700,1300,2200', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1160, 59, CAST(0x0000A95F00000000 AS DateTime), N'000011111111110000000000000011111111111111110000', 0, N'', CAST(0x0000A9A40084079F AS DateTime), 1, N'0200,0700,1400,2200', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1161, 59, CAST(0x0000A96000000000 AS DateTime), N'000011111111110000000000000000000000111111111111', 0, N'', CAST(0x0000A9A400844433 AS DateTime), 1, N'0200,0700,1800,2400', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1162, 59, CAST(0x0000A96100000000 AS DateTime), N'000011111111110000000000000000000000111111111111', 0, N'', CAST(0x0000A9A4008474D6 AS DateTime), 1, N'0200,0700,1800,2400', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1163, 59, CAST(0x0000A96200000000 AS DateTime), N'000011111111111111111111110000000000000000111111', 0, N'', CAST(0x0000A9A40084CA01 AS DateTime), 1, N'0200,1300,2100,2400', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1164, 59, CAST(0x0000A96300000000 AS DateTime), N'000011111111110000000000000000000011111111111111', 0, N'', CAST(0x0000A9A40084FEFD AS DateTime), 1, N'0200,0700,1700,2400', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1165, 59, CAST(0x0000A96400000000 AS DateTime), N'000011111111111111110000000000000000001111111111', 0, N'', CAST(0x0000A9A400852A7D AS DateTime), 1, N'0200,1000,1900,2400', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1166, 59, CAST(0x0000A96400000000 AS DateTime), N'000011111111111111110000000000000000001111111111', 0, N'', CAST(0x0000A9A400852AF9 AS DateTime), 1, N'0200,1000,1900,2400', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1167, 59, CAST(0x0000A96500000000 AS DateTime), N'000011111111110000000000000000111111111111000000', 0, N'', CAST(0x0000A9A400856EE7 AS DateTime), 1, N'0200,0700,1500,2100', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1168, 59, CAST(0x0000A96600000000 AS DateTime), N'000011111111111111111100000000000011111111000000', 0, N'', CAST(0x0000A9A40085A3EE AS DateTime), 1, N'0200,1100,1700,2100', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1169, 59, CAST(0x0000A96700000000 AS DateTime), N'000011111111110000000000111111111111111100000000', 0, N'', CAST(0x0000A9A40085C0D2 AS DateTime), 1, N'0200,0700,1200,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1170, 59, CAST(0x0000A96800000000 AS DateTime), N'000011111111110000000000111111111111111100000000', 0, N'', CAST(0x0000A9A40085E7C7 AS DateTime), 1, N'0200,0700,1200,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1171, 59, CAST(0x0000A96900000000 AS DateTime), N'000011111111110000000000111111111111111100000000', 0, N'', CAST(0x0000A9A400861C54 AS DateTime), 1, N'0200,0700,1200,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1172, 59, CAST(0x0000A96A00000000 AS DateTime), N'000011111111110000000000000000111111111111110000', 0, N'', CAST(0x0000A9A400864BA9 AS DateTime), 1, N'0200,0700,1500,2200', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1173, 59, CAST(0x0000A96B00000000 AS DateTime), N'000011111111110000000000001111111111111100000000', 0, N'', CAST(0x0000A9A400868661 AS DateTime), 1, N'0200,0700,1300,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1174, 61, CAST(0x0000A94E00000000 AS DateTime), N'000000000011111111111111111111000000000000000000', 0, N'', CAST(0x0000A9A4008C5773 AS DateTime), 1, N'0500,1500', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1175, 61, CAST(0x0000A94E00000000 AS DateTime), N'000000000011111111111111111111000000000000000000', 0, N'', CAST(0x0000A9A4008C5822 AS DateTime), 1, N'0500,1500', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1176, 60, CAST(0x0000A94E00000000 AS DateTime), N'000001111111111111111000000000000000000000000000', 0, N'', CAST(0x0000A9A4008D00D0 AS DateTime), 1, N'0230,1030', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1177, 60, CAST(0x0000A94E00000000 AS DateTime), N'000001111111111111111000000000000000000000000000', 0, N'', CAST(0x0000A9A4008D0112 AS DateTime), 1, N'0230,1030', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1178, 60, CAST(0x0000A94E00000000 AS DateTime), N'000001111111111111111000000000000000000000000000', 0, N'', CAST(0x0000A9A4008D0145 AS DateTime), 1, N'0230,1030', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1179, 60, CAST(0x0000A94E00000000 AS DateTime), N'000001111111111111111000000000000000000000000000', 0, N'', CAST(0x0000A9A4008D4E95 AS DateTime), 1, N'0230,1030', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1180, 60, CAST(0x0000A94E00000000 AS DateTime), N'000001111111111111111000000000000000000000000000', 0, N'', CAST(0x0000A9A4008D4F4D AS DateTime), 1, N'0230,1030', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1181, 60, CAST(0x0000A94E00000000 AS DateTime), N'000001111111111111111000000000000000000000000000', 0, N'', CAST(0x0000A9A4008D505E AS DateTime), 1, N'0230,1030', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1182, 60, CAST(0x0000A94E00000000 AS DateTime), N'000001111111111111111000000000000000000000000000', 0, N'', CAST(0x0000A9A4008D52A0 AS DateTime), 1, N'0230,1030', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1183, 60, CAST(0x0000A94E00000000 AS DateTime), N'000001111111111111111000000000000000000000000000', 0, N'', CAST(0x0000A9A4008D5709 AS DateTime), 1, N'0230,1030', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1184, 60, CAST(0x0000A94E00000000 AS DateTime), N'000001111111111111111000000000000000000000000000', 0, N'', CAST(0x0000A9A4008D582C AS DateTime), 1, N'0230,1030', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1185, 60, CAST(0x0000A94E00000000 AS DateTime), N'000001111111111111111000000000000000000000000000', 0, N'', CAST(0x0000A9A4008D5A06 AS DateTime), 1, N'0230,1030', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1186, 60, CAST(0x0000A94E00000000 AS DateTime), N'000001111111111111111000000000000000000000000000', 0, N'', CAST(0x0000A9A4008D6128 AS DateTime), 1, N'0230,1030', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1208, 2, CAST(0x0000A98B00000000 AS DateTime), N'000011111111000000000000000000000000000000000000', 0, N'', CAST(0x0000A9A400A8DFB9 AS DateTime), 1, N'0200,0600', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1209, 2, CAST(0x0000A98E00000000 AS DateTime), N'000011111111111111000000000000000000000000000000', 0, N'', CAST(0x0000A9A400AA7613 AS DateTime), 1, N'0200,0900', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1210, 2, CAST(0x0000A98C00000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9A400AA7055 AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1211, 2, CAST(0x0000A98D00000000 AS DateTime), N'000000000000000000000000000000000000000000000000', 0, N'', CAST(0x0000A9A400AA7057 AS DateTime), 1, N'0000,0000,0000,0000,0000,0000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1214, 6, CAST(0x0000A94F00000000 AS DateTime), N'000011111111110000000011111111111111111100000000', 0, N'', CAST(0x0000A9A400B3DD04 AS DateTime), 1, N'0200,0700,1100,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1215, 6, CAST(0x0000A95000000000 AS DateTime), N'000011111111110000000011111111111111111100000000', 0, N'', CAST(0x0000A9A400B3F8D0 AS DateTime), 1, N'0200,0700,1100,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1216, 6, CAST(0x0000A95100000000 AS DateTime), N'000011111111110000000000001111111111111100000000', 0, N'', CAST(0x0000A9A400B41227 AS DateTime), 1, N'0200,0700,1300,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1217, 6, CAST(0x0000A95200000000 AS DateTime), N'000011111111110000000011111111111111000000000000', 0, N'', CAST(0x0000A9A400B43ED9 AS DateTime), 1, N'0200,0700,1100,1800', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1218, 6, CAST(0x0000A95300000000 AS DateTime), N'000011111111110000000011111111111111000000000000', 0, N'', CAST(0x0000A9A400B44ED8 AS DateTime), 1, N'0200,0700,1100,1800', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1219, 6, CAST(0x0000A95400000000 AS DateTime), N'000011111111110000000011111111111111111100000000', 0, N'', CAST(0x0000A9A400B46574 AS DateTime), 1, N'0200,0700,1100,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1220, 6, CAST(0x0000A95500000000 AS DateTime), N'000011111111110000000011111111111111111100000000', 0, N'', CAST(0x0000A9A400B477F7 AS DateTime), 1, N'0200,0700,1100,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1221, 6, CAST(0x0000A95600000000 AS DateTime), N'000011111111110000000011111111111100000000000000', 0, N'', CAST(0x0000A9A400B4891D AS DateTime), 1, N'0200,0700,1100,1700', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1222, 6, CAST(0x0000A95700000000 AS DateTime), N'000011111111110000001111111111111111110000000000', 0, N'', CAST(0x0000A9A400B4ABFC AS DateTime), 1, N'0200,0700,1000,1900', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1223, 6, CAST(0x0000A95800000000 AS DateTime), N'000011111111110000001111111111110000000000000000', 0, N'', CAST(0x0000A9A400B4D376 AS DateTime), 1, N'0200,0700,1000,1600', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1224, 6, CAST(0x0000A95900000000 AS DateTime), N'000011111111110000111111111111111111000000000000', 0, N'', CAST(0x0000A9A400B4EFFF AS DateTime), 1, N'0200,0700,0900,1800', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1225, 6, CAST(0x0000A95A00000000 AS DateTime), N'000011111111110000111111111111111111000000000000', 0, N'', CAST(0x0000A9A400B500D4 AS DateTime), 1, N'0200,0700,0900,1800', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1226, 6, CAST(0x0000A95B00000000 AS DateTime), N'000011111111110000000000111111111111111100000000', 0, N'', CAST(0x0000A9A400B525AB AS DateTime), 1, N'0200,0700,1200,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1227, 6, CAST(0x0000A95C00000000 AS DateTime), N'000011111111110000000000111111111111111100000000', 0, N'', CAST(0x0000A9A400B54645 AS DateTime), 1, N'0200,0700,1200,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1228, 6, CAST(0x0000A95D00000000 AS DateTime), N'000011111111110000000000111111111111111100000000', 0, N'', CAST(0x0000A9A400B55D86 AS DateTime), 1, N'0200,0700,1200,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1229, 6, CAST(0x0000A95E00000000 AS DateTime), N'000011111111110000000000001111111111111111110000', 0, N'', CAST(0x0000A9A400B57985 AS DateTime), 1, N'0200,0700,1300,2200', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1230, 6, CAST(0x0000A95F00000000 AS DateTime), N'000011111111110000000000000011111111111111110000', 0, N'', CAST(0x0000A9A400B58C84 AS DateTime), 1, N'0200,0700,1400,2200', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1231, 6, CAST(0x0000A96000000000 AS DateTime), N'000011111111110000000000000000000000111111111111', 0, N'', CAST(0x0000A9A400B5A7AA AS DateTime), 1, N'0200,0700,1800,2400', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1232, 6, CAST(0x0000A96100000000 AS DateTime), N'000011111111111111111111110000000000000000111111', 0, N'', CAST(0x0000A9A400B5CAA0 AS DateTime), 1, N'0200,1300,2100,2400', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1233, 6, CAST(0x0000A96200000000 AS DateTime), N'000011111111111111111111110000000000000000111111', 0, N'', CAST(0x0000A9A400B5FFC0 AS DateTime), 1, N'0200,1300,2100,2400', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1234, 6, CAST(0x0000A96300000000 AS DateTime), N'000011111111110000000000000000000011111111111111', 0, N'', CAST(0x0000A9A400B61802 AS DateTime), 1, N'0200,0700,1700,2400', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1235, 6, CAST(0x0000A96400000000 AS DateTime), N'000011111111111111110000000000000000001111111111', 0, N'', CAST(0x0000A9A400B62FDD AS DateTime), 1, N'0200,1000,1900,2400', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1236, 6, CAST(0x0000A96500000000 AS DateTime), N'000011111111110000000000000000000011111100000000', 0, N'', CAST(0x0000A9A400B64A2E AS DateTime), 1, N'0200,0700,1700,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1237, 6, CAST(0x0000A96600000000 AS DateTime), N'000011111111111111111100000000000011111100000000', 0, N'', CAST(0x0000A9A400B66241 AS DateTime), 1, N'0200,1100,1700,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1238, 6, CAST(0x0000A96700000000 AS DateTime), N'000011111111110000000000111111111111111100000000', 0, N'', CAST(0x0000A9A400B67560 AS DateTime), 1, N'0200,0700,1200,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1239, 6, CAST(0x0000A96800000000 AS DateTime), N'000011111111110000000000111111111111111100000000', 0, N'', CAST(0x0000A9A400B68AD5 AS DateTime), 1, N'0200,0700,1200,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1240, 6, CAST(0x0000A96900000000 AS DateTime), N'000011111111110000000000111111111111111100000000', 0, N'', CAST(0x0000A9A400B6A0F3 AS DateTime), 1, N'0200,0700,1200,2000', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1241, 6, CAST(0x0000A96A00000000 AS DateTime), N'000011111111110000000000000011111111111111110000', 0, N'', CAST(0x0000A9A400B6B659 AS DateTime), 1, N'0200,0700,1400,2200', NULL, N'0', 9876543, 2)
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator], [VesselID], [RegimeID]) VALUES (1242, 6, CAST(0x0000A96B00000000 AS DateTime), N'000011111111110000000000001111111111111100000000', 0, N'', CAST(0x0000A9A400B6CD15 AS DateTime), 1, N'0200,0700,1300,2000', NULL, N'0', 9876543, 2)
SET IDENTITY_INSERT [dbo].[WorkSessions] OFF
SET ANSI_PADDING ON

GO
/****** Object:  Index [UK_RegimeName]    Script Date: 03-Dec-18 6:13:33 PM ******/
ALTER TABLE [dbo].[Regimes] ADD  CONSTRAINT [UK_RegimeName] UNIQUE NONCLUSTERED 
(
	[RegimeName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Ship]    Script Date: 03-Dec-18 6:13:33 PM ******/
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
