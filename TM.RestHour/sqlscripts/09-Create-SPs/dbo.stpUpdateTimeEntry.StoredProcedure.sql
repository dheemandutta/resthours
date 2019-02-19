USE [RestHour]
GO
/****** Object:  StoredProcedure [dbo].[stpUpdateTimeEntry]    Script Date: 10-May-18 11:17:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpUpdateTimeEntry]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stpUpdateTimeEntry]
GO
/****** Object:  StoredProcedure [dbo].[stpUpdateTimeEntry]    Script Date: 10-May-18 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stpUpdateTimeEntry]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[stpUpdateTimeEntry]

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



					IF(@AdjustmentFactor = ''+1'')

						BEGIN



						   DELETE FROM @TimeSheet



							INSERT INTO @TimeSheet(_ID,_CrewID,_ValidOn,_hours,_actualhours,_adjustmentfactor) 

							SELECT ID,CrewID,ValidOn,Hours,ActualHours,AdjustmentFator

							FROM WorkSessions 

							WHERE FLOOR(CAST(ValidOn as float)) = FLOOR(CAST(@BookDate as float))



							SET @actualhrs = ''''

							SET @hours = ''''

							SET @adjfactor =''''

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

								SELECT String FROM ufn_CSVToTable(@actualhrs,'','')

								



								IF EXISTS(SELECT 1 FROM @TimeTab WHERE ActHrs = ''00:00'')

									BEGIN

										UPDATE @TimeSheet SET _actualhours = REPLACE(_actualhours,''00:00'',''01:00'') WHERE _id = @id

										UPDATE @TimeSheet SET _hours = ''00'' + SUBSTRING(_hours,3,LEN(_hours)-3+1)

										,_adjustmentfactor= ''+1'' 

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

					IF(@AdjustmentFactor = ''+30'')

						BEGIN

							print  ''+30''



							DELETE FROM @TimeSheet

						    

							INSERT INTO @TimeSheet(_ID,_CrewID,_ValidOn,_hours,_actualhours,_adjustmentfactor) 

							SELECT ID,CrewID,ValidOn,Hours,ActualHours,AdjustmentFator

							FROM WorkSessions 

							WHERE FLOOR(CAST(ValidOn as float)) = FLOOR(CAST(@BookDate as float))



							SET @actualhrs = ''''

							SET @hours = ''''

							SET @adjfactor =''''

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

								SELECT String FROM ufn_CSVToTable(@actualhrs,'','')

								



								IF EXISTS(SELECT 1 FROM @TimeTab WHERE ActHrs = ''00:00'')

									BEGIN

										UPDATE @TimeSheet SET _actualhours = REPLACE(_actualhours,''00:00'',''00:30'') WHERE _id = @id

										UPDATE @TimeSheet SET _hours = ''01'' + SUBSTRING(_hours,3,LEN(_hours)-3+1)

										,_adjustmentfactor= ''+30''

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

					IF(@AdjustmentFactor = ''+1D'')

						BEGIN

							print  ''+1D''



							DELETE FROM @TimeSheet

						    

							INSERT INTO @TimeSheet(_ID,_CrewID,_ValidOn,_hours,_actualhours,_adjustmentfactor) 

							SELECT ID,CrewID,ValidOn,Hours,ActualHours,AdjustmentFator

							FROM WorkSessions 

							WHERE FLOOR(CAST(ValidOn as float)) = FLOOR(CAST(@BookDate as float))



							



							DELETE FROM  WorkSessions

							WHERE ID IN ( SELECT _ID FROM @TimeSheet)



						END

				    IF(@AdjustmentFactor = ''-1'')

						BEGIN

							print  ''-1''



							DELETE FROM @TimeSheet

						    

							INSERT INTO @TimeSheet(_ID,_CrewID,_ValidOn,_hours,_actualhours,_adjustmentfactor) 

							SELECT ID,CrewID,ValidOn,Hours,ActualHours,AdjustmentFator

							FROM WorkSessions 

							WHERE FLOOR(CAST(ValidOn as float)) = FLOOR(CAST(@BookDate as float))



							SET @actualhrs = ''''

							SET @hours = ''''

							SET @adjfactor =''''

							SET @id = 0



							

							

							DECLARE DB_CURSORM30 CURSOR FOR

							SELECT _actualhours,_hours,_adjustmentfactor,_id

							FROM  @TimeSheet



							OPEN DB_CURSORM30

							FETCH NEXT FROM DB_CURSORM30 INTO @actualhrs,@hours,@adjfactor,@id



							WHILE @@FETCH_STATUS = 0

							BEGIN

				

										UPDATE @TimeSheet SET 

										_adjustmentfactor= ''-1''

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

				    IF(@AdjustmentFactor = ''-30'')

						BEGIN

							print  ''-30''



							DELETE FROM @TimeSheet

						    

							INSERT INTO @TimeSheet(_ID,_CrewID,_ValidOn,_hours,_actualhours,_adjustmentfactor) 

							SELECT ID,CrewID,ValidOn,Hours,ActualHours,AdjustmentFator

							FROM WorkSessions 

							WHERE FLOOR(CAST(ValidOn as float)) = FLOOR(CAST(@BookDate as float))



							SET @actualhrs = ''''

							SET @hours = ''''

							SET @adjfactor =''''

							SET @id = 0



							

							

							DECLARE DB_CURSORM300 CURSOR FOR

							SELECT _actualhours,_hours,_adjustmentfactor,_id

							FROM  @TimeSheet



							OPEN DB_CURSORM300

							FETCH NEXT FROM DB_CURSORM300 INTO @actualhrs,@hours,@adjfactor,@id



							WHILE @@FETCH_STATUS = 0

							BEGIN

				

										UPDATE @TimeSheet SET 

										_adjustmentfactor= ''-30''

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

                    IF(@AdjustmentFactor = ''-1D'')

						BEGIN

							print  ''-1D''



							DELETE FROM @TimeSheet

						    

							INSERT INTO @TimeSheet(_ID,_CrewID,_ValidOn,_hours,_actualhours,_adjustmentfactor) 

							SELECT ID,CrewID,ValidOn,Hours,ActualHours,AdjustmentFator

							FROM WorkSessions 

							WHERE FLOOR(CAST(ValidOn as float)) = FLOOR(CAST(@BookDate as float))



							SET @actualhrs = ''''

							SET @hours = ''''

							SET @adjfactor =''''

							SET @id = 0



							

							

							DECLARE DB_CURSORM1D CURSOR FOR

							SELECT _actualhours,_hours,_adjustmentfactor,_id

							FROM  @TimeSheet



							OPEN DB_CURSORM1D

							FETCH NEXT FROM DB_CURSORM1D INTO @actualhrs,@hours,@adjfactor,@id



							WHILE @@FETCH_STATUS = 0

							BEGIN



								

										UPDATE @TimeSheet SET _adjustmentfactor= ''-1D''

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



END' 
END
GO
