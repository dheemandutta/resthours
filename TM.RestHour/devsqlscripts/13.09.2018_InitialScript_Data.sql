
SET IDENTITY_INSERT [dbo].[CountryMaster] ON 

INSERT [dbo].[CountryMaster] ([CountryID], [CountryName]) VALUES (1, N'India')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName]) VALUES (2, N'Bangladesh')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName]) VALUES (3, N'Pakistan')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName]) VALUES (4, N'China')
INSERT [dbo].[CountryMaster] ([CountryID], [CountryName]) VALUES (5, N'Sri Lanka')
SET IDENTITY_INSERT [dbo].[CountryMaster] OFF
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
SET IDENTITY_INSERT [dbo].[GroupRank] OFF
SET IDENTITY_INSERT [dbo].[Groups] ON 

INSERT [dbo].[Groups] ([ID], [GroupName], [AllowDelete], [VesselID]) VALUES (13, N'Super Admin', 1, 9876543)
INSERT [dbo].[Groups] ([ID], [GroupName], [AllowDelete], [VesselID]) VALUES (14, N'Admin', 1, 9876543)
INSERT [dbo].[Groups] ([ID], [GroupName], [AllowDelete], [VesselID]) VALUES (15, N'User', 1, 9876543)
SET IDENTITY_INSERT [dbo].[Groups] OFF
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
