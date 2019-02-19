USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewIDFromWorkSessions]    Script Date: 3/3/2018 2:29:15 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetMinusOneDayAdjustmentDays]    Script Date: 3/3/2018 2:29:15 AM ******/
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
/****** Object:  StoredProcedure [dbo].[stpGetPlusOneDayAdjustmentDays]    Script Date: 3/3/2018 2:29:15 AM ******/
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
