USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpAddUsers]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpDeleteShipDetails]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpDetleteRanks]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetAllCrewByCrewID]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
C.EmployeeNumber, C.PayNum,C.OvertimeEnabled,C.Watchkeeper,C.RankID


FROM dbo.Crew C 
LEFT OUTER JOIN ServiceTerms ST
ON C.ID = ST.CrewID
INNER JOIN Ranks R 
ON R.ID = C.RankID
WHERE C.ID= @ID
End

-- exec stpGetAllCrewByCrewID 21





GO
/****** Object:  StoredProcedure [dbo].[stpGetAllRanks]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetAllRegimes]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetAllShipDetails]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetChildNodes]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetCrewByRankID]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetCrewByUserID]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetCrewDetailsPageWise]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetCrewIDFromWorkSessions]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetCrewListingPageWise]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetCrewPageWise]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetCrewReportListPageWise]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetDataForVarianceReport]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetDayWiseCrewBookingData]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetLastAdjustmentBookedStatus]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetLastSevenDaysWorkSchedule]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetLastSixDaysWorkSchedule]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetMinusOneDayAdjustmentDays]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetNonComplianceByCrewId]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetNonComplianceInfo]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetParentNodes]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetPlusOneDayAdjustmentDays]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetRanksByID]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetRanksPageWise]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetRegimeById]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetShipDetailsByID]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetShipDetailsPageWise]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetTimeAdjustment]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetUserGroupsByUserID]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetUsersDetailsPageWise]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetWrokSessionsByCrewandDate]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetWrokSessionsByDate]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpLastBookedSession]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpResetPassword]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveCrew]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
@CrewIdentity nvarchar(20),
@PassportSeamanPassportBook nvarchar(20),
@Seaman nvarchar(20),

@CreatedOn datetime,
@ActiveTo datetime,
@PayNum nvarchar(25),
@EmployeeNumber nvarchar(25),
@Notes ntext,
@Watchkeeper bit,
@OvertimeEnabled bit
) 

AS 
BEGIN 
    
 IF @ID IS NULL
BEGIN   

BEGIN TRY  

BEGIN TRAN
INSERT INTO Crew 
           (FirstName,MiddleName,LastName,RankID,CreatedOn,LatestUpdate,Nationality,DOB,POB,CrewIdentity,PassportSeamanPassportBook,Seaman,PayNum,EmployeeNumber,Notes,Watchkeeper,OvertimeEnabled)  
Values(@FirstName,@MiddleName,@LastName,@RankID,@CreatedOn,@ActiveTo,@Nationality,@DOB,@POB,@CrewIdentity,@PassportSeamanPassportBook,@Seaman,@PayNum,@EmployeeNumber,@Notes,@Watchkeeper,@OvertimeEnabled) 

DECLARE @CrewId int
SET @CrewId = @@IDENTITY

INSERT INTO ServiceTerms(ActiveFrom,ActiveTo,CrewID,RankID,Deleted) VALUES
(@CreatedOn,@ActiveTo,@CrewId,@RankID,0)


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

UPDATE Crew
    SET FirstName=@FirstName,MiddleName=@MiddleName,LastName=@LastName,RankID=@RankID,CreatedOn=@CreatedOn,LatestUpdate=@ActiveTo,
    PayNum=@PayNum,EmployeeNumber=@EmployeeNumber,
    Notes=@Notes,Watchkeeper=@Watchkeeper,OvertimeEnabled=@OvertimeEnabled,
	CrewIdentity=@CrewIdentity,PassportSeamanPassportBook=@PassportSeamanPassportBook,Seaman=@Seaman,DOB=@DOB
	WHERE ID=@ID

	UPDATE ServiceTerms SET ActiveFrom = @CreatedOn,ActiveTo = @ActiveTo 
	WHERE CrewId = @ID
	
  COMMIT TRAN

END TRY
BEGIN CATCH

	ROLLBACK TRAN 
END CATCH
   

END
END







GO
/****** Object:  StoredProcedure [dbo].[stpSaveGroups]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveRankGroups]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveRanks]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveRegimes]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveShipDetails]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
  
INSERT INTO Ship 
           (ShipName,IMONumber,FlagOfShip)  
Values(@ShipName,@IMONumber,@FlagOfShip) 
  
 
END
ELSE
BEGIN

UPDATE Ship
SET ShipName=@ShipName,IMONumber=@IMONumber,FlagOfShip=@FlagOfShip--,Regime=@Regime
Where ID=@ID

END
END






GO
/****** Object:  StoredProcedure [dbo].[stpSaveShipTab]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveTimeAdjustment]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpSaveWorkSessions]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpUpdateRanks]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpUpdateTimeEntry]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[stpUserAuthentication]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
(Select ID from Users 
Where Username=@Username AND [Password]=@Password AND Active= 1),0)    

End




GO
/****** Object:  StoredProcedure [dbo].[TEST_TEMP]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_GetAllCrewForDrp]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_GetAllGroupsForDrp]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_GetAllRanksForDrp]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_GetAllShipForDrp]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_GetAllUsersForDrp]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[ufn_CSVToTable]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  Table [dbo].[Crew]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  Table [dbo].[GroupPermission]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  Table [dbo].[GroupRank]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  Table [dbo].[Groups]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  Table [dbo].[NCDetails]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  Table [dbo].[Permissions]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  Table [dbo].[Ranks]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  Table [dbo].[Regimes]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  Table [dbo].[ServiceTerms]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  Table [dbo].[Ship]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  Table [dbo].[TimeAdjustment]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  Table [dbo].[UserGroups]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  Table [dbo].[Users]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  Table [dbo].[WorkSchedules]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
/****** Object:  Table [dbo].[WorkSessions]    Script Date: 02-Apr-18 5:06:20 PM ******/
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

INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (18, N'x', 1, N'test1', NULL, CAST(0x0000A80F00000000 AS DateTime), NULL, N'ASD123', CAST(0x0000A80E00000000 AS DateTime), 1, N'12345', 0, 9, N'PIKU', N'JANA', N'Spanish', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (19, N'x', 0, N'test2', NULL, CAST(0x0000A81100000000 AS DateTime), NULL, N'AS342', CAST(0x0000A81000000000 AS DateTime), 0, N'123', 0, 9, N'ANIL', N'CHANDA', N'Indian', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (20, N'x', 0, N'test3', NULL, CAST(0x0000A81300000000 AS DateTime), NULL, N'LK98', CAST(0x0000A81200000000 AS DateTime), 1, N'9887', 0, 10, N'AMIT', N'DA', N'Indian', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (54, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1041, N'Setyawan', N'Andik Dwiato', N'Indian', CAST(0x000063DF00000000 AS DateTime), NULL, NULL, N'IN1234567 / 1234567', NULL, NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (1046, NULL, 1, N'c', NULL, NULL, NULL, N'pn', NULL, 1, N'en', 0, 9, N'gn', N'fn', N'n', CAST(0x0000A84A00000000 AS DateTime), N'p', N'i', N'pas', NULL, NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (1047, NULL, 1, N'ioi', NULL, CAST(0x0000A85A00000000 AS DateTime), NULL, N'ouyui', CAST(0x0000A85100000000 AS DateTime), 0, N'=09i0-', 0, 1040, N'gn', N'oioi', N'N1', CAST(0x0000A83C00000000 AS DateTime), N'POB', N'ipuiou', N'joh', NULL, NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (1048, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 10, N'Amitabh', N'Singh', N'Indian', CAST(0x000063DF00000000 AS DateTime), NULL, NULL, N'IN1234567 / 1234567', NULL, NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (1049, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 11, N'Yeshwant', N'Dessai', N'Indian', CAST(0x000063DF00000000 AS DateTime), NULL, NULL, N'IN1234567 / 1234567', NULL, NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (1050, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1037, N'Jhon Perianus', N'Bangun', N'Indonesian', CAST(0x000063DF00000000 AS DateTime), NULL, NULL, N'IN1234567 / 1234567', NULL, NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (1051, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1037, N'Chandra Supriyadi', N'Ginting,', N'Indonesian', CAST(0x000063DF00000000 AS DateTime), NULL, NULL, N'IN1234567 / 1234567', NULL, NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (1052, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 12, N'Kumar Ratan', N'Ghosh', N'Indian', CAST(0x000063DF00000000 AS DateTime), NULL, NULL, N'IN1234567 / 1234567', NULL, NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (1053, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1039, N'Keswanto', N'Heri', N'Indonesian', CAST(0x000063DF00000000 AS DateTime), NULL, NULL, N'IN1234567 / 1234567', NULL, NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (1054, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1039, N'Sayuti', N'Supardi', N'Indonesian', CAST(0x000063DF00000000 AS DateTime), NULL, NULL, N'IN1234567 / 1234567', NULL, NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (1055, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1041, N'Setyawan', N'Andik Dwiato', N'Indonesian', CAST(0x000063DF00000000 AS DateTime), NULL, NULL, N'IN1234567 / 1234567', NULL, NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (1056, NULL, 0, N'I nm the Boss', NULL, NULL, NULL, N'786', NULL, 1, N'01', 0, 12, N'Sabyasachi', N'Sabyasachi Sengupta', N'Indian', CAST(0x000080B800000000 AS DateTime), N'Barrackpore', N'PAN Card', N'123654879AADP9', NULL, NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (1057, NULL, 1, N'sasa', NULL, CAST(0x0000A86B00000000 AS DateTime), NULL, N'saas', CAST(0x0000A86400000000 AS DateTime), 0, N'sas', 0, 1039, N'sas', N'sas', N'as', CAST(0x0000A86C00000000 AS DateTime), N'saas', N'asas', N'asa', NULL, NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (2057, NULL, 1, N'C Test', NULL, NULL, NULL, N'P N Test ', NULL, 0, N'EN', 0, 1037, N'GN Test', N'FN Test', N'N Test', CAST(0x0000A87A00000000 AS DateTime), N'POB Test', N'I Test', N'PASS Test', NULL, NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (2058, NULL, 1, N'Comm test', NULL, CAST(0x0000A89500000000 AS DateTime), NULL, N'SD45454', CAST(0x0000A87F00000000 AS DateTime), 0, N'SD5454', 0, 1040, N'Deep Test 1', N'F Name', N'Ind', CAST(0x0000A88700000000 AS DateTime), N'Delhi', N'AS434', N'Pass000767', NULL, NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (2059, NULL, 0, N'aaaaa', NULL, CAST(0x0000A8B000000000 AS DateTime), NULL, N'aaa', CAST(0x0000A89B00000000 AS DateTime), 0, N'aaa', 0, 9, N'aaa', N'a', N'aaa', CAST(0x0000A8A200000000 AS DateTime), N'aaa', N'aaa', N'aaa', NULL, NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (2060, NULL, 0, N'q', NULL, CAST(0x0000A8B000000000 AS DateTime), NULL, N'q', CAST(0x0000A8A300000000 AS DateTime), 0, N'q', 0, 1040, N'q', N'q', N'q', CAST(0x0000A89600000000 AS DateTime), N'q', N'q', N'q', NULL, NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (2061, NULL, 0, N'ww', NULL, CAST(0x0000A8B000000000 AS DateTime), NULL, N'ww', CAST(0x0000A8A300000000 AS DateTime), 0, N'ww', 0, 1041, N'ww', N'ww', N'ww', CAST(0x0000A8A300000000 AS DateTime), N'ww', N'ww', N'ww', NULL, NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (3059, NULL, 0, N'zz', NULL, CAST(0x0000A8A300000000 AS DateTime), NULL, N'zz', CAST(0x0000A8A300000000 AS DateTime), 0, N'zz', 0, 1041, N'zz', N'z', N'z', CAST(0x0000A89E00000000 AS DateTime), N'zz', N'z', N'z', NULL, NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (3060, NULL, 1, NULL, NULL, CAST(0x0000A8AA00000000 AS DateTime), NULL, N'MM8987', CAST(0x0000A89600000000 AS DateTime), 0, N'LK8786', 0, 9, N'Jhon', N'Sina', N'USA', CAST(0x0000A89600000000 AS DateTime), N'USA', N'PL987878', NULL, N'LK9786658', NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (3061, NULL, 1, N'ghhgh', NULL, CAST(0x0000A8A900000000 AS DateTime), NULL, N'ghgh', CAST(0x0000A89600000000 AS DateTime), 0, N'ghhg', 0, 1039, N'Rajiv', N'Roy', N'India', CAST(0x0000A89600000000 AS DateTime), N'A', N'ghg', NULL, N'ghgh', N'Kumar')
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (3062, NULL, 0, N'fgfgfg', NULL, CAST(0x0000A8AA00000000 AS DateTime), NULL, N'fgghgf', CAST(0x0000A89700000000 AS DateTime), 0, N'fghgf', 0, 1040, N'hggf', N'gfhfg', N'gfhfg', CAST(0x0000A89600000000 AS DateTime), N'fghgfh', N'fghfg', NULL, N'fggh', N'ghfgh')
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (3063, NULL, 1, N'fgfggf', NULL, CAST(0x0000A8A400000000 AS DateTime), NULL, N'gffg', CAST(0x0000A89600000000 AS DateTime), 0, N'fggf', 0, 1039, N'fggfhhfg', N'fhfghfgh', N'fghfg', CAST(0x0000A89600000000 AS DateTime), N'fghgf', N'fgfh', NULL, N'fghgfh', NULL)
INSERT [dbo].[Crew] ([ID], [Name], [Watchkeeper], [Notes], [Deleted], [LatestUpdate], [CompleteHistory], [PayNum], [CreatedOn], [OvertimeEnabled], [EmployeeNumber], [NWKHoursMayVary], [RankID], [FirstName], [LastName], [Nationality], [DOB], [POB], [CrewIdentity], [PassportSeamanPassportBook], [Seaman], [MiddleName]) VALUES (4061, NULL, 1, N'saas', NULL, CAST(0x0000A8AC00000000 AS DateTime), NULL, N'sasa', CAST(0x0000A89600000000 AS DateTime), 1, N'asas', 0, 9, N'Santosh', N'Jana', N'Indian', CAST(0x0000A8AC00000000 AS DateTime), N'asa', N'sas', NULL, N'saas', N'Kr')
SET IDENTITY_INSERT [dbo].[Crew] OFF
SET IDENTITY_INSERT [dbo].[GroupPermission] ON 

INSERT [dbo].[GroupPermission] ([ID], [GroupID], [PermissionID]) VALUES (6, 8, 3)
INSERT [dbo].[GroupPermission] ([ID], [GroupID], [PermissionID]) VALUES (7, 8, 4)
INSERT [dbo].[GroupPermission] ([ID], [GroupID], [PermissionID]) VALUES (8, 8, 5)
INSERT [dbo].[GroupPermission] ([ID], [GroupID], [PermissionID]) VALUES (9, 9, 4)
INSERT [dbo].[GroupPermission] ([ID], [GroupID], [PermissionID]) VALUES (10, 9, 8)
INSERT [dbo].[GroupPermission] ([ID], [GroupID], [PermissionID]) VALUES (11, 10, 4)
INSERT [dbo].[GroupPermission] ([ID], [GroupID], [PermissionID]) VALUES (12, 10, 9)
INSERT [dbo].[GroupPermission] ([ID], [GroupID], [PermissionID]) VALUES (13, 10, 10)
INSERT [dbo].[GroupPermission] ([ID], [GroupID], [PermissionID]) VALUES (14, 12, 3)
INSERT [dbo].[GroupPermission] ([ID], [GroupID], [PermissionID]) VALUES (15, 12, 8)
SET IDENTITY_INSERT [dbo].[GroupPermission] OFF
SET IDENTITY_INSERT [dbo].[GroupRank] ON 

INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (1, 9, 11)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (2, 9, 12)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (3, 9, 10)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (4, 9, 9)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (12, 8, 11)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (13, 9, 11)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (14, 9, 10)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (15, 10, 10)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (16, 8, 9)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (17, 9, 9)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (18, 8, 11)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (19, 9, 11)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (20, 8, 11)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (21, 9, 11)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (22, 10, 11)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (23, 11, 11)
INSERT [dbo].[GroupRank] ([ID], [GroupID], [RankID]) VALUES (24, 12, 11)
SET IDENTITY_INSERT [dbo].[GroupRank] OFF
SET IDENTITY_INSERT [dbo].[Groups] ON 

INSERT [dbo].[Groups] ([ID], [GroupName], [AllowDelete]) VALUES (8, N'group10', 0)
INSERT [dbo].[Groups] ([ID], [GroupName], [AllowDelete]) VALUES (9, N'TestGrp 1', 0)
INSERT [dbo].[Groups] ([ID], [GroupName], [AllowDelete]) VALUES (10, N'group90', 0)
INSERT [dbo].[Groups] ([ID], [GroupName], [AllowDelete]) VALUES (11, N'lk', 0)
INSERT [dbo].[Groups] ([ID], [GroupName], [AllowDelete]) VALUES (12, N'my group', 0)
INSERT [dbo].[Groups] ([ID], [GroupName], [AllowDelete]) VALUES (13, N'Super Admin', 1)
INSERT [dbo].[Groups] ([ID], [GroupName], [AllowDelete]) VALUES (14, N'Admin', 1)
INSERT [dbo].[Groups] ([ID], [GroupName], [AllowDelete]) VALUES (15, N'User', 1)
SET IDENTITY_INSERT [dbo].[Groups] OFF
SET IDENTITY_INSERT [dbo].[NCDetails] ON 

INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (9075, 1049, CAST(0x0000A89200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus>Less than 10 hrs of rest in 24 hrs period</twentyfourhourresthoursstatus><minsevendaysrest>14</minsevendaysrest><mintwentyfourhoursrest>7</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>2</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>17</totalworkedhours><overtimeHours>17</overtimeHours></ncdetails>', 0, 10105, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (9076, 1049, CAST(0x0000A89200000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus>Less than 10 hrs of rest in 24 hrs period</twentyfourhourresthoursstatus><minsevendaysrest>15</minsevendaysrest><mintwentyfourhoursrest>7</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>2</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>16</totalworkedhours><overtimeHours>16</overtimeHours></ncdetails>', 0, 10106, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (9077, 1048, CAST(0x0000A89600000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>24</minsevendaysrest><mintwentyfourhoursrest>12</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>6</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 10107, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (9078, 1048, CAST(0x0000A89500000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>28</minsevendaysrest><mintwentyfourhoursrest>14</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>6</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>10</totalworkedhours><overtimeHours>2</overtimeHours></ncdetails>', 0, 10108, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (9079, 1048, CAST(0x0000A89300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>29</minsevendaysrest><mintwentyfourhoursrest>14</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>9</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>9</totalworkedhours><overtimeHours>1</overtimeHours></ncdetails>', 0, 10109, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (9080, 1048, CAST(0x0000A88D00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>28</minsevendaysrest><mintwentyfourhoursrest>14</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>11</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>10</totalworkedhours><overtimeHours>2</overtimeHours></ncdetails>', 0, 10110, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (9081, 1048, CAST(0x0000A88A00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>20</minsevendaysrest><mintwentyfourhoursrest>10</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>10</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>14</totalworkedhours><overtimeHours>10</overtimeHours></ncdetails>', 0, 10111, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (9082, 1049, CAST(0x0000A88D00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>36</minsevendaysrest><mintwentyfourhoursrest>18</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>17</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>6</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 10112, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (9083, 1048, CAST(0x0000A8A700000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>34</minsevendaysrest><mintwentyfourhoursrest>17</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>8</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>7</totalworkedhours><overtimeHours>7</overtimeHours></ncdetails>', 0, 10113, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (9084, 1048, CAST(0x0000A88B00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>32</minsevendaysrest><mintwentyfourhoursrest>16</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>10</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>8</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 10114, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (9085, 1049, CAST(0x0000A88B00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus>Less than 10 hrs of rest in 24 hrs period</twentyfourhourresthoursstatus><minsevendaysrest>19</minsevendaysrest><mintwentyfourhoursrest>9</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>5</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>14</totalworkedhours><overtimeHours>14</overtimeHours></ncdetails>', 0, 10115, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (9086, 1048, CAST(0x0000A88000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus>Less than 10 hrs of rest in 24 hrs period</twentyfourhourresthoursstatus><minsevendaysrest>11</minsevendaysrest><mintwentyfourhoursrest>5</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>4</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>18</totalworkedhours><overtimeHours>10</overtimeHours></ncdetails>', 0, 10116, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (9087, 1048, CAST(0x0000A88000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>45</minsevendaysrest><mintwentyfourhoursrest>22</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>1</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>1</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 10117, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (9088, 4061, CAST(0x0000A8AC00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>31</minsevendaysrest><mintwentyfourhoursrest>15</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>15</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>8</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 10118, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (9089, 1048, CAST(0x0000A8B100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus>Less than 10 hrs of rest in 24 hrs period</twentyfourhourresthoursstatus><minsevendaysrest>15</minsevendaysrest><mintwentyfourhoursrest>7</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>6</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>16</totalworkedhours><overtimeHours>8</overtimeHours></ncdetails>', 0, 10119, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (9090, 1048, CAST(0x0000A8B000000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>35</minsevendaysrest><mintwentyfourhoursrest>17</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>17</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>6</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 10120, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (9091, 1048, CAST(0x0000A8AF00000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>26</minsevendaysrest><mintwentyfourhoursrest>13</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>5</maxrestperiodintewntyfourhours><maxnrofrestperiod>5</maxnrofrestperiod><totalworkedhours>11</totalworkedhours><overtimeHours>3</overtimeHours></ncdetails>', 0, 10121, 1)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10089, 1050, CAST(0x0000A8B400000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>28</minsevendaysrest><mintwentyfourhoursrest>14</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>9</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>10</totalworkedhours><overtimeHours>6</overtimeHours></ncdetails>', 0, 11119, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10090, 1052, CAST(0x0000A8B300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>31</minsevendaysrest><mintwentyfourhoursrest>15</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>14</maxrestperiodintewntyfourhours><maxnrofrestperiod>2</maxnrofrestperiod><totalworkedhours>8</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 11120, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10091, 1053, CAST(0x0000A8B300000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus /><maxrestperiodstatus /><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>23</minsevendaysrest><mintwentyfourhoursrest>11</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>6</maxrestperiodintewntyfourhours><maxnrofrestperiod>1</maxnrofrestperiod><totalworkedhours>12</totalworkedhours><overtimeHours>4</overtimeHours></ncdetails>', 0, 11121, 0)
INSERT [dbo].[NCDetails] ([NCDetailsID], [CrewID], [OccuredOn], [ComplianceInfo], [TotalNCHours], [WorkSessionId], [isNC]) VALUES (10092, 1049, CAST(0x0000A8B100000000 AS DateTime), N'<ncdetails><maxnrrestperiodstatus>Maximum number of rest period is more than 2</maxnrrestperiodstatus><maxrestperiodstatus>No minimum 6 hrs rest period</maxrestperiodstatus><sevendaysstatus /><twentyfourhourresthoursstatus /><minsevendaysrest>38</minsevendaysrest><mintwentyfourhoursrest>19</mintwentyfourhoursrest><maxrestperiodintewntyfourhours>16</maxrestperiodintewntyfourhours><maxnrofrestperiod>3</maxnrofrestperiod><totalworkedhours>5</totalworkedhours><overtimeHours>0</overtimeHours></ncdetails>', 0, 11122, 1)
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

INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (24, CAST(0x0000A85B00000000 AS DateTime), CAST(0x0000A87500000000 AS DateTime), 1056, NULL, NULL, 12, 0)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (25, CAST(0x0000A86400000000 AS DateTime), CAST(0x0000A86B00000000 AS DateTime), 1057, NULL, NULL, 1039, 0)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (1025, CAST(0x0000A87A00000000 AS DateTime), CAST(0x0000A88E00000000 AS DateTime), 2057, NULL, NULL, 1037, 0)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (1026, CAST(0x0000A87F00000000 AS DateTime), CAST(0x0000A89500000000 AS DateTime), 2058, NULL, NULL, 1040, 0)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (1027, CAST(0x0000A89B00000000 AS DateTime), CAST(0x0000A8B000000000 AS DateTime), 2059, NULL, NULL, 9, 0)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (1028, CAST(0x0000A8A300000000 AS DateTime), CAST(0x0000A8B000000000 AS DateTime), 2060, NULL, NULL, 1040, 0)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (1029, CAST(0x0000A8A300000000 AS DateTime), CAST(0x0000A8B000000000 AS DateTime), 2061, NULL, NULL, 1041, 0)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (2027, CAST(0x0000A8A300000000 AS DateTime), CAST(0x0000A8A300000000 AS DateTime), 3059, NULL, NULL, 1041, 0)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (3027, CAST(0x0000A89600000000 AS DateTime), CAST(0x0000A8AA00000000 AS DateTime), 3060, NULL, NULL, 9, 0)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (3028, CAST(0x0000A89600000000 AS DateTime), CAST(0x0000A8A900000000 AS DateTime), 3061, NULL, NULL, 1039, 0)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (3029, CAST(0x0000A89700000000 AS DateTime), CAST(0x0000A8AA00000000 AS DateTime), 3062, NULL, NULL, 1040, 0)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (3030, CAST(0x0000A89600000000 AS DateTime), CAST(0x0000A8A400000000 AS DateTime), 3063, NULL, NULL, 1039, 0)
INSERT [dbo].[ServiceTerms] ([ID], [ActiveFrom], [ActiveTo], [CrewID], [OvertimeID], [ScheduleID], [RankID], [Deleted]) VALUES (4027, CAST(0x0000A89600000000 AS DateTime), CAST(0x0000A8AC00000000 AS DateTime), 4061, NULL, NULL, 9, 0)
SET IDENTITY_INSERT [dbo].[ServiceTerms] OFF
SET IDENTITY_INSERT [dbo].[Ship] ON 

INSERT [dbo].[Ship] ([ID], [ShipName], [IMONumber], [FlagOfShip], [Regime]) VALUES (1, N'Karaboujam', N'IMO1', N'Belgium', 3)
SET IDENTITY_INSERT [dbo].[Ship] OFF
INSERT [dbo].[TimeAdjustment] ([AdjustmentDate], [AdjustmentValue]) VALUES (CAST(0x0000A89200000000 AS DateTime), N'-1D')
INSERT [dbo].[TimeAdjustment] ([AdjustmentDate], [AdjustmentValue]) VALUES (CAST(0x0000A88B00000000 AS DateTime), N'-30')
INSERT [dbo].[TimeAdjustment] ([AdjustmentDate], [AdjustmentValue]) VALUES (CAST(0x0000A88900000000 AS DateTime), N'+1D')
INSERT [dbo].[TimeAdjustment] ([AdjustmentDate], [AdjustmentValue]) VALUES (NULL, NULL)
INSERT [dbo].[TimeAdjustment] ([AdjustmentDate], [AdjustmentValue]) VALUES (CAST(0x0000A88000000000 AS DateTime), N'-1D')
INSERT [dbo].[TimeAdjustment] ([AdjustmentDate], [AdjustmentValue]) VALUES (CAST(0x0000A89600000000 AS DateTime), N'-1')
INSERT [dbo].[TimeAdjustment] ([AdjustmentDate], [AdjustmentValue]) VALUES (CAST(0x0000A88D00000000 AS DateTime), N'-1')
INSERT [dbo].[TimeAdjustment] ([AdjustmentDate], [AdjustmentValue]) VALUES (CAST(0x0000A8B700000000 AS DateTime), N'-30')
INSERT [dbo].[TimeAdjustment] ([AdjustmentDate], [AdjustmentValue]) VALUES (CAST(0x0000A8B400000000 AS DateTime), N'+1')
INSERT [dbo].[TimeAdjustment] ([AdjustmentDate], [AdjustmentValue]) VALUES (CAST(0x0000A8B300000000 AS DateTime), N'-1D')
INSERT [dbo].[TimeAdjustment] ([AdjustmentDate], [AdjustmentValue]) VALUES (CAST(0x0000A8B100000000 AS DateTime), N'-30')
SET IDENTITY_INSERT [dbo].[UserGroups] ON 

INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID]) VALUES (38, 1, 13)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID]) VALUES (39, 30, 13)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID]) VALUES (40, 31, 14)
INSERT [dbo].[UserGroups] ([ID], [UserID], [GroupID]) VALUES (41, 32, 15)
SET IDENTITY_INSERT [dbo].[UserGroups] OFF
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId]) VALUES (1, N'u5', N'u5', 1, 1, NULL)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId]) VALUES (19, N'deep', N'deep', 1, 1, NULL)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId]) VALUES (30, N'sa', N'sa', 1, 1, 46)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId]) VALUES (31, N'admin', N'admin', 1, 1, 1055)
INSERT [dbo].[Users] ([ID], [Username], [Password], [Active], [AllowDelete], [CrewId]) VALUES (32, N'guest', N'guest', 1, 1, 19)
SET IDENTITY_INSERT [dbo].[Users] OFF
SET IDENTITY_INSERT [dbo].[WorkSessions] ON 

INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (10105, 1049, CAST(0x0000A89200000000 AS DateTime), N'000001111111111100011111111111100001111111111100', 0, N'', CAST(0x0000A8930165413B AS DateTime), 1, N'02:30,08:00,09:30,15:30,17:30,23:00', NULL, N'-1D')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (10106, 1049, CAST(0x0000A89200000000 AS DateTime), N'000000011111100001111111111111110011111111111100', 0, N'', CAST(0x0000A893016569FB AS DateTime), 1, N'03:30,06:30,08:30,16:00,17:00,23:00', NULL, N'-1D')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (10107, 1048, CAST(0x0000A89600000000 AS DateTime), N'000000000111111101111111111111101110000000000000', 0, N'', CAST(0x0000A89500B4557A AS DateTime), 1, N'04:30,08:00,08:30,15:30,16:00,17:30', NULL, N'-1')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (10108, 1048, CAST(0x0000A89500000000 AS DateTime), N'000001111111111100000000000011111111100000000000', 0, N'', CAST(0x0000A89500D90A39 AS DateTime), 1, N'02:30,08:00,14:00,18:30', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (10109, 1048, CAST(0x0000A89300000000 AS DateTime), N'111111111100000000000000000001111000000000111110', 0, N'', CAST(0x0000A89500F065E8 AS DateTime), 1, N'00:00,05:00,14:30,16:30,21:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (10110, 1048, CAST(0x0000A88D00000000 AS DateTime), N'001111110000111111111111110000000000000000000000', 0, N'', CAST(0x0000A8950106B6D3 AS DateTime), 1, N'01:00,04:00,06:00,13:00', NULL, N'-1')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (10111, 1048, CAST(0x0000A88A00000000 AS DateTime), N'111111111111111111111111111100000000000000000000', 0, N'', CAST(0x0000A8950105ED90 AS DateTime), 1, N'00:00,14:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (10112, 1049, CAST(0x0000A88D00000000 AS DateTime), N'111111111100000000000000000000000000000000000110', 0, N'', CAST(0x0000A895010A6584 AS DateTime), 1, N'00:00,05:00,22:30,23:30', NULL, N'-1')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (10113, 1048, CAST(0x0000A8A700000000 AS DateTime), N'000011111111000000000000000011111100000000000000', 0, N'', CAST(0x0000A89600060BFA AS DateTime), 1, N'02:00,06:00,14:00,17:00', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (10114, 1048, CAST(0x0000A88B00000000 AS DateTime), N'000000111111111000000000000000000000111111100000', 0, N'', CAST(0x0000A89600068208 AS DateTime), 1, N'03:00,07:30,18:00,21:30', NULL, N'-30')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (10115, 1049, CAST(0x0000A88B00000000 AS DateTime), N'111111000000000001111111111111111110000001111100', 0, N'', CAST(0x0000A89600184625 AS DateTime), 1, N'00:00,03:00,08:30,17:30,20:30,23:00', NULL, N'-30')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (10116, 1048, CAST(0x0000A88000000000 AS DateTime), N'000111111111111111111111111111111111111100000000', 0, N'', CAST(0x0000A8980003664F AS DateTime), 1, N'01:30,20:00', NULL, N'-1D')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (10117, 1048, CAST(0x0000A88000000000 AS DateTime), N'000000000000000000000000000000000000000000011100', 0, N'', CAST(0x0000A898000397D9 AS DateTime), 1, N'21:30,23:00', NULL, N'-1D')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (10118, 4061, CAST(0x0000A8AC00000000 AS DateTime), N'111111111111110000000000000000000000000000001110', 0, N'aaaa', CAST(0x0000A8AC00D7B117 AS DateTime), 1, N'00:00,07:00,22:00,23:30', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (10119, 1048, CAST(0x0000A8B100000000 AS DateTime), N'001111111111111111111111111111100000000000011110', 0, N'', CAST(0x0000A8B100EA7077 AS DateTime), 1, N'01:00,15:30,21:30,23:30', NULL, N'-30')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (10120, 1048, CAST(0x0000A8B000000000 AS DateTime), N'111111111111100000000000000000000000000000000000', 0, N'', CAST(0x0000A8B100EA9248 AS DateTime), 1, N'00:00,06:30', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (10121, 1048, CAST(0x0000A8AF00000000 AS DateTime), N'100011111100000000000111111111111000011000000010', 0, N'', CAST(0x0000A8B100EADDCC AS DateTime), 1, N'02:00,05:00,10:30,16:30,18:30,19:30,23:00,23:59', NULL, N'0')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11119, 1050, CAST(0x0000A8B400000000 AS DateTime), N'001111111000000000111111111110000000000000000000', 0, N'', CAST(0x0000A8B600E474B2 AS DateTime), 1, N'01:00,04:30,09:00,14:30', NULL, N'+1')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11120, 1052, CAST(0x0000A8B300000000 AS DateTime), N'011111111111111100100000000000000000000000000000', 0, N'', CAST(0x0000A8B600F1D3D1 AS DateTime), 1, N'00:30,08:00,09:00,09:30', NULL, N'-1D')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11121, 1053, CAST(0x0000A8B300000000 AS DateTime), N'000000000001111111111111111111111111000000000000', 0, N'', CAST(0x0000A8B600F1FA55 AS DateTime), 1, N'05:30,18:00', NULL, N'-1D')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11122, 1049, CAST(0x0000A8B100000000 AS DateTime), N'110011000011111100000000000000000000000000000000', 0, N'', CAST(0x0000A8B6010D7E23 AS DateTime), 1, N'00:00,01:00,02:00,03:00,05:00,08:00', NULL, N'-30')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11123, 1052, CAST(0x0000A8B300000000 AS DateTime), N'011111111111111100100000000000000000000000000000', 0, N'', CAST(0x0000A8B600F1D3D1 AS DateTime), 1, N'00:30,08:00,09:00,09:30', NULL, N'-1D')
INSERT [dbo].[WorkSessions] ([ID], [CrewID], [ValidOn], [Hours], [Increment], [Comment], [LatestUpdate], [Deleted], [ActualHours], [TimeAdjustment], [AdjustmentFator]) VALUES (11124, 1053, CAST(0x0000A8B300000000 AS DateTime), N'000000000001111111111111111111111111000000000000', 0, N'', CAST(0x0000A8B600F1FA55 AS DateTime), 1, N'05:30,18:00', NULL, N'-1D')
SET IDENTITY_INSERT [dbo].[WorkSessions] OFF
SET ANSI_PADDING ON

GO
/****** Object:  Index [UK_RegimeName]    Script Date: 02-Apr-18 5:06:20 PM ******/
ALTER TABLE [dbo].[Regimes] ADD  CONSTRAINT [UK_RegimeName] UNIQUE NONCLUSTERED 
(
	[RegimeName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Ship]    Script Date: 02-Apr-18 5:06:20 PM ******/
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
