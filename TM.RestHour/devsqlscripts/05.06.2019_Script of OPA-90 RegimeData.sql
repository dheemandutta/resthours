--USE [RestHour]
GO
SET IDENTITY_INSERT [dbo].[Regimes] ON 
INSERT [dbo].[Regimes] ([ID], [RegimeName], [Description], [Basis], [MinTotalRestIn7Days], [MaxTotalWorkIn24Hours], [MinContRestIn24Hours], [MinTotalRestIn24Hours], [MaxTotalWorkIn7Days], [CheckFor2Days], [OPA90], [ManilaExceptions], [UseHistCalculationOnly], [CheckOnlyWorkHours], [VesselID]) VALUES (9, N'OPA-90', N'dummy dummy dummy', N'rest', 77, 14, 6, 10, 91, 0, 0, 0, 1, 0, 8940557)
SET IDENTITY_INSERT [dbo].[Regimes] OFF
INSERT [dbo].[tblRegime] ([RegimeID], [RegimeStartDate], [IsActiveRegime], [VesselID], [RegimeEndDate]) VALUES (9, CAST(N'2019-06-05 00:00:00.000' AS DateTime), 0, 8940557, CAST(N'2019-06-05 00:00:00.000' AS DateTime))
