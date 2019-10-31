

ALTER PROCEDURE [dbo].[stpGetCrewIDFromWorkSessions]

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
		  SevenDaysRest varchar(10)

		)



		INSERT INTO @TimeTab(ID,Hours,BookDate,FirstName,LastName,RankName,WorkDate,ComplianceInfo,TotalNCHours,Comment,AdjustmentFactor,VesselID,RegimeSymbol)

		SELECT WS.ID,Hours,DAY(ValidOn) AS BookDate,C.FirstName,C.LastName,R.RankName,ISNULL(CONVERT(varchar(12),ValidOn,103), '') AS WorkDate,ComplianceInfo,TotalNCHours,WS.Comment,AdjustmentFator As AdjustmentFactor, WS.VesselID,
				
			CASE RegimeName
				WHEN 'IMO STCW' THEN              '~'
				WHEN 'ILO Rest (Flexible)' THEN '@'
				WHEN 'ILO Work' THEN '#'
				WHEN 'Customised' THEN '$'
				WHEN 'ILO Rest' THEN '^'
				WHEN 'IMO STCW 2010' THEN '&'
				WHEN 'OCIMF' THEN '*'
		END As RegimeSymbol

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



		SET @nextval =''
		SET @sevendaysrest = 0

					

		DECLARE db_cursor CURSOR FOR 

		SELECT ID,BookDate FROM @TimeTab

		

		OPEN db_cursor  
		FETCH NEXT FROM db_cursor INTO @id,@bdate

		

		WHILE @@FETCH_STATUS = 0  

		BEGIN  

			  
			  set @workdy = CONVERT(int,@bdate)
			
			  set @workmon = CAST(@Month AS int)

			  set @workyr =  CAST(@Year as int)
			  
			  EXEC stpGetWorkSessionsByValidOn @workdy,
											   @workmon,
											   @workyr,
											    @CrewId,
												@sevendaysrest OUTPUT

			  UPDATE @TimeTab SET SevenDaysRest= CONVERT(varchar,@sevendaysrest) WHERE ID  = @id

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
















