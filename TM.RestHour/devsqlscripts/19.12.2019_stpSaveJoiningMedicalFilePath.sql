CREATE PROCEDURE stpSaveJoiningMedicalFilePath
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