USE [SCHUniversalAPI]
GO
/****** Object:  UserDefinedTableType [dbo].[IdentifierList]    Script Date: 21/07/2016 10:39:51 ******/
CREATE TYPE [dbo].[IdentifierList] AS TABLE(
	[Identifier] [varchar](1000) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[IntegerTableType]    Script Date: 21/07/2016 10:39:52 ******/
CREATE TYPE [dbo].[IntegerTableType] AS TABLE(
	[ID] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[ProjectList]    Script Date: 21/07/2016 10:39:52 ******/
CREATE TYPE [dbo].[ProjectList] AS TABLE(
	[ProjectId] [int] NULL
)
GO
/****** Object:  UserDefinedFunction [dbo].[RemoveSpecialCharacters]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Function [dbo].[RemoveSpecialCharacters](@Temp VarChar(1000))
Returns VarChar(1000)
AS
Begin

    Declare @KeepValues as varchar(50)
    Set @KeepValues = '%[^a-z0-9A-Z-_ ]%'
    While PatIndex(@KeepValues, @Temp) > 0
        Set @Temp = Stuff(@Temp, PatIndex(@KeepValues, @Temp), 1, '')

    Return @Temp 
End
GO
/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Split]
(
@RowData nvarchar(max),
@SplitOn nvarchar(5)
)  
RETURNS @RtnValue table 
(
Id int identity(1,1),
Data nvarchar(100)
) 
AS  
BEGIN 
Declare @Cnt int
Set @Cnt = 1

While (Charindex(@SplitOn,@RowData)>0)
Begin
Insert Into @RtnValue (data)
Select 
Data = ltrim(rtrim(Substring(@RowData,1,Charindex(@SplitOn,@RowData)-1)))

Set @RowData = Substring(@RowData,Charindex(@SplitOn,@RowData)+1,len(@RowData))
Set @Cnt = @Cnt + 1
End

Insert Into @RtnValue (data)
Select Data = ltrim(rtrim(@RowData))

Return
END

GO
/****** Object:  Table [dbo].[Datapoint]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Datapoint](
	[DataPointId] [int] IDENTITY(1,1) NOT NULL,
	[DataPointName] [varchar](200) NULL,
	[DatapointGroupId] [int] NULL,
 CONSTRAINT [PK_Datapoint] PRIMARY KEY CLUSTERED 
(
	[DataPointId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DataPointOptions]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DataPointOptions](
	[DataPointValueId] [int] IDENTITY(1,1) NOT NULL,
	[DataPointId] [int] NULL,
	[DataPointValueName] [varchar](200) NULL,
	[OptionId] [int] NULL,
 CONSTRAINT [PK_DataPointOptions] PRIMARY KEY CLUSTERED 
(
	[DataPointValueId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PanelistMaster]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PanelistMaster](
	[Identifier] [varchar](100) NULL,
	[DataPointId] [int] NULL,
	[OptionId] [varchar](1000) NULL,
	[Active] [int] NULL,
	[PanelId] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Project]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Project](
	[ProjectId] [int] IDENTITY(1,1) NOT NULL,
	[ProjectName] [varchar](200) NULL,
	[LOI] [int] NULL,
	[Incidence] [int] NULL,
	[SurveyLink] [varchar](1000) NULL,
	[Status] [int] NULL,
	[CreateDate] [datetime] NULL,
	[RequestLogId] [int] NULL,
	[KinesisProjectId] [int] NULL,
	[KinesisProjectCreatedDate] [datetime] NULL,
	[KinesisStatus] [int] NULL,
	[KinesisProjectStatus] [int] NULL,
	[KinesisAPIError] [varchar](2000) NULL,
	[ErrorRetryCount] [int] NULL,
	[KinesisCloseStatus] [bit] NULL,
	[Panelld] [int] NULL,
	[EmailSubject] [varchar](500) NULL,
	[SurveyTopic] [varchar](500) NULL,
	[ReferenceCode] [varchar](500) NULL,
	[ActiveDate] [datetime] NULL,
	[InactiveDate] [datetime] NULL,
 CONSTRAINT [PK_Project] PRIMARY KEY CLUSTERED 
(
	[ProjectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[QueryMaster]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[QueryMaster](
	[QueryId] [int] IDENTITY(1,1) NOT NULL,
	[ProjectId] [int] NULL,
	[ReqN] [int] NULL,
	[Query] [varchar](max) NULL,
	[JsonText] [varchar](max) NULL,
	[Speciality] [int] NULL,
	[CreateDate] [datetime] NULL,
	[SampleId] [int] NULL,
	[CampaignId] [int] NULL,
	[Reward] [int] NULL,
	[SendReminder] [bit] NULL,
	[ReminderRequestDate] [datetime] NULL,
	[ReminderSentStatus] [bit] NULL,
	[KinesisReminderSentDate] [datetime] NULL,
	[KinesisReminderErrorCount] [int] NULL,
	[SampleRatio] [varchar](500) NULL,
	[CompleteGroup] [int] NULL,
	[TotalRespondent] [int] NULL,
	[ExclusionCount] [int] NULL,
 CONSTRAINT [PK_QueryMaster] PRIMARY KEY CLUSTERED 
(
	[QueryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RequestLog]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RequestLog](
	[LogId] [int] IDENTITY(1,1) NOT NULL,
	[RequestJson] [varchar](max) NULL,
	[RequestDate] [datetime] NULL,
	[ResponseJson] [varchar](max) NULL,
	[ResponseDate] [datetime] NULL,
 CONSTRAINT [PK_RequestLog] PRIMARY KEY CLUSTERED 
(
	[LogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RespondentList]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RespondentList](
	[RespondentListId] [int] IDENTITY(1,1) NOT NULL,
	[RespondentId] [varchar](1000) NULL,
	[ProjectId] [int] NULL,
	[Sesskey] [varchar](500) NULL,
	[SurveyStatus] [int] NULL,
	[SurveyRequestIP] [varchar](100) NULL,
	[SurveyRequestDate] [datetime] NULL,
	[SurveyCompletionDate] [datetime] NULL,
	[SurveyCompletionIP] [varchar](100) NULL,
	[UniqueId] [varchar](100) NULL,
	[KinesisProjectId] [int] NULL,
	[PanelId] [int] NULL,
	[QueryId] [int] NULL,
	[KinesisInsertionDate] [datetime] NULL,
 CONSTRAINT [PK_RespondentList] PRIMARY KEY CLUSTERED 
(
	[RespondentListId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ResponseLog]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ResponseLog](
	[ResponseId] [int] IDENTITY(1,1) NOT NULL,
	[ResponseJson] [varchar](1000) NULL,
	[Description] [varchar](1000) NULL,
 CONSTRAINT [PK_ResponseLog] PRIMARY KEY CLUSTERED 
(
	[ResponseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Reward]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Reward](
	[RewardId] [int] IDENTITY(1,1) NOT NULL,
	[CompleteGroup] [int] NULL,
	[LOI] [varchar](500) NULL,
	[SampleRatio] [varchar](500) NULL,
	[Reward] [varchar](50) NULL,
 CONSTRAINT [PK_Reward] PRIMARY KEY CLUSTERED 
(
	[RewardId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Sheet1$]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sheet1$](
	[F1] [nvarchar](255) NULL,
	[F2] [float] NULL,
	[F3] [nvarchar](255) NULL,
	[F4] [nvarchar](255) NULL,
	[F5] [nvarchar](255) NULL,
	[F6] [nvarchar](255) NULL,
	[F7] [nvarchar](255) NULL,
	[F8] [nvarchar](255) NULL,
	[F9] [nvarchar](255) NULL,
	[F10] [nvarchar](255) NULL,
	[F11] [float] NULL,
	[F12] [float] NULL,
	[F13] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SpecialityGroup]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SpecialityGroup](
	[SpecialityId] [int] NOT NULL,
	[SpecialityName] [varchar](200) NULL,
	[SpecialityOptionId] [int] NULL,
	[SpecialityOptionName] [varchar](200) NULL,
	[GroupId] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SurveyLog]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SurveyLog](
	[SurveyLogId] [int] IDENTITY(1,1) NOT NULL,
	[Url] [varchar](1000) NULL,
	[IPAddress] [varchar](100) NULL,
	[RespondentListId] [int] NULL,
	[LogDate] [datetime] NULL,
	[LogType] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[Datapoint] ON 

GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (1, N'Gender', 1)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (2, N'City', 2)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (3, N'State', 3)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (4, N'PostalCode', 4)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (5, N'Country', 5)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (6, N'QCardiologistClass_1GeneralCardiologist', 6)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (7, N'QCardiologistClass_2Non_InvasiveCardiologist', 6)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (8, N'QCardiologistClass_3InvasiveNon_InterventionalCardiologist', 6)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (9, N'QCardiologistClass_4Interventional_Cardiologist', 6)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (10, N'QCardiologistClass_5Electrophysiologist', 6)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (11, N'QCardiologistClass_6Pediatric_Cardiologist', 6)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (12, N'QDoctorWorkplaceSetting', 7)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (13, N'QHCPSpecialty_1Addiction_Medicine', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (14, N'QHCPSpecialty_2Aerospace_Medicine', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (15, N'QHCPSpecialty_3Allergist_ENT', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (16, N'QHCPSpecialty_4Anesthesiology', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (17, N'QHCPSpecialty_5Blood_Banking_Transfusion_Medicine', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (18, N'QHCPSpecialty_6Cardiology', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (19, N'QHCPSpecialty_7Cardiovascular_Diseases', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (20, N'QHCPSpecialty_8Clinical_Biochemical_Genetics', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (21, N'QHCPSpecialty_9Clinical_Pharmacology', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (22, N'QHCPSpecialty_10Dermatology', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (23, N'QHCPSpecialty_11Diabetologist', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (24, N'QHCPSpecialty_12Emergency_Medicine', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (25, N'QHCPSpecialty_13Endocrinology_Diabetes_Metabolism', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (26, N'QHCPSpecialty_14Epidemiology', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (27, N'QHCPSpecialty_15Gastroenterology', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (28, N'QHCPSpecialty_16General_Practice', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (29, N'QHCPSpecialty_17Geriatrics', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (30, N'QHCPSpecialty_18Hematology', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (31, N'QHCPSpecialty_19Hepatology', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (32, N'QHCPSpecialty_20HIV_AIDS', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (33, N'QHCPSpecialty_21Hospitalist', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (34, N'QHCPSpecialty_22Immunology', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (35, N'QHCPSpecialty_23Infectious_Disease', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (36, N'QHCPSpecialty_24Internal_Medicine', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (37, N'QHCPSpecialty_25Legal_Medicine', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (38, N'QHCPSpecialty_26Medical_Genetics', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (39, N'QHCPSpecialty_27Medical_Management', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (40, N'QHCPSpecialty_28Nephrology', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (41, N'QHCPSpecialty_29Neurology', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (42, N'QHCPSpecialty_30Neuropsychiatry', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (43, N'QHCPSpecialty_31Neurotology', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (44, N'QHCPSpecialty_32Nuclear_Medicine', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (45, N'QHCPSpecialty_33Nutrition', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (46, N'QHCPSpecialty_34Obesity', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (47, N'QHCPSpecialty_35Obstetrics_Gynecology', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (48, N'QHCPSpecialty_36Occupational_Medicine', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (49, N'QHCPSpecialty_37Oncology', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (50, N'QHCPSpecialty_38Ophthalmology', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (51, N'QHCPSpecialty_39Orthopedics', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (52, N'QHCPSpecialty_40Otolaryngology', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (53, N'QHCPSpecialty_41Otology', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (54, N'QHCPSpecialty_42Pain_Medicine', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (55, N'QHCPSpecialty_43Palliative_Medicine', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (56, N'QHCPSpecialty_44Pathology', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (57, N'QHCPSpecialty_45Pediatrics', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (58, N'QHCPSpecialty_46Physical_Medicine_Rehabilitation', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (59, N'QHCPSpecialty_47Plastic_Surgery', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (60, N'QHCPSpecialty_48Preventive_Medicine', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (61, N'QHCPSpecialty_49Proctology', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (62, N'QHCPSpecialty_50Psychiatry', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (63, N'QHCPSpecialty_51Public_Health_And_General_Preventive_Med', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (64, N'QHCPSpecialty_52Pulmonary_Medicine', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (65, N'QHCPSpecialty_53Radiology', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (66, N'QHCPSpecialty_54Reproductive_Endocrinology', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (67, N'QHCPSpecialty_55Rheumatology', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (68, N'QHCPSpecialty_56Sleep_Medicine', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (69, N'QHCPSpecialty_57Sports_Medicine', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (70, N'QHCPSpecialty_58Surgery_Surgeon', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (71, N'QHCPSpecialty_59Undersea_Medicine_Hyperbaric_Medic', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (72, N'QHCPSpecialty_60Urogynecology', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (73, N'QHCPSpecialty_61Urology', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (74, N'QHCPSpecialty_62Vascular_Medicine', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (75, N'QHCPSpecialty_63Bariatric_Medicine', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (76, N'QHCPSpecialty_64Community_Medicine', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (77, N'QHCPSpecialty_65Critical_Care_Medicine', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (78, N'QHCPSpecialty_66Medical_Scientist', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (79, N'QHCPSpecialty_67Medical_Biochemistry', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (80, N'QHCPSpecialty_68Respirology', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (81, N'QHCPSpecialty_69Movement_Disorder_Specialist', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (82, N'QHCPSpecialty_70Family_Medicine_Family_Practice', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (83, N'QHCPSpecialty_71Other_Specify', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (84, N'QHCPSpecialty_72Transplant', 8)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (85, N'QOncologistClass_1Medical_Oncologist', 9)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (86, N'QOncologistClass_2Hematologist_Oncologist', 9)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (87, N'QOncologistClass_3Radiation_Oncologist', 9)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (88, N'QOncologistClass_4Surgical_Oncologist', 9)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (89, N'QOncologistClass_5Gynecological_Oncologist', 9)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (90, N'QOncologistClass_6Pediatric_Oncologist', 9)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (91, N'QPanelistType_1Physician', 10)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (92, N'QPanelistType_2Dentist', 10)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (93, N'QPanelistType_3Dentist_Support_Staff', 10)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (94, N'QPanelistType_4Executive_or_Management', 10)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (95, N'QPanelistType_5Administrative_Technician_Operations', 10)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (96, N'QPanelistType_6Pharmacist_Pharmacy_Staff', 10)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (97, N'QPanelistType_7Physician_Support_Staff', 10)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (98, N'QPanelistType_8Optometrist', 10)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (99, N'QPanelistType_9Podiatrist', 10)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (100, N'QPanelistType_10Optician', 10)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (101, N'QPanelistType_11Chiropractor', 10)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (102, N'QPanelistType_12Veterinarian_Veterinary_Staff', 10)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (103, N'QPanelistType_13Executive_or_Management', 10)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (104, N'QPanelistType_14Therapist_Counselor', 10)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (105, N'QPanelistType_15Nurse', 10)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (106, N'QPediatricianClass_1Adolescent_Medicine', 11)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (107, N'QPediatricianClass_2Developmental_Behavioral_Pediatrics', 11)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (108, N'QPediatricianClass_3Hospice_and_Palliative_medicine', 11)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (109, N'QPediatricianClass_4Medical_Toxicology', 11)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (110, N'QPediatricianClass_5Neonatal_Perinatal_medicine', 11)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (111, N'QPediatricianClass_6Neurodevelopmental_Disabilities', 11)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (112, N'QPediatricianClass_7Pediatric_Allergist', 11)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (113, N'QPediatricianClass_8Pediatric_Cardiology', 11)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (114, N'QPediatricianClass_9Pediatric_Critical_Care_Medicine', 11)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (115, N'QPediatricianClass_10Pediatric_Emergency_Medicine', 11)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (116, N'QPediatricianClass_11Pediatric_Endocrinology', 11)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (117, N'QPediatricianClass_12Pediatric_gastroenterology', 11)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (118, N'QPediatricianClass_13Pediatric_Hematology_Oncology', 11)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (119, N'QPediatricianClass_14Pediatric_Infectious_Diseases', 11)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (120, N'QPediatricianClass_15Pediatric_Nephrology', 11)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (121, N'QPediatricianClass_16Pediatric_Neurology', 11)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (122, N'QPediatricianClass_17Pediatric_Ophthalmology', 11)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (123, N'QPediatricianClass_18Pediatric_Otolaryngology', 11)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (124, N'QPediatricianClass_19pediatric_Pulmonology', 11)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (125, N'QPediatricianClass_20Pediatric_Radiology', 11)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (126, N'QPediatricianClass_21Pediatric_Rheumatology', 11)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (127, N'QPediatricianClass_22Pediatric_Sports_Medicine', 11)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (128, N'QPediatricianClass_23Pediatric_Urology', 11)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (129, N'QPediatricianClass_24Pediatric_Sleep_Medicine', 11)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (130, N'QPediatricianClass_25None_of_the_above', 11)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (131, N'QRadiologistClass_1Abdominal_Radiology', 12)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (132, N'QRadiologistClass_2Breast_imaging', 12)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (133, N'QRadiologistClass_3Cardiothoracic_Radiology', 12)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (134, N'QRadiologistClass_4Cardiovascular_Radiology', 12)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (135, N'QRadiologistClass_5Chest_Radiology', 12)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (136, N'QRadiologistClass_6Diagnostic_Radiology', 12)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (137, N'QRadiologistClass_7Endovascular_Surgical_Neuroradiology', 12)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (138, N'QRadiologistClass_8Emergency_Radiology', 12)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (139, N'QRadiologistClass_9Gastrointestinal_GI_Radiology', 12)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (140, N'QRadiologistClass_10Genitourinary_Radiology', 12)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (141, N'QRadiologistClass_11Head_and_Neck_Radiology', 12)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (142, N'QRadiologistClass_12Interventional_Radiology', 12)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (143, N'QRadiologistClass_13Musculoskeletal_Radiology', 12)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (144, N'QRadiologistClass_14Neuroradiology', 12)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (145, N'QRadiologistClass_15Nuclear_Radiology', 12)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (146, N'QRadiologistClass_16Pediatric_Radiology', 12)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (147, N'QRadiologistClass_17Radiation_Oncology', 12)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (148, N'QRadiologistClass_18Other_Specify', 12)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (149, N'QSupportAdminTitles_1Case_Management_Patient_Case_Management', 13)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (150, N'QSupportAdminTitles_2Cath_Laboratory', 13)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (151, N'QSupportAdminTitles_3Clerical_Support', 13)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (152, N'QSupportAdminTitles_4Critical_Care_Intensive_Care', 13)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (153, N'QSupportAdminTitles_5Discharge', 13)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (154, N'QSupportAdminTitles_6Elderly_Care', 13)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (155, N'QSupportAdminTitles_7Emergency_Services', 13)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (156, N'QSupportAdminTitles_8Information_Technology', 13)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (157, N'QSupportAdminTitles_9Materials', 13)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (158, N'QSupportAdminTitles_10Maternity_Neonatal_Care', 13)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (159, N'QSupportAdminTitles_11Medical_Clinical_Laboratory', 13)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (160, N'QSupportAdminTitles_12Nuclear_Medicine_', 13)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (161, N'QSupportAdminTitles_13Nurse_Manager', 13)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (162, N'QSupportAdminTitles_14Nutrition_and_Dietetics', 13)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (163, N'QSupportAdminTitles_15Office_Administrator', 13)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (164, N'QSupportAdminTitles_16Office_Manager', 13)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (165, N'QSupportAdminTitles_17Operating_Room_', 13)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (166, N'QSupportAdminTitles_18Operations_', 13)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (167, N'QSupportAdminTitles_19Pain_management', 13)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (168, N'QSupportAdminTitles_20Pharmacy', 13)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (169, N'QSupportAdminTitles_21Physical_Occupational_Therapy', 13)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (170, N'QSupportAdminTitles_22Purchasing_Procurement', 13)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (171, N'QSupportAdminTitles_23Radiology', 13)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (172, N'QSupportAdminTitles_24Respiratory_Care', 13)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (173, N'QSupportAdminTitles_25Risk_Assessment', 13)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (174, N'QSupportAdminTitles_26Social_Work', 13)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (175, N'QSupportAdminTitles_27Surgical_Support', 13)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (176, N'QSupportAdminTitles_28Other', 13)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (177, N'QSupportAdminTitles_29Cardiology_Cardiac_Ultrasound_Echocardiography', 13)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (178, N'QSurgicalSpecialty_1Bariatric_Surgery', 14)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (179, N'QSurgicalSpecialty_2Cardiac_Surgery', 14)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (180, N'QSurgicalSpecialty_3Cardiothoracic_Surgery', 14)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (181, N'QSurgicalSpecialty_4Colon_Rectal_Surgery', 14)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (182, N'QSurgicalSpecialty_5Dermatological_Surgery', 14)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (183, N'QSurgicalSpecialty_6General_Surgery', 14)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (184, N'QSurgicalSpecialty_7Gynecologic_Surgery', 14)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (185, N'QSurgicalSpecialty_8Maxillofacial_Surgery', 14)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (186, N'QSurgicalSpecialty_9Neurosurgery', 14)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (187, N'QSurgicalSpecialty_10Obstetrics', 14)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (188, N'QSurgicalSpecialty_11Oncology', 14)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (189, N'QSurgicalSpecialty_12Ophthalmology', 14)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (190, N'QSurgicalSpecialty_13Oral_Surgery', 14)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (191, N'QSurgicalSpecialty_14Orthopedic_Surgery', 14)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (192, N'QSurgicalSpecialty_15Otolaryngology', 14)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (193, N'QSurgicalSpecialty_16Pediatric_Surgery', 14)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (194, N'QSurgicalSpecialty_17Plastic_Surgery_Cosmetic_Reconstructive_Surgery', 14)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (195, N'QSurgicalSpecialty_18Podiatry_Surgery', 14)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (196, N'QSurgicalSpecialty_19Thoracic_Surgery', 14)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (197, N'QSurgicalSpecialty_20Transplant_Surgery', 14)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (198, N'QSurgicalSpecialty_21Trauma_Surgery', 14)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (199, N'QSurgicalSpecialty_22Urological_Surgery', 14)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (200, N'QSurgicalSpecialty_23Vascular_Surgery', 14)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (201, N'QSurgicalSpecialty_24Other_Specify', 14)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (202, N'QSurgicalSpecialty_25Pain_Management_Surgery', 14)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (203, N'QSurgicalSpecialty_26Abdominal_Surgery', 14)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (204, N'UniqueIdentifier', 15)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (205, N'PhysicianNPINumber', 16)
GO
SET IDENTITY_INSERT [dbo].[Datapoint] OFF
GO
SET IDENTITY_INSERT [dbo].[Project] ON 

GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (1, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 3, CAST(N'2015-07-30 10:18:36.057' AS DateTime), NULL, 3165, NULL, 3, NULL, N'', NULL, 1, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', CAST(N'2015-12-23 20:07:44.413' AS DateTime), CAST(N'2015-12-23 20:08:23.240' AS DateTime))
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (2, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 4, CAST(N'2015-07-30 10:35:23.450' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (3, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 4, CAST(N'2015-07-30 10:36:01.270' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (4, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 4, CAST(N'2015-07-30 10:48:38.300' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (5, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 4, CAST(N'2015-07-30 10:48:40.130' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (6, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 4, CAST(N'2015-07-30 10:49:18.913' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (7, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 4, CAST(N'2015-07-30 10:50:19.160' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (8, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 4, CAST(N'2015-07-30 11:14:24.310' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (9, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 4, CAST(N'2015-07-30 11:18:32.647' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (10, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 2, CAST(N'2015-07-30 11:19:49.523' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (11, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 4, CAST(N'2015-07-30 11:39:10.233' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (12, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 4, CAST(N'2015-07-30 11:41:02.793' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (13, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 4, CAST(N'2015-07-30 11:42:06.327' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (14, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 4, CAST(N'2015-07-30 11:42:43.373' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (15, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 2, CAST(N'2015-07-30 11:43:16.203' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (16, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 4, CAST(N'2015-07-30 11:43:35.317' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (17, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 4, CAST(N'2015-07-30 11:45:21.490' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (18, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 4, CAST(N'2015-07-30 12:04:27.053' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (19, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 4, CAST(N'2015-07-30 12:07:14.890' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (20, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 2, CAST(N'2015-07-30 12:15:43.110' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (21, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 2, CAST(N'2015-07-30 12:22:32.227' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (22, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 2, CAST(N'2015-07-30 12:22:39.793' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (23, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 4, CAST(N'2015-07-30 12:23:59.113' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (24, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 2, CAST(N'2015-07-30 12:25:30.843' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (25, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 2, CAST(N'2015-07-30 12:27:31.923' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (26, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 2, CAST(N'2015-07-30 12:28:21.150' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (27, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 2, CAST(N'2015-07-30 12:37:29.490' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (28, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 4, CAST(N'2015-07-30 12:37:41.447' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (29, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 4, CAST(N'2015-07-30 12:42:23.453' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (30, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 4, CAST(N'2015-07-30 12:44:49.220' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (31, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 4, CAST(N'2015-07-30 15:14:05.457' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (32, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 4, CAST(N'2015-07-30 15:15:00.040' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (33, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 4, CAST(N'2015-07-30 15:16:24.313' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (34, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 4, CAST(N'2015-07-30 15:22:41.820' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (35, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 4, CAST(N'2015-07-30 17:32:12.387' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (36, N'SCH TEST SURVEY 7', 10, 100, N'http://paradigmsample.com?id=', 4, CAST(N'2015-07-30 18:20:01.427' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (37, N'SCH TEST SURVEY 7', 10, 10, N'http://paradigmsample.com?id=', 4, CAST(N'2015-09-16 15:02:56.923' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST PARADIGM SURVEY4', N'test paradigm sch tes3', N'100', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (38, N'ABC567_-ui', NULL, NULL, N'Qwe2#4_HJ_-', 2, CAST(N'2016-01-11 13:15:20.527' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TTYUJ3234se', NULL, NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (39, N'45GGjjs23', NULL, NULL, NULL, 2, CAST(N'2016-01-11 15:27:26.673' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'45GGjjs23', N'45GGjjs23', NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Project] OFF
GO
SET IDENTITY_INSERT [dbo].[QueryMaster] ON 

GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (1, 1, 10, N' (DataPointId = 8 AND OptionId IN(''6'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 1 AND OptionId IN(1)) AND EXISTS (SELECT * FROM PanelistMaster P2 WHERE P.Identifier=P2.Identifier AND DataPointId = 5 AND OptionId IN(1)) ', N'{"projectid":"9","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}]}', 1, CAST(N'2015-07-31 14:27:40.310' AS DateTime), 19410, 10899, NULL, 1, CAST(N'2015-10-06 11:00:52.133' AS DateTime), NULL, NULL, 1, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (2, 9, 10, N' (DataPointId = 8 AND OptionId IN(''6'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 1 AND OptionId IN(1)) AND EXISTS (SELECT * FROM PanelistMaster P2 WHERE P.Identifier=P2.Identifier AND DataPointId = 5 AND OptionId IN(1)) ', N'{"projectid":"9","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}]}', 1, CAST(N'2015-07-31 14:31:50.840' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (3, 9, 10, N' (DataPointId = 8 AND OptionId IN(''6'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 1 AND OptionId IN(1)) AND EXISTS (SELECT * FROM PanelistMaster P2 WHERE P.Identifier=P2.Identifier AND DataPointId = 5 AND OptionId IN(1)) ', N'{"projectid":"9","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}]}', 1, CAST(N'2015-07-31 14:38:40.530' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (4, 9, 10, N' (DataPointId = 8 AND OptionId IN(''6'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 1 AND OptionId IN(1)) AND EXISTS (SELECT * FROM PanelistMaster P2 WHERE P.Identifier=P2.Identifier AND DataPointId = 5 AND OptionId IN(1)) ', N'{"projectid":"9","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}]}', 1, CAST(N'2015-09-08 12:23:52.087' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (5, 9, 10, N' (DataPointId = 8 AND OptionId IN(''6'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 1 AND OptionId IN(1)) AND EXISTS (SELECT * FROM PanelistMaster P2 WHERE P.Identifier=P2.Identifier AND DataPointId = 5 AND OptionId IN(1)) ', N'{"projectid":"9","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}],"exclusions":["abc","def","ijk"]}', 1, CAST(N'2015-09-08 12:27:26.170' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (6, 9, 10, N' (DataPointId = 8 AND OptionId IN(''6'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 1 AND OptionId IN(1)) AND EXISTS (SELECT * FROM PanelistMaster P2 WHERE P.Identifier=P2.Identifier AND DataPointId = 5 AND OptionId IN(1)) ', N'{"projectid":"9","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}],"exclusions":[]}', 1, CAST(N'2015-09-08 12:28:52.527' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (7, 9, 10, N' (DataPointId = 8 AND OptionId IN(''6'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 1 AND OptionId IN(1)) AND EXISTS (SELECT * FROM PanelistMaster P2 WHERE P.Identifier=P2.Identifier AND DataPointId = 5 AND OptionId IN(1)) ', N'{"projectid":"9","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}],"exclusions":null}', 1, CAST(N'2015-09-08 12:29:16.643' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (8, 9, 10, N' (DataPointId = 8 AND OptionId IN(''6'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 1 AND OptionId IN(1)) AND EXISTS (SELECT * FROM PanelistMaster P2 WHERE P.Identifier=P2.Identifier AND DataPointId = 5 AND OptionId IN(1)) AND EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(System.Collections.Generic.List`1[System.String])) ', N'{"projectid":"9","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}],"exclusions":["abc","def","ijk"]}', 1, CAST(N'2015-09-08 12:37:05.783' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'1.00', 1, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (9, 9, 10, N' (DataPointId = 8 AND OptionId IN(''6'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 1 AND OptionId IN(''1'')) AND EXISTS (SELECT * FROM PanelistMaster P2 WHERE P.Identifier=P2.Identifier AND DataPointId = 5 AND OptionId IN(''1'')) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN('',,,,,,'')) ', N'{"projectid":"9","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}],"exclusions":["abc","def","ijk"]}', 1, CAST(N'2015-09-08 12:43:27.950' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (10, 9, 10, N' (DataPointId = 8 AND OptionId IN(''6'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 1 AND OptionId IN(''1'')) AND EXISTS (SELECT * FROM PanelistMaster P2 WHERE P.Identifier=P2.Identifier AND DataPointId = 5 AND OptionId IN(''1'')) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''abc,def,ijk'')) ', N'{"projectid":"9","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}],"exclusions":["abc","def","ijk"]}', 1, CAST(N'2015-09-08 12:44:28.387' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (11, 9, 10, N' (DataPointId = 8 AND OptionId IN(''6,9'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 1 AND OptionId IN(''1'')) AND EXISTS (SELECT * FROM PanelistMaster P2 WHERE P.Identifier=P2.Identifier AND DataPointId = 5 AND OptionId IN(''1'')) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''abc'',''def'',''ijk'')) ', N'{"projectid":"9","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6","9"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}],"exclusions":["abc","def","ijk"]}', 1, CAST(N'2015-09-08 12:47:31.003' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (12, 9, 10, N' (DataPointId = 8 AND OptionId IN(6,9) ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 1 AND OptionId IN(1)) AND EXISTS (SELECT * FROM PanelistMaster P2 WHERE P.Identifier=P2.Identifier AND DataPointId = 5 AND OptionId IN(1)) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''abc'',''def'',''ijk'')) ', N'{"projectid":"9","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6","9"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}],"exclusions":["abc","def","ijk"]}', 1, CAST(N'2015-09-08 12:54:28.283' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (13, 9, 10, N' (DataPointId = 8 AND OptionId IN(''6'',''9'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 1 AND OptionId IN(''1'')) AND EXISTS (SELECT * FROM PanelistMaster P2 WHERE P.Identifier=P2.Identifier AND DataPointId = 5 AND OptionId IN(''1'')) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''abc'',''def'',''ijk'')) ', N'{"projectid":"9","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6","9"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}],"exclusions":["abc","def","ijk"]}', 1, CAST(N'2015-09-08 12:56:33.420' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (14, 9, 10, N' (DataPointId = 8 AND OptionId IN(''6'',''9'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 1 AND OptionId IN(''1'')) AND EXISTS (SELECT * FROM PanelistMaster P2 WHERE P.Identifier=P2.Identifier AND DataPointId = 5 AND OptionId IN(''1'')) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''abc'',''def'',''ijk'')) ', N'{"projectid":"9","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6","9"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}],"exclusions":["abc","def","ijk"]}', 1, CAST(N'2015-09-08 13:53:51.430' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (15, 9, 10, N' (DataPointId = 1 AND OptionId IN(''male'') ) ', N'{"projectid":"9","reqn":"10","specialty":"1","querycondition":[{"datapointid":"1","datapointoptions":["male"]}],"exclusions":null}', 1, CAST(N'2015-09-09 14:52:37.937' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (16, 1, 10, N' (DataPointId = 1 AND OptionId IN(''male'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''abc'')) ', N'{"projectid":"1","reqn":"10","specialty":"1","querycondition":[{"datapointid":"1","datapointoptions":["male"]}],"exclusions":["abc"]}', 1, CAST(N'2015-09-09 14:54:23.140' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (17, 1, 10, N' (DataPointId = 1 AND OptionId IN(''male'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''abc'')) ', N'{"projectid":"1","reqn":"10","specialty":"1","querycondition":[{"datapointid":"1","datapointoptions":["male"]}],"exclusions":["abc"]}', 1, CAST(N'2015-09-09 14:55:14.303' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (18, 1, 10, N' (DataPointId = 1 AND OptionId IN(''male'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''abc123'')) ', N'{"projectid":"1","reqn":"10","specialty":"1","querycondition":[{"datapointid":"1","datapointoptions":["male"]}],"exclusions":["abc123"]}', 1, CAST(N'2015-09-09 14:56:19.677' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (19, 1, 10, N' (DataPointId = 1 AND OptionId IN(''male'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''abc123'')) ', N'{"projectid":"1","reqn":"10","specialty":"1","querycondition":[{"datapointid":"1","datapointoptions":["male"]}],"exclusions":["abc123"]}', 1, CAST(N'2015-09-09 14:57:21.500' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (20, 1, 10, N' (DataPointId = 1 AND OptionId IN(''male'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''abc123'')) ', N'{"projectid":"1","reqn":"10","specialty":"1","querycondition":[{"datapointid":"1","datapointoptions":["male"]}],"exclusions":["abc123"]}', 1, CAST(N'2015-09-09 15:55:43.743' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (21, 1, 10, N' (DataPointId = 1 AND OptionId IN(''male'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''abc123'')) ', N'{"projectid":"1","reqn":"10","specialty":"1","querycondition":[{"datapointid":"1","datapointoptions":["male"]}],"exclusions":["abc123"]}', 1, CAST(N'2015-09-09 15:56:08.723' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (22, 1, 10, N' (DataPointId = 1 AND OptionId IN(''male'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''abc123'')) ', N'{"projectid":"1","reqn":"10","specialty":"1","querycondition":[{"datapointid":"1","datapointoptions":["male"]}],"exclusions":["abc123"]}', 1, CAST(N'2015-09-09 15:58:32.723' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (23, 1, 10, N' (DataPointId = 1 AND OptionId IN(''male'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''abc123'')) ', N'{"projectid":"1","reqn":"10","specialty":"1","querycondition":[{"datapointid":"1","datapointoptions":["male"]}],"exclusions":["abc123"]}', 1, CAST(N'2015-09-09 16:03:48.570' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (24, 1, 10, N' (DataPointId = 1 AND OptionId IN(''male'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''abc123'')) ', N'{"projectid":"1","reqn":"10","specialty":"1","querycondition":[{"datapointid":"1","datapointoptions":["male"]}],"exclusions":["abc123"]}', 1, CAST(N'2015-09-09 16:04:06.900' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (25, 1, 10, N' (DataPointId = 1 AND OptionId IN(''male'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''abc123'')) ', N'{"projectid":"1","reqn":"10","specialty":"1","querycondition":[{"datapointid":"1","datapointoptions":["male"]}],"exclusions":["abc123"]}', 1, CAST(N'2015-09-09 16:04:25.253' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (26, 1, 92, N' (DataPointId = 3 AND OptionId IN(''1'',''5'',''7'') ) ', N'{"projectid":"1","reqn":"92","specialty":"3","querycondition":[{"datapointid":"3","datapointoptions":["1","5","7"]}],"exclusions":[]}', 3, CAST(N'2015-09-17 15:35:49.293' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (27, 1, 92, N' (DataPointId = 3 AND OptionId IN(''1'',''5'',''7'') ) ', N'{"projectid":"1","reqn":"92","specialty":"3","querycondition":[{"datapointid":"3","datapointoptions":["1","5","7"]}],"exclusions":[]}', 3, CAST(N'2015-09-17 15:39:54.637' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (28, 1, 92, N'', N'{"projectid":"1","reqn":"92","specialty":"3","querycondition":[],"exclusions":[]}', 3, CAST(N'2015-09-18 11:34:06.383' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (29, 1, 92, N'', N'{"projectid":"1","reqn":"92","specialty":"3","querycondition":[],"exclusions":[]}', 3, CAST(N'2015-09-18 11:34:26.043' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (30, 1, 92, N' (DataPointId != 16 AND OptionId NOT IN(''1'') ) ', N'{"projectid":"1","reqn":"92","specialty":"3","querycondition":[],"exclusions":["1"]}', 3, CAST(N'2015-09-18 11:34:59.470' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (31, 1, 92, N' (DataPointId = 3 AND OptionId IN(''1'',''5'',''7'') ) ', N'{"projectid":"1","reqn":"92","specialty":"3","querycondition":[{"datapointid":"3","datapointoptions":["1","5","7"]}],"exclusions":[]}', 3, CAST(N'2015-09-18 12:33:17.827' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (32, 1, 92, N' (DataPointId = 3 AND OptionId IN(''1'',''5'',''7'') ) ', N'{"projectid":"1","reqn":"92","specialty":"3","querycondition":[{"datapointid":"3","datapointoptions":["1","5","7"]}],"exclusions":[]}', 3, CAST(N'2015-09-18 12:38:59.013' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (33, 1, 92, N' (DataPointId = 8 AND OptionId IN(''1'',''5'',''7'') ) ', N'{"projectid":"1","reqn":"92","specialty":"3","querycondition":[{"datapointid":"8","datapointoptions":["1","5","7"]}],"exclusions":[]}', 3, CAST(N'2015-10-15 11:42:04.330' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (34, 1, 92, N' (DataPointId = 8 AND OptionId IN(''1'') ) ', N'{"projectid":"1","reqn":"92","specialty":"3","querycondition":[{"datapointid":"8","datapointoptions":["1"]}],"exclusions":[]}', 1, CAST(N'2015-10-15 12:03:45.870' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (35, 1, 92, N' (DataPointId = 8 AND OptionId IN(''10'') ) ', N'{"projectid":"1","reqn":"92","specialty":"3","querycondition":[{"datapointid":"8","datapointoptions":["10"]}],"exclusions":[]}', 10, CAST(N'2015-10-15 12:13:40.630' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (36, 1, 92, N' (DataPointId = 8 AND OptionId IN(''15'') ) ', N'{"projectid":"1","reqn":"92","specialty":"3","querycondition":[{"datapointid":"8","datapointoptions":["15"]}],"exclusions":[]}', 15, CAST(N'2015-10-15 12:14:56.477' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (37, 1, 92, N' (DataPointId = 8 AND OptionId IN(''15'') ) ', N'{"projectid":"1","reqn":"92","specialty":"3","querycondition":[{"datapointid":"8","datapointoptions":["15"]}],"exclusions":[]}', 15, CAST(N'2015-10-16 10:35:49.507' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [SampleId], [CampaignId], [Reward], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount]) VALUES (38, 1, 92, N' (DataPointId = 8 AND OptionId IN(''1'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 9 AND OptionId IN(''1'',''2'',''3'')) ', N'{"projectid":"1","reqn":"92","specialty":"3","querycondition":[{"datapointid":"8","datapointoptions":["1"]},{"datapointid":"9","datapointoptions":["1","2","3"]}],"exclusions":[]}', 1, CAST(N'2015-10-16 15:14:29.457' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[QueryMaster] OFF
GO
SET IDENTITY_INSERT [dbo].[RequestLog] ON 

GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (1, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 10:18:35.540' AS DateTime), N'{
  "projectid": "1",
  "success": "true"
}', CAST(N'2015-07-30 10:18:36.173' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (2, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 10:35:23.427' AS DateTime), N'{
  "projectid": "2",
  "success": "true"
}', CAST(N'2015-07-30 10:35:23.473' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (3, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 10:36:01.240' AS DateTime), N'{"projectid":"3","success":"true"}', CAST(N'2015-07-30 10:36:01.330' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (4, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 10:48:38.270' AS DateTime), N'', CAST(N'2015-07-30 10:48:38.353' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (5, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 10:48:40.083' AS DateTime), N'', CAST(N'2015-07-30 10:48:40.147' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (6, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 10:49:18.893' AS DateTime), N'', CAST(N'2015-07-30 10:50:02.433' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (7, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 10:50:19.137' AS DateTime), N'', CAST(N'2015-07-30 10:50:43.877' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (8, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 11:14:24.290' AS DateTime), N'{"projectid":"8","success":"true"}', CAST(N'2015-07-30 11:14:34.093' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (9, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 11:18:32.620' AS DateTime), N'{"projectid":"9","success":"true"}', CAST(N'2015-07-30 11:18:51.970' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (10, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 11:19:49.490' AS DateTime), N'{"projectid":"10","success":"true"}', CAST(N'2015-07-30 11:19:51.183' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (11, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 11:39:10.213' AS DateTime), N'{"projectid":"11","success":"true"}', CAST(N'2015-07-30 11:39:16.477' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (12, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 11:41:02.650' AS DateTime), N'{"projectid":"12","success":"true"}', CAST(N'2015-07-30 11:41:05.103' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (13, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 11:42:06.293' AS DateTime), N'{"projectid":"13","success":"true"}', CAST(N'2015-07-30 11:42:17.960' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (14, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 11:42:43.353' AS DateTime), N'{"projectid":"14","success":"true"}', CAST(N'2015-07-30 11:42:45.457' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (15, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 11:43:16.167' AS DateTime), N'{"projectid":"15","success":"true"}', CAST(N'2015-07-30 11:43:20.850' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (16, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 11:43:35.270' AS DateTime), N'{"projectid":"16","success":"true"}', CAST(N'2015-07-30 11:43:37.017' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (17, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 11:45:21.460' AS DateTime), N'{"projectid":"17","success":"true"}', CAST(N'2015-07-30 11:45:22.287' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (18, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 12:04:27.030' AS DateTime), N'{"projectid":"18","success":"true"}', CAST(N'2015-07-30 12:04:27.063' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (19, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 12:07:14.863' AS DateTime), N'{"projectid":"19","success":"true"}', CAST(N'2015-07-30 12:07:56.633' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (20, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 12:15:13.353' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (21, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 12:22:32.190' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (22, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 12:22:39.770' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (23, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 12:23:59.093' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (24, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 12:25:30.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (25, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 12:27:31.880' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (26, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 12:28:21.073' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (27, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 12:37:29.443' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (28, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 12:37:41.410' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (29, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 12:42:12.243' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (30, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 12:44:48.417' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (31, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 15:22:41.777' AS DateTime), N'{"projectid":"34","success":"true"}', CAST(N'2015-07-30 15:22:48.373' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (32, N'{"success":"false","error":"Invalid Data."}', CAST(N'2015-07-30 15:28:26.167' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (33, N'{"success":false,"error":"Invalid Data."}', CAST(N'2015-07-30 17:31:56.090' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (34, N'{"success":false,"error":"Invalid Data."}', CAST(N'2015-07-30 17:31:56.913' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (35, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 17:32:12.363' AS DateTime), N'{"projectid":35,"success":true}', CAST(N'2015-07-30 17:32:16.317' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (36, N'{"success":false,"error":"The Project is active or close you cannot delete the respondents."}', CAST(N'2015-07-30 17:32:32.533' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (37, N'{"success":false,"error":"Invalid Data."}', CAST(N'2015-07-30 18:05:26.930' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (38, N'{"success":false,"error":"Invalid Data."}', CAST(N'2015-07-30 18:05:32.940' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (39, N'{"success":false,"error":"Invalid Data."}', CAST(N'2015-07-30 18:13:18.360' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (40, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"100","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-07-30 18:20:01.397' AS DateTime), N'{"projectid":36,"success":true}', CAST(N'2015-07-30 18:20:01.477' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (41, N'{"projectid":"9","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}]}', CAST(N'2015-07-31 14:27:40.127' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (42, N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-07-31 14:27:41.733' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (43, N'{"projectid":"9","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}]}', CAST(N'2015-07-31 14:30:27.617' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (44, N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-07-31 14:38:32.300' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (45, N'{"projectid":"9","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}]}', CAST(N'2015-07-31 14:38:38.120' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (46, N'{"success":true,"queryid":3,"projectid":9,"feasibility":0}', CAST(N'2015-07-31 14:38:42.640' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (47, N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-08-13 13:35:50.327' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (48, N'{"success":true,"queryid":1}', CAST(N'2015-08-13 13:40:05.917' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (49, N'{"projectid":"9","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}]}', CAST(N'2015-09-08 11:21:44.810' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (50, N'{"projectid":"9","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}],"exclusions":["abc","def","ijk"]}', CAST(N'2015-09-08 12:27:12.353' AS DateTime), N'{"success":true,"queryid":5,"projectid":9,"feasibility":0}', CAST(N'2015-09-08 12:27:26.300' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (51, N'{"projectid":"9","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}],"exclusions":[]}', CAST(N'2015-09-08 12:28:42.440' AS DateTime), N'{"success":true,"queryid":6,"projectid":9,"feasibility":0}', CAST(N'2015-09-08 12:28:52.623' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (52, N'{"projectid":"9","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}],"exclusions":null}', CAST(N'2015-09-08 12:29:06.440' AS DateTime), N'{"success":true,"queryid":7,"projectid":9,"feasibility":0}', CAST(N'2015-09-08 12:29:16.743' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (53, N'{"projectid":"9","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}],"exclusions":["abc","def","ijk"]}', CAST(N'2015-09-08 12:35:06.993' AS DateTime), N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-09-08 12:37:05.850' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (54, N'{"projectid":"9","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}],"exclusions":["abc","def","ijk"]}', CAST(N'2015-09-08 12:42:25.900' AS DateTime), N'{"success":true,"queryid":9,"projectid":9,"feasibility":0}', CAST(N'2015-09-08 12:43:28.357' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (55, N'{"projectid":"9","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}],"exclusions":["abc","def","ijk"]}', CAST(N'2015-09-08 12:43:44.493' AS DateTime), N'{"success":true,"queryid":10,"projectid":9,"feasibility":0}', CAST(N'2015-09-08 12:44:28.577' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (56, N'{"projectid":"9","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6","9"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}],"exclusions":["abc","def","ijk"]}', CAST(N'2015-09-08 12:45:47.753' AS DateTime), N'{"success":true,"queryid":11,"projectid":9,"feasibility":0}', CAST(N'2015-09-08 12:47:31.227' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (57, N'{"projectid":"9","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6","9"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}],"exclusions":["abc","def","ijk"]}', CAST(N'2015-09-08 12:51:30.823' AS DateTime), N'{"success":true,"queryid":12,"projectid":9,"feasibility":0}', CAST(N'2015-09-08 12:54:28.477' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (58, N'{"projectid":"9","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6","9"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}],"exclusions":["abc","def","ijk"]}', CAST(N'2015-09-08 12:55:57.573' AS DateTime), N'{"success":true,"queryid":13,"projectid":9,"feasibility":0}', CAST(N'2015-09-08 12:56:33.610' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (59, N'{"projectid":"9","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6","9"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}],"exclusions":["abc","def","ijk"]}', CAST(N'2015-09-08 12:56:50.207' AS DateTime), N'{"success":true,"queryid":14,"projectid":9,"feasibility":0}', CAST(N'2015-09-08 13:53:51.650' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (60, N'{"success":false,"error":"Invalid Data."}', CAST(N'2015-09-08 14:22:25.750' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (61, N'{"projectid":"9","reqn":"10","specialty":"1","querycondition":[{"datapointid":"1","datapointoptions":["male"]}],"exclusions":null}', CAST(N'2015-09-09 14:52:37.833' AS DateTime), N'{"success":true,"queryid":15,"projectid":9,"feasibility":0}', CAST(N'2015-09-09 14:52:38.147' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (62, N'{"projectid":"1","reqn":"10","specialty":"1","querycondition":[{"datapointid":"1","datapointoptions":["male"]}],"exclusions":["abc"]}', CAST(N'2015-09-09 14:54:23.110' AS DateTime), N'{"success":true,"queryid":16,"projectid":1,"feasibility":0}', CAST(N'2015-09-09 14:54:23.187' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (63, N'{"projectid":"1","reqn":"10","specialty":"1","querycondition":[{"datapointid":"1","datapointoptions":["male"]}],"exclusions":["abc"]}', CAST(N'2015-09-09 14:55:14.267' AS DateTime), N'{"success":true,"queryid":17,"projectid":1,"feasibility":0}', CAST(N'2015-09-09 14:55:14.357' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (64, N'{"projectid":"1","reqn":"10","specialty":"1","querycondition":[{"datapointid":"1","datapointoptions":["male"]}],"exclusions":["abc123"]}', CAST(N'2015-09-09 14:56:19.643' AS DateTime), N'{"success":true,"queryid":18,"projectid":1,"feasibility":0}', CAST(N'2015-09-09 14:56:19.717' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (65, N'{"projectid":"1","reqn":"10","specialty":"1","querycondition":[{"datapointid":"1","datapointoptions":["male"]}],"exclusions":["abc123"]}', CAST(N'2015-09-09 14:57:21.463' AS DateTime), N'{"success":true,"queryid":19,"projectid":1,"feasibility":0}', CAST(N'2015-09-09 14:57:21.600' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (66, N'{"projectid":"1","reqn":"10","specialty":"1","querycondition":[{"datapointid":"1","datapointoptions":["male"]}],"exclusions":["abc123"]}', CAST(N'2015-09-09 14:59:53.987' AS DateTime), N'{"success":true,"queryid":20,"projectid":1,"feasibility":0}', CAST(N'2015-09-09 15:55:43.847' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (67, N'{"projectid":"1","reqn":"10","specialty":"1","querycondition":[{"datapointid":"1","datapointoptions":["male"]}],"exclusions":["abc123"]}', CAST(N'2015-09-09 15:56:07.037' AS DateTime), N'{"success":true,"queryid":21,"projectid":1,"feasibility":0}', CAST(N'2015-09-09 15:56:08.877' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (68, N'{"projectid":"1","reqn":"10","specialty":"1","querycondition":[{"datapointid":"1","datapointoptions":["male"]}],"exclusions":["abc123"]}', CAST(N'2015-09-09 15:58:30.127' AS DateTime), N'{"success":true,"queryid":22,"projectid":1,"feasibility":0}', CAST(N'2015-09-09 15:58:32.790' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (69, N'{"projectid":"1","reqn":"10","specialty":"1","querycondition":[{"datapointid":"1","datapointoptions":["male"]}],"exclusions":["abc123"]}', CAST(N'2015-09-09 16:03:47.087' AS DateTime), N'{"success":true,"queryid":23,"projectid":1,"feasibility":0}', CAST(N'2015-09-09 16:03:48.977' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (70, N'{"projectid":"1","reqn":"10","specialty":"1","querycondition":[{"datapointid":"1","datapointoptions":["male"]}],"exclusions":["abc123"]}', CAST(N'2015-09-09 16:04:05.290' AS DateTime), N'{"success":true,"queryid":24,"projectid":1,"feasibility":0}', CAST(N'2015-09-09 16:04:06.963' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (71, N'{"projectid":"1","reqn":"10","specialty":"1","querycondition":[{"datapointid":"1","datapointoptions":["male"]}],"exclusions":["abc123"]}', CAST(N'2015-09-09 16:04:23.783' AS DateTime), N'{"success":true,"queryid":25,"projectid":1,"feasibility":0}', CAST(N'2015-09-09 16:04:25.310' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (72, N'{"projectid":"1","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["1285634196","1659484145","1205896362","1790778793","1881667137","1689650327","1265472849","1255375135","1417927732","1487811931"]}', CAST(N'2015-09-16 10:19:13.467' AS DateTime), N'{"success":false,"error":"The Project is closed you cannot add new respondents."}', CAST(N'2015-09-16 10:19:19.950' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (73, N'{"projectid":"87","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["1285634196","1659484145","1205896362","1790778793","1881667137","1689650327","1265472849","1255375135","1417927732","1487811931","1003801853","1689686677","1235179839","1811934680","1669687299","1205948288","1356315303","1164403127","1902830888","1902830888","1902830888","1134143506","1104998194","1316942170","1285770925","1053419192","1083630834","1598711251","1053336354","1497719959","1689684524","1033145701","1043316615","1134172364","1770578031","1790878809","1619101268","1972529717","1346238284","1841293933","1366415804","1295819357","1265427496","1730175266","1629064605","1003093600","1427011444","1790725125","1144228966","1992898977","1750376380","1144250739","4631256798","1467720045","1376645838","1134115397","1275546038","1992762108","1992762108","016027204185","495167700147","1144338161","umpa","Health first cardiology","1902824287","AK3205285","1932157302","1710071717","1104828300","1083656821","1073680393","1306830682","1760504351","1376659813","1457387888","1720190986","1821094665","1174525778","1003837873","1942296140","1083766729","1578670154","1508035163","1871546523","1912997321","1386640522","1356360887","1427254432","1235227133","1669574976","NA","1184652638","1730137688","NA","Na","1982631966","NA","1780603860","1780651497","1679747950","1588690440","1063495893","1710967153","1649360447","1578572327","1902924152","1831172840","1558362152","1265446371","1467482703","1922070291","1497742381","1962460501","1023061850","1881695302","1437166394","1104822261","1225063902","1376569061","1295739274","1316912918","1255313540","1477635084","1982795894","1144288069","1164494563","1295765659","1659310761","1447342951","1639141229","Penn Medicine Valley Forge","1275786352","1609849256","1376675637","1790784395","1619987930","1811959869","1003961764","1366514259","1922088517","1306840210","1093714743","1225057532","1861589269', CAST(N'2015-09-16 10:31:05.083' AS DateTime), N'{"success":false,"error":"No project found with this Id."}', CAST(N'2015-09-16 12:20:34.550' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (74, N'{"projectid":"87","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["1285634196","1659484145","1205896362","1790778793","1881667137","1689650327","1265472849","1255375135","1417927732","1487811931","1003801853","1689686677","1235179839","1811934680","1669687299","1205948288","1356315303","1164403127","1902830888","1902830888","1902830888","1134143506","1104998194","1316942170","1285770925","1053419192","1083630834","1598711251","1053336354","1497719959","1689684524","1033145701","1043316615","1134172364","1770578031","1790878809","1619101268","1972529717","1346238284","1841293933","1366415804","1295819357","1265427496","1730175266","1629064605","1003093600","1427011444","1790725125","1144228966","1992898977","1750376380","1144250739","4631256798","1467720045","1376645838","1134115397","1275546038","1992762108","1992762108","016027204185","495167700147","1144338161","umpa","Health first cardiology","1902824287","AK3205285","1932157302","1710071717","1104828300","1083656821","1073680393","1306830682","1760504351","1376659813","1457387888","1720190986","1821094665","1174525778","1003837873","1942296140","1083766729","1578670154","1508035163","1871546523","1912997321","1386640522","1356360887","1427254432","1235227133","1669574976","NA","1184652638","1730137688","NA","Na","1982631966","NA","1780603860","1780651497","1679747950","1588690440","1063495893","1710967153","1649360447","1578572327","1902924152","1831172840","1558362152","1265446371","1467482703","1922070291","1497742381","1962460501","1023061850","1881695302","1437166394","1104822261","1225063902","1376569061","1295739274","1316912918","1255313540","1477635084","1982795894","1144288069","1164494563","1295765659","1659310761","1447342951","1639141229","Penn Medicine Valley Forge","1275786352","1609849256","1376675637","1790784395","1619987930","1811959869","1003961764","1366514259","1922088517","1306840210","1093714743","1225057532","1861589269', CAST(N'2015-09-16 13:26:52.277' AS DateTime), N'{"success":false,"error":"No project found with this Id."}', CAST(N'2015-09-16 13:27:58.210' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (75, N'{"projectid":"1","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["1285634196","1659484145","1205896362","1790778793","1881667137","1689650327","1265472849","1255375135","1417927732","1487811931","1003801853","1689686677","1235179839","1811934680","1669687299","1205948288","1356315303","1164403127","1902830888","1902830888","1902830888","1134143506","1104998194","1316942170","1285770925","1053419192","1083630834","1598711251","1053336354","1497719959","1689684524","1033145701","1043316615","1134172364","1770578031","1790878809","1619101268","1972529717","1346238284","1841293933","1366415804","1295819357","1265427496","1730175266","1629064605","1003093600","1427011444","1790725125","1144228966","1992898977","1750376380","1144250739","4631256798","1467720045","1376645838","1134115397","1275546038","1992762108","1992762108","016027204185","495167700147","1144338161","umpa","Health first cardiology","1902824287","AK3205285","1932157302","1710071717","1104828300","1083656821","1073680393","1306830682","1760504351","1376659813","1457387888","1720190986","1821094665","1174525778","1003837873","1942296140","1083766729","1578670154","1508035163","1871546523","1912997321","1386640522","1356360887","1427254432","1235227133","1669574976","NA","1184652638","1730137688","NA","Na","1982631966","NA","1780603860","1780651497","1679747950","1588690440","1063495893","1710967153","1649360447","1578572327","1902924152","1831172840","1558362152","1265446371","1467482703","1922070291","1497742381","1962460501","1023061850","1881695302","1437166394","1104822261","1225063902","1376569061","1295739274","1316912918","1255313540","1477635084","1982795894","1144288069","1164494563","1295765659","1659310761","1447342951","1639141229","Penn Medicine Valley Forge","1275786352","1609849256","1376675637","1790784395","1619987930","1811959869","1003961764","1366514259","1922088517","1306840210","1093714743","1225057532","1861589269"', CAST(N'2015-09-16 13:28:07.370' AS DateTime), N'{"success":false,"error":"The Project is closed you cannot add new respondents."}', CAST(N'2015-09-16 13:28:10.233' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (76, N'{"projectid":"9","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["1285634196","1659484145","1205896362","1790778793","1881667137","1689650327","1265472849","1255375135","1417927732","1487811931","1003801853","1689686677","1235179839","1811934680","1669687299","1205948288","1356315303","1164403127","1902830888","1902830888","1902830888","1134143506","1104998194","1316942170","1285770925","1053419192","1083630834","1598711251","1053336354","1497719959","1689684524","1033145701","1043316615","1134172364","1770578031","1790878809","1619101268","1972529717","1346238284","1841293933","1366415804","1295819357","1265427496","1730175266","1629064605","1003093600","1427011444","1790725125","1144228966","1992898977","1750376380","1144250739","4631256798","1467720045","1376645838","1134115397","1275546038","1992762108","1992762108","016027204185","495167700147","1144338161","umpa","Health first cardiology","1902824287","AK3205285","1932157302","1710071717","1104828300","1083656821","1073680393","1306830682","1760504351","1376659813","1457387888","1720190986","1821094665","1174525778","1003837873","1942296140","1083766729","1578670154","1508035163","1871546523","1912997321","1386640522","1356360887","1427254432","1235227133","1669574976","NA","1184652638","1730137688","NA","Na","1982631966","NA","1780603860","1780651497","1679747950","1588690440","1063495893","1710967153","1649360447","1578572327","1902924152","1831172840","1558362152","1265446371","1467482703","1922070291","1497742381","1962460501","1023061850","1881695302","1437166394","1104822261","1225063902","1376569061","1295739274","1316912918","1255313540","1477635084","1982795894","1144288069","1164494563","1295765659","1659310761","1447342951","1639141229","Penn Medicine Valley Forge","1275786352","1609849256","1376675637","1790784395","1619987930","1811959869","1003961764","1366514259","1922088517","1306840210","1093714743","1225057532","1861589269"', CAST(N'2015-09-16 13:28:19.200' AS DateTime), N'{"success":false,"error":"The Project is closed you cannot add new respondents."}', CAST(N'2015-09-16 13:28:21.810' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (77, N'{"projectid":"9","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["1285634196","1659484145","1205896362","1790778793","1881667137","1689650327","1265472849","1255375135","1417927732","1487811931","1003801853","1689686677","1235179839","1811934680","1669687299","1205948288","1356315303","1164403127","1902830888","1902830888","1902830888","1134143506","1104998194","1316942170","1285770925","1053419192","1083630834","1598711251","1053336354","1497719959","1689684524","1033145701","1043316615","1134172364","1770578031","1790878809","1619101268","1972529717","1346238284","1841293933","1366415804","1295819357","1265427496","1730175266","1629064605","1003093600","1427011444","1790725125","1144228966","1992898977","1750376380","1144250739","4631256798","1467720045","1376645838","1134115397","1275546038","1992762108","1992762108","016027204185","495167700147","1144338161","umpa","Health first cardiology","1902824287","AK3205285","1932157302","1710071717","1104828300","1083656821","1073680393","1306830682","1760504351","1376659813","1457387888","1720190986","1821094665","1174525778","1003837873","1942296140","1083766729","1578670154","1508035163","1871546523","1912997321","1386640522","1356360887","1427254432","1235227133","1669574976","NA","1184652638","1730137688","NA","Na","1982631966","NA","1780603860","1780651497","1679747950","1588690440","1063495893","1710967153","1649360447","1578572327","1902924152","1831172840","1558362152","1265446371","1467482703","1922070291","1497742381","1962460501","1023061850","1881695302","1437166394","1104822261","1225063902","1376569061","1295739274","1316912918","1255313540","1477635084","1982795894","1144288069","1164494563","1295765659","1659310761","1447342951","1639141229","Penn Medicine Valley Forge","1275786352","1609849256","1376675637","1790784395","1619987930","1811959869","1003961764","1366514259","1922088517","1306840210","1093714743","1225057532","1861589269","1992725071","1003914227","1669558508","1427039247","1407823578","1396788022","1396788022","1841277373","1750377545","1780796417","1598737223","1467673467","1144399718","1205928876","1114975737","1750476115","1114998986","1184604274","1356443451","1821065574","1699731851","1912103052","1861485104","1234","1912941345","1851309629","1346220019","1407041064","1649372319","1871594887","1780763250","1790834281","1861497802","1114913142","1780609057","1780609057","1700913076","N/A","Refusal","1083677710","1558408260","1770502544","1336150234","1174586499","1568532927","1043272776","Refusal","Refusal","Refusal","1891832499","1417142597","1922325687","1104900216","1619130291","1861454423","1619928892","1851349757","Refusal","1447222831","1376679084","1700835196","1891720579","1841254885","1588685176","1205884178","1851359533","Refusal","1043246572","1942505490","1730160524","1073556288","1568591006","1780642272","1992785018","1982605721","1568456366","1366541302","1356544993","1407055296","REFUSAL","1538324645","1174752554","1255308813","Refusal","1164476602","Private Practice","1922274364","1356377196","asdf","1902888365","1538186382","Refusal","1770668758","1568745016","1902823529","1447436126","1083892111","1053471110","1790726396","1811969041","1023065745","1760421564","1134297385","1669416160","30696 AZ.","Refusal","1639171606","1336343912","Refusal","1790834281","1346222353","1881680098","N/P","1003975673","1801861513","1053562470","1699772582","1417919499","1528089745","1356385330","1932143997","1497703367","1366493033","1003803412","None","1144279084","1013900851","1528012234","1538384250","1093880361","1275585846","1336296789","1205864550","1285781948","1134443112","1568558906","1215915012","1679520688","1447294699","1528070505","1558470112","1447333554","1366468894","1154494425","1962440701","1760696314","1356300222","1285913632","1023332079","1841516952","1215183934","5907859078","1225091812","1811055874","1508853052","1437120078","1457466518","1073558615","1881661601","1255303947","1811064785","1336206374","1215927900","1962546366","1851321442"]}', CAST(N'2015-09-16 15:01:34.517' AS DateTime), N'{"success":false,"error":"The Project is closed you cannot add new respondents."}', CAST(N'2015-09-16 15:01:34.670' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (78, N'{"success":false,"error":"Incidence should be greater than zero."}', CAST(N'2015-09-16 15:02:41.800' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (79, N'{"name":"SCH TEST SURVEY 7","loi":"10","incidence":"10","surveylink":"http://paradigmsample.com?id=","emailsubject":"TEST PARADIGM SURVEY4","referencecode":"100","surveytopic":"test paradigm sch tes3"}', CAST(N'2015-09-16 15:02:56.890' AS DateTime), N'{"projectid":37,"success":true}', CAST(N'2015-09-16 15:02:57.030' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (80, N'{"projectid":"1","reqn":"92","specialty":"3","querycondition":[{"datapointid":"3","datapointoptions":["1","5","7"]}],"exclusions":[]}', CAST(N'2015-09-17 15:33:39.823' AS DateTime), N'{"success":true,"queryid":26,"projectid":1,"feasibility":0}', CAST(N'2015-09-17 15:35:49.580' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (81, N'{"projectid":"1","reqn":"92","specialty":"3","querycondition":[{"datapointid":"3","datapointoptions":["1","5","7"]}],"exclusions":[]}', CAST(N'2015-09-17 15:36:00.480' AS DateTime), N'{"success":true,"queryid":27,"projectid":1,"feasibility":0}', CAST(N'2015-09-17 15:39:54.707' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (82, N'{"projectid":"1","reqn":"92","specialty":"3","querycondition":[],"exclusions":[]}', CAST(N'2015-09-18 11:32:19.080' AS DateTime), N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-09-18 11:34:25.070' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (83, N'{"projectid":"1","reqn":"92","specialty":"3","querycondition":[],"exclusions":[]}', CAST(N'2015-09-18 11:34:23.620' AS DateTime), N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-09-18 11:34:26.757' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (84, N'{"projectid":"1","reqn":"92","specialty":"3","querycondition":[],"exclusions":["1"]}', CAST(N'2015-09-18 11:34:57.163' AS DateTime), N'{"success":true,"queryid":30,"projectid":1,"feasibility":29}', CAST(N'2015-09-18 11:35:00.200' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (85, N'{"success":false,"error":"Project Id cannot be empty"}', CAST(N'2015-09-18 12:15:24.013' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (86, N'{"success":false,"error":"Query condition cannot be empty."}', CAST(N'2015-09-18 12:15:49.360' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (87, N'{"success":false,"error":"Speciality cannot be empty."}', CAST(N'2015-09-18 12:15:59.397' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (88, N'{"success":false,"error":"Project Id cannot be empty"}', CAST(N'2015-09-18 12:20:52.197' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (89, N'{"success":false,"error":"Project Id cannot be null or zero"}', CAST(N'2015-09-18 12:32:30.747' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (90, N'{"success":false,"error":"Speciality cannot be null or zero."}', CAST(N'2015-09-18 12:32:46.140' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (91, N'{"projectid":"1","reqn":"92","specialty":"3","querycondition":[{"datapointid":"3","datapointoptions":["1","5","7"]}],"exclusions":[]}', CAST(N'2015-09-18 12:33:17.797' AS DateTime), N'{"success":true,"queryid":31,"projectid":1,"feasibility":0}', CAST(N'2015-09-18 12:33:17.887' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (92, N'{"success":false,"error":"Query condition cannot be empty."}', CAST(N'2015-09-18 12:38:04.673' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (93, N'{"success":false,"error":"Query condition cannot be empty."}', CAST(N'2015-09-18 12:38:32.287' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (94, N'{"projectid":"1","reqn":"92","specialty":"3","querycondition":[{"datapointid":"3","datapointoptions":["1","5","7"]}],"exclusions":[]}', CAST(N'2015-09-18 12:38:58.990' AS DateTime), N'{"success":true,"queryid":32,"projectid":1,"feasibility":0}', CAST(N'2015-09-18 12:38:59.073' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (95, N'1', CAST(N'2015-10-06 11:00:47.710' AS DateTime), N'{"success":true,"queryid":1}', CAST(N'2015-10-06 11:01:01.813' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (96, N'{"success":false,"error":"Invalid Data."}', CAST(N'2015-10-15 11:38:39.383' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (97, N'{"success":false,"error":"Invalid Data."}', CAST(N'2015-10-15 11:40:50.997' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (98, N'{"success":false,"error":"Speciality cannot be null or zero."}', CAST(N'2015-10-15 11:41:36.940' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (99, N'{"projectid":"1","reqn":"92","specialty":"3","querycondition":[{"datapointid":"8","datapointoptions":["1","5","7"]}],"exclusions":[]}', CAST(N'2015-10-15 11:42:04.283' AS DateTime), N'{"success":true,"queryid":33,"projectid":1,"feasibility":0}', CAST(N'2015-10-15 11:42:04.420' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (100, N'{"success":false,"error":"Speciality cannot be null or zero."}', CAST(N'2015-10-15 11:42:48.270' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (101, N'{"success":false,"error":"Speciality cannot be null or zero."}', CAST(N'2015-10-15 11:57:32.560' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (102, N'{"success":false,"error":"Specialty should not allow multiple values."}', CAST(N'2015-10-15 12:00:33.460' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (103, N'{"projectid":"1","reqn":"92","specialty":"3","querycondition":[{"datapointid":"8","datapointoptions":["1"]}],"exclusions":[]}', CAST(N'2015-10-15 12:03:06.057' AS DateTime), N'{"success":true,"queryid":34,"projectid":1,"feasibility":0}', CAST(N'2015-10-15 12:03:45.950' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (104, N'{"projectid":"1","reqn":"92","specialty":"3","querycondition":[{"datapointid":"8","datapointoptions":["10"]}],"exclusions":[]}', CAST(N'2015-10-15 12:13:38.943' AS DateTime), N'{"success":true,"queryid":35,"projectid":1,"feasibility":0}', CAST(N'2015-10-15 12:13:40.660' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (105, N'{"projectid":"1","reqn":"92","specialty":"3","querycondition":[{"datapointid":"8","datapointoptions":["15"]}],"exclusions":[]}', CAST(N'2015-10-15 12:14:55.837' AS DateTime), N'{"success":true,"queryid":36,"projectid":1,"feasibility":0}', CAST(N'2015-10-15 12:14:56.507' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (106, N'{"projectid":"1","reqn":"92","specialty":"3","querycondition":[{"datapointid":"8","datapointoptions":["15"]}],"exclusions":[]}', CAST(N'2015-10-16 10:35:49.470' AS DateTime), N'{"success":true,"queryid":37,"projectid":1,"feasibility":0}', CAST(N'2015-10-16 10:35:49.577' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (107, N'{"success":false,"error":"Specialty cannot be null or zero."}', CAST(N'2015-10-16 15:11:13.473' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (108, N'{"success":false,"error":"Specialty should not allow multiple values."}', CAST(N'2015-10-16 15:12:09.483' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (109, N'{"projectid":"1","reqn":"92","specialty":"3","querycondition":[{"datapointid":"8","datapointoptions":["1"]},{"datapointid":"9","datapointoptions":["1","2","3"]}],"exclusions":[]}', CAST(N'2015-10-16 15:14:29.390' AS DateTime), N'{"success":true,"queryid":38,"projectid":1,"feasibility":0}', CAST(N'2015-10-16 15:14:30.510' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (110, N'{"success":false,"error":"Specialty should not allow multiple values."}', CAST(N'2015-10-16 15:14:40.430' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (111, N'{"success":false,"error":"Specialty cannot be null or zero."}', CAST(N'2015-10-16 15:14:54.560' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (112, N'{"projectid":"1","reqn":"92","specialty":"3","querycondition":[{"datapointid":"8","datapointoptions":["1"]}],"exclusions":[]}', CAST(N'2015-10-21 15:22:54.770' AS DateTime), N'{"success":true,"queryid":39,"projectid":1,"feasibility":0}', CAST(N'2015-10-21 15:22:54.960' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (113, N'{"projectid":"1","reqn":"92","specialty":"3","querycondition":[{"datapointid":"8","datapointoptions":["1"]}],"exclusions":[]}', CAST(N'2015-10-21 15:22:57.847' AS DateTime), N'{"success":true,"queryid":40,"projectid":1,"feasibility":0}', CAST(N'2015-10-21 15:22:57.907' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (114, N'{"success":false,"error":"Authentication Failed."}', CAST(N'2015-12-30 18:08:00.817' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (115, N'', CAST(N'2015-12-30 18:28:55.737' AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[RequestLog] OFF
GO
SET IDENTITY_INSERT [dbo].[RespondentList] ON 

GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (2, N'K_3khi7x008b', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3165, 1, 1, CAST(N'2015-08-15 15:15:53.127' AS DateTime))
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (3, N'K_38e05d84cf', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3165, 1, 1, CAST(N'2015-08-15 15:02:06.350' AS DateTime))
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (4, N'K_f6071f3039', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3165, 1, 1, CAST(N'2015-08-15 15:02:06.350' AS DateTime))
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (5, N'K_5e45292d67', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3165, 1, 1, CAST(N'2015-08-15 15:02:06.350' AS DateTime))
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (6, N'K_b637bc1fb1', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3165, 1, 1, CAST(N'2015-08-15 15:02:06.350' AS DateTime))
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (7, N'K_dfe17d50a3', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3165, 1, 1, CAST(N'2015-08-15 15:02:06.350' AS DateTime))
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (8, N'K_9727932589', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3165, 1, 1, CAST(N'2015-08-15 15:02:06.350' AS DateTime))
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (9, N'K_0afe639394', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3165, 1, 1, CAST(N'2015-08-15 15:02:06.350' AS DateTime))
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (10, N'K_6cf91a96d3', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3165, 1, 1, CAST(N'2015-08-15 15:02:06.350' AS DateTime))
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (11, N'K_578fd1ffcc', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3165, 1, 1, CAST(N'2015-08-15 15:02:06.350' AS DateTime))
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (12, N'K_9ff86a730e', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3165, 1, 1, CAST(N'2015-08-15 16:19:32.393' AS DateTime))
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (13, N'K_rsldyr3tme', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3165, 1, 1, CAST(N'2015-08-15 17:45:44.757' AS DateTime))
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (14, N'abc', 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 15, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (15, N'K_df6994cc1e', 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 15, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (23, N'K_df6994cc1e', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19, 1, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (25, N'K_df6994cc1e', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 25, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (26, N'abc', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (27, N'K_001c6f699a', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (28, N'K_001c6f699a', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (29, N'K_001c6f699a', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (30, N'K_001c6f699a', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (31, N'K_001c6f699a', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (32, N'K_0011894c0c', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (33, N'K_0011894c0c', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (34, N'K_0011894c0c', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (35, N'K_0011894c0c', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (36, N'K_0011894c0c', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (37, N'K_0011894c0c', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (38, N'K_0011894c0c', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (39, N'K_cd964071ca', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (40, N'K_cd964071ca', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (41, N'K_cd964071ca', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (42, N'K_cd964071ca', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (43, N'K_cd964071ca', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (44, N'K_cd964071ca', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (45, N'K_2b46b67a62', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (46, N'K_2b46b67a62', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (47, N'K_2b46b67a62', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (48, N'K_2b46b67a62', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (49, N'K_2b46b67a62', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (50, N'K_2b46b67a62', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (51, N'K_bf87639a49', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (52, N'K_bf87639a49', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (53, N'K_bf87639a49', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (54, N'K_bf87639a49', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (55, N'K_bf87639a49', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (56, N'K_bf87639a49', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (57, N'K_bf87639a49', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (58, N'K_bf87639a49', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (59, N'K_bf87639a49', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (60, N'K_bf87639a49', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (61, N'K_8d998b0953', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (62, N'K_8d998b0953', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (63, N'K_8d998b0953', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (64, N'K_8d998b0953', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (65, N'K_8d998b0953', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (66, N'K_8d998b0953', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (67, N'K_8d998b0953', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (68, N'K_090a8e248a', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (69, N'K_090a8e248a', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (70, N'K_090a8e248a', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (71, N'K_090a8e248a', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (72, N'K_090a8e248a', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (73, N'K_79d053efe9', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (74, N'K_79d053efe9', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (75, N'K_79d053efe9', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (76, N'K_79d053efe9', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (77, N'K_79d053efe9', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (78, N'K_79d053efe9', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (79, N'K_79d053efe9', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (80, N'K_79d053efe9', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (81, N'K_2a0c1e7cce', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (82, N'K_2a0c1e7cce', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (83, N'K_2a0c1e7cce', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (84, N'K_2a0c1e7cce', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (85, N'K_2a0c1e7cce', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (86, N'K_2a0c1e7cce', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (87, N'K_2a0c1e7cce', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (88, N'K_2a0c1e7cce', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (89, N'K_2a0c1e7cce', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (90, N'K_95bb44084f', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (91, N'K_95bb44084f', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (92, N'K_95bb44084f', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (93, N'K_95bb44084f', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (94, N'K_95bb44084f', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (95, N'K_95bb44084f', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (96, N'K_95bb44084f', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (97, N'K_f6c521fa93', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (98, N'K_f6c521fa93', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (99, N'K_f6c521fa93', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (100, N'K_f6c521fa93', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (101, N'K_f6c521fa93', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (102, N'K_f6c521fa93', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (103, N'K_f6c521fa93', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (104, N'K_409f769e16', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (105, N'K_409f769e16', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (106, N'K_409f769e16', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (107, N'K_409f769e16', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (108, N'K_409f769e16', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (109, N'K_409f769e16', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (110, N'K_409f769e16', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (111, N'K_409f769e16', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (112, N'K_f2deb0970d', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (113, N'K_f2deb0970d', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (114, N'K_f2deb0970d', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (115, N'K_f2deb0970d', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (116, N'K_f2deb0970d', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (117, N'K_f2deb0970d', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (118, N'K_f2deb0970d', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (119, N'K_f2deb0970d', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (120, N'K_f2deb0970d', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (121, N'K_7ef4fd49ce', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (122, N'K_7ef4fd49ce', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (123, N'K_7ef4fd49ce', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (124, N'K_7ef4fd49ce', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (125, N'K_7ef4fd49ce', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (126, N'K_a10da422b6', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (127, N'K_a10da422b6', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (128, N'K_a10da422b6', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (129, N'K_a10da422b6', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (130, N'K_a10da422b6', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (131, N'K_a10da422b6', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (132, N'K_a10da422b6', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (133, N'K_4ce5622068', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (134, N'K_4ce5622068', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (135, N'K_4ce5622068', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (136, N'K_4ce5622068', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (137, N'K_4ce5622068', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (138, N'K_4ce5622068', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (139, N'K_83d63d6182', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (140, N'K_83d63d6182', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (141, N'K_83d63d6182', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (142, N'K_83d63d6182', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (143, N'K_83d63d6182', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (144, N'K_83d63d6182', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (145, N'K_83d63d6182', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (146, N'K_83d63d6182', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (147, N'K_48e8993269', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (148, N'K_48e8993269', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (149, N'K_48e8993269', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (150, N'K_48e8993269', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (151, N'K_48e8993269', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (152, N'K_48e8993269', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (153, N'K_48e8993269', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (154, N'K_7b82b67b34', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (155, N'K_7b82b67b34', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (156, N'K_7b82b67b34', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (157, N'K_7b82b67b34', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (158, N'K_7b82b67b34', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (159, N'K_7b82b67b34', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (160, N'K_ac0d9c8d23', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (161, N'K_ac0d9c8d23', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (162, N'K_ac0d9c8d23', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (163, N'K_ac0d9c8d23', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (164, N'K_ac0d9c8d23', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (165, N'K_ac0d9c8d23', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (166, N'K_ac0d9c8d23', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (167, N'K_ac0d9c8d23', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (168, N'K_ac0d9c8d23', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (169, N'K_rreoggymvc', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (170, N'K_rreoggymvc', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (171, N'K_rreoggymvc', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (172, N'K_rreoggymvc', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (173, N'K_rreoggymvc', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate]) VALUES (174, N'K_rreoggymvc', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, NULL)
GO
SET IDENTITY_INSERT [dbo].[RespondentList] OFF
GO
SET IDENTITY_INSERT [dbo].[Reward] ON 

GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (1, 1, N'0-10', N'101-9999999', N'10')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (2, 1, N'0-10', N'51-100', N'10')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (3, 1, N'0-10', N'21-50', N'10')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (4, 1, N'0-10', N'1-20', N'10')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (5, 1, N'11-20', N'101-9999999', N'20')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (6, 1, N'11-20', N'51-100', N'25')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (7, 1, N'11-20', N'21-50', N'35')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (8, 1, N'11-20', N'1-20', N'45')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (9, 1, N'21-30', N'101-9999999', N'30')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (10, 1, N'21-30', N'51-100', N'50')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (11, 1, N'21-30', N'21-50', N'60')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (12, 1, N'21-30', N'1-20', N'75')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (13, 2, N'0-10', N'101-9999999', N'10')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (14, 2, N'0-10', N'51-100', N'10')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (15, 2, N'0-10', N'21-50', N'10')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (16, 2, N'0-10', N'1-20', N'10')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (17, 2, N'11-20', N'101-9999999', N'20')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (18, 2, N'11-20', N'51-100', N'25')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (19, 2, N'11-20', N'21-50', N'55')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (20, 2, N'11-20', N'1-20', N'70')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (21, 2, N'21-30', N'101-9999999', N'35')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (22, 2, N'21-30', N'51-100', N'50')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (23, 2, N'21-30', N'21-50', N'60')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (24, 2, N'21-30', N'1-20', N'75')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (25, 3, N'0-10', N'101-9999999', N'10')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (26, 3, N'0-10', N'51-100', N'10')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (27, 3, N'0-10', N'21-50', N'10')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (28, 3, N'0-10', N'1-20', N'10')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (29, 3, N'11-20', N'101-9999999', N'25')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (30, 3, N'11-20', N'51-100', N'40')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (31, 3, N'11-20', N'21-50', N'50')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (32, 3, N'11-20', N'1-20', N'75')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (33, 3, N'21-30', N'101-9999999', N'40')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (34, 3, N'21-30', N'51-100', N'50')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (35, 3, N'21-30', N'21-50', N'75')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (36, 3, N'21-30', N'1-20', N'85')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (37, 4, N'0-10', N'101-9999999', N'10')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (38, 4, N'0-10', N'51-100', N'10')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (39, 4, N'0-10', N'21-50', N'10')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (40, 4, N'0-10', N'1-20', N'10')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (41, 4, N'11-20', N'101-9999999', N'35')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (42, 4, N'11-20', N'51-100', N'40')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (43, 4, N'11-20', N'21-50', N'85')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (44, 4, N'11-20', N'1-20', N'100')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (45, 4, N'21-30', N'101-9999999', N'60')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (46, 4, N'21-30', N'51-100', N'75')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (47, 4, N'21-30', N'21-50', N'100')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (48, 4, N'21-30', N'1-20', N'115')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (49, 5, N'0-10', N'101-9999999', N'10')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (50, 5, N'0-10', N'51-100', N'10')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (51, 5, N'0-10', N'21-50', N'10')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (52, 5, N'0-10', N'1-20', N'10')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (53, 5, N'11-20', N'101-9999999', N'60')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (54, 5, N'11-20', N'51-100', N'70')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (55, 5, N'11-20', N'21-50', N'75')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (56, 5, N'11-20', N'1-20', N'85')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (57, 5, N'21-30', N'101-9999999', N'85')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (58, 5, N'21-30', N'51-100', N'100')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (59, 5, N'21-30', N'21-50', N'115')
GO
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [Reward]) VALUES (60, 5, N'21-30', N'1-20', N'135')
GO
SET IDENTITY_INSERT [dbo].[Reward] OFF
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_22cd23fc1a', 7, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'79a9ddded41559f716a69349f389c58b', N'NULL', 1, 24, CAST(N'2015-07-21 15:23:20.000' AS DateTime))
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_38e05d84cf', 7, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'e807125cea7ef6b52f3fba27b624aeb1', N'NULL', 1, 24, CAST(N'2015-07-21 15:04:02.000' AS DateTime))
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_f6071f3039', 7, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'790a67a0e21aff21233f12de23dbde46', N'NULL', 1, 24, CAST(N'2015-07-21 15:04:02.000' AS DateTime))
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_5e45292d67', 7, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'299d3a34ee9e0f7ad19f49406b032562', N'NULL', 1, 24, CAST(N'2015-07-21 15:04:02.000' AS DateTime))
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_b637bc1fb1', 7, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'e54082bb1401a574d404c2a55032f222', N'NULL', 1, 24, CAST(N'2015-07-21 15:04:02.000' AS DateTime))
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_dfe17d50a3', 7, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'dc5fe2827619d4828992d81b6022bdea', N'NULL', 1, 24, CAST(N'2015-07-21 15:04:02.000' AS DateTime))
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_9727932589', 7, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'40e44e5ae738290b0fd26636f8ff805a', N'NULL', 1, 24, CAST(N'2015-07-21 15:04:02.000' AS DateTime))
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_0afe639394', 7, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'829721f10a97276ac7a00e754ae44680', N'NULL', 1, 24, CAST(N'2015-07-21 15:04:02.000' AS DateTime))
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_6cf91a96d3', 7, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'473b29e69aadc5cc61e8758bd6153a4e', N'NULL', 1, 24, CAST(N'2015-07-21 15:04:02.000' AS DateTime))
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_578fd1ffcc', 7, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'52de9b0ae600bc9161cf34349bae4858', N'NULL', 1, 24, CAST(N'2015-07-21 15:04:02.000' AS DateTime))
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_2855d55cf7', 7, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'9caa620bf22a1dbc034b146c0cf11865', N'NULL', 1, 24, CAST(N'2015-07-21 15:04:02.000' AS DateTime))
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_0c6e78fef7', 7, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'6a6253b053bc04124a556ad9bc2aec88', N'NULL', 1, 24, CAST(N'2015-07-21 15:04:02.000' AS DateTime))
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_7e537027ff', 7, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'29f21bc289745e711b4e0b95f8f34e1f', N'NULL', 1, 24, CAST(N'2015-07-21 15:04:02.000' AS DateTime))
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_90c19c859a', 7, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'8a41cc148787018775bbb10ce2d384ee', N'NULL', 1, 24, CAST(N'2015-07-21 15:04:02.000' AS DateTime))
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_df6994cc1e', 7, N'g10giuo5vqd01kwc', N'1', N'127.0.0.1', N'13:37.2', N'18:28.3', N'127.0.0.1', N'db8552e50ba0989a07bddc6ee2d5fd85', N'NULL', 1, 24, CAST(N'2015-07-21 15:04:02.000' AS DateTime))
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_22cd23fc1a', 8, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'13d2ff3591d4eb0371a72e27d55c0c58', N'NULL', 1, 29, NULL)
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_38e05d84cf', 8, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'0ac737a081492b61082a71a53678ecc6', N'NULL', 1, 29, NULL)
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_f6071f3039', 8, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'c451577aa544c5cf2faca1be82e7e94f', N'NULL', 1, 29, NULL)
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_5e45292d67', 8, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'75f54a219f24de0f5b90811bea17332c', N'NULL', 1, 29, NULL)
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_b637bc1fb1', 8, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'fc29051fe2808fa581ba65eda7bac8bd', N'NULL', 1, 29, NULL)
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_dfe17d50a3', 8, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'6b7b276707b55ee9318198b9e75e1c59', N'NULL', 1, 29, NULL)
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_9727932589', 8, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'68c4f5c18dddd73c6d80a8418a535f0c', N'NULL', 1, 29, NULL)
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_0afe639394', 8, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'be445be0fb5be30416512a22a9bf61aa', N'NULL', 1, 29, NULL)
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_6cf91a96d3', 8, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'e8455c5236f6476e6189f0c5130e3bc7', N'NULL', 1, 29, NULL)
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_578fd1ffcc', 8, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'57013001f10ea472c8650c2b8f5ddb2a', N'NULL', 1, 29, NULL)
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_2855d55cf7', 8, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'd427f0d995a9aebc074a9b229bafcc52', N'NULL', 1, 29, NULL)
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_0c6e78fef7', 8, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'63744048e4bdd663d82a022025bf248f', N'NULL', 1, 29, NULL)
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_7e537027ff', 8, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'cc28a3df073780650912a9784d58842c', N'NULL', 1, 29, NULL)
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_90c19c859a', 8, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'3a0c09ab94ba6a6bb455bfa2fe71cffc', N'NULL', 1, 29, NULL)
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_df6994cc1e', 8, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'0b3c2e14797cfc279542e6c0494b06b7', N'NULL', 1, 29, NULL)
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_22cd23fc1a', 9, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'145a8449f8ca78cb98ce3075da587f29', N'NULL', 1, 30, CAST(N'2015-07-21 19:17:52.000' AS DateTime))
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_38e05d84cf', 9, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'66bdda0752246d433f6e7b2f2fbd19e2', N'NULL', 1, 30, CAST(N'2015-07-21 19:17:52.000' AS DateTime))
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_f6071f3039', 9, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'413eacff8d5112c34ce52b8da61189ff', N'NULL', 1, 30, CAST(N'2015-07-21 19:17:52.000' AS DateTime))
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_5e45292d67', 9, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'8df6a089d9c7a3482aed80ace1b7fbf4', N'NULL', 1, 30, CAST(N'2015-07-21 19:17:52.000' AS DateTime))
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_b637bc1fb1', 9, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'6a46566ffa18e73ad0d904c5e8af05e8', N'NULL', 1, 30, CAST(N'2015-07-21 19:17:52.000' AS DateTime))
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_dfe17d50a3', 9, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'bbce2341b74492922422b15a0a8b15ae', N'NULL', 1, 30, CAST(N'2015-07-21 19:17:52.000' AS DateTime))
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_9727932589', 9, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'0f3cddbf60e591e9783ddfe998ccfb08', N'NULL', 1, 30, CAST(N'2015-07-21 19:17:52.000' AS DateTime))
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_0afe639394', 9, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'a42929b6a48f25da63ac2178b81b266a', N'NULL', 1, 30, CAST(N'2015-07-21 19:17:52.000' AS DateTime))
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_6cf91a96d3', 9, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'e9fafa0cb754522c43ba1b532abf696e', N'NULL', 1, 30, CAST(N'2015-07-21 19:17:52.000' AS DateTime))
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_578fd1ffcc', 9, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'3b769a65b5397cefade4dfb3b6f2c02e', N'NULL', 1, 30, CAST(N'2015-07-21 19:17:52.000' AS DateTime))
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_2855d55cf7', 9, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'275e5679d49c4b18b1a8467e07086b47', N'NULL', 1, 30, CAST(N'2015-07-21 19:17:52.000' AS DateTime))
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_0c6e78fef7', 9, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'163beec29e76156124a44257c9d4b7c1', N'NULL', 1, 30, CAST(N'2015-07-21 19:17:52.000' AS DateTime))
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_7e537027ff', 9, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'c2ea049befe575956b36129b824eb747', N'NULL', 1, 30, CAST(N'2015-07-21 19:17:52.000' AS DateTime))
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_90c19c859a', 9, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'd9f994029b15fdaedb582699d5e7f096', N'NULL', 1, 30, CAST(N'2015-07-21 19:17:52.000' AS DateTime))
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'K_df6994cc1e', 9, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'99a8315f654b60a873a98be81da3dbf1', N'NULL', 1, 30, CAST(N'2015-07-21 19:23:46.000' AS DateTime))
GO
INSERT [dbo].[Sheet1$] ([F1], [F2], [F3], [F4], [F5], [F6], [F7], [F8], [F9], [F10], [F11], [F12], [F13]) VALUES (N'NULL', NULL, N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', N'NULL', NULL, NULL, NULL)
GO
INSERT [dbo].[SpecialityGroup] ([SpecialityId], [SpecialityName], [SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (1, N'Test1', 1, N'Test1', 2)
GO
INSERT [dbo].[SpecialityGroup] ([SpecialityId], [SpecialityName], [SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (2, N'Test2', 3, N'Test2', 3)
GO
ALTER TABLE [dbo].[SurveyLog] ADD  CONSTRAINT [DF_SurveyLog_LogDate]  DEFAULT (getdate()) FOR [LogDate]
GO
/****** Object:  StoredProcedure [dbo].[ChangeProjectStatus]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Experion
-- Create date: 30 June 2015
-- Description:	update Project status
-- =============================================
CREATE PROCEDURE [dbo].[ChangeProjectStatus]
	@ProjectId INT=NULL,
	@StatusId INT=NULL
AS
BEGIN
	DECLARE @CurrentStatus INT
	SET @CurrentStatus = (SELECT status FROM Project WHERE ProjectId = @ProjectId)
	
	IF ((@CurrentStatus = 2 AND @StatusId = 1) OR(@CurrentStatus = 2 AND @StatusId = 3) OR (@CurrentStatus = 1 AND @StatusId = 3) OR (@CurrentStatus = 3 AND @StatusId = 1) AND @CurrentStatus != 4)
	BEGIN
		UPDATE 
		Project
		SET 
		Status = @StatusId,
		ActiveDate=
			(
			CASE @StatusId
				WHEN 1 THEN Getdate()
				ELSE ActiveDate
			END
			),
		InactiveDate=
		(
			CASE @StatusId
				WHEN 3 THEN GETDATE()
				ELSE InactiveDate
			END
		)	
			
		WHERE ProjectId=@ProjectId
		SELECT @ProjectId
	END
	ELSE
	BEGIN
		SELECT @CurrentStatus,@StatusId
	END
END

GO
/****** Object:  StoredProcedure [dbo].[DeleteQuery]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteQuery]
	-- Add the parameters for the stored procedure here
	@QueryId INT = NULL
AS
BEGIN
DECLARE @Status int
SET @Status = (SELECT Status FROM Project p INNER JOIN QueryMaster q on q.ProjectId = p.ProjectId WHERE q.QueryId=@QueryId )
IF @Status = 2 
BEGIN
	DELETE FROM RespondentList WHERE QueryId = @QueryId
	DELETE FROM QueryMaster WHERE QueryId = @QueryId
	SELECT 'true'
END
ELSE
BEGIN
	SELECT 'false'
END
END

GO
/****** Object:  StoredProcedure [dbo].[GetNewProjectRequests]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetNewProjectRequests] 
	
AS
BEGIN



	SELECT DISTINCT
		ProjectId,
		SurveyURL,
		KinesisProjectName,
		KinesisIdentifier,
		ISNULL(KinesisProjectId,0) as KinesisProjectId,
		RespondentListId,
		PanelId,
		EmailSubject,
		EmailTemplate,
		LOI,
		Reward,
		QueryBatch,
		ReferenceCode,
	    SurveyTopic,
	    RewardPoints,
	    QueryId AS QueryId
	FROM (
		SELECT  
		p.ProjectId,
		'https://ss.opinionsite.com/pages/Survey.aspx?identifier=[IDENTIFIER]%26sesskey=[sesskey]%26prid=' + CONVERT(VARCHAR,p.ProjectId) AS SurveyURL, 
		'SCH API -'+ ProjectName + CONVERT(VARCHAR,p.ProjectId)  AS KinesisProjectName,
		RespondentId AS KinesisIdentifier,
		p.KinesisProjectId,
		RespondentListId,
		rl.panelId as PanelId,
		dense_rank() over ( order by rl.QueryId) AS QueryBatch,
		EmailSubject,
		'Invitation-'+CONVERT(VARCHAR,rl.PanelId)+'.htm' AS EmailTemplate,
		p.LOI,
	    Reward,
	    Reward AS RewardPoints,
	    ReferenceCode,
	    SurveyTopic,
	    q.QueryId AS QueryId
		FROM Project p	
		INNER JOIN QueryMaster q ON q.ProjectId = p.ProjectId
		INNER JOIN RespondentList rl ON rl.QueryId = q.QueryId
		WHERE 
	((rl.KinesisProjectId IS NULL OR rl.KinesisProjectId = 0 ) AND P.Status=1 AND ISNULL(ErrorRetryCount,0) < 5) 
			
	) p
	WHERE QueryBatch = 1 
	
	
----Close Kinesis Project
	SELECT  DISTINCT top 25 
	KinesisProjectId,Panelld as PanelId,ProjectId
	FROM 
	Project
	WHERE 
	Status = 4 AND KinesisCloseStatus IS NULL AND KinesisProjectId IS NOT NULL
	
----Send Reminder

		SELECT  
		p.ProjectId,
		EmailSubject,
		p.LOI,
	    Reward,
	    Reward * 10 AS RewardPoints,
	    ReferenceCode,
	    SurveyTopic,
	    q.QueryId AS QueryId,
	    CampaignId,
	    p.KinesisProjectId,
	    SampleId
		FROM 
		Project p	
		INNER JOIN QueryMaster q ON q.ProjectId = p.ProjectId
		WHERE 
		SendReminder = 1
		AND 
		ReminderSentStatus IS NULL 
		AND
		KinesisReminderSentDate IS NULL
		AND 
		Status = 1 AND CampaignId IS NOT NULL AND ISNULL(KinesisReminderErrorCount,0) < 5
		
	
END

GO
/****** Object:  StoredProcedure [dbo].[GetProjectSearchDetails]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetProjectSearchDetails] 
	@DateFrom datetime = null, 
	@DateTo datetime = null,
	@StatusId int = null
	
AS
BEGIN
	
	SET  @DateTo = DATEADD(dd, 1, @DateTo)

	SELECT 
	SUM(TotalRespondents) AS RespondentsCount
	,SUM(ISNULL(Completes,0))as CompletesCount
	FROM dbo.Project p
	LEFT OUTER JOIN
	(
		SELECT pj.ProjectId,Count(RespondentListId) AS TotalRespondents 
		FROM  dbo.RespondentList rl
		INNER JOIN Project pj on pj.ProjectId = rl.ProjectId 
		Group by pj.ProjectId
	  
	 ) rlt 
	ON rlt.ProjectId = p.ProjectId
	LEFT OUTER JOIN 
	(
	 SELECT pj.ProjectId,Count(RespondentListId) AS Completes  
	 FROM  dbo.RespondentList rl
	 INNER JOIN Project pj on pj.ProjectId = rl.ProjectId 
	 WHERE
	 SurveyStatus = 1
	 Group by pj.ProjectId
	 ) 
	cmt ON cmt.ProjectId = p.ProjectId
	
	WHERE
	(
	(@DateFrom IS NULL AND @DateFrom IS NULL)
	OR 
	(@DateTo IS NULL AND CreateDate >= @DateFrom)
	OR  
	(@DateFrom IS NULL AND CreateDate < @DateTo)
	OR 
	(CreateDate BETWEEN @DateFrom AND @DateTo)
	AND
	(
	@StatusId IS NULL OR Status = @StatusId
	)
	)
	
	SELECT 
	p.projectId AS [ProjectId]
	,'SCH API -'+ ProjectName + CONVERT(VARCHAR,p.ProjectId)   AS [Kinesis Project Name]
	,TotalRespondents AS [Total Respondents]
	,KinesisProjectId AS [Kinesis Project Id]
	,LOI AS [Length of the Survey]
	,Completes AS [Completes Count]
	,Quota AS [Quota Count]
	,Terminates AS [Terminate Count]
	,TotalClicks AS [Total Clicks]
	,CreateDate AS [Create Date]
	,CASE Status WHEN 1 THEN 'Active'
	WHEN 2 THEN 'Draft' 
	WHEN 3 THEN 'Inactive'
	ELSE 'Closed' END AS [Project Status]
	,p.Incidence,InactiveDate

	
	FROM dbo.Project p
	LEFT OUTER JOIN
	(
		SELECT rl.ProjectId,Count(RespondentListId) AS TotalRespondents 
		FROM  dbo.RespondentList rl
		Group by rl.ProjectId
	  
	 ) rlt 
	ON rlt.ProjectId = p.ProjectId
	LEFT OUTER JOIN 
	(
	 SELECT ProjectId,Count(RespondentListId) AS Completes  
	 FROM  dbo.RespondentList rl
	 WHERE
	 SurveyStatus = 1
	Group by ProjectId
	 ) 
	cmt ON cmt.ProjectId = p.ProjectId
	LEFT OUTER JOIN 
	(
	 SELECT ProjectId,Count(RespondentListId) AS Quota  
	 FROM  dbo.RespondentList rl
	 WHERE
	 SurveyStatus = 3
	Group by ProjectId
	 ) 
	quota ON quota.ProjectId = p.ProjectId
	LEFT OUTER JOIN 
	(
	 SELECT ProjectId,Count(RespondentListId) AS Terminates  
	 FROM  dbo.RespondentList rl
	 WHERE
	 SurveyStatus = 2
	Group by ProjectId
	 ) 
	terminate ON terminate.ProjectId = p.ProjectId
	LEFT OUTER JOIN 
	(
	 SELECT ProjectId,Count(RespondentListId) AS [TotalClicks]  
	 FROM  dbo.RespondentList rl
	 WHERE
	 Sesskey IS NOT NULL
	Group by ProjectId
	 ) 
	click ON click.ProjectId = p.ProjectId
	WHERE
	(
	(@DateFrom IS NULL AND @DateFrom IS NULL)
	OR 
	(@DateTo IS NULL AND CreateDate >= @DateFrom)
	OR  
	(@DateFrom IS NULL AND CreateDate < @DateTo)
	OR 
	(CreateDate BETWEEN @DateFrom AND @DateTo)
	AND
	(
	@StatusId IS NULL OR Status = @StatusId
	)
	)
	
	SELECT 
	p.projectId AS [ProjectId]
	,q.QueryId
	,TotalRespondents AS [Total Respondents]
	,Completes AS [Completes Count]
	,Quota AS [Quota Count]
	,Terminates AS [Terminate Count]
	,TotalClicks AS [Total Clicks]
	,q.CreateDate AS [Create Date]	
	,sg.SpecialityOptionName as SpecialityOptionName
	,sg.SpecialityOptionId as SpecialityId
	,q.SampleRatio
	,q.CompleteGroup
	,q.ReqN
	
	FROM dbo.QueryMaster q
	INNER JOIN Project p ON p.ProjectId = q.ProjectId
	LEFT OUTER JOIN
	(
		SELECT rl.QueryId,rl.projectId,Count(RespondentListId) AS TotalRespondents 
		FROM  dbo.RespondentList rl		
		Group by rl.QueryId,rl.ProjectId	  
	 ) rlt 
	ON rlt.QueryId = q.QueryId
	LEFT OUTER JOIN 
	(
	 SELECT QueryId,projectId,Count(RespondentListId) AS Completes  
	 FROM  dbo.RespondentList rl
	 WHERE
	 SurveyStatus = 1
	Group by QueryId,projectId
	 ) 
	cmt ON cmt.QueryId = q.QueryId
	LEFT OUTER JOIN 
	(
	 SELECT QueryId,projectId,count(RespondentListId) AS Quota  
	 FROM  dbo.RespondentList rl
	 WHERE
	 SurveyStatus = 3
	Group by QueryId,projectId
	 ) 
	quota ON quota.QueryId = q.QueryId
	LEFT OUTER JOIN 
	(
	 SELECT QueryId,projectId,Count(RespondentListId) AS Terminates  
	 FROM  dbo.RespondentList rl
	 WHERE
	 SurveyStatus = 2
	Group by QueryId,projectId
	 ) 
	terminate ON terminate.QueryId = q.QueryId
	LEFT OUTER JOIN 
	(
	 SELECT QueryId,projectId,Count(RespondentListId) AS [TotalClicks]  
	 FROM  dbo.RespondentList rl
	 WHERE
	 Sesskey IS NOT NULL
	Group by QueryId,projectId
	 ) 
	click ON click.QueryId = q.QueryId
	INNER JOIN 	dbo.SpecialityGroup sg ON sg.SpecialityOptionId = q.Speciality	
	WHERE
	(
	(@DateFrom IS NULL AND @DateFrom IS NULL)
	OR 
	(@DateTo IS NULL AND p.CreateDate >= @DateFrom)
	OR  
	(@DateFrom IS NULL AND p.CreateDate < @DateTo)
	OR 
	(p.CreateDate BETWEEN @DateFrom AND @DateTo)
	AND
	(
	@StatusId IS NULL OR p.Status = @StatusId
	)
	)
	ORDER BY QueryId

END

GO
/****** Object:  StoredProcedure [dbo].[ImportPanelistToDB]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Malu
-- Create date: 16 july 2015
-- Description:	Procedure for creating temporary table
-- =============================================
CREATE PROCEDURE [dbo].[ImportPanelistToDB]
	@Path varchar(1000),
	@PanelId int
AS
BEGIN
IF OBJECT_ID('tempdb..#PanelistTemp') IS  NULL
CREATE TABLE #PanelistTemp 
(
Identifier	nvarchar(max)   NULL,
Gender	nvarchar(max)   NULL,
City	nvarchar(max)   NULL,
State	nvarchar(max)   NULL,
PostalCode	nvarchar(max)   NULL,
Country	nvarchar(max)   NULL,
QCardiologistClass_1GeneralCardiologist	nvarchar(max)   NULL,
QCardiologistClass_2Non_InvasiveCardiologist	nvarchar(max)   NULL,
QCardiologistClass_3InvasiveNon_InterventionalCardiologist	nvarchar(max)   NULL,
QCardiologistClass_4Interventional_Cardiologist	nvarchar(max)   NULL,
QCardiologistClass_5Electrophysiologist	nvarchar(max)   NULL,
QCardiologistClass_6Pediatric_Cardiologist	nvarchar(max)   NULL,
QDoctorWorkplaceSetting	nvarchar(max)   NULL,
QHCPSpecialty_1Addiction_Medicine	nvarchar(max)   NULL,
QHCPSpecialty_2Aerospace_Medicine	nvarchar(max)   NULL,
QHCPSpecialty_3Allergist_ENT	nvarchar(max)   NULL,
QHCPSpecialty_4Anesthesiology	nvarchar(max)   NULL,
QHCPSpecialty_5Blood_Banking_Transfusion_Medicine	nvarchar(max)   NULL,
QHCPSpecialty_6Cardiology	nvarchar(max)   NULL,
QHCPSpecialty_7Cardiovascular_Diseases	nvarchar(max)   NULL,
QHCPSpecialty_8Clinical_Biochemical_Genetics	nvarchar(max)   NULL,
QHCPSpecialty_9Clinical_Pharmacology	nvarchar(max)   NULL,
QHCPSpecialty_10Dermatology	nvarchar(max)   NULL,
QHCPSpecialty_11Diabetologist	nvarchar(max)   NULL,
QHCPSpecialty_12Emergency_Medicine	nvarchar(max)   NULL,
QHCPSpecialty_13Endocrinology_Diabetes_Metabolism	nvarchar(max)   NULL,
QHCPSpecialty_14Epidemiology	nvarchar(max)   NULL,
QHCPSpecialty_15Gastroenterology	nvarchar(max)   NULL,
QHCPSpecialty_16General_Practice	nvarchar(max)   NULL,
QHCPSpecialty_17Geriatrics	nvarchar(max)   NULL,
QHCPSpecialty_18Hematology	nvarchar(max)   NULL,
QHCPSpecialty_19Hepatology	nvarchar(max)   NULL,
QHCPSpecialty_20HIV_AIDS	nvarchar(max)   NULL,
QHCPSpecialty_21Hospitalist	nvarchar(max)   NULL,
QHCPSpecialty_22Immunology	nvarchar(max)   NULL,
QHCPSpecialty_23Infectious_Disease	nvarchar(max)   NULL,
QHCPSpecialty_24Internal_Medicine	nvarchar(max)   NULL,
QHCPSpecialty_25Legal_Medicine	nvarchar(max)   NULL,
QHCPSpecialty_26Medical_Genetics	nvarchar(max)   NULL,
QHCPSpecialty_27Medical_Management	nvarchar(max)   NULL,
QHCPSpecialty_28Nephrology	nvarchar(max)   NULL,
QHCPSpecialty_29Neurology	nvarchar(max)   NULL,
QHCPSpecialty_30Neuropsychiatry	nvarchar(max)   NULL,
QHCPSpecialty_31Neurotology	nvarchar(max)   NULL,
QHCPSpecialty_32Nuclear_Medicine	nvarchar(max)   NULL,
QHCPSpecialty_33Nutrition	nvarchar(max)   NULL,
QHCPSpecialty_34Obesity	nvarchar(max)   NULL,
QHCPSpecialty_35Obstetrics_Gynecology	nvarchar(max)   NULL,
QHCPSpecialty_36Occupational_Medicine	nvarchar(max)   NULL,
QHCPSpecialty_37Oncology	nvarchar(max)   NULL,
QHCPSpecialty_38Ophthalmology	nvarchar(max)   NULL,
QHCPSpecialty_39Orthopedics	nvarchar(max)   NULL,
QHCPSpecialty_40Otolaryngology	nvarchar(max)   NULL,
QHCPSpecialty_41Otology	nvarchar(max)   NULL,
QHCPSpecialty_42Pain_Medicine	nvarchar(max)   NULL,
QHCPSpecialty_43Palliative_Medicine	nvarchar(max)   NULL,
QHCPSpecialty_44Pathology	nvarchar(max)   NULL,
QHCPSpecialty_45Pediatrics	nvarchar(max)   NULL,
QHCPSpecialty_46Physical_Medicine_Rehabilitation	nvarchar(max)   NULL,
QHCPSpecialty_47Plastic_Surgery	nvarchar(max)   NULL,
QHCPSpecialty_48Preventive_Medicine	nvarchar(max)   NULL,
QHCPSpecialty_49Proctology	nvarchar(max)   NULL,
QHCPSpecialty_50Psychiatry	nvarchar(max)   NULL,
QHCPSpecialty_51Public_Health_And_General_Preventive_Med	nvarchar(max)   NULL,
QHCPSpecialty_52Pulmonary_Medicine	nvarchar(max)   NULL,
QHCPSpecialty_53Radiology	nvarchar(max)   NULL,
QHCPSpecialty_54Reproductive_Endocrinology	nvarchar(max)   NULL,
QHCPSpecialty_55Rheumatology	nvarchar(max)   NULL,
QHCPSpecialty_56Sleep_Medicine	nvarchar(max)   NULL,
QHCPSpecialty_57Sports_Medicine	nvarchar(max)   NULL,
QHCPSpecialty_58Surgery_Surgeon	nvarchar(max)   NULL,
QHCPSpecialty_59Undersea_Medicine_Hyperbaric_Medic	nvarchar(max)   NULL,
QHCPSpecialty_60Urogynecology	nvarchar(max)   NULL,
QHCPSpecialty_61Urology	nvarchar(max)   NULL,
QHCPSpecialty_62Vascular_Medicine	nvarchar(max)   NULL,
QHCPSpecialty_63Bariatric_Medicine	nvarchar(max)   NULL,
QHCPSpecialty_64Community_Medicine	nvarchar(max)   NULL,
QHCPSpecialty_65Critical_Care_Medicine	nvarchar(max)   NULL,
QHCPSpecialty_66Medical_Scientist	nvarchar(max)   NULL,
QHCPSpecialty_67Medical_Biochemistry	nvarchar(max)   NULL,
QHCPSpecialty_68Respirology	nvarchar(max)   NULL,
QHCPSpecialty_69Movement_Disorder_Specialist	nvarchar(max)   NULL,
QHCPSpecialty_70Family_Medicine_Family_Practice	nvarchar(max)   NULL,
QHCPSpecialty_71Other_Specify	nvarchar(max)   NULL,
QHCPSpecialty_72Transplant	nvarchar(max)   NULL,
QOncologistClass_1Medical_Oncologist	nvarchar(max)   NULL,
QOncologistClass_2Hematologist_Oncologist	nvarchar(max)   NULL,
QOncologistClass_3Radiation_Oncologist	nvarchar(max)   NULL,
QOncologistClass_4Surgical_Oncologist	nvarchar(max)   NULL,
QOncologistClass_5Gynecological_Oncologist	nvarchar(max)   NULL,
QOncologistClass_6Pediatric_Oncologist	nvarchar(max)   NULL,
QPanelistType_1Physician	nvarchar(max)   NULL,
QPanelistType_2Dentist	nvarchar(max)   NULL,
QPanelistType_3Dentist_Support_Staff	nvarchar(max)   NULL,
QPanelistType_4Executive_or_Management	nvarchar(max)   NULL,
QPanelistType_5Administrative_Technician_Operations	nvarchar(max)   NULL,
QPanelistType_6Pharmacist_Pharmacy_Staff	nvarchar(max)   NULL,
QPanelistType_7Physician_Support_Staff	nvarchar(max)   NULL,
QPanelistType_8Optometrist	nvarchar(max)   NULL,
QPanelistType_9Podiatrist	nvarchar(max)   NULL,
QPanelistType_10Optician	nvarchar(max)   NULL,
QPanelistType_11Chiropractor	nvarchar(max)   NULL,
QPanelistType_12Veterinarian_Veterinary_Staff	nvarchar(max)   NULL,
QPanelistType_13Executive_or_Management	nvarchar(max)   NULL,
QPanelistType_14Therapist_Counselor	nvarchar(max)   NULL,
QPanelistType_15Nurse	nvarchar(max)   NULL,
QPediatricianClass_1Adolescent_Medicine	nvarchar(max)   NULL,
QPediatricianClass_2Developmental_Behavioral_Pediatrics	nvarchar(max)   NULL,
QPediatricianClass_3Hospice_and_Palliative_medicine	nvarchar(max)   NULL,
QPediatricianClass_4Medical_Toxicology	nvarchar(max)   NULL,
QPediatricianClass_5Neonatal_Perinatal_medicine	nvarchar(max)   NULL,
QPediatricianClass_6Neurodevelopmental_Disabilities	nvarchar(max)   NULL,
QPediatricianClass_7Pediatric_Allergist	nvarchar(max)   NULL,
QPediatricianClass_8Pediatric_Cardiology	nvarchar(max)   NULL,
QPediatricianClass_9Pediatric_Critical_Care_Medicine	nvarchar(max)   NULL,
QPediatricianClass_10Pediatric_Emergency_Medicine	nvarchar(max)   NULL,
QPediatricianClass_11Pediatric_Endocrinology	nvarchar(max)   NULL,
QPediatricianClass_12Pediatric_gastroenterology	nvarchar(max)   NULL,
QPediatricianClass_13Pediatric_Hematology_Oncology	nvarchar(max)   NULL,
QPediatricianClass_14Pediatric_Infectious_Diseases	nvarchar(max)   NULL,
QPediatricianClass_15Pediatric_Nephrology	nvarchar(max)   NULL,
QPediatricianClass_16Pediatric_Neurology	nvarchar(max)   NULL,
QPediatricianClass_17Pediatric_Ophthalmology	nvarchar(max)   NULL,
QPediatricianClass_18Pediatric_Otolaryngology	nvarchar(max)   NULL,
QPediatricianClass_19pediatric_Pulmonology	nvarchar(max)   NULL,
QPediatricianClass_20Pediatric_Radiology	nvarchar(max)   NULL,
QPediatricianClass_21Pediatric_Rheumatology	nvarchar(max)   NULL,
QPediatricianClass_22Pediatric_Sports_Medicine	nvarchar(max)   NULL,
QPediatricianClass_23Pediatric_Urology	nvarchar(max)   NULL,
QPediatricianClass_24Pediatric_Sleep_Medicine	nvarchar(max)   NULL,
QPediatricianClass_25None_of_the_above	nvarchar(max)   NULL,
QRadiologistClass_1Abdominal_Radiology	nvarchar(max)   NULL,
QRadiologistClass_2Breast_imaging	nvarchar(max)   NULL,
QRadiologistClass_3Cardiothoracic_Radiology	nvarchar(max)   NULL,
QRadiologistClass_4Cardiovascular_Radiology	nvarchar(max)   NULL,
QRadiologistClass_5Chest_Radiology	nvarchar(max)   NULL,
QRadiologistClass_6Diagnostic_Radiology	nvarchar(max)   NULL,
QRadiologistClass_7Endovascular_Surgical_Neuroradiology	nvarchar(max)   NULL,
QRadiologistClass_8Emergency_Radiology	nvarchar(max)   NULL,
QRadiologistClass_9Gastrointestinal_GI_Radiology	nvarchar(max)   NULL,
QRadiologistClass_10Genitourinary_Radiology	nvarchar(max)   NULL,
QRadiologistClass_11Head_and_Neck_Radiology	nvarchar(max)   NULL,
QRadiologistClass_12Interventional_Radiology	nvarchar(max)   NULL,
QRadiologistClass_13Musculoskeletal_Radiology	nvarchar(max)   NULL,
QRadiologistClass_14Neuroradiology	nvarchar(max)   NULL,
QRadiologistClass_15Nuclear_Radiology	nvarchar(max)   NULL,
QRadiologistClass_16Pediatric_Radiology	nvarchar(max)   NULL,
QRadiologistClass_17Radiation_Oncology	nvarchar(max)   NULL,
QRadiologistClass_18Other_Specify	nvarchar(max)   NULL,
QSupportAdminTitles_1Case_Management_Patient_Case_Management	nvarchar(max)   NULL,
QSupportAdminTitles_2Cath_Laboratory	nvarchar(max)   NULL,
QSupportAdminTitles_3Clerical_Support	nvarchar(max)   NULL,
QSupportAdminTitles_4Critical_Care_Intensive_Care	nvarchar(max)   NULL,
QSupportAdminTitles_5Discharge	nvarchar(max)   NULL,
QSupportAdminTitles_6Elderly_Care	nvarchar(max)   NULL,
QSupportAdminTitles_7Emergency_Services	nvarchar(max)   NULL,
QSupportAdminTitles_8Information_Technology	nvarchar(max)   NULL,
QSupportAdminTitles_9Materials	nvarchar(max)   NULL,
QSupportAdminTitles_10Maternity_Neonatal_Care	nvarchar(max)   NULL,
QSupportAdminTitles_11Medical_Clinical_Laboratory	nvarchar(max)   NULL,
QSupportAdminTitles_12Nuclear_Medicine_	nvarchar(max)   NULL,
QSupportAdminTitles_13Nurse_Manager	nvarchar(max)   NULL,
QSupportAdminTitles_14Nutrition_and_Dietetics	nvarchar(max)   NULL,
QSupportAdminTitles_15Office_Administrator	nvarchar(max)   NULL,
QSupportAdminTitles_16Office_Manager	nvarchar(max)   NULL,
QSupportAdminTitles_17Operating_Room_	nvarchar(max)   NULL,
QSupportAdminTitles_18Operations_	nvarchar(max)   NULL,
QSupportAdminTitles_19Pain_management	nvarchar(max)   NULL,
QSupportAdminTitles_20Pharmacy	nvarchar(max)   NULL,
QSupportAdminTitles_21Physical_Occupational_Therapy	nvarchar(max)   NULL,
QSupportAdminTitles_22Purchasing_Procurement	nvarchar(max)   NULL,
QSupportAdminTitles_23Radiology	nvarchar(max)   NULL,
QSupportAdminTitles_24Respiratory_Care	nvarchar(max)   NULL,
QSupportAdminTitles_25Risk_Assessment	nvarchar(max)   NULL,
QSupportAdminTitles_26Social_Work	nvarchar(max)   NULL,
QSupportAdminTitles_27Surgical_Support	nvarchar(max)   NULL,
QSupportAdminTitles_28Other	nvarchar(max)   NULL,
QSupportAdminTitles_29Cardiology_Cardiac_Ultrasound_Echocardiography	nvarchar(max)   NULL,
QSurgicalSpecialty_1Bariatric_Surgery	nvarchar(max)   NULL,
QSurgicalSpecialty_2Cardiac_Surgery	nvarchar(max)   NULL,
QSurgicalSpecialty_3Cardiothoracic_Surgery	nvarchar(max)   NULL,
QSurgicalSpecialty_4Colon_Rectal_Surgery	nvarchar(max)   NULL,
QSurgicalSpecialty_5Dermatological_Surgery	nvarchar(max)   NULL,
QSurgicalSpecialty_6General_Surgery	nvarchar(max)   NULL,
QSurgicalSpecialty_7Gynecologic_Surgery	nvarchar(max)   NULL,
QSurgicalSpecialty_8Maxillofacial_Surgery	nvarchar(max)   NULL,
QSurgicalSpecialty_9Neurosurgery	nvarchar(max)   NULL,
QSurgicalSpecialty_10Obstetrics	nvarchar(max)   NULL,
QSurgicalSpecialty_11Oncology	nvarchar(max)   NULL,
QSurgicalSpecialty_12Ophthalmology	nvarchar(max)   NULL,
QSurgicalSpecialty_13Oral_Surgery	nvarchar(max)   NULL,
QSurgicalSpecialty_14Orthopedic_Surgery	nvarchar(max)   NULL,
QSurgicalSpecialty_15Otolaryngology	nvarchar(max)   NULL,
QSurgicalSpecialty_16Pediatric_Surgery	nvarchar(max)   NULL,
QSurgicalSpecialty_17Plastic_Surgery_Cosmetic_Reconstructive_Surgery	nvarchar(max)   NULL,
QSurgicalSpecialty_18Podiatry_Surgery	nvarchar(max)   NULL,
QSurgicalSpecialty_19Thoracic_Surgery	nvarchar(max)   NULL,
QSurgicalSpecialty_20Transplant_Surgery	nvarchar(max)   NULL,
QSurgicalSpecialty_21Trauma_Surgery	nvarchar(max)   NULL,
QSurgicalSpecialty_22Urological_Surgery	nvarchar(max)   NULL,
QSurgicalSpecialty_23Vascular_Surgery	nvarchar(max)   NULL,
QSurgicalSpecialty_24Other_Specify	nvarchar(max)   NULL,
QSurgicalSpecialty_25Pain_Management_Surgery	nvarchar(max)   NULL,
QSurgicalSpecialty_26Abdominal_Surgery	nvarchar(max)   NULL,
UniqueIdentifier nvarchar(max) NULL,
PhysicianNPINumber nvarchar(max) NULL
)

declare @sqlCSV varchar(max)

set @sqlCSV = 'BULK INSERT #PanelistTemp FROM '''+@Path+'''  WITH(FIRSTROW = 2,FIELDTERMINATOR = '','',ROWTERMINATOR = ''\n'')'

exec (@sqlCSV)

declare @totalCount int
declare @tatalInsert int

declare @cname nvarchar(max)
SELECT @cname= STUFF((
    SELECT ', ' + NAME
    FROM tempdb.sys.columns 
   where object_id =
object_id('tempdb..#PanelistTemp') and NAME<>'Identifier'
    FOR XML PATH(''), TYPE).value('.', 'varchar(max)'), 1,1,'')
    
 SELECT @totalCount = COUNT(*) FROM #PanelistTemp
 
--DELETE pt
--FROM #PanelistTemp pt
--INNER JOIN PanelistMaster p
--  ON p.Identifier = pt.Identifier
  
  DELETE pm FROM PanelistMaster pm 
  INNER JOIN #PanelistTemp pt ON pm.Identifier = pt.Identifier
  
SELECT @tatalInsert = COUNT(*) FROM #PanelistTemp

declare @sql nvarchar(max)

 set @sql= N'INSERT INTO PanelistMaster(Identifier,DataPointId,OptionId,Active,PanelId) select a.Identifier,d.DatapointGroupId,a.Value,1,'+Convert(Varchar,@PanelId)+' from 
 (SELECT Identifier, DataPoint, Value FROM (SELECT Identifier,' +@cname+' FROM #PanelistTemp) p 
 UNPIVOT (Value FOR DataPoint IN ('+@cname+'))AS unpvt)a inner join Datapoint d on a.DataPoint=d.DataPointName'
 
exec sp_executesql @sql

delete from #PanelistTemp

SELECT @totalCount,@tatalInsert
END

GO
/****** Object:  StoredProcedure [dbo].[SaveProject]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Experion
-- Create date: 30 June 2015
-- Description:	Create Project 
-- =============================================
CREATE PROCEDURE [dbo].[SaveProject]
	@ProjectId INT = NULL,
	@ProjectName VARCHAR(200) = NULL,
	@LOI INT = NULL,
	@Incidence INT = NULL ,
	@SurveyLink VARCHAR(1000) = NULL,
	@EmailSubject VARCHAR(500) = NULL,
	@SurveyTopic VARCHAR(500) = NULL,
	@ReferenceCode VARCHAR(500) = NULL
AS
BEGIN
DECLARE @Status INT
SET @ProjectName = (SELECT dbo.RemoveSpecialCharacters(@ProjectName))
SET @EmailSubject = (SELECT dbo.RemoveSpecialCharacters(@EmailSubject))
SET @SurveyTopic = (SELECT dbo.RemoveSpecialCharacters(@SurveyTopic))


	IF @ProjectId = 0
	BEGIN
		INSERT INTO Project
		(
		ProjectName,
		LOI,
		Incidence,
		SurveyLink,
		Status,
		EmailSubject,
		SurveyTopic,
		ReferenceCode,
		CreateDate
		)
		VALUES
		(
		@ProjectName,
		@LOI,
		@Incidence,
		@SurveyLink,
		2, /*Project status will be in draft mode by default*/
		@EmailSubject,
		@SurveyTopic,
		@ReferenceCode,
		GETDATE()
		)
  
		SELECT scope_identity()
	END
	ELSE
	BEGIN
	
	SET @Status = (SELECT [Status] FROM Project WHERE ProjectId=@ProjectId)
	
	IF @Status = 2
	BEGIN
	
		UPDATE Project 
		SET 
		ProjectName = @ProjectName,
		LOI = @LOI,
		Incidence = @Incidence,
		SurveyLink = @SurveyLink,
		EmailSubject = @EmailSubject,
		SurveyTopic = @SurveyTopic,		
		ReferenceCode = @ReferenceCode
		WHERE ProjectId = @ProjectId
		
		SELECT @ProjectId
	END
	ELSE
	BEGIN
		SELECT 'false'
	END	
		
		
	END	
END

GO
/****** Object:  StoredProcedure [dbo].[SaveQueryAndGetProjectStatus]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Experion
-- Create date: 02 july 2013
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveQueryAndGetProjectStatus] 
	@ProjectId INT,
	@Query VARCHAR(MAX) = NULL,
	@ReqN INT = NULL,
	@JsonText VARCHAR(MAX) = NULL,
	@Speciality INT = NULL,
	@ExclusionCount INT =NULL
	
AS
BEGIN
IF EXISTS(SELECT * FROM Project WHERE ProjectId = @ProjectId)
BEGIN

DECLARE @Status INT
SET @Status = (SELECT Status FROM Project WHERE ProjectId = @ProjectId)

		IF (@Status != 3 and @Status != 4)
			BEGIN

				
				DECLARE @LOI int
				DECLARE @Reward int
				DECLARE @TotalRespondent  int 
				DECLARE @PnQuery NVARCHAR(MAX)
				DECLARE @SampleRatio decimal(18,2)
				DECLARE @SRdenominator decimal(18,2)
				DECLARE @Incidence int
				DECLARE @Group int
				DECLARE @rowcount TABLE (Value int);
				DECLARE @QuerySampleRatio varchar(500)
			
				
				SELECT @Incidence = Incidence,@LOI=LOI FROM Project WHERE ProjectId=@ProjectId
				
				SET @PnQuery = N'SELECT COUNT(*) FROM dbo.PanelistMaster P WHERE '+@Query+''
				
				INSERT INTO @rowcount
				EXEC(@PnQuery);
				SELECT @TotalRespondent = Value FROM @rowcount
				
				SET @SRdenominator = ((CONVERT(DECIMAL(18,2),@ReqN)+CONVERT(DECIMAL(18,2),@ExclusionCount))*(CONVERT(DECIMAL(18,2),@Incidence)/100))
			    SET @SampleRatio = @TotalRespondent / @SRdenominator
			    IF @SampleRatio  < 1 
			    BEGIN
					SET @SampleRatio = 1
			    END
				
				SELECT @Group = GroupId FROM SpecialityGroup WHERE SpecialityOptionId = @Speciality
				
				
				SELECT @Reward = Reward,@QuerySampleRatio = SampleRatio
				FROM Reward
				WHERE @LOI 
				BETWEEN 
				(
					SELECT Min(Convert(int,Data))
					FROM Split(LOI, '-')
				)
				AND 
				(
					SELECT Max(Convert(int,Data))
					FROM Split(LOI, '-')
				)
				AND 
				convert(int,@SampleRatio) BETWEEN 
				(
					SELECT Min(Convert(int,Data))
					FROM Split(SampleRatio, '-')
				)
				AND
				(
					SELECT Max(Convert(int,Data))
					FROM Split(SampleRatio, '-')
				)
				AND CompleteGroup = @Group
				
				

					INSERT INTO QueryMaster
					(
					ProjectId,
					ReqN,
					Query,
					JsonText,
					Speciality,
					CreateDate,
					Reward,
					SampleRatio,
					CompleteGroup,
					TotalRespondent,
					ExclusionCount
					)
					VALUES
					(
					@ProjectId,
					@ReqN,
					@Query,
					@JsonText,
					@Speciality,
					GETDATE(),
					@Reward,
					@QuerySampleRatio,
					@Group,
					@TotalRespondent,
					@ExclusionCount
					)

				  SELECT scope_identity() as QueryId,status  FROM Project WHERE ProjectId=@ProjectId
			  END
	
		  
		  ELSE
		  BEGIN
			SELECT 'close'
		  END
  END
  ELSE
  BEGIN
		SELECT 'noproject'
  END
END

GO
/****** Object:  StoredProcedure [dbo].[SaveReminder]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveReminder]
	-- Add the parameters for the stored procedure here
@QueryId int
AS
BEGIN
	IF EXISTS(SELECT 1 FROM QueryMaster WHERE QueryId = @QueryId AND CampaignId IS NOT NULL)
	BEGIN

		UPDATE QueryMaster 
		SET
		SendReminder = 1,
		ReminderRequestDate = GETDATE()
		WHERE QueryId = @QueryId
		SELECT 'true'
	END
	ELSE 
	BEGIN
		SELECT 'false'
	END
END

GO
/****** Object:  StoredProcedure [dbo].[SaveRequestLog]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Experion
-- Create date:03 July 2015
-- Description:	Save Log
-- =============================================
CREATE PROCEDURE [dbo].[SaveRequestLog]
	@LogId INT=null,
	@Json VARCHAR(2000)=null
	
AS
BEGIN
	IF @LogId = 0
	BEGIN
		INSERT INTO RequestLog(RequestJson,RequestDate)
		VALUES(@Json,GETDATE())
		SELECT Scope_Identity()
	END
	ELSE
	BEGIN
		UPDATE RequestLog
		SET 
		ResponseJson = @Json,
		ResponseDate = GETDATE()
		WHERE LogId = @LogId
		SELECT @LogId
	END
END

GO
/****** Object:  StoredProcedure [dbo].[SaveRespondentList]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Experion
-- Create date: 06 July 2015
-- Description:	Save Respondents and Return Feasibility
-- =============================================
CREATE PROCEDURE [dbo].[SaveRespondentList]
	-- Add the parameters for the stored procedure here
	@ProjectId int,
	@QueryId int,
	@ReqN int,
	@RR int,
	@QueryCondition varchar(MAX)
AS
BEGIN

DECLARE @IR INT 
DECLARE @FeasRespondCount DECIMAL(18,4)
DECLARE @Feasiblity INT
DECLARE @MaxPanelistCount INT
DECLARE @InsertCount  DECIMAL(18,4)
DECLARE @Group INT

---If the sample request is for Group=4 put it at 2% otherwise put it at 3%
SET @RR = 3
SET @Group = (SELECT CompleteGroup FROM QueryMaster WHERE QueryId = @QueryId)

IF @Group = 4
BEGIN
	SET @RR = 2 
END


SET @IR = (SELECT Incidence FROM dbo.Project WHERE ProjectId = @ProjectId)
SET @FeasRespondCount =(convert(decimal,@ReqN)*10000)/(@IR*@RR)


DECLARE @Sql VARCHAR(MAX)

			CREATE TABLE #RespondentsTemp
			(
				Identifier varchar(1000),
				PanelistType int,
				Speciality int,
				ProjectId int,
				QueryId int,
				PanelId int
				
			 )
			 
	--SET @Sql=N' INSERT INTO #RespondentsTemp(Identifier,ProjectId,QueryId,PanelId)
	--		 (SELECT 
	--		  Identifier,
	--		  '+Convert(varchar,@ProjectId)+',
	--		  '+Convert(varchar,@QueryId)+',
	--		  P.PanelId
	--		  FROM  
	--		  PanelistMaster P
	--		  LEFT OUTER JOIN RespondentList rl ON rl.RespondentId != P.Identifier and rl.ProjectId = '+Convert(varchar,@ProjectId)+' and rl.RespondentId IS NULL
	--		  WHERE rl.RespondentId IS NULL AND '+@QueryCondition +')'
	
	SET @Sql=N'INSERT INTO #RespondentsTemp(Identifier,ProjectId,QueryId,PanelId) 
SELECT Identifier ,'+Convert(varchar,@ProjectId)+', '+Convert(varchar,@QueryId)+'
	,pnlst.PanelId	
FROM (
	SELECT Identifier
		,P.PanelId
	FROM PanelistMaster P
	WHERE ACTIVE=1 AND '+	@QueryCondition+') pnlst
WHERE NOT EXISTS(SELECT * FROM RespondentList rl WHERE rl.RespondentId = pnlst.Identifier AND rl.ProjectId ='+Convert(varchar,@ProjectId)+')'



exec(@Sql)
--SELECT @Sql

	

	SET @MaxPanelistCount = (SELECT COUNT(*) FROM #RespondentsTemp)
	
	IF @MaxPanelistCount < @FeasRespondCount 
	BEGIN
		SET @InsertCount = @MaxPanelistCount
	END
	ELSE
	BEGIN
		SET @InsertCount = @FeasRespondCount
	END



 INSERT INTO RespondentList(RespondentId,ProjectId,QueryId,PanelId)
(SELECT TOP(CONVERT(INT,@InsertCount)) Identifier,rt.ProjectId,rt.QueryId,rt.PanelId FROM 
 #RespondentsTemp rt 
 WHERE rt.QueryId = @QueryId
 )
 
 --	UPDATE RespondentList SET 
 --	UniqueId = SUBSTRING(master.dbo.fn_varbintohexstr(HashBytes('MD5', CONVERT(varchar, RespondentListId+GETDATE()))), 3, 32) 
	--WHERE ProjectId = @ProjectId AND UniqueId IS NULL
	
 SET @Feasiblity = CEILING((convert(decimal,@InsertCount) *@RR*@IR)/10000)
 
 SELECT @Feasiblity as feasibility
 DROP TABLE #RespondentsTemp
 
END

GO
/****** Object:  StoredProcedure [dbo].[SaveSurveyLog]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveSurveyLog] 
	@Url NVARCHAR(MAX),
	@IPAddress	VARCHAR(50),
	@LogType INT
AS
BEGIN
	INSERT INTO SurveyLog(Url,IPAddress,LogType) 
	VALUES(@Url,@IPAddress,@LogType)
	
	RETURN SCOPE_IDENTITY()
END

GO
/****** Object:  StoredProcedure [dbo].[UpdateDataGetSCHSurveyURL]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateDataGetSCHSurveyURL] 
	@ProjectId INT,
	@Identifier	VARCHAR(1000),
	@Sesskey VARCHAR(500),
	@SurveyRequestIP VARCHAR(100),
	@SurveyLogId INT
AS
BEGIN
	
	DECLARE @RespondentListId AS INT	
	SELECT @RespondentListId = RespondentListId FROM RespondentList 
	WHERE ProjectId = @ProjectId AND RespondentId = @identifier
	
	UPDATE RespondentList SET 
		Sesskey = @Sesskey, 
		UniqueId = @Sesskey,
		SurveyRequestIP = @SurveyRequestIP, 
		SurveyRequestDate = GETDATE()
	WHERE RespondentListId = @RespondentListId
	
	UPDATE SurveyLog SET RespondentListId = @RespondentListId WHERE SurveyLogId = @SurveyLogId 
	
	SELECT 
		ISNULL(SurveyStatus,0) AS SurveyStatus, 
		REPLACE(REPLACE(SurveyLink,'[session_key]',Sesskey), '[identifier]' , RespondentId) AS SurveyURL,
		p.Status AS ProjectStatus
	FROM 
		RespondentList rl
		INNER JOIN Project p ON rl.ProjectId = p.ProjectId
	WHERE 
		RespondentListId = @RespondentListId
	
END

GO
/****** Object:  StoredProcedure [dbo].[UpdateKinesisProjectClosedStatus]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateKinesisProjectClosedStatus] 
	@ProjectIds varchar(2000) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 UPDATE Project SET
 KinesisCloseStatus = 1
 WHERE ProjectId IN (SELECT Data FROM Split(@ProjectIds,','))
 
 
 
END

GO
/****** Object:  StoredProcedure [dbo].[UpdateKinesisProjectStatus]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateKinesisProjectStatus] 
@ProjectId INT,
@KinesisProjectId INT,
@KinesisStatus INT,	
@KinesisAPIError VARCHAR(MAX),
@RespondentListId VARCHAR(MAX),
@PanelId int = NULL,
@CampaignId int = NULL,
@QueryId int = NULL,
@SampleId int = NULL

AS
BEGIN

DECLARE @ErrorRetryCount INT = 0


	UPDATE Project SET 	
	KinesisStatus = @KinesisStatus,
	KinesisAPIError = @KinesisAPIError,
    KinesisProjectId = 
	(case when @KinesisProjectId != 0
	then @KinesisProjectId else 
	KinesisProjectId end),
	ErrorRetryCount = 
	(case when @KinesisStatus != 3
	then ISNULL(ErrorRetryCount,0)+1 else 
	ErrorRetryCount end)
	WHERE
	ProjectId = @ProjectId 
		
	IF @CampaignId IS NOT NULL
	BEGIN
		UPDATE dbo.QueryMaster SET CampaignId = @CampaignId,SampleId=@SampleId WHERE QueryId = @QueryId
	END

	IF 	@KinesisStatus = 3 
	BEGIN
		Update RespondentList SET
		KinesisProjectId = @KinesisProjectId,
		KinesisInsertionDate = getdate()
		WHERE RespondentListId IN (SELECT data  from dbo.Split(@RespondentListId,','))
	END
	
END

GO
/****** Object:  StoredProcedure [dbo].[UpdateKinesisReminderStatus]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateKinesisReminderStatus] 
	@QueryIds varchar(2000) = NULL,
	@FailedQueryIds varchar(2000) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

IF @QueryIds IS NOT NULL
BEGIN
 UPDATE QueryMaster SET
 KinesisReminderSentDate = GETDATE(),
 ReminderSentStatus = 1
 WHERE QueryId IN (SELECT Data FROM Split(@QueryIds,','))
END

IF @FailedQueryIds IS NOT NULL
BEGIN
 UPDATE QueryMaster SET
 KinesisReminderErrorCount = ISNULL(KinesisReminderErrorCount,0)+1
 WHERE QueryId IN (SELECT Data FROM Split(@FailedQueryIds,','))
END
 
 
 
 
END

GO
/****** Object:  StoredProcedure [dbo].[UpdatePanelistMasterStatus]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Malu NS
-- Create date: 06/04/2015
-- Description:	import data
-- =============================================


CREATE PROCEDURE [dbo].[UpdatePanelistMasterStatus]

 @ImportType int,
 @IdentifierList IdentifierList readonly   
 /* WITH ENCRYPTION */
AS
BEGIN
	
	 IF(@ImportType = 2) --Suspend--
	BEGIN
	
		UPDATE PanelistMaster  SET Active = 2
		WHERE Identifier IN (SELECT Identifier FROM @IdentifierList) and  Active = 1
		SELECT 1
		
	END
	ELSE IF(@ImportType = 3) --Black list--
	BEGIN
	
		UPDATE PanelistMaster SET Active = 3
		WHERE Identifier IN (SELECT Identifier FROM @IdentifierList) 
		SELECT 1
		
	END
	ELSE IF(@ImportType = 4) --Resume--
	BEGIN
		
		UPDATE PanelistMaster SET Active = 1
		WHERE Identifier IN (SELECT Identifier FROM @IdentifierList) and Active = 2
		SELECT 1
	END



END

GO
/****** Object:  StoredProcedure [dbo].[UpdateProjectStatusToClose]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Experion
-- Create date: 14 August 2015
-- Description:	update Project status to close by admin
-- =============================================
CREATE PROCEDURE [dbo].[UpdateProjectStatusToClose]
 @ProjectList ProjectList readonly   
AS
BEGIN
	
		UPDATE 
		Project
		SET 
		Status = 4
		WHERE KinesisProjectId IN (SELECT ProjectId FROM @ProjectList)

	
END

GO
/****** Object:  StoredProcedure [dbo].[UpdateProjectToClose]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateProjectToClose] 
	@ProjectId nvarchar(500)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	

 UPDATE Project SET

 Status = 4,
 KinesisCloseStatus = 1
 WHERE ProjectId IN (SELECT data  from dbo.Split(@ProjectId,',')) 
 
 
 
END

GO
/****** Object:  StoredProcedure [dbo].[UpdateSurveyStatus]    Script Date: 21/07/2016 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateSurveyStatus] 
	@UniqueId varchar(100),
	@status	INT,
	@SurveyCompletionIP VARCHAR(100),
	@SurveyLogId INT
AS
BEGIN
	
	DECLARE @RespondantListId int
	DECLARE @SurveyStatus AS INT
	
	SELECT @SurveyStatus = ISNULL(SurveyStatus,0) FROM RespondentList WHERE UniqueId = @UniqueId
	
	--do only if status is not updated
	IF @SurveyStatus IS NULL OR @SurveyStatus = 0 
	BEGIN
	
		UPDATE RespondentList SET 
			SurveyStatus = @status,
			SurveyCompletionIP = @SurveyCompletionIP,
			SurveyCompletionDate = GETDATE()
		WHERE UniqueId = @UniqueId	
	END
	
	SELECT @RespondantListId = RespondentListId FROM RespondentList where UniqueId = @UniqueId
	
	UPDATE SurveyLog SET RespondentListId = @RespondantListId WHERE SurveyLogId = @SurveyLogId
	
	IF @SurveyStatus IS NULL OR @SurveyStatus = 0 	
	BEGIN
		SELECT Sesskey FROM RespondentList WHERE UniqueId = @UniqueId
	END
	ELSE	
	BEGIN
		SELECT 'Invalid' AS Sesskey
	END
	
	
END

GO
