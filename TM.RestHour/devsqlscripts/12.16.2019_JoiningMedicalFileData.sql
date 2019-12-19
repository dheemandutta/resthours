/****** Object:  Table [dbo].[JoiningMedicalFileData]    Script Date: 12/16/2019 12:40:35 PM ********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JoiningMedicalFileData](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CrewId] [int] NULL,
	[UploadDate] [DateTime] NULL,
	[JoiningMedicalFile] [nvarchar](500) NULL,
 CONSTRAINT [PK_JoiningMedicalFileData] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
