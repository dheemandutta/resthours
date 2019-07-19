USE [resthoursclient]
GO
/****** Object:  StoredProcedure [dbo].[stpSaveConfigData]    Script Date: 19-07-2019 16:36:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec stpSaveConfigData 'smtptest','1000','d@d.com','f@f.com','qwerty'
ALTER Procedure [dbo].[stpSaveConfigData]
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
Update tblConfig Set IsActive = 0 Where KeyName = 'pop3'
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
