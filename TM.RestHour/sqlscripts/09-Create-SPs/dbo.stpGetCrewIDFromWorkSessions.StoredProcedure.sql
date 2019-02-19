USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewIDFromWorkSessions]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetCrewIDFromWorkSessions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpGetCrewIDFromWorkSessions]
GO
/****** Object:  StoredProcedure [dbo].[stpGetCrewIDFromWorkSessions]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpGetCrewIDFromWorkSessions]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- exec stpGetCrewIDFromWorkSessions ''1048'' ,''02'',''2018''



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

		SELECT WS.ID,Hours,DAY(ValidOn) AS BookDate,C.FirstName,C.LastName,R.RankName,ISNULL(CONVERT(varchar(12),ValidOn,103), '''') AS WorkDate,ComplianceInfo,TotalNCHours,WS.Comment,AdjustmentFator As AdjustmentFactor

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



		SET @nextval =''''

					

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

			  

			  UPDATE @TimeTab SET BookDate = @bdate + ''_dup'' WHERE ID=@id



			  END





			  FETCH NEXT FROM db_cursor INTO @id,@bdate 

		END 



		CLOSE db_cursor  

		DEALLOCATE db_cursor    

	





	   SELECT * FROM @TimeTab ORDER BY BookDate



END' 
END
GO
