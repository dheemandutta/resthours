USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpAddUsers]    Script Date: 04-May-18 10:59:40 AM ******/
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
	@CrewId int	

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
			INSERT INTO Users(Username,Password,Active,CrewId) VALUES
			(@UserName,@Password,1,@CrewId)

			SET @UserId = @@IDENTITY

			INSERT INTO @GroupTab(GrpId,UserId) 
			SELECT String,@UserId FROM ufn_CSVToTable(@GroupIds,',')


			INSERT INTO UserGroups(UserID,GroupID)
			SELECT UserId,GrpId FROM @GroupTab

		END
		ELSE
		BEGIN
			UPDATE Users SET Username = @UserName , Password = @Password ,Active = @Active 
			WHERE ID = @ID

			DELETE FROM UserGroups WHERE UserID  = @ID 

			INSERT INTO @GroupTab(GrpId,UserId) 
			SELECT String,@ID FROM ufn_CSVToTable(@GroupIds,',')

			INSERT INTO UserGroups(UserID,GroupID)
			SELECT UserId,GrpId FROM @GroupTab
		END


		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
	END CATCH

END




GO
/****** Object:  StoredProcedure [dbo].[stpDeleteShipDetails]    Script Date: 04-May-18 10:59:40 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stpDetleteRanks]    Script Date: 04-May-18 10:59:40 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetAllCrewByCrewID]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[stpGetAllCrewByCrewID]
(
	@ID int
)
AS

Begin
Select  C.ID ,FirstName + '  ' +LastName AS Name, RankName, ISNULL(Notes,' ') Notes ,
ISNULL(CONVERT(varchar(12),ST.ActiveFrom,101), '-') ActiveFrom1,
ISNULL(CONVERT(varchar(12),ST.ActiveTo,101), '-') ActiveTo1,
C.FirstName,C.LastName,
ISNULL(CONVERT(varchar(12),DOB,101), '-') DOB1,
ISNULL(C.Nationality,'') Nationality,ISNULL(C.POB,'') POB, 
ISNULL(C.CrewIdentity,'') CrewIdentity,ISNULL(C.PassportSeamanPassportBook,'') PassportSeamanPassportBook,
--
ISNULL(CONVERT(varchar(12),C.CreatedOn,101), '-') CreatedOn,
ISNULL(CONVERT(varchar(12),C.LatestUpdate,101), '-') LatestUpdate,
--
C.OvertimeEnabled,C.Watchkeeper,C.RankID


FROM dbo.Crew C 
LEFT OUTER JOIN ServiceTerms ST
ON C.ID = ST.CrewID
INNER JOIN Ranks R 
ON R.ID = C.RankID
WHERE C.ID= @ID
End

-- exec stpGetAllCrewByCrewID 21





GO
/****** Object:  StoredProcedure [dbo].[stpGetAllRanks]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stpGetAllRanks]
AS

Begin
Select ID,RankName,[Description],Scheduled
from dbo.Ranks  
End






GO
/****** Object:  StoredProcedure [dbo].[stpGetAllRegimes]    Script Date: 04-May-18 10:59:40 AM ******/
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
  FROM [dbo].[Regimes] 
End




GO
/****** Object:  StoredProcedure [dbo].[stpGetAllShipDetails]    Script Date: 04-May-18 10:59:40 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetChildNodes]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetChildNodes]
(
	@ID int
)
AS

Begin
Select  ID,PermissionName
FROM dbo.[Permissions]   
Where ParentPermissionID  = @ID
End




GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewByRankID]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[stpGetCrewByRankID]
(
	@RankID int
)
AS

Begin
Select  *
FROM dbo.Crew
	  
WHERE RankID= @RankID
End




GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewByUserID]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[stpGetCrewByUserID]
(
	@UserID int
)
AS

Begin
Select  GroupID,G.GroupName
FROM UserGroups UG
INNER JOIN Groups G
ON UG.ID = G.ID
	  
WHERE UserID= @UserID
End




GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewDetailsPageWise]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[stpGetCrewDetailsPageWise]
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
            ORDER BY [Name] ASC
      )AS RowNumber
     ,Name,RankName,CreatedOn As StartDate,ISNULL(C.LatestUpdate,'') As EndDate, DateDIFF(day , GETDATE(), C.LatestUpdate ) AS DiffDays,COUNT(R.ID) AS TotCount ,
CASE
	WHEN  datediff(day , GETDATE(), C.LatestUpdate ) > 0 THEN 1
	ELSE 0
END As Active
 INTO #Results
FROM Crew C INNER JOIN Ranks R
ON C.RankID = R.ID
GROUP BY Name,RankName,CreatedOn,C.LatestUpdate
	
     
      SELECT @RecordCount = COUNT(*)
      FROM #Results
           
      SELECT * FROM #Results
      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1
     
      DROP TABLE #Results
END







GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewIDFromWorkSessions]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec stpGetCrewIDFromWorkSessions '1048' ,'02','2018'

CREATE PROCEDURE [dbo].[stpGetCrewIDFromWorkSessions]
(
	@CrewId int,
	@Month int,
	@Year int
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
		  AdjustmentFactor varchar(10)

		)

		INSERT INTO @TimeTab
		SELECT WS.ID,Hours,DAY(ValidOn) AS BookDate,C.FirstName,C.LastName,R.RankName,ISNULL(CONVERT(varchar(12),ValidOn,103), '') AS WorkDate,ComplianceInfo,TotalNCHours,WS.Comment,AdjustmentFator As AdjustmentFactor
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
	


	   SELECT * FROM @TimeTab ORDER BY BookDate

END




GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewListingPageWise]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetCrewListingPageWise]
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
            ORDER BY [FirstName] ASC
      )AS RowNumber
     ,FirstName + '  ' +LastName AS Name
	 ,RankName
	 --,CreatedOn As StartDate
	 ,CONVERT(varchar(12),CreatedOn,103) StartDate
	 --,ISNULL(C.LatestUpdate,'') As EndDate
	  ,CONVERT(varchar(12),C.LatestUpdate,103) EndDate
	 ,C.ID,
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
     
      DROP TABLE #Results
END







GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewPageWise]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetCrewPageWise]
 (
      @ID int,
      @PageIndex INT = 1,
      @PageSize INT = 10,
      @RecordCount INT OUTPUT
)
AS
BEGIN
      SET NOCOUNT ON;
      SELECT ROW_NUMBER() OVER
      (
            ORDER BY [ID] ASC
      )AS RowNumber
      ,ID
     ,FirstName + '  ' +LastName AS Name
     INTO #Results
      FROM Crew
	where RankID=@ID
     
      SELECT @RecordCount = COUNT(*)
      FROM #Results
           
      SELECT * FROM #Results
      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1
     
      DROP TABLE #Results
END







GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewReportListPageWise]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[stpGetCrewReportListPageWise]
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
            ORDER BY [FirstName] ASC
      )AS RowNumber
     ,FirstName + ' ' +LastName AS Name
	 ,R.RankName
	 ,(ISNULL(CONVERT(VARCHAR(12),C.DOB,103),'') +' '+ISNULL(C.POB,'') ) AS DOB1
	 ,C.ID
	 ,C.Nationality
	 ,C.EmployeeNumber
	 ,C.DOB
	 ,C.PassportSeamanPassportBook

 INTO #Results
FROM Crew C INNER JOIN Ranks R
ON C.RankID = R.ID
--GROUP BY Name,RankName,CreatedOn,C.LatestUpdate
	
     
      SELECT @RecordCount = COUNT(*)
      FROM #Results
           
      SELECT * FROM #Results
      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1
     
      DROP TABLE #Results
END





GO
/****** Object:  StoredProcedure [dbo].[stpGetDataForVarianceReport]    Script Date: 04-May-18 10:59:40 AM ******/
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
      @RecordCount INT OUTPUT
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
/****** Object:  StoredProcedure [dbo].[stpGetDayWiseCrewBookingData]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetDayWiseCrewBookingData]
(
	@BookDate DateTime
)
AS
BEGIN

SELECT Hours,CrewID, C.FirstName,C.LastName,C.Nationality,R.RankName,Comment,AdjustmentFator As AdjustmentFactor
FROM WorkSessions W
INNER JOIN Crew C
ON C.ID= W.CrewID
INNER JOIN Ranks R
ON C.RankID = R.ID 
WHERE CONVERT(varchar(12),ValidOn,103) = CONVERT(varchar(12),@BookDate,103)
ORDER BY CrewID

END




GO
/****** Object:  StoredProcedure [dbo].[stpGetFirstLastNameByUserId]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec stpGetFirstLastNameByUserId 34
CREATE PROCEDURE [dbo].[stpGetFirstLastNameByUserId]
(
	@UserId int
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
	Select  C.FirstName, C.LastName,C.ID AS CrewId
	FROM Crew C
	INNER JOIN Users U
	ON C.ID = U.CrewId
	WHERE U.ID= @UserId
END
ELSE IF @CrewId IS NULL
BEGIN
	SELECT 'Admin' FirstName,'Admin' LastName,0 CrewId
	FROM Users WHERE ID = @UserId
	 
END




End
GO
/****** Object:  StoredProcedure [dbo].[stpGetLastAdjustmentBookedStatus]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetLastAdjustmentBookedStatus]
(
	@BookDate datetime,
	@CrewID int
)
AS
BEGIN
	DECLARE @LastMinuSOneAdjustmentDate Datetime

	SELECT @LastMinuSOneAdjustmentDate = MAX(CONVERT(date,AdjustmentDate,110)) FROM TimeAdjustment
	WHERE AdjustmentValue = '-1D'
	AND CONVERT(DATE,AdjustmentDate,110) < CONVERT(DATE,@BookDate,110)

	IF @LastMinuSOneAdjustmentDate IS NOT NULL
		BEGIN

		SELECT COUNT(*) AS 'BookCount',CONVERT(DATE,@LastMinuSOneAdjustmentDate,113) AS 'LastBookDate'
		FROM WorkSessions 
		WHERE CONVERT(DATE,ValidOn,110) = CONVERT(DATE,@LastMinuSOneAdjustmentDate,110)
		AND CrewID = @CrewID

		END
	ELSE
		BEGIN
			SELECT 0 AS 'BookCount' ,CONVERT(DATE,@LastMinuSOneAdjustmentDate,113) AS 'LastBookDate'  
		END

END



GO
/****** Object:  StoredProcedure [dbo].[stpGetLastSevenDaysWorkSchedule]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[stpGetLastSevenDaysWorkSchedule]
(
	@CrewId int,
	@BookDate datetime
)
AS
BEGIN
		 
		 DECLARE @ScheduleTable TABLE
		 (
			BookDate Datetime,
			Schedule varchar(1000)
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

		--SET @Counter=1

		 --print DATEDIFF(day,@BookDate, dateadd(day,-6 ,@BookDate))

		 SET @ChangedBookDate = dateadd(day,-1 ,@ChangedBookDate)
		 print @ChangedBookDate
		 WHILE (DATEDIFF(day,@BookDate, @ChangedBookDate) >= -7)
		 BEGIN
				print DATEDIFF(day,@BookDate, @ChangedBookDate)


				--SET @NegativeCounter = @Counter * -1
				IF EXISTS(SELECT 1 FROM WorkSessions WHERE CrewId = @CrewId AND ValidOn = @ChangedBookDate )
					BEGIN
							INSERT INTO @ScheduleTable(BookDate,Schedule) 
							SELECT @ChangedBookDate,Hours
							FROM WorkSessions 
							WHERE CrewID = @CrewId
							AND ValidOn = @ChangedBookDate 
					END
				ELSE
					BEGIN
							INSERT INTO @ScheduleTable(BookDate,Schedule) 
							SELECT @ChangedBookDate,@ZeroSchedule
							
					END
				--SET @Counter = @Counter + 1
				SET @ChangedBookDate = dateadd(day,-1 ,@ChangedBookDate)
				print @ChangedBookDate
		 END  
		  
		 SELECT TOP 7 BookDate AS [ValidOn],Schedule AS [Hours] FROM @ScheduleTable  
		 ORDER BY BookDate desc

 END

 





GO
/****** Object:  StoredProcedure [dbo].[stpGetLastSixDaysWorkSchedule]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetLastSixDaysWorkSchedule]
(
	@CrewId int,
	@BookDate datetime
)
AS
BEGIN
		 
		 DECLARE @ScheduleTable TABLE
		 (
			BookDate Datetime,
			Schedule varchar(1000)
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
				IF EXISTS(SELECT 1 FROM WorkSessions WHERE CrewId = @CrewId AND ValidOn = @ChangedBookDate )
					BEGIN
							INSERT INTO @ScheduleTable(BookDate,Schedule) 
							SELECT @ChangedBookDate,Hours
							FROM WorkSessions 
							WHERE CrewID = @CrewId
							AND ValidOn = @ChangedBookDate 
					END
				ELSE
					BEGIN
							INSERT INTO @ScheduleTable(BookDate,Schedule) 
							SELECT @ChangedBookDate,@ZeroSchedule
							
					END
				SET @Counter = @Counter + 1
				SET @ChangedBookDate = dateadd(day,-1 ,@ChangedBookDate)
		 END  

		 SELECT BookDate AS [ValidOn],Schedule AS [Hours] FROM @ScheduleTable  
		 ORDER BY BookDate


 END

 




GO
/****** Object:  StoredProcedure [dbo].[stpGetMinusOneDayAdjustmentDays]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---EXEC stpGetMinusOneDayAdjustmentDays 2,2018,1048
CREATE PROCEDURE [dbo].[stpGetMinusOneDayAdjustmentDays]

(
	@Month int,
	@Year int,
	@CrewId int
)
AS
BEGIN

	SELECT ISNULL(DAY(AdjustmentDate), '') AS MinusAdjustmentDate,NULL AS AdjustmentDate
	FROM TimeAdjustment 
	WHERE AdjustmentValue = '-1D'
	AND MONTH(AdjustmentDate) = @Month
	AND YEAR(AdjustmentDate) = @Year
	AND AdjustmentDate IN (SELECT ValidOn 
							FROM WorkSessions WHERE CrewID = @CrewId 
							AND MONTH(ValidOn)= @Month
						    AND YEAR(ValidOn) = @Year
							AND AdjustmentFator = '-1D' )
END



GO
/****** Object:  StoredProcedure [dbo].[stpGetNonComplianceByCrewId]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec stpGetNonComplianceByCrewId 19,11,2017

CREATE PROCEDURE [dbo].[stpGetNonComplianceByCrewId]
(
	@CrewId int,
	@Month int,
	@Year int
)
AS
BEGIN

	SELECT ComplianceInfo,TotalNCHours
	FROM NCDetails
	WHERE CrewId = @CrewId
	AND MONTH(OccuredOn) = @Month
	AND YEAR(OccuredOn) = @Year

END




GO
/****** Object:  StoredProcedure [dbo].[stpGetNonComplianceInfo]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[stpGetNonComplianceInfo]
(
	@NCDetailsID int
)
AS

Begin
Select  ComplianceInfo
FROM NCDetails
  
WHERE NCDetailsID= @NCDetailsID
End
GO
/****** Object:  StoredProcedure [dbo].[stpGetParentNodes]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpGetParentNodes]
AS

Begin
Select ID,PermissionName 
from dbo.[Permissions]  
Where ParentPermissionID IS NULL
End




GO
/****** Object:  StoredProcedure [dbo].[stpGetPlusOneDayAdjustmentDays]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetPlusOneDayAdjustmentDays]

(
	@Month int,
	@Year int
)
AS
BEGIN

	SELECT ISNULL(CONVERT(varchar(12),AdjustmentDate,103), '') AS AdjustmentDate, NULL as MinusAdjustmentDate
	FROM TimeAdjustment
	WHERE AdjustmentValue = '+1D'
	AND MONTH(AdjustmentDate) = @Month
	AND YEAR(AdjustmentDate) = @Year

END



GO
/****** Object:  StoredProcedure [dbo].[stpGetRankFromGroup]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetRankFromGroup]
(
	@RankId int
)
AS
BEGIN
	SELECT GroupId FROM GroupRank
	WHERE RankID = @RankId
END
GO
/****** Object:  StoredProcedure [dbo].[stpGetRanksByID]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[stpGetRanksByID]
(
	@ID int
)
AS

Begin
Select  ID,RankName,[Description],Scheduled
FROM dbo.Ranks
	  
WHERE ID= @ID
End






GO
/****** Object:  StoredProcedure [dbo].[stpGetRanksPageWise]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetRanksPageWise]
 (
      @PageIndex INT = 1,
      @PageSize INT = 15,
      @RecordCount INT OUTPUT
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
	
     INTO #Results
      FROM Ranks
	
     
      SELECT @RecordCount = COUNT(*)
      FROM #Results
           
      SELECT * FROM #Results
      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1
	  ORDER BY [Order] ASC
     
      DROP TABLE #Results
END







GO
/****** Object:  StoredProcedure [dbo].[stpGetRegimeById]    Script Date: 04-May-18 10:59:40 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetShipDetailsByID]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[stpGetShipDetailsByID]
(
	@ID int
)
AS

Begin
Select  ID,ShipName,IMONumber,FlagOfShip,Regime
FROM dbo.Ship
	  
WHERE ID= @ID
End






GO
/****** Object:  StoredProcedure [dbo].[stpGetShipDetailsPageWise]    Script Date: 04-May-18 10:59:40 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetTimeAdjustment]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpGetTimeAdjustment]
(
	@BookDate Datetime
)
AS

Begin



IF EXISTS (SELECT 1 FROM TimeAdjustment WHERE  CONVERT(varchar(12),AdjustmentDate,103)=  CONVERT(varchar(12),@BookDate,103) )
BEGIN
		Select isnull(AdjustmentValue,0) AS AdjustmentValue
		from dbo.TimeAdjustment  
		WHERE  CONVERT(varchar(12),AdjustmentDate,101) =  CONVERT(varchar(12),@BookDate,101) 
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
/****** Object:  StoredProcedure [dbo].[stpGetTimeAdjustmentDetailsPageWise]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetTimeAdjustmentDetailsPageWise]
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
            ORDER BY [AdjustmentDate] ASC
      )AS RowNumber
     -- ,AdjustmentDate
      ,AdjustmentValue
	,CONVERT(varchar(12),AdjustmentDate,101) AdjustmentDate
     INTO #Results
      FROM TimeAdjustment
	
     
      SELECT @RecordCount = COUNT(*)
      FROM #Results
           
      SELECT * FROM #Results
      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1
     
      DROP TABLE #Results
END







GO
/****** Object:  StoredProcedure [dbo].[stpGetUserGroupsByUserID]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetUserGroupsByUserID]
(
	@UserID int
)
AS

Begin

Select  GroupID,G.GroupName
FROM UserGroups UG
INNER JOIN Groups G
ON UG.GroupID = G.ID
WHERE UserID= @UserID
End




GO
/****** Object:  StoredProcedure [dbo].[stpGetUsersDetailsPageWise]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpGetUsersDetailsPageWise]
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
            ORDER BY [Username] ASC
      )AS RowNumber
      ,ID
      ,Username
	  ,Active
	
     INTO #Results
      FROM Users
     
      SELECT @RecordCount = COUNT(*)
      FROM #Results
           
      SELECT * FROM #Results
      WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1
     
      DROP TABLE #Results
END







GO
/****** Object:  StoredProcedure [dbo].[stpGetWrokSessionsByCrewandDate]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[stpGetWrokSessionsByCrewandDate]
(
	@CrewId int,
	@BookDate DateTime
)
AS
BEGIN

	SELECT *,NCD.NCDetailsID FROM WorkSessions WS
	INNER JOIN NCDetails NCD
	ON WS.ID = NCD.WorkSessionId 
	WHERE WS.CrewId = @CrewId
	AND CONVERT(varchar(12),ValidOn,103) = CONVERT(varchar(12),@BookDate,103)
	ORDER BY Timestamp 

END




GO
/****** Object:  StoredProcedure [dbo].[stpGetWrokSessionsByDate]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec stpGetWrokSessionsByDate 2,2018
CREATE PROCEDURE [dbo].[stpGetWrokSessionsByDate]
(
	@Month int,
	@Year int
)
AS
BEGIN

	DECLARE @SelectedDay DateTime

	SET @SelectedDay =  datefromparts(@Year, @Month, 1)
	

	SELECT *,NCD.NCDetailsID,C.FirstName + ' ' + C.LastName AS CrewName,
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
	ORDER BY NCD.CrewID,WS.Timestamp DESC

END




GO
/****** Object:  StoredProcedure [dbo].[stpLastBookedSession]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[stpLastBookedSession]
(
	@CrewId int
	
)
AS
BEGIN

	


	SELECT * FROM WorkSessions
	WHERE CrewId = @CrewId
	AND CONVERT(varchar(12),ValidOn,103) = (

		SELECT TOP 1 CONVERT(varchar(12),VAlidOn,103)  
	FROM WorkSessions 
	WHERE CrewID = @CrewId
	ORDER BY ValidOn DESC
	)

END




GO
/****** Object:  StoredProcedure [dbo].[stpResetPassword]    Script Date: 04-May-18 10:59:40 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveCrew]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[stpSaveCrew] 
  
( 
@ID int,
@FirstName nvarchar(100),
@MiddleName nvarchar(100),
@LastName nvarchar(50),
@RankID int,

@Nationality nvarchar(20),
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
@NewCrewId int OUTPUT
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
           (FirstName,MiddleName,LastName,RankID,CreatedOn,LatestUpdate,Nationality,DOB,POB,PassportSeamanPassportBook,Seaman,Notes,Watchkeeper,OvertimeEnabled,EmployeeNumber)  
Values(@FirstName,@MiddleName,@LastName,@RankID,@CreatedOn,@ActiveTo,@Nationality,@DOB,@POB,@PassportSeamanPassportBook,@Seaman,@Notes,@Watchkeeper,@OvertimeEnabled,@EmployeeNum) 

DECLARE @CrewId int
SET @CrewId = @@IDENTITY

SET @NewCrewId = @@IDENTITY

--UPDATE Crew
--SET EmployeeNumber = @CrewId + '/' + @YearValue
--WHERE ID = @CrewId

INSERT INTO ServiceTerms(ActiveFrom,ActiveTo,CrewID,RankID,Deleted) VALUES
(@CreatedOn,@ActiveTo,@CrewId,@RankID,0)


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
    Notes=@Notes,Watchkeeper=@Watchkeeper,OvertimeEnabled=@OvertimeEnabled,
	PassportSeamanPassportBook=@PassportSeamanPassportBook,Seaman=@Seaman,DOB=@DOB
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
/****** Object:  StoredProcedure [dbo].[stpSaveGroups]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpSaveGroups] 
  
( 
@ID int,
@GroupName nvarchar(50),
@PermissionIds varchar(1000)

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

	INSERT INTO Groups(GroupName,AllowDelete)  
	Values(@GroupName,0) 
  
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
/****** Object:  StoredProcedure [dbo].[stpSaveRankGroups]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpSaveRankGroups]
(
	@RankId int,
	@Groups varchar(1000)
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

	INSERT INTO GroupRank(GroupId,RankID)
	SELECT GrpId,RankId FROM @GroupTab

END




GO
/****** Object:  StoredProcedure [dbo].[stpSaveRanks]    Script Date: 04-May-18 10:59:40 AM ******/
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
@Scheduled bit
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
           (RankName,[Description],Scheduled,[Order] ) 
Values(@RankName,@Description,@Scheduled,@MaxRankOrder) 
  
 
END
ELSE
BEGIN

UPDATE Ranks
SET RankName=@RankName,[Description]=@Description,Scheduled=@Scheduled--,Regime=@Regime
Where ID=@ID

END
END






GO
/****** Object:  StoredProcedure [dbo].[stpSaveRegimes]    Script Date: 04-May-18 10:59:40 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveShipDetails]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpSaveShipDetails] 
  
( 
@ID int,
@ShipName nvarchar(21),
@IMONumber nvarchar(8),
@FlagOfShip nvarchar(50)
--@Regime nvarchar(50)
) 

AS 
BEGIN 
    
 IF @ID IS NULL
BEGIN   
  
IF NOT EXISTS(SELECT COUNT(*) FROM Ship)
BEGIN
	INSERT INTO Ship 
			   (ShipName,IMONumber,FlagOfShip)  
	Values(@ShipName,@IMONumber,@FlagOfShip) 
END 
 
END
ELSE
BEGIN

UPDATE Ship
SET ShipName=@ShipName,IMONumber=@IMONumber,FlagOfShip=@FlagOfShip--,Regime=@Regime
Where ID=@ID

END
END







GO
/****** Object:  StoredProcedure [dbo].[stpSaveShipTab]    Script Date: 04-May-18 10:59:40 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveTimeAdjustment]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stpSaveTimeAdjustment] 
  
( 
@AdjustmentDate datetime,
@AdjustmentValue varchar(30)
) 

AS 
BEGIN 

BEGIN TRY

BEGIN TRAN

IF EXISTS (SELECT 1 FROM TimeAdjustment WHERE  CONVERT(varchar(12),AdjustmentDate,103)=  CONVERT(varchar(12),@AdjustmentDate,103) )

	BEGIN

		UPDATE TimeAdjustment
		SET AdjustmentValue = @AdjustmentValue
		WHERE CONVERT(varchar(12),AdjustmentDate,101) =  CONVERT(varchar(12),@AdjustmentDate,101) 


	END
ELSE
	BEGIN
			INSERT INTO TimeAdjustment 
			   (AdjustmentDate, AdjustmentValue)  
		Values(@AdjustmentDate,@AdjustmentValue)

	END

EXEC stpUpdateTimeEntry  @AdjustmentDate,@AdjustmentValue
 
 

 COMMIT TRAN

 END TRY
 BEGIN CATCH
	ROLLBACK TRAN

	PRINT @@ERROR

 END CATCH
 

 END






GO
/****** Object:  StoredProcedure [dbo].[stpSaveWorkSessions]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC stpSaveWorkSessions 10100,1048,'2018-02-23 00:00:00.000','000000111111001111111111111111111111111111100000',0,'test',0,'03:00,06:00,07:00,21:30','2018-02-23 00:00:00.000','<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus>Less than 10 hrs of rest in 24 hrs period</twentyfourhourresthoursstatus><minsevendaysrest>13</minsevendaysrest><mintwentyfourhoursrest>6</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>2</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>17</totalworkedhours><overtimeHours>9</overtimeHours></ncdetails>',0,'0',0


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
@isNonCompliant bit

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
           (CrewID, ValidOn, [Hours], Increment, Comment, LatestUpdate, [Deleted],ActualHours,AdjustmentFator)  
Values(@CrewID, @ValidOn, @Hours, @Increment, @Comment,GETDATE(), 1,@ActualHours,@AdjustmentFator) 

SET @WrkSessionId = @@IDENTITY


INSERT INTO NCDetails(CrewID,OccuredOn,ComplianceInfo,TotalNCHours,WorkSessionId,isNC)
VALUES(@CrewID,@OccuredOn,@ComplianceInfo,@TotalNCHours,@WrkSessionId,@isNonCompliant) 


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
				(CrewID, ValidOn, [Hours], Increment, Comment, LatestUpdate, [Deleted],ActualHours,AdjustmentFator)  
				Values(@CrewID, @ValidOn, @Hours, @Increment, @Comment,GETDATE(), 1,@ActualHours,@AdjustmentFator)
				
				SET @WrkSessionId = @@IDENTITY 


				INSERT INTO NCDetails(CrewID,OccuredOn,ComplianceInfo,TotalNCHours,WorkSessionId)
				VALUES(@CrewID,@OccuredOn,@ComplianceInfo,@TotalNCHours,@WrkSessionId) 

			END
	END
ELSE IF (@LastMinuSOneAdjustmentDate IS NULL AND @Day1Update = 0 ) -- FIRST DAY2 SAVE CASE
	BEGIN
		
				print 'h2'
				
				INSERT INTO WorkSessions 
				(CrewID, ValidOn, [Hours], Increment, Comment, LatestUpdate, [Deleted],ActualHours,AdjustmentFator)  
				Values(@CrewID, @ValidOn, @Hours, @Increment, @Comment,GETDATE(), 1,@ActualHours,@AdjustmentFator) 

				SET @WrkSessionId = @@IDENTITY 


				INSERT INTO NCDetails(CrewID,OccuredOn,ComplianceInfo,TotalNCHours,WorkSessionId)
				VALUES(@CrewID,@OccuredOn,@ComplianceInfo,@TotalNCHours,@WrkSessionId) 

			

	END
ELSE IF @Day1Update = 1
	BEGIN
			
			print 'h3'
			
			UPDATE WorkSessions
			SET CrewID=@CrewID, ValidOn=@ValidOn, [Hours]=@Hours, Increment=@Increment, Comment=@Comment,
				LatestUpdate=GETDATE(), Deleted=@Deleted, ActualHours=@ActualHours, AdjustmentFator=@AdjustmentFator
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
/****** Object:  StoredProcedure [dbo].[stpUpdateRanks]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpUpdateRanks]
(
	@RankOrder AS XML
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

	
END




GO
/****** Object:  StoredProcedure [dbo].[stpUpdateTimeEntry]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stpUpdateTimeEntry]
(
	@BookDate datetime,
	@AdjustmentFactor varchar(3)
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
  _adjustmentfactor varchar(10)
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

							INSERT INTO @TimeSheet(_ID,_CrewID,_ValidOn,_hours,_actualhours,_adjustmentfactor) 
							SELECT ID,CrewID,ValidOn,Hours,ActualHours,AdjustmentFator
							FROM WorkSessions 
							WHERE FLOOR(CAST(ValidOn as float)) = FLOOR(CAST(@BookDate as float))

							SET @actualhrs = ''
							SET @hours = ''
							SET @adjfactor =''
							SET @id = 0

							
							
							DECLARE DB_CURSOR CURSOR FOR
							SELECT _actualhours,_hours,_adjustmentfactor,_id
							FROM  @TimeSheet

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

						END
					IF(@AdjustmentFactor = '+30')
						BEGIN
							print  '+30'

							DELETE FROM @TimeSheet
						    
							INSERT INTO @TimeSheet(_ID,_CrewID,_ValidOn,_hours,_actualhours,_adjustmentfactor) 
							SELECT ID,CrewID,ValidOn,Hours,ActualHours,AdjustmentFator
							FROM WorkSessions 
							WHERE FLOOR(CAST(ValidOn as float)) = FLOOR(CAST(@BookDate as float))

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

						END
					IF(@AdjustmentFactor = '+1D')
						BEGIN
							print  '+1D'

							DELETE FROM @TimeSheet
						    
							INSERT INTO @TimeSheet(_ID,_CrewID,_ValidOn,_hours,_actualhours,_adjustmentfactor) 
							SELECT ID,CrewID,ValidOn,Hours,ActualHours,AdjustmentFator
							FROM WorkSessions 
							WHERE FLOOR(CAST(ValidOn as float)) = FLOOR(CAST(@BookDate as float))

							

							DELETE FROM  WorkSessions
							WHERE ID IN ( SELECT _ID FROM @TimeSheet)

						END
				    IF(@AdjustmentFactor = '-1')
						BEGIN
							print  '-1'

							DELETE FROM @TimeSheet
						    
							INSERT INTO @TimeSheet(_ID,_CrewID,_ValidOn,_hours,_actualhours,_adjustmentfactor) 
							SELECT ID,CrewID,ValidOn,Hours,ActualHours,AdjustmentFator
							FROM WorkSessions 
							WHERE FLOOR(CAST(ValidOn as float)) = FLOOR(CAST(@BookDate as float))

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

						END
				    IF(@AdjustmentFactor = '-30')
						BEGIN
							print  '-30'

							DELETE FROM @TimeSheet
						    
							INSERT INTO @TimeSheet(_ID,_CrewID,_ValidOn,_hours,_actualhours,_adjustmentfactor) 
							SELECT ID,CrewID,ValidOn,Hours,ActualHours,AdjustmentFator
							FROM WorkSessions 
							WHERE FLOOR(CAST(ValidOn as float)) = FLOOR(CAST(@BookDate as float))

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

						END
                    IF(@AdjustmentFactor = '-1D')
						BEGIN
							print  '-1D'

							DELETE FROM @TimeSheet
						    
							INSERT INTO @TimeSheet(_ID,_CrewID,_ValidOn,_hours,_actualhours,_adjustmentfactor) 
							SELECT ID,CrewID,ValidOn,Hours,ActualHours,AdjustmentFator
							FROM WorkSessions 
							WHERE FLOOR(CAST(ValidOn as float)) = FLOOR(CAST(@BookDate as float))

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

							INSERT INTO WorkSessions(CrewID,ValidOn,Hours,Increment,Comment,LatestUpdate,Deleted,ActualHours,TimeAdjustment,AdjustmentFator)
							SELECT CrewID,ValidOn,Hours,Increment,Comment,LatestUpdate,Deleted,ActualHours,TimeAdjustment,AdjustmentFator 
							FROM WorkSessions
							WHERE FLOOR(CAST(ValidOn as float)) = FLOOR(CAST(@BookDate as float))
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
/****** Object:  StoredProcedure [dbo].[stpUserAuthentication]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec stpUserAuthentication 'u52', 'u5'
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

End





GO
/****** Object:  StoredProcedure [dbo].[TEST_TEMP]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TEST_TEMP]
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
            ORDER BY [Name] ASC
      )AS RowNumber
     ,Name
	 ,RankName
	 --,CreatedOn As StartDate
	 ,CONVERT(varchar(12),CreatedOn,103) StartDate
	 --,ISNULL(C.LatestUpdate,'') As EndDate
	  ,CONVERT(varchar(12),C.LatestUpdate,103) EndDate
	 ,C.ID,
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
     
      DROP TABLE #Results
END







GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllCrewForDrp]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_GetAllCrewForDrp]
AS

Begin
Select ID, FirstName + '  ' +LastName AS Name
from dbo.Crew
End




GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllGroupsForDrp]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usp_GetAllGroupsForDrp]
AS

Begin
Select ID, GroupName
from dbo.Groups
End




GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllRanksForDrp]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usp_GetAllRanksForDrp]
AS

Begin
Select ID AS RankID, RankName
from dbo.Ranks
End






GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllShipForDrp]    Script Date: 04-May-18 10:59:40 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_GetAllUsersForDrp]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usp_GetAllUsersForDrp]
AS

Begin
Select ID, Username
from dbo.Users
End




GO
/****** Object:  UserDefinedFunction [dbo].[ufn_CSVToTable]    Script Date: 04-May-18 10:59:40 AM ******/
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
/****** Object:  Table [dbo].[Crew]    Script Date: 04-May-18 10:59:40 AM ******/
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
	[Nationality] [nvarchar](20) NULL,
	[DOB] [datetime] NULL,
	[POB] [nvarchar](20) NULL,
	[CrewIdentity] [nvarchar](20) NULL,
	[PassportSeamanPassportBook] [nvarchar](20) NULL,
	[Seaman] [nvarchar](20) NULL,
	[MiddleName] [varchar](100) NULL,
 CONSTRAINT [PK_dbo.Crew] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[GroupPermission]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GroupPermission](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GroupID] [int] NOT NULL,
	[PermissionID] [int] NOT NULL,
	[TimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_dbo.GroupPermission] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GroupRank]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GroupRank](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GroupID] [int] NOT NULL,
	[RankID] [int] NOT NULL,
	[Timestamp] [timestamp] NULL,
 CONSTRAINT [PK_GroupRank] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Groups]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Groups](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GroupName] [nvarchar](50) NOT NULL,
	[Timestamp] [timestamp] NOT NULL,
	[AllowDelete] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.Groups] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NCDetails]    Script Date: 04-May-18 10:59:40 AM ******/
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
 CONSTRAINT [PK_dbo.NCDetails] PRIMARY KEY CLUSTERED 
(
	[NCDetailsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Permissions]    Script Date: 04-May-18 10:59:40 AM ******/
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
 CONSTRAINT [PK_dbo.Permissions] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Ranks]    Script Date: 04-May-18 10:59:40 AM ******/
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
 CONSTRAINT [PK_dbo.Ranks] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Regimes]    Script Date: 04-May-18 10:59:40 AM ******/
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
 CONSTRAINT [PK_RegimeID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ServiceTerms]    Script Date: 04-May-18 10:59:40 AM ******/
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
 CONSTRAINT [PK_dbo.ServiceTerms] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Ship]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ship](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ShipName] [nvarchar](21) NOT NULL,
	[IMONumber] [nvarchar](8) NOT NULL,
	[FlagOfShip] [nvarchar](50) NOT NULL,
	[Regime] [int] NULL,
	[TimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_dbo.Ship] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TimeAdjustment]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TimeAdjustment](
	[AdjustmentDate] [datetime] NULL,
	[AdjustmentValue] [varchar](30) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserGroups]    Script Date: 04-May-18 10:59:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserGroups](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[GroupID] [int] NOT NULL,
	[Timestamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_dbo.UserGroups] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Users]    Script Date: 04-May-18 10:59:40 AM ******/
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
 CONSTRAINT [PK_dbo.Users] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkSchedules]    Script Date: 04-May-18 10:59:40 AM ******/
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
 CONSTRAINT [PK_dbo.WorkSchedules] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkSessions]    Script Date: 04-May-18 10:59:40 AM ******/
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
 CONSTRAINT [PK_dbo.WorkSessions] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[Crew] ON 

INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (4063, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 10, N'Manoj', N'Kumar', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (4064, NULL, 1, N'34434', NULL, CAST(0x0000A8D200000000 AS DateTime), NULL, N'43434', CAST(0x0000A8B700000000 AS DateTime), 0, N'3434', 0, 11, N'Yeshwant', N'Dessai', N'Liberia', CAST(0x0000A8B800000000 AS DateTime), N'Liberia', N'er34344', NULL, N'3434', NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (4065, NULL, 1, NULL, NULL, CAST(0x0000A8C700000000 AS DateTime), NULL, N'fghgfg76868678', CAST(0x0000A8B500000000 AS DateTime), 0, N'6786786', 0, 1034, N'Olga', N'Olianova', N'Liberia', CAST(0x0000A8B800000000 AS DateTime), N'Liberia', N'fggf5656', NULL, N'4564ghfg', NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (4066, NULL, 1, NULL, NULL, CAST(0x0000A8BD00000000 AS DateTime), NULL, N'4545', CAST(0x0000A8B500000000 AS DateTime), 0, N'4554545', 0, 1037, N'Musmadi', N'Musmadi', N'Liberia', CAST(0x0000A8B700000000 AS DateTime), N'Liberia', N'554545', NULL, N'4554545', NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (4067, NULL, 1, NULL, NULL, CAST(0x0000A8CE00000000 AS DateTime), NULL, N'4545', CAST(0x0000A8B700000000 AS DateTime), 0, N'45545454', 0, 1037, N'Pius', N'Romadi', N'Liberia', CAST(0x0000A8B600000000 AS DateTime), N'Liberia', N'5445', NULL, N'45454', NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (4068, NULL, 0, NULL, NULL, CAST(0x0000A8D200000000 AS DateTime), NULL, N'44545', CAST(0x0000A8B500000000 AS DateTime), 0, N'4554544', 0, 1044, N'Kishan', N'Kumar', N'Liberia', CAST(0x0000A8B500000000 AS DateTime), N'Liberia', N'43e', NULL, N'4545', NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (4069, NULL, 0, NULL, NULL, CAST(0x0000A8D200000000 AS DateTime), NULL, N'3434343', CAST(0x0000A8B800000000 AS DateTime), 0, N'3343434', 0, 1044, N'Haryadi', N'Haryadi', N'Liberia', CAST(0x0000A8B800000000 AS DateTime), N'Liberia', N'453434', NULL, N'34343', NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (4070, NULL, 0, NULL, NULL, CAST(0x0000A8CD00000000 AS DateTime), NULL, N'2364656', CAST(0x0000A8BA00000000 AS DateTime), 0, N'56656', 0, 12, N'Paras Pratap', N'Patil', N'Liberia', CAST(0x0000A8B900000000 AS DateTime), N'Liberia', N'454334', NULL, N'344343', NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (4071, NULL, 0, NULL, NULL, CAST(0x0000A8CD00000000 AS DateTime), NULL, N'32434', CAST(0x0000A8BA00000000 AS DateTime), 0, N'34434', 0, 1034, N'Hadi Siswoyo', N'Suko', N'Liberia', CAST(0x0000A8B700000000 AS DateTime), N'Liberia', N'45344', NULL, N'344334', NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (4072, NULL, 0, NULL, NULL, CAST(0x0000A8C500000000 AS DateTime), NULL, N'3434', CAST(0x0000A8BA00000000 AS DateTime), 0, N'3434343', 0, 1039, N'Keswanto', N'Heri', N'Liberia', CAST(0x0000A8B900000000 AS DateTime), N'Liberia', N'3434', NULL, N'34343', NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (4073, NULL, 0, NULL, NULL, CAST(0x0000A8CD00000000 AS DateTime), NULL, N'5565', CAST(0x0000A8B800000000 AS DateTime), 0, N'565656', 0, 1039, N'Sayuti', N'Supardi', N'Liberia', CAST(0x0000A8B800000000 AS DateTime), N'Liberia', N'44trr', NULL, N'r656565', NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (4074, NULL, 0, NULL, NULL, CAST(0x0000A8CC00000000 AS DateTime), NULL, N'783456', CAST(0x0000A8BA00000000 AS DateTime), 0, N'6557', 0, 1040, N'Jana Avijit', N'Kumar', N'Liberia', CAST(0x0000A8B800000000 AS DateTime), N'Liberia', N'544678', NULL, N'878', NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (4075, NULL, 0, NULL, NULL, CAST(0x0000A8D200000000 AS DateTime), NULL, N'4563476', CAST(0x0000A8B500000000 AS DateTime), 0, N'74446', 0, 1045, N'John Welem', N'Mare', N'Liberia', CAST(0x0000492100000000 AS DateTime), N'Liberia', N'3479', NULL, N'68754436', NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (4076, NULL, 0, NULL, NULL, CAST(0x0000A8CE00000000 AS DateTime), NULL, N'455475', CAST(0x0000A8BF00000000 AS DateTime), 0, N'45357756', 0, 1041, N'Muhamad', N'Mulyadi', N'Liberia', CAST(0x0000A8B800000000 AS DateTime), N'Liberia', N'23685468', NULL, N'455445466', NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (4077, NULL, 1, NULL, NULL, CAST(0x0000A8C500000000 AS DateTime), NULL, N'90333', CAST(0x00009BDE00000000 AS DateTime), 0, N'AA4564', 0, 1041, N'Muhamad', N'Mulyadi', N'Liberia', CAST(0x0000A8C100000000 AS DateTime), N'Liberia', N'dgd46y', NULL, N'df359089', NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (5077, NULL, 0, NULL, NULL, CAST(0x0000A8CB00000000 AS DateTime), NULL, NULL, CAST(0x0000A8B800000000 AS DateTime), 0, N'44uijip', 0, 9, N'Manoj', N'Kumar', N'Indian', CAST(0x0000A8B800000000 AS DateTime), N'Indian', N'645ih', NULL, N'lklj4544', NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (6077, NULL, 0, N'ghgfghg', NULL, CAST(0x0000A8D200000000 AS DateTime), NULL, NULL, CAST(0x0000A8B500000000 AS DateTime), 0, NULL, 0, 9, N'Muhamad', N'Mulyadi', N'indian', CAST(0x0000A8B900000000 AS DateTime), N'indian', N'dfdf433434', NULL, N'5gfh6', NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (6078, NULL, 0, N'jhkjhkhjk', NULL, CAST(0x0000A8CC00000000 AS DateTime), NULL, NULL, CAST(0x0000A8B500000000 AS DateTime), 0, N'18/2018', 0, 9, N'Muhamad', N'Mulyadi', N'India', CAST(0x0000A8B500000000 AS DateTime), N'India', NULL, NULL, N'gfgf', NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (6079, NULL, 0, N'uhjj', NULL, CAST(0x0000A8C600000000 AS DateTime), NULL, NULL, CAST(0x0000A8B700000000 AS DateTime), 0, N'19/2018', 0, 9, N'Muhamad', N'Mulyadi', N'India', CAST(0x0000A8B500000000 AS DateTime), N'Mulyadi, Muhamad', NULL, NULL, N'ihy75', NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (6080, NULL, 0, NULL, NULL, CAST(0x0000A8F100000000 AS DateTime), NULL, NULL, CAST(0x0000A8D300000000 AS DateTime), 0, N'20/2018', 0, 9, N'Manoj', N'Kumar', N'Liberia', CAST(0x0000467300000000 AS DateTime), N'Liberia', NULL, NULL, N'PU66764', NULL)
SET IDENTITY_INSERT [dbo].[Crew] OFF
SET IDENTITY_INSERT [dbo].[GroupRank] ON 

INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (25, 13, 10)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (26, 14, 9)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (27, 14, 11)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (28, 14, 12)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (29, 14, 1032)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (30, 15, 1033)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (31, 15, 1034)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (32, 15, 1035)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (33, 15, 1036)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (34, 15, 1037)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (35, 15, 1038)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (36, 15, 1039)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (37, 15, 1040)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (38, 15, 1041)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (39, 15, 1043)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (40, 15, 1044)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (41, 15, 1045)
SET IDENTITY_INSERT [dbo].[GroupRank] OFF
SET IDENTITY_INSERT [dbo].[Groups] ON 

INSERT [dbo].[Groups] ([ID], [GroupName], [AllowDelete]) VALUES (13, N'Super Admin', 1)
INSERT [dbo].[Groups] ([ID], [GroupName], [AllowDelete]) VALUES (14, N'Admin', 1)
INSERT [dbo].[Groups] ([ID], [GroupName], [AllowDelete]) VALUES (15, N'User', 1)
SET IDENTITY_INSERT [dbo].[Groups] OFF
SET IDENTITY_INSERT [dbo].[NCDetails] ON 

INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10127, 4063, CAST(0x0000A8B500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11159, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10128, 4063, CAST(0x0000A8B600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11160, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10129, 4063, CAST(0x0000A8B700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11161, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10130, 4063, CAST(0x0000A8B800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11162, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10131, 4063, CAST(0x0000A8B900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11163, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10132, 4063, CAST(0x0000A8BA00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11164, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10133, 4063, CAST(0x0000A8BB00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 11165, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10134, 4063, CAST(0x0000A8BC00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11166, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10135, 4063, CAST(0x0000A8BD00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11167, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10136, 4063, CAST(0x0000A8BE00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11168, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10137, 4063, CAST(0x0000A8BF00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11169, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10138, 4063, CAST(0x0000A8C000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11170, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10139, 4063, CAST(0x0000A8C100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11171, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10140, 4063, CAST(0x0000A8C200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 11172, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10141, 4063, CAST(0x0000A8C300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>23</minsevendaysrest><mintwentyfourhoursrest>11</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>3</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11173, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10142, 4063, CAST(0x0000A8C400000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11174, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10143, 4063, CAST(0x0000A8C500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11175, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10144, 4063, CAST(0x0000A8C600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11176, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10145, 4063, CAST(0x0000A8C700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11177, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10146, 4063, CAST(0x0000A8C800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11178, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10147, 4063, CAST(0x0000A8C900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 11179, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10148, 4063, CAST(0x0000A8CA00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11180, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10149, 4063, CAST(0x0000A8CB00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11181, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10150, 4063, CAST(0x0000A8CC00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11182, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10151, 4063, CAST(0x0000A8CD00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11183, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10152, 4063, CAST(0x0000A8CE00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11184, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10153, 4063, CAST(0x0000A8CF00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11185, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10154, 4063, CAST(0x0000A8D000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 11186, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10155, 4063, CAST(0x0000A8D100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11187, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10156, 4063, CAST(0x0000A8D200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11188, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10157, 4065, CAST(0x0000A8B500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11189, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10158, 4065, CAST(0x0000A8B600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11190, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10159, 4065, CAST(0x0000A8B700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11191, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10160, 4065, CAST(0x0000A8B800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11192, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10161, 4065, CAST(0x0000A8B900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11193, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10162, 4065, CAST(0x0000A8BA00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11194, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10163, 4065, CAST(0x0000A8BB00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 11195, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10164, 4065, CAST(0x0000A8BC00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11196, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10165, 4065, CAST(0x0000A8BD00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11197, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10166, 4065, CAST(0x0000A8BE00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11198, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10167, 4065, CAST(0x0000A8BF00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11199, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10168, 4065, CAST(0x0000A8C000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11200, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10169, 4065, CAST(0x0000A8C100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11201, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10170, 4065, CAST(0x0000A8C200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 11202, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10171, 4065, CAST(0x0000A8C300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>23</minsevendaysrest><mintwentyfourhoursrest>11</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>3</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11203, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10172, 4065, CAST(0x0000A8C400000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11204, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10173, 4065, CAST(0x0000A8C500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11205, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10174, 4065, CAST(0x0000A8C600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11206, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10175, 4065, CAST(0x0000A8C700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11207, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10176, 4065, CAST(0x0000A8C800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11208, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10177, 4065, CAST(0x0000A8C900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 11209, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10178, 4065, CAST(0x0000A8CA00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11210, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10179, 4065, CAST(0x0000A8CB00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11211, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10180, 4065, CAST(0x0000A8CC00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11212, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10181, 4065, CAST(0x0000A8CD00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11213, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10182, 4065, CAST(0x0000A8CE00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11214, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10183, 4065, CAST(0x0000A8CF00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11215, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10184, 4065, CAST(0x0000A8D000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 11216, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10185, 4065, CAST(0x0000A8D100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11217, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10186, 4065, CAST(0x0000A8D200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11218, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10187, 4067, CAST(0x0000A8B500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11219, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10188, 4067, CAST(0x0000A8B600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11220, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10189, 4067, CAST(0x0000A8B700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11221, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10190, 4067, CAST(0x0000A8B800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11222, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10191, 4067, CAST(0x0000A8B900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11223, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10192, 4067, CAST(0x0000A8BA00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11224, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10193, 4067, CAST(0x0000A8BB00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 11225, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10194, 4067, CAST(0x0000A8BC00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11226, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10195, 4067, CAST(0x0000A8BD00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11227, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10196, 4067, CAST(0x0000A8BE00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11228, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10197, 4067, CAST(0x0000A8BF00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11229, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10198, 4067, CAST(0x0000A8C000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11230, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10199, 4067, CAST(0x0000A8C100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11231, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10200, 4067, CAST(0x0000A8C200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 11232, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10201, 4067, CAST(0x0000A8C300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>23</minsevendaysrest><mintwentyfourhoursrest>11</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>3</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11233, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10202, 4067, CAST(0x0000A8C400000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11234, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10203, 4067, CAST(0x0000A8C500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11235, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10204, 4067, CAST(0x0000A8C600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11236, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10205, 4067, CAST(0x0000A8C700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11237, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10206, 4067, CAST(0x0000A8C800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11238, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10207, 4067, CAST(0x0000A8C900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 11239, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10208, 4067, CAST(0x0000A8CA00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11240, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10209, 4067, CAST(0x0000A8CB00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11241, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10210, 4067, CAST(0x0000A8CC00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11242, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10211, 4067, CAST(0x0000A8CD00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11243, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10212, 4067, CAST(0x0000A8CE00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11244, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10213, 4067, CAST(0x0000A8CF00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11245, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10214, 4067, CAST(0x0000A8D000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 11246, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10215, 4067, CAST(0x0000A8D100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11247, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10216, 4067, CAST(0x0000A8D200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11248, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10217, 4069, CAST(0x0000A8B500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11249, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10218, 4069, CAST(0x0000A8B600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11250, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10219, 4069, CAST(0x0000A8B700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11251, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10220, 4069, CAST(0x0000A8B800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11252, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10221, 4069, CAST(0x0000A8B900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11253, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10222, 4069, CAST(0x0000A8BA00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11254, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10223, 4069, CAST(0x0000A8BB00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 11255, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10224, 4069, CAST(0x0000A8BC00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11256, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10225, 4069, CAST(0x0000A8BD00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11257, 1)
GO
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10226, 4069, CAST(0x0000A8BE00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11258, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10227, 4069, CAST(0x0000A8BF00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11259, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10228, 4069, CAST(0x0000A8C000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11260, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10229, 4069, CAST(0x0000A8C100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11261, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10230, 4069, CAST(0x0000A8C200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 11262, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10231, 4069, CAST(0x0000A8C300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>23</minsevendaysrest><mintwentyfourhoursrest>11</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>3</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11263, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10232, 4069, CAST(0x0000A8C400000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11264, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10233, 4069, CAST(0x0000A8C500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11265, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10234, 4069, CAST(0x0000A8C600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11266, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10235, 4069, CAST(0x0000A8C700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11267, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10236, 4069, CAST(0x0000A8C800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11268, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10237, 4069, CAST(0x0000A8C900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 11269, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10238, 4069, CAST(0x0000A8CA00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11270, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10239, 4069, CAST(0x0000A8CB00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11271, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10240, 4069, CAST(0x0000A8CC00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11272, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10241, 4069, CAST(0x0000A8CD00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11273, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10242, 4069, CAST(0x0000A8CE00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11274, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10243, 4069, CAST(0x0000A8CF00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11275, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10244, 4069, CAST(0x0000A8D000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 11276, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10245, 4069, CAST(0x0000A8D100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11277, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10246, 4069, CAST(0x0000A8D200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11278, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10247, 4071, CAST(0x0000A8B500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11279, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10248, 4071, CAST(0x0000A8B600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11280, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10249, 4071, CAST(0x0000A8B700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11281, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10250, 4071, CAST(0x0000A8B800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11282, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10251, 4071, CAST(0x0000A8B900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11283, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10252, 4071, CAST(0x0000A8BA00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11284, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10253, 4071, CAST(0x0000A8BB00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 11285, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10254, 4071, CAST(0x0000A8BC00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11286, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10255, 4071, CAST(0x0000A8BD00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11287, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10256, 4071, CAST(0x0000A8BE00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11288, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10257, 4071, CAST(0x0000A8BF00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11289, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10258, 4071, CAST(0x0000A8C000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11290, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10259, 4071, CAST(0x0000A8C100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11291, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10260, 4071, CAST(0x0000A8C200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 11292, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10261, 4071, CAST(0x0000A8C300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>23</minsevendaysrest><mintwentyfourhoursrest>11</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>3</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11293, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10262, 4071, CAST(0x0000A8C400000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11294, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10263, 4071, CAST(0x0000A8C500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11295, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10264, 4071, CAST(0x0000A8C600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11296, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10265, 4071, CAST(0x0000A8C700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11297, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10266, 4071, CAST(0x0000A8C800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11298, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10267, 4071, CAST(0x0000A8C900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 11299, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10268, 4071, CAST(0x0000A8CA00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11300, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10269, 4071, CAST(0x0000A8CB00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11301, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10270, 4071, CAST(0x0000A8CC00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11302, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10271, 4071, CAST(0x0000A8CD00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11303, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10272, 4071, CAST(0x0000A8CE00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11304, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10273, 4071, CAST(0x0000A8CF00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11305, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10274, 4071, CAST(0x0000A8D000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 11306, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10275, 4071, CAST(0x0000A8D100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11307, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10276, 4071, CAST(0x0000A8D200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11308, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10277, 4073, CAST(0x0000A8B500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11309, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10278, 4073, CAST(0x0000A8B600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11310, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10279, 4073, CAST(0x0000A8B700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11311, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10280, 4073, CAST(0x0000A8B800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11312, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10281, 4073, CAST(0x0000A8B900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11313, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10282, 4073, CAST(0x0000A8BA00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11314, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10283, 4073, CAST(0x0000A8BB00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 11315, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10284, 4073, CAST(0x0000A8BC00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11316, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10285, 4073, CAST(0x0000A8BD00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11317, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10286, 4073, CAST(0x0000A8BE00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11318, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10287, 4073, CAST(0x0000A8BF00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11319, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10288, 4073, CAST(0x0000A8C000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11320, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10289, 4073, CAST(0x0000A8C100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11321, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10290, 4073, CAST(0x0000A8C200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 11322, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10291, 4073, CAST(0x0000A8C300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>23</minsevendaysrest><mintwentyfourhoursrest>11</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>3</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11323, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10292, 4073, CAST(0x0000A8C400000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11324, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10293, 4073, CAST(0x0000A8C500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11325, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10294, 4073, CAST(0x0000A8C600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11326, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10295, 4073, CAST(0x0000A8C700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11327, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10296, 4073, CAST(0x0000A8C800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11328, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10297, 4073, CAST(0x0000A8C900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 11329, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10298, 4073, CAST(0x0000A8CA00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11330, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10299, 4073, CAST(0x0000A8CB00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11331, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10300, 4073, CAST(0x0000A8CC00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11332, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10301, 4073, CAST(0x0000A8CD00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11333, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10302, 4073, CAST(0x0000A8CE00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11334, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10303, 4073, CAST(0x0000A8CF00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11335, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10304, 4073, CAST(0x0000A8D000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 11336, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10305, 4073, CAST(0x0000A8D100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11337, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10306, 4073, CAST(0x0000A8D200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11338, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10307, 4075, CAST(0x0000A8B500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11339, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10308, 4075, CAST(0x0000A8B600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11340, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10309, 4075, CAST(0x0000A8B700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11341, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10310, 4075, CAST(0x0000A8B800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11342, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10311, 4075, CAST(0x0000A8B900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11343, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10312, 4075, CAST(0x0000A8BA00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11344, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10313, 4075, CAST(0x0000A8BB00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 11345, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10314, 4075, CAST(0x0000A8BC00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11346, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10315, 4075, CAST(0x0000A8BD00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11347, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10316, 4075, CAST(0x0000A8BE00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11348, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10317, 4075, CAST(0x0000A8BF00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11349, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10318, 4075, CAST(0x0000A8C000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11350, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10319, 4075, CAST(0x0000A8C100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11351, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10320, 4075, CAST(0x0000A8C200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 11352, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10321, 4075, CAST(0x0000A8C300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>23</minsevendaysrest><mintwentyfourhoursrest>11</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>3</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11353, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10322, 4075, CAST(0x0000A8C400000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11354, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10323, 4075, CAST(0x0000A8C500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11355, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10324, 4075, CAST(0x0000A8C600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11356, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10325, 4075, CAST(0x0000A8C700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11357, 1)
GO
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10326, 4075, CAST(0x0000A8C800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11358, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10327, 4075, CAST(0x0000A8C900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 11359, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10328, 4075, CAST(0x0000A8CA00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11360, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10329, 4075, CAST(0x0000A8CB00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11361, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10330, 4075, CAST(0x0000A8CC00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11362, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10331, 4075, CAST(0x0000A8CD00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11363, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10332, 4075, CAST(0x0000A8CE00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11364, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10333, 4075, CAST(0x0000A8CF00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11365, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10334, 4075, CAST(0x0000A8D000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 11366, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10335, 4075, CAST(0x0000A8D100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>12</overtimeHours></ncdetails>', 0, 11367, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10336, 4075, CAST(0x0000A8D200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11368, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10337, 4064, CAST(0x0000A8B500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11369, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10338, 4064, CAST(0x0000A8B600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11370, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10339, 4064, CAST(0x0000A8B800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11371, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10340, 4064, CAST(0x0000A8B900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11372, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10341, 4064, CAST(0x0000A8BA00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11373, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10342, 4064, CAST(0x0000A8BB00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 11374, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10343, 4064, CAST(0x0000A8BC00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11375, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10344, 4064, CAST(0x0000A8BD00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11376, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10345, 4064, CAST(0x0000A8BE00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11377, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10346, 4064, CAST(0x0000A8BF00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11378, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10347, 4064, CAST(0x0000A8C000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11379, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10348, 4064, CAST(0x0000A8C100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11380, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10349, 4064, CAST(0x0000A8C200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 11381, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10350, 4064, CAST(0x0000A8C300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11382, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10351, 4064, CAST(0x0000A8C400000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11383, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10352, 4064, CAST(0x0000A8C500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11384, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10353, 4064, CAST(0x0000A8C600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11385, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10354, 4064, CAST(0x0000A8C700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11386, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10355, 4064, CAST(0x0000A8C800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11387, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10357, 4064, CAST(0x0000A8B700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11389, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10358, 4064, CAST(0x0000A8CA00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11390, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10359, 4064, CAST(0x0000A8CB00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11391, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10360, 4064, CAST(0x0000A8CC00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11392, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10361, 4064, CAST(0x0000A8CD00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11393, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10362, 4064, CAST(0x0000A8CE00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11394, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10363, 4064, CAST(0x0000A8CF00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11395, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10364, 4064, CAST(0x0000A8D000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 11396, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10365, 4064, CAST(0x0000A8D100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11397, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10366, 4064, CAST(0x0000A8D200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11398, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10367, 4064, CAST(0x0000A8C900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 11399, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10368, 4066, CAST(0x0000A8B500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11400, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10369, 4066, CAST(0x0000A8B600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11401, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10370, 4066, CAST(0x0000A8B700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11402, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10371, 4066, CAST(0x0000A8B800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11403, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10372, 4066, CAST(0x0000A8B900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11404, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10373, 4066, CAST(0x0000A8BA00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11405, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10374, 4066, CAST(0x0000A8BB00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 11406, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10375, 4066, CAST(0x0000A8BC00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11407, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10376, 4066, CAST(0x0000A8BD00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11408, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10377, 4066, CAST(0x0000A8BE00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11409, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10378, 4066, CAST(0x0000A8BF00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11410, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10379, 4066, CAST(0x0000A8C000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11411, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10380, 4066, CAST(0x0000A8C100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11412, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10381, 4066, CAST(0x0000A8C200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 11413, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10382, 4066, CAST(0x0000A8C300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11414, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10383, 4066, CAST(0x0000A8C400000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11415, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10384, 4066, CAST(0x0000A8C500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11416, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10385, 4066, CAST(0x0000A8C600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11417, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10386, 4066, CAST(0x0000A8C700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11418, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10387, 4066, CAST(0x0000A8C800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11419, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10388, 4066, CAST(0x0000A8C900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 11420, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10389, 4066, CAST(0x0000A8CA00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11421, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10390, 4066, CAST(0x0000A8CB00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11422, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10391, 4066, CAST(0x0000A8CC00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11423, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10392, 4066, CAST(0x0000A8CD00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11424, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10393, 4066, CAST(0x0000A8CE00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11425, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10394, 4066, CAST(0x0000A8CF00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11426, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10395, 4066, CAST(0x0000A8D000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 11427, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10396, 4066, CAST(0x0000A8D100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11428, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10397, 4066, CAST(0x0000A8D200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11429, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10398, 4068, CAST(0x0000A8B500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11430, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10399, 4068, CAST(0x0000A8B600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11431, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10400, 4068, CAST(0x0000A8B700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11432, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10401, 4068, CAST(0x0000A8B800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11433, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10402, 4068, CAST(0x0000A8B900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11434, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10403, 4068, CAST(0x0000A8BA00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11435, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10404, 4068, CAST(0x0000A8BB00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 11436, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10405, 4068, CAST(0x0000A8BC00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11437, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10406, 4068, CAST(0x0000A8BD00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11438, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10407, 4068, CAST(0x0000A8BE00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11439, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10408, 4068, CAST(0x0000A8BF00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11440, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10409, 4068, CAST(0x0000A8C000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11441, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10410, 4068, CAST(0x0000A8C100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11442, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10411, 4068, CAST(0x0000A8C200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 11443, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10412, 4068, CAST(0x0000A8C300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11444, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10413, 4068, CAST(0x0000A8C400000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11445, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10414, 4068, CAST(0x0000A8C500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11446, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10415, 4068, CAST(0x0000A8C600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11447, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10416, 4068, CAST(0x0000A8C700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11448, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10417, 4068, CAST(0x0000A8C800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11449, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10418, 4068, CAST(0x0000A8C900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 11450, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10419, 4068, CAST(0x0000A8CA00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11451, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10420, 4068, CAST(0x0000A8CB00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11452, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10421, 4068, CAST(0x0000A8CC00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11453, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10422, 4068, CAST(0x0000A8CD00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11454, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10423, 4068, CAST(0x0000A8CE00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11455, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10424, 4068, CAST(0x0000A8CF00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11456, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10425, 4068, CAST(0x0000A8D000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 11457, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10426, 4068, CAST(0x0000A8D100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11458, 0)
GO
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10427, 4068, CAST(0x0000A8D200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11459, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10428, 4070, CAST(0x0000A8B500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11460, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10429, 4070, CAST(0x0000A8B600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11461, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10430, 4070, CAST(0x0000A8B700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11462, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10431, 4070, CAST(0x0000A8B800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11463, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10432, 4070, CAST(0x0000A8B900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11464, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10433, 4070, CAST(0x0000A8BA00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11465, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10434, 4070, CAST(0x0000A8BB00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 11466, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10435, 4070, CAST(0x0000A8BC00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11467, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10436, 4070, CAST(0x0000A8BD00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11468, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10437, 4070, CAST(0x0000A8BE00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11469, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10438, 4070, CAST(0x0000A8BF00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11470, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10439, 4070, CAST(0x0000A8C000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11471, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10440, 4070, CAST(0x0000A8C100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11472, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10441, 4070, CAST(0x0000A8C200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 11473, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10442, 4070, CAST(0x0000A8C300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11474, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10443, 4070, CAST(0x0000A8C400000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11475, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10444, 4070, CAST(0x0000A8C500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11476, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10445, 4070, CAST(0x0000A8C600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11477, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10446, 4070, CAST(0x0000A8C700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11478, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10447, 4070, CAST(0x0000A8C800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11479, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10448, 4070, CAST(0x0000A8C900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 11480, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10449, 4070, CAST(0x0000A8CA00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11481, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10450, 4070, CAST(0x0000A8CB00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11482, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10451, 4070, CAST(0x0000A8CC00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11483, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10452, 4070, CAST(0x0000A8CD00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11484, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10453, 4070, CAST(0x0000A8CE00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11485, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10454, 4070, CAST(0x0000A8CF00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11486, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10455, 4070, CAST(0x0000A8D000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 11487, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10456, 4070, CAST(0x0000A8D100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11488, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10457, 4070, CAST(0x0000A8D200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11489, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10458, 4072, CAST(0x0000A8B500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11490, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10459, 4072, CAST(0x0000A8B600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11491, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10460, 4072, CAST(0x0000A8B700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11492, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10461, 4072, CAST(0x0000A8B800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11493, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10462, 4072, CAST(0x0000A8B900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11494, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10463, 4072, CAST(0x0000A8BA00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11495, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10464, 4072, CAST(0x0000A8BB00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 11496, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10465, 4072, CAST(0x0000A8BC00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11497, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10466, 4072, CAST(0x0000A8BD00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11498, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10467, 4072, CAST(0x0000A8BE00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11499, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10468, 4072, CAST(0x0000A8BF00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11500, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10469, 4072, CAST(0x0000A8C000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11501, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10470, 4072, CAST(0x0000A8C100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11502, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10471, 4072, CAST(0x0000A8C200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 11503, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10472, 4072, CAST(0x0000A8C300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11504, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10473, 4072, CAST(0x0000A8C400000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11505, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10474, 4072, CAST(0x0000A8C500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11506, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10475, 4072, CAST(0x0000A8C600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11507, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10476, 4072, CAST(0x0000A8C700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11508, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10477, 4072, CAST(0x0000A8C800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11509, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10478, 4072, CAST(0x0000A8C900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 11510, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10479, 4072, CAST(0x0000A8CA00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11511, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10480, 4072, CAST(0x0000A8CB00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11512, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10481, 4072, CAST(0x0000A8CC00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11513, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10482, 4072, CAST(0x0000A8CD00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11514, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10483, 4072, CAST(0x0000A8CE00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11515, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10484, 4072, CAST(0x0000A8CF00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11516, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10485, 4072, CAST(0x0000A8D000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 11517, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10486, 4072, CAST(0x0000A8D100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11518, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10487, 4072, CAST(0x0000A8D200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11519, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10488, 4074, CAST(0x0000A8B500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11520, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10489, 4074, CAST(0x0000A8B600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11521, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10490, 4074, CAST(0x0000A8B700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11522, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10491, 4074, CAST(0x0000A8B800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11523, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10492, 4074, CAST(0x0000A8B900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11524, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10493, 4074, CAST(0x0000A8BA00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11525, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10494, 4074, CAST(0x0000A8BB00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 11526, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10495, 4074, CAST(0x0000A8BC00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11527, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10496, 4074, CAST(0x0000A8BD00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11528, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10497, 4074, CAST(0x0000A8BE00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11529, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10498, 4074, CAST(0x0000A8BF00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11530, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10499, 4074, CAST(0x0000A8C000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11531, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10500, 4074, CAST(0x0000A8C100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11532, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10501, 4074, CAST(0x0000A8C200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 11533, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10502, 4074, CAST(0x0000A8C300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11534, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10503, 4074, CAST(0x0000A8C400000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11535, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10504, 4074, CAST(0x0000A8C500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11536, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10505, 4074, CAST(0x0000A8C600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11537, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10506, 4074, CAST(0x0000A8C700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11538, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10507, 4074, CAST(0x0000A8C800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11539, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10508, 4074, CAST(0x0000A8C900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 11540, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10509, 4074, CAST(0x0000A8CA00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11541, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10510, 4074, CAST(0x0000A8CB00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11542, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10511, 4074, CAST(0x0000A8CC00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11543, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10512, 4074, CAST(0x0000A8CD00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11544, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10513, 4074, CAST(0x0000A8CE00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11545, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10514, 4074, CAST(0x0000A8CF00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11546, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10515, 4074, CAST(0x0000A8D000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 11547, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10516, 4074, CAST(0x0000A8D100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11548, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10517, 4074, CAST(0x0000A8D200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11549, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10518, 4076, CAST(0x0000A8B500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11550, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10519, 4076, CAST(0x0000A8B600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11551, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10520, 4076, CAST(0x0000A8B700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11552, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10521, 4076, CAST(0x0000A8B800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11553, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10522, 4076, CAST(0x0000A8B900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11554, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10523, 4076, CAST(0x0000A8BA00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11555, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10524, 4076, CAST(0x0000A8BB00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 11556, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10525, 4076, CAST(0x0000A8BC00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11557, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10526, 4076, CAST(0x0000A8BD00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11558, 0)
GO
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10527, 4076, CAST(0x0000A8BE00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11559, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10528, 4076, CAST(0x0000A8BF00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11560, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10529, 4076, CAST(0x0000A8C000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11561, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10530, 4076, CAST(0x0000A8C100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11562, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10531, 4076, CAST(0x0000A8C200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 11563, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10532, 4076, CAST(0x0000A8C300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11564, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10533, 4076, CAST(0x0000A8C400000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11565, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10534, 4076, CAST(0x0000A8C500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11566, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10535, 4076, CAST(0x0000A8C600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11567, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10536, 4076, CAST(0x0000A8C700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11568, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10537, 4076, CAST(0x0000A8C800000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11569, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10538, 4076, CAST(0x0000A8C900000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 11570, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10539, 4076, CAST(0x0000A8CA00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11571, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10540, 4076, CAST(0x0000A8CB00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11572, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10541, 4076, CAST(0x0000A8CC00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11573, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10542, 4076, CAST(0x0000A8CD00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11574, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10543, 4076, CAST(0x0000A8CE00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11575, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10544, 4076, CAST(0x0000A8CF00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11576, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10545, 4076, CAST(0x0000A8D000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 11577, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10546, 4076, CAST(0x0000A8D100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>11</overtimeHours></ncdetails>', 0, 11578, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10547, 4076, CAST(0x0000A8D200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>25</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 11579, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (11516, 4063, CAST(0x0000A8D300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>42</minsevendaysrest><mintwentyfourhoursrest>21</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>12</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>3</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 12548, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (11517, 4063, CAST(0x0000A8F300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>40</minsevendaysrest><mintwentyfourhoursrest>20</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>10</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>4</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 12549, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (12516, 6080, CAST(0x0000A8D300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>37</minsevendaysrest><mintwentyfourhoursrest>18</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>18</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 13548, 0)
SET IDENTITY_INSERT [dbo].[NCDetails] OFF
SET IDENTITY_INSERT [dbo].[Permissions] ON 

INSERT [dbo].[Permissions] ([ID], [PermissionName], [ParentPermissionID], [SplitByRank]) VALUES (1, N'Rank', NULL, 0)
INSERT [dbo].[Permissions] ([ID], [PermissionName], [ParentPermissionID], [SplitByRank]) VALUES (3, N'Add', 1, 0)
INSERT [dbo].[Permissions] ([ID], [PermissionName], [ParentPermissionID], [SplitByRank]) VALUES (4, N'Edit', 1, 0)
INSERT [dbo].[Permissions] ([ID], [PermissionName], [ParentPermissionID], [SplitByRank]) VALUES (5, N'Delete', 1, 0)
INSERT [dbo].[Permissions] ([ID], [PermissionName], [ParentPermissionID], [SplitByRank]) VALUES (6, N'Access', 1, 0)
INSERT [dbo].[Permissions] ([ID], [PermissionName], [ParentPermissionID], [SplitByRank]) VALUES (7, N'Crew', NULL, 0)
INSERT [dbo].[Permissions] ([ID], [PermissionName], [ParentPermissionID], [SplitByRank]) VALUES (8, N'Add', 7, 0)
INSERT [dbo].[Permissions] ([ID], [PermissionName], [ParentPermissionID], [SplitByRank]) VALUES (9, N'Edit', 7, 0)
INSERT [dbo].[Permissions] ([ID], [PermissionName], [ParentPermissionID], [SplitByRank]) VALUES (10, N'Delete', 7, 0)
INSERT [dbo].[Permissions] ([ID], [PermissionName], [ParentPermissionID], [SplitByRank]) VALUES (11, N'Access', 7, 0)
SET IDENTITY_INSERT [dbo].[Permissions] OFF
SET IDENTITY_INSERT [dbo].[Ranks] ON 

INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled]) VALUES (9, N'Chief Off / SDPO', N'Chief Off / SDPO', 2, NULL, 0, NULL, NULL, 1)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled]) VALUES (10, N'Master / SDPO', N'Master / SDPO', 1, NULL, 0, NULL, NULL, 1)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled]) VALUES (11, N'2nd Off / DPO', N'2nd Off / DPO', 3, NULL, 0, NULL, NULL, 1)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled]) VALUES (12, N'Chief Engineer', N'Chief Engineer', 4, NULL, 0, NULL, NULL, 1)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled]) VALUES (1032, N'1st Engineer', N'1st Engineer', 5, NULL, 0, NULL, NULL, 1)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled]) VALUES (1033, N'ETO', N'ETO', 6, NULL, 0, NULL, NULL, 1)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled]) VALUES (1034, N'3rd Engineer', N'3rd Engineer', 7, NULL, 0, NULL, NULL, 1)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled]) VALUES (1035, N'Bosun / Crane', N'Bosun / Crane', 8, NULL, 0, NULL, NULL, 1)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled]) VALUES (1036, N'Crane Operator', N'Crane Operator', 9, NULL, 0, NULL, NULL, 1)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled]) VALUES (1037, N'AB', N'AB', 10, NULL, 0, NULL, NULL, 1)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled]) VALUES (1038, N'Fitter', N'Fitter', 11, NULL, 0, NULL, NULL, 1)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled]) VALUES (1039, N'Oiler', N'Oiler', 12, NULL, 0, NULL, NULL, 1)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled]) VALUES (1040, N'Cook', N'Cook', 13, NULL, 0, NULL, NULL, 1)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled]) VALUES (1041, N'Steward', N'Steward', 14, NULL, 0, NULL, NULL, 1)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled]) VALUES (1043, N'R Test ', N'D Test', 15, NULL, 0, NULL, NULL, 0)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled]) VALUES (1044, N'O/S', N'New', 16, NULL, 0, NULL, NULL, 0)
INSERT [dbo].[Ranks] ([ID], [RankName], [Description], [Order], [ScheduleID], [Deleted], [LatestUpdate], [DefaultScheduleComments], [Scheduled]) VALUES (1045, N'2nd Cook', N'2nd Cook', 17, NULL, 0, NULL, NULL, 0)
SET IDENTITY_INSERT [dbo].[Ranks] OFF
SET IDENTITY_INSERT [dbo].[Regimes] ON 

INSERT [dbo].[Regimes] ([ID], [RegimeName], [Description], [Basis], [MinTotalRestIn7Days], [MaxTotalWorkIn24Hours], [MinContRestIn24Hours], [MinTotalRestIn24Hours], [MaxTotalWorkIn7Days], [CheckFor2Days], [OPA90], [ManilaExceptions], [UseHistCalculationOnly], [CheckOnlyWorkHours]) VALUES (1, N'IMO STCW', N'IMO STCW Convention (Regulation VIII/1) concerning minimum rest hours', N'rest', 70, 14, 6, 10, 98, 0, 1, NULL, 1, 1)
INSERT [dbo].[Regimes] ([ID], [RegimeName], [Description], [Basis], [MinTotalRestIn7Days], [MaxTotalWorkIn24Hours], [MinContRestIn24Hours], [MinTotalRestIn24Hours], [MaxTotalWorkIn7Days], [CheckFor2Days], [OPA90], [ManilaExceptions], [UseHistCalculationOnly], [CheckOnlyWorkHours]) VALUES (2, N'ILO Rest (Flexible)', N'ILO Convention No 180 based on minimum rest hours (Article 5 1b)', N'rest', 77, 14, 6, 10, 91, 0, 0, NULL, 1, 1)
INSERT [dbo].[Regimes] ([ID], [RegimeName], [Description], [Basis], [MinTotalRestIn7Days], [MaxTotalWorkIn24Hours], [MinContRestIn24Hours], [MinTotalRestIn24Hours], [MaxTotalWorkIn7Days], [CheckFor2Days], [OPA90], [ManilaExceptions], [UseHistCalculationOnly], [CheckOnlyWorkHours]) VALUES (3, N'ILO Work', N'ILO Convention No 180 based on maximum hours of work (Article 5 1a)', N'work', 96, 14, 6, 10, 72, 0, 1, NULL, 0, 1)
INSERT [dbo].[Regimes] ([ID], [RegimeName], [Description], [Basis], [MinTotalRestIn7Days], [MaxTotalWorkIn24Hours], [MinContRestIn24Hours], [MinTotalRestIn24Hours], [MaxTotalWorkIn7Days], [CheckFor2Days], [OPA90], [ManilaExceptions], [UseHistCalculationOnly], [CheckOnlyWorkHours]) VALUES (4, N'Customised', N'Based on collective agreement or national regulations', N'rest', 70, 14, 6, 10, 93, 0, 1, NULL, 1, 1)
INSERT [dbo].[Regimes] ([ID], [RegimeName], [Description], [Basis], [MinTotalRestIn7Days], [MaxTotalWorkIn24Hours], [MinContRestIn24Hours], [MinTotalRestIn24Hours], [MaxTotalWorkIn7Days], [CheckFor2Days], [OPA90], [ManilaExceptions], [UseHistCalculationOnly], [CheckOnlyWorkHours]) VALUES (5, N'ILO Rest', N'ILO Convention No 180 based on minimum rest hours (Article 5 1b)', N'rest', 77, 14, 6, 10, 91, 0, 0, NULL, 1, 1)
INSERT [dbo].[Regimes] ([ID], [RegimeName], [Description], [Basis], [MinTotalRestIn7Days], [MaxTotalWorkIn24Hours], [MinContRestIn24Hours], [MinTotalRestIn24Hours], [MaxTotalWorkIn7Days], [CheckFor2Days], [OPA90], [ManilaExceptions], [UseHistCalculationOnly], [CheckOnlyWorkHours]) VALUES (6, N'IMO STCW 2010', N'IMO STCW 2010 Convention (Regulation VIII/1) concerning minimum rest hours', N'rest', 77, 14, 6, 10, 91, 0, 0, 0, 1, 1)
INSERT [dbo].[Regimes] ([ID], [RegimeName], [Description], [Basis], [MinTotalRestIn7Days], [MaxTotalWorkIn24Hours], [MinContRestIn24Hours], [MinTotalRestIn24Hours], [MaxTotalWorkIn7Days], [CheckFor2Days], [OPA90], [ManilaExceptions], [UseHistCalculationOnly], [CheckOnlyWorkHours]) VALUES (7, N'OCIMF', N'OCIMF Historical Regime', N'rest', 77, 14, 6, 10, 91, 0, 0, 0, 1, 0)
SET IDENTITY_INSERT [dbo].[Regimes] OFF
SET IDENTITY_INSERT [dbo].[ServiceTerms] ON 

INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (4028, CAST(0x0000A8B700000000 AS DateTime), CAST(0x0000A8D200000000 AS DateTime), 4064, NULL, NULL, 11, 0)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (4029, CAST(0x0000A8B500000000 AS DateTime), CAST(0x0000A8C700000000 AS DateTime), 4065, NULL, NULL, 1034, 0)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (4030, CAST(0x0000A8B500000000 AS DateTime), CAST(0x0000A8BD00000000 AS DateTime), 4066, NULL, NULL, 1037, 0)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (4031, CAST(0x0000A8B700000000 AS DateTime), CAST(0x0000A8CE00000000 AS DateTime), 4067, NULL, NULL, 1037, 0)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (4032, CAST(0x0000A8B500000000 AS DateTime), CAST(0x0000A8D200000000 AS DateTime), 4068, NULL, NULL, 1044, 0)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (4033, CAST(0x0000A8B800000000 AS DateTime), CAST(0x0000A8D200000000 AS DateTime), 4069, NULL, NULL, 1044, 0)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (4034, CAST(0x0000A8BA00000000 AS DateTime), CAST(0x0000A8CD00000000 AS DateTime), 4070, NULL, NULL, 12, 0)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (4035, CAST(0x0000A8BA00000000 AS DateTime), CAST(0x0000A8CD00000000 AS DateTime), 4071, NULL, NULL, 1034, 0)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (4036, CAST(0x0000A8BA00000000 AS DateTime), CAST(0x0000A8C500000000 AS DateTime), 4072, NULL, NULL, 1039, 0)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (4037, CAST(0x0000A8B800000000 AS DateTime), CAST(0x0000A8CD00000000 AS DateTime), 4073, NULL, NULL, 1039, 0)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (4038, CAST(0x0000A8BA00000000 AS DateTime), CAST(0x0000A8CC00000000 AS DateTime), 4074, NULL, NULL, 1040, 0)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (4039, CAST(0x0000A8B500000000 AS DateTime), CAST(0x0000A8D200000000 AS DateTime), 4075, NULL, NULL, 1045, 0)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (4040, CAST(0x0000A8BF00000000 AS DateTime), CAST(0x0000A8CE00000000 AS DateTime), 4076, NULL, NULL, 1041, 0)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (4041, CAST(0x00009BDE00000000 AS DateTime), CAST(0x0000A8C500000000 AS DateTime), 4077, NULL, NULL, 1041, 0)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (5041, CAST(0x0000A8B800000000 AS DateTime), CAST(0x0000A8CB00000000 AS DateTime), 5077, NULL, NULL, 9, 0)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (6041, CAST(0x0000A8B500000000 AS DateTime), CAST(0x0000A8D200000000 AS DateTime), 6077, NULL, NULL, 9, 0)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (6042, CAST(0x0000A8B500000000 AS DateTime), CAST(0x0000A8CC00000000 AS DateTime), 6078, NULL, NULL, 9, 0)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (6043, CAST(0x0000A8B700000000 AS DateTime), CAST(0x0000A8C600000000 AS DateTime), 6079, NULL, NULL, 9, 0)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (6044, CAST(0x0000A8D300000000 AS DateTime), CAST(0x0000A8F100000000 AS DateTime), 6080, NULL, NULL, 9, 0)
SET IDENTITY_INSERT [dbo].[ServiceTerms] OFF
SET IDENTITY_INSERT [dbo].[Ship] ON 

INSERT [dbo].[Ship] ([ID], [ShipName], [IMONumber], [FlagOfShip], [Regime]) VALUES (1, N'Karaboujam', N'IMO1', N'Belgium', 3)
SET IDENTITY_INSERT [dbo].[Ship] OFF
INSERT [dbo].[TimeAdjustment] ([AdjustmentDate], [AdjustmentValue]) VALUES (CAST(0x0000A8F200000000 AS DateTime), N'+1')
INSERT [dbo].[TimeAdjustment] ([AdjustmentDate], [AdjustmentValue]) VALUES (CAST(0x0000A96900000000 AS DateTime), N'+1D')
INSERT [dbo].[TimeAdjustment] ([AdjustmentDate], [AdjustmentValue]) VALUES (CAST(0x0000A98B00000000 AS DateTime), N'-30')
SET IDENTITY_INSERT [dbo].[UserGroups] ON 

INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID]) VALUES (42, 34, 13)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID]) VALUES (44, 36, 14)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID]) VALUES (45, 37, 15)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID]) VALUES (46, 38, 15)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID]) VALUES (47, 39, 15)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID]) VALUES (48, 40, 15)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID]) VALUES (49, 41, 15)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID]) VALUES (50, 42, 15)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID]) VALUES (51, 43, 15)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID]) VALUES (52, 44, 15)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID]) VALUES (53, 45, 15)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID]) VALUES (54, 46, 15)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID]) VALUES (55, 47, 15)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID]) VALUES (56, 48, 15)
SET IDENTITY_INSERT [dbo].[UserGroups] OFF
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId]) VALUES (34, N'sa', N'admin', 1, 1, NULL)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId]) VALUES (35, N'admin0', N'admin', 1, 1, 4063)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId]) VALUES (36, N'admin1', N'admin', 1, 1, 4064)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId]) VALUES (37, N'User1', N'admin', 1, 1, 4065)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId]) VALUES (38, N'User2', N'admin', 1, 1, 4066)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId]) VALUES (39, N'User3', N'admin', 1, 1, 4067)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId]) VALUES (40, N'User4', N'admin', 1, 1, 4068)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId]) VALUES (41, N'User5', N'admin', 1, 1, 4069)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId]) VALUES (42, N'User6', N'admin', 1, 1, 4070)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId]) VALUES (43, N'User7', N'admin', 1, 1, 4071)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId]) VALUES (44, N'User8', N'admin', 1, 1, 4072)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId]) VALUES (45, N'User9', N'admin', 1, 1, 4073)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId]) VALUES (46, N'User10', N'admin', 1, 1, 4074)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId]) VALUES (47, N'User11', N'admin', 1, 1, 4075)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId]) VALUES (48, N'User12', N'admin', 1, 1, 4076)
SET IDENTITY_INSERT [dbo].[Users] OFF
SET IDENTITY_INSERT [dbo].[WorkSessions] ON 

INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11159, 4063, CAST(0x0000A8B500000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901533C8D AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11160, 4063, CAST(0x0000A8B600000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B9015364AB AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11161, 4063, CAST(0x0000A8B700000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90153773B AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11162, 4063, CAST(0x0000A8B800000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B9015382E9 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11163, 4063, CAST(0x0000A8B900000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901538DDA AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11164, 4063, CAST(0x0000A8BA00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901539AB0 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11165, 4063, CAST(0x0000A8BB00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90153ADBE AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11166, 4063, CAST(0x0000A8BC00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901540965 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11167, 4063, CAST(0x0000A8BD00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B9015417AB AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11168, 4063, CAST(0x0000A8BE00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154262E AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11169, 4063, CAST(0x0000A8BF00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901543651 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11170, 4063, CAST(0x0000A8C000000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901544F31 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11171, 4063, CAST(0x0000A8C100000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901545FE7 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11172, 4063, CAST(0x0000A8C200000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901546C0C AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11173, 4063, CAST(0x0000A8C300000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901547C00 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11174, 4063, CAST(0x0000A8C400000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901548A56 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11175, 4063, CAST(0x0000A8C500000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901549A79 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11176, 4063, CAST(0x0000A8C600000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154A715 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11177, 4063, CAST(0x0000A8C700000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154B0ED AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11178, 4063, CAST(0x0000A8C800000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154C114 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11179, 4063, CAST(0x0000A8C900000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154CA8E AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11180, 4063, CAST(0x0000A8CA00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154D468 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11181, 4063, CAST(0x0000A8CB00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154DCF8 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11182, 4063, CAST(0x0000A8CC00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154E5C3 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11183, 4063, CAST(0x0000A8CD00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154F0A2 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11184, 4063, CAST(0x0000A8CE00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154FD56 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11185, 4063, CAST(0x0000A8CF00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901550812 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11186, 4063, CAST(0x0000A8D000000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901550FFE AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11187, 4063, CAST(0x0000A8D100000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901551A22 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11188, 4063, CAST(0x0000A8D200000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B9015542E5 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11189, 4065, CAST(0x0000A8B500000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901533C8D AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11190, 4065, CAST(0x0000A8B600000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B9015364AB AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11191, 4065, CAST(0x0000A8B700000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90153773B AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11192, 4065, CAST(0x0000A8B800000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B9015382E9 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11193, 4065, CAST(0x0000A8B900000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901538DDA AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11194, 4065, CAST(0x0000A8BA00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901539AB0 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11195, 4065, CAST(0x0000A8BB00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90153ADBE AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11196, 4065, CAST(0x0000A8BC00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901540965 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11197, 4065, CAST(0x0000A8BD00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B9015417AB AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11198, 4065, CAST(0x0000A8BE00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154262E AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11199, 4065, CAST(0x0000A8BF00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901543651 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11200, 4065, CAST(0x0000A8C000000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901544F31 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11201, 4065, CAST(0x0000A8C100000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901545FE7 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11202, 4065, CAST(0x0000A8C200000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901546C0C AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11203, 4065, CAST(0x0000A8C300000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901547C00 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11204, 4065, CAST(0x0000A8C400000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901548A56 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11205, 4065, CAST(0x0000A8C500000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901549A79 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11206, 4065, CAST(0x0000A8C600000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154A715 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11207, 4065, CAST(0x0000A8C700000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154B0ED AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11208, 4065, CAST(0x0000A8C800000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154C114 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11209, 4065, CAST(0x0000A8C900000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154CA8E AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11210, 4065, CAST(0x0000A8CA00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154D468 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11211, 4065, CAST(0x0000A8CB00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154DCF8 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11212, 4065, CAST(0x0000A8CC00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154E5C3 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11213, 4065, CAST(0x0000A8CD00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154F0A2 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11214, 4065, CAST(0x0000A8CE00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154FD56 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11215, 4065, CAST(0x0000A8CF00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901550812 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11216, 4065, CAST(0x0000A8D000000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901550FFE AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11217, 4065, CAST(0x0000A8D100000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901551A22 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11218, 4065, CAST(0x0000A8D200000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B9015542E5 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11219, 4067, CAST(0x0000A8B500000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901533C8D AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11220, 4067, CAST(0x0000A8B600000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B9015364AB AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11221, 4067, CAST(0x0000A8B700000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90153773B AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11222, 4067, CAST(0x0000A8B800000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B9015382E9 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11223, 4067, CAST(0x0000A8B900000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901538DDA AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11224, 4067, CAST(0x0000A8BA00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901539AB0 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11225, 4067, CAST(0x0000A8BB00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90153ADBE AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11226, 4067, CAST(0x0000A8BC00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901540965 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11227, 4067, CAST(0x0000A8BD00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B9015417AB AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11228, 4067, CAST(0x0000A8BE00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154262E AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11229, 4067, CAST(0x0000A8BF00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901543651 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11230, 4067, CAST(0x0000A8C000000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901544F31 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11231, 4067, CAST(0x0000A8C100000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901545FE7 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11232, 4067, CAST(0x0000A8C200000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901546C0C AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11233, 4067, CAST(0x0000A8C300000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901547C00 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11234, 4067, CAST(0x0000A8C400000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901548A56 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11235, 4067, CAST(0x0000A8C500000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901549A79 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11236, 4067, CAST(0x0000A8C600000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154A715 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11237, 4067, CAST(0x0000A8C700000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154B0ED AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11238, 4067, CAST(0x0000A8C800000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154C114 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11239, 4067, CAST(0x0000A8C900000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154CA8E AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11240, 4067, CAST(0x0000A8CA00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154D468 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11241, 4067, CAST(0x0000A8CB00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154DCF8 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11242, 4067, CAST(0x0000A8CC00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154E5C3 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11243, 4067, CAST(0x0000A8CD00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154F0A2 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11244, 4067, CAST(0x0000A8CE00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154FD56 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11245, 4067, CAST(0x0000A8CF00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901550812 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11246, 4067, CAST(0x0000A8D000000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901550FFE AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11247, 4067, CAST(0x0000A8D100000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901551A22 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11248, 4067, CAST(0x0000A8D200000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B9015542E5 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11249, 4069, CAST(0x0000A8B500000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901533C8D AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11250, 4069, CAST(0x0000A8B600000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B9015364AB AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11251, 4069, CAST(0x0000A8B700000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90153773B AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11252, 4069, CAST(0x0000A8B800000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B9015382E9 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11253, 4069, CAST(0x0000A8B900000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901538DDA AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11254, 4069, CAST(0x0000A8BA00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901539AB0 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11255, 4069, CAST(0x0000A8BB00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90153ADBE AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11256, 4069, CAST(0x0000A8BC00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901540965 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11257, 4069, CAST(0x0000A8BD00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B9015417AB AS DateTime), 1, N'08:00,20:00', NULL, N'0')
GO
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11258, 4069, CAST(0x0000A8BE00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154262E AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11259, 4069, CAST(0x0000A8BF00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901543651 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11260, 4069, CAST(0x0000A8C000000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901544F31 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11261, 4069, CAST(0x0000A8C100000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901545FE7 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11262, 4069, CAST(0x0000A8C200000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901546C0C AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11263, 4069, CAST(0x0000A8C300000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901547C00 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11264, 4069, CAST(0x0000A8C400000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901548A56 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11265, 4069, CAST(0x0000A8C500000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901549A79 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11266, 4069, CAST(0x0000A8C600000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154A715 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11267, 4069, CAST(0x0000A8C700000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154B0ED AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11268, 4069, CAST(0x0000A8C800000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154C114 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11269, 4069, CAST(0x0000A8C900000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154CA8E AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11270, 4069, CAST(0x0000A8CA00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154D468 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11271, 4069, CAST(0x0000A8CB00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154DCF8 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11272, 4069, CAST(0x0000A8CC00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154E5C3 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11273, 4069, CAST(0x0000A8CD00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154F0A2 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11274, 4069, CAST(0x0000A8CE00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154FD56 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11275, 4069, CAST(0x0000A8CF00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901550812 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11276, 4069, CAST(0x0000A8D000000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901550FFE AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11277, 4069, CAST(0x0000A8D100000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901551A22 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11278, 4069, CAST(0x0000A8D200000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B9015542E5 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11279, 4071, CAST(0x0000A8B500000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901533C8D AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11280, 4071, CAST(0x0000A8B600000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B9015364AB AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11281, 4071, CAST(0x0000A8B700000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90153773B AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11282, 4071, CAST(0x0000A8B800000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B9015382E9 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11283, 4071, CAST(0x0000A8B900000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901538DDA AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11284, 4071, CAST(0x0000A8BA00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901539AB0 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11285, 4071, CAST(0x0000A8BB00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90153ADBE AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11286, 4071, CAST(0x0000A8BC00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901540965 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11287, 4071, CAST(0x0000A8BD00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B9015417AB AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11288, 4071, CAST(0x0000A8BE00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154262E AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11289, 4071, CAST(0x0000A8BF00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901543651 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11290, 4071, CAST(0x0000A8C000000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901544F31 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11291, 4071, CAST(0x0000A8C100000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901545FE7 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11292, 4071, CAST(0x0000A8C200000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901546C0C AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11293, 4071, CAST(0x0000A8C300000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901547C00 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11294, 4071, CAST(0x0000A8C400000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901548A56 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11295, 4071, CAST(0x0000A8C500000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901549A79 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11296, 4071, CAST(0x0000A8C600000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154A715 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11297, 4071, CAST(0x0000A8C700000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154B0ED AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11298, 4071, CAST(0x0000A8C800000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154C114 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11299, 4071, CAST(0x0000A8C900000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154CA8E AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11300, 4071, CAST(0x0000A8CA00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154D468 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11301, 4071, CAST(0x0000A8CB00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154DCF8 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11302, 4071, CAST(0x0000A8CC00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154E5C3 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11303, 4071, CAST(0x0000A8CD00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154F0A2 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11304, 4071, CAST(0x0000A8CE00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154FD56 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11305, 4071, CAST(0x0000A8CF00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901550812 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11306, 4071, CAST(0x0000A8D000000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901550FFE AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11307, 4071, CAST(0x0000A8D100000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901551A22 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11308, 4071, CAST(0x0000A8D200000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B9015542E5 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11309, 4073, CAST(0x0000A8B500000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901533C8D AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11310, 4073, CAST(0x0000A8B600000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B9015364AB AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11311, 4073, CAST(0x0000A8B700000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90153773B AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11312, 4073, CAST(0x0000A8B800000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B9015382E9 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11313, 4073, CAST(0x0000A8B900000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901538DDA AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11314, 4073, CAST(0x0000A8BA00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901539AB0 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11315, 4073, CAST(0x0000A8BB00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90153ADBE AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11316, 4073, CAST(0x0000A8BC00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901540965 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11317, 4073, CAST(0x0000A8BD00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B9015417AB AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11318, 4073, CAST(0x0000A8BE00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154262E AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11319, 4073, CAST(0x0000A8BF00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901543651 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11320, 4073, CAST(0x0000A8C000000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901544F31 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11321, 4073, CAST(0x0000A8C100000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901545FE7 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11322, 4073, CAST(0x0000A8C200000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901546C0C AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11323, 4073, CAST(0x0000A8C300000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901547C00 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11324, 4073, CAST(0x0000A8C400000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901548A56 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11325, 4073, CAST(0x0000A8C500000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901549A79 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11326, 4073, CAST(0x0000A8C600000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154A715 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11327, 4073, CAST(0x0000A8C700000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154B0ED AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11328, 4073, CAST(0x0000A8C800000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154C114 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11329, 4073, CAST(0x0000A8C900000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154CA8E AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11330, 4073, CAST(0x0000A8CA00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154D468 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11331, 4073, CAST(0x0000A8CB00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154DCF8 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11332, 4073, CAST(0x0000A8CC00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154E5C3 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11333, 4073, CAST(0x0000A8CD00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154F0A2 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11334, 4073, CAST(0x0000A8CE00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154FD56 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11335, 4073, CAST(0x0000A8CF00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901550812 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11336, 4073, CAST(0x0000A8D000000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901550FFE AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11337, 4073, CAST(0x0000A8D100000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901551A22 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11338, 4073, CAST(0x0000A8D200000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B9015542E5 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11339, 4075, CAST(0x0000A8B500000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901533C8D AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11340, 4075, CAST(0x0000A8B600000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B9015364AB AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11341, 4075, CAST(0x0000A8B700000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90153773B AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11342, 4075, CAST(0x0000A8B800000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B9015382E9 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11343, 4075, CAST(0x0000A8B900000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901538DDA AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11344, 4075, CAST(0x0000A8BA00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901539AB0 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11345, 4075, CAST(0x0000A8BB00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90153ADBE AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11346, 4075, CAST(0x0000A8BC00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901540965 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11347, 4075, CAST(0x0000A8BD00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B9015417AB AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11348, 4075, CAST(0x0000A8BE00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154262E AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11349, 4075, CAST(0x0000A8BF00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901543651 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11350, 4075, CAST(0x0000A8C000000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901544F31 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11351, 4075, CAST(0x0000A8C100000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901545FE7 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11352, 4075, CAST(0x0000A8C200000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901546C0C AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11353, 4075, CAST(0x0000A8C300000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901547C00 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11354, 4075, CAST(0x0000A8C400000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901548A56 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11355, 4075, CAST(0x0000A8C500000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901549A79 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11356, 4075, CAST(0x0000A8C600000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154A715 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11357, 4075, CAST(0x0000A8C700000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154B0ED AS DateTime), 1, N'08:00,20:00', NULL, N'0')
GO
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11358, 4075, CAST(0x0000A8C800000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154C114 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11359, 4075, CAST(0x0000A8C900000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154CA8E AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11360, 4075, CAST(0x0000A8CA00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154D468 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11361, 4075, CAST(0x0000A8CB00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154DCF8 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11362, 4075, CAST(0x0000A8CC00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154E5C3 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11363, 4075, CAST(0x0000A8CD00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154F0A2 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11364, 4075, CAST(0x0000A8CE00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B90154FD56 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11365, 4075, CAST(0x0000A8CF00000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901550812 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11366, 4075, CAST(0x0000A8D000000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901550FFE AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11367, 4075, CAST(0x0000A8D100000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B901551A22 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11368, 4075, CAST(0x0000A8D200000000 AS DateTime), N'000000000000000011111111111111111111111100000000', 0, N'', CAST(0x0000A8B9015542E5 AS DateTime), 1, N'08:00,20:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11369, 4064, CAST(0x0000A8B500000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01401604 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11370, 4064, CAST(0x0000A8B600000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01405F37 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11371, 4064, CAST(0x0000A8B800000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0140744D AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11372, 4064, CAST(0x0000A8B900000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01407B3B AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11373, 4064, CAST(0x0000A8BA00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014081AF AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11374, 4064, CAST(0x0000A8BB00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01408778 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11375, 4064, CAST(0x0000A8BC00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01409168 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11376, 4064, CAST(0x0000A8BD00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014099BE AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11377, 4064, CAST(0x0000A8BE00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0140ACF7 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11378, 4064, CAST(0x0000A8BF00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0140B692 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11379, 4064, CAST(0x0000A8C000000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0140BCD2 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11380, 4064, CAST(0x0000A8C100000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0140CF09 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11381, 4064, CAST(0x0000A8C200000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0140D6CB AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11382, 4064, CAST(0x0000A8C300000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0140DDE8 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11383, 4064, CAST(0x0000A8C400000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0140E2E2 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11384, 4064, CAST(0x0000A8C500000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0140EDAF AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11385, 4064, CAST(0x0000A8C600000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0140F810 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11386, 4064, CAST(0x0000A8C700000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0140FD66 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11387, 4064, CAST(0x0000A8C800000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014101C2 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11389, 4064, CAST(0x0000A8B700000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01417EB5 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11390, 4064, CAST(0x0000A8CA00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0141FEDE AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11391, 4064, CAST(0x0000A8CB00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0142098E AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11392, 4064, CAST(0x0000A8CC00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014211CB AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11393, 4064, CAST(0x0000A8CD00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01421A07 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11394, 4064, CAST(0x0000A8CE00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014221A7 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11395, 4064, CAST(0x0000A8CF00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0142276C AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11396, 4064, CAST(0x0000A8D000000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01422DFF AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11397, 4064, CAST(0x0000A8D100000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014234DD AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11398, 4064, CAST(0x0000A8D200000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01423DB4 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11399, 4064, CAST(0x0000A8C900000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0146E669 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11400, 4066, CAST(0x0000A8B500000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014750D6 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11401, 4066, CAST(0x0000A8B600000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01475DD7 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11402, 4066, CAST(0x0000A8B700000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014767CC AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11403, 4066, CAST(0x0000A8B800000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014773D0 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11404, 4066, CAST(0x0000A8B900000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01477C84 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11405, 4066, CAST(0x0000A8BA00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01478AA4 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11406, 4066, CAST(0x0000A8BB00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01479573 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11407, 4066, CAST(0x0000A8BC00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0147A11D AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11408, 4066, CAST(0x0000A8BD00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0147ADE5 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11409, 4066, CAST(0x0000A8BE00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0147B997 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11410, 4066, CAST(0x0000A8BF00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0147C5A4 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11411, 4066, CAST(0x0000A8C000000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0147D011 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11412, 4066, CAST(0x0000A8C100000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0147D9B7 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11413, 4066, CAST(0x0000A8C200000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0147E52B AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11414, 4066, CAST(0x0000A8C300000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0147F13D AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11415, 4066, CAST(0x0000A8C400000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014922EF AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11416, 4066, CAST(0x0000A8C500000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01492ABD AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11417, 4066, CAST(0x0000A8C600000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014931A2 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11418, 4066, CAST(0x0000A8C700000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01493C56 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11419, 4066, CAST(0x0000A8C800000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01494735 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11420, 4066, CAST(0x0000A8C900000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01495253 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11421, 4066, CAST(0x0000A8CA00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01495CAD AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11422, 4066, CAST(0x0000A8CB00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01496850 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11423, 4066, CAST(0x0000A8CC00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01497308 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11424, 4066, CAST(0x0000A8CD00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01497DAF AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11425, 4066, CAST(0x0000A8CE00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01498A17 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11426, 4066, CAST(0x0000A8CF00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014995FC AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11427, 4066, CAST(0x0000A8D000000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0149A418 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11428, 4066, CAST(0x0000A8D100000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0149B34F AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11429, 4066, CAST(0x0000A8D200000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0149BF96 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11430, 4068, CAST(0x0000A8B500000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014A8E21 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11431, 4068, CAST(0x0000A8B600000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014AA87A AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11432, 4068, CAST(0x0000A8B700000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014AB4BE AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11433, 4068, CAST(0x0000A8B800000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014AC3ED AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11434, 4068, CAST(0x0000A8B900000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014AD1F6 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11435, 4068, CAST(0x0000A8BA00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014ADF29 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11436, 4068, CAST(0x0000A8BB00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014AEB3D AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11437, 4068, CAST(0x0000A8BC00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014AF746 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11438, 4068, CAST(0x0000A8BD00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014B0563 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11439, 4068, CAST(0x0000A8BE00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014B115C AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11440, 4068, CAST(0x0000A8BF00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014B1A69 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11441, 4068, CAST(0x0000A8C000000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014B23C9 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11442, 4068, CAST(0x0000A8C100000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014B2F6B AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11443, 4068, CAST(0x0000A8C200000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014B3A62 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11444, 4068, CAST(0x0000A8C300000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014B46F8 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11445, 4068, CAST(0x0000A8C400000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014B4F36 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11446, 4068, CAST(0x0000A8C500000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014B5912 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11447, 4068, CAST(0x0000A8C600000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014B661B AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11448, 4068, CAST(0x0000A8C700000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014B6FF7 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11449, 4068, CAST(0x0000A8C800000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014B7B0D AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11450, 4068, CAST(0x0000A8C900000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014B8483 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11451, 4068, CAST(0x0000A8CA00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014B8DB1 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11452, 4068, CAST(0x0000A8CB00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014B97A7 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11453, 4068, CAST(0x0000A8CC00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014BA17B AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11454, 4068, CAST(0x0000A8CD00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014BB39F AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11455, 4068, CAST(0x0000A8CE00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014BBE6D AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11456, 4068, CAST(0x0000A8CF00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014BC7C5 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11457, 4068, CAST(0x0000A8D000000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014BD5D4 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11458, 4068, CAST(0x0000A8D100000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014BE000 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
GO
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11459, 4068, CAST(0x0000A8D200000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014BEACC AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11460, 4070, CAST(0x0000A8B500000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014D977D AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11461, 4070, CAST(0x0000A8B600000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014DA99B AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11462, 4070, CAST(0x0000A8B700000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014DB7C4 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11463, 4070, CAST(0x0000A8B800000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014DC1BB AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11464, 4070, CAST(0x0000A8B900000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014DD2DE AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11465, 4070, CAST(0x0000A8BA00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014E893F AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11466, 4070, CAST(0x0000A8BB00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014E922C AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11467, 4070, CAST(0x0000A8BC00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014E9951 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11468, 4070, CAST(0x0000A8BD00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014EA228 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11469, 4070, CAST(0x0000A8BE00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014EAC23 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11470, 4070, CAST(0x0000A8BF00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014EBA81 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11471, 4070, CAST(0x0000A8C000000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014EC7F0 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11472, 4070, CAST(0x0000A8C100000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014ECFCF AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11473, 4070, CAST(0x0000A8C200000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014EDC22 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11474, 4070, CAST(0x0000A8C300000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014EE6FE AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11475, 4070, CAST(0x0000A8C400000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014EF680 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11476, 4070, CAST(0x0000A8C500000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014F005C AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11477, 4070, CAST(0x0000A8C600000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014F0BCA AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11478, 4070, CAST(0x0000A8C700000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014F1823 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11479, 4070, CAST(0x0000A8C800000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014F2263 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11480, 4070, CAST(0x0000A8C900000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014F2BA0 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11481, 4070, CAST(0x0000A8CA00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014F33EA AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11482, 4070, CAST(0x0000A8CB00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014F3EE5 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11483, 4070, CAST(0x0000A8CC00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014F4779 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11484, 4070, CAST(0x0000A8CD00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014F5615 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11485, 4070, CAST(0x0000A8CE00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014F614E AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11486, 4070, CAST(0x0000A8CF00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014F6A02 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11487, 4070, CAST(0x0000A8D000000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014F74B8 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11488, 4070, CAST(0x0000A8D100000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014F82CC AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11489, 4070, CAST(0x0000A8D200000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA014F8B89 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11490, 4072, CAST(0x0000A8B500000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA015027AD AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11491, 4072, CAST(0x0000A8B600000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA015047CC AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11492, 4072, CAST(0x0000A8B700000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0150C6BC AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11493, 4072, CAST(0x0000A8B800000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0150CEE4 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11494, 4072, CAST(0x0000A8B900000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0150DA57 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11495, 4072, CAST(0x0000A8BA00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01515D02 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11496, 4072, CAST(0x0000A8BB00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA015166BB AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11497, 4072, CAST(0x0000A8BC00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01517021 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11498, 4072, CAST(0x0000A8BD00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01517B89 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11499, 4072, CAST(0x0000A8BE00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA015183BD AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11500, 4072, CAST(0x0000A8BF00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01518D12 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11501, 4072, CAST(0x0000A8C000000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA015199E8 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11502, 4072, CAST(0x0000A8C100000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0151A4CD AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11503, 4072, CAST(0x0000A8C200000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0151B003 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11504, 4072, CAST(0x0000A8C300000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0151BE6A AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11505, 4072, CAST(0x0000A8C400000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0151C8A6 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11506, 4072, CAST(0x0000A8C500000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0151D819 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11507, 4072, CAST(0x0000A8C600000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0151E304 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11508, 4072, CAST(0x0000A8C700000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0151EA44 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11509, 4072, CAST(0x0000A8C800000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0151F546 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11510, 4072, CAST(0x0000A8C900000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0152025A AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11511, 4072, CAST(0x0000A8CA00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01521035 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11512, 4072, CAST(0x0000A8CB00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01521BE9 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11513, 4072, CAST(0x0000A8CC00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01522934 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11514, 4072, CAST(0x0000A8CD00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01523540 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11515, 4072, CAST(0x0000A8CE00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0152408D AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11516, 4072, CAST(0x0000A8CF00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01524BB8 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11517, 4072, CAST(0x0000A8D000000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA015256FB AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11518, 4072, CAST(0x0000A8D100000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01526213 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11519, 4072, CAST(0x0000A8D200000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA015270CD AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11520, 4074, CAST(0x0000A8B500000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01533ED6 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11521, 4074, CAST(0x0000A8B600000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01535863 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11522, 4074, CAST(0x0000A8B700000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01536227 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11523, 4074, CAST(0x0000A8B800000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01536F3A AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11524, 4074, CAST(0x0000A8B900000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01537A0A AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11525, 4074, CAST(0x0000A8BA00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA015384BA AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11526, 4074, CAST(0x0000A8BB00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01538C51 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11527, 4074, CAST(0x0000A8BC00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA015399EA AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11528, 4074, CAST(0x0000A8BD00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0153AE1B AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11529, 4074, CAST(0x0000A8BE00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0153B8A9 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11530, 4074, CAST(0x0000A8BF00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0153CA71 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11531, 4074, CAST(0x0000A8C000000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0153DA7F AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11532, 4074, CAST(0x0000A8C100000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0153EB8F AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11533, 4074, CAST(0x0000A8C200000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0153F786 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11534, 4074, CAST(0x0000A8C300000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0154008E AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11535, 4074, CAST(0x0000A8C400000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA015412F5 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11536, 4074, CAST(0x0000A8C500000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01541E76 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11537, 4074, CAST(0x0000A8C600000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0154298B AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11538, 4074, CAST(0x0000A8C700000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01543192 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11539, 4074, CAST(0x0000A8C800000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01543984 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11540, 4074, CAST(0x0000A8C900000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA015440C9 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11541, 4074, CAST(0x0000A8CA00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01544C9F AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11542, 4074, CAST(0x0000A8CB00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01545596 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11543, 4074, CAST(0x0000A8CC00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01545EF7 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11544, 4074, CAST(0x0000A8CD00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA015465E6 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11545, 4074, CAST(0x0000A8CE00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01546DDF AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11546, 4074, CAST(0x0000A8CF00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01547556 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11547, 4074, CAST(0x0000A8D000000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01547D89 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11548, 4074, CAST(0x0000A8D100000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA015484FF AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11549, 4074, CAST(0x0000A8D200000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01548E0F AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11550, 4076, CAST(0x0000A8B500000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0154D607 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11551, 4076, CAST(0x0000A8B600000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0154F47B AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11552, 4076, CAST(0x0000A8B700000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0154FA63 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11553, 4076, CAST(0x0000A8B800000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA015502EB AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11554, 4076, CAST(0x0000A8B900000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01550A6F AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11555, 4076, CAST(0x0000A8BA00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01551137 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11556, 4076, CAST(0x0000A8BB00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA015515FF AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11557, 4076, CAST(0x0000A8BC00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01551B3A AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11558, 4076, CAST(0x0000A8BD00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA015520E9 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
GO
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11559, 4076, CAST(0x0000A8BE00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0155265E AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11560, 4076, CAST(0x0000A8BF00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01552C37 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11561, 4076, CAST(0x0000A8C000000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA015531BF AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11562, 4076, CAST(0x0000A8C100000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0155396D AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11563, 4076, CAST(0x0000A8C200000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA015540C3 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11564, 4076, CAST(0x0000A8C300000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0155446E AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11565, 4076, CAST(0x0000A8C400000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01554C7F AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11566, 4076, CAST(0x0000A8C500000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01555799 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11567, 4076, CAST(0x0000A8C600000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01555EB5 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11568, 4076, CAST(0x0000A8C700000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01556544 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11569, 4076, CAST(0x0000A8C800000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01556B34 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11570, 4076, CAST(0x0000A8C900000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01557394 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11571, 4076, CAST(0x0000A8CA00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0155792E AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11572, 4076, CAST(0x0000A8CB00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0155841D AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11573, 4076, CAST(0x0000A8CC00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01558A23 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11574, 4076, CAST(0x0000A8CD00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01558FCC AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11575, 4076, CAST(0x0000A8CE00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01559484 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11576, 4076, CAST(0x0000A8CF00000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01559A49 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11577, 4076, CAST(0x0000A8D000000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA01559E5B AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11578, 4076, CAST(0x0000A8D100000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0155A3A8 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11579, 4076, CAST(0x0000A8D200000000 AS DateTime), N'111111111111111100000000000000000000000011111110', 0, N'', CAST(0x0000A8BA0155A929 AS DateTime), 1, N'00:00,08:00,20:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (12548, 4063, CAST(0x0000A8D300000000 AS DateTime), N'001100000000000000001111000000000000000000000000', 0, N'', CAST(0x0000A8CC01490A24 AS DateTime), 1, N'01:00,02:00,10:00,12:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (12549, 4063, CAST(0x0000A8F300000000 AS DateTime), N'001100000000000000001100000000000000000000111100', 0, N'', CAST(0x0000A8CC014D4812 AS DateTime), 1, N'01:00,02:00,10:00,11:00,21:00,23:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (13548, 6080, CAST(0x0000A8D300000000 AS DateTime), N'011111111111000000000000000000000000000000000000', 0, N'', CAST(0x0000A8D500E2D319 AS DateTime), 1, N'00:30,06:00', NULL, N'0')
SET IDENTITY_INSERT [dbo].[WorkSessions] OFF
SET ANSI_PADDING ON

GO
/****** Object:  Index [UK_RegimeName]    Script Date: 04-May-18 10:59:41 AM ******/
ALTER TABLE [dbo].[Regimes] ADD  CONSTRAINT [UK_RegimeName] UNIQUE NONCLUSTERED 
(
	[RegimeName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Ship]    Script Date: 04-May-18 10:59:41 AM ******/
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
ALTER TABLE [dbo].[Crew]  WITH CHECK ADD  CONSTRAINT [FK_Crew_Ranks] FOREIGN KEY([RankID])
REFERENCES [dbo].[Ranks] ([ID])
GO
ALTER TABLE [dbo].[Crew] CHECK CONSTRAINT [FK_Crew_Ranks]
GO
ALTER TABLE [dbo].[GroupPermission]  WITH CHECK ADD  CONSTRAINT [Group_GroupPermission] FOREIGN KEY([GroupID])
REFERENCES [dbo].[Groups] ([ID])
GO
ALTER TABLE [dbo].[GroupPermission] CHECK CONSTRAINT [Group_GroupPermission]
GO
ALTER TABLE [dbo].[GroupPermission]  WITH CHECK ADD  CONSTRAINT [Permission_GroupPermission] FOREIGN KEY([PermissionID])
REFERENCES [dbo].[Permissions] ([ID])
GO
ALTER TABLE [dbo].[GroupPermission] CHECK CONSTRAINT [Permission_GroupPermission]
GO
ALTER TABLE [dbo].[GroupRank]  WITH CHECK ADD  CONSTRAINT [FK_GroupRank_Groups] FOREIGN KEY([GroupID])
REFERENCES [dbo].[Groups] ([ID])
GO
ALTER TABLE [dbo].[GroupRank] CHECK CONSTRAINT [FK_GroupRank_Groups]
GO
ALTER TABLE [dbo].[GroupRank]  WITH CHECK ADD  CONSTRAINT [FK_GroupRank_Ranks] FOREIGN KEY([RankID])
REFERENCES [dbo].[Ranks] ([ID])
GO
ALTER TABLE [dbo].[GroupRank] CHECK CONSTRAINT [FK_GroupRank_Ranks]
GO
ALTER TABLE [dbo].[NCDetails]  WITH CHECK ADD  CONSTRAINT [Crew_NCDetails] FOREIGN KEY([CrewID])
REFERENCES [dbo].[Crew] ([ID])
GO
ALTER TABLE [dbo].[NCDetails] CHECK CONSTRAINT [Crew_NCDetails]
GO
ALTER TABLE [dbo].[NCDetails]  WITH CHECK ADD FOREIGN KEY([WorkSessionId])
REFERENCES [dbo].[WorkSessions] ([ID])
GO
ALTER TABLE [dbo].[Permissions]  WITH CHECK ADD  CONSTRAINT [Permission_Permission] FOREIGN KEY([ParentPermissionID])
REFERENCES [dbo].[Permissions] ([ID])
GO
ALTER TABLE [dbo].[Permissions] CHECK CONSTRAINT [Permission_Permission]
GO
ALTER TABLE [dbo].[ServiceTerms]  WITH CHECK ADD  CONSTRAINT [Crew_ServiceTerm] FOREIGN KEY([CrewID])
REFERENCES [dbo].[Crew] ([ID])
GO
ALTER TABLE [dbo].[ServiceTerms] CHECK CONSTRAINT [Crew_ServiceTerm]
GO
ALTER TABLE [dbo].[ServiceTerms]  WITH NOCHECK ADD  CONSTRAINT [FK_ServiceTerms_Ranks] FOREIGN KEY([RankID])
REFERENCES [dbo].[Ranks] ([ID])
GO
ALTER TABLE [dbo].[ServiceTerms] CHECK CONSTRAINT [FK_ServiceTerms_Ranks]
GO
ALTER TABLE [dbo].[ServiceTerms]  WITH CHECK ADD  CONSTRAINT [FK_ServiceTerms_Schedule] FOREIGN KEY([ScheduleID])
REFERENCES [dbo].[WorkSchedules] ([ID])
GO
ALTER TABLE [dbo].[ServiceTerms] CHECK CONSTRAINT [FK_ServiceTerms_Schedule]
GO
ALTER TABLE [dbo].[UserGroups]  WITH CHECK ADD  CONSTRAINT [Group_UserGroup] FOREIGN KEY([GroupID])
REFERENCES [dbo].[Groups] ([ID])
GO
ALTER TABLE [dbo].[UserGroups] CHECK CONSTRAINT [Group_UserGroup]
GO
ALTER TABLE [dbo].[UserGroups]  WITH CHECK ADD  CONSTRAINT [User_UserGroup] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([ID])
GO
ALTER TABLE [dbo].[UserGroups] CHECK CONSTRAINT [User_UserGroup]
GO
ALTER TABLE [dbo].[WorkSessions]  WITH CHECK ADD  CONSTRAINT [Crew_WorkSession] FOREIGN KEY([CrewID])
REFERENCES [dbo].[Crew] ([ID])
GO
ALTER TABLE [dbo].[WorkSessions] CHECK CONSTRAINT [Crew_WorkSession]
GO
