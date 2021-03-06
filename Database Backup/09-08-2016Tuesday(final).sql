USE [master]
GO
/****** Object:  Database [SCHUniversalAPITest]    Script Date: 09/08/2016 14:06:45 ******/
CREATE DATABASE [SCHUniversalAPITest] ON  PRIMARY 
( NAME = N'SCHUniversalAPITest', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.SQL2K8\MSSQL\DATA\SCHUniversalAPITest.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'SCHUniversalAPITest_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.SQL2K8\MSSQL\DATA\SCHUniversalAPITest_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [SCHUniversalAPITest] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SCHUniversalAPITest].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SCHUniversalAPITest] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SCHUniversalAPITest] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SCHUniversalAPITest] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SCHUniversalAPITest] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SCHUniversalAPITest] SET ARITHABORT OFF 
GO
ALTER DATABASE [SCHUniversalAPITest] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [SCHUniversalAPITest] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SCHUniversalAPITest] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SCHUniversalAPITest] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SCHUniversalAPITest] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SCHUniversalAPITest] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SCHUniversalAPITest] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SCHUniversalAPITest] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SCHUniversalAPITest] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SCHUniversalAPITest] SET  DISABLE_BROKER 
GO
ALTER DATABASE [SCHUniversalAPITest] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SCHUniversalAPITest] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SCHUniversalAPITest] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SCHUniversalAPITest] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SCHUniversalAPITest] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SCHUniversalAPITest] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SCHUniversalAPITest] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SCHUniversalAPITest] SET RECOVERY FULL 
GO
ALTER DATABASE [SCHUniversalAPITest] SET  MULTI_USER 
GO
ALTER DATABASE [SCHUniversalAPITest] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SCHUniversalAPITest] SET DB_CHAINING OFF 
GO
EXEC sys.sp_db_vardecimal_storage_format N'SCHUniversalAPITest', N'ON'
GO
USE [SCHUniversalAPITest]
GO
/****** Object:  UserDefinedTableType [dbo].[IdentifierList]    Script Date: 09/08/2016 14:06:45 ******/
CREATE TYPE [dbo].[IdentifierList] AS TABLE(
	[Identifier] [varchar](1000) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[IntegerTableType]    Script Date: 09/08/2016 14:06:45 ******/
CREATE TYPE [dbo].[IntegerTableType] AS TABLE(
	[ID] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[ProjectList]    Script Date: 09/08/2016 14:06:45 ******/
CREATE TYPE [dbo].[ProjectList] AS TABLE(
	[ProjectId] [int] NULL
)
GO
/****** Object:  UserDefinedFunction [dbo].[RemoveSpecialCharacters]    Script Date: 09/08/2016 14:06:45 ******/
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
/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 09/08/2016 14:06:45 ******/
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
/****** Object:  Table [dbo].[Datapoint]    Script Date: 09/08/2016 14:06:45 ******/
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
/****** Object:  Table [dbo].[DataPointOptions]    Script Date: 09/08/2016 14:06:45 ******/
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
/****** Object:  Table [dbo].[PanelistMaster]    Script Date: 09/08/2016 14:06:45 ******/
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
	[PanelId] [int] NULL,
	[SurveyCompletionCount] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Project]    Script Date: 09/08/2016 14:06:45 ******/
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
/****** Object:  Table [dbo].[pvt]    Script Date: 09/08/2016 14:06:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pvt](
	[VendorID] [int] NULL,
	[Emp1] [int] NULL,
	[Emp2] [int] NULL,
	[Emp3] [int] NULL,
	[Emp4] [int] NULL,
	[Emp5] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[QueryMaster]    Script Date: 09/08/2016 14:06:45 ******/
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
	[Reward] [int] NULL,
	[SampleId] [int] NULL,
	[CampaignId] [int] NULL,
	[SendReminder] [bit] NULL,
	[ReminderRequestDate] [datetime] NULL,
	[ReminderSentStatus] [bit] NULL,
	[KinesisReminderSentDate] [datetime] NULL,
	[KinesisReminderErrorCount] [int] NULL,
	[SampleRatio] [varchar](500) NULL,
	[CompleteGroup] [int] NULL,
	[TotalRespondent] [int] NULL,
	[ExclusionCount] [int] NULL,
	[CampaignCreatedDate] [datetime] NULL,
	[RewardLevel] [nvarchar](10) NULL,
 CONSTRAINT [PK_QueryMaster] PRIMARY KEY CLUSTERED 
(
	[QueryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[QuerySampleMapping]    Script Date: 09/08/2016 14:06:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[QuerySampleMapping](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[QueryId] [int] NULL,
	[SampleId] [int] NULL,
	[CampaignId] [int] NULL,
	[SendReminder] [bit] NULL,
	[ReminderRequestDate] [datetime] NULL,
	[ReminderSentStatus] [bit] NULL,
	[KinesisReminderSentDate] [datetime] NULL,
	[KinesisReminderErrorCount] [int] NULL,
	[SampleRatio] [varchar](500) NULL,
	[CompleteGroup] [int] NULL,
	[TotalRespondent] [int] NULL,
	[ExclusionCount] [int] NULL,
	[CampaignCreatedDate] [datetime] NULL,
	[ErrorRetryCount] [int] NULL,
	[KinesisAPIError] [varchar](100) NULL,
	[MaxRemainder] [int] NULL,
	[RemainderCount] [int] NULL,
 CONSTRAINT [PK_QuerySampleMapping] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RequestLog]    Script Date: 09/08/2016 14:06:45 ******/
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
/****** Object:  Table [dbo].[RespondentList]    Script Date: 09/08/2016 14:06:45 ******/
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
	[FK_QuerySampleMappingId] [int] NULL,
	[RewardSentStatus] [int] NULL,
	[RewardSentDate] [datetime] NULL,
	[Reward] [int] NULL,
	[RewardLevel] [nvarchar](10) NULL,
 CONSTRAINT [PK_RespondentList] PRIMARY KEY CLUSTERED 
(
	[RespondentListId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ResponseLog]    Script Date: 09/08/2016 14:06:45 ******/
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
/****** Object:  Table [dbo].[Reward]    Script Date: 09/08/2016 14:06:45 ******/
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
	[RewardA] [varchar](50) NULL,
	[RewardB] [varchar](50) NULL,
	[RewardC] [varchar](50) NULL,
	[RewardD] [varchar](50) NULL,
 CONSTRAINT [PK_Reward] PRIMARY KEY CLUSTERED 
(
	[RewardId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SampleRemainderHistoryTable]    Script Date: 09/08/2016 14:06:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SampleRemainderHistoryTable](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FK_QuerySampleMapping] [int] NULL,
	[RemainderSentDate] [datetime] NULL,
 CONSTRAINT [PK_SampleRemainderHistoryTable] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SpecialityGroup]    Script Date: 09/08/2016 14:06:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SpecialityGroup](
	[SpecialityOptionId] [int] NULL,
	[SpecialityOptionName] [varchar](200) NULL,
	[GroupId] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SurveyLog]    Script Date: 09/08/2016 14:06:45 ******/
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
	[LogDate] [datetime] NULL CONSTRAINT [DF_SurveyLog_LogDate]  DEFAULT (getdate()),
	[LogType] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[Datapoint] ON 

INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (1, N'Gender', 1)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (2, N'City', 2)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (3, N'State', 3)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (4, N'PostalCode', 4)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (5, N'Country', 5)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (6, N'QCardiologistClass_1GeneralCardiologist', 6)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (7, N'QCardiologistClass_2Non_InvasiveCardiologist', 6)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (8, N'QCardiologistClass_3InvasiveNon_InterventionalCardiologist', 6)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (9, N'QCardiologistClass_4Interventional_Cardiologist', 6)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (10, N'QCardiologistClass_5Electrophysiologist', 6)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (11, N'QCardiologistClass_6Pediatric_Cardiologist', 6)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (12, N'QDoctorWorkplaceSetting', 7)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (13, N'QHCPSpecialty_1Addiction_Medicine', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (14, N'QHCPSpecialty_2Aerospace_Medicine', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (15, N'QHCPSpecialty_3Allergist_ENT', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (16, N'QHCPSpecialty_4Anesthesiology', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (17, N'QHCPSpecialty_5Blood_Banking_Transfusion_Medicine', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (18, N'QHCPSpecialty_6Cardiology', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (19, N'QHCPSpecialty_7Cardiovascular_Diseases', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (20, N'QHCPSpecialty_8Clinical_Biochemical_Genetics', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (21, N'QHCPSpecialty_9Clinical_Pharmacology', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (22, N'QHCPSpecialty_10Dermatology', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (23, N'QHCPSpecialty_11Diabetologist', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (24, N'QHCPSpecialty_12Emergency_Medicine', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (25, N'QHCPSpecialty_13Endocrinology_Diabetes_Metabolism', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (26, N'QHCPSpecialty_14Epidemiology', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (27, N'QHCPSpecialty_15Gastroenterology', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (28, N'QHCPSpecialty_16General_Practice', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (29, N'QHCPSpecialty_17Geriatrics', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (30, N'QHCPSpecialty_18Hematology', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (31, N'QHCPSpecialty_19Hepatology', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (32, N'QHCPSpecialty_20HIV_AIDS', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (33, N'QHCPSpecialty_21Hospitalist', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (34, N'QHCPSpecialty_22Immunology', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (35, N'QHCPSpecialty_23Infectious_Disease', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (36, N'QHCPSpecialty_24Internal_Medicine', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (37, N'QHCPSpecialty_25Legal_Medicine', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (38, N'QHCPSpecialty_26Medical_Genetics', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (39, N'QHCPSpecialty_27Medical_Management', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (40, N'QHCPSpecialty_28Nephrology', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (41, N'QHCPSpecialty_29Neurology', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (42, N'QHCPSpecialty_30Neuropsychiatry', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (43, N'QHCPSpecialty_31Neurotology', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (44, N'QHCPSpecialty_32Nuclear_Medicine', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (45, N'QHCPSpecialty_33Nutrition', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (46, N'QHCPSpecialty_34Obesity', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (47, N'QHCPSpecialty_35Obstetrics_Gynecology', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (48, N'QHCPSpecialty_36Occupational_Medicine', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (49, N'QHCPSpecialty_37Oncology', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (50, N'QHCPSpecialty_38Ophthalmology', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (51, N'QHCPSpecialty_39Orthopedics', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (52, N'QHCPSpecialty_40Otolaryngology', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (53, N'QHCPSpecialty_41Otology', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (54, N'QHCPSpecialty_42Pain_Medicine', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (55, N'QHCPSpecialty_43Palliative_Medicine', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (56, N'QHCPSpecialty_44Pathology', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (57, N'QHCPSpecialty_45Pediatrics', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (58, N'QHCPSpecialty_46Physical_Medicine_Rehabilitation', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (59, N'QHCPSpecialty_47Plastic_Surgery', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (60, N'QHCPSpecialty_48Preventive_Medicine', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (61, N'QHCPSpecialty_49Proctology', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (62, N'QHCPSpecialty_50Psychiatry', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (63, N'QHCPSpecialty_51Public_Health_And_General_Preventive_Med', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (64, N'QHCPSpecialty_52Pulmonary_Medicine', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (65, N'QHCPSpecialty_53Radiology', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (66, N'QHCPSpecialty_54Reproductive_Endocrinology', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (67, N'QHCPSpecialty_55Rheumatology', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (68, N'QHCPSpecialty_56Sleep_Medicine', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (69, N'QHCPSpecialty_57Sports_Medicine', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (70, N'QHCPSpecialty_58Surgery_Surgeon', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (71, N'QHCPSpecialty_59Undersea_Medicine_Hyperbaric_Medic', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (72, N'QHCPSpecialty_60Urogynecology', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (73, N'QHCPSpecialty_61Urology', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (74, N'QHCPSpecialty_62Vascular_Medicine', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (75, N'QHCPSpecialty_63Bariatric_Medicine', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (76, N'QHCPSpecialty_64Community_Medicine', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (77, N'QHCPSpecialty_65Critical_Care_Medicine', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (78, N'QHCPSpecialty_66Medical_Scientist', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (79, N'QHCPSpecialty_67Medical_Biochemistry', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (80, N'QHCPSpecialty_68Respirology', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (81, N'QHCPSpecialty_69Movement_Disorder_Specialist', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (82, N'QHCPSpecialty_70Family_Medicine_Family_Practice', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (83, N'QHCPSpecialty_71Other_Specify', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (84, N'QHCPSpecialty_72Transplant', 8)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (85, N'QOncologistClass_1Medical_Oncologist', 9)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (86, N'QOncologistClass_2Hematologist_Oncologist', 9)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (87, N'QOncologistClass_3Radiation_Oncologist', 9)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (88, N'QOncologistClass_4Surgical_Oncologist', 9)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (89, N'QOncologistClass_5Gynecological_Oncologist', 9)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (90, N'QOncologistClass_6Pediatric_Oncologist', 9)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (91, N'QPanelistType_1Physician', 10)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (92, N'QPanelistType_2Dentist', 10)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (93, N'QPanelistType_3Dentist_Support_Staff', 10)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (94, N'QPanelistType_4Executive_or_Management', 10)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (95, N'QPanelistType_5Administrative_Technician_Operations', 10)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (96, N'QPanelistType_6Pharmacist_Pharmacy_Staff', 10)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (97, N'QPanelistType_7Physician_Support_Staff', 10)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (98, N'QPanelistType_8Optometrist', 10)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (99, N'QPanelistType_9Podiatrist', 10)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (100, N'QPanelistType_10Optician', 10)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (101, N'QPanelistType_11Chiropractor', 10)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (102, N'QPanelistType_12Veterinarian_Veterinary_Staff', 10)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (103, N'QPanelistType_13Executive_or_Management', 10)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (104, N'QPanelistType_14Therapist_Counselor', 10)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (105, N'QPanelistType_15Nurse', 10)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (106, N'QPediatricianClass_1Adolescent_Medicine', 11)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (107, N'QPediatricianClass_2Developmental_Behavioral_Pediatrics', 11)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (108, N'QPediatricianClass_3Hospice_and_Palliative_medicine', 11)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (109, N'QPediatricianClass_4Medical_Toxicology', 11)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (110, N'QPediatricianClass_5Neonatal_Perinatal_medicine', 11)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (111, N'QPediatricianClass_6Neurodevelopmental_Disabilities', 11)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (112, N'QPediatricianClass_7Pediatric_Allergist', 11)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (113, N'QPediatricianClass_8Pediatric_Cardiology', 11)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (114, N'QPediatricianClass_9Pediatric_Critical_Care_Medicine', 11)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (115, N'QPediatricianClass_10Pediatric_Emergency_Medicine', 11)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (116, N'QPediatricianClass_11Pediatric_Endocrinology', 11)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (117, N'QPediatricianClass_12Pediatric_gastroenterology', 11)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (118, N'QPediatricianClass_13Pediatric_Hematology_Oncology', 11)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (119, N'QPediatricianClass_14Pediatric_Infectious_Diseases', 11)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (120, N'QPediatricianClass_15Pediatric_Nephrology', 11)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (121, N'QPediatricianClass_16Pediatric_Neurology', 11)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (122, N'QPediatricianClass_17Pediatric_Ophthalmology', 11)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (123, N'QPediatricianClass_18Pediatric_Otolaryngology', 11)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (124, N'QPediatricianClass_19pediatric_Pulmonology', 11)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (125, N'QPediatricianClass_20Pediatric_Radiology', 11)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (126, N'QPediatricianClass_21Pediatric_Rheumatology', 11)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (127, N'QPediatricianClass_22Pediatric_Sports_Medicine', 11)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (128, N'QPediatricianClass_23Pediatric_Urology', 11)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (129, N'QPediatricianClass_24Pediatric_Sleep_Medicine', 11)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (130, N'QPediatricianClass_25None_of_the_above', 11)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (131, N'QRadiologistClass_1Abdominal_Radiology', 12)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (132, N'QRadiologistClass_2Breast_imaging', 12)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (133, N'QRadiologistClass_3Cardiothoracic_Radiology', 12)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (134, N'QRadiologistClass_4Cardiovascular_Radiology', 12)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (135, N'QRadiologistClass_5Chest_Radiology', 12)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (136, N'QRadiologistClass_6Diagnostic_Radiology', 12)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (137, N'QRadiologistClass_7Endovascular_Surgical_Neuroradiology', 12)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (138, N'QRadiologistClass_8Emergency_Radiology', 12)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (139, N'QRadiologistClass_9Gastrointestinal_GI_Radiology', 12)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (140, N'QRadiologistClass_10Genitourinary_Radiology', 12)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (141, N'QRadiologistClass_11Head_and_Neck_Radiology', 12)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (142, N'QRadiologistClass_12Interventional_Radiology', 12)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (143, N'QRadiologistClass_13Musculoskeletal_Radiology', 12)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (144, N'QRadiologistClass_14Neuroradiology', 12)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (145, N'QRadiologistClass_15Nuclear_Radiology', 12)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (146, N'QRadiologistClass_16Pediatric_Radiology', 12)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (147, N'QRadiologistClass_17Radiation_Oncology', 12)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (148, N'QRadiologistClass_18Other_Specify', 12)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (149, N'QSupportAdminTitles_1Case_Management_Patient_Case_Management', 13)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (150, N'QSupportAdminTitles_2Cath_Laboratory', 13)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (151, N'QSupportAdminTitles_3Clerical_Support', 13)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (152, N'QSupportAdminTitles_4Critical_Care_Intensive_Care', 13)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (153, N'QSupportAdminTitles_5Discharge', 13)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (154, N'QSupportAdminTitles_6Elderly_Care', 13)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (155, N'QSupportAdminTitles_7Emergency_Services', 13)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (156, N'QSupportAdminTitles_8Information_Technology', 13)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (157, N'QSupportAdminTitles_9Materials', 13)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (158, N'QSupportAdminTitles_10Maternity_Neonatal_Care', 13)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (159, N'QSupportAdminTitles_11Medical_Clinical_Laboratory', 13)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (160, N'QSupportAdminTitles_12Nuclear_Medicine_', 13)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (161, N'QSupportAdminTitles_13Nurse_Manager', 13)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (162, N'QSupportAdminTitles_14Nutrition_and_Dietetics', 13)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (163, N'QSupportAdminTitles_15Office_Administrator', 13)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (164, N'QSupportAdminTitles_16Office_Manager', 13)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (165, N'QSupportAdminTitles_17Operating_Room_', 13)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (166, N'QSupportAdminTitles_18Operations_', 13)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (167, N'QSupportAdminTitles_19Pain_management', 13)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (168, N'QSupportAdminTitles_20Pharmacy', 13)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (169, N'QSupportAdminTitles_21Physical_Occupational_Therapy', 13)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (170, N'QSupportAdminTitles_22Purchasing_Procurement', 13)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (171, N'QSupportAdminTitles_23Radiology', 13)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (172, N'QSupportAdminTitles_24Respiratory_Care', 13)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (173, N'QSupportAdminTitles_25Risk_Assessment', 13)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (174, N'QSupportAdminTitles_26Social_Work', 13)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (175, N'QSupportAdminTitles_27Surgical_Support', 13)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (176, N'QSupportAdminTitles_28Other', 13)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (177, N'QSupportAdminTitles_29Cardiology_Cardiac_Ultrasound_Echocardiography', 13)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (178, N'QSurgicalSpecialty_1Bariatric_Surgery', 14)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (179, N'QSurgicalSpecialty_2Cardiac_Surgery', 14)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (180, N'QSurgicalSpecialty_3Cardiothoracic_Surgery', 14)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (181, N'QSurgicalSpecialty_4Colon_Rectal_Surgery', 14)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (182, N'QSurgicalSpecialty_5Dermatological_Surgery', 14)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (183, N'QSurgicalSpecialty_6General_Surgery', 14)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (184, N'QSurgicalSpecialty_7Gynecologic_Surgery', 14)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (185, N'QSurgicalSpecialty_8Maxillofacial_Surgery', 14)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (186, N'QSurgicalSpecialty_9Neurosurgery', 14)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (187, N'QSurgicalSpecialty_10Obstetrics', 14)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (188, N'QSurgicalSpecialty_11Oncology', 14)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (189, N'QSurgicalSpecialty_12Ophthalmology', 14)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (190, N'QSurgicalSpecialty_13Oral_Surgery', 14)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (191, N'QSurgicalSpecialty_14Orthopedic_Surgery', 14)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (192, N'QSurgicalSpecialty_15Otolaryngology', 14)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (193, N'QSurgicalSpecialty_16Pediatric_Surgery', 14)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (194, N'QSurgicalSpecialty_17Plastic_Surgery_Cosmetic_Reconstructive_Surgery', 14)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (195, N'QSurgicalSpecialty_18Podiatry_Surgery', 14)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (196, N'QSurgicalSpecialty_19Thoracic_Surgery', 14)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (197, N'QSurgicalSpecialty_20Transplant_Surgery', 14)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (198, N'QSurgicalSpecialty_21Trauma_Surgery', 14)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (199, N'QSurgicalSpecialty_22Urological_Surgery', 14)
GO
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (200, N'QSurgicalSpecialty_23Vascular_Surgery', 14)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (201, N'QSurgicalSpecialty_24Other_Specify', 14)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (202, N'QSurgicalSpecialty_25Pain_Management_Surgery', 14)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (203, N'QSurgicalSpecialty_26Abdominal_Surgery', 14)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (204, N'UniqueIdentifier', 15)
INSERT [dbo].[Datapoint] ([DataPointId], [DataPointName], [DatapointGroupId]) VALUES (205, N'PhysicianNPINumber', 16)
SET IDENTITY_INSERT [dbo].[Datapoint] OFF
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_001c6f699a', 1, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_001c6f699a', 2, N'Hanover', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_001c6f699a', 3, N'30', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_001c6f699a', 4, N'21076', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_001c6f699a', 5, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_001c6f699a', 8, N'29', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_001c6f699a', 10, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_001c6f699a', 15, N'K_001c6f699a', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_001c6f699a', 16, N'9999999979', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_0011894c0c', 1, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_0011894c0c', 2, N'San Leandro', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_0011894c0c', 3, N'9', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_0011894c0c', 4, N'94577', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_0011894c0c', 5, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_0011894c0c', 8, N'18', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_0011894c0c', 8, N'37', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_0011894c0c', 9, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_0011894c0c', 9, N'2', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_0011894c0c', 10, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_0011894c0c', 15, N'K_0011894c0c', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_0011894c0c', 16, N'9999999980', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_cd964071ca', 1, N'2', 1, 9, 3)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_cd964071ca', 2, N'Whitehouse Station', 1, 9, 3)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_cd964071ca', 3, N'44', 1, 9, 3)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_cd964071ca', 4, N'8889', 1, 9, 3)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_cd964071ca', 5, N'1', 1, 9, 3)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_cd964071ca', 10, N'12', 1, 9, 3)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_cd964071ca', 15, N'K_cd964071ca', 1, 9, 3)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_cd964071ca', 16, N'9999999981', 1, 9, 3)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_2b46b67a62', 1, N'2', 1, 9, 2)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_2b46b67a62', 2, N'Cedar Park', 1, 9, 2)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_2b46b67a62', 3, N'69', 1, 9, 2)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_2b46b67a62', 4, N'78613', 1, 9, 2)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_2b46b67a62', 5, N'1', 1, 9, 2)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_2b46b67a62', 10, N'8', 1, 9, 2)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_2b46b67a62', 15, N'K_2b46b67a62', 1, 9, 2)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_2b46b67a62', 16, N'9999999982', 1, 9, 2)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_bf87639a49', 1, N'2', 1, 9, 6)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_bf87639a49', 2, N'Omaha', 1, 9, 6)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_bf87639a49', 3, N'41', 1, 9, 6)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_bf87639a49', 4, N'68104', 1, 9, 6)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_bf87639a49', 5, N'1', 1, 9, 6)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_bf87639a49', 8, N'6', 1, 9, 6)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_bf87639a49', 8, N'45', 1, 9, 6)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_bf87639a49', 8, N'48', 1, 9, 6)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_bf87639a49', 8, N'63', 1, 9, 6)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_bf87639a49', 10, N'15', 1, 9, 6)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_bf87639a49', 15, N'K_bf87639a49', 1, 9, 6)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_bf87639a49', 16, N'9999999983', 1, 9, 6)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_8d998b0953', 1, N'2', 1, 9, 6)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_8d998b0953', 2, N'Charlottesville', 1, 9, 6)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_8d998b0953', 3, N'71', 1, 9, 6)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_8d998b0953', 4, N'22902', 1, 9, 6)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_8d998b0953', 5, N'1', 1, 9, 6)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_8d998b0953', 8, N'35', 1, 9, 6)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_8d998b0953', 10, N'15', 1, 9, 6)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_8d998b0953', 15, N'K_8d998b0953', 1, 9, 6)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_8d998b0953', 16, N'9999999984', 1, 9, 6)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_090a8e248a', 1, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_090a8e248a', 2, N'Marengo', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_090a8e248a', 3, N'21', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_090a8e248a', 4, N'60152', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_090a8e248a', 5, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_090a8e248a', 10, N'4', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_090a8e248a', 15, N'K_090a8e248a', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_090a8e248a', 16, N'9999999985', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_79d053efe9', 1, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_79d053efe9', 2, N'Bayside', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_79d053efe9', 3, N'51', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_79d053efe9', 4, N'11360', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_79d053efe9', 5, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_79d053efe9', 7, N'17', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_79d053efe9', 8, N'15', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_79d053efe9', 8, N'19', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_79d053efe9', 8, N'24', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_79d053efe9', 10, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_79d053efe9', 15, N'K_79d053efe9', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_79d053efe9', 16, N'9999999986', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_2a0c1e7cce', 1, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_2a0c1e7cce', 2, N'Fort Mill', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_2a0c1e7cce', 3, N'64', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_2a0c1e7cce', 4, N'29715', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_2a0c1e7cce', 5, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_2a0c1e7cce', 10, N'5', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_2a0c1e7cce', 13, N'17', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_2a0c1e7cce', 13, N'19', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_2a0c1e7cce', 13, N'27', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_2a0c1e7cce', 13, N'28', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_2a0c1e7cce', 15, N'K_2a0c1e7cce', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_2a0c1e7cce', 16, N'9999999987', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_95bb44084f', 1, N'2', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_95bb44084f', 2, N'Carlisle', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_95bb44084f', 3, N'56', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_95bb44084f', 4, N'17013', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_95bb44084f', 5, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_95bb44084f', 8, N'50', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_95bb44084f', 10, N'15', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_95bb44084f', 15, N'K_95bb44084f', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_95bb44084f', 16, N'9999999988', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_f6c521fa93', 1, N'2', 1, 9, 1)
GO
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_f6c521fa93', 2, N'Hoffman Estates', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_f6c521fa93', 3, N'21', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_f6c521fa93', 4, N'60169', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_f6c521fa93', 5, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_f6c521fa93', 8, N'37', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_f6c521fa93', 10, N'15', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_f6c521fa93', 15, N'K_f6c521fa93', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_f6c521fa93', 16, N'9999999989', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_409f769e16', 1, N'2', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_409f769e16', 2, N'AUSTIN', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_409f769e16', 3, N'69', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_409f769e16', 4, N'78757', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_409f769e16', 5, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_409f769e16', 8, N'24', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_409f769e16', 8, N'55', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_409f769e16', 10, N'7', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_409f769e16', 15, N'K_409f769e16', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_409f769e16', 16, N'9999999990', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_f2deb0970d', 1, N'1', 1, 9, 3)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_f2deb0970d', 2, N'Orangeburg', 1, 9, 3)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_f2deb0970d', 3, N'64', 1, 9, 3)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_f2deb0970d', 4, N'29118', 1, 9, 3)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_f2deb0970d', 5, N'1', 1, 9, 3)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_f2deb0970d', 6, N'3', 1, 9, 3)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_f2deb0970d', 7, N'10', 1, 9, 3)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_f2deb0970d', 8, N'6', 1, 9, 3)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_f2deb0970d', 8, N'7', 1, 9, 3)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_f2deb0970d', 10, N'1', 1, 9, 3)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_f2deb0970d', 14, N'24', 1, 9, 3)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_f2deb0970d', 15, N'K_f2deb0970d', 1, 9, 3)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_f2deb0970d', 16, N'9999999991', 1, 9, 3)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_7ef4fd49ce', 1, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_7ef4fd49ce', 2, N'Fernandina Beach', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_7ef4fd49ce', 3, N'14', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_7ef4fd49ce', 4, N'32034', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_7ef4fd49ce', 5, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_7ef4fd49ce', 10, N'8', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_7ef4fd49ce', 15, N'K_7ef4fd49ce', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_7ef4fd49ce', 16, N'9999999992', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_a10da422b6', 1, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_a10da422b6', 2, N'Charlotte', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_a10da422b6', 3, N'32', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_a10da422b6', 4, N'48813', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_a10da422b6', 5, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_a10da422b6', 8, N'4', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_a10da422b6', 8, N'42', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_a10da422b6', 10, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_a10da422b6', 14, N'25', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_a10da422b6', 15, N'K_a10da422b6', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_a10da422b6', 16, N'9999999993', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_4ce5622068', 1, N'2', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_4ce5622068', 2, N'Sparks', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_4ce5622068', 3, N'50', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_4ce5622068', 4, N'89434', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_4ce5622068', 5, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_4ce5622068', 10, N'12', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_4ce5622068', 15, N'K_4ce5622068', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_4ce5622068', 16, N'9999999994', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_83d63d6182', 1, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_83d63d6182', 2, N'Grand Junction', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_83d63d6182', 3, N'10', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_83d63d6182', 4, N'81507', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_83d63d6182', 5, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_83d63d6182', 8, N'39', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_83d63d6182', 10, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_83d63d6182', 14, N'14', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_83d63d6182', 14, N'18', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_83d63d6182', 14, N'21', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_83d63d6182', 15, N'K_83d63d6182', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_83d63d6182', 16, N'9999999995', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_48e8993269', 1, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_48e8993269', 2, N'Cedarhurst', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_48e8993269', 3, N'51', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_48e8993269', 4, N'11516', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_48e8993269', 5, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_48e8993269', 8, N'15', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_48e8993269', 8, N'19', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_48e8993269', 8, N'24', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_48e8993269', 10, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_48e8993269', 15, N'K_48e8993269', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_48e8993269', 16, N'9999999996', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_7b82b67b34', 1, N'2', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_7b82b67b34', 2, N'Coppell', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_7b82b67b34', 3, N'69', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_7b82b67b34', 4, N'75019', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_7b82b67b34', 5, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_7b82b67b34', 10, N'12', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_7b82b67b34', 15, N'K_7b82b67b34', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_7b82b67b34', 16, N'9999999997', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_ac0d9c8d23', 1, N'2', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_ac0d9c8d23', 2, N'Compton', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_ac0d9c8d23', 3, N'21', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_ac0d9c8d23', 4, N'61318', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_ac0d9c8d23', 5, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_ac0d9c8d23', 8, N'27', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_ac0d9c8d23', 8, N'58', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_ac0d9c8d23', 8, N'65', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_ac0d9c8d23', 10, N'15', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_ac0d9c8d23', 15, N'K_ac0d9c8d23', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_ac0d9c8d23', 16, N'9999999998', 1, 9, 1)
GO
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_rreoggymvc', 1, N'2', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_rreoggymvc', 2, N'Rockwell', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_rreoggymvc', 3, N'39', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_rreoggymvc', 4, N'28138', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_rreoggymvc', 5, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_rreoggymvc', 10, N'3', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_rreoggymvc', 15, N'K_rreoggymvc', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_rreoggymvc', 16, N'9999999999', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_rreoggyqwe', 1, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_rreoggyrty', 1, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_rreoggyuio', 1, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_rreoggypas', 1, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_rreoggysdf', 1, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_rreoggyghj', 1, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_rreoggyklz', 1, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_neoggyklz', 1, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_asoggyklz', 1, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_bcxoggyklz', 1, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_lfoggyklz', 1, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_lfodfgyklz', 1, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_lfoddfgyklz', 1, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_lfoddfdfgklz', 1, N'1', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_lfvvdfdfgklz', 1, N'2', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_lfofdgklz', 1, N'1', 2, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_lfofdgfc', 1, N'2', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_lffddgfc', 1, N'2', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_ldddgfc', 1, N'2', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_ldddgffdg', 1, N'2', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_lddddgffdg', 1, N'2', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_gddddgffdg', 1, N'2', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_dddgffdg', 1, N'2', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_dddgfdg', 1, N'2', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_ddfdg', 1, N'2', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_ddgfdg', 1, N'2', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_dddfdg', 1, N'2', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_dddfdsg', 1, N'2', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_dddfg', 1, N'2', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_dddfsd', 1, N'2', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_dcbvbgfsd', 1, N'2', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_dcbvsdxfsd', 1, N'2', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_mmlpvsdxfsd', 1, N'2', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'L_mmlpvsdxfsd', 1, N'2', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'L_mdsdxfsd', 1, N'2', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'L_mposdxfsd', 1, N'2', 1, 9, 1)
INSERT [dbo].[PanelistMaster] ([Identifier], [DataPointId], [OptionId], [Active], [PanelId], [SurveyCompletionCount]) VALUES (N'K_rreoggymvc', 15, N'K_rreoggymvc', 1, 15, NULL)
SET IDENTITY_INSERT [dbo].[Project] ON 

INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (2, N'1-Universal Test Project', 3, 10, N'https://api.tester.com/surveys/100?id=', 1, CAST(N'2015-07-27 11:49:34.683' AS DateTime), NULL, 4402, CAST(N'2015-07-31 08:44:49.413' AS DateTime), 3, NULL, N'', 3, NULL, NULL, N'SCH Survey', N'Panel Survey', N'200', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (3, N'Test SHC 1', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=', 2, CAST(N'2015-07-29 10:50:13.073' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15285', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (4, N'Test SHC 1', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=', 2, CAST(N'2015-07-29 10:56:40.617' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15285', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (5, N'Test SHC 1', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=', 2, CAST(N'2015-07-29 10:56:49.443' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15285', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (6, N'Test SHC 1', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=', 2, CAST(N'2015-07-29 11:25:11.727' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15285', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (7, N'Test SHC 1', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=', 2, CAST(N'2015-07-29 11:25:59.863' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15285', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (8, N'Test SHC 1', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=', 2, CAST(N'2015-07-29 11:27:17.530' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15285', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (9, N'Test SHC 1', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=', 2, CAST(N'2015-07-29 11:42:15.457' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15285', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (10, N'Test SHC 1', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=', 2, CAST(N'2015-07-29 11:44:21.077' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15285', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (11, N'Test SHC 1', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=', 2, CAST(N'2015-07-29 11:45:28.270' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15285', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (12, N'Test SHC 1', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=', 2, CAST(N'2015-07-29 11:46:24.880' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15285', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (13, N'Test SHC 1', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=', 1, CAST(N'2015-07-29 11:47:06.833' AS DateTime), NULL, 4422, CAST(N'2015-08-03 04:17:19.300' AS DateTime), 3, NULL, N'', 1, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15285', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (14, N'Test SHC 1', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=', 1, CAST(N'2015-07-29 11:51:24.717' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15285', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (15, N'Test SHC 1', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=', 2, CAST(N'2015-07-29 12:46:58.387' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15285', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (16, N'Test SHC 1', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=', 2, CAST(N'2015-07-29 12:53:08.097' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15285', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (17, N'Test SHC 1', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=', 2, CAST(N'2015-07-29 12:53:38.520' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15285', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (18, N'Test SHC 1', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=', 2, CAST(N'2015-07-29 12:56:50.793' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15285', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (19, N'Test SHC 1', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=', 2, CAST(N'2015-07-29 12:59:29.850' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15285', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (20, N'Bens Test Project', 3, 10, N'http://incrowdnow.com', 2, CAST(N'2015-07-29 13:39:27.770' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'SCH Survey', N'Panel Survey', N'200', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (21, N'Bens Test Project', 3, 10, N'http://incrowdnow.com', 2, CAST(N'2015-07-29 13:42:27.647' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'SCH Survey', N'Panel Survey', N'200', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (22, N'SHC 1', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3717&crowdId=3600&providerId=16&lang=en&thirdPartyResponderId=', 2, CAST(N'2015-07-30 15:04:02.520' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15073', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (23, N'SHC 1', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3717&crowdId=3600&providerId=16&lang=en&thirdPartyResponderId=', 2, CAST(N'2015-07-30 15:05:43.207' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15073', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (24, N'SHC 1', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3717&crowdId=3600&providerId=16&lang=en&thirdPartyResponderId=', 1, CAST(N'2015-07-30 15:19:57.873' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15073', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (25, N'SHC 1', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3717&crowdId=3600&providerId=16&lang=en&thirdPartyResponderId=', 2, CAST(N'2015-07-30 15:32:16.923' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15073', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (26, N'SHC 1', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3717&crowdId=3600&providerId=16&lang=en&thirdPartyResponderId=', 2, CAST(N'2015-07-30 15:34:19.147' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15073', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (27, N'SHC 1', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3717&crowdId=3600&providerId=16&lang=en&thirdPartyResponderId=', 2, CAST(N'2015-07-30 15:38:07.067' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15073', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (28, N'SHC 1', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3717&crowdId=3600&providerId=16&lang=en&thirdPartyResponderId=', 2, CAST(N'2015-07-30 15:40:57.653' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15073', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (29, N'SHC 1', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3717&crowdId=3600&providerId=16&lang=en&thirdPartyResponderId=', 2, CAST(N'2015-07-30 15:41:29.197' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15073', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (30, N'SHC 1', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3717&crowdId=3600&providerId=16&lang=en&thirdPartyResponderId=', 2, CAST(N'2015-07-30 15:41:49.080' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15073', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (31, N'SHC 1', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3717&crowdId=3600&providerId=16&lang=en&thirdPartyResponderId=', 2, CAST(N'2015-07-30 15:42:16.830' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15073', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (32, N'SHC 1', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3717&crowdId=3600&providerId=16&lang=en&thirdPartyResponderId=', 1, CAST(N'2015-07-30 15:55:35.143' AS DateTime), NULL, 4420, NULL, 2, NULL, N'Campaign class internal error', 5, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15073', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (33, N'BSC SHC 1', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=', 1, CAST(N'2015-07-31 13:08:04.730' AS DateTime), NULL, 4432, CAST(N'2015-07-31 13:11:03.173' AS DateTime), 2, NULL, N'Campaign class internal error', 5, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15285', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (34, N'BSC SHC 1', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=', 1, CAST(N'2015-07-31 13:10:30.413' AS DateTime), NULL, 4433, CAST(N'2015-07-31 13:36:03.083' AS DateTime), 2, NULL, N'Campaign class internal error', 5, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15285', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (35, N'BSC SHC 2', 4, 70, N'http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=', 1, CAST(N'2015-07-31 13:31:11.357' AS DateTime), NULL, 4434, CAST(N'2015-07-31 14:01:03.067' AS DateTime), 2, NULL, N'Campaign class internal error', 5, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15285', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (36, N'BSC SHC 3', 1, 70, N'http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 4, CAST(N'2015-08-03 16:39:24.010' AS DateTime), NULL, 4442, CAST(N'2015-08-03 16:41:01.170' AS DateTime), 3, NULL, N'', NULL, 1, NULL, N'You''re invited to respond!', N'Health Care', N'15285', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (37, N'BSC SHC TEST 3', 1, 70, N'http://localhost:3001/answer/?thirdParty=true&surveyId=3748&crowdId=3626&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 2, CAST(N'2015-08-04 10:48:40.693' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15286', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (38, N'BSC SHC TEST 3', 1, 70, N'http://localhost:3001/answer/?thirdParty=true&surveyId=3748&crowdId=3626&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 2, CAST(N'2015-08-04 10:50:32.703' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15286', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (39, N'BSC SHC TEST 3', 1, 70, N'http://localhost:3001/answer/?thirdParty=true&surveyId=3748&crowdId=3626&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 2, CAST(N'2015-08-04 10:53:25.460' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15286', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (40, N'BSC SHC TEST 3', 1, 70, N'http://localhost:3001/answer/?thirdParty=true&surveyId=3748&crowdId=3626&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 1, CAST(N'2015-08-04 10:54:26.057' AS DateTime), NULL, 4447, CAST(N'2015-08-04 10:56:01.163' AS DateTime), 3, NULL, N'', NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15286', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (41, N'SHC test 4', 1, 70, N'http://localhost:3001/answer/?thirdParty=true&surveyId=3749&crowdId=3626&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 3, CAST(N'2015-08-04 11:05:32.270' AS DateTime), NULL, 4448, CAST(N'2015-08-04 11:06:01.130' AS DateTime), 3, NULL, N'', NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15287', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (42, N'SHC TEST', 1, 70, N'http://localhost:3001/answer/?thirdParty=true&surveyId=3747&crowdId=3626&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 1, CAST(N'2015-08-05 11:32:20.923' AS DateTime), NULL, 4459, CAST(N'2015-08-05 11:36:01.170' AS DateTime), 3, NULL, N'', NULL, NULL, NULL, N'TODO Define subject', N'TODO Define topic', N'15287', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (43, N'Test Survey', 3, 70, N'http://localhost:3001/answer/?thirdParty=true&surveyId=3837&crowdId=1031&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 1, CAST(N'2015-08-18 09:45:03.590' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'15930', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (44, N'Test Survey', 3, 70, N'http://localhost:3001/answer/?thirdParty=true&surveyId=3837&crowdId=1031&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 1, CAST(N'2015-08-19 10:44:59.083' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'15930', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (45, N'Test Survey', 3, 70, N'http://localhost:3001/answer/?thirdParty=true&surveyId=3837&crowdId=1031&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 1, CAST(N'2015-08-19 10:45:38.137' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'15930', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (46, N'Test Survey', 3, 70, N'http://localhost:3001/answer/?thirdParty=true&surveyId=3837&crowdId=1031&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 1, CAST(N'2015-08-19 10:47:24.360' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'15930', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (47, N'Test Survey', 3, 70, N'http://localhost:3001/answer/?thirdParty=true&surveyId=3837&crowdId=1031&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 1, CAST(N'2015-08-19 10:48:19.223' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'15930', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (48, N'Testing SHC', 1, 70, N'http://localhost:3001/answer/?thirdParty=true&surveyId=3838&crowdId=1031&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 3, CAST(N'2015-08-24 16:36:05.903' AS DateTime), NULL, 4572, NULL, 3, NULL, N'', NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'15931', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (49, N'title', 1, 70, N'http://localhost:3001/answer/?thirdParty=true&surveyId=3839&crowdId=1031&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 3, CAST(N'2015-08-25 12:41:43.607' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'15932', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (50, N'test', 1, 70, N'http://localhost:3001/answer/?thirdParty=true&surveyId=3840&crowdId=1031&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 1, CAST(N'2015-08-25 12:45:39.823' AS DateTime), NULL, 4575, NULL, 3, NULL, N'', NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'15933', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (51, N'121', 10, 100, N'http://ss.opinionsite.com?id=', 2, CAST(N'2015-08-31 04:09:24.180' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST 7 SURVEY4', N'test  sch tes3', N'100', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (52, N'121', 10, 100, N'http://ss.opinionsite.com?id=', 2, CAST(N'2015-08-31 04:09:46.040' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST 7 SURVEY4', N'test  sch tes3', N'100', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (53, N'121', 10, 100, N'http://ss.opinionsite.com?id=', 2, CAST(N'2015-08-31 04:20:33.790' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST 7 SURVEY4', N'test  sch tes3', N'100', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (54, N'121', 10, 100, N'http://ss.opinionsite.com?id=', 2, CAST(N'2015-08-31 05:02:50.613' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'TEST 7 SURVEY4', N'test  sch tes3', N'100', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (55, N'this is a test survey', 1, 0, N'https://web-qa.incrowdanswers.com/answer/?thirdParty=true&surveyId=3887&crowdId=1031&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 2, CAST(N'2015-08-31 09:32:10.757' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'16033', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (56, N'test SHC reminders', 1, 70, N'http://localhost:3001/answer/?thirdParty=true&surveyId=3841&crowdId=1031&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 3, CAST(N'2015-08-31 10:41:12.023' AS DateTime), NULL, 4599, NULL, 3, NULL, N'', NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'15934', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (57, N'test shc reminders 2', 1, 70, N'http://localhost:3001/answer/?thirdParty=true&surveyId=3842&crowdId=1031&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 1, CAST(N'2015-08-31 11:07:20.257' AS DateTime), NULL, 4602, NULL, 3, NULL, N'', NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'15935', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (58, N'this is a test survey', 1, 0, N'https://web-qa.incrowdanswers.com/answer/?thirdParty=true&surveyId=3887&crowdId=1031&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 2, CAST(N'2015-08-31 13:38:34.710' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'16033', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (59, N'test shc reminders 2', 1, 70, N'http://localhost:3001/answer/?thirdParty=true&surveyId=3842&crowdId=1031&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 1, CAST(N'2015-08-31 14:02:06.710' AS DateTime), NULL, 4603, NULL, 3, NULL, N'', NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'15935', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (60, N'test shc reminders 2', 1, 70, N'http://localhost:3001/answer/?thirdParty=true&surveyId=3842&crowdId=1031&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 1, CAST(N'2015-08-31 14:03:07.547' AS DateTime), NULL, 4604, NULL, 3, NULL, N'', NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'15935', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (61, N'Wesley 1', 10, 10, N'https://www.google.com/?q=fuzzy+bunnies', 2, CAST(N'2015-09-09 10:56:22.413' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Fast Survey for Medical Professionals', N'Your Expertise Required! Fabulous Rewards Promised!', N'10028', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (62, N'Wesley 2', 10, 100, N'https://www.google.com/?q=fuzzy+bunnies', 2, CAST(N'2015-09-09 11:02:02.497' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Fast Survey for Medical Professionals', N'Your Expertise Required! Fabulous Rewards Promised!', N'10029', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (63, N'Wesley 3', 10, 100, N'https://www.google.com/?q=fuzzy+bunnies', 2, CAST(N'2015-09-09 11:26:39.503' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Fast Survey for Medical Professionals', N'Your Expertise Required! Fabulous Rewards Promised!', N'10030', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (64, N'Wesley 4', 10, 100, N'https://www.google.com/?q=fuzzy+bunnies', 2, CAST(N'2015-09-09 11:36:02.863' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Fast Survey for Medical Professionals', N'Your Expertise Required! Fabulous Rewards Promised!', N'10031', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (65, N'Wesley 5', 10, 100, N'https://www.google.com/?q=fuzzy+bunnies', 2, CAST(N'2015-09-09 11:37:06.327' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Fast Survey for Medical Professionals', N'Your Expertise Required! Fabulous Rewards Promised!', N'10032', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (66, N'Wesley 6', 10, 100, N'https://www.google.com/?q=fuzzy+bunnies', 2, CAST(N'2015-09-09 11:38:34.603' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Fast Survey for Medical Professionals', N'Your Expertise Required! Fabulous Rewards Promised!', N'10033', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (67, N'Wesley 7', 10, 100, N'https://www.google.com/?q=fuzzy+bunnies', 2, CAST(N'2015-09-09 13:40:55.043' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Fast Survey for Medical Professionals', N'Your Expertise Required! Fabulous Rewards Promised!', N'10034', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (68, N'Wesley 8', 10, 100, N'https://www.google.com/?q=fuzzy+bunnies', 2, CAST(N'2015-09-09 13:43:23.550' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Fast Survey for Medical Professionals', N'Your Expertise Required! Fabulous Rewards Promised!', N'10035', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (69, N'Wesley 10', 10, 100, N'https://www.google.com/?q=fuzzy+bunnies', 2, CAST(N'2015-09-09 13:53:52.753' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Fast Survey for Medical Professionals', N'Your Expertise Required! Fabulous Rewards Promised!', N'20034', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (70, N'Wesley 11', 10, 100, N'https://www.google.com/?q=fuzzy+bunnies', 2, CAST(N'2015-09-09 13:59:24.727' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Fast Survey for Medical Professionals', N'Your Expertise Required! Fabulous Rewards Promised!', N'20035', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (71, N'Wesley 12', 10, 100, N'https://www.google.com/?q=fuzzy+bunnies', 2, CAST(N'2015-09-09 14:07:03.777' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Fast Survey for Medical Professionals', N'Your Expertise Required! Fabulous Rewards Promised!', N'20036', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (72, N'Wesley 13', 10, 100, N'https://www.google.com/?q=fuzzy+bunnies', 2, CAST(N'2015-09-09 14:08:33.417' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Fast Survey for Medical Professionals', N'Your Expertise Required! Fabulous Rewards Promised!', N'20037', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (73, N'Wesley 20', 10, 100, N'https://www.google.com/?q=fuzzy+bunnies', 2, CAST(N'2015-09-10 09:45:38.537' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Fast Survey for Medical Professionals', N'Your Expertise Required! Fabulous Rewards Promised!', N'30034', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (74, N'Wesley 21', 10, 100, N'https://www.google.com/?q=fuzzy+bunnies', 2, CAST(N'2015-09-10 09:47:01.100' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Fast Survey for Medical Professionals', N'Your Expertise Required! Fabulous Rewards Promised!', N'30035', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (75, N'Wesley 22', 10, 100, N'https://www.google.com/?q=fuzzy+bunnies', 2, CAST(N'2015-09-10 09:48:15.010' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Fast Survey for Medical Professionals', N'Your Expertise Required! Fabulous Rewards Promised!', N'30036', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (76, N'Wesley 23', 10, 100, N'https://www.google.com/?q=fuzzy+bunnies', 2, CAST(N'2015-09-10 09:49:21.290' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Fast Survey for Medical Professionals', N'Your Expertise Required! Fabulous Rewards Promised!', N'30037', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (77, N'Wesley 24', 10, 100, N'https://www.google.com/?q=fuzzy+bunnies', 2, CAST(N'2015-09-10 12:15:18.747' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Fast Survey for Medical Professionals', N'Your Expertise Required! Fabulous Rewards Promised!', N'30038', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (78, N'Wesley 30', 10, 100, N'https://www.google.com/?q=fuzzy+bunnies', 2, CAST(N'2015-09-11 10:16:36.080' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Fast Survey for Medical Professionals', N'Your Expertise Required! Fabulous Rewards Promised!', N'40034', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (79, N'Wesley 30', 10, 100, N'https://www.google.com/?q=fuzzy+bunnies', 2, CAST(N'2015-09-11 10:16:49.337' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Fast Survey for Medical Professionals', N'Your Expertise Required! Fabulous Rewards Promised!', N'40034', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (80, N'Wesley 31', 10, 100, N'https://www.google.com/?q=fuzzy+bunnies', 2, CAST(N'2015-09-11 10:20:27.500' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Fast Survey for Medical Professionals', N'Your Expertise Required! Fabulous Rewards Promised!', N'40035', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (81, N'Wesley 32', 10, 100, N'https://www.google.com/?q=fuzzy+bunnies', 2, CAST(N'2015-09-11 10:21:29.720' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Fast Survey for Medical Professionals', N'Your Expertise Required! Fabulous Rewards Promised!', N'30036', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (82, N'Wesley 33', 10, 100, N'https://www.google.com/?q=fuzzy+bunnies', 2, CAST(N'2015-09-11 10:22:28.947' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Fast Survey for Medical Professionals', N'Your Expertise Required! Fabulous Rewards Promised!', N'40037', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (83, N'T-Vec Concept Survey', 8, 0, N'http://localhost:3001/answer/?thirdParty=true&surveyId=3959&crowdId=3745&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 2, CAST(N'2015-09-14 15:02:40.983' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'16398', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (84, N'T-Vec Concept Survey', 8, 0, N'http://localhost:3001/answer/?thirdParty=true&surveyId=3959&crowdId=3745&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 2, CAST(N'2015-09-14 15:03:57.303' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'16398', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (85, N'T-Vec Concept Survey', 8, 0, N'http://localhost:3001/answer/?thirdParty=true&surveyId=3959&crowdId=3745&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 2, CAST(N'2015-09-14 15:25:49.093' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'16398', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (86, N'T-Vec Concept Survey', 8, 0, N'http://localhost:3001/answer/?thirdParty=true&surveyId=3959&crowdId=3745&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 2, CAST(N'2015-09-14 15:27:49.963' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'16398', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (87, N'T-Vec Concept Survey', 8, 100, N'http://localhost:3001/answer/?thirdParty=true&surveyId=3959&crowdId=3745&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 2, CAST(N'2015-09-15 08:38:46.300' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'16398', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (88, N'T-Vec Concept Survey', 8, 0, N'http://localhost:3001/answer/?thirdParty=true&surveyId=3959&crowdId=3745&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 2, CAST(N'2015-09-15 08:57:12.313' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'16398', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (89, N'T-Vec Concept Survey', 8, 0, N'http://localhost:3001/answer/?thirdParty=true&surveyId=3959&crowdId=3745&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 2, CAST(N'2015-09-15 09:26:36.943' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'16398', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (90, N'T-Vec Concept Survey', 8, 0, N'http://localhost:3001/answer/?thirdParty=true&surveyId=3959&crowdId=3745&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 2, CAST(N'2015-09-15 09:57:48.660' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'16398', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (91, N'Payer Issues Questions Survey', 9, 10, N'http://localhost:3001/answer/?thirdParty=true&surveyId=3871&crowdId=3686&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 2, CAST(N'2015-09-16 09:13:48.567' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'16110', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (92, N'Payer Issues Questions Survey', 9, 10, N'http://localhost:3001/answer/?thirdParty=true&surveyId=3871&crowdId=3710&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 1, CAST(N'2015-09-16 09:16:59.467' AS DateTime), NULL, 4681, NULL, 2, NULL, N'', 5, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'16111', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (93, N'Payer Issues Questions Survey', 9, 10, N'http://localhost:3001/answer/?thirdParty=true&surveyId=3871&crowdId=3710&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 2, CAST(N'2015-09-16 10:10:10.950' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'16111', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (94, N'Test Project QA', 5, 10, N'http://lmgtfy.com/?q=fuzzy+bunnies', 2, CAST(N'2015-09-18 11:15:35.500' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'A Vital Study For Your Review', N'Fabulous Rewards Available! Click Now!', NULL, NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (95, N'QA Test 2', 5, 100, N'http://lmgtfy.com/?q=fuzzy+bunnies', 2, CAST(N'2015-09-18 11:32:45.940' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Survey', N'Click here', N'60011', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (96, N'20150918 TV Ad Recall - Wave 2', 5, 10, N'http://localhost:3001/answer/?thirdParty=true&surveyId=4008&crowdId=3779&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 1, CAST(N'2015-09-18 12:31:29.323' AS DateTime), NULL, 4698, NULL, 2, NULL, N'', 5, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'16703', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (97, N'Sample #3', 3, 10, N'https://web-qa.incrowdanswers.com/answer/?thirdParty=true&surveyId=3928&crowdId=2424&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 1, CAST(N'2015-09-28 14:06:18.623' AS DateTime), NULL, NULL, NULL, -1, NULL, N'Panel 9 not found', 5, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'16052', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (98, N'90-Day Prescription Survey', 6, 10, N'http://localhost:3001/answer/?thirdParty=true&surveyId=4072&crowdId=2794&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 1, CAST(N'2015-10-16 11:46:29.280' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'4072:2794:API', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (99, N'20150928 Psoriasis in Sensitive Skin Areas - Germany', 8, 10, N'http://localhost:3001/answer/?thirdParty=true&surveyId=4060&crowdId=3817&providerId=16&lang=de&projectId=[session_key]&thirdPartyResponderId=[identifier]', 1, CAST(N'2015-10-16 11:49:47.547' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'4060:3817:API', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (100, N'PCP Influenza Treatment Survey', 8, 10, N'http://localhost:3001/answer/?thirdParty=true&surveyId=4163&crowdId=826&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 1, CAST(N'2015-11-03 09:31:06.703' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'4163:826:API', NULL, NULL)
GO
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (101, N'PCP Influenza Treatment Survey', 8, 10, N'http://localhost:3001/answer/?thirdParty=true&surveyId=4163&crowdId=826&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 1, CAST(N'2015-11-03 09:32:00.057' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'4163:826:API', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (102, N'20151023 MDI v DPI Preferences - PUD', 5, 10, N'http://localhost:3001/answer/?thirdParty=true&surveyId=4180&crowdId=569&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 2, CAST(N'2015-11-03 09:36:28.310' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'4180:569:API', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (103, N'20151023 MDI v DPI Preferences - PUD', 5, 10, N'http://localhost:3001/answer/?thirdParty=true&surveyId=4180&crowdId=569&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 2, CAST(N'2015-11-03 09:37:30.797' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'4180:569:API', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (104, N'Neurotoxins  All kinds of creepsstuff', 4, 36, N'http://localhost:3001/answer/?thirdParty=true&surveyId=4400&crowdId=4133&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 2, CAST(N'2015-12-18 10:38:56.787' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'4400:4133:API', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (105, N'Neurotoxins+%26+All+kind%27s+of+creeps%2Fstuff', 4, 36, N'http://localhost:3001/answer/?thirdParty=true&surveyId=4400&crowdId=4134&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 1, CAST(N'2015-12-18 11:42:32.847' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'4400:4134:API', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (106, N'Things & This / That, The Other', 1, 100, N'http://localhost:3001/answer/?thirdParty=true&surveyId=4329&crowdId=4039&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 1, CAST(N'2015-12-18 12:59:11.500' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'4329:4039:API', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (107, N'20151214+HCV+Product+Launch+-+Brazil', 10, 30, N'http://localhost:3001/answer/?thirdParty=true&surveyId=4389&crowdId=4142&providerId=16&lang=pt&projectId=[session_key]&thirdPartyResponderId=[identifier]', 1, CAST(N'2015-12-21 11:33:52.370' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'4389:4142:API', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (108, N'Neurotoxins+%26+All+kind%27s+of+creeps%2Fstuff', 4, 36, N'http://localhost:3001/answer/?thirdParty=true&surveyId=4400&crowdId=4135&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 2, CAST(N'2015-12-21 11:41:39.517' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'4400:4135:API', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (109, N'20151214+HCV+Product+Launch+-+Brazil', 10, 70, N'http://localhost:3001/answer/?thirdParty=true&surveyId=4389&crowdId=4142&providerId=16&lang=pt&projectId=[session_key]&thirdPartyResponderId=[identifier]', 1, CAST(N'2015-12-21 13:27:17.307' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'4389:4142:API', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (110, N'This+%26+That+%2F+The+Other%2C+and+Some+More+%26', 1, 10, N'http://localhost:3001/answer/?thirdParty=true&surveyId=4332&crowdId=4039&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 1, CAST(N'2015-12-21 14:53:22.417' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'4332:4039:API', NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (111, N'20151228+Colon+Device+Survey', 10, 22, N'http://localhost:3001/answer/?thirdParty=true&surveyId=4441&crowdId=3062&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 1, CAST(N'2015-12-30 18:12:48.273' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey; Log In Now to Answer', N'Your Medical Expertise Requested', N'4441:3062:API', CAST(N'2015-12-30 18:12:48.933' AS DateTime), NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (112, N'20160425ThoughtsOnBrands', 2, 95, N'http://localhost:3001/answer/?thirdParty=true&surveyId=5058&crowdId=568&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 1, CAST(N'2016-05-05 11:08:36.667' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Five Minute Medical MicroSurvey Log In Now to Answer', N'Your Medical Expertise Requested', N'5058:568:API', CAST(N'2016-05-05 11:08:36.933' AS DateTime), NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectName], [LOI], [Incidence], [SurveyLink], [Status], [CreateDate], [RequestLogId], [KinesisProjectId], [KinesisProjectCreatedDate], [KinesisStatus], [KinesisProjectStatus], [KinesisAPIError], [ErrorRetryCount], [KinesisCloseStatus], [Panelld], [EmailSubject], [SurveyTopic], [ReferenceCode], [ActiveDate], [InactiveDate]) VALUES (113, N'20160425ThoughtsOnBrands', 2, 95, N'http://localhost:3001/answer/?thirdParty=true&surveyId=5058&crowdId=569&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]', 1, CAST(N'2016-05-05 11:58:24.837' AS DateTime), NULL, 4402, NULL, 3, NULL, N'Testing', NULL, NULL, NULL, N'Five Minute Medical MicroSurvey Log In Now to Answer', N'Your Medical Expertise Requested', N'5058:569:API', CAST(N'2016-05-05 11:58:25.073' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[Project] OFF
SET IDENTITY_INSERT [dbo].[QueryMaster] ON 

INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (1, 2, 10, N' (DataPointId = 1 AND OptionId IN(''1'') ) ', N'{"projectid":"2","reqn":"10","specialty":"1","querycondition":[{"datapointid":"1","datapointoptions":["1"]}]}', 1, CAST(N'2015-07-28 15:47:47.927' AS DateTime), 10, 5678, 1234, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, CAST(N'2016-07-25 11:51:12.280' AS DateTime), N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (2, 2, 5, N'(DataPointId = 1 AND OptionId IN(''1'',''2'') )', N'{"projectid":"2","reqn":"10","specialty":"1","querycondition":[{"datapointid":"1","datapointoptions":["1","2"]}]}', 1, CAST(N'2015-07-28 15:49:51.067' AS DateTime), 75, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'11-20', 3, 10, NULL, NULL, N'RewardB')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (3, 26, 10, N' (DataPointId = 1 AND OptionId IN(''1'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 5 AND OptionId IN(1)) ', N'{"projectid":"26","reqn":"10","specialty":"1","querycondition":[{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}]}', 1, CAST(N'2015-07-30 15:34:19.313' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (4, 27, 10, N' (DataPointId = 8 AND OptionId IN(''6'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 1 AND OptionId IN(1)) AND EXISTS (SELECT * FROM PanelistMaster P2 WHERE P.Identifier=P2.Identifier AND DataPointId = 5 AND OptionId IN(1)) ', N'{"projectid":"27","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}]}', 1, CAST(N'2015-07-30 15:38:07.297' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (5, 28, 10, N' (DataPointId = 8 AND OptionId IN(''6'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 1 AND OptionId IN(1)) AND EXISTS (SELECT * FROM PanelistMaster P2 WHERE P.Identifier=P2.Identifier AND DataPointId = 5 AND OptionId IN(1)) ', N'{"projectid":"28","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}]}', 1, CAST(N'2015-07-30 15:40:57.883' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (6, 29, 10, N' (DataPointId = 8 AND OptionId IN(''6'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 1 AND OptionId IN(1)) AND EXISTS (SELECT * FROM PanelistMaster P2 WHERE P.Identifier=P2.Identifier AND DataPointId = 5 AND OptionId IN(1)) ', N'{"projectid":"29","reqn":"10","specialty":"6","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}]}', 6, CAST(N'2015-07-30 15:41:29.333' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (7, 31, 10, N' (DataPointId = 8 AND OptionId IN(''6'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 1 AND OptionId IN(1)) AND EXISTS (SELECT * FROM PanelistMaster P2 WHERE P.Identifier=P2.Identifier AND DataPointId = 5 AND OptionId IN(1)) ', N'{"projectid":"31","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}]}', 1, CAST(N'2015-07-30 15:42:17.597' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (8, 13, 300, N' (DataPointId = 5 AND OptionId IN(''1'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 1 AND OptionId IN(1)) AND EXISTS (SELECT * FROM PanelistMaster P2 WHERE P.Identifier=P2.Identifier AND DataPointId = 8 AND OptionId IN(6,10)) ', N'{"projectid":"13","reqn":"300","specialty":"1","querycondition":[{"datapointid":"5","datapointoptions":["1"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"8","datapointoptions":["6","10"]}]}', 1, CAST(N'2015-07-30 15:54:31.177' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (9, 13, 300, N' (DataPointId = 8 AND OptionId IN(''6,10'') ) ', N'{"projectid":"13","reqn":"300","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6","10"]}]}', 1, CAST(N'2015-07-30 15:54:43.323' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (10, 32, 10, N' (DataPointId = 8 AND OptionId IN(''6'') ) ', N'{"projectid":"32","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]}]}', 1, CAST(N'2015-07-30 15:55:35.257' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (11, 13, 300, N' (DataPointId = 5 AND OptionId IN(''1'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 8 AND OptionId IN(6,10)) ', N'{"projectid":"13","reqn":"300","specialty":"1","querycondition":[{"datapointid":"5","datapointoptions":["1"]},{"datapointid":"8","datapointoptions":["6","10"]}]}', 1, CAST(N'2015-07-30 15:58:07.227' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (12, 13, 300, N' (DataPointId = 1 AND OptionId IN(''1'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 8 AND OptionId IN(6,10)) ', N'{"projectid":"13","reqn":"300","specialty":"1","querycondition":[{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"8","datapointoptions":["6","10"]}]}', 1, CAST(N'2015-07-30 15:58:17.513' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (13, 13, 300, N'', N'{"projectid":"13","reqn":"300","specialty":"3","querycondition":[]}', 3, CAST(N'2015-07-30 15:58:41.227' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (14, 13, 300, N' (DataPointId = 1 AND OptionId IN(''2'') ) ', N'{"projectid":"13","reqn":"300","specialty":"3","querycondition":[{"datapointid":"1","datapointoptions":["2"]}]}', 3, CAST(N'2015-07-30 15:59:26.000' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (15, 33, 10, N' (DataPointId = 8 AND OptionId IN(''6'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 1 AND OptionId IN(2)) AND EXISTS (SELECT * FROM PanelistMaster P2 WHERE P.Identifier=P2.Identifier AND DataPointId = 5 AND OptionId IN(1)) ', N'{"projectid":"33","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["2"]},{"datapointid":"5","datapointoptions":["1"]}]}', 1, CAST(N'2015-07-31 13:08:05.220' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (16, 34, 10, N' (DataPointId = 8 AND OptionId IN(''6'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 1 AND OptionId IN(2)) AND EXISTS (SELECT * FROM PanelistMaster P2 WHERE P.Identifier=P2.Identifier AND DataPointId = 5 AND OptionId IN(1)) ', N'{"projectid":"34","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["2"]},{"datapointid":"5","datapointoptions":["1"]}]}', 1, CAST(N'2015-07-31 13:10:30.517' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (17, 34, 300, N' (DataPointId = 1 AND OptionId IN(''2'') ) ', N'{"projectid":"34","reqn":"300","specialty":"3","querycondition":[{"datapointid":"1","datapointoptions":["2"]}]}', 3, CAST(N'2015-07-31 13:11:04.633' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (18, 35, 300, N' (DataPointId = 1 AND OptionId IN(''2'') ) ', N'{"projectid":"35","reqn":"300","specialty":"3","querycondition":[{"datapointid":"1","datapointoptions":["2"]}]}', 3, CAST(N'2015-07-31 13:31:23.867' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (19, 36, 300, N' (DataPointId = 1 AND OptionId IN(''2'') ) ', N'{"projectid":"36","reqn":"300","specialty":"3","querycondition":[{"datapointid":"1","datapointoptions":["2"]}]}', 3, CAST(N'2015-08-03 16:39:35.587' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (20, 40, 10, N' (DataPointId = 1 AND OptionId IN(''2'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 5 AND OptionId IN(1)) ', N'{"projectid":"40","reqn":"10","specialty":"3","querycondition":[{"datapointid":"1","datapointoptions":["2"]},{"datapointid":"5","datapointoptions":["1"]}]}', 3, CAST(N'2015-08-04 10:54:26.210' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (21, 41, 10, N' (DataPointId = 1 AND OptionId IN(''2'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 5 AND OptionId IN(1)) ', N'{"projectid":"41","reqn":"10","specialty":"3","querycondition":[{"datapointid":"1","datapointoptions":["2"]},{"datapointid":"5","datapointoptions":["1"]}]}', 3, CAST(N'2015-08-04 11:05:32.380' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (22, 42, 10, N' (DataPointId = 1 AND OptionId IN(''2'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 5 AND OptionId IN(1)) ', N'{"projectid":"42","reqn":"10","specialty":"3","querycondition":[{"datapointid":"1","datapointoptions":["2"]},{"datapointid":"5","datapointoptions":["1"]}]}', 3, CAST(N'2015-08-05 11:32:21.107' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (23, 43, 10, N' (DataPointId = 8 AND OptionId IN(''64,51,48,36,24'') ) ', N'{"projectid":"43","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["64","51","48","36","24"]}]}', 1, CAST(N'2015-08-18 09:45:03.793' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (24, 44, 10, N' (DataPointId = 8 AND OptionId IN(''64,51,48,36,24'') ) ', N'{"projectid":"44","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["64","51","48","36","24"]}]}', 1, CAST(N'2015-08-19 10:44:59.327' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (25, 45, 10, N' (DataPointId = 8 AND OptionId IN(''64,51,48,36,24'') ) ', N'{"projectid":"45","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["64","51","48","36","24"]}]}', 1, CAST(N'2015-08-19 10:45:38.210' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (26, 46, 10, N' (DataPointId = 8 AND OptionId IN(''64,51,48,36,24'') ) ', N'{"projectid":"46","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["64","51","48","36","24"]}]}', 1, CAST(N'2015-08-19 10:47:24.437' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (27, 47, 10, N' (DataPointId = 8 AND OptionId IN(''64,51,48,36,24'') ) ', N'{"projectid":"47","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["64","51","48","36","24"]}]}', 1, CAST(N'2015-08-19 10:48:19.310' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (28, 35, 300, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) ', N'{"projectid":"35","reqn":"300","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}]}', 3, CAST(N'2015-08-24 15:24:23.560' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (29, 48, 10, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) ', N'{"projectid":"48","reqn":"10","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}]}', 3, CAST(N'2015-08-24 16:36:06.100' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (30, 49, 1, N' (DataPointId = 8 AND OptionId IN(''64,51,48,36,24'') ) ', N'{"projectid":"49","reqn":"1","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["64","51","48","36","24"]}]}', 1, CAST(N'2015-08-25 12:41:43.810' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (31, 50, 1, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) ', N'{"projectid":"50","reqn":"1","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}]}', 3, CAST(N'2015-08-25 12:45:40.010' AS DateTime), 10, 73847, 11419, 1, CAST(N'2015-08-31 11:05:33.920' AS DateTime), 1, CAST(N'2015-08-31 02:51:00.887' AS DateTime), 2, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (32, 56, 10, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) ', N'{"projectid":"56","reqn":"10","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}]}', 3, CAST(N'2015-08-31 10:41:12.193' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (33, 57, 10, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) ', N'{"projectid":"57","reqn":"10","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}]}', 3, CAST(N'2015-08-31 11:07:20.347' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (34, 59, 10, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) ', N'{"projectid":"59","reqn":"10","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}]}', 3, CAST(N'2015-08-31 14:02:07.107' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (35, 60, 10, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) ', N'{"projectid":"60","reqn":"10","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}]}', 3, CAST(N'2015-08-31 14:03:07.653' AS DateTime), 10, 74292, 11492, 1, CAST(N'2015-08-31 14:07:34.327' AS DateTime), 1, CAST(N'2015-08-31 14:11:00.960' AS DateTime), NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (36, 61, 50, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) ', N'{"projectid":"61","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', 3, CAST(N'2015-09-09 10:58:40.303' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (37, 61, 50, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''9999999999'')) ', N'{"projectid":"61","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["9999999999"]}', 3, CAST(N'2015-09-09 11:00:25.573' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (38, 62, 50, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) ', N'{"projectid":"62","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', 3, CAST(N'2015-09-09 11:03:00.897' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (39, 62, 50, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''9999999999'')) ', N'{"projectid":"62","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["9999999999"]}', 3, CAST(N'2015-09-09 11:03:29.230' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (40, 62, 50, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''9999999998'')) ', N'{"projectid":"62","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["9999999998"]}', 3, CAST(N'2015-09-09 11:25:49.307' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (41, 62, 50, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) ', N'{"projectid":"62","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', 3, CAST(N'2015-09-09 11:26:01.557' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (42, 64, 50, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''9999999998'')) ', N'{"projectid":"64","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["9999999998"]}', 3, CAST(N'2015-09-09 11:36:30.650' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (43, 65, 50, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''9999999999'')) ', N'{"projectid":"65","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["9999999999"]}', 3, CAST(N'2015-09-09 11:37:31.987' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (44, 66, 50, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''9999999999'')) ', N'{"projectid":"66","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["9999999999"]}', 3, CAST(N'2015-09-09 11:38:58.560' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (45, 67, 50, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) ', N'{"projectid":"67","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', 3, CAST(N'2015-09-09 13:41:21.300' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (46, 67, 50, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) ', N'{"projectid":"67","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":null}', 3, CAST(N'2015-09-09 13:42:46.180' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (47, 68, 50, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''9999999999'')) ', N'{"projectid":"68","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["9999999999"]}', 3, CAST(N'2015-09-09 13:43:52.247' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (48, 69, 50, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) ', N'{"projectid":"69","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":null}', 3, CAST(N'2015-09-09 13:54:59.520' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (49, 70, 50, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) ', N'{"projectid":"70","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', 3, CAST(N'2015-09-09 14:01:38.870' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (50, 70, 50, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''9999999999'')) ', N'{"projectid":"70","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["9999999999"]}', 3, CAST(N'2015-09-09 14:07:26.937' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (51, 72, 50, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''9999999998'')) ', N'{"projectid":"72","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["9999999998"]}', 3, CAST(N'2015-09-09 14:08:58.623' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (52, 73, 50, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) ', N'{"projectid":"73","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":null}', 3, CAST(N'2015-09-10 09:46:01.903' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (53, 74, 50, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) ', N'{"projectid":"74","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', 3, CAST(N'2015-09-10 09:47:36.700' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (54, 75, 50, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''9999999998'')) ', N'{"projectid":"75","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["9999999998"]}', 3, CAST(N'2015-09-10 09:48:47.480' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (55, 76, 50, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''9999999999'')) ', N'{"projectid":"76","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["9999999999"]}', 3, CAST(N'2015-09-10 09:50:01.920' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (56, 76, 50, N'', N'{"projectid":"76","reqn":"50","specialty":"3","querycondition":[],"exclusions":null}', 3, CAST(N'2015-09-10 12:15:55.680' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (57, 77, 50, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'',''K_ac0d9c8d23'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''9999999999'')) ', N'{"projectid":"77","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc","K_ac0d9c8d23"]}],"exclusions":["9999999999"]}', 3, CAST(N'2015-09-10 12:17:37.367' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (58, 79, 50, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) ', N'{"projectid":"79","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":null}', 3, CAST(N'2015-09-11 10:19:37.640' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (59, 80, 50, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) ', N'{"projectid":"80","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', 3, CAST(N'2015-09-11 10:20:56.113' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (60, 81, 50, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''9999999998'')) ', N'{"projectid":"81","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["9999999998"]}', 3, CAST(N'2015-09-11 10:21:57.613' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (61, 82, 50, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''9999999999'')) ', N'{"projectid":"82","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["9999999999"]}', 3, CAST(N'2015-09-11 10:22:50.167' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (62, 83, 92, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) ', N'{"projectid":"83","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', 3, CAST(N'2015-09-14 15:02:41.143' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (63, 84, 92, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) ', N'{"projectid":"84","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', 3, CAST(N'2015-09-14 15:03:59.703' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (64, 84, 92, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) ', N'{"projectid":"84","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', 3, CAST(N'2015-09-14 15:05:51.370' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (65, 83, 92, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) ', N'{"projectid":"83","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', 3, CAST(N'2015-09-14 15:15:41.433' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (66, 80, 92, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) ', N'{"projectid":"80","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', 3, CAST(N'2015-09-14 15:15:48.600' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (67, 81, 92, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) ', N'{"projectid":"81","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', 3, CAST(N'2015-09-14 15:16:01.610' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (68, 82, 92, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) ', N'{"projectid":"82","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', 3, CAST(N'2015-09-14 15:16:09.647' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (69, 83, 92, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) ', N'{"projectid":"83","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', 3, CAST(N'2015-09-14 15:16:16.680' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (70, 83, 92, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) ', N'{"projectid":"83","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', 3, CAST(N'2015-09-14 15:16:31.540' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (71, 85, 92, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''1285634196'','''','''','''',''1659484145'',''1205896362'','''',''1790778793'','''',''1881667137'',''1689650327'',''1265472849'',''1255375135'',''1417927732'','''',''1487811931	'','''',''1003801853'',''1689686677'',''1235179839'',''1811934680'',''1669687299'',''1205948288'',''1356315303'',''1164403127'',''1902830888'',''1902830888'',''1902830888'',''1134143506'','''','''',''1104998194'','''','''',''1316942170'',''1285770925'',''1053419192'',''1083630834'','''',''1598711251'','''','''','''',''1053336354'','''',''1497719959'','''',''1689684524'',''1033145701'',''1043316615'',''1134172364'',''1770578031'',''1790878809'',''1619101268'','''',''1972529717'','''',''1346238284'','''',''1841293933'',''1366415804'',''1295819357'',''1265427496'',''1730175266'','''',''1629064605'',''1003093600'',''1427011444'',''1790725125'','''',''1144228966'',''1992898977'',''1750376380'',''1144250739'',''4631256798'',''1467720045'',''1376645838'',''1134115397'',''1275546038'',''1992762108'',''1992762108'',''016027204185'',''495167700147'','''',''1144338161'',''umpa'',''Health first cardiology'',''1902824287 '',''AK3205285'',''1932157302'',''1710071717'',''1104828300'',''1083656821'',''1073680393'',''1306830682'',''1760504351'',''1376659813'',''1457387888'',''1720190986'',''1821094665'',''1174525778'',''1003837873'',''1942296140'',''1083766729'',''1578670154'',''1508035163'',''1871546523'',''1912997321'',''1386640522'',''1356360887'',''1427254432'',''1235227133'',''1669574976'',''NA'',''1184652638'',''1730137688'',''NA'',''Na'',''1982631966'',''NA'',''1780603860'',''1780651497'',''1679747950'',''1588690440'',''1063495893'',''1710967153'',''1649360447'',''1578572327'',''1902924152'',''1831172840'',''1558362152'',''1265446371'',''1467482703'',''1922070291'',''1497742381'',''1962460501'',''1023061850'',''1881695302'',''1437166394'',''1104822261'',''1225063902'',''1376569061'',''1295739274'',''1316912918'',''1255313540'',''1477635084'',''1982795894'',''1144288069'',''1164494563'',''1295765659'',''1659310761'',''1447342951'',''1639141229'',''Penn Medicine Valley Forge'',''1275786352'',''1609849256'',''1376675637'',''1790784395'',''1619987930'',''1811959869'',''1003961764'',''1366514259'',''1922088517'',''1306840210'',''1093714743'',''1225057532'',''1861589269'',''1992725071'',''1003914227'',''1669558508'',''1427039247'',''1407823578'',''1396788022'',''1396788022'',''1841277373'',''1750377545'',''1780796417'',''1598737223'',''1467673467'',''1144399718'',''1205928876'',''1114975737'',''1750476115'',''1114998986'',''1184604274'',''1356443451'',''1821065574'',''1699731851'',''1912103052'',''1861485104'',''1234'',''1912941345'',''1851309629'',''1346220019'',''1407041064'',''1649372319'',''1871594887'',''1780763250'',''1790834281'',''1861497802'',''1114913142'',''1780609057'',''1780609057'',''1700913076'',''N/A'',''Refusal'',''1083677710'',''1558408260'',''1770502544'',''1336150234'',''1174586499'',''1568532927'',''1043272776'',''Refusal'',''Refusal'',''Refusal'',''1891832499'',''1417142597'',''1922325687'',''1104900216'',''1619130291'',''1861454423'',''1619928892'',''1851349757'',''Refusal'',''1447222831'',''1376679084'',''1700835196'',''1891720579'',''1841254885'',''1588685176'',''1205884178'',''1851359533'',''Refusal'',''1043246572'',''1942505490'',''1730160524'',''1073556288'',''1568591006'',''1780642272'',''1992785018'',''1982605721'',''1568456366'',''1366541302'',''1356544993'',''1407055296'',''REFUSAL'',''1538324645 '',''1174752554'',''1255308813'',''Refusal'',''1164476602'',''Private Practice'',''1922274364'',''1356377196'',''asdf'',''1902888365 '',''1538186382'',''Refusal'',''1770668758 '',''1568745016'',''1902823529'',''1447436126'',''1083892111'',''1053471110'',''1790726396'',''1811969041'',''1023065745'',''1760421564'',''1134297385'',''1669416160'',''30696 AZ.'',''Refusal'',''1639171606'',''1336343912'',''Refusal'',''1790834281'',''1346222353'',''1881680098'',''N/P'',''1003975673'',''1801861513'',''1053562470'',''1699772582'',''1417919499'',''1528089745'',''1356385330'',''1932143997'',''1497703367'',''1366493033'',''1003803412'',''None'',''1144279084'',''1013900851'',''1528012234'',''1538384250'',''1093880361'',''1275585846'',''1336296789'',''1205864550'',''1285781948'',''1134443112'',''1568558906'',''1215915012'',''1679520688'',''1447294699'',''1528070505'',''1558470112'',''1447333554'',''1366468894'',''1154494425'',''1962440701'',''1760696314'',''1356300222'',''1285913632'',''1023332079'',''1841516952'',''1215183934'',''5907859078'',''1225091812'',''1811055874'',''1508853052'',''1437120078'',''1457466518'',''1073558615'',''1881661601'',''1255303947'',''1811064785'',''1336206374'',''1215927900'',''1962546366'',''1851321442'')) ', N'{"projectid":"85","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["1285634196","","","","1659484145","1205896362","","1790778793","","1881667137","1689650327","1265472849","1255375135","1417927732","","1487811931\t","","1003801853","1689686677","1235179839","1811934680","1669687299","1205948288","1356315303","1164403127","1902830888","1902830888","1902830888","1134143506","","","1104998194","","","1316942170","1285770925","1053419192","1083630834","","1598711251","","","","1053336354","","1497719959","","1689684524","1033145701","1043316615","1134172364","1770578031","1790878809","1619101268","","1972529717","","1346238284","","1841293933","1366415804","1295819357","1265427496","1730175266","","1629064605","1003093600","1427011444","1790725125","","1144228966","1992898977","1750376380","1144250739","4631256798","1467720045","1376645838","1134115397","1275546038","1992762108","1992762108","016027204185","495167700147","","1144338161","umpa","Health first cardiology","1902824287 ","AK3205285","1932157302","1710071717","1104828300","1083656821","1073680393","1306830682","1760504351","1376659813","1457387888","1720190986","1821094665","1174525778","1003837873","1942296140","1083766729","1578670154","1508035163","1871546523","1912997321","1386640522","1356360887","1427254432","1235227133","1669574976","NA","1184652638","1730137688","NA","Na","1982631966","NA","1780603860","1780651497","1679747950","1588690440","1063495893","1710967153","1649360447","1578572327","1902924152","1831172840","1558362152","1265446371","1467482703","1922070291","1497742381","1962460501","1023061850","1881695302","1437166394","1104822261","1225063902","1376569061","1295739274","1316912918","1255313540","1477635084","1982795894","1144288069","1164494563","1295765659","1659310761","1447342951","1639141229","Penn Medicine Valley Forge","1275786352","1609849256","1376675637","1790784395","1619987930","1811959869","1003961764","1366514259","1922088517","1306840210","1093714743","1225057532","1861589269","1992725071","1003914227","1669558508","1427039247","1407823578","1396788022","1396788022","1841277373","1750377545","1780796417","1598737223","1467673467","1144399718","1205928876","1114975737","1750476115","1114998986","1184604274","1356443451","1821065574","1699731851","1912103052","1861485104","1234","1912941345","1851309629","1346220019","1407041064","1649372319","1871594887","1780763250","1790834281","1861497802","1114913142","1780609057","1780609057","1700913076","N/A","Refusal","1083677710","1558408260","1770502544","1336150234","1174586499","1568532927","1043272776","Refusal","Refusal","Refusal","1891832499","1417142597","1922325687","1104900216","1619130291","1861454423","1619928892","1851349757","Refusal","1447222831","1376679084","1700835196","1891720579","1841254885","1588685176","1205884178","1851359533","Refusal","1043246572","1942505490","1730160524","1073556288","1568591006","1780642272","1992785018","1982605721","1568456366","1366541302","1356544993","1407055296","REFUSAL","1538324645 ","1174752554","1255308813","Refusal","1164476602","Private Practice","1922274364","1356377196","asdf","1902888365 ","1538186382","Refusal","1770668758 ","1568745016","1902823529","1447436126","1083892111","1053471110","1790726396","1811969041","1023065745","1760421564","1134297385","1669416160","30696 AZ.","Refusal","1639171606","1336343912","Refusal","1790834281","1346222353","1881680098","N/P","1003975673","1801861513","1053562470","1699772582","1417919499","1528089745","1356385330","1932143997","1497703367","1366493033","1003803412","None","1144279084","1013900851","1528012234","1538384250","1093880361","1275585846","1336296789","1205864550","1285781948","1134443112","1568558906","1215915012","1679520688","1447294699","1528070505","1558470112","1447333554","1366468894","1154494425","1962440701","1760696314","1356300222","1285913632","1023332079","1841516952","1215183934","5907859078","1225091812","1811055874","1508853052","1437120078","1457466518","1073558615","1881661601","1255303947","1811064785","1336206374","1215927900","1962546366","1851321442"]}', 3, CAST(N'2015-09-14 15:25:49.233' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (72, 86, 92, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''1285634196'',''1659484145'',''1205896362'',''1790778793'',''1881667137'',''1689650327'',''1265472849'',''1255375135'',''1417927732'',''1487811931'',''1003801853'',''1689686677'',''1235179839'',''1811934680'',''1669687299'',''1205948288'',''1356315303'',''1164403127'',''1902830888'',''1902830888'',''1902830888'',''1134143506'',''1104998194'',''1316942170'',''1285770925'',''1053419192'',''1083630834'',''1598711251'',''1053336354'',''1497719959'',''1689684524'',''1033145701'',''1043316615'',''1134172364'',''1770578031'',''1790878809'',''1619101268'',''1972529717'',''1346238284'',''1841293933'',''1366415804'',''1295819357'',''1265427496'',''1730175266'',''1629064605'',''1003093600'',''1427011444'',''1790725125'',''1144228966'',''1992898977'',''1750376380'',''1144250739'',''4631256798'',''1467720045'',''1376645838'',''1134115397'',''1275546038'',''1992762108'',''1992762108'',''016027204185'',''495167700147'',''1144338161'',''umpa'',''Health first cardiology'',''1902824287'',''AK3205285'',''1932157302'',''1710071717'',''1104828300'',''1083656821'',''1073680393'',''1306830682'',''1760504351'',''1376659813'',''1457387888'',''1720190986'',''1821094665'',''1174525778'',''1003837873'',''1942296140'',''1083766729'',''1578670154'',''1508035163'',''1871546523'',''1912997321'',''1386640522'',''1356360887'',''1427254432'',''1235227133'',''1669574976'',''NA'',''1184652638'',''1730137688'',''NA'',''Na'',''1982631966'',''NA'',''1780603860'',''1780651497'',''1679747950'',''1588690440'',''1063495893'',''1710967153'',''1649360447'',''1578572327'',''1902924152'',''1831172840'',''1558362152'',''1265446371'',''1467482703'',''1922070291'',''1497742381'',''1962460501'',''1023061850'',''1881695302'',''1437166394'',''1104822261'',''1225063902'',''1376569061'',''1295739274'',''1316912918'',''1255313540'',''1477635084'',''1982795894'',''1144288069'',''1164494563'',''1295765659'',''1659310761'',''1447342951'',''1639141229'',''Penn Medicine Valley Forge'',''1275786352'',''1609849256'',''1376675637'',''1790784395'',''1619987930'',''1811959869'',''1003961764'',''1366514259'',''1922088517'',''1306840210'',''1093714743'',''1225057532'',''1861589269'',''1992725071'',''1003914227'',''1669558508'',''1427039247'',''1407823578'',''1396788022'',''1396788022'',''1841277373'',''1750377545'',''1780796417'',''1598737223'',''1467673467'',''1144399718'',''1205928876'',''1114975737'',''1750476115'',''1114998986'',''1184604274'',''1356443451'',''1821065574'',''1699731851'',''1912103052'',''1861485104'',''1234'',''1912941345'',''1851309629'',''1346220019'',''1407041064'',''1649372319'',''1871594887'',''1780763250'',''1790834281'',''1861497802'',''1114913142'',''1780609057'',''1780609057'',''1700913076'',''N/A'',''Refusal'',''1083677710'',''1558408260'',''1770502544'',''1336150234'',''1174586499'',''1568532927'',''1043272776'',''Refusal'',''Refusal'',''Refusal'',''1891832499'',''1417142597'',''1922325687'',''1104900216'',''1619130291'',''1861454423'',''1619928892'',''1851349757'',''Refusal'',''1447222831'',''1376679084'',''1700835196'',''1891720579'',''1841254885'',''1588685176'',''1205884178'',''1851359533'',''Refusal'',''1043246572'',''1942505490'',''1730160524'',''1073556288'',''1568591006'',''1780642272'',''1992785018'',''1982605721'',''1568456366'',''1366541302'',''1356544993'',''1407055296'',''REFUSAL'',''1538324645'',''1174752554'',''1255308813'',''Refusal'',''1164476602'',''Private Practice'',''1922274364'',''1356377196'',''asdf'',''1902888365'',''1538186382'',''Refusal'',''1770668758'',''1568745016'',''1902823529'',''1447436126'',''1083892111'',''1053471110'',''1790726396'',''1811969041'',''1023065745'',''1760421564'',''1134297385'',''1669416160'',''30696 AZ.'',''Refusal'',''1639171606'',''1336343912'',''Refusal'',''1790834281'',''1346222353'',''1881680098'',''N/P'',''1003975673'',''1801861513'',''1053562470'',''1699772582'',''1417919499'',''1528089745'',''1356385330'',''1932143997'',''1497703367'',''1366493033'',''1003803412'',''None'',''1144279084'',''1013900851'',''1528012234'',''1538384250'',''1093880361'',''1275585846'',''1336296789'',''1205864550'',''1285781948'',''1134443112'',''1568558906'',''1215915012'',''1679520688'',''1447294699'',''1528070505'',''1558470112'',''1447333554'',''1366468894'',''1154494425'',''1962440701'',''1760696314'',''1356300222'',''1285913632'',''1023332079'',''1841516952'',''1215183934'',''5907859078'',''1225091812'',''1811055874'',''1508853052'',''1437120078'',''1457466518'',''1073558615'',''1881661601'',''1255303947'',''1811064785'',''1336206374'',''1215927900'',''1962546366'',''1851321442'')) ', N'{"projectid":"86","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["1285634196","1659484145","1205896362","1790778793","1881667137","1689650327","1265472849","1255375135","1417927732","1487811931","1003801853","1689686677","1235179839","1811934680","1669687299","1205948288","1356315303","1164403127","1902830888","1902830888","1902830888","1134143506","1104998194","1316942170","1285770925","1053419192","1083630834","1598711251","1053336354","1497719959","1689684524","1033145701","1043316615","1134172364","1770578031","1790878809","1619101268","1972529717","1346238284","1841293933","1366415804","1295819357","1265427496","1730175266","1629064605","1003093600","1427011444","1790725125","1144228966","1992898977","1750376380","1144250739","4631256798","1467720045","1376645838","1134115397","1275546038","1992762108","1992762108","016027204185","495167700147","1144338161","umpa","Health first cardiology","1902824287","AK3205285","1932157302","1710071717","1104828300","1083656821","1073680393","1306830682","1760504351","1376659813","1457387888","1720190986","1821094665","1174525778","1003837873","1942296140","1083766729","1578670154","1508035163","1871546523","1912997321","1386640522","1356360887","1427254432","1235227133","1669574976","NA","1184652638","1730137688","NA","Na","1982631966","NA","1780603860","1780651497","1679747950","1588690440","1063495893","1710967153","1649360447","1578572327","1902924152","1831172840","1558362152","1265446371","1467482703","1922070291","1497742381","1962460501","1023061850","1881695302","1437166394","1104822261","1225063902","1376569061","1295739274","1316912918","1255313540","1477635084","1982795894","1144288069","1164494563","1295765659","1659310761","1447342951","1639141229","Penn Medicine Valley Forge","1275786352","1609849256","1376675637","1790784395","1619987930","1811959869","1003961764","1366514259","1922088517","1306840210","1093714743","1225057532","1861589269","1992725071","1003914227","1669558508","1427039247","1407823578","1396788022","1396788022","1841277373","1750377545","1780796417","1598737223","1467673467","1144399718","1205928876","1114975737","1750476115","1114998986","1184604274","1356443451","1821065574","1699731851","1912103052","1861485104","1234","1912941345","1851309629","1346220019","1407041064","1649372319","1871594887","1780763250","1790834281","1861497802","1114913142","1780609057","1780609057","1700913076","N/A","Refusal","1083677710","1558408260","1770502544","1336150234","1174586499","1568532927","1043272776","Refusal","Refusal","Refusal","1891832499","1417142597","1922325687","1104900216","1619130291","1861454423","1619928892","1851349757","Refusal","1447222831","1376679084","1700835196","1891720579","1841254885","1588685176","1205884178","1851359533","Refusal","1043246572","1942505490","1730160524","1073556288","1568591006","1780642272","1992785018","1982605721","1568456366","1366541302","1356544993","1407055296","REFUSAL","1538324645","1174752554","1255308813","Refusal","1164476602","Private Practice","1922274364","1356377196","asdf","1902888365","1538186382","Refusal","1770668758","1568745016","1902823529","1447436126","1083892111","1053471110","1790726396","1811969041","1023065745","1760421564","1134297385","1669416160","30696 AZ.","Refusal","1639171606","1336343912","Refusal","1790834281","1346222353","1881680098","N/P","1003975673","1801861513","1053562470","1699772582","1417919499","1528089745","1356385330","1932143997","1497703367","1366493033","1003803412","None","1144279084","1013900851","1528012234","1538384250","1093880361","1275585846","1336296789","1205864550","1285781948","1134443112","1568558906","1215915012","1679520688","1447294699","1528070505","1558470112","1447333554","1366468894","1154494425","1962440701","1760696314","1356300222","1285913632","1023332079","1841516952","1215183934","5907859078","1225091812","1811055874","1508853052","1437120078","1457466518","1073558615","1881661601","1255303947","1811064785","1336206374","1215927900","1962546366","1851321442"]}', 3, CAST(N'2015-09-14 15:27:50.107' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (73, 87, 92, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''1285634196'',''1659484145'',''1205896362'',''1790778793'',''1881667137'',''1689650327'',''1265472849'',''1255375135'',''1417927732'',''1487811931'',''1003801853'',''1689686677'',''1235179839'',''1811934680'',''1669687299'',''1205948288'',''1356315303'',''1164403127'',''1902830888'',''1902830888'',''1902830888'',''1134143506'',''1104998194'',''1316942170'',''1285770925'',''1053419192'',''1083630834'',''1598711251'',''1053336354'',''1497719959'',''1689684524'',''1033145701'',''1043316615'',''1134172364'',''1770578031'',''1790878809'',''1619101268'',''1972529717'',''1346238284'',''1841293933'',''1366415804'',''1295819357'',''1265427496'',''1730175266'',''1629064605'',''1003093600'',''1427011444'',''1790725125'',''1144228966'',''1992898977'',''1750376380'',''1144250739'',''4631256798'',''1467720045'',''1376645838'',''1134115397'',''1275546038'',''1992762108'',''1992762108'',''016027204185'',''495167700147'',''1144338161'',''umpa'',''Health first cardiology'',''1902824287'',''AK3205285'',''1932157302'',''1710071717'',''1104828300'',''1083656821'',''1073680393'',''1306830682'',''1760504351'',''1376659813'',''1457387888'',''1720190986'',''1821094665'',''1174525778'',''1003837873'',''1942296140'',''1083766729'',''1578670154'',''1508035163'',''1871546523'',''1912997321'',''1386640522'',''1356360887'',''1427254432'',''1235227133'',''1669574976'',''NA'',''1184652638'',''1730137688'',''NA'',''Na'',''1982631966'',''NA'',''1780603860'',''1780651497'',''1679747950'',''1588690440'',''1063495893'',''1710967153'',''1649360447'',''1578572327'',''1902924152'',''1831172840'',''1558362152'',''1265446371'',''1467482703'',''1922070291'',''1497742381'',''1962460501'',''1023061850'',''1881695302'',''1437166394'',''1104822261'',''1225063902'',''1376569061'',''1295739274'',''1316912918'',''1255313540'',''1477635084'',''1982795894'',''1144288069'',''1164494563'',''1295765659'',''1659310761'',''1447342951'',''1639141229'',''Penn Medicine Valley Forge'',''1275786352'',''1609849256'',''1376675637'',''1790784395'',''1619987930'',''1811959869'',''1003961764'',''1366514259'',''1922088517'',''1306840210'',''1093714743'',''1225057532'',''1861589269'',''1992725071'',''1003914227'',''1669558508'',''1427039247'',''1407823578'',''1396788022'',''1396788022'',''1841277373'',''1750377545'',''1780796417'',''1598737223'',''1467673467'',''1144399718'',''1205928876'',''1114975737'',''1750476115'',''1114998986'',''1184604274'',''1356443451'',''1821065574'',''1699731851'',''1912103052'',''1861485104'',''1234'',''1912941345'',''1851309629'',''1346220019'',''1407041064'',''1649372319'',''1871594887'',''1780763250'',''1790834281'',''1861497802'',''1114913142'',''1780609057'',''1780609057'',''1700913076'',''N/A'',''Refusal'',''1083677710'',''1558408260'',''1770502544'',''1336150234'',''1174586499'',''1568532927'',''1043272776'',''Refusal'',''Refusal'',''Refusal'',''1891832499'',''1417142597'',''1922325687'',''1104900216'',''1619130291'',''1861454423'',''1619928892'',''1851349757'',''Refusal'',''1447222831'',''1376679084'',''1700835196'',''1891720579'',''1841254885'',''1588685176'',''1205884178'',''1851359533'',''Refusal'',''1043246572'',''1942505490'',''1730160524'',''1073556288'',''1568591006'',''1780642272'',''1992785018'',''1982605721'',''1568456366'',''1366541302'',''1356544993'',''1407055296'',''REFUSAL'',''1538324645'',''1174752554'',''1255308813'',''Refusal'',''1164476602'',''Private Practice'',''1922274364'',''1356377196'',''asdf'',''1902888365'',''1538186382'',''Refusal'',''1770668758'',''1568745016'',''1902823529'',''1447436126'',''1083892111'',''1053471110'',''1790726396'',''1811969041'',''1023065745'',''1760421564'',''1134297385'',''1669416160'',''30696 AZ.'',''Refusal'',''1639171606'',''1336343912'',''Refusal'',''1790834281'',''1346222353'',''1881680098'',''N/P'',''1003975673'',''1801861513'',''1053562470'',''1699772582'',''1417919499'',''1528089745'',''1356385330'',''1932143997'',''1497703367'',''1366493033'',''1003803412'',''None'',''1144279084'',''1013900851'',''1528012234'',''1538384250'',''1093880361'',''1275585846'',''1336296789'',''1205864550'',''1285781948'',''1134443112'',''1568558906'',''1215915012'',''1679520688'',''1447294699'',''1528070505'',''1558470112'',''1447333554'',''1366468894'',''1154494425'',''1962440701'',''1760696314'',''1356300222'',''1285913632'',''1023332079'',''1841516952'',''1215183934'',''5907859078'',''1225091812'',''1811055874'',''1508853052'',''1437120078'',''1457466518'',''1073558615'',''1881661601'',''1255303947'',''1811064785'',''1336206374'',''1215927900'',''1962546366'',''1851321442'')) ', N'{"projectid":"87","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["1285634196","1659484145","1205896362","1790778793","1881667137","1689650327","1265472849","1255375135","1417927732","1487811931","1003801853","1689686677","1235179839","1811934680","1669687299","1205948288","1356315303","1164403127","1902830888","1902830888","1902830888","1134143506","1104998194","1316942170","1285770925","1053419192","1083630834","1598711251","1053336354","1497719959","1689684524","1033145701","1043316615","1134172364","1770578031","1790878809","1619101268","1972529717","1346238284","1841293933","1366415804","1295819357","1265427496","1730175266","1629064605","1003093600","1427011444","1790725125","1144228966","1992898977","1750376380","1144250739","4631256798","1467720045","1376645838","1134115397","1275546038","1992762108","1992762108","016027204185","495167700147","1144338161","umpa","Health first cardiology","1902824287","AK3205285","1932157302","1710071717","1104828300","1083656821","1073680393","1306830682","1760504351","1376659813","1457387888","1720190986","1821094665","1174525778","1003837873","1942296140","1083766729","1578670154","1508035163","1871546523","1912997321","1386640522","1356360887","1427254432","1235227133","1669574976","NA","1184652638","1730137688","NA","Na","1982631966","NA","1780603860","1780651497","1679747950","1588690440","1063495893","1710967153","1649360447","1578572327","1902924152","1831172840","1558362152","1265446371","1467482703","1922070291","1497742381","1962460501","1023061850","1881695302","1437166394","1104822261","1225063902","1376569061","1295739274","1316912918","1255313540","1477635084","1982795894","1144288069","1164494563","1295765659","1659310761","1447342951","1639141229","Penn Medicine Valley Forge","1275786352","1609849256","1376675637","1790784395","1619987930","1811959869","1003961764","1366514259","1922088517","1306840210","1093714743","1225057532","1861589269","1992725071","1003914227","1669558508","1427039247","1407823578","1396788022","1396788022","1841277373","1750377545","1780796417","1598737223","1467673467","1144399718","1205928876","1114975737","1750476115","1114998986","1184604274","1356443451","1821065574","1699731851","1912103052","1861485104","1234","1912941345","1851309629","1346220019","1407041064","1649372319","1871594887","1780763250","1790834281","1861497802","1114913142","1780609057","1780609057","1700913076","N/A","Refusal","1083677710","1558408260","1770502544","1336150234","1174586499","1568532927","1043272776","Refusal","Refusal","Refusal","1891832499","1417142597","1922325687","1104900216","1619130291","1861454423","1619928892","1851349757","Refusal","1447222831","1376679084","1700835196","1891720579","1841254885","1588685176","1205884178","1851359533","Refusal","1043246572","1942505490","1730160524","1073556288","1568591006","1780642272","1992785018","1982605721","1568456366","1366541302","1356544993","1407055296","REFUSAL","1538324645","1174752554","1255308813","Refusal","1164476602","Private Practice","1922274364","1356377196","asdf","1902888365","1538186382","Refusal","1770668758","1568745016","1902823529","1447436126","1083892111","1053471110","1790726396","1811969041","1023065745","1760421564","1134297385","1669416160","30696 AZ.","Refusal","1639171606","1336343912","Refusal","1790834281","1346222353","1881680098","N/P","1003975673","1801861513","1053562470","1699772582","1417919499","1528089745","1356385330","1932143997","1497703367","1366493033","1003803412","None","1144279084","1013900851","1528012234","1538384250","1093880361","1275585846","1336296789","1205864550","1285781948","1134443112","1568558906","1215915012","1679520688","1447294699","1528070505","1558470112","1447333554","1366468894","1154494425","1962440701","1760696314","1356300222","1285913632","1023332079","1841516952","1215183934","5907859078","1225091812","1811055874","1508853052","1437120078","1457466518","1073558615","1881661601","1255303947","1811064785","1336206374","1215927900","1962546366","1851321442"]}', 3, CAST(N'2015-09-15 08:38:46.513' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (74, 88, 92, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''1285634196'',''1659484145'',''1205896362'',''1790778793'',''1881667137'',''1689650327'',''1265472849'',''1255375135'',''1417927732'',''1003801853'',''1689686677'',''1235179839'',''1811934680'',''1669687299'',''1205948288'',''1356315303'',''1164403127'',''1902830888'',''1902830888'',''1902830888'',''1134143506'',''1104998194'',''1316942170'',''1285770925'',''1053419192'',''1083630834'',''1598711251'',''1053336354'',''1497719959'',''1689684524'',''1033145701'',''1043316615'',''1134172364'',''1770578031'',''1790878809'',''1619101268'',''1972529717'',''1346238284'',''1841293933'',''1366415804'',''1295819357'',''1265427496'',''1730175266'',''1629064605'',''1003093600'',''1427011444'',''1790725125'',''1144228966'',''1992898977'',''1750376380'',''1144250739'',''4631256798'',''1467720045'',''1376645838'',''1134115397'',''1275546038'',''1992762108'',''1992762108'',''1144338161'',''1932157302'',''1710071717'',''1104828300'',''1083656821'',''1073680393'',''1306830682'',''1760504351'',''1376659813'',''1457387888'',''1720190986'',''1821094665'',''1174525778'',''1003837873'',''1942296140'',''1083766729'',''1578670154'',''1508035163'',''1871546523'',''1912997321'',''1386640522'',''1356360887'',''1427254432'',''1235227133'',''1669574976'',''1184652638'',''1730137688'',''1982631966'',''1780603860'',''1780651497'',''1679747950'',''1588690440'',''1063495893'',''1710967153'',''1649360447'',''1578572327'',''1902924152'',''1831172840'',''1558362152'',''1265446371'',''1467482703'',''1922070291'',''1497742381'',''1962460501'',''1023061850'',''1881695302'',''1437166394'',''1104822261'',''1225063902'',''1376569061'',''1295739274'',''1316912918'',''1255313540'',''1477635084'',''1982795894'',''1144288069'',''1164494563'',''1295765659'',''1659310761'',''1447342951'',''1639141229'',''1275786352'',''1609849256'',''1376675637'',''1790784395'',''1619987930'',''1811959869'',''1003961764'',''1366514259'',''1922088517'',''1306840210'',''1093714743'',''1225057532'',''1861589269'',''1992725071'',''1003914227'',''1669558508'',''1427039247'',''1407823578'',''1396788022'',''1396788022'',''1841277373'',''1750377545'',''1780796417'',''1598737223'',''1467673467'',''1144399718'',''1205928876'',''1114975737'',''1750476115'',''1114998986'',''1184604274'',''1356443451'',''1821065574'',''1699731851'',''1912103052'',''1861485104'',''1912941345'',''1851309629'',''1346220019'',''1407041064'',''1649372319'',''1871594887'',''1780763250'',''1790834281'',''1861497802'',''1114913142'',''1780609057'',''1780609057'',''1700913076'',''1083677710'',''1558408260'',''1770502544'',''1336150234'',''1174586499'',''1568532927'',''1043272776'',''1891832499'',''1417142597'',''1922325687'',''1104900216'',''1619130291'',''1861454423'',''1619928892'',''1851349757'',''1447222831'',''1376679084'',''1700835196'',''1891720579'',''1841254885'',''1588685176'',''1205884178'',''1851359533'',''1043246572'',''1942505490'',''1730160524'',''1073556288'',''1568591006'',''1780642272'',''1992785018'',''1982605721'',''1568456366'',''1366541302'',''1356544993'',''1407055296'',''1174752554'',''1255308813'',''1164476602'',''1922274364'',''1356377196'',''1538186382'',''1568745016'',''1902823529'',''1447436126'',''1083892111'',''1053471110'',''1790726396'',''1811969041'',''1023065745'',''1760421564'',''1134297385'',''1669416160'',''1639171606'',''1336343912'',''1790834281'',''1346222353'',''1881680098'',''1003975673'',''1801861513'',''1053562470'',''1699772582'',''1417919499'',''1528089745'',''1356385330'',''1932143997'',''1497703367'',''1366493033'',''1003803412'',''1144279084'',''1013900851'',''1528012234'',''1538384250'',''1093880361'',''1275585846'',''1336296789'',''1205864550'',''1285781948'',''1134443112'',''1568558906'',''1215915012'',''1679520688'',''1447294699'',''1528070505'',''1558470112'',''1447333554'',''1366468894'',''1154494425'',''1962440701'',''1760696314'',''1356300222'',''1285913632'',''1023332079'',''1841516952'',''1215183934'',''5907859078'',''1225091812'',''1811055874'',''1508853052'',''1437120078'',''1457466518'',''1073558615'',''1881661601'',''1255303947'',''1811064785'',''1336206374'',''1215927900'',''1962546366'',''1851321442'')) ', N'{"projectid":"88","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["1285634196","1659484145","1205896362","1790778793","1881667137","1689650327","1265472849","1255375135","1417927732","1003801853","1689686677","1235179839","1811934680","1669687299","1205948288","1356315303","1164403127","1902830888","1902830888","1902830888","1134143506","1104998194","1316942170","1285770925","1053419192","1083630834","1598711251","1053336354","1497719959","1689684524","1033145701","1043316615","1134172364","1770578031","1790878809","1619101268","1972529717","1346238284","1841293933","1366415804","1295819357","1265427496","1730175266","1629064605","1003093600","1427011444","1790725125","1144228966","1992898977","1750376380","1144250739","4631256798","1467720045","1376645838","1134115397","1275546038","1992762108","1992762108","1144338161","1932157302","1710071717","1104828300","1083656821","1073680393","1306830682","1760504351","1376659813","1457387888","1720190986","1821094665","1174525778","1003837873","1942296140","1083766729","1578670154","1508035163","1871546523","1912997321","1386640522","1356360887","1427254432","1235227133","1669574976","1184652638","1730137688","1982631966","1780603860","1780651497","1679747950","1588690440","1063495893","1710967153","1649360447","1578572327","1902924152","1831172840","1558362152","1265446371","1467482703","1922070291","1497742381","1962460501","1023061850","1881695302","1437166394","1104822261","1225063902","1376569061","1295739274","1316912918","1255313540","1477635084","1982795894","1144288069","1164494563","1295765659","1659310761","1447342951","1639141229","1275786352","1609849256","1376675637","1790784395","1619987930","1811959869","1003961764","1366514259","1922088517","1306840210","1093714743","1225057532","1861589269","1992725071","1003914227","1669558508","1427039247","1407823578","1396788022","1396788022","1841277373","1750377545","1780796417","1598737223","1467673467","1144399718","1205928876","1114975737","1750476115","1114998986","1184604274","1356443451","1821065574","1699731851","1912103052","1861485104","1912941345","1851309629","1346220019","1407041064","1649372319","1871594887","1780763250","1790834281","1861497802","1114913142","1780609057","1780609057","1700913076","1083677710","1558408260","1770502544","1336150234","1174586499","1568532927","1043272776","1891832499","1417142597","1922325687","1104900216","1619130291","1861454423","1619928892","1851349757","1447222831","1376679084","1700835196","1891720579","1841254885","1588685176","1205884178","1851359533","1043246572","1942505490","1730160524","1073556288","1568591006","1780642272","1992785018","1982605721","1568456366","1366541302","1356544993","1407055296","1174752554","1255308813","1164476602","1922274364","1356377196","1538186382","1568745016","1902823529","1447436126","1083892111","1053471110","1790726396","1811969041","1023065745","1760421564","1134297385","1669416160","1639171606","1336343912","1790834281","1346222353","1881680098","1003975673","1801861513","1053562470","1699772582","1417919499","1528089745","1356385330","1932143997","1497703367","1366493033","1003803412","1144279084","1013900851","1528012234","1538384250","1093880361","1275585846","1336296789","1205864550","1285781948","1134443112","1568558906","1215915012","1679520688","1447294699","1528070505","1558470112","1447333554","1366468894","1154494425","1962440701","1760696314","1356300222","1285913632","1023332079","1841516952","1215183934","5907859078","1225091812","1811055874","1508853052","1437120078","1457466518","1073558615","1881661601","1255303947","1811064785","1336206374","1215927900","1962546366","1851321442"]}', 3, CAST(N'2015-09-15 08:57:12.450' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (75, 89, 92, N' (DataPointId = 6 AND OptionId IN(''6'',''3'',''2'',''1'',''4'',''5'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 8 AND OptionId IN(''62'',''7'',''6'')) AND EXISTS (SELECT * FROM PanelistMaster P2 WHERE P.Identifier=P2.Identifier AND DataPointId = 5 AND OptionId IN(''1'')) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''1285634196'',''1659484145'',''1205896362'',''1790778793'',''1881667137'',''1689650327'',''1265472849'',''1255375135'',''1417927732'',''1003801853'',''1689686677'',''1235179839'',''1811934680'',''1669687299'',''1205948288'',''1356315303'',''1164403127'',''1902830888'',''1902830888'',''1902830888'',''1134143506'',''1104998194'',''1316942170'',''1285770925'',''1053419192'',''1083630834'',''1598711251'',''1053336354'',''1497719959'',''1689684524'',''1033145701'',''1043316615'',''1134172364'',''1770578031'',''1790878809'',''1619101268'',''1972529717'',''1346238284'',''1841293933'',''1366415804'',''1295819357'',''1265427496'',''1730175266'',''1629064605'',''1003093600'',''1427011444'',''1790725125'',''1144228966'',''1992898977'',''1750376380'',''1144250739'',''4631256798'',''1467720045'',''1376645838'',''1134115397'',''1275546038'',''1992762108'',''1992762108'',''1144338161'',''1932157302'',''1710071717'',''1104828300'',''1083656821'',''1073680393'',''1306830682'',''1760504351'',''1376659813'',''1457387888'',''1720190986'',''1821094665'',''1174525778'',''1003837873'',''1942296140'',''1083766729'',''1578670154'',''1508035163'',''1871546523'',''1912997321'',''1386640522'',''1356360887'',''1427254432'',''1235227133'',''1669574976'',''1184652638'',''1730137688'',''1982631966'',''1780603860'',''1780651497'',''1679747950'',''1588690440'',''1063495893'',''1710967153'',''1649360447'',''1578572327'',''1902924152'',''1831172840'',''1558362152'',''1265446371'',''1467482703'',''1922070291'',''1497742381'',''1962460501'',''1023061850'',''1881695302'',''1437166394'',''1104822261'',''1225063902'',''1376569061'',''1295739274'',''1316912918'',''1255313540'',''1477635084'',''1982795894'',''1144288069'',''1164494563'',''1295765659'',''1659310761'',''1447342951'',''1639141229'',''1275786352'',''1609849256'',''1376675637'',''1790784395'',''1619987930'',''1811959869'',''1003961764'',''1366514259'',''1922088517'',''1306840210'',''1093714743'',''1225057532'',''1861589269'',''1992725071'',''1003914227'',''1669558508'',''1427039247'',''1407823578'',''1396788022'',''1396788022'',''1841277373'',''1750377545'',''1780796417'',''1598737223'',''1467673467'',''1144399718'',''1205928876'',''1114975737'',''1750476115'',''1114998986'',''1184604274'',''1356443451'',''1821065574'',''1699731851'',''1912103052'',''1861485104'',''1912941345'',''1851309629'',''1346220019'',''1407041064'',''1649372319'',''1871594887'',''1780763250'',''1790834281'',''1861497802'',''1114913142'',''1780609057'',''1780609057'',''1700913076'',''1083677710'',''1558408260'',''1770502544'',''1336150234'',''1174586499'',''1568532927'',''1043272776'',''1891832499'',''1417142597'',''1922325687'',''1104900216'',''1619130291'',''1861454423'',''1619928892'',''1851349757'',''1447222831'',''1376679084'',''1700835196'',''1891720579'',''1841254885'',''1588685176'',''1205884178'',''1851359533'',''1043246572'',''1942505490'',''1730160524'',''1073556288'',''1568591006'',''1780642272'',''1992785018'',''1982605721'',''1568456366'',''1366541302'',''1356544993'',''1407055296'',''1174752554'',''1255308813'',''1164476602'',''1922274364'',''1356377196'',''1538186382'',''1568745016'',''1902823529'',''1447436126'',''1083892111'',''1053471110'',''1790726396'',''1811969041'',''1023065745'',''1760421564'',''1134297385'',''1669416160'',''1639171606'',''1336343912'',''1790834281'',''1346222353'',''1881680098'',''1003975673'',''1801861513'',''1053562470'',''1699772582'',''1417919499'',''1528089745'',''1356385330'',''1932143997'',''1497703367'',''1366493033'',''1003803412'',''1144279084'',''1013900851'',''1528012234'',''1538384250'',''1093880361'',''1275585846'',''1336296789'',''1205864550'',''1285781948'',''1134443112'',''1568558906'',''1215915012'',''1679520688'',''1447294699'',''1528070505'',''1558470112'',''1447333554'',''1366468894'',''1154494425'',''1962440701'',''1760696314'',''1356300222'',''1285913632'',''1023332079'',''1841516952'',''1215183934'',''5907859078'',''1225091812'',''1811055874'',''1508853052'',''1437120078'',''1457466518'',''1073558615'',''1881661601'',''1255303947'',''1811064785'',''1336206374'',''1215927900'',''1962546366'',''1851321442'')) ', N'{"projectid":"89","reqn":"92","specialty":"1","querycondition":[{"datapointid":"6","datapointoptions":["6","3","2","1","4","5"]},{"datapointid":"8","datapointoptions":["62","7","6"]},{"datapointid":"5","datapointoptions":["1"]}],"exclusions":["1285634196","1659484145","1205896362","1790778793","1881667137","1689650327","1265472849","1255375135","1417927732","1003801853","1689686677","1235179839","1811934680","1669687299","1205948288","1356315303","1164403127","1902830888","1902830888","1902830888","1134143506","1104998194","1316942170","1285770925","1053419192","1083630834","1598711251","1053336354","1497719959","1689684524","1033145701","1043316615","1134172364","1770578031","1790878809","1619101268","1972529717","1346238284","1841293933","1366415804","1295819357","1265427496","1730175266","1629064605","1003093600","1427011444","1790725125","1144228966","1992898977","1750376380","1144250739","4631256798","1467720045","1376645838","1134115397","1275546038","1992762108","1992762108","1144338161","1932157302","1710071717","1104828300","1083656821","1073680393","1306830682","1760504351","1376659813","1457387888","1720190986","1821094665","1174525778","1003837873","1942296140","1083766729","1578670154","1508035163","1871546523","1912997321","1386640522","1356360887","1427254432","1235227133","1669574976","1184652638","1730137688","1982631966","1780603860","1780651497","1679747950","1588690440","1063495893","1710967153","1649360447","1578572327","1902924152","1831172840","1558362152","1265446371","1467482703","1922070291","1497742381","1962460501","1023061850","1881695302","1437166394","1104822261","1225063902","1376569061","1295739274","1316912918","1255313540","1477635084","1982795894","1144288069","1164494563","1295765659","1659310761","1447342951","1639141229","1275786352","1609849256","1376675637","1790784395","1619987930","1811959869","1003961764","1366514259","1922088517","1306840210","1093714743","1225057532","1861589269","1992725071","1003914227","1669558508","1427039247","1407823578","1396788022","1396788022","1841277373","1750377545","1780796417","1598737223","1467673467","1144399718","1205928876","1114975737","1750476115","1114998986","1184604274","1356443451","1821065574","1699731851","1912103052","1861485104","1912941345","1851309629","1346220019","1407041064","1649372319","1871594887","1780763250","1790834281","1861497802","1114913142","1780609057","1780609057","1700913076","1083677710","1558408260","1770502544","1336150234","1174586499","1568532927","1043272776","1891832499","1417142597","1922325687","1104900216","1619130291","1861454423","1619928892","1851349757","1447222831","1376679084","1700835196","1891720579","1841254885","1588685176","1205884178","1851359533","1043246572","1942505490","1730160524","1073556288","1568591006","1780642272","1992785018","1982605721","1568456366","1366541302","1356544993","1407055296","1174752554","1255308813","1164476602","1922274364","1356377196","1538186382","1568745016","1902823529","1447436126","1083892111","1053471110","1790726396","1811969041","1023065745","1760421564","1134297385","1669416160","1639171606","1336343912","1790834281","1346222353","1881680098","1003975673","1801861513","1053562470","1699772582","1417919499","1528089745","1356385330","1932143997","1497703367","1366493033","1003803412","1144279084","1013900851","1528012234","1538384250","1093880361","1275585846","1336296789","1205864550","1285781948","1134443112","1568558906","1215915012","1679520688","1447294699","1528070505","1558470112","1447333554","1366468894","1154494425","1962440701","1760696314","1356300222","1285913632","1023332079","1841516952","1215183934","5907859078","1225091812","1811055874","1508853052","1437120078","1457466518","1073558615","1881661601","1255303947","1811064785","1336206374","1215927900","1962546366","1851321442"]}', 1, CAST(N'2015-09-15 09:26:37.233' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (76, 90, 92, N' (DataPointId = 6 AND OptionId IN(''6'',''3'',''2'',''1'',''4'',''5'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 8 AND OptionId IN(''62'',''7'',''6'')) AND EXISTS (SELECT * FROM PanelistMaster P2 WHERE P.Identifier=P2.Identifier AND DataPointId = 5 AND OptionId IN(''1'')) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''1285634196'',''1659484145'',''1205896362'',''1790778793'',''1881667137'',''1689650327'',''1265472849'',''1255375135'',''1417927732'',''1003801853'',''1689686677'',''1235179839'',''1811934680'',''1669687299'',''1205948288'',''1356315303'',''1164403127'',''1902830888'',''1902830888'',''1902830888'',''1134143506'',''1104998194'',''1316942170'',''1285770925'',''1053419192'',''1083630834'',''1598711251'',''1053336354'',''1497719959'',''1689684524'',''1033145701'',''1043316615'',''1134172364'',''1770578031'',''1790878809'',''1619101268'',''1972529717'',''1346238284'',''1841293933'',''1366415804'',''1295819357'',''1265427496'',''1730175266'',''1629064605'',''1003093600'',''1427011444'',''1790725125'',''1144228966'',''1992898977'',''1750376380'',''1144250739'',''4631256798'',''1467720045'',''1376645838'',''1134115397'',''1275546038'',''1992762108'',''1992762108'',''1144338161'',''1932157302'',''1710071717'',''1104828300'',''1083656821'',''1073680393'',''1306830682'',''1760504351'',''1376659813'',''1457387888'',''1720190986'',''1821094665'',''1174525778'',''1003837873'',''1942296140'',''1083766729'',''1578670154'',''1508035163'',''1871546523'',''1912997321'',''1386640522'',''1356360887'',''1427254432'',''1235227133'',''1669574976'',''1184652638'',''1730137688'',''1982631966'',''1780603860'',''1780651497'',''1679747950'',''1588690440'',''1063495893'',''1710967153'',''1649360447'',''1578572327'',''1902924152'',''1831172840'',''1558362152'',''1265446371'',''1467482703'',''1922070291'',''1497742381'',''1962460501'',''1023061850'',''1881695302'',''1437166394'',''1104822261'',''1225063902'',''1376569061'',''1295739274'',''1316912918'',''1255313540'',''1477635084'',''1982795894'',''1144288069'',''1164494563'',''1295765659'',''1659310761'',''1447342951'',''1639141229'',''1275786352'',''1609849256'',''1376675637'',''1790784395'',''1619987930'',''1811959869'',''1003961764'',''1366514259'',''1922088517'',''1306840210'',''1093714743'',''1225057532'',''1861589269'',''1992725071'',''1003914227'',''1669558508'',''1427039247'',''1407823578'',''1396788022'',''1396788022'',''1841277373'',''1750377545'',''1780796417'',''1598737223'',''1467673467'',''1144399718'',''1205928876'',''1114975737'',''1750476115'',''1114998986'',''1184604274'',''1356443451'',''1821065574'',''1699731851'',''1912103052'',''1861485104'',''1912941345'',''1851309629'',''1346220019'',''1407041064'',''1649372319'',''1871594887'',''1780763250'',''1790834281'',''1861497802'',''1114913142'',''1780609057'',''1780609057'',''1700913076'',''1083677710'',''1558408260'',''1770502544'',''1336150234'',''1174586499'',''1568532927'',''1043272776'',''1891832499'',''1417142597'',''1922325687'',''1104900216'',''1619130291'',''1861454423'',''1619928892'',''1851349757'',''1447222831'',''1376679084'',''1700835196'',''1891720579'',''1841254885'',''1588685176'',''1205884178'',''1851359533'',''1043246572'',''1942505490'',''1730160524'',''1073556288'',''1568591006'',''1780642272'',''1992785018'',''1982605721'',''1568456366'',''1366541302'',''1356544993'',''1407055296'',''1174752554'',''1255308813'',''1164476602'',''1922274364'',''1356377196'',''1538186382'',''1568745016'',''1902823529'',''1447436126'',''1083892111'',''1053471110'',''1790726396'',''1811969041'',''1023065745'',''1760421564'',''1134297385'',''1669416160'',''1639171606'',''1336343912'',''1790834281'',''1346222353'',''1881680098'',''1003975673'',''1801861513'',''1053562470'',''1699772582'',''1417919499'',''1528089745'',''1356385330'',''1932143997'',''1497703367'',''1366493033'',''1003803412'',''1144279084'',''1013900851'',''1528012234'',''1538384250'',''1093880361'',''1275585846'',''1336296789'',''1205864550'',''1285781948'',''1134443112'',''1568558906'',''1215915012'',''1679520688'',''1447294699'',''1528070505'',''1558470112'',''1447333554'',''1366468894'',''1154494425'',''1962440701'',''1760696314'',''1356300222'',''1285913632'',''1023332079'',''1841516952'',''1215183934'',''5907859078'',''1225091812'',''1811055874'',''1508853052'',''1437120078'',''1457466518'',''1073558615'',''1881661601'',''1255303947'',''1811064785'',''1336206374'',''1215927900'',''1962546366'',''1851321442'')) ', N'{"projectid":"90","reqn":"92","specialty":"1","querycondition":[{"datapointid":"6","datapointoptions":["6","3","2","1","4","5"]},{"datapointid":"8","datapointoptions":["62","7","6"]},{"datapointid":"5","datapointoptions":["1"]}],"exclusions":["1285634196","1659484145","1205896362","1790778793","1881667137","1689650327","1265472849","1255375135","1417927732","1003801853","1689686677","1235179839","1811934680","1669687299","1205948288","1356315303","1164403127","1902830888","1902830888","1902830888","1134143506","1104998194","1316942170","1285770925","1053419192","1083630834","1598711251","1053336354","1497719959","1689684524","1033145701","1043316615","1134172364","1770578031","1790878809","1619101268","1972529717","1346238284","1841293933","1366415804","1295819357","1265427496","1730175266","1629064605","1003093600","1427011444","1790725125","1144228966","1992898977","1750376380","1144250739","4631256798","1467720045","1376645838","1134115397","1275546038","1992762108","1992762108","1144338161","1932157302","1710071717","1104828300","1083656821","1073680393","1306830682","1760504351","1376659813","1457387888","1720190986","1821094665","1174525778","1003837873","1942296140","1083766729","1578670154","1508035163","1871546523","1912997321","1386640522","1356360887","1427254432","1235227133","1669574976","1184652638","1730137688","1982631966","1780603860","1780651497","1679747950","1588690440","1063495893","1710967153","1649360447","1578572327","1902924152","1831172840","1558362152","1265446371","1467482703","1922070291","1497742381","1962460501","1023061850","1881695302","1437166394","1104822261","1225063902","1376569061","1295739274","1316912918","1255313540","1477635084","1982795894","1144288069","1164494563","1295765659","1659310761","1447342951","1639141229","1275786352","1609849256","1376675637","1790784395","1619987930","1811959869","1003961764","1366514259","1922088517","1306840210","1093714743","1225057532","1861589269","1992725071","1003914227","1669558508","1427039247","1407823578","1396788022","1396788022","1841277373","1750377545","1780796417","1598737223","1467673467","1144399718","1205928876","1114975737","1750476115","1114998986","1184604274","1356443451","1821065574","1699731851","1912103052","1861485104","1912941345","1851309629","1346220019","1407041064","1649372319","1871594887","1780763250","1790834281","1861497802","1114913142","1780609057","1780609057","1700913076","1083677710","1558408260","1770502544","1336150234","1174586499","1568532927","1043272776","1891832499","1417142597","1922325687","1104900216","1619130291","1861454423","1619928892","1851349757","1447222831","1376679084","1700835196","1891720579","1841254885","1588685176","1205884178","1851359533","1043246572","1942505490","1730160524","1073556288","1568591006","1780642272","1992785018","1982605721","1568456366","1366541302","1356544993","1407055296","1174752554","1255308813","1164476602","1922274364","1356377196","1538186382","1568745016","1902823529","1447436126","1083892111","1053471110","1790726396","1811969041","1023065745","1760421564","1134297385","1669416160","1639171606","1336343912","1790834281","1346222353","1881680098","1003975673","1801861513","1053562470","1699772582","1417919499","1528089745","1356385330","1932143997","1497703367","1366493033","1003803412","1144279084","1013900851","1528012234","1538384250","1093880361","1275585846","1336296789","1205864550","1285781948","1134443112","1568558906","1215915012","1679520688","1447294699","1528070505","1558470112","1447333554","1366468894","1154494425","1962440701","1760696314","1356300222","1285913632","1023332079","1841516952","1215183934","5907859078","1225091812","1811055874","1508853052","1437120078","1457466518","1073558615","1881661601","1255303947","1811064785","1336206374","1215927900","1962546366","1851321442"]}', 1, CAST(N'2015-09-15 09:57:48.813' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (77, 87, 92, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''1285634196'',''1659484145'',''1205896362'',''1790778793'',''1881667137'',''1689650327'',''1265472849'',''1255375135'',''1417927732'',''1487811931'',''1003801853'',''1689686677'',''1235179839'',''1811934680'',''1669687299'',''1205948288'',''1356315303'',''1164403127'',''1902830888'',''1902830888'',''1902830888'',''1134143506'',''1104998194'',''1316942170'',''1285770925'',''1053419192'',''1083630834'',''1598711251'',''1053336354'',''1497719959'',''1689684524'',''1033145701'',''1043316615'',''1134172364'',''1770578031'',''1790878809'',''1619101268'',''1972529717'',''1346238284'',''1841293933'',''1366415804'',''1295819357'',''1265427496'',''1730175266'',''1629064605'',''1003093600'',''1427011444'',''1790725125'',''1144228966'',''1992898977'',''1750376380'',''1144250739'',''4631256798'',''1467720045'',''1376645838'',''1134115397'',''1275546038'',''1992762108'',''1992762108'',''016027204185'',''495167700147'',''1144338161'',''umpa'',''Health first cardiology'',''1902824287'',''AK3205285'',''1932157302'',''1710071717'',''1104828300'',''1083656821'',''1073680393'',''1306830682'',''1760504351'',''1376659813'',''1457387888'',''1720190986'',''1821094665'',''1174525778'',''1003837873'',''1942296140'',''1083766729'',''1578670154'',''1508035163'',''1871546523'',''1912997321'',''1386640522'',''1356360887'',''1427254432'',''1235227133'',''1669574976'',''NA'',''1184652638'',''1730137688'',''NA'',''Na'',''1982631966'',''NA'',''1780603860'',''1780651497'',''1679747950'',''1588690440'',''1063495893'',''1710967153'',''1649360447'',''1578572327'',''1902924152'',''1831172840'',''1558362152'',''1265446371'',''1467482703'',''1922070291'',''1497742381'',''1962460501'',''1023061850'',''1881695302'',''1437166394'',''1104822261'',''1225063902'',''1376569061'',''1295739274'',''1316912918'',''1255313540'',''1477635084'',''1982795894'',''1144288069'',''1164494563'',''1295765659'',''1659310761'',''1447342951'',''1639141229'',''Penn Medicine Valley Forge'',''1275786352'',''1609849256'',''1376675637'',''1790784395'',''1619987930'',''1811959869'',''1003961764'',''1366514259'',''1922088517'',''1306840210'',''1093714743'',''1225057532'',''1861589269'',''1992725071'',''1003914227'',''1669558508'',''1427039247'',''1407823578'',''1396788022'',''1396788022'',''1841277373'',''1750377545'',''1780796417'',''1598737223'',''1467673467'',''1144399718'',''1205928876'',''1114975737'',''1750476115'',''1114998986'',''1184604274'',''1356443451'',''1821065574'',''1699731851'',''1912103052'',''1861485104'',''1234'',''1912941345'',''1851309629'',''1346220019'',''1407041064'',''1649372319'',''1871594887'',''1780763250'',''1790834281'',''1861497802'',''1114913142'',''1780609057'',''1780609057'',''1700913076'',''N/A'',''Refusal'',''1083677710'',''1558408260'',''1770502544'',''1336150234'',''1174586499'',''1568532927'',''1043272776'',''Refusal'',''Refusal'',''Refusal'',''1891832499'',''1417142597'',''1922325687'',''1104900216'',''1619130291'',''1861454423'',''1619928892'',''1851349757'',''Refusal'',''1447222831'',''1376679084'',''1700835196'',''1891720579'',''1841254885'',''1588685176'',''1205884178'',''1851359533'',''Refusal'',''1043246572'',''1942505490'',''1730160524'',''1073556288'',''1568591006'',''1780642272'',''1992785018'',''1982605721'',''1568456366'',''1366541302'',''1356544993'',''1407055296'',''REFUSAL'',''1538324645'',''1174752554'',''1255308813'',''Refusal'',''1164476602'',''Private Practice'',''1922274364'',''1356377196'',''asdf'',''1902888365'',''1538186382'',''Refusal'',''1770668758'',''1568745016'',''1902823529'',''1447436126'',''1083892111'',''1053471110'',''1790726396'',''1811969041'',''1023065745'',''1760421564'',''1134297385'',''1669416160'',''30696 AZ.'',''Refusal'',''1639171606'',''1336343912'',''Refusal'',''1790834281'',''1346222353'',''1881680098'',''N/P'',''1003975673'',''1801861513'',''1053562470'',''1699772582'',''1417919499'',''1528089745'',''1356385330'',''1932143997'',''1497703367'',''1366493033'',''1003803412'',''None'',''1144279084'',''1013900851'',''1528012234'',''1538384250'',''1093880361'',''1275585846'',''1336296789'',''1205864550'',''1285781948'',''1134443112'',''1568558906'',''1215915012'',''1679520688'',''1447294699'',''1528070505'',''1558470112'',''1447333554'',''1366468894'',''1154494425'',''1962440701'',''1760696314'',''1356300222'',''1285913632'',''1023332079'',''1841516952'',''1215183934'',''5907859078'',''1225091812'',''1811055874'',''1508853052'',''1437120078'',''1457466518'',''1073558615'',''1881661601'',''1255303947'',''1811064785'',''1336206374'',''1215927900'',''1962546366'',''1851321442'')) ', N'{"projectid":"87","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["1285634196","1659484145","1205896362","1790778793","1881667137","1689650327","1265472849","1255375135","1417927732","1487811931","1003801853","1689686677","1235179839","1811934680","1669687299","1205948288","1356315303","1164403127","1902830888","1902830888","1902830888","1134143506","1104998194","1316942170","1285770925","1053419192","1083630834","1598711251","1053336354","1497719959","1689684524","1033145701","1043316615","1134172364","1770578031","1790878809","1619101268","1972529717","1346238284","1841293933","1366415804","1295819357","1265427496","1730175266","1629064605","1003093600","1427011444","1790725125","1144228966","1992898977","1750376380","1144250739","4631256798","1467720045","1376645838","1134115397","1275546038","1992762108","1992762108","016027204185","495167700147","1144338161","umpa","Health first cardiology","1902824287","AK3205285","1932157302","1710071717","1104828300","1083656821","1073680393","1306830682","1760504351","1376659813","1457387888","1720190986","1821094665","1174525778","1003837873","1942296140","1083766729","1578670154","1508035163","1871546523","1912997321","1386640522","1356360887","1427254432","1235227133","1669574976","NA","1184652638","1730137688","NA","Na","1982631966","NA","1780603860","1780651497","1679747950","1588690440","1063495893","1710967153","1649360447","1578572327","1902924152","1831172840","1558362152","1265446371","1467482703","1922070291","1497742381","1962460501","1023061850","1881695302","1437166394","1104822261","1225063902","1376569061","1295739274","1316912918","1255313540","1477635084","1982795894","1144288069","1164494563","1295765659","1659310761","1447342951","1639141229","Penn Medicine Valley Forge","1275786352","1609849256","1376675637","1790784395","1619987930","1811959869","1003961764","1366514259","1922088517","1306840210","1093714743","1225057532","1861589269","1992725071","1003914227","1669558508","1427039247","1407823578","1396788022","1396788022","1841277373","1750377545","1780796417","1598737223","1467673467","1144399718","1205928876","1114975737","1750476115","1114998986","1184604274","1356443451","1821065574","1699731851","1912103052","1861485104","1234","1912941345","1851309629","1346220019","1407041064","1649372319","1871594887","1780763250","1790834281","1861497802","1114913142","1780609057","1780609057","1700913076","N/A","Refusal","1083677710","1558408260","1770502544","1336150234","1174586499","1568532927","1043272776","Refusal","Refusal","Refusal","1891832499","1417142597","1922325687","1104900216","1619130291","1861454423","1619928892","1851349757","Refusal","1447222831","1376679084","1700835196","1891720579","1841254885","1588685176","1205884178","1851359533","Refusal","1043246572","1942505490","1730160524","1073556288","1568591006","1780642272","1992785018","1982605721","1568456366","1366541302","1356544993","1407055296","REFUSAL","1538324645","1174752554","1255308813","Refusal","1164476602","Private Practice","1922274364","1356377196","asdf","1902888365","1538186382","Refusal","1770668758","1568745016","1902823529","1447436126","1083892111","1053471110","1790726396","1811969041","1023065745","1760421564","1134297385","1669416160","30696 AZ.","Refusal","1639171606","1336343912","Refusal","1790834281","1346222353","1881680098","N/P","1003975673","1801861513","1053562470","1699772582","1417919499","1528089745","1356385330","1932143997","1497703367","1366493033","1003803412","None","1144279084","1013900851","1528012234","1538384250","1093880361","1275585846","1336296789","1205864550","1285781948","1134443112","1568558906","1215915012","1679520688","1447294699","1528070505","1558470112","1447333554","1366468894","1154494425","1962440701","1760696314","1356300222","1285913632","1023332079","1841516952","1215183934","5907859078","1225091812","1811055874","1508853052","1437120078","1457466518","1073558615","1881661601","1255303947","1811064785","1336206374","1215927900","1962546366","1851321442"]}', 3, CAST(N'2015-09-16 03:39:28.140' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (78, 87, 92, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''1285634196'',''1659484145'',''1205896362'',''1790778793'',''1881667137'',''1689650327'',''1265472849'',''1255375135'',''1417927732'',''1487811931'',''1003801853'',''1689686677'',''1235179839'',''1811934680'',''1669687299'',''1205948288'',''1356315303'',''1164403127'',''1902830888'',''1902830888'',''1902830888'',''1134143506'',''1104998194'',''1316942170'',''1285770925'',''1053419192'',''1083630834'',''1598711251'',''1053336354'',''1497719959'',''1689684524'',''1033145701'',''1043316615'',''1134172364'',''1770578031'',''1790878809'',''1619101268'',''1972529717'',''1346238284'',''1841293933'',''1366415804'',''1295819357'',''1265427496'',''1730175266'',''1629064605'',''1003093600'',''1427011444'',''1790725125'',''1144228966'',''1992898977'',''1750376380'',''1144250739'',''4631256798'',''1467720045'',''1376645838'',''1134115397'',''1275546038'',''1992762108'',''1992762108'',''016027204185'',''495167700147'',''1144338161'',''umpa'',''Health first cardiology'',''1902824287'',''AK3205285'',''1932157302'',''1710071717'',''1104828300'',''1083656821'',''1073680393'',''1306830682'',''1760504351'',''1376659813'',''1457387888'',''1720190986'',''1821094665'',''1174525778'',''1003837873'',''1942296140'',''1083766729'',''1578670154'',''1508035163'',''1871546523'',''1912997321'',''1386640522'',''1356360887'',''1427254432'',''1235227133'',''1669574976'',''NA'',''1184652638'',''1730137688'',''NA'',''Na'',''1982631966'',''NA'',''1780603860'',''1780651497'',''1679747950'',''1588690440'',''1063495893'',''1710967153'',''1649360447'',''1578572327'',''1902924152'',''1831172840'',''1558362152'',''1265446371'',''1467482703'',''1922070291'',''1497742381'',''1962460501'',''1023061850'',''1881695302'',''1437166394'',''1104822261'',''1225063902'',''1376569061'',''1295739274'',''1316912918'',''1255313540'',''1477635084'',''1982795894'',''1144288069'',''1164494563'',''1295765659'',''1659310761'',''1447342951'',''1639141229'',''Penn Medicine Valley Forge'',''1275786352'',''1609849256'',''1376675637'',''1790784395'',''1619987930'',''1811959869'',''1003961764'',''1366514259'',''1922088517'',''1306840210'',''1093714743'',''1225057532'',''1861589269'',''1992725071'',''1003914227'',''1669558508'',''1427039247'',''1407823578'',''1396788022'',''1396788022'',''1841277373'',''1750377545'',''1780796417'',''1598737223'',''1467673467'',''1144399718'',''1205928876'',''1114975737'',''1750476115'',''1114998986'',''1184604274'',''1356443451'',''1821065574'',''1699731851'',''1912103052'',''1861485104'',''1234'',''1912941345'',''1851309629'',''1346220019'',''1407041064'',''1649372319'',''1871594887'',''1780763250'',''1790834281'',''1861497802'',''1114913142'',''1780609057'',''1780609057'',''1700913076'',''N/A'',''Refusal'',''1083677710'',''1558408260'',''1770502544'',''1336150234'',''1174586499'',''1568532927'',''1043272776'',''Refusal'',''Refusal'',''Refusal'',''1891832499'',''1417142597'',''1922325687'',''1104900216'',''1619130291'',''1861454423'',''1619928892'',''1851349757'',''Refusal'',''1447222831'',''1376679084'',''1700835196'',''1891720579'',''1841254885'',''1588685176'',''1205884178'',''1851359533'',''Refusal'',''1043246572'',''1942505490'',''1730160524'',''1073556288'',''1568591006'',''1780642272'',''1992785018'',''1982605721'',''1568456366'',''1366541302'',''1356544993'',''1407055296'',''REFUSAL'',''1538324645'',''1174752554'',''1255308813'',''Refusal'',''1164476602'',''Private Practice'',''1922274364'',''1356377196'',''asdf'',''1902888365'',''1538186382'',''Refusal'',''1770668758'',''1568745016'',''1902823529'',''1447436126'',''1083892111'',''1053471110'',''1790726396'',''1811969041'',''1023065745'',''1760421564'',''1134297385'',''1669416160'',''30696 AZ.'',''Refusal'',''1639171606'',''1336343912'',''Refusal'',''1790834281'',''1346222353'',''1881680098'',''N/P'',''1003975673'',''1801861513'',''1053562470'',''1699772582'',''1417919499'',''1528089745'',''1356385330'',''1932143997'',''1497703367'',''1366493033'',''1003803412'',''None'',''1144279084'',''1013900851'',''1528012234'',''1538384250'',''1093880361'',''1275585846'',''1336296789'',''1205864550'',''1285781948'',''1134443112'',''1568558906'',''1215915012'',''1679520688'',''1447294699'',''1528070505'',''1558470112'',''1447333554'',''1366468894'',''1154494425'',''1962440701'',''1760696314'',''1356300222'',''1285913632'',''1023332079'',''1841516952'',''1215183934'',''5907859078'',''1225091812'',''1811055874'',''1508853052'',''1437120078'',''1457466518'',''1073558615'',''1881661601'',''1255303947'',''1811064785'',''1336206374'',''1215927900'',''1962546366'',''1851321442'')) ', N'{"projectid":"87","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["1285634196","1659484145","1205896362","1790778793","1881667137","1689650327","1265472849","1255375135","1417927732","1487811931","1003801853","1689686677","1235179839","1811934680","1669687299","1205948288","1356315303","1164403127","1902830888","1902830888","1902830888","1134143506","1104998194","1316942170","1285770925","1053419192","1083630834","1598711251","1053336354","1497719959","1689684524","1033145701","1043316615","1134172364","1770578031","1790878809","1619101268","1972529717","1346238284","1841293933","1366415804","1295819357","1265427496","1730175266","1629064605","1003093600","1427011444","1790725125","1144228966","1992898977","1750376380","1144250739","4631256798","1467720045","1376645838","1134115397","1275546038","1992762108","1992762108","016027204185","495167700147","1144338161","umpa","Health first cardiology","1902824287","AK3205285","1932157302","1710071717","1104828300","1083656821","1073680393","1306830682","1760504351","1376659813","1457387888","1720190986","1821094665","1174525778","1003837873","1942296140","1083766729","1578670154","1508035163","1871546523","1912997321","1386640522","1356360887","1427254432","1235227133","1669574976","NA","1184652638","1730137688","NA","Na","1982631966","NA","1780603860","1780651497","1679747950","1588690440","1063495893","1710967153","1649360447","1578572327","1902924152","1831172840","1558362152","1265446371","1467482703","1922070291","1497742381","1962460501","1023061850","1881695302","1437166394","1104822261","1225063902","1376569061","1295739274","1316912918","1255313540","1477635084","1982795894","1144288069","1164494563","1295765659","1659310761","1447342951","1639141229","Penn Medicine Valley Forge","1275786352","1609849256","1376675637","1790784395","1619987930","1811959869","1003961764","1366514259","1922088517","1306840210","1093714743","1225057532","1861589269","1992725071","1003914227","1669558508","1427039247","1407823578","1396788022","1396788022","1841277373","1750377545","1780796417","1598737223","1467673467","1144399718","1205928876","1114975737","1750476115","1114998986","1184604274","1356443451","1821065574","1699731851","1912103052","1861485104","1234","1912941345","1851309629","1346220019","1407041064","1649372319","1871594887","1780763250","1790834281","1861497802","1114913142","1780609057","1780609057","1700913076","N/A","Refusal","1083677710","1558408260","1770502544","1336150234","1174586499","1568532927","1043272776","Refusal","Refusal","Refusal","1891832499","1417142597","1922325687","1104900216","1619130291","1861454423","1619928892","1851349757","Refusal","1447222831","1376679084","1700835196","1891720579","1841254885","1588685176","1205884178","1851359533","Refusal","1043246572","1942505490","1730160524","1073556288","1568591006","1780642272","1992785018","1982605721","1568456366","1366541302","1356544993","1407055296","REFUSAL","1538324645","1174752554","1255308813","Refusal","1164476602","Private Practice","1922274364","1356377196","asdf","1902888365","1538186382","Refusal","1770668758","1568745016","1902823529","1447436126","1083892111","1053471110","1790726396","1811969041","1023065745","1760421564","1134297385","1669416160","30696 AZ.","Refusal","1639171606","1336343912","Refusal","1790834281","1346222353","1881680098","N/P","1003975673","1801861513","1053562470","1699772582","1417919499","1528089745","1356385330","1932143997","1497703367","1366493033","1003803412","None","1144279084","1013900851","1528012234","1538384250","1093880361","1275585846","1336296789","1205864550","1285781948","1134443112","1568558906","1215915012","1679520688","1447294699","1528070505","1558470112","1447333554","1366468894","1154494425","1962440701","1760696314","1356300222","1285913632","1023332079","1841516952","1215183934","5907859078","1225091812","1811055874","1508853052","1437120078","1457466518","1073558615","1881661601","1255303947","1811064785","1336206374","1215927900","1962546366","1851321442"]}', 3, CAST(N'2015-09-16 03:39:54.623' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (79, 87, 92, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''1285634196'',''1659484145'',''1205896362'',''1790778793'',''1881667137'',''1689650327'',''1265472849'',''1255375135'',''1417927732'',''1487811931'',''1003801853'',''1689686677'',''1235179839'',''1811934680'',''1669687299'',''1205948288'',''1356315303'',''1164403127'',''1902830888'',''1902830888'',''1902830888'',''1134143506'',''1104998194'',''1316942170'',''1285770925'',''1053419192'',''1083630834'',''1598711251'',''1053336354'',''1497719959'',''1689684524'',''1033145701'',''1043316615'',''1134172364'',''1770578031'',''1790878809'',''1619101268'',''1972529717'',''1346238284'',''1841293933'',''1366415804'',''1295819357'',''1265427496'',''1730175266'',''1629064605'',''1003093600'',''1427011444'',''1790725125'',''1144228966'',''1992898977'',''1750376380'',''1144250739'',''4631256798'',''1467720045'',''1376645838'',''1134115397'',''1275546038'',''1992762108'',''1992762108'',''016027204185'',''495167700147'',''1144338161'',''umpa'',''Health first cardiology'',''1902824287'',''AK3205285'',''1932157302'',''1710071717'',''1104828300'',''1083656821'',''1073680393'',''1306830682'',''1760504351'',''1376659813'',''1457387888'',''1720190986'',''1821094665'',''1174525778'',''1003837873'',''1942296140'',''1083766729'',''1578670154'',''1508035163'',''1871546523'',''1912997321'',''1386640522'',''1356360887'',''1427254432'',''1235227133'',''1669574976'',''NA'',''1184652638'',''1730137688'',''NA'',''Na'',''1982631966'',''NA'',''1780603860'',''1780651497'',''1679747950'',''1588690440'',''1063495893'',''1710967153'',''1649360447'',''1578572327'',''1902924152'',''1831172840'',''1558362152'',''1265446371'',''1467482703'',''1922070291'',''1497742381'',''1962460501'',''1023061850'',''1881695302'',''1437166394'',''1104822261'',''1225063902'',''1376569061'',''1295739274'',''1316912918'',''1255313540'',''1477635084'',''1982795894'',''1144288069'',''1164494563'',''1295765659'',''1659310761'',''1447342951'',''1639141229'',''Penn Medicine Valley Forge'',''1275786352'',''1609849256'',''1376675637'',''1790784395'',''1619987930'',''1811959869'',''1003961764'',''1366514259'',''1922088517'',''1306840210'',''1093714743'',''1225057532'',''1861589269'',''1992725071'',''1003914227'',''1669558508'',''1427039247'',''1407823578'',''1396788022'',''1396788022'',''1841277373'',''1750377545'',''1780796417'',''1598737223'',''1467673467'',''1144399718'',''1205928876'',''1114975737'',''1750476115'',''1114998986'',''1184604274'',''1356443451'',''1821065574'',''1699731851'',''1912103052'',''1861485104'',''1234'',''1912941345'',''1851309629'',''1346220019'',''1407041064'',''1649372319'',''1871594887'',''1780763250'',''1790834281'',''1861497802'',''1114913142'',''1780609057'',''1780609057'',''1700913076'',''N/A'',''Refusal'',''1083677710'',''1558408260'',''1770502544'',''1336150234'',''1174586499'',''1568532927'',''1043272776'',''Refusal'',''Refusal'',''Refusal'',''1891832499'',''1417142597'',''1922325687'',''1104900216'',''1619130291'',''1861454423'',''1619928892'',''1851349757'',''Refusal'',''1447222831'',''1376679084'',''1700835196'',''1891720579'',''1841254885'',''1588685176'',''1205884178'',''1851359533'',''Refusal'',''1043246572'',''1942505490'',''1730160524'',''1073556288'',''1568591006'',''1780642272'',''1992785018'',''1982605721'',''1568456366'',''1366541302'',''1356544993'',''1407055296'',''REFUSAL'',''1538324645'',''1174752554'',''1255308813'',''Refusal'',''1164476602'',''Private Practice'',''1922274364'',''1356377196'',''asdf'',''1902888365'',''1538186382'',''Refusal'',''1770668758'',''1568745016'',''1902823529'',''1447436126'',''1083892111'',''1053471110'',''1790726396'',''1811969041'',''1023065745'',''1760421564'',''1134297385'',''1669416160'',''30696 AZ.'',''Refusal'',''1639171606'',''1336343912'',''Refusal'',''1790834281'',''1346222353'',''1881680098'',''N/P'',''1003975673'',''1801861513'',''1053562470'',''1699772582'',''1417919499'',''1528089745'',''1356385330'',''1932143997'',''1497703367'',''1366493033'',''1003803412'',''None'',''1144279084'',''1013900851'',''1528012234'',''1538384250'',''1093880361'',''1275585846'',''1336296789'',''1205864550'',''1285781948'',''1134443112'',''1568558906'',''1215915012'',''1679520688'',''1447294699'',''1528070505'',''1558470112'',''1447333554'',''1366468894'',''1154494425'',''1962440701'',''1760696314'',''1356300222'',''1285913632'',''1023332079'',''1841516952'',''1215183934'',''5907859078'',''1225091812'',''1811055874'',''1508853052'',''1437120078'',''1457466518'',''1073558615'',''1881661601'',''1255303947'',''1811064785'',''1336206374'',''1215927900'',''1962546366'',''1851321442'')) ', N'{"projectid":"87","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["1285634196","1659484145","1205896362","1790778793","1881667137","1689650327","1265472849","1255375135","1417927732","1487811931","1003801853","1689686677","1235179839","1811934680","1669687299","1205948288","1356315303","1164403127","1902830888","1902830888","1902830888","1134143506","1104998194","1316942170","1285770925","1053419192","1083630834","1598711251","1053336354","1497719959","1689684524","1033145701","1043316615","1134172364","1770578031","1790878809","1619101268","1972529717","1346238284","1841293933","1366415804","1295819357","1265427496","1730175266","1629064605","1003093600","1427011444","1790725125","1144228966","1992898977","1750376380","1144250739","4631256798","1467720045","1376645838","1134115397","1275546038","1992762108","1992762108","016027204185","495167700147","1144338161","umpa","Health first cardiology","1902824287","AK3205285","1932157302","1710071717","1104828300","1083656821","1073680393","1306830682","1760504351","1376659813","1457387888","1720190986","1821094665","1174525778","1003837873","1942296140","1083766729","1578670154","1508035163","1871546523","1912997321","1386640522","1356360887","1427254432","1235227133","1669574976","NA","1184652638","1730137688","NA","Na","1982631966","NA","1780603860","1780651497","1679747950","1588690440","1063495893","1710967153","1649360447","1578572327","1902924152","1831172840","1558362152","1265446371","1467482703","1922070291","1497742381","1962460501","1023061850","1881695302","1437166394","1104822261","1225063902","1376569061","1295739274","1316912918","1255313540","1477635084","1982795894","1144288069","1164494563","1295765659","1659310761","1447342951","1639141229","Penn Medicine Valley Forge","1275786352","1609849256","1376675637","1790784395","1619987930","1811959869","1003961764","1366514259","1922088517","1306840210","1093714743","1225057532","1861589269","1992725071","1003914227","1669558508","1427039247","1407823578","1396788022","1396788022","1841277373","1750377545","1780796417","1598737223","1467673467","1144399718","1205928876","1114975737","1750476115","1114998986","1184604274","1356443451","1821065574","1699731851","1912103052","1861485104","1234","1912941345","1851309629","1346220019","1407041064","1649372319","1871594887","1780763250","1790834281","1861497802","1114913142","1780609057","1780609057","1700913076","N/A","Refusal","1083677710","1558408260","1770502544","1336150234","1174586499","1568532927","1043272776","Refusal","Refusal","Refusal","1891832499","1417142597","1922325687","1104900216","1619130291","1861454423","1619928892","1851349757","Refusal","1447222831","1376679084","1700835196","1891720579","1841254885","1588685176","1205884178","1851359533","Refusal","1043246572","1942505490","1730160524","1073556288","1568591006","1780642272","1992785018","1982605721","1568456366","1366541302","1356544993","1407055296","REFUSAL","1538324645","1174752554","1255308813","Refusal","1164476602","Private Practice","1922274364","1356377196","asdf","1902888365","1538186382","Refusal","1770668758","1568745016","1902823529","1447436126","1083892111","1053471110","1790726396","1811969041","1023065745","1760421564","1134297385","1669416160","30696 AZ.","Refusal","1639171606","1336343912","Refusal","1790834281","1346222353","1881680098","N/P","1003975673","1801861513","1053562470","1699772582","1417919499","1528089745","1356385330","1932143997","1497703367","1366493033","1003803412","None","1144279084","1013900851","1528012234","1538384250","1093880361","1275585846","1336296789","1205864550","1285781948","1134443112","1568558906","1215915012","1679520688","1447294699","1528070505","1558470112","1447333554","1366468894","1154494425","1962440701","1760696314","1356300222","1285913632","1023332079","1841516952","1215183934","5907859078","1225091812","1811055874","1508853052","1437120078","1457466518","1073558615","1881661601","1255303947","1811064785","1336206374","1215927900","1962546366","1851321442"]}', 3, CAST(N'2015-09-16 03:39:57.793' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (80, 87, 92, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''1285634196'',''1659484145'')) ', N'{"projectid":"87","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["1285634196","1659484145"]}', 3, CAST(N'2015-09-16 03:40:42.233' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (81, 91, 31, N'', N'{"projectid":"91","reqn":"31","specialty":"13","querycondition":[],"exclusions":[]}', 13, CAST(N'2015-09-16 09:13:48.753' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (82, 92, 31, N' (DataPointId = 8 AND OptionId IN(''56'',''31'',''30'',''29'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 5 AND OptionId IN(''1'')) ', N'{"projectid":"92","reqn":"31","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["56","31","30","29"]},{"datapointid":"5","datapointoptions":["1"]}],"exclusions":[]}', 1, CAST(N'2015-09-16 09:16:59.560' AS DateTime), 10, 75371, 0, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (83, 93, 31, N' (DataPointId = 15 AND OptionId IN(''K_f2deb0970d'',''K_7ef4fd49ce'',''K_a10da422b6'',''K_4ce5622068'',''K_83d63d6182'',''K_48e8993269'',''K_7b82b67b34'',''K_ac0d9c8d23'',''K_rreoggymvc'') ) ', N'{"projectid":"93","reqn":"31","specialty":"1","querycondition":[{"datapointid":"15","datapointoptions":["K_f2deb0970d","K_7ef4fd49ce","K_a10da422b6","K_4ce5622068","K_83d63d6182","K_48e8993269","K_7b82b67b34","K_ac0d9c8d23","K_rreoggymvc"]}],"exclusions":[]}', 1, CAST(N'2015-09-16 10:10:59.847' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (84, 93, 31, N' (DataPointId = 15 AND OptionId IN(''K_f2deb0970d'') ) ', N'{"projectid":"93","reqn":"31","specialty":"1","querycondition":[{"datapointid":"15","datapointoptions":["K_f2deb0970d"]}],"exclusions":[]}', 1, CAST(N'2015-09-16 10:11:35.177' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (85, 93, 31, N' (DataPointId = 15 AND OptionId IN(''K_f2deb0970d'') ) ', N'{"projectid":"93","reqn":"31","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_f2deb0970d"]}],"exclusions":[]}', 3, CAST(N'2015-09-16 10:12:32.597' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (86, 93, 31, N' (DataPointId = 15 AND OptionId IN(''K_f2deb0970d'') ) ', N'{"projectid":"93","reqn":"31","specialty":"1","querycondition":[{"datapointid":"15","datapointoptions":["K_f2deb0970d"]}],"exclusions":[]}', 1, CAST(N'2015-09-16 10:13:40.180' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (87, 94, 4, N' (DataPointId = 8 AND OptionId IN(''24'') ) ', N'{"projectid":"94","reqn":"4","specialty":"24","querycondition":[{"datapointid":"8","datapointoptions":["24"]}],"exclusions":[]}', 24, CAST(N'2015-09-18 11:19:24.860' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (88, 95, 50, N' (DataPointId = 8 AND OptionId IN(''24'') ) ', N'{"projectid":"95","reqn":"50","specialty":"24","querycondition":[{"datapointid":"8","datapointoptions":["24"]}],"exclusions":[]}', 24, CAST(N'2015-09-18 11:34:32.467' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (89, 96, 50, N' (DataPointId = 8 AND OptionId IN(''64'',''51'',''48'',''36'',''24'') ) AND EXISTS (SELECT * FROM PanelistMaster P1 WHERE P.Identifier=P1.Identifier AND DataPointId = 5 AND OptionId IN(''1'')) AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = 16 AND OptionId IN(''1437130622'',''1114903994'',''1124003330'',''1487623955'',''1639142177'',''1396888277'',''1851362974'',''1063478469'',''1740480565'',''1285634196'',''1306802277'',''1497752653'',''1023006111'',''1083827018'',''1285608299'',''1649295270'',''1841272309'',''1911293275'',''1164462206'',''0101058086'',''1336323989'',''1598722597'',''1598701559'',''1922004027'',''1568611465'',''1720074412'',''1316042104'',''1346251071'',''1326062597'',''1528254133'',''1942289674'',''1215966098'',''1821021007'',''1659363356'',''1447340245'',''1700999745'',''1770531816'',''1972643344'',''1518981885'',''1689852428'',''1861472342'',''1104810936'',''1245449438'',''1063640639'',''1689650327'',''1508890005'',''1649341678'',''1386642478'',''1598738171'',''1487616454'',''1902856313'',''1598982712'',''1518206622'',''1467679738'',''1467462531'',''1811934680'',''1992739726'',''1629257035'',''1144290750'',''1366471344'',''1508959644'',''1497884910'',''1538260740'',''1518900976'',''1669412342'',''1003055302'',''1356315303'',''1902830888'',''1902830888'',''1902830888'',''1457559585'',''1316084676'',''1245217413'',''1932109246'',''1942302781'',''1487684353'',''1982854725'',''1255316782'',''1942308580'',''1962408583'',''1538185491'',''1275741647'',''1124039755'',''1477551752'',''1205068053'',''1407911969'',''1750489340'',''1104930916'',''1316049844'',''1316942170'',''1760407597'',''1184710246'',''1053393561'',''1407967235'',''1770576365'',''1275547622'',''1801807607'',''1285698514'',''1841279833'',''1629039177'',''1316044415'',''1245266949'',''1780615641'',''1992740294'',''1184618993'',''1427079250'',''1508910209'',''1083672711'',''1083652986'',''1710940416'',''1306909072'',''1053419192'',''1831197334'',''1659487684'',''1578513420'',''1346227956'',''1417096363'',''1861582942'',''1508020819'',''1750434940'',''1295897569'',''1952455701'',''1598830416'',''1225130701'',''1265564761'',''1467415695'',''1114036878'',''1598711251'',''1881652519'',''1609862663'',''1942238928'',''1043200181'',''1043292618'',''1619973443'',''1306836150'',''1138904126'',''1790793537'',''1326081530'',''1598798183'',''1922101104'',''1417975681'',''1619908597'',''1154452142'',''1841303740'',''1548273295'',''1770550766'',''1972751915'',''1033145701'',''1750497483'',''1407898646'',''8173465960'',''1013023258'',''1306800859'',''1407819683'',''1861439093'',''1841339090'',''1801994207'',''1659303980'',''0000000000'',''1710956305'',''1568429272'',''1255385514'',''1235223009'',''1477615425'',''1598766537'',''1760406649'',''1831115633'',''1043316615'',''1619080314'',''1215974902'',''1376538900'',''1619993474'',''1790787729'',''1942277660'',''1245259274'',''1659354868'',''1598710238'',''1801887856'',''1891724241'',''1134172364'',''1033156500'',''1922014257'',''1184623993'',''1265448237'',''1750300539'',''1578763462'',''1487648929'',''1629211982'',''1548262017'',''1023049541'',''1689666984'',''1215042528'',''1548263353'',''1114988417'',''1790775369'',''1790775369'',''1972529717'',''1700029485'',''1215918990'',''1447270475'',''1902891732'',''1144249871'',''1427098631'',''1710144670'',''1487623427'',''1609885581'',''1164422432'',''1851378616'',''1619960655'',''1063496644'',''1558412288'',''1942348255'',''1164428777'',''1295815538'',''1922066489'',''1235124298'',''1346316197'',''1841293933'',''1295819357'',''1730175266'',''1962539577'',''1144271917'',''1336165877'',''1629064605'',''1003093600'',''1073527479'',''1629047709'',''1730123308'',''1790725125'',''1578975330'',''1629000609'',''1710935564'',''1235142431'',''1750376380'',''1144250739'',''1851417729'',''4631256798'',''1164415519'',''1548274350'',''1083656201'',''1366680829'',''1992762108'',''1992762108'',''1790773505'',''1053307561'',''1508869835'',''1114992625'',''1316057326'',''1114911930'',''1508807827'',''1740212398'',''1881640084'',''1649241902'',''1770599326'',''1629090881'',''1609812841'',''1982628384'',''1679897185'',''1285791228'',''1376645366'',''1477577682'',''1992902605'',''1962533380'',''1073512844'',''1164408472'',''1689689028'',''1144524729'',''1922083633'',''1225050404'',''1134182983'',''1801081971'',''1134326275'',''1275579724'',''1871520726'',''1082376825'',''1184670671'',''1154361673'',''1932318532'',''1144254095'',''1821033481'',''1205801404'',''1144317850'',''1407854458'',''1134185135'',''1205934767'',''1821241779'',''1629113402'',''1568404440'',''1295706158'',''1043284540'',''1699770164'',''1134103765'',''1942376074'',''1376535757'',''1639197239'',''1538175799'',''1922009901'',''1598758575'',''1962410100'',''1922267426'',''1043532286'',''1811925910'',''1043393895'',''1538160395'',''1831202753'',''1295993715'',''1467686717'',''1932157302'',''1477649168'',''1083676209'',''1235171364'',''1487644803'',''1689665556'',''1851365985'',''1841266343'',''1508858564'',''1508955956'',''1144294182'',''1750366779'',''1871739276'',''1043379605'',''1770698490'',''1932196102'',''1053394106'',''1396798708'',''1154428613'',''1861685018'',''1326362989'',''1548421514'',''1245332519'',''1952403016'',''1740256783'',''1649531427'',''1780656488'',''1508847021'',''1770698375'',''1073523759'',''1083603716'',''1093977639'',''1164409561'',''1720044241'',''1922088426'',''1356336846'',''1821182791'',''1063475549'',''1417959123'',''1730160144'',''1922325687'',''1376679084'',''1992810857'',''1588685176'',''1568414985'',''1508097742'',''1962509265'',''1427042837'',''1083641856'',''1861420077'',''1891718768'',''1295758514'',''1326032012'',''1093759581'',''1144257395'',''1023033040'',''1215986245'',''1891730479'',''1841365889'',''1023087491'',''1780663898'',''1457456808'',''1720086499'',''1871922575'',''1538164066'',''1366631749'',''1942341417'',''1710974209'',''1730145343'',''1720072960'',''1265465835'',''1942238654'',''1740230739'',''1689693483'',''1376640227'',''1952375073'',''1124093331'',''1972688564'',''1023187622'',''1609829365'',''1528005634'',''1194712877'',''1831245307'',''1437217601'',''1598789588'',''1164402764'',''1831208412'',''1588628549'',''1447271259'',''1811928799'',''1447367479'',''1801882386'',''1760560494'',''1962402586'',''1992055115'',''1639202120'',''1083748685'',''1861571622'',''1184631772'',''1104006089'',''1922331628'',''1194754788'',''1720083173'',''1639114721'',''1770581803'',''1093880361'',''1588695712'',''1336104694'',''1134246770'',''1174624035'',''1568660652'',''1184601577'',''1134443112'',''1144225848'',''1023035094'',''1538491212'',''1619980620'',''1275851222'',''1497888192'',''1437233012'',''1386867448'',''1881717197'',''1952321820'',''1720015084'',''1295762722'',''1386706059'',''1821062944'',''1558470112'',''1376593806'',''1609977552'',''1902986151'',''1447307897'',''1851302863'',''1669604450'',''1215996988'',''1093810228'',''1538158084'',''1154494425'',''1700941788'',''1316912967'',''1760466692'',''1942592563'',''1568482818'',''1750466165'',''1508841883'',''1104819622'',''1851529374'',''1497016190'',''1174507974'',''1306017991'',''1073537072'',''1184670820'',''1811967771'',''1184856965'',''1750551453'',''1083673685'',''1013978402'',''1093931081'',''1225276488'',''1548428618'',''1962452425'',''5907859078'',''1174588651'',''1962693150'',''1164427977'',''1568576510'',''1780635599'',''1417121138'',''1124027750'',''1023019270'',''1306024161'',''1992071336'',''1669667242'',''1396737581'',''1770826331'',''1730422536'',''1699086496'',''1518269232'',''1225109150'',''1760469654'',''1730165259'',''1255498507'',''1275875130'',''1982624946'',''1902097892'',''1639304355'')) ', N'{"projectid":"96","reqn":"50","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["64","51","48","36","24"]},{"datapointid":"5","datapointoptions":["1"]}],"exclusions":["1437130622","1114903994","1124003330","1487623955","1639142177","1396888277","1851362974","1063478469","1740480565","1285634196","1306802277","1497752653","1023006111","1083827018","1285608299","1649295270","1841272309","1911293275","1164462206","0101058086","1336323989","1598722597","1598701559","1922004027","1568611465","1720074412","1316042104","1346251071","1326062597","1528254133","1942289674","1215966098","1821021007","1659363356","1447340245","1700999745","1770531816","1972643344","1518981885","1689852428","1861472342","1104810936","1245449438","1063640639","1689650327","1508890005","1649341678","1386642478","1598738171","1487616454","1902856313","1598982712","1518206622","1467679738","1467462531","1811934680","1992739726","1629257035","1144290750","1366471344","1508959644","1497884910","1538260740","1518900976","1669412342","1003055302","1356315303","1902830888","1902830888","1902830888","1457559585","1316084676","1245217413","1932109246","1942302781","1487684353","1982854725","1255316782","1942308580","1962408583","1538185491","1275741647","1124039755","1477551752","1205068053","1407911969","1750489340","1104930916","1316049844","1316942170","1760407597","1184710246","1053393561","1407967235","1770576365","1275547622","1801807607","1285698514","1841279833","1629039177","1316044415","1245266949","1780615641","1992740294","1184618993","1427079250","1508910209","1083672711","1083652986","1710940416","1306909072","1053419192","1831197334","1659487684","1578513420","1346227956","1417096363","1861582942","1508020819","1750434940","1295897569","1952455701","1598830416","1225130701","1265564761","1467415695","1114036878","1598711251","1881652519","1609862663","1942238928","1043200181","1043292618","1619973443","1306836150","1138904126","1790793537","1326081530","1598798183","1922101104","1417975681","1619908597","1154452142","1841303740","1548273295","1770550766","1972751915","1033145701","1750497483","1407898646","8173465960","1013023258","1306800859","1407819683","1861439093","1841339090","1801994207","1659303980","0000000000","1710956305","1568429272","1255385514","1235223009","1477615425","1598766537","1760406649","1831115633","1043316615","1619080314","1215974902","1376538900","1619993474","1790787729","1942277660","1245259274","1659354868","1598710238","1801887856","1891724241","1134172364","1033156500","1922014257","1184623993","1265448237","1750300539","1578763462","1487648929","1629211982","1548262017","1023049541","1689666984","1215042528","1548263353","1114988417","1790775369","1790775369","1972529717","1700029485","1215918990","1447270475","1902891732","1144249871","1427098631","1710144670","1487623427","1609885581","1164422432","1851378616","1619960655","1063496644","1558412288","1942348255","1164428777","1295815538","1922066489","1235124298","1346316197","1841293933","1295819357","1730175266","1962539577","1144271917","1336165877","1629064605","1003093600","1073527479","1629047709","1730123308","1790725125","1578975330","1629000609","1710935564","1235142431","1750376380","1144250739","1851417729","4631256798","1164415519","1548274350","1083656201","1366680829","1992762108","1992762108","1790773505","1053307561","1508869835","1114992625","1316057326","1114911930","1508807827","1740212398","1881640084","1649241902","1770599326","1629090881","1609812841","1982628384","1679897185","1285791228","1376645366","1477577682","1992902605","1962533380","1073512844","1164408472","1689689028","1144524729","1922083633","1225050404","1134182983","1801081971","1134326275","1275579724","1871520726","1082376825","1184670671","1154361673","1932318532","1144254095","1821033481","1205801404","1144317850","1407854458","1134185135","1205934767","1821241779","1629113402","1568404440","1295706158","1043284540","1699770164","1134103765","1942376074","1376535757","1639197239","1538175799","1922009901","1598758575","1962410100","1922267426","1043532286","1811925910","1043393895","1538160395","1831202753","1295993715","1467686717","1932157302","1477649168","1083676209","1235171364","1487644803","1689665556","1851365985","1841266343","1508858564","1508955956","1144294182","1750366779","1871739276","1043379605","1770698490","1932196102","1053394106","1396798708","1154428613","1861685018","1326362989","1548421514","1245332519","1952403016","1740256783","1649531427","1780656488","1508847021","1770698375","1073523759","1083603716","1093977639","1164409561","1720044241","1922088426","1356336846","1821182791","1063475549","1417959123","1730160144","1922325687","1376679084","1992810857","1588685176","1568414985","1508097742","1962509265","1427042837","1083641856","1861420077","1891718768","1295758514","1326032012","1093759581","1144257395","1023033040","1215986245","1891730479","1841365889","1023087491","1780663898","1457456808","1720086499","1871922575","1538164066","1366631749","1942341417","1710974209","1730145343","1720072960","1265465835","1942238654","1740230739","1689693483","1376640227","1952375073","1124093331","1972688564","1023187622","1609829365","1528005634","1194712877","1831245307","1437217601","1598789588","1164402764","1831208412","1588628549","1447271259","1811928799","1447367479","1801882386","1760560494","1962402586","1992055115","1639202120","1083748685","1861571622","1184631772","1104006089","1922331628","1194754788","1720083173","1639114721","1770581803","1093880361","1588695712","1336104694","1134246770","1174624035","1568660652","1184601577","1134443112","1144225848","1023035094","1538491212","1619980620","1275851222","1497888192","1437233012","1386867448","1881717197","1952321820","1720015084","1295762722","1386706059","1821062944","1558470112","1376593806","1609977552","1902986151","1447307897","1851302863","1669604450","1215996988","1093810228","1538158084","1154494425","1700941788","1316912967","1760466692","1942592563","1568482818","1750466165","1508841883","1104819622","1851529374","1497016190","1174507974","1306017991","1073537072","1184670820","1811967771","1184856965","1750551453","1083673685","1013978402","1093931081","1225276488","1548428618","1962452425","5907859078","1174588651","1962693150","1164427977","1568576510","1780635599","1417121138","1124027750","1023019270","1306024161","1992071336","1669667242","1396737581","1770826331","1730422536","1699086496","1518269232","1225109150","1760469654","1730165259","1255498507","1275875130","1982624946","1902097892","1639304355"]}', 1, CAST(N'2015-09-18 12:31:29.680' AS DateTime), 10, 75644, 0, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (90, 13, 80, N' (DataPointId = 15 AND OptionId IN(''K_rreoggymvc'') ) ', N'{"projectid":"13","reqn":"80","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', 3, CAST(N'2015-09-28 14:00:53.130' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (110, 2, 2, N' (DataPointId = 1 AND OptionId IN(''1'') ) ', NULL, NULL, CAST(N'2016-08-01 19:53:50.527' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (111, 2, 2, N' (DataPointId = 1 AND OptionId IN(''1'') ) ', NULL, NULL, CAST(N'2016-08-01 19:53:55.667' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (112, 2, 2, N' (DataPointId = 1 AND OptionId IN(''1'') ) ', NULL, NULL, CAST(N'2016-08-01 19:55:14.427' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (113, 2, 2, N' (DataPointId = 1 AND OptionId IN(''1'') ) ', NULL, NULL, CAST(N'2016-08-01 19:55:16.657' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (114, 2, 2, N' (DataPointId = 1 AND OptionId IN(''1'') ) ', NULL, NULL, CAST(N'2016-08-01 19:57:47.950' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (115, 2, 2, N' (DataPointId = 1 AND OptionId IN(''1'') ) ', NULL, NULL, CAST(N'2016-08-01 19:58:01.090' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (116, 2, 2, N' (DataPointId = 1 AND OptionId IN(''1'') ) ', NULL, NULL, CAST(N'2016-08-01 19:58:33.800' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (117, 2, 2, N' (DataPointId = 1 AND OptionId IN(''1'') ) ', NULL, NULL, CAST(N'2016-08-01 19:58:38.587' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, NULL, NULL, N'RewardA')
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (118, 2, 10, NULL, NULL, NULL, CAST(N'2016-08-03 16:59:41.327' AS DateTime), 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, 1, NULL, N'RewardA')
GO
INSERT [dbo].[QueryMaster] ([QueryId], [ProjectId], [ReqN], [Query], [JsonText], [Speciality], [CreateDate], [Reward], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [RewardLevel]) VALUES (119, 2, 10, N' (DataPointId = 1 AND OptionId IN(''1'') ) ', NULL, 1, CAST(N'2016-08-03 17:01:59.550' AS DateTime), 85, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'21-30', 3, 10, 1, NULL, N'RewardA')
SET IDENTITY_INSERT [dbo].[QueryMaster] OFF
SET IDENTITY_INSERT [dbo].[QuerySampleMapping] ON 

INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (24, 1, 1234, 2468, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(N'2016-07-26 20:26:40.280' AS DateTime), 3, N'testing error', 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (25, 2, 3455, 5677, 1, CAST(N'2016-08-01 19:05:09.340' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(N'2016-07-31 21:28:12.140' AS DateTime), NULL, NULL, 3, 2)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (148, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (149, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (150, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (151, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (152, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (153, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (154, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (155, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (156, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (157, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (158, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (159, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (160, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (161, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (162, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (163, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (164, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (165, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (166, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (167, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (168, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (169, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (170, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (171, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (172, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (173, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (174, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (175, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (176, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (177, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (178, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (179, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (180, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (181, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (182, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (183, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (184, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (185, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (186, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (187, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (188, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (189, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (190, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (191, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (192, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (193, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (194, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (195, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (196, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (197, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (198, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (199, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (200, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (201, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (202, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (203, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (204, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (205, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (206, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (207, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (208, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (209, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (210, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (211, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (212, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (213, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (214, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (215, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (216, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (217, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
INSERT [dbo].[QuerySampleMapping] ([Id], [QueryId], [SampleId], [CampaignId], [SendReminder], [ReminderRequestDate], [ReminderSentStatus], [KinesisReminderSentDate], [KinesisReminderErrorCount], [SampleRatio], [CompleteGroup], [TotalRespondent], [ExclusionCount], [CampaignCreatedDate], [ErrorRetryCount], [KinesisAPIError], [MaxRemainder], [RemainderCount]) VALUES (218, 2, 23445, 345455, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL)
SET IDENTITY_INSERT [dbo].[QuerySampleMapping] OFF
SET IDENTITY_INSERT [dbo].[RequestLog] ON 

INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (2, N'{"success":"false","error":"Authentication Failed."}', CAST(N'2015-07-24 05:58:52.460' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (3, N'{"name":"1-Universal Test Project","loi":"3","incidence":"10","surveylink":"https://api.tester.com/surveys/100?id=","emailsubject":"SCH Survey","referencecode":"200","surveytopic":"Panel Survey"}', CAST(N'2015-07-27 11:49:34.670' AS DateTime), N'{"projectid":"2","success":"true"}', CAST(N'2015-07-27 11:49:34.690' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (4, N'{"success":"false","error":"Invalid Data."}', CAST(N'2015-07-28 15:46:12.060' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (5, N'{"success":"false","error":"Invalid Data."}', CAST(N'2015-07-28 15:47:33.640' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (6, N'{"projectid":"2","reqn":"10","specialty":"1","querycondition":[{"datapointid":"1","datapointoptions":["1"]}]}', CAST(N'2015-07-28 15:47:47.847' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (7, N'{"success":"true","queryid":"1","projectid":"2","feasibility":"1"}', CAST(N'2015-07-28 15:47:47.980' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (8, N'{"success":"false","error":"Invalid Data."}', CAST(N'2015-07-28 15:47:58.577' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (9, N'{"projectid":"2","statusid":"1"}', CAST(N'2015-07-28 15:48:34.480' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (10, N'{"projectid":"2","success":"true"}', CAST(N'2015-07-28 15:48:34.500' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (11, N'{"success":"false","error":"Invalid Data."}', CAST(N'2015-07-28 15:49:29.950' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (12, N'{"success":"false","error":"Invalid Data."}', CAST(N'2015-07-28 15:49:36.413' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (13, N'{"success":"false","error":"Invalid Data."}', CAST(N'2015-07-28 15:49:43.193' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (14, N'{"projectid":"2","reqn":"10","specialty":"1","querycondition":[{"datapointid":"1","datapointoptions":["1","2"]}]}', CAST(N'2015-07-28 15:49:51.057' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (15, N'{"success":"true","queryid":"2","projectid":"2","feasibility":"0"}', CAST(N'2015-07-28 15:49:51.077' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (16, N'{"name":"Test SHC 1","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15285","surveytopic":"TODO Define topic"}', CAST(N'2015-07-29 10:50:12.967' AS DateTime), N'{"projectid":"3","success":"true"}', CAST(N'2015-07-29 10:50:13.123' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (17, N'{"name":"Test SHC 1","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15285","surveytopic":"TODO Define topic"}', CAST(N'2015-07-29 10:56:40.607' AS DateTime), N'{"projectid":"4","success":"true"}', CAST(N'2015-07-29 10:56:40.620' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (18, N'{"name":"Test SHC 1","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15285","surveytopic":"TODO Define topic"}', CAST(N'2015-07-29 10:56:49.437' AS DateTime), N'{"projectid":"5","success":"true"}', CAST(N'2015-07-29 10:56:49.450' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (19, N'{"name":"Test SHC 1","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15285","surveytopic":"TODO Define topic"}', CAST(N'2015-07-29 11:25:11.713' AS DateTime), N'{"projectid":"6","success":"true"}', CAST(N'2015-07-29 11:25:11.740' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (20, N'{"name":"Test SHC 1","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15285","surveytopic":"TODO Define topic"}', CAST(N'2015-07-29 11:25:59.860' AS DateTime), N'{"projectid":"7","success":"true"}', CAST(N'2015-07-29 11:25:59.883' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (21, N'{"name":"Test SHC 1","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15285","surveytopic":"TODO Define topic"}', CAST(N'2015-07-29 11:27:17.480' AS DateTime), N'{"projectid":"8","success":"true"}', CAST(N'2015-07-29 11:27:17.540' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (22, N'{"name":"Test SHC 1","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15285","surveytopic":"TODO Define topic"}', CAST(N'2015-07-29 11:42:15.447' AS DateTime), N'{"projectid":"9","success":"true"}', CAST(N'2015-07-29 11:42:15.460' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (23, N'{"name":"Test SHC 1","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15285","surveytopic":"TODO Define topic"}', CAST(N'2015-07-29 11:44:21.073' AS DateTime), N'{"projectid":"10","success":"true"}', CAST(N'2015-07-29 11:44:21.080' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (24, N'{"name":"Test SHC 1","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15285","surveytopic":"TODO Define topic"}', CAST(N'2015-07-29 11:45:28.263' AS DateTime), N'{"projectid":"11","success":"true"}', CAST(N'2015-07-29 11:45:28.273' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (25, N'{"name":"Test SHC 1","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15285","surveytopic":"TODO Define topic"}', CAST(N'2015-07-29 11:46:24.870' AS DateTime), N'{"projectid":"12","success":"true"}', CAST(N'2015-07-29 11:46:24.900' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (26, N'{"name":"Test SHC 1","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15285","surveytopic":"TODO Define topic"}', CAST(N'2015-07-29 11:47:06.827' AS DateTime), N'{"projectid":"13","success":"true"}', CAST(N'2015-07-29 11:47:06.843' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (27, N'{"name":"Test SHC 1","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15285","surveytopic":"TODO Define topic"}', CAST(N'2015-07-29 11:51:24.710' AS DateTime), N'{"projectid":"14","success":"true"}', CAST(N'2015-07-29 11:51:24.727' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (28, N'{"name":"Test SHC 1","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15285","surveytopic":"TODO Define topic"}', CAST(N'2015-07-29 12:46:58.373' AS DateTime), N'{"projectid":"15","success":"true"}', CAST(N'2015-07-29 12:46:58.403' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (29, N'{"name":"Test SHC 1","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15285","surveytopic":"TODO Define topic"}', CAST(N'2015-07-29 12:53:08.087' AS DateTime), N'{"projectid":"16","success":"true"}', CAST(N'2015-07-29 12:53:08.103' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (30, N'{"name":"Test SHC 1","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15285","surveytopic":"TODO Define topic"}', CAST(N'2015-07-29 12:53:38.513' AS DateTime), N'{"projectid":"17","success":"true"}', CAST(N'2015-07-29 12:53:38.540' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (31, N'{"name":"Test SHC 1","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15285","surveytopic":"TODO Define topic"}', CAST(N'2015-07-29 12:56:50.790' AS DateTime), N'{"projectid":"18","success":"true"}', CAST(N'2015-07-29 12:56:50.800' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (32, N'{"name":"Test SHC 1","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15285","surveytopic":"TODO Define topic"}', CAST(N'2015-07-29 12:59:29.840' AS DateTime), N'{"projectid":"19","success":"true"}', CAST(N'2015-07-29 12:59:29.860' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (33, N'{"name":"Bens Test Project","loi":"3","incidence":"10","surveylink":"http://incrowdnow.com","emailsubject":"SCH Survey","referencecode":"200","surveytopic":"Panel Survey"}', CAST(N'2015-07-29 13:39:27.760' AS DateTime), N'{"projectid":"20","success":"true"}', CAST(N'2015-07-29 13:39:27.777' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (34, N'{"name":"Bens Test Project","loi":"3","incidence":"10","surveylink":"http://incrowdnow.com","emailsubject":"SCH Survey","referencecode":"200","surveytopic":"Panel Survey"}', CAST(N'2015-07-29 13:42:27.637' AS DateTime), N'{"projectid":"21","success":"true"}', CAST(N'2015-07-29 13:42:27.650' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (35, N'{"success":"false","error":"Invalid Data."}', CAST(N'2015-07-29 14:21:41.913' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (36, N'{"projectid":"14","statusid":"1"}', CAST(N'2015-07-29 14:21:42.080' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (37, N'{"projectid":"14","success":"true"}', CAST(N'2015-07-29 14:21:42.107' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (38, N'{"projectid":"14","reqn":"0","specialty":"1","querycondition":[{"datapointid":null,"datapointoptions":null}]}', CAST(N'2015-07-29 14:23:56.003' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (39, N'{"success":"false","error":"Erron on Save Query."}', CAST(N'2015-07-29 14:23:56.050' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (40, N'{"projectid":"14","statusid":"1"}', CAST(N'2015-07-29 14:23:56.217' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (41, N'', CAST(N'2015-07-29 14:23:56.223' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (42, N'{"projectid":"14","reqn":"10","specialty":"1","querycondition":[{"datapointid":null,"datapointoptions":null}]}', CAST(N'2015-07-29 14:24:24.407' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (43, N'{"success":"false","error":"Erron on Save Query."}', CAST(N'2015-07-29 14:24:24.410' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (44, N'{"projectid":"14","statusid":"1"}', CAST(N'2015-07-29 14:24:24.460' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (45, N'', CAST(N'2015-07-29 14:24:24.467' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (46, N'{"name":"SHC 1","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3717&crowdId=3600&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15073","surveytopic":"TODO Define topic"}', CAST(N'2015-07-30 15:04:02.507' AS DateTime), N'{"projectid":22,"success":true}', CAST(N'2015-07-30 15:04:02.540' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (47, N'{"name":"SHC 1","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3717&crowdId=3600&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15073","surveytopic":"TODO Define topic"}', CAST(N'2015-07-30 15:05:43.197' AS DateTime), N'{"projectid":23,"success":true}', CAST(N'2015-07-30 15:05:43.210' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (48, N'{"success":false,"error":"Invalid Data."}', CAST(N'2015-07-30 15:05:43.410' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (49, N'{"success":false,"error":"Invalid Data."}', CAST(N'2015-07-30 15:05:43.537' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (50, N'{"name":"SHC 1","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3717&crowdId=3600&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15073","surveytopic":"TODO Define topic"}', CAST(N'2015-07-30 15:19:57.867' AS DateTime), N'{"projectid":24,"success":true}', CAST(N'2015-07-30 15:19:57.877' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (51, N'{"projectid":"24","reqn":"10","specialty":"1","querycondition":[{"datapointid":null,"datapointoptions":null}]}', CAST(N'2015-07-30 15:19:58.003' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (52, N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-07-30 15:19:58.017' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (53, N'{"projectid":"24","statusid":"1"}', CAST(N'2015-07-30 15:19:58.077' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (54, N'{"projectid":24,"success":true}', CAST(N'2015-07-30 15:19:58.087' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (55, N'{"name":"SHC 1","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3717&crowdId=3600&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15073","surveytopic":"TODO Define topic"}', CAST(N'2015-07-30 15:32:16.917' AS DateTime), N'{"projectid":25,"success":true}', CAST(N'2015-07-30 15:32:16.930' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (56, N'{"projectid":"25","reqn":"10","specialty":"1","querycondition":[{"datapointid":null,"datapointoptions":null}]}', CAST(N'2015-07-30 15:32:17.077' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (57, N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-07-30 15:32:17.083' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (58, N'{"name":"SHC 1","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3717&crowdId=3600&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15073","surveytopic":"TODO Define topic"}', CAST(N'2015-07-30 15:34:19.140' AS DateTime), N'{"projectid":26,"success":true}', CAST(N'2015-07-30 15:34:19.150' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (59, N'{"projectid":"26","reqn":"10","specialty":"1","querycondition":[{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}]}', CAST(N'2015-07-30 15:34:19.237' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (60, N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-07-30 15:34:19.340' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (61, N'{"name":"SHC 1","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3717&crowdId=3600&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15073","surveytopic":"TODO Define topic"}', CAST(N'2015-07-30 15:38:07.060' AS DateTime), N'{"projectid":27,"success":true}', CAST(N'2015-07-30 15:38:07.077' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (62, N'{"projectid":"27","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}]}', CAST(N'2015-07-30 15:38:07.277' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (63, N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-07-30 15:38:07.323' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (64, N'{"name":"SHC 1","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3717&crowdId=3600&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15073","surveytopic":"TODO Define topic"}', CAST(N'2015-07-30 15:40:57.647' AS DateTime), N'{"projectid":28,"success":true}', CAST(N'2015-07-30 15:40:57.657' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (65, N'{"projectid":"28","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}]}', CAST(N'2015-07-30 15:40:57.853' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (66, N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-07-30 15:40:57.903' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (67, N'{"name":"SHC 1","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3717&crowdId=3600&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15073","surveytopic":"TODO Define topic"}', CAST(N'2015-07-30 15:41:29.180' AS DateTime), N'{"projectid":29,"success":true}', CAST(N'2015-07-30 15:41:29.207' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (68, N'{"projectid":"29","reqn":"10","specialty":"6","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}]}', CAST(N'2015-07-30 15:41:29.320' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (69, N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-07-30 15:41:29.340' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (70, N'{"name":"SHC 1","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3717&crowdId=3600&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15073","surveytopic":"TODO Define topic"}', CAST(N'2015-07-30 15:41:49.070' AS DateTime), N'{"projectid":30,"success":true}', CAST(N'2015-07-30 15:41:49.087' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (71, N'{"success":false,"error":"Invalid Data."}', CAST(N'2015-07-30 15:41:49.163' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (72, N'{"name":"SHC 1","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3717&crowdId=3600&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15073","surveytopic":"TODO Define topic"}', CAST(N'2015-07-30 15:42:16.820' AS DateTime), N'{"projectid":31,"success":true}', CAST(N'2015-07-30 15:42:16.840' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (73, N'{"projectid":"31","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"5","datapointoptions":["1"]}]}', CAST(N'2015-07-30 15:42:17.583' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (74, N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-07-30 15:42:17.620' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (75, N'{"success":false,"error":"Invalid Data."}', CAST(N'2015-07-30 15:43:56.927' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (76, N'{"projectid":"13","reqn":"300","specialty":"2","querycondition":[{"datapointid":"1","datapointoptions":["18","19","20","34"]},{"datapointid":"2","datapointoptions":null}]}', CAST(N'2015-07-30 15:44:06.647' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (77, N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-07-30 15:44:06.660' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (78, N'{"projectid":"13","reqn":"300","specialty":"2","querycondition":[{"datapointid":"1","datapointoptions":["18","19","20","34"]},{"datapointid":"2","datapointoptions":null}]}', CAST(N'2015-07-30 15:44:16.783' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (79, N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-07-30 15:44:16.813' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (80, N'{"projectid":"13","reqn":"300","specialty":"1","querycondition":[{"datapointid":"5","datapointoptions":["1"]},{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"8","datapointoptions":["6","10"]}]}', CAST(N'2015-07-30 15:54:31.163' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (81, N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-07-30 15:54:31.183' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (82, N'{"projectid":"13","reqn":"300","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6","10"]}]}', CAST(N'2015-07-30 15:54:43.300' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (83, N'{"success":true,"queryid":9,"projectid":13,"feasibility":0}', CAST(N'2015-07-30 15:54:43.367' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (84, N'{"name":"SHC 1","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3717&crowdId=3600&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15073","surveytopic":"TODO Define topic"}', CAST(N'2015-07-30 15:55:35.140' AS DateTime), N'{"projectid":32,"success":true}', CAST(N'2015-07-30 15:55:35.147' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (85, N'{"projectid":"32","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]}]}', CAST(N'2015-07-30 15:55:35.230' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (86, N'{"success":true,"queryid":10,"projectid":32,"feasibility":1}', CAST(N'2015-07-30 15:55:35.277' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (87, N'{"projectid":"32","statusid":"1"}', CAST(N'2015-07-30 15:55:35.990' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (88, N'{"projectid":32,"success":true}', CAST(N'2015-07-30 15:55:36.007' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (89, N'{"projectid":"13","reqn":"300","specialty":"1","querycondition":[{"datapointid":"5","datapointoptions":["1"]},{"datapointid":"8","datapointoptions":["6","10"]}]}', CAST(N'2015-07-30 15:58:07.197' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (90, N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-07-30 15:58:07.237' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (91, N'{"projectid":"13","reqn":"300","specialty":"1","querycondition":[{"datapointid":"1","datapointoptions":["1"]},{"datapointid":"8","datapointoptions":["6","10"]}]}', CAST(N'2015-07-30 15:58:17.503' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (92, N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-07-30 15:58:17.520' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (93, N'{"projectid":"13","reqn":"300","specialty":"3","querycondition":[]}', CAST(N'2015-07-30 15:58:41.200' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (94, N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-07-30 15:58:41.250' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (95, N'{"projectid":"13","reqn":"300","specialty":"3","querycondition":[{"datapointid":"1","datapointoptions":["2"]}]}', CAST(N'2015-07-30 15:59:25.987' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (96, N'{"success":true,"queryid":14,"projectid":13,"feasibility":7}', CAST(N'2015-07-30 15:59:26.023' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (97, N'{"projectid":"13","statusid":"1"}', CAST(N'2015-07-30 15:59:45.873' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (98, N'{"projectid":13,"success":true}', CAST(N'2015-07-30 15:59:45.910' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (99, N'{"name":"BSC SHC 1","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15285","surveytopic":"TODO Define topic"}', CAST(N'2015-07-31 13:08:04.717' AS DateTime), N'{"projectid":33,"success":true}', CAST(N'2015-07-31 13:08:04.740' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (100, N'{"projectid":"33","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["2"]},{"datapointid":"5","datapointoptions":["1"]}]}', CAST(N'2015-07-31 13:08:05.140' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (101, N'{"success":true,"queryid":15,"projectid":33,"feasibility":0}', CAST(N'2015-07-31 13:08:05.280' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (102, N'{"projectid":"33","statusid":"1"}', CAST(N'2015-07-31 13:08:05.393' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (103, N'{"projectid":33,"success":true}', CAST(N'2015-07-31 13:08:05.400' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (104, N'{"name":"BSC SHC 1","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15285","surveytopic":"TODO Define topic"}', CAST(N'2015-07-31 13:10:30.407' AS DateTime), N'{"projectid":34,"success":true}', CAST(N'2015-07-31 13:10:30.417' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (105, N'{"projectid":"34","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["6"]},{"datapointid":"1","datapointoptions":["2"]},{"datapointid":"5","datapointoptions":["1"]}]}', CAST(N'2015-07-31 13:10:30.507' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (106, N'{"success":true,"queryid":16,"projectid":34,"feasibility":0}', CAST(N'2015-07-31 13:10:30.573' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (107, N'{"projectid":"34","statusid":"1"}', CAST(N'2015-07-31 13:10:30.653' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (108, N'{"projectid":34,"success":true}', CAST(N'2015-07-31 13:10:30.667' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (109, N'{"projectid":"34","reqn":"300","specialty":"3","querycondition":[{"datapointid":"1","datapointoptions":["2"]}]}', CAST(N'2015-07-31 13:11:04.557' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (110, N'{"success":true,"queryid":17,"projectid":34,"feasibility":7}', CAST(N'2015-07-31 13:11:04.670' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (111, N'{"projectid":"34","statusid":"1"}', CAST(N'2015-07-31 13:11:16.610' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (112, N'', CAST(N'2015-07-31 13:11:16.620' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (113, N'{"projectid":"34","statusid":"1"}', CAST(N'2015-07-31 13:11:25.090' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (114, N'', CAST(N'2015-07-31 13:11:25.093' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (115, N'{"name":"BSC SHC 2","loi":"4","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&thirdPartyResponderId=","emailsubject":"TODO Define subject","referencecode":"15285","surveytopic":"TODO Define topic"}', CAST(N'2015-07-31 13:31:11.350' AS DateTime), N'{"projectid":35,"success":true}', CAST(N'2015-07-31 13:31:11.373' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (116, N'{"projectid":"35","reqn":"300","specialty":"3","querycondition":[{"datapointid":"1","datapointoptions":["2"]}]}', CAST(N'2015-07-31 13:31:23.857' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (117, N'{"success":true,"queryid":18,"projectid":35,"feasibility":7}', CAST(N'2015-07-31 13:31:23.897' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (118, N'{"projectid":"35","statusid":"1"}', CAST(N'2015-07-31 13:31:36.840' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (119, N'{"projectid":35,"success":true}', CAST(N'2015-07-31 13:31:36.877' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (120, N'{"name":"BSC SHC 3","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/#third_party?surveyId=3746&crowdId=3626&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"You''re invited to respond!","referencecode":"15285","surveytopic":"Health Care"}', CAST(N'2015-08-03 16:39:23.997' AS DateTime), N'{"projectid":36,"success":true}', CAST(N'2015-08-03 16:39:24.023' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (121, N'{"projectid":"36","reqn":"300","specialty":"3","querycondition":[{"datapointid":"1","datapointoptions":["2"]}]}', CAST(N'2015-08-03 16:39:35.567' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (122, N'{"success":true,"queryid":19,"projectid":36,"feasibility":7}', CAST(N'2015-08-03 16:39:35.610' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (123, N'{"projectid":"36","statusid":"1"}', CAST(N'2015-08-03 16:39:45.173' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (124, N'{"projectid":36,"success":true}', CAST(N'2015-08-03 16:39:45.190' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (125, N'{"name":"BSC SHC TEST 3","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=3748&crowdId=3626&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"TODO Define subject","referencecode":"15286","surveytopic":"TODO Define topic"}', CAST(N'2015-08-04 10:48:40.680' AS DateTime), N'{"projectid":37,"success":true}', CAST(N'2015-08-04 10:48:40.703' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (126, N'{"name":"BSC SHC TEST 3","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=3748&crowdId=3626&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"TODO Define subject","referencecode":"15286","surveytopic":"TODO Define topic"}', CAST(N'2015-08-04 10:50:32.700' AS DateTime), N'{"projectid":38,"success":true}', CAST(N'2015-08-04 10:50:32.707' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (127, N'{"name":"BSC SHC TEST 3","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=3748&crowdId=3626&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"TODO Define subject","referencecode":"15286","surveytopic":"TODO Define topic"}', CAST(N'2015-08-04 10:53:25.453' AS DateTime), N'{"projectid":39,"success":true}', CAST(N'2015-08-04 10:53:25.467' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (128, N'{"name":"BSC SHC TEST 3","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=3748&crowdId=3626&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"TODO Define subject","referencecode":"15286","surveytopic":"TODO Define topic"}', CAST(N'2015-08-04 10:54:26.050' AS DateTime), N'{"projectid":40,"success":true}', CAST(N'2015-08-04 10:54:26.060' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (129, N'{"projectid":"40","reqn":"10","specialty":"3","querycondition":[{"datapointid":"1","datapointoptions":["2"]},{"datapointid":"5","datapointoptions":["1"]}]}', CAST(N'2015-08-04 10:54:26.190' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (130, N'{"success":true,"queryid":20,"projectid":40,"feasibility":7}', CAST(N'2015-08-04 10:54:26.233' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (131, N'{"projectid":"40","statusid":"1"}', CAST(N'2015-08-04 10:54:26.300' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (132, N'{"projectid":40,"success":true}', CAST(N'2015-08-04 10:54:26.310' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (133, N'{"name":"SHC test 4","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=3749&crowdId=3626&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"TODO Define subject","referencecode":"15287","surveytopic":"TODO Define topic"}', CAST(N'2015-08-04 11:05:32.263' AS DateTime), N'{"projectid":41,"success":true}', CAST(N'2015-08-04 11:05:32.273' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (134, N'{"projectid":"41","reqn":"10","specialty":"3","querycondition":[{"datapointid":"1","datapointoptions":["2"]},{"datapointid":"5","datapointoptions":["1"]}]}', CAST(N'2015-08-04 11:05:32.370' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (135, N'{"success":true,"queryid":21,"projectid":41,"feasibility":7}', CAST(N'2015-08-04 11:05:32.403' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (136, N'{"projectid":"41","statusid":"1"}', CAST(N'2015-08-04 11:05:32.493' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (137, N'{"projectid":41,"success":true}', CAST(N'2015-08-04 11:05:32.503' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (138, N'{"projectid":"41","statusid":"3"}', CAST(N'2015-08-04 13:11:37.170' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (139, N'{"projectid":41,"success":true}', CAST(N'2015-08-04 13:11:37.197' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (140, N'{"projectid":"41","statusid":"1"}', CAST(N'2015-08-04 13:11:50.097' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (141, N'{"success":false,"error":"You cannot activate a closed project ."}', CAST(N'2015-08-04 13:11:50.107' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (142, N'{"name":"SHC TEST","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=3747&crowdId=3626&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"TODO Define subject","referencecode":"15287","surveytopic":"TODO Define topic"}', CAST(N'2015-08-05 11:32:20.910' AS DateTime), N'{"projectid":42,"success":true}', CAST(N'2015-08-05 11:32:20.933' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (143, N'{"projectid":"42","reqn":"10","specialty":"3","querycondition":[{"datapointid":"1","datapointoptions":["2"]},{"datapointid":"5","datapointoptions":["1"]}]}', CAST(N'2015-08-05 11:32:21.093' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (144, N'{"success":true,"queryid":22,"projectid":42,"feasibility":7}', CAST(N'2015-08-05 11:32:21.137' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (145, N'{"projectid":"42","statusid":"1"}', CAST(N'2015-08-05 11:32:21.210' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (146, N'{"projectid":42,"success":true}', CAST(N'2015-08-05 11:32:21.217' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (147, N'{"name":"Test Survey","loi":"3","incidence":"70","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=3837&crowdId=1031&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"15930","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-08-18 09:45:03.570' AS DateTime), N'{"projectid":43,"success":true}', CAST(N'2015-08-18 09:45:03.607' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (148, N'{"projectid":"43","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["64","51","48","36","24"]}]}', CAST(N'2015-08-18 09:45:03.760' AS DateTime), N'{"success":true,"queryid":23,"projectid":43,"feasibility":0}', CAST(N'2015-08-18 09:45:03.817' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (149, N'{"projectid":"43","statusid":"1"}', CAST(N'2015-08-18 09:45:03.897' AS DateTime), N'{"projectid":43,"success":true}', CAST(N'2015-08-18 09:45:03.910' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (150, N'{"name":"Test Survey","loi":"3","incidence":"70","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=3837&crowdId=1031&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"15930","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-08-19 10:44:59.070' AS DateTime), N'{"projectid":44,"success":true}', CAST(N'2015-08-19 10:44:59.093' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (151, N'{"projectid":"44","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["64","51","48","36","24"]}]}', CAST(N'2015-08-19 10:44:59.307' AS DateTime), N'{"success":true,"queryid":24,"projectid":44,"feasibility":0}', CAST(N'2015-08-19 10:44:59.347' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (152, N'{"projectid":"44","statusid":"1"}', CAST(N'2015-08-19 10:44:59.420' AS DateTime), N'{"projectid":44,"success":true}', CAST(N'2015-08-19 10:44:59.430' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (153, N'{"name":"Test Survey","loi":"3","incidence":"70","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=3837&crowdId=1031&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"15930","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-08-19 10:45:38.127' AS DateTime), N'{"projectid":45,"success":true}', CAST(N'2015-08-19 10:45:38.140' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (154, N'{"projectid":"45","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["64","51","48","36","24"]}]}', CAST(N'2015-08-19 10:45:38.203' AS DateTime), N'{"success":true,"queryid":25,"projectid":45,"feasibility":0}', CAST(N'2015-08-19 10:45:38.230' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (155, N'{"projectid":"45","statusid":"1"}', CAST(N'2015-08-19 10:45:38.307' AS DateTime), N'{"projectid":45,"success":true}', CAST(N'2015-08-19 10:45:38.313' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (156, N'{"name":"Test Survey","loi":"3","incidence":"70","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=3837&crowdId=1031&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"15930","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-08-19 10:47:24.350' AS DateTime), N'{"projectid":46,"success":true}', CAST(N'2015-08-19 10:47:24.363' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (157, N'{"projectid":"46","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["64","51","48","36","24"]}]}', CAST(N'2015-08-19 10:47:24.430' AS DateTime), N'{"success":true,"queryid":26,"projectid":46,"feasibility":0}', CAST(N'2015-08-19 10:47:24.443' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (158, N'{"projectid":"46","statusid":"1"}', CAST(N'2015-08-19 10:47:24.500' AS DateTime), N'{"projectid":46,"success":true}', CAST(N'2015-08-19 10:47:24.507' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (159, N'{"name":"Test Survey","loi":"3","incidence":"70","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=3837&crowdId=1031&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"15930","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-08-19 10:48:19.220' AS DateTime), N'{"projectid":47,"success":true}', CAST(N'2015-08-19 10:48:19.230' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (160, N'{"projectid":"47","reqn":"10","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["64","51","48","36","24"]}]}', CAST(N'2015-08-19 10:48:19.300' AS DateTime), N'{"success":true,"queryid":27,"projectid":47,"feasibility":0}', CAST(N'2015-08-19 10:48:19.317' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (161, N'{"projectid":"47","statusid":"1"}', CAST(N'2015-08-19 10:48:19.373' AS DateTime), N'{"projectid":47,"success":true}', CAST(N'2015-08-19 10:48:19.380' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (162, N'{"projectid":"35","reqn":"300","specialty":"3","querycondition":[{"datapointid":null,"datapointoptions":null}]}', CAST(N'2015-08-20 15:06:23.153' AS DateTime), N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-08-20 15:06:23.177' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (163, N'{"projectid":"35","reqn":"300","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}]}', CAST(N'2015-08-24 15:24:23.540' AS DateTime), N'{"success":true,"queryid":28,"projectid":35,"feasibility":0}', CAST(N'2015-08-24 15:24:23.593' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (164, N'{"success":false,"error":"Invalid Data."}', CAST(N'2015-08-24 15:24:32.127' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (165, N'{"name":"Testing SHC","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=3838&crowdId=1031&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"15931","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-08-24 16:36:05.887' AS DateTime), N'{"projectid":48,"success":true}', CAST(N'2015-08-24 16:36:05.917' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (166, N'{"projectid":"48","reqn":"10","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}]}', CAST(N'2015-08-24 16:36:06.080' AS DateTime), N'{"success":true,"queryid":29,"projectid":48,"feasibility":0}', CAST(N'2015-08-24 16:36:06.123' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (167, N'{"projectid":"48","statusid":"1"}', CAST(N'2015-08-24 16:36:06.213' AS DateTime), N'{"projectid":48,"success":true}', CAST(N'2015-08-24 16:36:06.223' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (168, N'{"projectid":"48","statusid":"3"}', CAST(N'2015-08-25 09:31:00.900' AS DateTime), N'{"projectid":48,"success":true}', CAST(N'2015-08-25 09:31:00.940' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (169, N'{"projectid":"48","statusid":"1"}', CAST(N'2015-08-25 09:31:12.207' AS DateTime), N'', CAST(N'2015-08-25 09:31:12.217' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (170, N'{"projectid":"48","statusid":"1"}', CAST(N'2015-08-25 09:34:12.300' AS DateTime), N'', CAST(N'2015-08-25 09:34:12.310' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (171, N'{"projectid":"48","statusid":"1"}', CAST(N'2015-08-25 09:38:26.890' AS DateTime), N'', CAST(N'2015-08-25 09:38:26.900' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (172, N'{"projectid":"48","statusid":"1"}', CAST(N'2015-08-25 10:05:14.973' AS DateTime), N'', CAST(N'2015-08-25 10:05:14.990' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (173, N'{"success":false,"error":"Authentication Failed."}', CAST(N'2015-08-25 11:55:16.223' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (174, N'{"success":false,"error":"Authentication Failed."}', CAST(N'2015-08-25 11:55:25.747' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (175, N'29', CAST(N'2015-08-25 12:20:14.337' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-08-25 12:20:14.563' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (176, N'{"name":"title","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=3839&crowdId=1031&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"15932","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-08-25 12:41:43.593' AS DateTime), N'{"projectid":49,"success":true}', CAST(N'2015-08-25 12:41:43.620' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (177, N'{"projectid":"49","reqn":"1","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["64","51","48","36","24"]}]}', CAST(N'2015-08-25 12:41:43.790' AS DateTime), N'{"success":true,"queryid":30,"projectid":49,"feasibility":0}', CAST(N'2015-08-25 12:41:43.827' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (178, N'{"projectid":"49","statusid":"1"}', CAST(N'2015-08-25 12:41:43.923' AS DateTime), N'{"projectid":49,"success":true}', CAST(N'2015-08-25 12:41:43.937' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (179, N'{"projectid":"49","statusid":"3"}', CAST(N'2015-08-25 12:42:02.537' AS DateTime), N'{"projectid":49,"success":true}', CAST(N'2015-08-25 12:42:02.547' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (180, N'{"projectid":"49","statusid":"1"}', CAST(N'2015-08-25 12:42:57.380' AS DateTime), N'', CAST(N'2015-08-25 12:42:57.400' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (181, N'{"name":"test","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=3840&crowdId=1031&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"15933","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-08-25 12:45:39.810' AS DateTime), N'{"projectid":50,"success":true}', CAST(N'2015-08-25 12:45:39.843' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (182, N'{"projectid":"50","reqn":"1","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}]}', CAST(N'2015-08-25 12:45:39.990' AS DateTime), N'{"success":true,"queryid":31,"projectid":50,"feasibility":0}', CAST(N'2015-08-25 12:45:40.050' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (183, N'{"projectid":"50","statusid":"1"}', CAST(N'2015-08-25 12:45:40.120' AS DateTime), N'{"projectid":50,"success":true}', CAST(N'2015-08-25 12:45:40.133' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (184, N'31', CAST(N'2015-08-25 12:45:58.670' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-08-25 12:45:58.690' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (185, N'31', CAST(N'2015-08-25 12:51:34.030' AS DateTime), N'{"success":true,"queryid":31}', CAST(N'2015-08-25 12:51:34.067' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (186, N'31', CAST(N'2015-08-25 13:17:13.687' AS DateTime), N'{"success":true,"queryid":31}', CAST(N'2015-08-25 13:17:13.910' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (187, N'31', CAST(N'2015-08-26 10:29:33.113' AS DateTime), N'{"success":true,"queryid":31}', CAST(N'2015-08-26 10:29:33.340' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (188, N'{"success":false,"error":"Authentication Failed."}', CAST(N'2015-08-30 23:32:52.930' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (189, N'{"success":false,"error":"Authentication Failed."}', CAST(N'2015-08-30 23:33:27.890' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (190, N'{"name":"121","loi":"10","incidence":"100","surveylink":"http://ss.opinionsite.com?id=","emailsubject":"TEST 7 SURVEY4","referencecode":"100","surveytopic":"test  sch tes3"}', CAST(N'2015-08-31 04:09:24.163' AS DateTime), N'{"projectid":51,"success":true}', CAST(N'2015-08-31 04:09:24.197' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (191, N'{"name":"121","loi":"10","incidence":"100","surveylink":"http://ss.opinionsite.com?id=","emailsubject":"TEST 7 SURVEY4","referencecode":"100","surveytopic":"test  sch tes3"}', CAST(N'2015-08-31 04:09:46.033' AS DateTime), N'{"projectid":52,"success":true}', CAST(N'2015-08-31 04:09:46.060' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (192, N'{"name":"121","loi":"10","incidence":"100","surveylink":"http://ss.opinionsite.com?id=","emailsubject":"TEST 7 SURVEY4","referencecode":"100","surveytopic":"test  sch tes3"}', CAST(N'2015-08-31 04:20:33.773' AS DateTime), N'{"projectid":53,"success":true}', CAST(N'2015-08-31 04:20:33.817' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (193, N'{"name":"121","loi":"10","incidence":"100","surveylink":"http://ss.opinionsite.com?id=","emailsubject":"TEST 7 SURVEY4","referencecode":"100","surveytopic":"test  sch tes3"}', CAST(N'2015-08-31 05:02:50.600' AS DateTime), N'{"projectid":54,"success":true}', CAST(N'2015-08-31 05:02:50.623' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (194, N'{"success":false,"error":"Authentication Failed."}', CAST(N'2015-08-31 05:08:54.373' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (195, N'{"success":false,"error":"Authentication Failed."}', CAST(N'2015-08-31 09:31:47.127' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (196, N'{"name":"this is a test survey","loi":"1","incidence":"0","surveylink":"https://web-qa.incrowdanswers.com/answer/?thirdParty=true&surveyId=3887&crowdId=1031&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"16033","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-08-31 09:32:10.740' AS DateTime), N'{"projectid":55,"success":true}', CAST(N'2015-08-31 09:32:10.770' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (197, N'{"name":"test SHC reminders","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=3841&crowdId=1031&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"15934","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-08-31 10:41:12.007' AS DateTime), N'{"projectid":56,"success":true}', CAST(N'2015-08-31 10:41:12.030' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (198, N'{"projectid":"56","reqn":"10","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}]}', CAST(N'2015-08-31 10:41:12.170' AS DateTime), N'{"success":true,"queryid":32,"projectid":56,"feasibility":0}', CAST(N'2015-08-31 10:41:12.217' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (199, N'{"projectid":"56","statusid":"1"}', CAST(N'2015-08-31 10:41:12.400' AS DateTime), N'{"projectid":56,"success":true}', CAST(N'2015-08-31 10:41:12.417' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (200, N'{"projectid":"56","statusid":"3"}', CAST(N'2015-08-31 10:45:35.680' AS DateTime), N'{"projectid":56,"success":true}', CAST(N'2015-08-31 10:45:35.717' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (201, N'{"projectid":"56","statusid":"1"}', CAST(N'2015-08-31 10:45:44.603' AS DateTime), N'', CAST(N'2015-08-31 10:45:44.610' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (202, N'32', CAST(N'2015-08-31 11:05:12.773' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-08-31 11:05:12.807' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (203, N'31', CAST(N'2015-08-31 11:05:33.910' AS DateTime), N'{"success":true,"queryid":31}', CAST(N'2015-08-31 11:05:33.930' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (204, N'32', CAST(N'2015-08-31 11:05:46.917' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-08-31 11:05:46.927' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (205, N'{"name":"test shc reminders 2","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=3842&crowdId=1031&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"15935","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-08-31 11:07:20.240' AS DateTime), N'{"projectid":57,"success":true}', CAST(N'2015-08-31 11:07:20.273' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (206, N'{"projectid":"57","reqn":"10","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}]}', CAST(N'2015-08-31 11:07:20.340' AS DateTime), N'{"success":true,"queryid":33,"projectid":57,"feasibility":0}', CAST(N'2015-08-31 11:07:20.373' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (207, N'{"projectid":"57","statusid":"1"}', CAST(N'2015-08-31 11:07:20.453' AS DateTime), N'{"projectid":57,"success":true}', CAST(N'2015-08-31 11:07:20.467' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (208, N'33', CAST(N'2015-08-31 11:07:39.037' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-08-31 11:07:39.047' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (209, N'33', CAST(N'2015-08-31 11:07:48.507' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-08-31 11:07:48.513' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (210, N'33', CAST(N'2015-08-31 11:07:49.490' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-08-31 11:07:49.503' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (211, N'33', CAST(N'2015-08-31 11:09:01.560' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-08-31 11:09:01.570' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (212, N'33', CAST(N'2015-08-31 11:11:35.187' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-08-31 11:11:35.197' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (213, N'33', CAST(N'2015-08-31 11:11:36.317' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-08-31 11:11:36.323' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (214, N'32', CAST(N'2015-08-31 11:11:41.663' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-08-31 11:11:41.673' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (215, N'57', CAST(N'2015-08-31 11:12:32.900' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-08-31 11:12:32.910' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (216, N'33', CAST(N'2015-08-31 11:12:40.167' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-08-31 11:12:40.177' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (217, N'33', CAST(N'2015-08-31 11:31:23.620' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-08-31 11:31:23.630' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (218, N'32', CAST(N'2015-08-31 11:31:30.430' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-08-31 11:31:30.437' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (219, N'32', CAST(N'2015-08-31 11:32:09.570' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-08-31 11:32:09.583' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (220, N'32', CAST(N'2015-08-31 11:32:16.013' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-08-31 11:32:16.027' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (221, N'32', CAST(N'2015-08-31 11:40:28.067' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-08-31 11:40:28.077' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (222, N'32', CAST(N'2015-08-31 11:45:29.553' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-08-31 11:45:29.567' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (223, N'32', CAST(N'2015-08-31 13:20:08.263' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-08-31 13:20:08.487' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (224, N'{"projectid":"56","statusid":"1"}', CAST(N'2015-08-31 13:20:45.700' AS DateTime), N'', CAST(N'2015-08-31 13:20:45.713' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (225, N'{"projectid":"56","statusid":"1"}', CAST(N'2015-08-31 13:21:56.777' AS DateTime), N'', CAST(N'2015-08-31 13:21:56.793' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (226, N'{"projectid":"56","statusid":"1"}', CAST(N'2015-08-31 13:22:06.333' AS DateTime), N'', CAST(N'2015-08-31 13:22:06.347' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (227, N'{"projectid":"56","statusid":"1"}', CAST(N'2015-08-31 13:22:28.863' AS DateTime), N'', CAST(N'2015-08-31 13:22:28.870' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (228, N'{"projectid":"56","statusid":"1"}', CAST(N'2015-08-31 13:23:56.917' AS DateTime), N'', CAST(N'2015-08-31 13:23:56.920' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (229, N'{"projectid":"56","statusid":"1"}', CAST(N'2015-08-31 13:24:15.120' AS DateTime), N'', CAST(N'2015-08-31 13:24:15.147' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (230, N'{"projectid":"56","statusid":"1"}', CAST(N'2015-08-31 13:24:24.463' AS DateTime), N'', CAST(N'2015-08-31 13:24:24.510' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (231, N'{"projectid":"56","statusid":"1"}', CAST(N'2015-08-31 13:35:48.780' AS DateTime), N'', CAST(N'2015-08-31 13:35:48.783' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (232, N'{"projectid":"56","statusid":"1"}', CAST(N'2015-08-31 13:35:52.830' AS DateTime), N'', CAST(N'2015-08-31 13:35:52.843' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (233, N'{"name":"this is a test survey","loi":"1","incidence":"0","surveylink":"https://web-qa.incrowdanswers.com/answer/?thirdParty=true&surveyId=3887&crowdId=1031&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"16033","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-08-31 13:38:34.700' AS DateTime), N'{"projectid":58,"success":true}', CAST(N'2015-08-31 13:38:34.733' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (234, N'{"projectid":"56","statusid":"1"}', CAST(N'2015-08-31 13:40:03.770' AS DateTime), N'', CAST(N'2015-08-31 13:40:03.783' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (235, N'{"projectid":"57","statusid":"1"}', CAST(N'2015-08-31 13:40:24.947' AS DateTime), N'', CAST(N'2015-08-31 13:40:24.957' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (236, N'{"projectid":"56","statusid":"1"}', CAST(N'2015-08-31 13:40:34.763' AS DateTime), N'', CAST(N'2015-08-31 13:40:34.773' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (237, N'{"name":"test shc reminders 2","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=3842&crowdId=1031&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"15935","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-08-31 14:02:06.683' AS DateTime), N'{"projectid":59,"success":true}', CAST(N'2015-08-31 14:02:06.720' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (238, N'{"projectid":"59","reqn":"10","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}]}', CAST(N'2015-08-31 14:02:07.080' AS DateTime), N'{"success":true,"queryid":34,"projectid":59,"feasibility":0}', CAST(N'2015-08-31 14:02:07.130' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (239, N'{"projectid":"59","statusid":"1"}', CAST(N'2015-08-31 14:02:07.210' AS DateTime), N'{"projectid":59,"success":true}', CAST(N'2015-08-31 14:02:07.223' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (240, N'{"name":"test shc reminders 2","loi":"1","incidence":"70","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=3842&crowdId=1031&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"15935","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-08-31 14:03:07.540' AS DateTime), N'{"projectid":60,"success":true}', CAST(N'2015-08-31 14:03:07.550' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (241, N'{"projectid":"60","reqn":"10","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}]}', CAST(N'2015-08-31 14:03:07.643' AS DateTime), N'{"success":true,"queryid":35,"projectid":60,"feasibility":0}', CAST(N'2015-08-31 14:03:07.667' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (242, N'{"projectid":"60","statusid":"1"}', CAST(N'2015-08-31 14:03:07.737' AS DateTime), N'{"projectid":60,"success":true}', CAST(N'2015-08-31 14:03:07.760' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (243, N'35', CAST(N'2015-08-31 14:07:34.317' AS DateTime), N'{"success":true,"queryid":35}', CAST(N'2015-08-31 14:07:34.333' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (244, N'{"success":false,"error":"Authentication Failed."}', CAST(N'2015-09-09 10:55:54.303' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (245, N'{"success":false,"error":"Authentication Failed."}', CAST(N'2015-09-09 10:55:54.330' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (246, N'{"name":"Wesley 1","loi":"10","incidence":"10","surveylink":"https://www.google.com/?q=fuzzy+bunnies","emailsubject":"Fast Survey for Medical Professionals","referencecode":"10028","surveytopic":"Your Expertise Required! Fabulous Rewards Promised!"}', CAST(N'2015-09-09 10:56:22.403' AS DateTime), N'{"projectid":61,"success":true}', CAST(N'2015-09-09 10:56:22.433' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (247, N'{"projectid":"61","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-09-09 10:58:40.260' AS DateTime), N'{"success":true,"queryid":36,"projectid":61,"feasibility":0}', CAST(N'2015-09-09 10:58:40.363' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (248, N'{"projectid":"61","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["9999999999"]}', CAST(N'2015-09-09 11:00:25.553' AS DateTime), N'{"success":true,"queryid":37,"projectid":61,"feasibility":0}', CAST(N'2015-09-09 11:00:25.637' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (249, N'{"name":"Wesley 2","loi":"10","incidence":"100","surveylink":"https://www.google.com/?q=fuzzy+bunnies","emailsubject":"Fast Survey for Medical Professionals","referencecode":"10029","surveytopic":"Your Expertise Required! Fabulous Rewards Promised!"}', CAST(N'2015-09-09 11:02:02.470' AS DateTime), N'{"projectid":62,"success":true}', CAST(N'2015-09-09 11:02:02.513' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (250, N'{"success":false,"error":"Invalid Data."}', CAST(N'2015-09-09 11:02:38.430' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (251, N'{"projectid":"62","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-09-09 11:03:00.883' AS DateTime), N'{"success":true,"queryid":38,"projectid":62,"feasibility":1}', CAST(N'2015-09-09 11:03:00.920' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (252, N'{"projectid":"62","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["9999999999"]}', CAST(N'2015-09-09 11:03:29.217' AS DateTime), N'{"success":true,"queryid":39,"projectid":62,"feasibility":0}', CAST(N'2015-09-09 11:03:29.243' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (253, N'{"projectid":"62","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["9999999998"]}', CAST(N'2015-09-09 11:25:49.263' AS DateTime), N'{"success":true,"queryid":40,"projectid":62,"feasibility":0}', CAST(N'2015-09-09 11:25:49.333' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (254, N'{"projectid":"62","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-09-09 11:26:01.543' AS DateTime), N'{"success":true,"queryid":41,"projectid":62,"feasibility":0}', CAST(N'2015-09-09 11:26:01.600' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (255, N'{"name":"Wesley 3","loi":"10","incidence":"100","surveylink":"https://www.google.com/?q=fuzzy+bunnies","emailsubject":"Fast Survey for Medical Professionals","referencecode":"10030","surveytopic":"Your Expertise Required! Fabulous Rewards Promised!"}', CAST(N'2015-09-09 11:26:39.487' AS DateTime), N'{"projectid":63,"success":true}', CAST(N'2015-09-09 11:26:39.507' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (256, N'{"name":"Wesley 4","loi":"10","incidence":"100","surveylink":"https://www.google.com/?q=fuzzy+bunnies","emailsubject":"Fast Survey for Medical Professionals","referencecode":"10031","surveytopic":"Your Expertise Required! Fabulous Rewards Promised!"}', CAST(N'2015-09-09 11:36:02.853' AS DateTime), N'{"projectid":64,"success":true}', CAST(N'2015-09-09 11:36:02.867' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (257, N'{"projectid":"64","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["9999999998"]}', CAST(N'2015-09-09 11:36:30.637' AS DateTime), N'{"success":true,"queryid":42,"projectid":64,"feasibility":1}', CAST(N'2015-09-09 11:36:30.673' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (258, N'{"name":"Wesley 5","loi":"10","incidence":"100","surveylink":"https://www.google.com/?q=fuzzy+bunnies","emailsubject":"Fast Survey for Medical Professionals","referencecode":"10032","surveytopic":"Your Expertise Required! Fabulous Rewards Promised!"}', CAST(N'2015-09-09 11:37:06.320' AS DateTime), N'{"projectid":65,"success":true}', CAST(N'2015-09-09 11:37:06.330' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (259, N'{"projectid":"65","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["9999999999"]}', CAST(N'2015-09-09 11:37:31.977' AS DateTime), N'{"success":true,"queryid":43,"projectid":65,"feasibility":1}', CAST(N'2015-09-09 11:37:32.007' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (260, N'{"name":"Wesley 6","loi":"10","incidence":"100","surveylink":"https://www.google.com/?q=fuzzy+bunnies","emailsubject":"Fast Survey for Medical Professionals","referencecode":"10033","surveytopic":"Your Expertise Required! Fabulous Rewards Promised!"}', CAST(N'2015-09-09 11:38:34.583' AS DateTime), N'{"projectid":66,"success":true}', CAST(N'2015-09-09 11:38:34.620' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (261, N'{"projectid":"66","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["9999999999"]}', CAST(N'2015-09-09 11:38:58.540' AS DateTime), N'{"success":true,"queryid":44,"projectid":66,"feasibility":1}', CAST(N'2015-09-09 11:38:58.587' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (262, N'{"success":false,"error":"Invalid Data."}', CAST(N'2015-09-09 13:40:28.643' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (263, N'{"success":false,"error":"Invalid Data."}', CAST(N'2015-09-09 13:40:28.667' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (264, N'{"name":"Wesley 7","loi":"10","incidence":"100","surveylink":"https://www.google.com/?q=fuzzy+bunnies","emailsubject":"Fast Survey for Medical Professionals","referencecode":"10034","surveytopic":"Your Expertise Required! Fabulous Rewards Promised!"}', CAST(N'2015-09-09 13:40:55.000' AS DateTime), N'{"projectid":67,"success":true}', CAST(N'2015-09-09 13:40:55.070' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (265, N'{"projectid":"67","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-09-09 13:41:21.270' AS DateTime), N'{"success":true,"queryid":45,"projectid":67,"feasibility":0}', CAST(N'2015-09-09 13:41:21.373' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (266, N'{"projectid":"68","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-09-09 13:41:45.067' AS DateTime), N'{"success":false,"error":"No project found with this Id."}', CAST(N'2015-09-09 13:41:45.097' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (267, N'{"projectid":"67","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":null}', CAST(N'2015-09-09 13:42:46.170' AS DateTime), N'{"success":true,"queryid":46,"projectid":67,"feasibility":0}', CAST(N'2015-09-09 13:42:46.190' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (268, N'{"success":false,"error":"Invalid Data."}', CAST(N'2015-09-09 13:43:15.337' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (269, N'{"name":"Wesley 8","loi":"10","incidence":"100","surveylink":"https://www.google.com/?q=fuzzy+bunnies","emailsubject":"Fast Survey for Medical Professionals","referencecode":"10035","surveytopic":"Your Expertise Required! Fabulous Rewards Promised!"}', CAST(N'2015-09-09 13:43:23.543' AS DateTime), N'{"projectid":68,"success":true}', CAST(N'2015-09-09 13:43:23.557' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (270, N'{"projectid":"68","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["9999999999"]}', CAST(N'2015-09-09 13:43:52.220' AS DateTime), N'{"success":true,"queryid":47,"projectid":68,"feasibility":0}', CAST(N'2015-09-09 13:43:52.270' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (271, N'{"success":false,"error":"Invalid Data."}', CAST(N'2015-09-09 13:53:44.213' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (272, N'{"name":"Wesley 10","loi":"10","incidence":"100","surveylink":"https://www.google.com/?q=fuzzy+bunnies","emailsubject":"Fast Survey for Medical Professionals","referencecode":"20034","surveytopic":"Your Expertise Required! Fabulous Rewards Promised!"}', CAST(N'2015-09-09 13:53:52.743' AS DateTime), N'{"projectid":69,"success":true}', CAST(N'2015-09-09 13:53:52.770' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (273, N'{"projectid":"69","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":null}', CAST(N'2015-09-09 13:54:59.497' AS DateTime), N'{"success":true,"queryid":48,"projectid":69,"feasibility":0}', CAST(N'2015-09-09 13:54:59.540' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (274, N'{"name":"Wesley 11","loi":"10","incidence":"100","surveylink":"https://www.google.com/?q=fuzzy+bunnies","emailsubject":"Fast Survey for Medical Professionals","referencecode":"20035","surveytopic":"Your Expertise Required! Fabulous Rewards Promised!"}', CAST(N'2015-09-09 13:59:24.713' AS DateTime), N'{"projectid":70,"success":true}', CAST(N'2015-09-09 13:59:24.733' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (275, N'{"projectid":"70","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-09-09 14:01:38.857' AS DateTime), N'{"success":true,"queryid":49,"projectid":70,"feasibility":0}', CAST(N'2015-09-09 14:01:38.883' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (276, N'{"name":"Wesley 12","loi":"10","incidence":"100","surveylink":"https://www.google.com/?q=fuzzy+bunnies","emailsubject":"Fast Survey for Medical Professionals","referencecode":"20036","surveytopic":"Your Expertise Required! Fabulous Rewards Promised!"}', CAST(N'2015-09-09 14:07:03.770' AS DateTime), N'{"projectid":71,"success":true}', CAST(N'2015-09-09 14:07:03.780' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (277, N'{"projectid":"70","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["9999999999"]}', CAST(N'2015-09-09 14:07:26.920' AS DateTime), N'{"success":true,"queryid":50,"projectid":70,"feasibility":0}', CAST(N'2015-09-09 14:07:26.957' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (278, N'{"name":"Wesley 13","loi":"10","incidence":"100","surveylink":"https://www.google.com/?q=fuzzy+bunnies","emailsubject":"Fast Survey for Medical Professionals","referencecode":"20037","surveytopic":"Your Expertise Required! Fabulous Rewards Promised!"}', CAST(N'2015-09-09 14:08:33.403' AS DateTime), N'{"projectid":72,"success":true}', CAST(N'2015-09-09 14:08:33.443' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (279, N'{"projectid":"72","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["9999999998"]}', CAST(N'2015-09-09 14:08:58.603' AS DateTime), N'{"success":true,"queryid":51,"projectid":72,"feasibility":0}', CAST(N'2015-09-09 14:08:58.643' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (280, N'{"name":"Wesley 20","loi":"10","incidence":"100","surveylink":"https://www.google.com/?q=fuzzy+bunnies","emailsubject":"Fast Survey for Medical Professionals","referencecode":"30034","surveytopic":"Your Expertise Required! Fabulous Rewards Promised!"}', CAST(N'2015-09-10 09:45:38.520' AS DateTime), N'{"projectid":73,"success":true}', CAST(N'2015-09-10 09:45:38.547' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (281, N'{"projectid":"73","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":null}', CAST(N'2015-09-10 09:46:01.880' AS DateTime), N'{"success":true,"queryid":52,"projectid":73,"feasibility":0}', CAST(N'2015-09-10 09:46:01.923' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (282, N'{"name":"Wesley 21","loi":"10","incidence":"100","surveylink":"https://www.google.com/?q=fuzzy+bunnies","emailsubject":"Fast Survey for Medical Professionals","referencecode":"30035","surveytopic":"Your Expertise Required! Fabulous Rewards Promised!"}', CAST(N'2015-09-10 09:47:01.093' AS DateTime), N'{"projectid":74,"success":true}', CAST(N'2015-09-10 09:47:01.103' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (283, N'{"projectid":"74","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-09-10 09:47:36.690' AS DateTime), N'{"success":true,"queryid":53,"projectid":74,"feasibility":0}', CAST(N'2015-09-10 09:47:36.717' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (284, N'{"name":"Wesley 22","loi":"10","incidence":"100","surveylink":"https://www.google.com/?q=fuzzy+bunnies","emailsubject":"Fast Survey for Medical Professionals","referencecode":"30036","surveytopic":"Your Expertise Required! Fabulous Rewards Promised!"}', CAST(N'2015-09-10 09:48:15.000' AS DateTime), N'{"projectid":75,"success":true}', CAST(N'2015-09-10 09:48:15.013' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (285, N'{"projectid":"75","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["9999999998"]}', CAST(N'2015-09-10 09:48:47.463' AS DateTime), N'{"success":true,"queryid":54,"projectid":75,"feasibility":0}', CAST(N'2015-09-10 09:48:47.490' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (286, N'{"name":"Wesley 23","loi":"10","incidence":"100","surveylink":"https://www.google.com/?q=fuzzy+bunnies","emailsubject":"Fast Survey for Medical Professionals","referencecode":"30037","surveytopic":"Your Expertise Required! Fabulous Rewards Promised!"}', CAST(N'2015-09-10 09:49:21.280' AS DateTime), N'{"projectid":76,"success":true}', CAST(N'2015-09-10 09:49:21.293' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (287, N'{"projectid":"76","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["9999999999"]}', CAST(N'2015-09-10 09:50:01.910' AS DateTime), N'{"success":true,"queryid":55,"projectid":76,"feasibility":0}', CAST(N'2015-09-10 09:50:01.933' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (288, N'{"name":"Wesley 24","loi":"10","incidence":"100","surveylink":"https://www.google.com/?q=fuzzy+bunnies","emailsubject":"Fast Survey for Medical Professionals","referencecode":"30038","surveytopic":"Your Expertise Required! Fabulous Rewards Promised!"}', CAST(N'2015-09-10 12:15:18.730' AS DateTime), N'{"projectid":77,"success":true}', CAST(N'2015-09-10 12:15:18.757' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (289, N'{"projectid":"76","reqn":"50","specialty":"3","querycondition":[],"exclusions":null}', CAST(N'2015-09-10 12:15:55.657' AS DateTime), N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-09-10 12:15:55.687' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (290, N'{"projectid":"77","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc","K_ac0d9c8d23"]}],"exclusions":["9999999999"]}', CAST(N'2015-09-10 12:17:37.343' AS DateTime), N'{"success":true,"queryid":57,"projectid":77,"feasibility":0}', CAST(N'2015-09-10 12:17:37.400' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (291, N'{"name":"Wesley 30","loi":"10","incidence":"100","surveylink":"https://www.google.com/?q=fuzzy+bunnies","emailsubject":"Fast Survey for Medical Professionals","referencecode":"40034","surveytopic":"Your Expertise Required! Fabulous Rewards Promised!"}', CAST(N'2015-09-11 10:16:36.047' AS DateTime), N'{"projectid":78,"success":true}', CAST(N'2015-09-11 10:16:36.103' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (292, N'{"name":"Wesley 30","loi":"10","incidence":"100","surveylink":"https://www.google.com/?q=fuzzy+bunnies","emailsubject":"Fast Survey for Medical Professionals","referencecode":"40034","surveytopic":"Your Expertise Required! Fabulous Rewards Promised!"}', CAST(N'2015-09-11 10:16:49.323' AS DateTime), N'{"projectid":79,"success":true}', CAST(N'2015-09-11 10:16:49.350' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (293, N'{"projectid":"79","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":null}', CAST(N'2015-09-11 10:19:37.563' AS DateTime), N'{"success":true,"queryid":58,"projectid":79,"feasibility":1}', CAST(N'2015-09-11 10:19:37.783' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (294, N'{"name":"Wesley 31","loi":"10","incidence":"100","surveylink":"https://www.google.com/?q=fuzzy+bunnies","emailsubject":"Fast Survey for Medical Professionals","referencecode":"40035","surveytopic":"Your Expertise Required! Fabulous Rewards Promised!"}', CAST(N'2015-09-11 10:20:27.493' AS DateTime), N'{"projectid":80,"success":true}', CAST(N'2015-09-11 10:20:27.513' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (295, N'{"projectid":"80","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-09-11 10:20:56.100' AS DateTime), N'{"success":true,"queryid":59,"projectid":80,"feasibility":1}', CAST(N'2015-09-11 10:20:56.143' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (296, N'{"name":"Wesley 32","loi":"10","incidence":"100","surveylink":"https://www.google.com/?q=fuzzy+bunnies","emailsubject":"Fast Survey for Medical Professionals","referencecode":"30036","surveytopic":"Your Expertise Required! Fabulous Rewards Promised!"}', CAST(N'2015-09-11 10:21:29.707' AS DateTime), N'{"projectid":81,"success":true}', CAST(N'2015-09-11 10:21:29.743' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (297, N'{"projectid":"81","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["9999999998"]}', CAST(N'2015-09-11 10:21:57.583' AS DateTime), N'{"success":true,"queryid":60,"projectid":81,"feasibility":1}', CAST(N'2015-09-11 10:21:57.643' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (298, N'{"name":"Wesley 33","loi":"10","incidence":"100","surveylink":"https://www.google.com/?q=fuzzy+bunnies","emailsubject":"Fast Survey for Medical Professionals","referencecode":"40037","surveytopic":"Your Expertise Required! Fabulous Rewards Promised!"}', CAST(N'2015-09-11 10:22:28.940' AS DateTime), N'{"projectid":82,"success":true}', CAST(N'2015-09-11 10:22:28.963' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (299, N'{"projectid":"82","reqn":"50","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["9999999999"]}', CAST(N'2015-09-11 10:22:50.150' AS DateTime), N'{"success":true,"queryid":61,"projectid":82,"feasibility":0}', CAST(N'2015-09-11 10:22:50.183' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (300, N'{"name":"T-Vec Concept Survey","loi":"8","incidence":"0","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=3959&crowdId=3745&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"16398","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-09-14 15:02:40.970' AS DateTime), N'{"projectid":83,"success":true}', CAST(N'2015-09-14 15:02:40.997' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (301, N'{"projectid":"83","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-09-14 15:02:41.120' AS DateTime), N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-09-14 15:02:41.163' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (302, N'{"name":"T-Vec Concept Survey","loi":"8","incidence":"0","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=3959&crowdId=3745&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"16398","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-09-14 15:03:57.297' AS DateTime), N'{"projectid":84,"success":true}', CAST(N'2015-09-14 15:03:57.310' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (303, N'{"projectid":"84","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-09-14 15:03:59.690' AS DateTime), N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-09-14 15:03:59.717' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (304, N'{"projectid":"84","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-09-14 15:05:51.323' AS DateTime), N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-09-14 15:05:51.387' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (305, N'{"projectid":"83","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-09-14 15:15:41.420' AS DateTime), N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-09-14 15:15:41.450' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (306, N'{"projectid":"80","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-09-14 15:15:48.587' AS DateTime), N'{"success":true,"queryid":66,"projectid":80,"feasibility":0}', CAST(N'2015-09-14 15:15:48.613' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (307, N'{"projectid":"81","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-09-14 15:16:01.600' AS DateTime), N'{"success":true,"queryid":67,"projectid":81,"feasibility":0}', CAST(N'2015-09-14 15:16:01.620' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (308, N'{"projectid":"82","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-09-14 15:16:09.633' AS DateTime), N'{"success":true,"queryid":68,"projectid":82,"feasibility":1}', CAST(N'2015-09-14 15:16:09.657' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (309, N'{"projectid":"83","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-09-14 15:16:16.663' AS DateTime), N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-09-14 15:16:16.690' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (310, N'{"projectid":"85","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-09-14 15:16:23.410' AS DateTime), N'{"success":false,"error":"No project found with this Id."}', CAST(N'2015-09-14 15:16:23.417' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (311, N'{"projectid":"83","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-09-14 15:16:31.520' AS DateTime), N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-09-14 15:16:31.557' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (312, N'{"name":"T-Vec Concept Survey","loi":"8","incidence":"0","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=3959&crowdId=3745&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"16398","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-09-14 15:25:49.087' AS DateTime), N'{"projectid":85,"success":true}', CAST(N'2015-09-14 15:25:49.097' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (313, N'{"projectid":"85","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["1285634196","","","","1659484145","1205896362","","1790778793","","1881667137","1689650327","1265472849","1255375135","1417927732","","1487811931\t","","1003801853","1689686677","1235179839","1811934680","1669687299","1205948288","1356315303","1164403127","1902830888","1902830888","1902830888","1134143506","","","1104998194","","","1316942170","1285770925","1053419192","1083630834","","1598711251","","","","1053336354","","1497719959","","1689684524","1033145701","1043316615","1134172364","1770578031","1790878809","1619101268","","1972529717","","1346238284","","1841293933","1366415804","1295819357","1265427496","1730175266","","1629064605","1003093600","1427011444","1790725125","","1144228966","1992898977","1750376380","1144250739","4631256798","1467720045","1376645838","1134115397","1275546038","1992762108","1992762108","016027204185","495167700147","","1144338161","umpa","Health first cardiology","1902824287 ","AK3205285","1932157302","1710071717","1104828300","1083656821","1073680393","1306830682","1760504351","1376659813","1457387888","1720190986","1821094665","1174525778","1003837873","1942296140","1083766729","1578670154","1508035163","1871546523","1912997321","1386640522","1356360887","1427254432","1235227133","1669574976","NA","1184652638","1730137688","NA","Na","1982631966","NA","1780603860","1780651497","1679747950","1588690440","1063495893","1710967153","1649360447","1578572327","1902924152","1831172840","1558362152","1265446371","1467482703","1922070291","1497742381","1962460501","1023061850","1881695302","1437166394","1104822261","1225063902","1376569061","1295739274","1316912918","1255313540","1477635084","1982795894","1144288069","1164494563","1295765659","1659310761","1447342951","1639141229","Penn Medicine Valley Forge","1275786352","1609849256","1376675637","1790784395","1619987930","1811959869","1003961764","136', CAST(N'2015-09-14 15:25:49.217' AS DateTime), N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-09-14 15:25:49.237' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (314, N'{"name":"T-Vec Concept Survey","loi":"8","incidence":"0","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=3959&crowdId=3745&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"16398","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-09-14 15:27:49.957' AS DateTime), N'{"projectid":86,"success":true}', CAST(N'2015-09-14 15:27:49.970' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (315, N'{"projectid":"86","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["1285634196","1659484145","1205896362","1790778793","1881667137","1689650327","1265472849","1255375135","1417927732","1487811931","1003801853","1689686677","1235179839","1811934680","1669687299","1205948288","1356315303","1164403127","1902830888","1902830888","1902830888","1134143506","1104998194","1316942170","1285770925","1053419192","1083630834","1598711251","1053336354","1497719959","1689684524","1033145701","1043316615","1134172364","1770578031","1790878809","1619101268","1972529717","1346238284","1841293933","1366415804","1295819357","1265427496","1730175266","1629064605","1003093600","1427011444","1790725125","1144228966","1992898977","1750376380","1144250739","4631256798","1467720045","1376645838","1134115397","1275546038","1992762108","1992762108","016027204185","495167700147","1144338161","umpa","Health first cardiology","1902824287","AK3205285","1932157302","1710071717","1104828300","1083656821","1073680393","1306830682","1760504351","1376659813","1457387888","1720190986","1821094665","1174525778","1003837873","1942296140","1083766729","1578670154","1508035163","1871546523","1912997321","1386640522","1356360887","1427254432","1235227133","1669574976","NA","1184652638","1730137688","NA","Na","1982631966","NA","1780603860","1780651497","1679747950","1588690440","1063495893","1710967153","1649360447","1578572327","1902924152","1831172840","1558362152","1265446371","1467482703","1922070291","1497742381","1962460501","1023061850","1881695302","1437166394","1104822261","1225063902","1376569061","1295739274","1316912918","1255313540","1477635084","1982795894","1144288069","1164494563","1295765659","1659310761","1447342951","1639141229","Penn Medicine Valley Forge","1275786352","1609849256","1376675637","1790784395","1619987930","1811959869","1003961764","1366514259","1922088517","1306840210","1093714743","1225057532","1861589269', CAST(N'2015-09-14 15:27:50.097' AS DateTime), N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-09-14 15:27:50.110' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (316, N'{"name":"T-Vec Concept Survey","loi":"8","incidence":"0","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=3959&crowdId=3745&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"16398","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-09-15 08:38:46.287' AS DateTime), N'{"projectid":87,"success":true}', CAST(N'2015-09-15 08:38:46.310' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (317, N'{"projectid":"87","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["1285634196","1659484145","1205896362","1790778793","1881667137","1689650327","1265472849","1255375135","1417927732","1487811931","1003801853","1689686677","1235179839","1811934680","1669687299","1205948288","1356315303","1164403127","1902830888","1902830888","1902830888","1134143506","1104998194","1316942170","1285770925","1053419192","1083630834","1598711251","1053336354","1497719959","1689684524","1033145701","1043316615","1134172364","1770578031","1790878809","1619101268","1972529717","1346238284","1841293933","1366415804","1295819357","1265427496","1730175266","1629064605","1003093600","1427011444","1790725125","1144228966","1992898977","1750376380","1144250739","4631256798","1467720045","1376645838","1134115397","1275546038","1992762108","1992762108","016027204185","495167700147","1144338161","umpa","Health first cardiology","1902824287","AK3205285","1932157302","1710071717","1104828300","1083656821","1073680393","1306830682","1760504351","1376659813","1457387888","1720190986","1821094665","1174525778","1003837873","1942296140","1083766729","1578670154","1508035163","1871546523","1912997321","1386640522","1356360887","1427254432","1235227133","1669574976","NA","1184652638","1730137688","NA","Na","1982631966","NA","1780603860","1780651497","1679747950","1588690440","1063495893","1710967153","1649360447","1578572327","1902924152","1831172840","1558362152","1265446371","1467482703","1922070291","1497742381","1962460501","1023061850","1881695302","1437166394","1104822261","1225063902","1376569061","1295739274","1316912918","1255313540","1477635084","1982795894","1144288069","1164494563","1295765659","1659310761","1447342951","1639141229","Penn Medicine Valley Forge","1275786352","1609849256","1376675637","1790784395","1619987930","1811959869","1003961764","1366514259","1922088517","1306840210","1093714743","1225057532","1861589269', CAST(N'2015-09-15 08:38:46.490' AS DateTime), N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-09-15 08:38:46.550' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (318, N'{"name":"T-Vec Concept Survey","loi":"8","incidence":"0","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=3959&crowdId=3745&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"16398","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-09-15 08:57:12.303' AS DateTime), N'{"projectid":88,"success":true}', CAST(N'2015-09-15 08:57:12.317' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (319, N'{"projectid":"88","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["1285634196","1659484145","1205896362","1790778793","1881667137","1689650327","1265472849","1255375135","1417927732","1003801853","1689686677","1235179839","1811934680","1669687299","1205948288","1356315303","1164403127","1902830888","1902830888","1902830888","1134143506","1104998194","1316942170","1285770925","1053419192","1083630834","1598711251","1053336354","1497719959","1689684524","1033145701","1043316615","1134172364","1770578031","1790878809","1619101268","1972529717","1346238284","1841293933","1366415804","1295819357","1265427496","1730175266","1629064605","1003093600","1427011444","1790725125","1144228966","1992898977","1750376380","1144250739","4631256798","1467720045","1376645838","1134115397","1275546038","1992762108","1992762108","1144338161","1932157302","1710071717","1104828300","1083656821","1073680393","1306830682","1760504351","1376659813","1457387888","1720190986","1821094665","1174525778","1003837873","1942296140","1083766729","1578670154","1508035163","1871546523","1912997321","1386640522","1356360887","1427254432","1235227133","1669574976","1184652638","1730137688","1982631966","1780603860","1780651497","1679747950","1588690440","1063495893","1710967153","1649360447","1578572327","1902924152","1831172840","1558362152","1265446371","1467482703","1922070291","1497742381","1962460501","1023061850","1881695302","1437166394","1104822261","1225063902","1376569061","1295739274","1316912918","1255313540","1477635084","1982795894","1144288069","1164494563","1295765659","1659310761","1447342951","1639141229","1275786352","1609849256","1376675637","1790784395","1619987930","1811959869","1003961764","1366514259","1922088517","1306840210","1093714743","1225057532","1861589269","1992725071","1003914227","1669558508","1427039247","1407823578","1396788022","1396788022","1841277373","1750377545","1780796417","1598737223","1467', CAST(N'2015-09-15 08:57:12.400' AS DateTime), N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-09-15 08:57:12.473' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (320, N'{"name":"T-Vec Concept Survey","loi":"8","incidence":"0","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=3959&crowdId=3745&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"16398","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-09-15 09:26:36.923' AS DateTime), N'{"projectid":89,"success":true}', CAST(N'2015-09-15 09:26:36.990' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (321, N'{"projectid":"89","reqn":"92","specialty":"1","querycondition":[{"datapointid":"6","datapointoptions":["6","3","2","1","4","5"]},{"datapointid":"8","datapointoptions":["62","7","6"]},{"datapointid":"5","datapointoptions":["1"]}],"exclusions":["1285634196","1659484145","1205896362","1790778793","1881667137","1689650327","1265472849","1255375135","1417927732","1003801853","1689686677","1235179839","1811934680","1669687299","1205948288","1356315303","1164403127","1902830888","1902830888","1902830888","1134143506","1104998194","1316942170","1285770925","1053419192","1083630834","1598711251","1053336354","1497719959","1689684524","1033145701","1043316615","1134172364","1770578031","1790878809","1619101268","1972529717","1346238284","1841293933","1366415804","1295819357","1265427496","1730175266","1629064605","1003093600","1427011444","1790725125","1144228966","1992898977","1750376380","1144250739","4631256798","1467720045","1376645838","1134115397","1275546038","1992762108","1992762108","1144338161","1932157302","1710071717","1104828300","1083656821","1073680393","1306830682","1760504351","1376659813","1457387888","1720190986","1821094665","1174525778","1003837873","1942296140","1083766729","1578670154","1508035163","1871546523","1912997321","1386640522","1356360887","1427254432","1235227133","1669574976","1184652638","1730137688","1982631966","1780603860","1780651497","1679747950","1588690440","1063495893","1710967153","1649360447","1578572327","1902924152","1831172840","1558362152","1265446371","1467482703","1922070291","1497742381","1962460501","1023061850","1881695302","1437166394","1104822261","1225063902","1376569061","1295739274","1316912918","1255313540","1477635084","1982795894","1144288069","1164494563","1295765659","1659310761","1447342951","1639141229","1275786352","1609849256","1376675637","1790784395","1619987930","1811959869","1003961764","1366514259","1922088517","1306840210","1093714743","1225057532","1861589269","1992725071","1003914227","1669558508","1', CAST(N'2015-09-15 09:26:37.200' AS DateTime), N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-09-15 09:26:37.300' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (322, N'{"name":"T-Vec Concept Survey","loi":"8","incidence":"0","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=3959&crowdId=3745&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"16398","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-09-15 09:57:48.647' AS DateTime), N'{"projectid":90,"success":true}', CAST(N'2015-09-15 09:57:48.670' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (323, N'{"projectid":"90","reqn":"92","specialty":"1","querycondition":[{"datapointid":"6","datapointoptions":["6","3","2","1","4","5"]},{"datapointid":"8","datapointoptions":["62","7","6"]},{"datapointid":"5","datapointoptions":["1"]}],"exclusions":["1285634196","1659484145","1205896362","1790778793","1881667137","1689650327","1265472849","1255375135","1417927732","1003801853","1689686677","1235179839","1811934680","1669687299","1205948288","1356315303","1164403127","1902830888","1902830888","1902830888","1134143506","1104998194","1316942170","1285770925","1053419192","1083630834","1598711251","1053336354","1497719959","1689684524","1033145701","1043316615","1134172364","1770578031","1790878809","1619101268","1972529717","1346238284","1841293933","1366415804","1295819357","1265427496","1730175266","1629064605","1003093600","1427011444","1790725125","1144228966","1992898977","1750376380","1144250739","4631256798","1467720045","1376645838","1134115397","1275546038","1992762108","1992762108","1144338161","1932157302","1710071717","1104828300","1083656821","1073680393","1306830682","1760504351","1376659813","1457387888","1720190986","1821094665","1174525778","1003837873","1942296140","1083766729","1578670154","1508035163","1871546523","1912997321","1386640522","1356360887","1427254432","1235227133","1669574976","1184652638","1730137688","1982631966","1780603860","1780651497","1679747950","1588690440","1063495893","1710967153","1649360447","1578572327","1902924152","1831172840","1558362152","1265446371","1467482703","1922070291","1497742381","1962460501","1023061850","1881695302","1437166394","1104822261","1225063902","1376569061","1295739274","1316912918","1255313540","1477635084","1982795894","1144288069","1164494563","1295765659","1659310761","1447342951","1639141229","1275786352","1609849256","1376675637","1790784395","1619987930","1811959869","1003961764","1366514259","1922088517","1306840210","1093714743","1225057532","1861589269","1992725071","1003914227","1669558508","1', CAST(N'2015-09-15 09:57:48.790' AS DateTime), N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-09-15 09:57:48.820' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (324, N'{"projectid":"87","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["1285634196","1659484145","1205896362","1790778793","1881667137","1689650327","1265472849","1255375135","1417927732","1487811931","1003801853","1689686677","1235179839","1811934680","1669687299","1205948288","1356315303","1164403127","1902830888","1902830888","1902830888","1134143506","1104998194","1316942170","1285770925","1053419192","1083630834","1598711251","1053336354","1497719959","1689684524","1033145701","1043316615","1134172364","1770578031","1790878809","1619101268","1972529717","1346238284","1841293933","1366415804","1295819357","1265427496","1730175266","1629064605","1003093600","1427011444","1790725125","1144228966","1992898977","1750376380","1144250739","4631256798","1467720045","1376645838","1134115397","1275546038","1992762108","1992762108","016027204185","495167700147","1144338161","umpa","Health first cardiology","1902824287","AK3205285","1932157302","1710071717","1104828300","1083656821","1073680393","1306830682","1760504351","1376659813","1457387888","1720190986","1821094665","1174525778","1003837873","1942296140","1083766729","1578670154","1508035163","1871546523","1912997321","1386640522","1356360887","1427254432","1235227133","1669574976","NA","1184652638","1730137688","NA","Na","1982631966","NA","1780603860","1780651497","1679747950","1588690440","1063495893","1710967153","1649360447","1578572327","1902924152","1831172840","1558362152","1265446371","1467482703","1922070291","1497742381","1962460501","1023061850","1881695302","1437166394","1104822261","1225063902","1376569061","1295739274","1316912918","1255313540","1477635084","1982795894","1144288069","1164494563","1295765659","1659310761","1447342951","1639141229","Penn Medicine Valley Forge","1275786352","1609849256","1376675637","1790784395","1619987930","1811959869","1003961764","1366514259","1922088517","1306840210","1093714743","1225057532","1861589269","1992725071","1003914227","1669558508","1427039247","1407823578","1396788022","1396788022","1841277373","1750377545","1780796417","1598737223","1467673467","1144399718","1205928876","1114975737","1750476115","1114998986","1184604274","1356443451","1821065574","1699731851","1912103052","1861485104","1234","1912941345","1851309629","1346220019","1407041064","1649372319","1871594887","1780763250","1790834281","1861497802","1114913142","1780609057","1780609057","1700913076","N/A","Refusal","1083677710","1558408260","1770502544","1336150234","1174586499","1568532927","1043272776","Refusal","Refusal","Refusal","1891832499","1417142597","1922325687","1104900216","1619130291","1861454423","1619928892","1851349757","Refusal","1447222831","1376679084","1700835196","1891720579","1841254885","1588685176","1205884178","1851359533","Refusal","1043246572","1942505490","1730160524","1073556288","1568591006","1780642272","1992785018","1982605721","1568456366","1366541302","1356544993","1407055296","REFUSAL","1538324645","1174752554","1255308813","Refusal","1164476602","Private Practice","1922274364","1356377196","asdf","1902888365","1538186382","Refusal","1770668758","1568745016","1902823529","1447436126","1083892111","1053471110","1790726396","1811969041","1023065745","1760421564","1134297385","1669416160","30696 AZ.","Refusal","1639171606","1336343912","Refusal","1790834281","1346222353","1881680098","N/P","1003975673","1801861513","1053562470","1699772582","1417919499","1528089745","1356385330","1932143997","1497703367","1366493033","1003803412","None","1144279084","1013900851","1528012234","1538384250","1093880361","1275585846","1336296789","1205864550","1285781948","1134443112","1568558906","1215915012","1679520688","1447294699","1528070505","1558470112","1447333554","1366468894","1154494425","1962440701","1760696314","1356300222","1285913632","1023332079","1841516952","1215183934","5907859078","1225091812","1811055874","1508853052","1437120078","1457466518","1073558615","1881661601","1255303947","1811064785","1336206374","1215927900","1962546366","1851321442"]}', CAST(N'2015-09-16 03:39:28.053' AS DateTime), N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-09-16 03:39:28.213' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (325, N'{"projectid":"87","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["1285634196","1659484145","1205896362","1790778793","1881667137","1689650327","1265472849","1255375135","1417927732","1487811931","1003801853","1689686677","1235179839","1811934680","1669687299","1205948288","1356315303","1164403127","1902830888","1902830888","1902830888","1134143506","1104998194","1316942170","1285770925","1053419192","1083630834","1598711251","1053336354","1497719959","1689684524","1033145701","1043316615","1134172364","1770578031","1790878809","1619101268","1972529717","1346238284","1841293933","1366415804","1295819357","1265427496","1730175266","1629064605","1003093600","1427011444","1790725125","1144228966","1992898977","1750376380","1144250739","4631256798","1467720045","1376645838","1134115397","1275546038","1992762108","1992762108","016027204185","495167700147","1144338161","umpa","Health first cardiology","1902824287","AK3205285","1932157302","1710071717","1104828300","1083656821","1073680393","1306830682","1760504351","1376659813","1457387888","1720190986","1821094665","1174525778","1003837873","1942296140","1083766729","1578670154","1508035163","1871546523","1912997321","1386640522","1356360887","1427254432","1235227133","1669574976","NA","1184652638","1730137688","NA","Na","1982631966","NA","1780603860","1780651497","1679747950","1588690440","1063495893","1710967153","1649360447","1578572327","1902924152","1831172840","1558362152","1265446371","1467482703","1922070291","1497742381","1962460501","1023061850","1881695302","1437166394","1104822261","1225063902","1376569061","1295739274","1316912918","1255313540","1477635084","1982795894","1144288069","1164494563","1295765659","1659310761","1447342951","1639141229","Penn Medicine Valley Forge","1275786352","1609849256","1376675637","1790784395","1619987930","1811959869","1003961764","1366514259","1922088517","1306840210","1093714743","1225057532","1861589269","1992725071","1003914227","1669558508","1427039247","1407823578","1396788022","1396788022","1841277373","1750377545","1780796417","1598737223","1467673467","1144399718","1205928876","1114975737","1750476115","1114998986","1184604274","1356443451","1821065574","1699731851","1912103052","1861485104","1234","1912941345","1851309629","1346220019","1407041064","1649372319","1871594887","1780763250","1790834281","1861497802","1114913142","1780609057","1780609057","1700913076","N/A","Refusal","1083677710","1558408260","1770502544","1336150234","1174586499","1568532927","1043272776","Refusal","Refusal","Refusal","1891832499","1417142597","1922325687","1104900216","1619130291","1861454423","1619928892","1851349757","Refusal","1447222831","1376679084","1700835196","1891720579","1841254885","1588685176","1205884178","1851359533","Refusal","1043246572","1942505490","1730160524","1073556288","1568591006","1780642272","1992785018","1982605721","1568456366","1366541302","1356544993","1407055296","REFUSAL","1538324645","1174752554","1255308813","Refusal","1164476602","Private Practice","1922274364","1356377196","asdf","1902888365","1538186382","Refusal","1770668758","1568745016","1902823529","1447436126","1083892111","1053471110","1790726396","1811969041","1023065745","1760421564","1134297385","1669416160","30696 AZ.","Refusal","1639171606","1336343912","Refusal","1790834281","1346222353","1881680098","N/P","1003975673","1801861513","1053562470","1699772582","1417919499","1528089745","1356385330","1932143997","1497703367","1366493033","1003803412","None","1144279084","1013900851","1528012234","1538384250","1093880361","1275585846","1336296789","1205864550","1285781948","1134443112","1568558906","1215915012","1679520688","1447294699","1528070505","1558470112","1447333554","1366468894","1154494425","1962440701","1760696314","1356300222","1285913632","1023332079","1841516952","1215183934","5907859078","1225091812","1811055874","1508853052","1437120078","1457466518","1073558615","1881661601","1255303947","1811064785","1336206374","1215927900","1962546366","1851321442"]}', CAST(N'2015-09-16 03:39:54.610' AS DateTime), N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-09-16 03:39:54.680' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (326, N'{"projectid":"87","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["1285634196","1659484145","1205896362","1790778793","1881667137","1689650327","1265472849","1255375135","1417927732","1487811931","1003801853","1689686677","1235179839","1811934680","1669687299","1205948288","1356315303","1164403127","1902830888","1902830888","1902830888","1134143506","1104998194","1316942170","1285770925","1053419192","1083630834","1598711251","1053336354","1497719959","1689684524","1033145701","1043316615","1134172364","1770578031","1790878809","1619101268","1972529717","1346238284","1841293933","1366415804","1295819357","1265427496","1730175266","1629064605","1003093600","1427011444","1790725125","1144228966","1992898977","1750376380","1144250739","4631256798","1467720045","1376645838","1134115397","1275546038","1992762108","1992762108","016027204185","495167700147","1144338161","umpa","Health first cardiology","1902824287","AK3205285","1932157302","1710071717","1104828300","1083656821","1073680393","1306830682","1760504351","1376659813","1457387888","1720190986","1821094665","1174525778","1003837873","1942296140","1083766729","1578670154","1508035163","1871546523","1912997321","1386640522","1356360887","1427254432","1235227133","1669574976","NA","1184652638","1730137688","NA","Na","1982631966","NA","1780603860","1780651497","1679747950","1588690440","1063495893","1710967153","1649360447","1578572327","1902924152","1831172840","1558362152","1265446371","1467482703","1922070291","1497742381","1962460501","1023061850","1881695302","1437166394","1104822261","1225063902","1376569061","1295739274","1316912918","1255313540","1477635084","1982795894","1144288069","1164494563","1295765659","1659310761","1447342951","1639141229","Penn Medicine Valley Forge","1275786352","1609849256","1376675637","1790784395","1619987930","1811959869","1003961764","1366514259","1922088517","1306840210","1093714743","1225057532","1861589269","1992725071","1003914227","1669558508","1427039247","1407823578","1396788022","1396788022","1841277373","1750377545","1780796417","1598737223","1467673467","1144399718","1205928876","1114975737","1750476115","1114998986","1184604274","1356443451","1821065574","1699731851","1912103052","1861485104","1234","1912941345","1851309629","1346220019","1407041064","1649372319","1871594887","1780763250","1790834281","1861497802","1114913142","1780609057","1780609057","1700913076","N/A","Refusal","1083677710","1558408260","1770502544","1336150234","1174586499","1568532927","1043272776","Refusal","Refusal","Refusal","1891832499","1417142597","1922325687","1104900216","1619130291","1861454423","1619928892","1851349757","Refusal","1447222831","1376679084","1700835196","1891720579","1841254885","1588685176","1205884178","1851359533","Refusal","1043246572","1942505490","1730160524","1073556288","1568591006","1780642272","1992785018","1982605721","1568456366","1366541302","1356544993","1407055296","REFUSAL","1538324645","1174752554","1255308813","Refusal","1164476602","Private Practice","1922274364","1356377196","asdf","1902888365","1538186382","Refusal","1770668758","1568745016","1902823529","1447436126","1083892111","1053471110","1790726396","1811969041","1023065745","1760421564","1134297385","1669416160","30696 AZ.","Refusal","1639171606","1336343912","Refusal","1790834281","1346222353","1881680098","N/P","1003975673","1801861513","1053562470","1699772582","1417919499","1528089745","1356385330","1932143997","1497703367","1366493033","1003803412","None","1144279084","1013900851","1528012234","1538384250","1093880361","1275585846","1336296789","1205864550","1285781948","1134443112","1568558906","1215915012","1679520688","1447294699","1528070505","1558470112","1447333554","1366468894","1154494425","1962440701","1760696314","1356300222","1285913632","1023332079","1841516952","1215183934","5907859078","1225091812","1811055874","1508853052","1437120078","1457466518","1073558615","1881661601","1255303947","1811064785","1336206374","1215927900","1962546366","1851321442"]}', CAST(N'2015-09-16 03:39:57.780' AS DateTime), N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-09-16 03:39:57.850' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (327, N'{"projectid":"87","reqn":"92","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":["1285634196","1659484145"]}', CAST(N'2015-09-16 03:40:42.217' AS DateTime), N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-09-16 03:40:42.250' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (328, N'{"success":false,"error":"Incidence should be greater than zero."}', CAST(N'2015-09-16 06:30:08.347' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (329, N'{"success":false,"error":"Incidence should be greater than zero."}', CAST(N'2015-09-16 09:12:15.650' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (330, N'{"name":"Payer Issues Questions Survey","loi":"9","incidence":"10","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=3871&crowdId=3686&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"16110","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-09-16 09:13:48.553' AS DateTime), N'{"projectid":91,"success":true}', CAST(N'2015-09-16 09:13:48.573' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (331, N'{"projectid":"91","reqn":"31","specialty":"13","querycondition":[],"exclusions":[]}', CAST(N'2015-09-16 09:13:48.687' AS DateTime), N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-09-16 09:13:48.767' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (332, N'{"name":"Payer Issues Questions Survey","loi":"9","incidence":"10","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=3871&crowdId=3710&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"16111","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-09-16 09:16:59.460' AS DateTime), N'{"projectid":92,"success":true}', CAST(N'2015-09-16 09:16:59.470' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (333, N'{"projectid":"92","reqn":"31","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["56","31","30","29"]},{"datapointid":"5","datapointoptions":["1"]}],"exclusions":[]}', CAST(N'2015-09-16 09:16:59.547' AS DateTime), N'{"success":true,"queryid":82,"projectid":92,"feasibility":0}', CAST(N'2015-09-16 09:16:59.597' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (334, N'{"projectid":"92","statusid":"1"}', CAST(N'2015-09-16 09:16:59.653' AS DateTime), N'{"projectid":92,"success":true}', CAST(N'2015-09-16 09:16:59.667' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (335, N'{"name":"Payer Issues Questions Survey","loi":"9","incidence":"10","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=3871&crowdId=3710&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"16111","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-09-16 10:10:10.937' AS DateTime), N'{"projectid":93,"success":true}', CAST(N'2015-09-16 10:10:10.960' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (336, N'{"projectid":"93","reqn":"31","specialty":"1","querycondition":[{"datapointid":"15","datapointoptions":["K_f2deb0970d","K_7ef4fd49ce","K_a10da422b6","K_4ce5622068","K_83d63d6182","K_48e8993269","K_7b82b67b34","K_ac0d9c8d23","K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-09-16 10:10:59.823' AS DateTime), N'{"success":true,"queryid":83,"projectid":93,"feasibility":0}', CAST(N'2015-09-16 10:10:59.883' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (337, N'{"projectid":"93","reqn":"31","specialty":"1","querycondition":[{"datapointid":"15","datapointoptions":["K_f2deb0970d"]}],"exclusions":[]}', CAST(N'2015-09-16 10:11:35.153' AS DateTime), N'{"success":true,"queryid":84,"projectid":93,"feasibility":0}', CAST(N'2015-09-16 10:11:35.200' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (338, N'{"projectid":"93","reqn":"31","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_f2deb0970d"]}],"exclusions":[]}', CAST(N'2015-09-16 10:12:32.587' AS DateTime), N'{"success":true,"queryid":85,"projectid":93,"feasibility":0}', CAST(N'2015-09-16 10:12:32.607' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (339, N'{"projectid":"93","reqn":"31","specialty":"1","querycondition":[{"datapointid":"15","datapointoptions":["K_f2deb0970d"]}],"exclusions":[]}', CAST(N'2015-09-16 10:13:40.170' AS DateTime), N'{"success":true,"queryid":86,"projectid":93,"feasibility":0}', CAST(N'2015-09-16 10:13:40.197' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (340, N'{"success":false,"error":"Project Id cannot be null or zero"}', CAST(N'2015-09-18 04:14:19.580' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (341, N'{"success":false,"error":"Speciality cannot be null or zero."}', CAST(N'2015-09-18 04:14:37.970' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (342, N'{"success":false,"error":"Query condition cannot be empty."}', CAST(N'2015-09-18 04:14:48.583' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (343, N'{"name":"Test Project QA","loi":"5","incidence":"10","surveylink":"http://lmgtfy.com/?q=fuzzy+bunnies","emailsubject":"A Vital Study For Your Review","referencecode":null,"surveytopic":"Fabulous Rewards Available! Click Now!"}', CAST(N'2015-09-18 11:15:35.487' AS DateTime), N'{"projectid":94,"success":true}', CAST(N'2015-09-18 11:15:35.510' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (344, N'{"success":false,"error":"Authentication Failed."}', CAST(N'2015-09-18 11:19:06.567' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (345, N'{"projectid":"94","reqn":"4","specialty":"24","querycondition":[{"datapointid":"8","datapointoptions":["24"]}],"exclusions":[]}', CAST(N'2015-09-18 11:19:24.830' AS DateTime), N'{"success":true,"queryid":87,"projectid":94,"feasibility":0}', CAST(N'2015-09-18 11:19:24.883' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (346, N'{"name":"QA Test 2","loi":"5","incidence":"100","surveylink":"http://lmgtfy.com/?q=fuzzy+bunnies","emailsubject":"Survey","referencecode":"60011","surveytopic":"Click here"}', CAST(N'2015-09-18 11:32:45.933' AS DateTime), N'{"projectid":95,"success":true}', CAST(N'2015-09-18 11:32:45.943' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (347, N'{"projectid":"95","reqn":"50","specialty":"24","querycondition":[{"datapointid":"8","datapointoptions":["24"]}],"exclusions":[]}', CAST(N'2015-09-18 11:34:32.450' AS DateTime), N'{"success":true,"queryid":88,"projectid":95,"feasibility":3}', CAST(N'2015-09-18 11:34:32.510' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (348, N'{"name":"20150918 TV Ad Recall - Wave 2","loi":"5","incidence":"10","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=4008&crowdId=3779&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"16703","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-09-18 12:31:29.307' AS DateTime), N'{"projectid":96,"success":true}', CAST(N'2015-09-18 12:31:29.333' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (349, N'{"projectid":"96","reqn":"50","specialty":"1","querycondition":[{"datapointid":"8","datapointoptions":["64","51","48","36","24"]},{"datapointid":"5","datapointoptions":["1"]}],"exclusions":["1437130622","1114903994","1124003330","1487623955","1639142177","1396888277","1851362974","1063478469","1740480565","1285634196","1306802277","1497752653","1023006111","1083827018","1285608299","1649295270","1841272309","1911293275","1164462206","0101058086","1336323989","1598722597","1598701559","1922004027","1568611465","1720074412","1316042104","1346251071","1326062597","1528254133","1942289674","1215966098","1821021007","1659363356","1447340245","1700999745","1770531816","1972643344","1518981885","1689852428","1861472342","1104810936","1245449438","1063640639","1689650327","1508890005","1649341678","1386642478","1598738171","1487616454","1902856313","1598982712","1518206622","1467679738","1467462531","1811934680","1992739726","1629257035","1144290750","1366471344","1508959644","1497884910","1538260740","1518900976","1669412342","1003055302","1356315303","1902830888","1902830888","1902830888","1457559585","1316084676","1245217413","1932109246","1942302781","1487684353","1982854725","1255316782","1942308580","1962408583","1538185491","1275741647","1124039755","1477551752","1205068053","1407911969","1750489340","1104930916","1316049844","1316942170","1760407597","1184710246","1053393561","1407967235","1770576365","1275547622","1801807607","1285698514","1841279833","1629039177","1316044415","1245266949","1780615641","1992740294","1184618993","1427079250","1508910209","1083672711","1083652986","1710940416","1306909072","1053419192","1831197334","1659487684","1578513420","1346227956","1417096363","1861582942","1508020819","1750434940","1295897569","1952455701","1598830416","1225130701","1265564761","1467415695","1114036878","1598711251","1881652519","1609862663","1942238928","1043200181","1043292618","1619973443","1306836150","1138904126","1790793537","1326081530","1598798183","1922101104","1417975681","1619908597","1154452142","1841303740","1548273295","1770550766","1972751915","1033145701","1750497483","1407898646","8173465960","1013023258","1306800859","1407819683","1861439093","1841339090","1801994207","1659303980","0000000000","1710956305","1568429272","1255385514","1235223009","1477615425","1598766537","1760406649","1831115633","1043316615","1619080314","1215974902","1376538900","1619993474","1790787729","1942277660","1245259274","1659354868","1598710238","1801887856","1891724241","1134172364","1033156500","1922014257","1184623993","1265448237","1750300539","1578763462","1487648929","1629211982","1548262017","1023049541","1689666984","1215042528","1548263353","1114988417","1790775369","1790775369","1972529717","1700029485","1215918990","1447270475","1902891732","1144249871","1427098631","1710144670","1487623427","1609885581","1164422432","1851378616","1619960655","1063496644","1558412288","1942348255","1164428777","1295815538","1922066489","1235124298","1346316197","1841293933","1295819357","1730175266","1962539577","1144271917","1336165877","1629064605","1003093600","1073527479","1629047709","1730123308","1790725125","1578975330","1629000609","1710935564","1235142431","1750376380","1144250739","1851417729","4631256798","1164415519","1548274350","1083656201","1366680829","1992762108","1992762108","1790773505","1053307561","1508869835","1114992625","1316057326","1114911930","1508807827","1740212398","1881640084","1649241902","1770599326","1629090881","1609812841","1982628384","1679897185","1285791228","1376645366","1477577682","1992902605","1962533380","1073512844","1164408472","1689689028","1144524729","1922083633","1225050404","1134182983","1801081971","1134326275","1275579724","1871520726","1082376825","1184670671","1154361673","1932318532","1144254095","1821033481","1205801404","1144317850","1407854458","1134185135","1205934767","1821241779","1629113402","1568404440","1295706158","1043284540","1699770164","1134103765","1942376074","1376535757","1639197239","1538175799","1922009901","1598758575","1962410100","1922267426","1043532286","1811925910","1043393895","1538160395","1831202753","1295993715","1467686717","1932157302","1477649168","1083676209","1235171364","1487644803","1689665556","1851365985","1841266343","1508858564","1508955956","1144294182","1750366779","1871739276","1043379605","1770698490","1932196102","1053394106","1396798708","1154428613","1861685018","1326362989","1548421514","1245332519","1952403016","1740256783","1649531427","1780656488","1508847021","1770698375","1073523759","1083603716","1093977639","1164409561","1720044241","1922088426","1356336846","1821182791","1063475549","1417959123","1730160144","1922325687","1376679084","1992810857","1588685176","1568414985","1508097742","1962509265","1427042837","1083641856","1861420077","1891718768","1295758514","1326032012","1093759581","1144257395","1023033040","1215986245","1891730479","1841365889","1023087491","1780663898","1457456808","1720086499","1871922575","1538164066","1366631749","1942341417","1710974209","1730145343","1720072960","1265465835","1942238654","1740230739","1689693483","1376640227","1952375073","1124093331","1972688564","1023187622","1609829365","1528005634","1194712877","1831245307","1437217601","1598789588","1164402764","1831208412","1588628549","1447271259","1811928799","1447367479","1801882386","1760560494","1962402586","1992055115","1639202120","1083748685","1861571622","1184631772","1104006089","1922331628","1194754788","1720083173","1639114721","1770581803","1093880361","1588695712","1336104694","1134246770","1174624035","1568660652","1184601577","1134443112","1144225848","1023035094","1538491212","1619980620","1275851222","1497888192","1437233012","1386867448","1881717197","1952321820","1720015084","1295762722","1386706059","1821062944","1558470112","1376593806","1609977552","1902986151","1447307897","1851302863","1669604450","1215996988","1093810228","1538158084","1154494425","1700941788","1316912967","1760466692","1942592563","1568482818","1750466165","1508841883","1104819622","1851529374","1497016190","1174507974","1306017991","1073537072","1184670820","1811967771","1184856965","1750551453","1083673685","1013978402","1093931081","1225276488","1548428618","1962452425","5907859078","1174588651","1962693150","1164427977","1568576510","1780635599","1417121138","1124027750","1023019270","1306024161","1992071336","1669667242","1396737581","1770826331","1730422536","1699086496","1518269232","1225109150","1760469654","1730165259","1255498507","1275875130","1982624946","1902097892","1639304355"]}', CAST(N'2015-09-18 12:31:29.590' AS DateTime), N'{"success":true,"queryid":89,"projectid":96,"feasibility":0}', CAST(N'2015-09-18 12:31:29.780' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (350, N'{"projectid":"96","statusid":"1"}', CAST(N'2015-09-18 12:31:29.900' AS DateTime), N'{"projectid":96,"success":true}', CAST(N'2015-09-18 12:31:29.910' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (351, N'{"projectid":"13","reqn":"80","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-09-28 14:00:53.043' AS DateTime), N'{"success":true,"queryid":90,"projectid":13,"feasibility":0}', CAST(N'2015-09-28 14:00:53.157' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (352, N'{"name":"Sample #3","loi":"3","incidence":"10","surveylink":"https://web-qa.incrowdanswers.com/answer/?thirdParty=true&surveyId=3928&crowdId=2424&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"16052","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-09-28 14:06:18.597' AS DateTime), N'{"projectid":97,"success":true}', CAST(N'2015-09-28 14:06:18.647' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (353, N'{"success":false,"error":"Authentication Failed."}', CAST(N'2015-09-28 14:06:43.757' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (354, N'{"projectid":"97","reqn":"80","specialty":"3","querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-09-28 14:06:57.717' AS DateTime), N'{"success":true,"queryid":91,"projectid":97,"feasibility":0}', CAST(N'2015-09-28 14:06:57.747' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (355, N'{"projectid":"97","statusid":"1"}', CAST(N'2015-09-28 14:07:14.970' AS DateTime), N'{"projectid":97,"success":true}', CAST(N'2015-09-28 14:07:14.993' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (356, N'21', CAST(N'2015-10-05 14:30:00.253' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-10-05 14:30:00.450' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (357, N'43', CAST(N'2015-10-05 14:30:05.630' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-10-05 14:30:05.643' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (358, N'{"success":false,"error":"Speciality cannot be null or zero."}', CAST(N'2015-10-16 06:28:49.680' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (359, N'{"success":false,"error":"Specialty cannot be null or zero."}', CAST(N'2015-10-16 06:29:49.187' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (360, N'{"projectid":"45","reqn":"92","specialty":null,"querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]},{"datapointid":"8","datapointoptions":["1"]}],"exclusions":[]}', CAST(N'2015-10-16 06:30:13.683' AS DateTime), N'{"success":true,"queryid":92,"projectid":45,"feasibility":0}', CAST(N'2015-10-16 06:30:13.750' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (361, N'{"success":false,"error":"Only one value allowed in specialty."}', CAST(N'2015-10-16 06:30:27.583' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (362, N'{"name":"90-Day Prescription Survey","loi":"6","incidence":"10","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=4072&crowdId=2794&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"4072:2794:API","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-10-16 11:46:29.270' AS DateTime), N'{"projectid":98,"success":true}', CAST(N'2015-10-16 11:46:29.290' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (363, N'{"projectid":"98","reqn":"9","specialty":null,"querycondition":[{"datapointid":"8","datapointoptions":["3"]},{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-10-16 11:46:29.433' AS DateTime), N'{"success":true,"queryid":93,"projectid":98,"feasibility":0}', CAST(N'2015-10-16 11:46:29.483' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (364, N'{"projectid":"98","statusid":"1"}', CAST(N'2015-10-16 11:46:29.553' AS DateTime), N'{"projectid":98,"success":true}', CAST(N'2015-10-16 11:46:29.567' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (365, N'{"name":"20150928 Psoriasis in Sensitive Skin Areas - Germany","loi":"8","incidence":"10","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=4060&crowdId=3817&providerId=16&lang=de&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"4060:3817:API","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-10-16 11:49:47.540' AS DateTime), N'{"projectid":99,"success":true}', CAST(N'2015-10-16 11:49:47.550' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (366, N'{"projectid":"99","reqn":"9","specialty":null,"querycondition":[{"datapointid":"8","datapointoptions":["10"]},{"datapointid":"5","datapointoptions":["5"]}],"exclusions":[]}', CAST(N'2015-10-16 11:49:47.660' AS DateTime), N'{"success":true,"queryid":94,"projectid":99,"feasibility":0}', CAST(N'2015-10-16 11:49:47.700' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (367, N'{"projectid":"99","statusid":"1"}', CAST(N'2015-10-16 11:49:47.763' AS DateTime), N'{"projectid":99,"success":true}', CAST(N'2015-10-16 11:49:47.770' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (368, N'94', CAST(N'2015-10-16 14:55:51.427' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-10-16 14:55:51.543' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (369, N'26', CAST(N'2015-10-21 11:59:46.673' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-10-21 11:59:47.143' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (370, N'26', CAST(N'2015-10-21 12:59:45.473' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-10-21 12:59:45.567' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (371, N'26', CAST(N'2015-10-21 13:59:44.497' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-10-21 13:59:44.590' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (372, N'{"projectid":"45","reqn":"92","specialty":null,"querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]},{"datapointid":"8","datapointoptions":["1"]}],"exclusions":[]}', CAST(N'2015-10-27 06:31:32.177' AS DateTime), N'{"success":true,"queryid":95,"projectid":45,"feasibility":0}', CAST(N'2015-10-27 06:31:32.267' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (373, N'{"projectid":"45","reqn":"92","specialty":null,"querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]},{"datapointid":"8","datapointoptions":["1"]}],"exclusions":[]}', CAST(N'2015-11-03 02:19:40.943' AS DateTime), N'{"success":true,"queryid":96,"projectid":45,"feasibility":0}', CAST(N'2015-11-03 02:19:41.000' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (374, N'{"name":"PCP Influenza Treatment Survey","loi":"8","incidence":"10","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=4163&crowdId=826&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"4163:826:API","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-11-03 09:31:06.690' AS DateTime), N'{"projectid":100,"success":true}', CAST(N'2015-11-03 09:31:06.713' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (375, N'{"projectid":"100","reqn":"2","specialty":null,"querycondition":[{"datapointid":"8","datapointoptions":["3"]},{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-11-03 09:31:12.127' AS DateTime), N'{"success":true,"queryid":97,"projectid":100,"feasibility":0}', CAST(N'2015-11-03 09:31:12.173' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (376, N'{"projectid":"100","statusid":"1"}', CAST(N'2015-11-03 09:31:13.583' AS DateTime), N'{"projectid":100,"success":true}', CAST(N'2015-11-03 09:31:13.603' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (377, N'{"name":"PCP Influenza Treatment Survey","loi":"8","incidence":"10","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=4163&crowdId=826&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"4163:826:API","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-11-03 09:32:00.050' AS DateTime), N'{"projectid":101,"success":true}', CAST(N'2015-11-03 09:32:00.063' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (378, N'{"projectid":"101","reqn":"2","specialty":null,"querycondition":[{"datapointid":"8","datapointoptions":["3"]},{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-11-03 09:32:00.130' AS DateTime), N'{"success":true,"queryid":98,"projectid":101,"feasibility":0}', CAST(N'2015-11-03 09:32:00.163' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (379, N'{"projectid":"101","statusid":"1"}', CAST(N'2015-11-03 09:32:00.220' AS DateTime), N'{"projectid":101,"success":true}', CAST(N'2015-11-03 09:32:00.227' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (380, N'{"name":"20151023 MDI v DPI Preferences - PUD","loi":"5","incidence":"10","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=4180&crowdId=569&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"4180:569:API","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-11-03 09:36:28.300' AS DateTime), N'{"projectid":102,"success":true}', CAST(N'2015-11-03 09:36:28.313' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (381, N'{"projectid":"102","reqn":"-2","specialty":null,"querycondition":[{"datapointid":"8","datapointoptions":["3"]},{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-11-03 09:36:28.413' AS DateTime), N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-11-03 09:36:28.450' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (382, N'{"name":"20151023 MDI v DPI Preferences - PUD","loi":"5","incidence":"10","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=4180&crowdId=569&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"4180:569:API","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-11-03 09:37:30.767' AS DateTime), N'{"projectid":103,"success":true}', CAST(N'2015-11-03 09:37:30.803' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (383, N'{"projectid":"103","reqn":"-2","specialty":null,"querycondition":[{"datapointid":"8","datapointoptions":["3"]},{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-11-03 09:37:30.917' AS DateTime), N'{"success":false,"error":"Erron on Save Query."}', CAST(N'2015-11-03 09:37:30.950' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (384, N'{"projectid":"45","reqn":"92","specialty":null,"querycondition":[{"datapointid":"15","datapointoptions":["K_rreoggymvc"]},{"datapointid":"8","datapointoptions":["1"]}],"exclusions":[]}', CAST(N'2015-11-11 04:32:37.480' AS DateTime), N'{"success":true,"queryid":101,"projectid":45,"feasibility":0}', CAST(N'2015-11-11 04:32:37.577' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (385, N'75', CAST(N'2015-11-16 09:53:11.080' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-11-16 09:53:11.183' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (386, N'75', CAST(N'2015-11-16 10:10:08.690' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-11-16 10:10:08.717' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (387, N'75', CAST(N'2015-11-16 11:06:49.807' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-11-16 11:06:49.927' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (388, N'78', CAST(N'2015-11-20 09:59:32.083' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-11-20 09:59:32.190' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (389, N'78', CAST(N'2015-11-20 10:59:33.753' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-11-20 10:59:33.843' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (390, N'78', CAST(N'2015-11-20 11:59:33.343' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-11-20 11:59:33.350' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (391, N'78', CAST(N'2015-11-20 12:59:33.080' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-11-20 12:59:33.090' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (392, N'78', CAST(N'2015-11-20 13:59:33.103' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-11-20 13:59:33.110' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (393, N'78', CAST(N'2015-11-20 14:59:32.677' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-11-20 14:59:32.683' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (394, N'78', CAST(N'2015-11-20 15:59:32.520' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-11-20 15:59:32.527' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (395, N'84', CAST(N'2015-11-30 14:59:53.593' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-11-30 14:59:53.693' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (396, N'78', CAST(N'2015-12-01 08:59:28.440' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-12-01 08:59:28.553' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (397, N'78', CAST(N'2015-12-01 09:59:27.937' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-12-01 09:59:28.050' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (398, N'78', CAST(N'2015-12-01 10:59:27.767' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-12-01 10:59:27.880' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (399, N'88', CAST(N'2015-12-05 08:59:32.760' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-12-05 08:59:32.877' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (400, N'88', CAST(N'2015-12-05 09:59:32.520' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-12-05 09:59:32.637' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (401, N'88', CAST(N'2015-12-05 10:59:31.060' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-12-05 10:59:31.170' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (402, N'88', CAST(N'2015-12-05 11:59:30.113' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-12-05 11:59:30.240' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (403, N'88', CAST(N'2015-12-05 12:59:29.850' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-12-05 12:59:29.967' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (404, N'88', CAST(N'2015-12-05 13:59:29.700' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-12-05 13:59:29.813' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (405, N'88', CAST(N'2015-12-05 14:59:32.730' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-12-05 14:59:32.840' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (406, N'88', CAST(N'2015-12-05 15:59:29.210' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-12-05 15:59:29.310' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (407, N'88', CAST(N'2015-12-06 09:00:01.610' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-12-06 09:00:01.903' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (408, N'88', CAST(N'2015-12-06 10:00:01.470' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-12-06 10:00:01.587' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (409, N'88', CAST(N'2015-12-06 11:00:02.017' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-12-06 11:00:02.133' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (410, N'88', CAST(N'2015-12-06 11:59:59.040' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-12-06 11:59:59.157' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (411, N'88', CAST(N'2015-12-06 12:59:59.557' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-12-06 12:59:59.670' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (412, N'88', CAST(N'2015-12-06 14:00:02.013' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-12-06 14:00:02.130' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (413, N'88', CAST(N'2015-12-06 14:59:58.420' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-12-06 14:59:58.533' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (414, N'88', CAST(N'2015-12-06 15:59:59.687' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-12-06 15:59:59.803' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (415, N'85', CAST(N'2015-12-10 15:59:37.573' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-12-10 15:59:37.687' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (416, N'84', CAST(N'2015-12-15 14:59:13.720' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-12-15 14:59:13.843' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (417, N'84', CAST(N'2015-12-15 16:06:18.717' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-12-15 16:06:18.840' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (418, N'84', CAST(N'2015-12-16 08:59:09.083' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-12-16 08:59:09.200' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (419, N'84', CAST(N'2015-12-18 09:05:40.413' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-12-18 09:05:40.530' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (420, N'{"name":"Neurotoxins  All kinds of creepsstuff","loi":"4","incidence":"36","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=4400&crowdId=4133&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"4400:4133:API","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-12-18 10:38:56.773' AS DateTime), N'{"projectid":104,"success":true}', CAST(N'2015-12-18 10:38:56.813' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (421, N'{"success":false,"error":"Query condition cannot be empty."}', CAST(N'2015-12-18 10:38:56.937' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (422, N'84', CAST(N'2015-12-18 10:59:59.387' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-12-18 10:59:59.427' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (423, N'{"name":"Neurotoxins+%26+All+kind%27s+of+creeps%2Fstuff","loi":"4","incidence":"36","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=4400&crowdId=4134&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"4400:4134:API","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-12-18 11:42:32.840' AS DateTime), N'{"projectid":105,"success":true}', CAST(N'2015-12-18 11:42:32.857' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (424, N'{"projectid":"105","reqn":"9","specialty":null,"querycondition":[{"datapointid":"8","datapointoptions":["3"]},{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-12-18 11:42:32.980' AS DateTime), N'{"success":true,"queryid":102,"projectid":105,"feasibility":0}', CAST(N'2015-12-18 11:42:33.080' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (425, N'{"projectid":"105","statusid":"1"}', CAST(N'2015-12-18 11:42:33.137' AS DateTime), N'{"projectid":105,"success":true}', CAST(N'2015-12-18 11:42:33.163' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (426, N'84', CAST(N'2015-12-18 11:59:58.987' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-12-18 11:59:59.023' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (427, N'{"name":"Things & This / That, The Other","loi":"1","incidence":"100","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=4329&crowdId=4039&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"4329:4039:API","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-12-18 12:59:11.493' AS DateTime), N'{"projectid":106,"success":true}', CAST(N'2015-12-18 12:59:11.507' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (428, N'{"projectid":"106","reqn":"9","specialty":null,"querycondition":[{"datapointid":"8","datapointoptions":["3"]},{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-12-18 12:59:11.637' AS DateTime), N'{"success":true,"queryid":103,"projectid":106,"feasibility":0}', CAST(N'2015-12-18 12:59:11.687' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (429, N'{"projectid":"106","statusid":"1"}', CAST(N'2015-12-18 12:59:11.723' AS DateTime), N'{"projectid":106,"success":true}', CAST(N'2015-12-18 12:59:11.730' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (430, N'84', CAST(N'2015-12-21 09:59:49.147' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-12-21 09:59:49.260' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (431, N'103', CAST(N'2015-12-21 09:59:49.273' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-12-21 09:59:49.280' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (432, N'103', CAST(N'2015-12-21 10:59:48.290' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-12-21 10:59:48.403' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (433, N'84', CAST(N'2015-12-21 10:59:48.413' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2015-12-21 10:59:48.420' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (434, N'{"name":"20151214+HCV+Product+Launch+-+Brazil","loi":"10","incidence":"30","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=4389&crowdId=4142&providerId=16&lang=pt&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"4389:4142:API","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-12-21 11:33:52.357' AS DateTime), N'{"projectid":107,"success":true}', CAST(N'2015-12-21 11:33:52.390' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (435, N'{"projectid":"107","reqn":"50","specialty":null,"querycondition":[{"datapointid":"8","datapointoptions":["3"]},{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-12-21 11:33:52.510' AS DateTime), N'{"success":true,"queryid":104,"projectid":107,"feasibility":0}', CAST(N'2015-12-21 11:33:52.603' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (436, N'{"projectid":"107","statusid":"1"}', CAST(N'2015-12-21 11:33:52.640' AS DateTime), N'{"projectid":107,"success":true}', CAST(N'2015-12-21 11:33:52.667' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (437, N'{"name":"Neurotoxins+%26+All+kind%27s+of+creeps%2Fstuff","loi":"4","incidence":"36","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=4400&crowdId=4135&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"4400:4135:API","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-12-21 11:41:39.500' AS DateTime), N'{"projectid":108,"success":true}', CAST(N'2015-12-21 11:41:39.520' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (438, N'{"success":false,"error":"Query condition cannot be empty."}', CAST(N'2015-12-21 11:41:39.600' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (439, N'{"name":"20151214+HCV+Product+Launch+-+Brazil","loi":"10","incidence":"70","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=4389&crowdId=4142&providerId=16&lang=pt&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"4389:4142:API","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-12-21 13:27:17.293' AS DateTime), N'{"projectid":109,"success":true}', CAST(N'2015-12-21 13:27:17.313' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (440, N'{"projectid":"109","reqn":"50","specialty":null,"querycondition":[{"datapointid":"8","datapointoptions":["3"]},{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-12-21 13:27:17.400' AS DateTime), N'{"success":true,"queryid":105,"projectid":109,"feasibility":0}', CAST(N'2015-12-21 13:27:17.447' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (441, N'{"projectid":"109","statusid":"1"}', CAST(N'2015-12-21 13:27:17.483' AS DateTime), N'{"projectid":109,"success":true}', CAST(N'2015-12-21 13:27:17.497' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (442, N'{"name":"This+%26+That+%2F+The+Other%2C+and+Some+More+%26","loi":"1","incidence":"10","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=4332&crowdId=4039&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"4332:4039:API","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-12-21 14:53:22.397' AS DateTime), N'{"projectid":110,"success":true}', CAST(N'2015-12-21 14:53:22.433' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (443, N'{"projectid":"110","reqn":"10","specialty":null,"querycondition":[{"datapointid":"8","datapointoptions":["3"]},{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-12-21 14:53:22.697' AS DateTime), N'{"success":true,"queryid":106,"projectid":110,"feasibility":0}', CAST(N'2015-12-21 14:53:22.760' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (444, N'{"projectid":"110","statusid":"1"}', CAST(N'2015-12-21 14:53:22.837' AS DateTime), N'{"projectid":110,"success":true}', CAST(N'2015-12-21 14:53:22.850' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (445, N'{"name":"20151228+Colon+Device+Survey","loi":"10","incidence":"22","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=4441&crowdId=3062&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"4441:3062:API","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2015-12-30 18:12:48.227' AS DateTime), N'{"projectid":111,"success":true}', CAST(N'2015-12-30 18:12:48.303' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (446, N'{"projectid":"111","reqn":"15","specialty":null,"querycondition":[{"datapointid":"8","datapointoptions":["3"]},{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2015-12-30 18:12:48.453' AS DateTime), N'{"success":true,"queryid":107,"projectid":111,"feasibility":0}', CAST(N'2015-12-30 18:12:48.807' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (447, N'{"projectid":"111","statusid":"1"}', CAST(N'2015-12-30 18:12:48.883' AS DateTime), N'{"projectid":111,"success":true}', CAST(N'2015-12-30 18:12:48.970' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (448, N'126', CAST(N'2016-02-25 13:54:16.680' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-02-25 13:54:16.900' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (449, N'165', CAST(N'2016-04-28 14:59:49.660' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-04-28 14:59:49.900' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (450, N'165', CAST(N'2016-04-28 15:59:49.503' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-04-28 15:59:49.630' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (451, N'164', CAST(N'2016-04-28 15:59:49.640' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-04-28 15:59:49.643' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (452, N'165', CAST(N'2016-04-28 16:59:49.303' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-04-28 16:59:49.447' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (453, N'164', CAST(N'2016-04-28 16:59:49.457' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-04-28 16:59:49.463' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (454, N'164', CAST(N'2016-04-29 09:18:08.533' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-04-29 09:18:08.660' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (455, N'165', CAST(N'2016-04-29 09:18:08.670' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-04-29 09:18:08.687' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (456, N'164', CAST(N'2016-04-29 09:59:43.263' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-04-29 09:59:43.383' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (457, N'165', CAST(N'2016-04-29 09:59:43.390' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-04-29 09:59:43.400' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (458, N'164', CAST(N'2016-05-04 10:59:44.787' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-04 10:59:45.597' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (459, N'165', CAST(N'2016-05-04 13:59:42.967' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-04 13:59:43.090' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (460, N'164', CAST(N'2016-05-04 13:59:43.100' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-04 13:59:43.110' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (461, N'165', CAST(N'2016-05-04 14:59:42.557' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-04 14:59:42.683' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (462, N'164', CAST(N'2016-05-04 14:59:42.693' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-04 14:59:42.700' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (463, N'164', CAST(N'2016-05-04 15:59:42.267' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-04 15:59:42.397' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (464, N'165', CAST(N'2016-05-04 15:59:42.413' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-04 15:59:42.420' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (465, N'{"name":"20160425+Thoughts+On+Brands","loi":"2","incidence":"95","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=5058&crowdId=568&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"5058:568:API","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2016-05-05 11:08:36.647' AS DateTime), N'{"projectid":112,"success":true}', CAST(N'2016-05-05 11:08:36.680' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (466, N'{"projectid":"112","reqn":"3","specialty":null,"querycondition":[{"datapointid":"8","datapointoptions":["3"]},{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2016-05-05 11:08:36.780' AS DateTime), N'{"success":true,"queryid":108,"projectid":112,"feasibility":0}', CAST(N'2016-05-05 11:08:36.890' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (467, N'{"projectid":"112","statusid":"1"}', CAST(N'2016-05-05 11:08:36.923' AS DateTime), N'{"projectid":112,"success":true}', CAST(N'2016-05-05 11:08:36.937' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (468, N'{"name":"20160425+Thoughts+On+Brands","loi":"2","incidence":"95","surveylink":"http://localhost:3001/answer/?thirdParty=true&surveyId=5058&crowdId=569&providerId=16&lang=en&projectId=[session_key]&thirdPartyResponderId=[identifier]","emailsubject":"Five Minute Medical MicroSurvey; Log In Now to Answer","referencecode":"5058:569:API","surveytopic":"Your Medical Expertise Requested"}', CAST(N'2016-05-05 11:58:24.827' AS DateTime), N'{"projectid":113,"success":true}', CAST(N'2016-05-05 11:58:24.853' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (469, N'{"projectid":"113","reqn":"10","specialty":null,"querycondition":[{"datapointid":"8","datapointoptions":["3"]},{"datapointid":"15","datapointoptions":["K_rreoggymvc"]}],"exclusions":[]}', CAST(N'2016-05-05 11:58:24.937' AS DateTime), N'{"success":true,"queryid":109,"projectid":113,"feasibility":0}', CAST(N'2016-05-05 11:58:25.020' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (470, N'{"projectid":"113","statusid":"1"}', CAST(N'2016-05-05 11:58:25.067' AS DateTime), N'{"projectid":113,"success":true}', CAST(N'2016-05-05 11:58:25.080' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (471, N'164', CAST(N'2016-05-05 15:59:37.173' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-05 15:59:37.283' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (472, N'165', CAST(N'2016-05-05 15:59:37.173' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-05 15:59:37.283' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (473, N'164', CAST(N'2016-05-06 11:59:32.877' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-06 11:59:32.987' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (474, N'165', CAST(N'2016-05-06 11:59:32.880' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-06 11:59:32.990' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (475, N'179', CAST(N'2016-05-18 14:59:43.257' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-18 14:59:43.387' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (476, N'179', CAST(N'2016-05-18 15:59:42.980' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-18 15:59:43.107' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (477, N'179', CAST(N'2016-05-18 16:59:42.697' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-18 16:59:42.823' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (478, N'179', CAST(N'2016-05-19 08:59:39.420' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-19 08:59:39.550' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (479, N'179', CAST(N'2016-05-19 09:59:39.153' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-19 09:59:39.280' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (480, N'179', CAST(N'2016-05-19 10:59:39.070' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-19 10:59:39.197' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (481, N'179', CAST(N'2016-05-19 11:59:38.790' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-19 11:59:38.920' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (482, N'179', CAST(N'2016-05-19 12:59:38.720' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-19 12:59:38.857' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (483, N'179', CAST(N'2016-05-19 13:59:38.427' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-19 13:59:38.557' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (484, N'179', CAST(N'2016-05-19 14:59:38.210' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-19 14:59:38.357' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (485, N'179', CAST(N'2016-05-19 15:59:37.930' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-19 15:59:38.060' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (486, N'179', CAST(N'2016-05-19 16:59:37.603' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-19 16:59:37.720' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (487, N'179', CAST(N'2016-05-20 08:59:34.120' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-20 08:59:34.253' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (488, N'179', CAST(N'2016-05-20 09:59:36.510' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-20 09:59:36.633' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (489, N'179', CAST(N'2016-05-20 10:59:36.867' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-20 10:59:37.000' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (490, N'179', CAST(N'2016-05-20 11:59:33.753' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-20 11:59:33.917' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (491, N'179', CAST(N'2016-05-20 12:59:33.023' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-20 12:59:33.153' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (492, N'179', CAST(N'2016-05-20 13:59:32.923' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-20 13:59:33.057' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (493, N'179', CAST(N'2016-05-20 14:59:32.620' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-20 14:59:32.730' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (494, N'179', CAST(N'2016-05-20 15:59:32.657' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-20 15:59:32.787' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (495, N'179', CAST(N'2016-05-20 16:59:32.453' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-20 16:59:32.600' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (496, N'179', CAST(N'2016-05-21 08:59:29.120' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-21 08:59:29.243' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (497, N'179', CAST(N'2016-05-21 09:59:28.887' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-21 09:59:29.013' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (498, N'179', CAST(N'2016-05-21 10:59:28.490' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-21 10:59:28.630' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (499, N'179', CAST(N'2016-05-21 11:59:28.520' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-21 11:59:28.667' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (500, N'179', CAST(N'2016-05-21 12:59:28.177' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-21 12:59:28.310' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (501, N'179', CAST(N'2016-05-21 13:59:28.083' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-21 13:59:28.220' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (502, N'179', CAST(N'2016-05-21 14:59:27.710' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-21 14:59:27.843' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (503, N'179', CAST(N'2016-05-21 15:59:27.437' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-21 15:59:27.560' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (504, N'179', CAST(N'2016-05-21 16:59:27.357' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-21 16:59:27.480' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (505, N'179', CAST(N'2016-05-22 08:59:59.187' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-22 08:59:59.313' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (506, N'179', CAST(N'2016-05-22 09:59:58.890' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-22 09:59:59.017' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (507, N'179', CAST(N'2016-05-22 10:59:58.653' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-22 10:59:58.780' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (508, N'179', CAST(N'2016-05-22 11:59:58.550' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-22 11:59:58.677' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (509, N'179', CAST(N'2016-05-22 12:59:58.320' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-22 12:59:58.443' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (510, N'179', CAST(N'2016-05-22 13:59:58.067' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-22 13:59:58.190' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (511, N'179', CAST(N'2016-05-22 14:59:57.727' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-22 14:59:57.853' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (512, N'179', CAST(N'2016-05-22 15:59:57.723' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-22 15:59:57.850' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (513, N'179', CAST(N'2016-05-22 16:59:57.430' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-22 16:59:57.560' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (514, N'179', CAST(N'2016-05-23 08:59:54.150' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-23 08:59:54.280' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (515, N'179', CAST(N'2016-05-23 09:59:53.900' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-23 09:59:54.027' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (516, N'179', CAST(N'2016-05-23 10:59:53.403' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-23 10:59:53.510' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (517, N'179', CAST(N'2016-05-23 11:59:53.150' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-23 11:59:53.170' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (518, N'179', CAST(N'2016-05-23 12:59:52.943' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-23 12:59:52.950' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (519, N'179', CAST(N'2016-05-23 13:59:53.077' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-23 13:59:53.200' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (520, N'179', CAST(N'2016-05-23 14:59:52.817' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-23 14:59:52.970' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (521, N'179', CAST(N'2016-05-23 15:59:52.410' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-23 15:59:52.527' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (522, N'179', CAST(N'2016-05-23 16:59:52.443' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-23 16:59:52.570' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (523, N'179', CAST(N'2016-05-24 08:59:49.113' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-24 08:59:49.253' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (524, N'179', CAST(N'2016-05-24 09:59:48.690' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-24 09:59:48.883' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (525, N'165', CAST(N'2016-05-24 10:59:48.420' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-24 10:59:48.547' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (526, N'164', CAST(N'2016-05-24 10:59:48.420' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-24 10:59:48.547' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (527, N'179', CAST(N'2016-05-24 10:59:48.557' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-24 10:59:48.560' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (528, N'179', CAST(N'2016-05-24 11:59:48.687' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-24 11:59:48.817' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (529, N'179', CAST(N'2016-05-24 12:59:48.327' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-24 12:59:48.450' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (530, N'179', CAST(N'2016-05-24 13:59:48.093' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-24 13:59:48.237' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (531, N'179', CAST(N'2016-05-24 14:59:47.893' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-24 14:59:48.047' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (532, N'180', CAST(N'2016-05-24 14:59:48.060' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-24 14:59:48.080' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (533, N'180', CAST(N'2016-05-24 15:59:47.460' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-24 15:59:47.587' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (534, N'179', CAST(N'2016-05-24 15:59:47.707' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-24 15:59:47.713' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (535, N'180', CAST(N'2016-05-24 16:59:47.260' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-24 16:59:47.397' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (536, N'179', CAST(N'2016-05-24 16:59:47.510' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-24 16:59:47.537' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (537, N'180', CAST(N'2016-05-25 08:59:44.200' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-25 08:59:44.300' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (538, N'179', CAST(N'2016-05-25 08:59:44.310' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-25 08:59:44.313' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (539, N'180', CAST(N'2016-05-25 09:59:43.490' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-25 09:59:43.603' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (540, N'179', CAST(N'2016-05-25 09:59:43.667' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-25 09:59:43.670' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (541, N'180', CAST(N'2016-05-25 10:59:43.497' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-25 10:59:43.637' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (542, N'179', CAST(N'2016-05-25 10:59:43.653' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-25 10:59:43.670' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (543, N'180', CAST(N'2016-05-25 11:59:43.290' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-25 11:59:43.417' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (544, N'179', CAST(N'2016-05-25 11:59:43.433' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-25 11:59:43.443' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (545, N'180', CAST(N'2016-05-25 12:59:42.880' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-25 12:59:43.027' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (546, N'179', CAST(N'2016-05-25 12:59:43.047' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-25 12:59:43.047' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (547, N'180', CAST(N'2016-05-25 13:59:42.960' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-25 13:59:43.087' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (548, N'179', CAST(N'2016-05-25 13:59:43.100' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-25 13:59:43.107' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (549, N'180', CAST(N'2016-05-25 14:59:42.693' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-25 14:59:42.827' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (550, N'179', CAST(N'2016-05-25 14:59:42.833' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-25 14:59:42.847' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (551, N'180', CAST(N'2016-05-25 15:59:42.457' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-25 15:59:42.583' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (552, N'179', CAST(N'2016-05-25 15:59:42.610' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-25 15:59:42.620' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (553, N'179', CAST(N'2016-05-25 16:59:42.613' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-25 16:59:42.740' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (554, N'179', CAST(N'2016-05-26 08:59:39.180' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-26 08:59:39.310' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (555, N'179', CAST(N'2016-05-26 09:59:39.050' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-26 09:59:39.180' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (556, N'179', CAST(N'2016-05-26 10:59:38.913' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-26 10:59:39.040' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (557, N'179', CAST(N'2016-05-26 11:59:38.837' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-26 11:59:38.967' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (558, N'164', CAST(N'2016-05-26 12:59:38.573' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-26 12:59:38.700' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (559, N'165', CAST(N'2016-05-26 12:59:38.710' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-26 12:59:38.713' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (560, N'179', CAST(N'2016-05-26 12:59:46.330' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-26 12:59:46.340' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (561, N'179', CAST(N'2016-05-26 13:59:38.140' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-26 13:59:38.253' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (562, N'179', CAST(N'2016-05-26 14:59:38.297' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-26 14:59:38.427' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (563, N'179', CAST(N'2016-05-26 15:59:37.657' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-26 15:59:37.783' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (564, N'179', CAST(N'2016-05-26 16:59:37.487' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-26 16:59:37.617' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (565, N'179', CAST(N'2016-05-27 08:59:34.440' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-27 08:59:34.567' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (566, N'179', CAST(N'2016-05-27 09:59:33.837' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-27 09:59:33.943' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (567, N'164', CAST(N'2016-05-27 10:59:33.607' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-27 10:59:33.750' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (568, N'165', CAST(N'2016-05-27 10:59:33.790' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-27 10:59:33.810' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (569, N'179', CAST(N'2016-05-27 10:59:33.833' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-27 10:59:33.893' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (570, N'180', CAST(N'2016-05-27 11:59:33.127' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-27 11:59:33.133' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (571, N'179', CAST(N'2016-05-27 11:59:33.443' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-27 11:59:33.453' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (572, N'180', CAST(N'2016-05-27 12:59:32.690' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-27 12:59:32.700' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (573, N'179', CAST(N'2016-05-27 12:59:33.053' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-27 12:59:33.063' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (574, N'180', CAST(N'2016-05-27 13:59:32.523' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-27 13:59:32.533' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (575, N'179', CAST(N'2016-05-27 13:59:32.797' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-27 13:59:32.803' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (576, N'180', CAST(N'2016-05-27 14:59:32.450' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-27 14:59:32.570' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (577, N'179', CAST(N'2016-05-27 14:59:32.770' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-27 14:59:32.780' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (578, N'180', CAST(N'2016-05-27 15:59:32.420' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-27 15:59:32.550' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (579, N'179', CAST(N'2016-05-27 15:59:32.983' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-27 15:59:32.993' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (580, N'180', CAST(N'2016-05-27 16:59:32.283' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-27 16:59:32.413' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (581, N'179', CAST(N'2016-05-27 16:59:32.423' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-27 16:59:32.430' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (582, N'180', CAST(N'2016-05-28 08:59:28.930' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-28 08:59:29.057' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (583, N'179', CAST(N'2016-05-28 08:59:29.067' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-28 08:59:29.073' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (584, N'180', CAST(N'2016-05-28 09:59:28.667' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-28 09:59:28.800' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (585, N'179', CAST(N'2016-05-28 09:59:28.810' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-28 09:59:28.817' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (586, N'180', CAST(N'2016-05-28 10:59:28.450' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-28 10:59:28.660' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (587, N'179', CAST(N'2016-05-28 10:59:28.723' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-28 10:59:28.730' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (588, N'180', CAST(N'2016-05-28 11:59:28.117' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-28 11:59:28.243' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (589, N'179', CAST(N'2016-05-28 11:59:28.680' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-28 11:59:28.693' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (590, N'180', CAST(N'2016-05-28 12:59:28.083' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-28 12:59:28.210' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (591, N'179', CAST(N'2016-05-28 12:59:28.670' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-28 12:59:28.680' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (592, N'180', CAST(N'2016-05-28 13:59:27.667' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-28 13:59:27.777' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (593, N'179', CAST(N'2016-05-28 13:59:27.890' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-28 13:59:27.903' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (594, N'180', CAST(N'2016-05-28 14:59:27.647' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-28 14:59:27.777' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (595, N'179', CAST(N'2016-05-28 14:59:27.787' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-28 14:59:27.790' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (596, N'180', CAST(N'2016-05-28 15:59:27.240' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-28 15:59:27.353' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (597, N'179', CAST(N'2016-05-28 15:59:27.417' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-28 15:59:27.423' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (598, N'180', CAST(N'2016-05-28 16:59:27.263' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-28 16:59:27.393' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (599, N'179', CAST(N'2016-05-28 16:59:27.580' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-28 16:59:27.590' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (600, N'180', CAST(N'2016-05-29 08:59:59.060' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-29 08:59:59.190' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (601, N'179', CAST(N'2016-05-29 08:59:59.453' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-29 08:59:59.463' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (602, N'180', CAST(N'2016-05-29 09:59:58.800' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-29 09:59:58.930' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (603, N'179', CAST(N'2016-05-29 09:59:58.940' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-29 09:59:58.947' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (604, N'180', CAST(N'2016-05-29 10:59:58.650' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-29 10:59:58.780' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (605, N'179', CAST(N'2016-05-29 10:59:58.807' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-29 10:59:58.817' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (606, N'180', CAST(N'2016-05-29 11:59:58.370' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-29 11:59:58.497' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (607, N'179', CAST(N'2016-05-29 11:59:58.510' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-29 11:59:58.517' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (608, N'180', CAST(N'2016-05-29 12:59:58.197' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-29 12:59:58.320' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (609, N'179', CAST(N'2016-05-29 12:59:58.330' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-29 12:59:58.337' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (610, N'180', CAST(N'2016-05-29 13:59:58.017' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-29 13:59:58.143' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (611, N'179', CAST(N'2016-05-29 13:59:58.153' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-29 13:59:58.167' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (612, N'180', CAST(N'2016-05-29 14:59:57.757' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-29 14:59:57.887' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (613, N'179', CAST(N'2016-05-29 14:59:57.900' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-29 14:59:57.903' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (614, N'180', CAST(N'2016-05-29 15:59:57.680' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-29 15:59:57.817' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (615, N'179', CAST(N'2016-05-29 15:59:57.827' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-29 15:59:57.833' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (616, N'180', CAST(N'2016-05-29 16:59:57.393' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-29 16:59:57.520' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (617, N'179', CAST(N'2016-05-29 16:59:57.530' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-29 16:59:57.533' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (618, N'180', CAST(N'2016-05-30 08:59:54.107' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-30 08:59:54.237' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (619, N'179', CAST(N'2016-05-30 08:59:54.250' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-30 08:59:54.287' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (620, N'180', CAST(N'2016-05-30 09:59:53.750' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-30 09:59:53.873' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (621, N'179', CAST(N'2016-05-30 09:59:53.973' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-30 09:59:53.983' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (622, N'180', CAST(N'2016-05-30 10:59:53.597' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-30 10:59:53.733' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (623, N'179', CAST(N'2016-05-30 10:59:53.747' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-30 10:59:53.753' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (624, N'180', CAST(N'2016-05-30 11:59:53.350' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-30 11:59:53.483' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (625, N'179', CAST(N'2016-05-30 11:59:53.553' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-30 11:59:53.560' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (626, N'180', CAST(N'2016-05-30 12:59:53.163' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-30 12:59:53.290' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (627, N'179', CAST(N'2016-05-30 12:59:53.300' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-30 12:59:53.303' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (628, N'180', CAST(N'2016-05-30 13:59:52.880' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-30 13:59:53.003' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (629, N'179', CAST(N'2016-05-30 13:59:53.010' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-30 13:59:53.020' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (630, N'180', CAST(N'2016-05-30 14:59:52.720' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-30 14:59:52.860' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (631, N'179', CAST(N'2016-05-30 14:59:53.307' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-30 14:59:53.317' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (632, N'180', CAST(N'2016-05-30 15:59:52.597' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-30 15:59:52.737' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (633, N'179', CAST(N'2016-05-30 15:59:52.750' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-30 15:59:52.760' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (634, N'180', CAST(N'2016-05-30 16:59:52.277' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-30 16:59:52.437' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (635, N'179', CAST(N'2016-05-30 16:59:52.760' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-30 16:59:52.783' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (636, N'180', CAST(N'2016-05-31 08:59:49.020' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-31 08:59:49.147' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (637, N'179', CAST(N'2016-05-31 08:59:49.153' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-31 08:59:49.160' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (638, N'180', CAST(N'2016-05-31 09:59:48.777' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-31 09:59:48.903' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (639, N'179', CAST(N'2016-05-31 09:59:48.913' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-31 09:59:48.920' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (640, N'180', CAST(N'2016-05-31 10:59:48.340' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-31 10:59:48.437' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (641, N'179', CAST(N'2016-05-31 10:59:48.660' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-31 10:59:48.677' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (642, N'180', CAST(N'2016-05-31 11:59:48.327' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-31 11:59:48.450' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (643, N'179', CAST(N'2016-05-31 11:59:50.173' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-31 11:59:50.193' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (644, N'180', CAST(N'2016-05-31 12:59:48.227' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-31 12:59:48.380' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (645, N'179', CAST(N'2016-05-31 12:59:48.493' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-31 12:59:48.500' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (646, N'180', CAST(N'2016-05-31 13:59:47.780' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-31 13:59:47.883' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (647, N'179', CAST(N'2016-05-31 13:59:48.633' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-31 13:59:48.643' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (648, N'180', CAST(N'2016-05-31 14:59:47.530' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-31 14:59:47.667' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (649, N'179', CAST(N'2016-05-31 14:59:47.927' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-31 14:59:47.947' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (650, N'180', CAST(N'2016-05-31 15:59:47.533' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-31 15:59:47.660' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (651, N'179', CAST(N'2016-05-31 15:59:47.670' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-31 15:59:47.677' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (652, N'180', CAST(N'2016-05-31 16:59:46.980' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-31 16:59:47.050' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (653, N'179', CAST(N'2016-05-31 16:59:47.343' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-05-31 16:59:47.360' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (654, N'180', CAST(N'2016-06-01 08:59:43.773' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-01 08:59:43.890' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (655, N'179', CAST(N'2016-06-01 08:59:44.053' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-01 08:59:44.063' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (656, N'180', CAST(N'2016-06-01 09:59:43.593' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-01 09:59:43.720' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (657, N'179', CAST(N'2016-06-01 09:59:44.337' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-01 09:59:44.367' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (658, N'180', CAST(N'2016-06-01 10:59:43.307' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-01 10:59:43.420' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (659, N'179', CAST(N'2016-06-01 10:59:43.717' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-01 10:59:43.730' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (660, N'179', CAST(N'2016-06-01 11:59:44.133' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-01 11:59:44.250' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (661, N'179', CAST(N'2016-06-01 12:59:43.757' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-01 12:59:43.853' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (662, N'179', CAST(N'2016-06-01 13:59:43.240' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-01 13:59:43.333' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (663, N'164', CAST(N'2016-06-01 13:59:43.850' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-01 13:59:43.863' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (664, N'165', CAST(N'2016-06-01 13:59:43.867' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-01 13:59:43.893' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (665, N'179', CAST(N'2016-06-01 14:59:42.823' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-01 14:59:42.957' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (666, N'180', CAST(N'2016-06-01 14:59:42.967' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-01 14:59:42.973' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (667, N'164', CAST(N'2016-06-01 14:59:43.447' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-01 14:59:43.460' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (668, N'165', CAST(N'2016-06-01 14:59:43.450' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-01 14:59:43.470' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (669, N'180', CAST(N'2016-06-01 15:59:42.140' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-01 15:59:42.163' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (670, N'179', CAST(N'2016-06-01 15:59:42.690' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-01 15:59:42.710' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (671, N'180', CAST(N'2016-06-01 16:59:41.917' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-01 16:59:41.930' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (672, N'179', CAST(N'2016-06-01 16:59:42.467' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-01 16:59:42.477' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (673, N'180', CAST(N'2016-06-02 08:59:38.720' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-02 08:59:38.820' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (674, N'179', CAST(N'2016-06-02 08:59:39.080' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-02 08:59:39.090' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (675, N'180', CAST(N'2016-06-02 09:59:38.707' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-02 09:59:38.833' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (676, N'179', CAST(N'2016-06-02 09:59:49.240' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-02 09:59:49.247' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (677, N'180', CAST(N'2016-06-02 10:59:38.457' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-02 10:59:38.590' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (678, N'165', CAST(N'2016-06-02 10:59:39.497' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-02 10:59:39.507' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (679, N'164', CAST(N'2016-06-02 10:59:39.500' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-02 10:59:39.513' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (680, N'179', CAST(N'2016-06-02 10:59:39.590' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-02 10:59:39.600' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (681, N'180', CAST(N'2016-06-02 11:59:38.090' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-02 11:59:38.210' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (682, N'179', CAST(N'2016-06-02 11:59:38.453' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-02 11:59:38.463' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (683, N'165', CAST(N'2016-06-02 11:59:39.170' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-02 11:59:39.200' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (684, N'164', CAST(N'2016-06-02 11:59:39.170' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-02 11:59:39.257' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (685, N'180', CAST(N'2016-06-02 12:59:38.107' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-02 12:59:38.230' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (686, N'179', CAST(N'2016-06-02 12:59:38.277' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-02 12:59:38.283' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (687, N'164', CAST(N'2016-06-02 12:59:39.183' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-02 12:59:39.217' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (688, N'165', CAST(N'2016-06-02 12:59:39.183' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-02 12:59:39.250' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (689, N'180', CAST(N'2016-06-02 13:59:37.873' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-02 13:59:38.000' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (690, N'179', CAST(N'2016-06-02 13:59:38.257' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-02 13:59:38.270' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (691, N'164', CAST(N'2016-06-02 13:59:38.710' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-02 13:59:38.727' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (692, N'165', CAST(N'2016-06-02 13:59:38.713' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-02 13:59:38.730' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (693, N'179', CAST(N'2016-06-02 14:59:38.500' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-02 14:59:38.633' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (694, N'179', CAST(N'2016-06-02 15:59:37.820' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-02 15:59:37.950' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (695, N'179', CAST(N'2016-06-02 16:59:37.787' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-02 16:59:37.920' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (696, N'179', CAST(N'2016-06-03 08:59:34.390' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-03 08:59:34.517' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (697, N'179', CAST(N'2016-06-03 10:09:12.813' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-03 10:09:12.937' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (698, N'179', CAST(N'2016-06-03 10:59:33.840' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-03 10:59:33.983' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (699, N'179', CAST(N'2016-06-03 11:59:39.910' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-03 11:59:40.047' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (700, N'179', CAST(N'2016-06-03 12:59:33.617' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-03 12:59:33.743' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (701, N'180', CAST(N'2016-06-03 13:59:33.110' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-03 13:59:33.237' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (702, N'179', CAST(N'2016-06-03 13:59:34.573' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-03 13:59:34.583' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (703, N'180', CAST(N'2016-06-03 14:59:32.613' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-03 14:59:32.737' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (704, N'164', CAST(N'2016-06-03 14:59:32.760' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-03 14:59:32.767' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (705, N'165', CAST(N'2016-06-03 14:59:32.783' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-03 14:59:32.793' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (706, N'179', CAST(N'2016-06-03 14:59:58.833' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-03 14:59:58.843' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (707, N'180', CAST(N'2016-06-03 15:59:32.617' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-03 15:59:32.750' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (708, N'179', CAST(N'2016-06-03 15:59:32.907' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-03 15:59:32.920' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (709, N'180', CAST(N'2016-06-03 16:59:32.160' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-03 16:59:32.283' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (710, N'179', CAST(N'2016-06-03 16:59:33.683' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-03 16:59:33.690' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (711, N'164', CAST(N'2016-06-03 17:01:16.647' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-03 17:01:16.660' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (712, N'165', CAST(N'2016-06-03 17:01:16.647' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-03 17:01:16.670' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (713, N'180', CAST(N'2016-06-04 08:59:28.977' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-04 08:59:29.103' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (714, N'179', CAST(N'2016-06-04 08:59:29.117' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-04 08:59:29.127' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (715, N'180', CAST(N'2016-06-04 09:59:28.793' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-04 09:59:28.947' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (716, N'179', CAST(N'2016-06-04 09:59:28.977' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-04 09:59:28.983' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (717, N'180', CAST(N'2016-06-04 10:59:28.447' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-04 10:59:28.597' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (718, N'179', CAST(N'2016-06-04 10:59:28.747' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-04 10:59:28.757' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (719, N'180', CAST(N'2016-06-04 11:59:28.127' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-04 11:59:28.260' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (720, N'179', CAST(N'2016-06-04 11:59:28.857' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-04 11:59:28.863' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (721, N'180', CAST(N'2016-06-04 12:59:28.050' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-04 12:59:28.177' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (722, N'179', CAST(N'2016-06-04 12:59:28.260' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-04 12:59:28.273' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (723, N'180', CAST(N'2016-06-04 13:59:27.910' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-04 13:59:28.040' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (724, N'179', CAST(N'2016-06-04 13:59:28.053' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-04 13:59:28.060' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (725, N'180', CAST(N'2016-06-04 14:59:27.643' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-04 14:59:27.767' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (726, N'179', CAST(N'2016-06-04 14:59:28.023' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-04 14:59:28.037' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (727, N'180', CAST(N'2016-06-04 15:59:27.397' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-04 15:59:27.523' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (728, N'179', CAST(N'2016-06-04 15:59:27.537' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-04 15:59:27.543' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (729, N'180', CAST(N'2016-06-04 16:59:27.200' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-04 16:59:27.327' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (730, N'179', CAST(N'2016-06-04 16:59:27.343' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-04 16:59:27.360' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (731, N'180', CAST(N'2016-06-05 09:00:00.033' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-05 09:00:00.483' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (732, N'179', CAST(N'2016-06-05 09:00:00.480' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-05 09:00:00.610' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (733, N'180', CAST(N'2016-06-05 09:59:58.880' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-05 09:59:58.987' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (734, N'179', CAST(N'2016-06-05 09:59:59.330' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-05 09:59:59.340' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (735, N'180', CAST(N'2016-06-05 10:59:58.840' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-05 10:59:58.960' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (736, N'179', CAST(N'2016-06-05 10:59:59.240' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-05 10:59:59.250' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (737, N'180', CAST(N'2016-06-05 11:59:58.503' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-05 11:59:58.620' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (738, N'179', CAST(N'2016-06-05 12:00:01.837' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-05 12:00:01.847' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (739, N'180', CAST(N'2016-06-05 12:59:58.317' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-05 12:59:58.437' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (740, N'179', CAST(N'2016-06-05 12:59:59.790' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-05 12:59:59.800' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (741, N'180', CAST(N'2016-06-05 13:59:58.227' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-05 13:59:58.347' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (742, N'179', CAST(N'2016-06-05 13:59:58.880' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-05 13:59:58.890' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (743, N'180', CAST(N'2016-06-05 14:59:58.000' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-05 14:59:58.123' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (744, N'179', CAST(N'2016-06-05 14:59:58.130' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-05 14:59:58.140' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (745, N'180', CAST(N'2016-06-05 15:59:57.820' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-05 15:59:57.943' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (746, N'179', CAST(N'2016-06-05 15:59:59.087' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-05 15:59:59.097' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (747, N'180', CAST(N'2016-06-05 16:59:57.627' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-05 16:59:57.747' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (748, N'179', CAST(N'2016-06-05 16:59:57.757' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-05 16:59:57.763' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (749, N'180', CAST(N'2016-06-06 08:59:54.353' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-06 08:59:54.473' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (750, N'179', CAST(N'2016-06-06 08:59:54.490' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-06 08:59:54.497' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (751, N'164', CAST(N'2016-06-06 09:48:57.487' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-06 09:48:57.603' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (752, N'165', CAST(N'2016-06-06 09:48:57.640' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-06 09:48:57.663' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (753, N'180', CAST(N'2016-06-06 09:59:53.673' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-06 09:59:53.690' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (754, N'179', CAST(N'2016-06-06 09:59:54.137' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-06 09:59:54.160' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (755, N'180', CAST(N'2016-06-06 10:59:53.683' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-06 10:59:53.833' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (756, N'180', CAST(N'2016-06-06 11:59:53.600' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-06 11:59:53.723' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (757, N'179', CAST(N'2016-06-06 11:59:54.627' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-06 11:59:54.633' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (758, N'180', CAST(N'2016-06-06 12:59:53.320' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-06 12:59:53.430' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (759, N'179', CAST(N'2016-06-06 12:59:54.453' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-06 12:59:54.463' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (760, N'180', CAST(N'2016-06-06 13:59:53.263' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-06 13:59:53.387' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (761, N'179', CAST(N'2016-06-06 13:59:54.117' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-06 13:59:54.150' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (762, N'180', CAST(N'2016-06-06 14:59:53.043' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-06 14:59:53.170' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (763, N'179', CAST(N'2016-06-06 14:59:56.667' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-06 14:59:56.677' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (764, N'180', CAST(N'2016-06-06 15:59:52.993' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-06 15:59:53.117' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (765, N'180', CAST(N'2016-06-06 16:59:52.590' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-06 16:59:52.713' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (766, N'180', CAST(N'2016-06-07 08:59:49.380' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-07 08:59:49.507' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (767, N'180', CAST(N'2016-06-07 09:59:49.013' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-07 09:59:49.137' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (768, N'{"projectid":"154","statusid":"3"}', CAST(N'2016-06-28 11:45:42.673' AS DateTime), N'', CAST(N'2016-06-28 11:45:42.693' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (769, N'211', CAST(N'2016-06-28 16:59:47.590' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-28 16:59:47.690' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (770, N'211', CAST(N'2016-06-29 08:59:43.887' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-29 08:59:44.007' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (771, N'211', CAST(N'2016-06-29 09:59:43.643' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-29 09:59:43.767' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (772, N'211', CAST(N'2016-06-29 10:59:43.587' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-29 10:59:43.710' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (773, N'211', CAST(N'2016-06-29 11:59:43.340' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-29 11:59:43.467' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (774, N'211', CAST(N'2016-06-29 12:59:43.170' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-29 12:59:43.293' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (775, N'211', CAST(N'2016-06-29 13:59:43.167' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-29 13:59:43.290' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (776, N'211', CAST(N'2016-06-29 14:59:42.477' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-29 14:59:42.483' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (777, N'211', CAST(N'2016-06-29 15:59:42.407' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-29 15:59:42.530' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (778, N'211', CAST(N'2016-06-29 16:59:42.220' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-29 16:59:42.327' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (779, N'211', CAST(N'2016-06-30 08:59:38.777' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-30 08:59:38.887' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (780, N'211', CAST(N'2016-06-30 09:59:38.540' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-30 09:59:38.640' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (781, N'211', CAST(N'2016-06-30 10:59:38.190' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-30 10:59:38.203' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (782, N'211', CAST(N'2016-06-30 11:59:38.003' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-30 11:59:38.013' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (783, N'211', CAST(N'2016-06-30 12:59:37.857' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-30 12:59:37.883' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (784, N'211', CAST(N'2016-06-30 13:59:37.577' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-30 13:59:37.583' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (785, N'211', CAST(N'2016-06-30 14:59:37.360' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-30 14:59:37.367' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (786, N'211', CAST(N'2016-06-30 15:59:37.480' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-30 15:59:37.603' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (787, N'211', CAST(N'2016-06-30 16:59:37.373' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-06-30 16:59:37.500' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (788, N'211', CAST(N'2016-07-01 08:59:33.973' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-01 08:59:34.107' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (789, N'211', CAST(N'2016-07-01 09:59:33.757' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-01 09:59:33.883' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (790, N'211', CAST(N'2016-07-01 10:59:33.573' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-01 10:59:33.693' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (791, N'211', CAST(N'2016-07-01 11:59:33.320' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-01 11:59:33.443' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (792, N'211', CAST(N'2016-07-01 12:59:33.887' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-01 12:59:34.010' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (793, N'211', CAST(N'2016-07-01 13:59:32.713' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-01 13:59:32.827' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (794, N'211', CAST(N'2016-07-01 14:59:32.730' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-01 14:59:32.860' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (795, N'211', CAST(N'2016-07-01 15:59:32.490' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-01 15:59:32.610' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (796, N'211', CAST(N'2016-07-01 16:59:32.123' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-01 16:59:32.233' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (797, N'211', CAST(N'2016-07-02 08:59:28.890' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-02 08:59:29.013' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (798, N'211', CAST(N'2016-07-02 09:59:28.843' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-02 09:59:28.967' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (799, N'211', CAST(N'2016-07-02 10:59:28.607' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-02 10:59:28.737' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (800, N'211', CAST(N'2016-07-02 11:59:28.297' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-02 11:59:28.417' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (801, N'211', CAST(N'2016-07-02 12:59:28.073' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-02 12:59:28.200' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (802, N'211', CAST(N'2016-07-02 13:59:27.860' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-02 13:59:27.980' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (803, N'211', CAST(N'2016-07-02 14:59:27.710' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-02 14:59:27.833' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (804, N'211', CAST(N'2016-07-02 15:59:27.507' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-02 15:59:27.633' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (805, N'211', CAST(N'2016-07-02 16:59:27.330' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-02 16:59:27.453' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (806, N'211', CAST(N'2016-07-03 09:00:03.650' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-03 09:00:04.440' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (807, N'211', CAST(N'2016-07-03 09:59:59.163' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-03 09:59:59.307' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (808, N'211', CAST(N'2016-07-03 10:59:58.977' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-03 10:59:59.107' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (809, N'211', CAST(N'2016-07-03 11:59:58.780' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-03 11:59:58.907' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (810, N'211', CAST(N'2016-07-03 12:59:58.393' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-03 12:59:58.513' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (811, N'211', CAST(N'2016-07-03 13:59:58.357' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-03 13:59:58.493' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (812, N'211', CAST(N'2016-07-03 14:59:58.127' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-03 14:59:58.250' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (813, N'211', CAST(N'2016-07-03 15:59:57.900' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-03 15:59:58.030' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (814, N'211', CAST(N'2016-07-03 16:59:58.027' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-03 16:59:58.203' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (815, N'211', CAST(N'2016-07-04 08:59:54.403' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-04 08:59:54.530' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (816, N'211', CAST(N'2016-07-04 09:59:54.170' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-04 09:59:54.380' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (817, N'211', CAST(N'2016-07-04 10:59:53.953' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-04 10:59:54.077' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (818, N'211', CAST(N'2016-07-04 11:59:53.713' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-04 11:59:53.840' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (819, N'211', CAST(N'2016-07-04 12:59:53.477' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-04 12:59:53.600' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (820, N'211', CAST(N'2016-07-04 13:59:53.330' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-04 13:59:53.453' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (821, N'211', CAST(N'2016-07-04 14:59:53.133' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-04 14:59:53.260' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (822, N'211', CAST(N'2016-07-04 15:59:52.910' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-04 15:59:53.037' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (823, N'211', CAST(N'2016-07-04 16:59:52.710' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-04 16:59:52.870' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (824, N'211', CAST(N'2016-07-05 08:59:49.200' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-05 08:59:49.333' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (825, N'211', CAST(N'2016-07-05 09:59:49.147' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-05 09:59:49.290' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (826, N'211', CAST(N'2016-07-05 10:59:48.900' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-05 10:59:49.027' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (827, N'211', CAST(N'2016-07-05 11:59:48.820' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-05 11:59:48.920' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (828, N'211', CAST(N'2016-07-05 12:59:48.500' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-05 12:59:48.657' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (829, N'211', CAST(N'2016-07-05 13:59:48.360' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-05 13:59:48.490' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (830, N'211', CAST(N'2016-07-05 14:59:48.073' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-05 14:59:48.197' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (831, N'211', CAST(N'2016-07-05 15:59:47.813' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-05 15:59:47.943' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (832, N'211', CAST(N'2016-07-05 16:59:47.663' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-05 16:59:47.820' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (833, N'211', CAST(N'2016-07-06 08:59:44.140' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-06 08:59:44.267' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (834, N'211', CAST(N'2016-07-06 09:59:44.163' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-06 09:59:44.303' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (835, N'211', CAST(N'2016-07-06 10:59:44.030' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-06 10:59:44.153' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (836, N'211', CAST(N'2016-07-06 11:59:43.877' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-06 11:59:44.003' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (837, N'211', CAST(N'2016-07-06 12:59:43.513' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-06 12:59:43.643' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (838, N'211', CAST(N'2016-07-06 13:59:43.307' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-06 13:59:43.437' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (839, N'211', CAST(N'2016-07-06 14:59:42.893' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-06 14:59:43.020' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (840, N'211', CAST(N'2016-07-06 15:59:42.717' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-06 15:59:42.843' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (841, N'211', CAST(N'2016-07-06 16:59:42.717' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-06 16:59:42.903' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (842, N'211', CAST(N'2016-07-07 08:59:39.330' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-07 08:59:39.460' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (843, N'211', CAST(N'2016-07-07 09:59:39.657' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-07 09:59:39.847' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (844, N'211', CAST(N'2016-07-07 10:59:38.867' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-07 10:59:38.993' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (845, N'211', CAST(N'2016-07-07 11:59:38.660' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-07 11:59:38.780' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (846, N'211', CAST(N'2016-07-07 12:59:38.283' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-07 12:59:38.407' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (847, N'211', CAST(N'2016-07-07 13:59:38.020' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-07 13:59:38.123' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (848, N'211', CAST(N'2016-07-07 14:59:37.727' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-07 14:59:37.733' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (849, N'211', CAST(N'2016-07-07 15:59:37.517' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-07 15:59:37.530' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (850, N'211', CAST(N'2016-07-07 16:59:37.270' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-07 16:59:37.280' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (851, N'211', CAST(N'2016-07-08 08:59:34.070' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-08 08:59:34.183' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (852, N'211', CAST(N'2016-07-08 09:59:34.073' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-08 09:59:34.203' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (853, N'211', CAST(N'2016-07-08 10:59:33.450' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-08 10:59:33.460' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (854, N'211', CAST(N'2016-07-08 11:59:33.377' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-08 11:59:33.477' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (855, N'211', CAST(N'2016-07-08 12:59:33.250' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-08 12:59:33.380' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (856, N'211', CAST(N'2016-07-08 13:59:32.970' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-08 13:59:33.090' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (857, N'211', CAST(N'2016-07-08 14:59:33.037' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-08 14:59:33.163' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (858, N'211', CAST(N'2016-07-08 15:59:32.810' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-08 15:59:32.940' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (859, N'211', CAST(N'2016-07-08 16:59:32.547' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-08 16:59:32.650' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (860, N'211', CAST(N'2016-07-09 08:59:29.643' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-09 08:59:29.743' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (861, N'211', CAST(N'2016-07-09 09:59:29.017' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-09 09:59:29.150' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (862, N'211', CAST(N'2016-07-09 10:59:28.700' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-09 10:59:28.813' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (863, N'211', CAST(N'2016-07-09 11:59:28.493' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-09 11:59:28.617' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (864, N'211', CAST(N'2016-07-09 12:59:28.400' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-09 12:59:28.533' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (865, N'211', CAST(N'2016-07-09 13:59:28.210' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-09 13:59:28.340' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (866, N'211', CAST(N'2016-07-09 14:59:27.760' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-09 14:59:27.873' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (867, N'211', CAST(N'2016-07-09 15:59:27.810' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-09 15:59:27.937' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (868, N'211', CAST(N'2016-07-09 16:59:27.543' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-09 16:59:27.670' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (869, N'211', CAST(N'2016-07-10 08:59:59.060' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-10 08:59:59.190' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (870, N'211', CAST(N'2016-07-10 09:59:58.830' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-10 09:59:58.960' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (871, N'211', CAST(N'2016-07-10 10:59:58.390' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-10 10:59:58.507' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (872, N'211', CAST(N'2016-07-10 11:59:58.410' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-10 11:59:58.533' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (873, N'211', CAST(N'2016-07-10 12:59:58.210' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-10 12:59:58.340' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (874, N'211', CAST(N'2016-07-10 13:59:57.783' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-10 13:59:57.897' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (875, N'211', CAST(N'2016-07-10 14:59:57.813' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-10 14:59:57.940' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (876, N'211', CAST(N'2016-07-10 15:59:57.573' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-10 15:59:57.700' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (877, N'211', CAST(N'2016-07-10 16:59:57.373' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-10 16:59:57.500' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (878, N'211', CAST(N'2016-07-11 08:59:53.997' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-11 08:59:54.120' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (879, N'211', CAST(N'2016-07-11 09:59:53.607' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-11 09:59:53.720' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (880, N'211', CAST(N'2016-07-11 10:59:53.327' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-11 10:59:53.427' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (881, N'211', CAST(N'2016-07-11 11:59:53.490' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-11 11:59:53.613' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (882, N'211', CAST(N'2016-07-11 12:59:53.007' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-11 12:59:53.117' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (883, N'226', CAST(N'2016-07-15 08:59:33.933' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-15 08:59:34.080' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (884, N'226', CAST(N'2016-07-15 10:03:49.930' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-15 10:03:50.053' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (885, N'226', CAST(N'2016-07-15 11:04:40.953' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-15 11:04:40.963' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (886, N'226', CAST(N'2016-07-15 11:59:33.100' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-15 11:59:33.110' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (887, N'226', CAST(N'2016-07-15 12:24:13.597' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-15 12:24:13.613' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (888, N'226', CAST(N'2016-07-15 13:07:10.770' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-15 13:07:10.893' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (889, N'226', CAST(N'2016-07-15 13:59:32.927' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-15 13:59:33.100' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (890, N'226', CAST(N'2016-07-15 15:10:37.400' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-15 15:10:37.537' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (891, N'226', CAST(N'2016-07-15 16:23:04.750' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-15 16:23:04.877' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (892, N'226', CAST(N'2016-07-15 17:25:02.850' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-15 17:25:02.963' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (893, N'226', CAST(N'2016-07-16 08:59:28.913' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-16 08:59:29.040' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (894, N'226', CAST(N'2016-07-16 09:59:28.707' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-16 09:59:28.833' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (895, N'226', CAST(N'2016-07-16 10:59:28.783' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-16 10:59:28.913' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (896, N'226', CAST(N'2016-07-16 11:59:28.070' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-16 11:59:28.180' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (897, N'226', CAST(N'2016-07-16 12:59:27.893' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-16 12:59:28.020' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (898, N'226', CAST(N'2016-07-16 13:59:27.710' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-16 13:59:27.853' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (899, N'226', CAST(N'2016-07-16 14:59:27.687' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-16 14:59:27.810' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (900, N'226', CAST(N'2016-07-16 15:59:27.487' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-16 15:59:27.613' AS DateTime))
GO
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (901, N'226', CAST(N'2016-07-16 16:59:27.213' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-16 16:59:27.357' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (902, N'226', CAST(N'2016-07-17 08:59:59.073' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-17 08:59:59.197' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (903, N'226', CAST(N'2016-07-17 09:59:58.877' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-17 09:59:59.003' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (904, N'226', CAST(N'2016-07-17 10:59:58.720' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-17 10:59:58.847' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (905, N'226', CAST(N'2016-07-17 11:59:58.470' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-17 11:59:58.597' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (906, N'226', CAST(N'2016-07-17 12:59:58.260' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-17 12:59:58.387' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (907, N'226', CAST(N'2016-07-17 13:59:58.013' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-17 13:59:58.140' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (908, N'226', CAST(N'2016-07-17 14:59:57.733' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-17 14:59:57.860' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (909, N'226', CAST(N'2016-07-17 15:59:57.650' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-17 15:59:57.777' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (910, N'226', CAST(N'2016-07-17 16:59:57.447' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-17 16:59:57.577' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (911, N'226', CAST(N'2016-07-18 08:59:53.967' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-18 08:59:54.090' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (912, N'226', CAST(N'2016-07-18 09:59:53.913' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-18 09:59:54.037' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (913, N'226', CAST(N'2016-07-18 10:59:53.760' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-18 10:59:53.887' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (914, N'226', CAST(N'2016-07-18 10:59:53.900' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-18 10:59:53.907' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (915, N'226', CAST(N'2016-07-18 11:59:53.380' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-18 11:59:53.483' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (916, N'226', CAST(N'2016-07-18 11:59:53.383' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-18 11:59:53.487' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (917, N'226', CAST(N'2016-07-18 12:59:53.263' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-18 12:59:53.390' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (918, N'226', CAST(N'2016-07-18 13:59:53.020' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-18 13:59:53.150' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (919, N'226', CAST(N'2016-07-18 14:59:52.587' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-18 14:59:52.700' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (920, N'226', CAST(N'2016-07-18 15:59:52.500' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-18 15:59:52.643' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (921, N'226', CAST(N'2016-07-18 16:59:52.030' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-18 16:59:52.040' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (922, N'226', CAST(N'2016-07-19 08:59:49.100' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-19 08:59:49.230' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (923, N'226', CAST(N'2016-07-19 09:59:48.623' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-19 09:59:48.720' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (924, N'226', CAST(N'2016-07-19 11:01:55.667' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-19 11:01:55.673' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (925, N'226', CAST(N'2016-07-19 11:59:48.010' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-19 11:59:48.060' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (926, N'226', CAST(N'2016-07-19 12:59:47.843' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-19 12:59:47.850' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (927, N'229', CAST(N'2016-07-20 09:14:28.910' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-20 09:14:29.037' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (928, N'229', CAST(N'2016-07-20 10:16:21.050' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-20 10:16:21.153' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (929, N'229', CAST(N'2016-07-20 11:33:55.967' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-20 11:33:56.067' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (930, N'229', CAST(N'2016-07-20 12:59:43.120' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-20 12:59:43.233' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (931, N'229', CAST(N'2016-07-20 13:59:42.680' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-20 13:59:42.687' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (932, N'229', CAST(N'2016-07-20 14:59:42.553' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-20 14:59:42.673' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (933, N'229', CAST(N'2016-07-20 15:59:42.540' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-20 15:59:42.663' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (934, N'229', CAST(N'2016-07-20 16:59:42.310' AS DateTime), N'{"success":false,"error":"Query Id doesnot exists or Campaign not created yet."}', CAST(N'2016-07-20 16:59:42.437' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (935, N'{"QueryId":2,"NewRequiredN":10}', CAST(N'2016-08-01 20:59:52.190' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (936, N'{"QueryId":2,"NewRequiredN":2}', CAST(N'2016-08-01 21:10:18.273' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (937, N'{"QueryId":1000,"NewRequiredN":2}', CAST(N'2016-08-01 21:18:03.050' AS DateTime), N'{"Status":0,"Message":"Failed to Update"}', CAST(N'2016-08-01 21:18:09.510' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (938, N'{"QueryId":2,"NewRequiredN":10}', CAST(N'2016-08-02 12:56:21.347' AS DateTime), N'{"Status":1,"Message":"Updated SuccessFully"}', CAST(N'2016-08-02 12:56:22.960' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (939, N'{"QueryId":2,"NewRequiredN":10}', CAST(N'2016-08-02 12:57:00.130' AS DateTime), N'{"Status":1,"Message":"Updated SuccessFully"}', CAST(N'2016-08-02 12:57:01.367' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (940, N'{"QueryId":2,"NewRequiredN":10}', CAST(N'2016-08-02 14:20:42.703' AS DateTime), N'{"Status":1,"Message":"Updated SuccessFully"}', CAST(N'2016-08-02 14:20:43.540' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (941, N'{"QueryId":2,"NewRequiredN":10}', CAST(N'2016-08-02 14:21:35.450' AS DateTime), N'{"Status":1,"Message":"Updated SuccessFully"}', CAST(N'2016-08-02 14:21:36.197' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (942, N'{"QueryId":2,"NewRequiredN":10}', CAST(N'2016-08-02 14:22:11.480' AS DateTime), N'{"Status":1,"Message":"Updated SuccessFully"}', CAST(N'2016-08-02 14:22:12.350' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (943, N'{"QueryId":2,"NewRequiredN":10,"NewHonorium":null}', CAST(N'2016-08-02 16:41:07.113' AS DateTime), N'{"Status":1,"Message":"Updated SuccessFully"}', CAST(N'2016-08-02 16:41:15.520' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (944, N'{"QueryId":2,"NewRequiredN":10,"NewHonorium":null}', CAST(N'2016-08-02 16:47:57.823' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (945, N'{"QueryId":2,"NewRequiredN":10,"NewHonorium":null}', CAST(N'2016-08-02 16:50:44.250' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (946, N'{"QueryId":2,"NewRequiredN":10,"NewHonorium":null}', CAST(N'2016-08-02 16:51:38.537' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (947, N'{"QueryId":2,"NewRequiredN":10,"NewHonorium":null}', CAST(N'2016-08-02 16:52:40.853' AS DateTime), N'{"Status":1,"Message":"Updated SuccessFully"}', CAST(N'2016-08-02 16:52:46.427' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (948, N'{"QueryId":2,"NewRequiredN":10,"NewHonorium":null}', CAST(N'2016-08-02 19:40:47.083' AS DateTime), N'{"Status":1,"Message":"Updated SuccessFully"}', CAST(N'2016-08-02 19:40:49.540' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (949, N'{"QueryId":2,"NewRequiredN":10,"NewHonorium":null,"NewIncidence":null}', CAST(N'2016-08-03 14:15:35.623' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (950, N'{"queryid":2,"newrequiredN":0,"newhonorarium":"b","newincidence":null}', CAST(N'2016-08-08 16:49:33.807' AS DateTime), N'{"success":true}', CAST(N'2016-08-08 16:50:05.857' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (951, N'{"queryid":2,"newrequiredN":0,"newhonorarium":"b","newincidence":null}', CAST(N'2016-08-08 16:55:16.227' AS DateTime), N'{"success":true}', CAST(N'2016-08-08 16:55:19.690' AS DateTime))
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (952, N'{"queryid":21,"newrequiredN":0,"newhonorarium":"b","newincidence":null}', CAST(N'2016-08-08 17:21:53.760' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (953, N'{"queryid":21,"newrequiredN":0,"newhonorarium":"b","newincidence":null}', CAST(N'2016-08-09 12:23:43.733' AS DateTime), NULL, NULL)
INSERT [dbo].[RequestLog] ([LogId], [RequestJson], [RequestDate], [ResponseJson], [ResponseDate]) VALUES (954, N'{"queryid":2,"newrequiredN":0,"newhonorarium":"b","newincidence":null}', CAST(N'2016-08-09 12:24:45.437' AS DateTime), N'{"success":true}', CAST(N'2016-08-09 12:24:45.527' AS DateTime))
SET IDENTITY_INSERT [dbo].[RequestLog] OFF
SET IDENTITY_INSERT [dbo].[RespondentList] ON 

INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (11, N'K_bf87639a49', 2, NULL, 1, NULL, NULL, CAST(N'2016-08-04 21:27:27.710' AS DateTime), N'58.68.91.114', N'59e3fdc37adbc9c32c2efb7d049b23a1', NULL, 3, 10, NULL, 218, NULL, NULL, 10, N'RewardC')
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (12, N'K_f2deb0970d', 2, NULL, NULL, NULL, NULL, NULL, NULL, N'a1cd3aab54f80ea97732a8e33c3dea0c', NULL, 3, 10, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (13, N'K_cd964071ca', 13, NULL, 1, NULL, NULL, CAST(N'2016-08-04 21:24:04.553' AS DateTime), N'58.68.91.114', N'a7f53ce08f8081ba2a8f7f5a153f0d6a', 4422, 3, 14, CAST(N'2015-08-03 04:18:21.407' AS DateTime), NULL, NULL, NULL, 10, N'RewardA')
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (14, N'K_2b46b67a62', 13, NULL, NULL, NULL, NULL, NULL, NULL, N'44afdb67b099f83818a1a48cfd3e938c', 4422, 3, 14, CAST(N'2015-08-03 04:18:21.407' AS DateTime), NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (15, N'K_bf87639a49', 13, NULL, NULL, NULL, NULL, NULL, NULL, N'c531e2684538c10ee509073e75c7d807', 4422, 3, 14, CAST(N'2015-08-03 04:18:21.407' AS DateTime), NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (16, N'K_8d998b0953', 13, NULL, NULL, NULL, NULL, NULL, NULL, N'f4260b62f45506981ecb542d844db6d8', 4422, 3, 14, CAST(N'2015-08-03 04:18:21.407' AS DateTime), NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (17, N'K_95bb44084f', 13, NULL, NULL, NULL, NULL, NULL, NULL, N'c9049610f7c105937a03ef00cb162a0a', 4422, 3, 14, CAST(N'2015-08-03 04:18:21.407' AS DateTime), NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (18, N'K_f6c521fa93', 13, NULL, NULL, NULL, NULL, NULL, NULL, N'1fc916d8a64466cfdb059c48d162583b', 4422, 3, 14, CAST(N'2015-08-03 04:18:21.407' AS DateTime), NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (19, N'K_409f769e16', 13, NULL, NULL, NULL, NULL, NULL, NULL, N'698b4917b3805aa6f67664840409f25d', 4422, 3, 14, CAST(N'2015-08-03 04:18:21.407' AS DateTime), NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (20, N'K_4ce5622068', 13, NULL, NULL, NULL, NULL, NULL, NULL, N'83759ad3b1cfa54dff4910adc9c4ccc7', 4422, 3, 14, CAST(N'2015-08-03 04:18:21.407' AS DateTime), NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (21, N'K_7b82b67b34', 13, NULL, NULL, NULL, NULL, NULL, NULL, N'a2404d603d7e60cc4a990381a62eca6e', 4422, 3, 14, CAST(N'2015-08-03 04:18:21.407' AS DateTime), NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (22, N'K_ac0d9c8d23', 13, NULL, NULL, NULL, NULL, NULL, NULL, N'1e9959b78e1267a2660899db32b4f3a8', 4422, 3, 14, CAST(N'2015-08-03 04:18:21.407' AS DateTime), NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (23, N'K_rreoggymvc', 13, N'g08ex04k33bhgun5', NULL, N'50.250.7.210', CAST(N'2015-08-03 09:48:46.750' AS DateTime), NULL, NULL, N'g08ex04k33bhgun5', 4422, 3, 14, CAST(N'2015-08-03 04:18:21.407' AS DateTime), NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (24, N'K_bf87639a49', 33, NULL, NULL, NULL, NULL, NULL, NULL, N'4b464f1dc010d0ac54a5d1fdbe9f22ed', NULL, 3, 15, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (25, N'K_bf87639a49', 34, NULL, NULL, NULL, NULL, NULL, NULL, N'1688958752bf9e12537df2a9dcd8ade0', NULL, 3, 16, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (26, N'K_cd964071ca', 34, NULL, NULL, NULL, NULL, NULL, NULL, N'61474c80752c33eeb2c56cb2795fd15b', NULL, 3, 17, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (27, N'K_2b46b67a62', 34, NULL, NULL, NULL, NULL, NULL, NULL, N'd611fdf67501c7bd5c67ff399b196ea6', NULL, 3, 17, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (28, N'K_bf87639a49', 34, NULL, NULL, NULL, NULL, NULL, NULL, N'c99e5ada01cebf4206c728a885b86235', NULL, 3, 17, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (29, N'K_8d998b0953', 34, NULL, NULL, NULL, NULL, NULL, NULL, N'6c97415b0ff4acd765443de3f66d602d', NULL, 3, 17, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (30, N'K_95bb44084f', 34, NULL, NULL, NULL, NULL, NULL, NULL, N'e3d2ce5a7b9a3eda3926f3776b90dbee', NULL, 3, 17, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (31, N'K_f6c521fa93', 34, NULL, NULL, NULL, NULL, NULL, NULL, N'e909093c571792b4ddddb1609673c8e7', NULL, 3, 17, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (32, N'K_409f769e16', 34, NULL, NULL, NULL, NULL, NULL, NULL, N'72fde91d41adb4df960017e45010bedb', NULL, 3, 17, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (33, N'K_4ce5622068', 34, NULL, NULL, NULL, NULL, NULL, NULL, N'9641e738a28983b40832defac15d11d2', NULL, 3, 17, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (34, N'K_7b82b67b34', 34, NULL, NULL, NULL, NULL, NULL, NULL, N'7123db84d23191fb4ae520d8a16084bd', NULL, 3, 17, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (35, N'K_ac0d9c8d23', 34, NULL, NULL, NULL, NULL, NULL, NULL, N'398aff948a91e309ffb46f84de91959d', NULL, 3, 17, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (36, N'K_rreoggymvc', 34, NULL, NULL, NULL, NULL, NULL, NULL, N'e8068ca3f2b466a7c4f96156a43dc2ea', NULL, 3, 17, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (37, N'K_cd964071ca', 35, NULL, NULL, NULL, NULL, NULL, NULL, N'b3b84c608ed870c28e623af198f2d306', NULL, 3, 18, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (38, N'K_2b46b67a62', 35, NULL, NULL, NULL, NULL, NULL, NULL, N'9054f8ac3fd661eca1c8aefb358d7389', NULL, 3, 18, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (39, N'K_bf87639a49', 35, NULL, NULL, NULL, NULL, NULL, NULL, N'fe52cfdb64f517913f84eb3b7ca3ced2', NULL, 3, 18, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (40, N'K_8d998b0953', 35, NULL, NULL, NULL, NULL, NULL, NULL, N'6e652db8f264d55c02c28503db39120b', NULL, 3, 18, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (41, N'K_95bb44084f', 35, NULL, NULL, NULL, NULL, NULL, NULL, N'93a616fc814f12b734285ecd7b70f0b2', NULL, 3, 18, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (42, N'K_f6c521fa93', 35, NULL, NULL, NULL, NULL, NULL, NULL, N'0c9e3c1284bf6b731d860657bf2f9948', NULL, 3, 18, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (43, N'K_409f769e16', 35, NULL, NULL, NULL, NULL, NULL, NULL, N'2c5e55942aba284354cf17395654df7a', NULL, 3, 18, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (44, N'K_4ce5622068', 35, NULL, NULL, NULL, NULL, NULL, NULL, N'5039165a79d9aa6181230524808aa17a', NULL, 3, 18, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (45, N'K_7b82b67b34', 35, NULL, NULL, NULL, NULL, NULL, NULL, N'12d60aea6c041b159506d158486c4de1', NULL, 3, 18, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (46, N'K_ac0d9c8d23', 35, NULL, NULL, NULL, NULL, NULL, NULL, N'ff216194b9fe76037a84f487fa310fc6', NULL, 3, 18, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (47, N'K_rreoggymvc', 35, NULL, NULL, NULL, NULL, NULL, NULL, N'e2a4ebc6d66d28f9f7c5d1f8cc43015b', NULL, 3, 18, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (48, N'K_cd964071ca', 36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4442, 3, 19, CAST(N'2015-08-03 16:41:01.177' AS DateTime), NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (49, N'K_2b46b67a62', 36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4442, 3, 19, CAST(N'2015-08-03 16:41:01.177' AS DateTime), NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (50, N'K_bf87639a49', 36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4442, 3, 19, CAST(N'2015-08-03 16:41:01.177' AS DateTime), NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (51, N'K_8d998b0953', 36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4442, 3, 19, CAST(N'2015-08-03 16:41:01.177' AS DateTime), NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (52, N'K_95bb44084f', 36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4442, 3, 19, CAST(N'2015-08-03 16:41:01.177' AS DateTime), NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (53, N'K_f6c521fa93', 36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4442, 3, 19, CAST(N'2015-08-03 16:41:01.177' AS DateTime), NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (54, N'K_409f769e16', 36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4442, 3, 19, CAST(N'2015-08-03 16:41:01.177' AS DateTime), NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (55, N'K_4ce5622068', 36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4442, 3, 19, CAST(N'2015-08-03 16:41:01.177' AS DateTime), NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (56, N'K_7b82b67b34', 36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4442, 3, 19, CAST(N'2015-08-03 16:41:01.177' AS DateTime), NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (57, N'K_ac0d9c8d23', 36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4442, 3, 19, CAST(N'2015-08-03 16:41:01.177' AS DateTime), NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (58, N'K_rreoggymvc', 36, N'g1nhml39sj0t2q6j', 1, N'50.250.7.210', CAST(N'2015-08-03 16:57:39.550' AS DateTime), CAST(N'2015-08-04 00:53:32.943' AS DateTime), N'58.68.91.114', N'g1nhml39sj0t2q6j', 4442, 3, 19, CAST(N'2015-08-03 16:41:01.177' AS DateTime), NULL, NULL, NULL, 10, N'RewardA')
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (59, N'K_cd964071ca', 40, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4447, 3, 20, CAST(N'2015-08-04 10:56:01.170' AS DateTime), NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (60, N'K_2b46b67a62', 40, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4447, 3, 20, CAST(N'2015-08-04 10:56:01.170' AS DateTime), NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3879, N'K_090a8e248a', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3880, N'K_79d053efe9', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3881, N'K_2a0c1e7cce', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3882, N'K_95bb44084f', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3883, N'K_f6c521fa93', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3884, N'K_409f769e16', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3885, N'K_f2deb0970d', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3886, N'K_7ef4fd49ce', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3887, N'K_a10da422b6', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3888, N'K_4ce5622068', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3889, N'K_83d63d6182', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3890, N'K_48e8993269', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3891, N'K_7b82b67b34', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3892, N'K_ac0d9c8d23', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3893, N'K_rreoggymvc', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3894, N'K_rreoggyqwe', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3895, N'K_rreoggyrty', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3896, N'K_rreoggyuio', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3897, N'K_rreoggypas', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3898, N'K_rreoggysdf', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3899, N'K_rreoggyghj', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3900, N'K_rreoggyklz', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3901, N'K_neoggyklz', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3902, N'K_asoggyklz', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3903, N'K_bcxoggyklz', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3904, N'K_lfoggyklz', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3905, N'K_lfodfgyklz', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3906, N'K_lfoddfgyklz', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3907, N'K_lfoddfdfgklz', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3908, N'K_lfvvdfdfgklz', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3909, N'K_lfofdgfc', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3910, N'K_lffddgfc', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3911, N'K_ldddgfc', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3912, N'K_ldddgffdg', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3913, N'K_lddddgffdg', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3914, N'K_gddddgffdg', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3915, N'K_dddgffdg', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3916, N'K_dddgfdg', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3917, N'K_ddfdg', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3918, N'K_ddgfdg', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3919, N'K_dddfdg', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3920, N'K_dddfdsg', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3921, N'K_dddfg', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3922, N'K_dddfsd', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3923, N'K_dcbvbgfsd', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3924, N'K_dcbvsdxfsd', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3925, N'K_mmlpvsdxfsd', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3926, N'L_mmlpvsdxfsd', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3927, N'L_mdsdxfsd', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3928, N'L_mposdxfsd', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3929, N'K_001c6f699a', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3930, N'K_0011894c0c', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3931, N'K_cd964071ca', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3932, N'K_2b46b67a62', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3933, N'K_bf87639a49', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
INSERT [dbo].[RespondentList] ([RespondentListId], [RespondentId], [ProjectId], [Sesskey], [SurveyStatus], [SurveyRequestIP], [SurveyRequestDate], [SurveyCompletionDate], [SurveyCompletionIP], [UniqueId], [KinesisProjectId], [PanelId], [QueryId], [KinesisInsertionDate], [FK_QuerySampleMappingId], [RewardSentStatus], [RewardSentDate], [Reward], [RewardLevel]) VALUES (3934, N'K_8d998b0953', 2, NULL, NULL, NULL, NULL, NULL, NULL, N'59e3fdc37adbc9c32c2efb7d049b2321', NULL, 9, 2, NULL, 218, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[RespondentList] OFF
SET IDENTITY_INSERT [dbo].[Reward] ON 

INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (1, 1, N'101-9999999', N'0-10', N'10', N'10', N'10', N'10')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (2, 1, N'51-100', N'0-10', N'10', N'10', N'10', N'10')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (3, 1, N'21-50', N'0-10', N'10', N'10', N'10', N'10')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (4, 1, N'1-20', N'0-10', N'10', N'10', N'10', N'10')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (5, 1, N'101-9999999', N'11-20', N'20', N'20', N'20', N'20')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (6, 1, N'51-100', N'11-20', N'25', N'25', N'25', N'25')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (7, 1, N'21-50', N'11-20', N'35', N'35', N'35', N'35')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (8, 1, N'1-20', N'11-20', N'45', N'45', N'45', N'45')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (9, 1, N'101-9999999', N'21-30', N'30', N'30', N'30', N'30')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (10, 1, N'51-100', N'21-30', N'50', N'50', N'50', N'50')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (11, 1, N'21-50', N'21-30', N'60', N'60', N'60', N'60')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (12, 1, N'1-20', N'21-30', N'75', N'75', N'75', N'75')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (13, 2, N'101-9999999', N'0-10', N'10', N'10', N'10', N'10')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (14, 2, N'51-100', N'0-10', N'10', N'10', N'10', N'10')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (15, 2, N'21-50', N'0-10', N'10', N'10', N'10', N'10')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (16, 2, N'1-20', N'0-10', N'10', N'10', N'10', N'10')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (17, 2, N'101-9999999', N'11-20', N'20', N'20', N'20', N'20')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (18, 2, N'51-100', N'11-20', N'25', N'25', N'25', N'25')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (19, 2, N'21-50', N'11-20', N'55', N'55', N'55', N'55')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (20, 2, N'1-20', N'11-20', N'70', N'70', N'70', N'70')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (21, 2, N'101-9999999', N'21-30', N'35', N'35', N'35', N'35')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (22, 2, N'51-100', N'21-30', N'50', N'50', N'50', N'50')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (23, 2, N'21-50', N'21-30', N'60', N'60', N'60', N'60')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (24, 2, N'1-20', N'21-30', N'75', N'75', N'75', N'75')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (25, 3, N'101-9999999', N'0-10', N'10', N'10', N'10', N'10')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (26, 3, N'51-100', N'0-10', N'10', N'10', N'10', N'10')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (27, 3, N'21-50', N'0-10', N'10', N'10', N'10', N'10')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (28, 3, N'1-20', N'0-10', N'10', N'10', N'10', N'10')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (29, 3, N'101-9999999', N'11-20', N'25', N'25', N'25', N'25')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (30, 3, N'51-100', N'11-20', N'40', N'40', N'40', N'40')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (31, 3, N'21-50', N'11-20', N'50', N'50', N'50', N'50')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (32, 3, N'1-20', N'11-20', N'75', N'75', N'75', N'75')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (33, 3, N'101-9999999', N'21-30', N'40', N'40', N'40', N'40')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (34, 3, N'51-100', N'21-30', N'50', N'50', N'50', N'50')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (35, 3, N'21-50', N'21-30', N'75', N'75', N'75', N'75')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (36, 3, N'1-20', N'21-30', N'85', N'85', N'85', N'85')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (37, 4, N'101-9999999', N'0-10', N'10', N'10', N'10', N'10')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (38, 4, N'51-100', N'0-10', N'10', N'10', N'10', N'10')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (39, 4, N'21-50', N'0-10', N'10', N'10', N'10', N'10')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (40, 4, N'1-20', N'0-10', N'10', N'10', N'10', N'10')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (41, 4, N'101-9999999', N'11-20', N'35', N'35', N'35', N'35')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (42, 4, N'51-100', N'11-20', N'40', N'40', N'40', N'40')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (43, 4, N'21-50', N'11-20', N'85', N'85', N'85', N'85')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (44, 4, N'1-20', N'11-20', N'100', N'100', N'100', N'100')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (45, 4, N'101-9999999', N'21-30', N'60', N'60', N'60', N'60')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (46, 4, N'51-100', N'21-30', N'75', N'75', N'75', N'75')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (47, 4, N'21-50', N'21-30', N'100', N'100', N'100', N'100')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (48, 4, N'1-20', N'21-30', N'115', N'115', N'115', N'115')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (49, 5, N'101-9999999', N'0-10', N'10', N'10', N'10', N'10')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (50, 5, N'51-100', N'0-10', N'10', N'10', N'10', N'10')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (51, 5, N'21-50', N'0-10', N'10', N'10', N'10', N'10')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (52, 5, N'1-20', N'0-10', N'10', N'10', N'10', N'10')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (53, 5, N'101-9999999', N'11-20', N'60', N'60', N'60', N'60')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (54, 5, N'51-100', N'11-20', N'70', N'70', N'70', N'70')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (55, 5, N'21-50', N'11-20', N'75', N'75', N'75', N'75')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (56, 5, N'1-20', N'11-20', N'85', N'85', N'85', N'85')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (57, 5, N'101-9999999', N'21-30', N'85', N'85', N'85', N'85')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (58, 5, N'51-100', N'21-30', N'100', N'100', N'100', N'100')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (59, 5, N'21-50', N'21-30', N'115', N'115', N'115', N'115')
INSERT [dbo].[Reward] ([RewardId], [CompleteGroup], [LOI], [SampleRatio], [RewardA], [RewardB], [RewardC], [RewardD]) VALUES (60, 5, N'1-20', N'21-30', N'135', N'135', N'135', N'135')
SET IDENTITY_INSERT [dbo].[Reward] OFF
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (1, N'Addiction Medicine', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (2, N'Aerospace Medicine', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (3, N'Allergist / ENT', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (4, N'Anesthesiology', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (5, N'Blood Banking/Transfusion Medicine', 4)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (6, N'Cardiology', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (7, N'Cardiovascular Diseases', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (8, N'Clinical Biochemical Genetics', 4)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (9, N'Clinical Pharmacology', 4)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (10, N'Dermatology', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (11, N'Diabetologist', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (12, N'Emergency Medicine', 4)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (13, N'Endocrinology, Diabetes & Metabolism', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (14, N'Epidemiology', 4)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (15, N'Gastroenterology', 4)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (16, N'General Practice', 1)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (17, N'Geriatrics', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (18, N'Hematology', 4)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (19, N'Hepatology', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (20, N'HIV/AIDS', 4)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (21, N'Hospitalist', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (22, N'Immunology', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (23, N'Infectious Disease', 4)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (24, N'Internal Medicine', 1)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (25, N'Legal Medicine', 4)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (26, N'Medical Genetics', 4)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (27, N'Medical Management', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (28, N'Nephrology', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (29, N'Neurology', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (30, N'Neuropsychiatry', 4)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (31, N'Neurotology', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (32, N'Nuclear Medicine', 4)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (33, N'Nutrition', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (34, N'Obesity', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (35, N'Obstetrics & Gynecology', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (36, N'Occupational Medicine', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (37, N'Oncology (Cancer)', 4)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (38, N'Ophthalmology', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (39, N'Orthopedics', 4)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (40, N'Otolaryngology', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (41, N'Otology', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (42, N'Pain Medicine', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (43, N'Palliative Medicine', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (44, N'Pathology', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (45, N'Pediatrics', 2)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (46, N'Physical Medicine & Rehabilitation', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (47, N'Plastic Surgery', 4)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (48, N'Preventive Medicine', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (49, N'Proctology', 4)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (50, N'Psychiatry', 2)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (51, N'Public Health And General Preventive Med...', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (52, N'Pulmonary Medicine', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (53, N'Radiology', 4)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (54, N'Reproductive Endocrinology', 4)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (55, N'Rheumatology', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (56, N'Sleep Medicine', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (57, N'Sports Medicine', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (58, N'Surgery/Surgeon', 4)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (59, N'Undersea Medicine & Hyperbaric Medic...', 4)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (60, N'Urogynecology', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (61, N'Urology', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (62, N'Vascular Medicine', 4)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (63, N'Bariatric Medicine', 4)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (64, N'Community Medicine', 3)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (65, N'Critical Care Medicine', 4)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (66, N'Medical Scientist', 4)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (67, N'Medical Biochemistry', 4)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (68, N'Respirology', 4)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (69, N'Movement Disorder Specialist', 4)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (70, N'Family Medicine/Family Practice', 1)
INSERT [dbo].[SpecialityGroup] ([SpecialityOptionId], [SpecialityOptionName], [GroupId]) VALUES (72, N'Transplant', 4)
SET IDENTITY_INSERT [dbo].[SurveyLog] ON 

INSERT [dbo].[SurveyLog] ([SurveyLogId], [Url], [IPAddress], [RespondentListId], [LogDate], [LogType]) VALUES (1, N'http://ss.opinionsite.com/sandbox/pages/complete.aspx', N'58.68.91.114', 11, CAST(N'2015-07-23 12:40:15.760' AS DateTime), 2)
INSERT [dbo].[SurveyLog] ([SurveyLogId], [Url], [IPAddress], [RespondentListId], [LogDate], [LogType]) VALUES (2, N'http://ss.opinionsite.com/sandbox/pages/complete.aspx?sourcedate=%5Bxxx%5D', N'58.68.91.114', NULL, CAST(N'2015-07-23 12:40:29.383' AS DateTime), 2)
INSERT [dbo].[SurveyLog] ([SurveyLogId], [Url], [IPAddress], [RespondentListId], [LogDate], [LogType]) VALUES (3, N'http://ss.opinionsite.com/sandbox/pages/term.aspx?sourcedate=%5Bxxx%5D', N'58.68.91.114', NULL, CAST(N'2015-07-23 12:42:00.750' AS DateTime), 2)
INSERT [dbo].[SurveyLog] ([SurveyLogId], [Url], [IPAddress], [RespondentListId], [LogDate], [LogType]) VALUES (4, N'http://ss.opinionsite.com/sandbox/pages/quota.aspx?sourcedate=%5Bxxx%5D', N'58.68.91.114', NULL, CAST(N'2015-07-23 12:42:18.463' AS DateTime), 2)
INSERT [dbo].[SurveyLog] ([SurveyLogId], [Url], [IPAddress], [RespondentListId], [LogDate], [LogType]) VALUES (5, N'http://ss.opinionsite.com/sandbox/pages/Survey.aspx?identifier=K_rreoggymvc&sesskey=g08ex04k33bhgun5&prid=13', N'50.250.7.210', 23, CAST(N'2015-08-03 09:48:46.720' AS DateTime), 1)
INSERT [dbo].[SurveyLog] ([SurveyLogId], [Url], [IPAddress], [RespondentListId], [LogDate], [LogType]) VALUES (6, N'http://ss.opinionsite.com/sandbox/pages/Survey.aspx?identifier=K_rreoggymvc&sesskey=g1nhml39sj0t2q6j&prid=36', N'50.250.7.210', 58, CAST(N'2015-08-03 16:43:35.027' AS DateTime), 1)
INSERT [dbo].[SurveyLog] ([SurveyLogId], [Url], [IPAddress], [RespondentListId], [LogDate], [LogType]) VALUES (7, N'http://ss.opinionsite.com/sandbox/pages/Survey.aspx?identifier=K_rreoggymvc&sesskey=g1nhml39sj0t2q6j&prid=36', N'50.250.7.210', 58, CAST(N'2015-08-03 16:57:39.543' AS DateTime), 1)
INSERT [dbo].[SurveyLog] ([SurveyLogId], [Url], [IPAddress], [RespondentListId], [LogDate], [LogType]) VALUES (8, N'http://ss.opinionsite.com/sandbox/pages/complete.aspx?sourcedate=g1nhml39sj0t2q6j', N'50.250.7.210', NULL, CAST(N'2015-08-03 17:07:05.863' AS DateTime), 2)
INSERT [dbo].[SurveyLog] ([SurveyLogId], [Url], [IPAddress], [RespondentListId], [LogDate], [LogType]) VALUES (9, N'http://ss.opinionsite.com/sandbox/pages/complete.aspx?sourcedata=g1nhml39sj0t2q6j', N'58.68.91.114', 58, CAST(N'2015-08-04 00:53:32.930' AS DateTime), 2)
INSERT [dbo].[SurveyLog] ([SurveyLogId], [Url], [IPAddress], [RespondentListId], [LogDate], [LogType]) VALUES (10, N'http://ss.opinionsite.com/sandbox/pages/Survey.aspx?identifier=K_rreoggymvc&sesskey=g390mi6xbd3fl9dc&prid=40', N'50.250.7.210', 69, CAST(N'2015-08-04 10:58:32.947' AS DateTime), 1)
INSERT [dbo].[SurveyLog] ([SurveyLogId], [Url], [IPAddress], [RespondentListId], [LogDate], [LogType]) VALUES (11, N'http://ss.opinionsite.com/sandbox/pages/Survey.aspx?identifier=K_rreoggymvc&sesskey=g390mi6xbd3fl9dc&prid=40', N'50.250.7.210', 69, CAST(N'2015-08-04 11:05:46.970' AS DateTime), 1)
INSERT [dbo].[SurveyLog] ([SurveyLogId], [Url], [IPAddress], [RespondentListId], [LogDate], [LogType]) VALUES (12, N'http://ss.opinionsite.com/sandbox/pages/complete.aspx?sourcedata=g390mi6xbd3fl9dc', N'50.250.7.210', 69, CAST(N'2015-08-04 11:05:52.103' AS DateTime), 2)
INSERT [dbo].[SurveyLog] ([SurveyLogId], [Url], [IPAddress], [RespondentListId], [LogDate], [LogType]) VALUES (13, N'http://ss.opinionsite.com/sandbox/pages/Survey.aspx?identifier=K_rreoggymvc&sesskey=g2di7g6x82zxmy70&prid=41', N'50.250.7.210', 80, CAST(N'2015-08-04 11:07:30.843' AS DateTime), 1)
INSERT [dbo].[SurveyLog] ([SurveyLogId], [Url], [IPAddress], [RespondentListId], [LogDate], [LogType]) VALUES (14, N'http://ss.opinionsite.com/sandbox/pages/complete.aspx?sourcedata=g2di7g6x82zxmy70', N'50.250.7.210', 80, CAST(N'2015-08-04 11:07:34.683' AS DateTime), 2)
INSERT [dbo].[SurveyLog] ([SurveyLogId], [Url], [IPAddress], [RespondentListId], [LogDate], [LogType]) VALUES (15, N'http://ss.opinionsite.com/sandbox/pages/Survey.aspx?identifier=K_rreoggymvc&sesskey=g06vyjpyivr0k09v&prid=42', N'50.250.7.210', 91, CAST(N'2015-08-05 11:39:41.270' AS DateTime), 1)
INSERT [dbo].[SurveyLog] ([SurveyLogId], [Url], [IPAddress], [RespondentListId], [LogDate], [LogType]) VALUES (16, N'http://ss.opinionsite.com/sandbox/pages/complete.aspx?sourcedata=g06vyjpyivr0k09v', N'50.250.7.210', 91, CAST(N'2015-08-05 11:40:40.773' AS DateTime), 2)
INSERT [dbo].[SurveyLog] ([SurveyLogId], [Url], [IPAddress], [RespondentListId], [LogDate], [LogType]) VALUES (17, N'http://ss.opinionsite.com/sandbox/pages/Survey.aspx?identifier=K_rreoggymvc&sesskey=g0ndjrapfeglol8p&prid=48', N'50.250.7.210', 93, CAST(N'2015-08-24 16:53:25.220' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[SurveyLog] OFF
/****** Object:  StoredProcedure [dbo].[ChangeProjectStatus]    Script Date: 09/08/2016 14:06:46 ******/
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
/****** Object:  StoredProcedure [dbo].[DeleteQuery]    Script Date: 09/08/2016 14:06:46 ******/
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
/****** Object:  StoredProcedure [dbo].[GetAllLatestQuery]    Script Date: 09/08/2016 14:06:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Deepak
-- Create date: 25/07/2016 monday
-- Description:	<Description,,>
-- =============================================


CREATE procedure [dbo].[GetAllLatestQuery]
AS
BEGIN

DECLARE @MaxDate datetime
DECLARE @QueryId int

--------------------------------------------------------
DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR
		select max(CampaignCreatedDate) as MaxDate,QueryId as QueryMappingId from QuerySampleMapping where ISNULL(ErrorRetryCount,0) < 5 and  CampaignCreatedDate < DateADD(mi, -30, Current_TimeStamp) group by QueryId 	
		OPEN @MyCursor
FETCH NEXT FROM @MyCursor
INTO @MaxDate,@QueryId
WHILE @@FETCH_STATUS = 0
BEGIN	

declare @respondantCount int
--if ((select count(*) from RespondentList rl inner join project p on rl.ProjectId = p.ProjectId where rl.QueryId = @QueryId and rl.FK_QuerySampleMappingId is null or rl.FK_QuerySampleMappingId = 0 and (ISNULL(p.ErrorRetryCount,0) < 5)) = 0)

--if ((select count(*) from RespondentList rl inner join project p on rl.ProjectId = p.ProjectId where rl.QueryId = @QueryId) = 0)
	--	begin

	
	--check whether project is active or not
	if((select status from Project where projectid = (select projectid from QueryMaster where QueryId = @QueryId)) = 1)	
		begin
			if((select count(rl.RespondentId) from RespondentList rl where rl.SurveyStatus is not null and rl.SurveyStatus = 1 and rl.QueryId = @QueryId) < (select reqN from QueryMaster where QueryId = @QueryId))
			begin	
				
				---------------------------------------------------------------------
				DECLARE @IR INT 
				DECLARE @FeasRespondCount DECIMAL(18,4)
				DECLARE @Feasiblity INT
				DECLARE @MaxPanelistCount INT
				DECLARE @InsertCount  DECIMAL(18,4)
				DECLARE @Group INT,@RR int,@ReqN int,@ProjectId int
				DECLARE @Sql VARCHAR(MAX),@QueryCondition varchar(MAX)


				set @ProjectId = (select projectid from QueryMaster where QueryId = @QueryId)
				set @ReqN = (select reqN from QueryMaster where QueryId = @QueryId)
				set @QueryCondition = (select Query from QueryMaster where QueryId = @QueryId)

			

				---If the sample request is for Group=4 put it at 2% otherwise put it at 3%
				SET @RR = 3
				SET @Group = (SELECT CompleteGroup FROM QueryMaster WHERE QueryId = @QueryId)

				IF @Group = 4
						BEGIN
						SET @RR = 2 
						END

						SET @IR = (SELECT Incidence FROM dbo.Project WHERE ProjectId = @ProjectId)
						SET @FeasRespondCount =(convert(decimal,@ReqN)*10000)/(@IR*@RR)


						CREATE TABLE #RespondentsTemp
						(
							Identifier varchar(1000),
							PanelistType int,
							Speciality int,
							ProjectId int,
							QueryId int,
							PanelId int	,
							--New requirement
							querysamplemappingId int,
							surveycompletioncount int 
						 )

						 	SET @Sql=N'INSERT INTO #RespondentsTemp(Identifier,ProjectId,QueryId,PanelId,surveycompletioncount) 
SELECT Identifier ,'+Convert(varchar,@ProjectId)+', '+Convert(varchar,@QueryId)+'
	,pnlst.PanelId	, pnlst.surveycompletioncount
FROM (
	SELECT Identifier
		,P.PanelId,
		p.surveycompletioncount
	FROM PanelistMaster P
	WHERE ACTIVE=1 AND '+	@QueryCondition+') pnlst
WHERE NOT EXISTS(SELECT * FROM RespondentList rl WHERE rl.RespondentId = pnlst.Identifier AND rl.ProjectId ='+Convert(varchar,@ProjectId)+') order by pnlst.surveycompletioncount asc'

exec(@Sql)


	--New requirement
	declare @querysamplemappingId int	
	insert into querysamplemapping (queryid,MaxRemainder) values (@QueryId,2)
	set @querysamplemappingId = (select SCOPE_IDENTITY())
	update #RespondentsTemp set querysamplemappingId = @querysamplemappingId


SET @MaxPanelistCount = (SELECT COUNT(*) FROM #RespondentsTemp)
select @MaxPanelistCount as MaxPanelistCount
	
	
	--IF @MaxPanelistCount < @FeasRespondCount 
	--BEGIN
	--	SET @InsertCount = @MaxPanelistCount
	--END
	--ELSE
	--BEGIN
	SET @InsertCount = @FeasRespondCount
	--END

	
	if(@ReqN <= 10)
	begin
		set	@InsertCount = 2 * @FeasRespondCount
	end
	else
	begin
		set @InsertCount = CONVERT(INT,@FeasRespondCount)/4
	end
	
	
INSERT INTO RespondentList(RespondentId,ProjectId,QueryId,PanelId,FK_QuerySampleMappingId)
(SELECT TOP(CONVERT(INT,@InsertCount)) Identifier,rt.ProjectId,rt.QueryId,rt.PanelId,rt.querysamplemappingId FROM 
 #RespondentsTemp rt 
 WHERE rt.QueryId = @QueryId 
 )

DECLARE @timeResponse int
DECLARE @current_Hour INT
SELECT @current_hour = DATEPART(HH,@MaxDate)

DECLARE @startTime INT
SET @startTime = 22		--10 PM
DECLARE @endtime INT
set @endTime = 7		--7 AM

 --if no items is added to respondantlist table,it means that all identifiers for query recieve first set of invitations,then we need to start sending inviations
 --if((select count(*) from #RespondentsTemp) = 0)
	--begin	
	--	if((select count(*) from RespondentList where (SurveyStatus is null or SurveyStatus = 4) and ProjectId = @ProjectId and queryid = @QueryId) > 0)
	--		begin	
	--			if exists(select FK_QuerySampleMapping from SampleRemainderHistoryTable where FK_QuerySampleMapping = (select id from QuerySampleMapping where CampaignCreatedDate = @MaxDate) group by FK_QuerySampleMapping  having datediff(hh, max(RemainderSentDate), getdate()) >= 6)
	--				begin
	--					if ((select ISNULL(remaindercount,0) from QuerySampleMapping where id = (select id from QuerySampleMapping where CampaignCreatedDate = @MaxDate)) < (select ISNULL(MaxRemainder,0) from QuerySampleMapping where id = (select id from QuerySampleMapping where CampaignCreatedDate = @MaxDate)))
	--						begin
	--						update QuerySampleMapping set SendReminder = 1 , ReminderRequestDate = getdate(),remaindercount = ISNULL(remaindercount,0) + 1 where id = (select id from QuerySampleMapping where CampaignCreatedDate = @MaxDate)					
	--						end
	--				end
	--			else if exists (select CampaignCreatedDate from QuerySampleMapping where id = (select id from QuerySampleMapping where CampaignCreatedDate = @MaxDate) group by CampaignCreatedDate having datediff(hh,MAX(CampaignCreatedDate), GETDATE()) >= 6)
	--				begin
	--					if ((select ISNULL(remaindercount,0) from QuerySampleMapping where id = (select id from QuerySampleMapping where CampaignCreatedDate = @MaxDate)) < (select ISNULL(MaxRemainder,0) from QuerySampleMapping where id = (select id from QuerySampleMapping where CampaignCreatedDate = @MaxDate)))
	--						begin							
	--						update QuerySampleMapping set SendReminder = 1 , ReminderRequestDate = getdate(),remaindercount = ISNULL(remaindercount,0) + 1 where id = (select id from QuerySampleMapping where CampaignCreatedDate = @MaxDate)					
	--						end
	--				end
	--		end
	--end

	declare @CreatedDateorLastInsertdDate datetime
	 if exists(select RemainderSentDate from SampleRemainderHistoryTable where FK_QuerySampleMapping = (select id from QuerySampleMapping where CampaignCreatedDate = @MaxDate))
		 begin
			set @CreatedDateorLastInsertdDate = (select RemainderSentDate from SampleRemainderHistoryTable where FK_QuerySampleMapping = (select id from QuerySampleMapping where CampaignCreatedDate = @MaxDate))
		 end
	 else
		begin
			set @CreatedDateorLastInsertdDate = (select CampaignCreatedDate from QuerySampleMapping where id = (select id from QuerySampleMapping where CampaignCreatedDate = @MaxDate))
		end

	if((select count(*) from #RespondentsTemp) = 0)
	begin	
		if((select count(*) from RespondentList where (SurveyStatus is null or SurveyStatus = 4) and ProjectId = @ProjectId and queryid = @QueryId) > 0)
			begin	
				
				----------------Logic for sending Remainder Comes Here------------------------

				set @timeResponse = (SELECT CASE 
									  WHEN @startTime <= @endTime
									  THEN 
									  CASE WHEN   @current_hour BETWEEN @startTime AND @endtime THEN 1 ELSE  0 END
									  ELSE
								      CASE WHEN @current_hour BETWEEN @endtime AND @startTime THEN   0 ELSE 1 END
									  END)	

				if(@timeResponse = 1)
					begin
						set @CreatedDateorLastInsertdDate = (SELECT DATEADD(day, DATEDIFF(day, 0, GETDATE()), '07:00:00'))			
					end

				if(cast(@CreatedDateorLastInsertdDate as date) != cast(GETDATE() as date))
					begin
						if(cast(@CreatedDateorLastInsertdDate as time) <= '22:00:00:00')
							begin	
								if((select DATEDIFF(hour, (select cast(@CreatedDateorLastInsertdDate as time)), '22:00:00.00') +  (select DATEDIFF(hour, '07:00:00.00', (select cast(GETDATE() as time))))) >= 6)
									begin										
										----Logic of updating the status for sending Remainder
										if ((select ISNULL(remaindercount,0) from QuerySampleMapping where id = (select id from QuerySampleMapping where CampaignCreatedDate = @MaxDate)) < (select ISNULL(MaxRemainder,0) from QuerySampleMapping where id = (select id from QuerySampleMapping where CampaignCreatedDate = @MaxDate)))
												begin
												update QuerySampleMapping set SendReminder = 1 , ReminderRequestDate = getdate(),remaindercount = ISNULL(remaindercount,0) + 1 where id = (select id from QuerySampleMapping where CampaignCreatedDate = @MaxDate)					
												end		
									end		
							end
					end

				else if(cast(@CreatedDateorLastInsertdDate as date) = cast(GETDATE() as date))
					begin
						if(cast(@CreatedDateorLastInsertdDate as time) >= '07:00:00:00')
							begin	
								if((select DATEDIFF(hour, (select cast(@maxdate as time)), (select cast(getdate() as time)))) >= 6)
									begin
											----Logic of updating the status for sending Remainder
										if ((select ISNULL(remaindercount,0) from QuerySampleMapping where id = (select id from QuerySampleMapping where CampaignCreatedDate = @MaxDate)) < (select ISNULL(MaxRemainder,0) from QuerySampleMapping where id = (select id from QuerySampleMapping where CampaignCreatedDate = @MaxDate)))
												begin
												update QuerySampleMapping set SendReminder = 1 , ReminderRequestDate = getdate(),remaindercount = ISNULL(remaindercount,0) + 1 where id = (select id from QuerySampleMapping where CampaignCreatedDate = @MaxDate)					
												end
									end		
							end
					end


			end
	end


 SET @Feasiblity = CEILING((convert(decimal,@InsertCount) *@RR*@IR)/10000)
 
 SELECT @Feasiblity as feasibility
 DROP TABLE #RespondentsTemp

				----------------------------------------------------------------------
			end
		end
		--end

FETCH NEXT FROM @MyCursor
INTO @MaxDate,@QueryId
END
CLOSE @MyCursor
DEALLOCATE @MyCursor
END

GO
/****** Object:  StoredProcedure [dbo].[GetNewProjectRequests]    Script Date: 09/08/2016 14:06:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetNewProjectRequests] 
	
AS
BEGIN



	SELECT DISTINCT
	FK_QuerySampleMappingId,
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
		rl.FK_QuerySampleMappingId,
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
	    q.Reward,
	    q.Reward AS RewardPoints,
	    ReferenceCode,
	    SurveyTopic,
	    q.QueryId AS QueryId
		FROM Project p	
		INNER JOIN QueryMaster q ON q.ProjectId = p.ProjectId
		INNER JOIN RespondentList rl ON rl.QueryId = q.QueryId
		WHERE 
		((rl.KinesisProjectId IS NULL OR rl.KinesisProjectId = 0 )AND P.Status=1 AND ISNULL(p.ErrorRetryCount,0) < 5) 
			
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

		--SELECT  
		--p.ProjectId,
		--EmailSubject,
		--p.LOI,
	 --   Reward,
	 --   Reward * 10 AS RewardPoints,
	 --   ReferenceCode,
	 --   SurveyTopic,
	 --   q.QueryId AS QueryId,
	 --   CampaignId,
	 --   p.KinesisProjectId,
	 --   SampleId
		--FROM 
		--Project p	
		--INNER JOIN QueryMaster q ON q.ProjectId = p.ProjectId
		--WHERE 
		--SendReminder = 1
		--AND 
		--ReminderSentStatus IS NULL 
		--AND
		--KinesisReminderSentDate IS NULL
		--AND 
		--Status = 1 AND CampaignId IS NOT NULL AND ISNULL(KinesisReminderErrorCount,0) < 5

		-- new requirement
		SELECT  
		qsm.id as QuerySampleMappingId,
		p.ProjectId,
		EmailSubject,
		p.LOI,
	    Reward,
	    Reward * 10 AS RewardPoints,
	    ReferenceCode,
	    SurveyTopic,
	    q.QueryId AS QueryId,
	    qsm.CampaignId,
	    p.KinesisProjectId,
	    qsm.SampleId
		FROM 
		Project p	
		INNER JOIN QueryMaster q ON q.ProjectId = p.ProjectId
		inner join querysamplemapping qsm on q.QueryId = qsm.QueryId
		WHERE 
		qsm.SendReminder = 1
		--AND 
		--qsm.ReminderSentStatus IS NULL 
		--AND
		--qsm.KinesisReminderSentDate IS NULL
		AND 
		Status = 1 AND qsm.CampaignId IS NOT NULL AND ISNULL(qsm.KinesisReminderErrorCount,0) < 5 

	
	-- New Requiement		
	--getting honoruim updated respondents 
	select respondentId as Identifier,respondentlistId as RespondentListId,Reward * 10 as RewardPoints,'Setting reward points after the completion of survey' as RewardDesciption from respondentlist where surveystatus = 1 and rewardsentdate is null and rewardsentstatus is null
END

GO
/****** Object:  StoredProcedure [dbo].[GetProjectSearchDetails]    Script Date: 09/08/2016 14:06:46 ******/
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



	-- New Requirement
	-- Need to update admin reporting screens to identify number of completes by hono rate level 	
	select isnull (Completes,0) AS [Completes Count],p.ProjectId,rl.QueryId,('Reward level ' + replace(rl.rewardlevel,'Reward','') +' @ '+ convert(nvarchar(50),rl.reward)) as HonorariumRateLevel  from RespondentList rl left join Project p on p.projectid = rl.ProjectId
LEFT OUTER JOIN
	(
	SELECT QueryId,projectId,Count(RespondentListId) AS Completes  
	FROM  dbo.RespondentList rl WHERE SurveyStatus = 1 Group by QueryId,projectId  
	) rlt 
ON rlt.QueryId = rl.QueryId
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
	AND
	(
	rl.SurveyStatus =1
	)
	)	
	ORDER BY rl.reward

END

GO
/****** Object:  StoredProcedure [dbo].[GetProjectStatus]    Script Date: 09/08/2016 14:06:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GetProjectStatus]
@Projectid nvarchar(50)


AS
BEGIN


DECLARE @QueryId int
--------------------------------------------------------
DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR
select queryid from querymaster where ProjectId =  @Projectid
OPEN @MyCursor
FETCH NEXT FROM @MyCursor
INTO @QueryId
WHILE @@FETCH_STATUS = 0
BEGIN

declare @InvitationSentCount int,@RemainderSentCount int,@NumberOfCompletes int,@RewardLevel nvarchar(20)

-- Finding Count of Invitations already sent for a query 	
select @InvitationSentCount =  count(*) from RespondentList rl inner join QuerySampleMapping qm on rl.FK_QuerySampleMappingId = qm.id where SampleId is not null and CampaignId is not null and qm.QueryId = @QueryId

-- Finding Number of Remainders Sent
select @RemainderSentCount = isnull(sum(isnull(remaindercount,0)),0)  from respondentlist rl inner join QuerySampleMapping qm on rl.FK_QuerySampleMappingId = qm.id  where qm.QueryId = @QueryId

-- Number of Completes 
select @NumberOfCompletes = COUNT(*) from RespondentList where QueryId = @QueryId and SurveyStatus = 1

select @RewardLevel = Rewardlevel from QueryMaster where QueryId = @QueryId

select @QueryId as QueryId, @InvitationSentCount as InvitationSentCount,@RemainderSentCount as RemainderSentCount,@NumberOfCompletes as NumberOfCompletes,@RewardLevel as RewardLevel
 
FETCH NEXT FROM @MyCursor
INTO @QueryId
END
CLOSE @MyCursor
DEALLOCATE @MyCursor


   

	-- Finding Count of Invitations already sent for a query 	
	--select COUNT(*) as Invitations from QuerySampleMapping qsm inner join QueryMaster qm on qm.QueryId = qsm.QueryId where qm.ProjectId = @Projectid and qsm.SampleId is not null and qsm.CampaignId is not null	

	-- Finding Number of Remainders Sent
	--select isnull(sum(isnull(remaindercount,0)),0) as RemainderSent from querysamplemapping qsm inner join querymaster q on q.queryid = qsm.queryid where q.projectid = @Projectid

	-- Number of Completes 
	--select count(*) as NoOfCompletes from RespondentList where projectid = @Projectid and SurveyStatus = 1
	
END


GO
/****** Object:  StoredProcedure [dbo].[ImportPanelistToDB]    Script Date: 09/08/2016 14:06:46 ******/
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
/****** Object:  StoredProcedure [dbo].[SaveProject]    Script Date: 09/08/2016 14:06:46 ******/
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
/****** Object:  StoredProcedure [dbo].[SaveQueryAndGetProjectStatus]    Script Date: 09/08/2016 14:06:46 ******/
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
				
				
				SELECT @Reward = RewardA,@QuerySampleRatio = SampleRatio
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
					ExclusionCount,
					RewardLevel
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
					@ExclusionCount,
					'RewardA'
					)

					-- New Requirement
				  SELECT scope_identity() as QueryId,status,(select @TotalRespondent ) as MaxAddressable  FROM Project WHERE ProjectId=@ProjectId
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
/****** Object:  StoredProcedure [dbo].[SaveReminder]    Script Date: 09/08/2016 14:06:46 ******/
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
	-- New Requirement
	--IF EXISTS(SELECT 1 FROM QueryMaster WHERE QueryId = @QueryId AND CampaignId IS NOT NULL)
	IF EXISTS(SELECT 1 FROM QuerySampleMapping WHERE QueryId = @QueryId AND CampaignId IS NOT NULL)	
	BEGIN

	-- New Requirement

		--UPDATE QueryMaster 
		--SET
		--SendReminder = 1,
		--ReminderRequestDate = GETDATE()
		--WHERE QueryId = @QueryId
		--SELECT 'true'

		update QuerySampleMapping set SendReminder = 1, ReminderRequestDate = GETDATE() where queryid = @QueryId
		SELECT 'true'
	END
	ELSE 
	BEGIN
		SELECT 'false'
	END
END

GO
/****** Object:  StoredProcedure [dbo].[SaveRequestLog]    Script Date: 09/08/2016 14:06:46 ******/
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
	@Json VARCHAR(MAX)=null
	
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
/****** Object:  StoredProcedure [dbo].[SaveRespondentList]    Script Date: 09/08/2016 14:06:46 ******/
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
WITH RECOMPILE	
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
				PanelId int,
				--New requirement
				querysamplemappingId int
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


	--New requirement
	declare @querysamplemappingId int
	insert into querysamplemapping (queryid,MaxRemainder) values (@QueryId,2)
	set @querysamplemappingId = (select SCOPE_IDENTITY())
	update #RespondentsTemp set querysamplemappingId = @querysamplemappingId

	SET @MaxPanelistCount = (SELECT COUNT(*) FROM #RespondentsTemp)
	
	IF @MaxPanelistCount < @FeasRespondCount 
	BEGIN
		SET @InsertCount = @MaxPanelistCount
	END
	ELSE
	BEGIN
		SET @InsertCount = @FeasRespondCount
	END

	

	

 INSERT INTO RespondentList(RespondentId,ProjectId,QueryId,PanelId,FK_QuerySampleMappingId)
((SELECT TOP(CONVERT(INT,@InsertCount)) Identifier,rt.ProjectId,rt.QueryId,rt.PanelId,rt.querysamplemappingId FROM 
 #RespondentsTemp rt 
 WHERE rt.QueryId = @QueryId
 ))



 
 --	UPDATE RespondentList SET 
 --	UniqueId = SUBSTRING(master.dbo.fn_varbintohexstr(HashBytes('MD5', CONVERT(varchar, RespondentListId+GETDATE()))), 3, 32) 
	--WHERE ProjectId = @ProjectId AND UniqueId IS NULL
	
 SET @Feasiblity = CEILING((convert(decimal,@InsertCount) *@RR*@IR)/10000)
 
 SELECT @Feasiblity as feasibility
 DROP TABLE #RespondentsTemp
 
END


GO
/****** Object:  StoredProcedure [dbo].[SaveSurveyLog]    Script Date: 09/08/2016 14:06:46 ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateDataGetSCHSurveyURL]    Script Date: 09/08/2016 14:06:46 ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateKinesisProjectClosedStatus]    Script Date: 09/08/2016 14:06:46 ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateKinesisProjectStatus]    Script Date: 09/08/2016 14:06:46 ******/
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
@SampleId int = NULL,

-- new requirement
@QuerysampleMappingId int = null

AS
BEGIN

DECLARE @ErrorRetryCount INT = 0
declare @QuerrySampleMappingScopeIdentity int = 0


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
	

	
	 -- New Requirement added new column called CampaignCreatedDate and set getdate()
	IF @CampaignId IS NOT NULL
	BEGIN
		--UPDATE dbo.QueryMaster SET CampaignId = @CampaignId,SampleId=@SampleId, CampaignCreatedDate = getdate()  WHERE QueryId = @QueryId
		--INSERT into dbo.QuerySampleMapping (QueryId,SampleId,CampaignId,CampaignCreatedDate) values (@QueryId,@SampleId,@CampaignId,getdate())
		--set @QuerrySampleMappingScopeIdentity  = SCOPE_IDENTITY()

			update QuerySampleMapping set KinesisAPIError = @KinesisAPIError,ErrorRetryCount = 
			(case when @KinesisStatus != 3
			then ISNULL(ErrorRetryCount,0)+1 else
			ErrorRetryCount end),SampleId = @SampleId, CampaignId = @CampaignId,CampaignCreatedDate = getdate()
			where id = @QuerysampleMappingId
	END

	IF 	@KinesisStatus = 3 
	BEGIN
		Update RespondentList SET
		KinesisProjectId = @KinesisProjectId,
		KinesisInsertionDate = getdate()
		--FK_QuerySampleMappingId = @QuerrySampleMappingScopeIdentity
		WHERE RespondentListId IN (SELECT data  from dbo.Split(@RespondentListId,','))
	END
	
END

GO
/****** Object:  StoredProcedure [dbo].[UpdateKinesisReminderStatus]    Script Date: 09/08/2016 14:06:46 ******/
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
	@FailedQueryIds varchar(2000) = NULL,

	-- new requirement
	@QuerySampleMappingIds varchar(2000) = NULL,
	@FailedQuerySampleMappingIds varchar(200) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--IF @QueryIds IS NOT NULL
-- new requirement
if @QuerySampleMappingIds is not null
BEGIN
 --UPDATE QueryMaster SET
 --KinesisReminderSentDate = GETDATE(),
 --ReminderSentStatus = 1
 --WHERE QueryId IN (SELECT Data FROM Split(@QueryIds,','))

 -- new requirement
 update QuerySampleMapping set
 ReminderSentStatus = 1,
 SendReminder = 0  
 where id in (SELECT Data FROM Split(@QuerySampleMappingIds,','))
 
 insert into SampleRemainderHistoryTable (FK_QuerySampleMapping,RemainderSentDate)  (SELECT Data, getdate() FROM Split(@QuerySampleMappingIds,','))

END

--IF @FailedQueryIds IS NOT NULL
-- new requirement
if @FailedQuerySampleMappingIds is not null
BEGIN
 --UPDATE QueryMaster SET
 --KinesisReminderErrorCount = ISNULL(KinesisReminderErrorCount,0)+1
 --WHERE QueryId IN (SELECT Data FROM Split(@FailedQueryIds,','))

 update QuerySampleMapping set
 KinesisReminderErrorCount = ISNULL(KinesisReminderErrorCount,0)+1
 where id in (SELECT Data FROM Split(@FailedQuerySampleMappingIds,','))
END
 
 
 
 
END

GO
/****** Object:  StoredProcedure [dbo].[UpdatePanelistMasterStatus]    Script Date: 09/08/2016 14:06:46 ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateProjectStatusToClose]    Script Date: 09/08/2016 14:06:46 ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateProjectToClose]    Script Date: 09/08/2016 14:06:46 ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateQuery]    Script Date: 09/08/2016 14:06:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[UpdateQuery]
@QueryId int,
@NewN int = null,
@NewHonorium nvarchar(20) = null,
@NewIncidence nvarchar(20) = null


AS
BEGIN

DECLARE @Status INT
SET @Status = (SELECT Status FROM Project WHERE ProjectId = (select projectid from querymaster where queryid = @QueryId))

	IF (@Status != 3 and @Status != 4)
			begin
		--updating honorum
		if(@NewN is null and @NewIncidence is null and @NewHonorium is not null)
			begin
		-- updating honorum doesn't require sample ratio calculation 
			update querymaster set RewardLevel = CASE  
                        WHEN LOWER(@NewHonorium) = 'a' THEN 'RewardA'
						WHEN LOWER(@NewHonorium) = 'b' THEN 'RewardB'
						WHEN LOWER(@NewHonorium) = 'c' THEN 'RewardC'
						WHEN LOWER(@NewHonorium) = 'd' THEN 'RewardD' 
						END
						where queryId = @QueryId

				DECLARE @Reward1 int
				DECLARE @QuerySampleRatio1 varchar(500)
				DECLARE @SRdenominator1 decimal(18,2),@ReqN1 INT ,@ExclusionCount1 INT, @Incidence1 int, @SampleRatio1 decimal(18,2), @TotalRespondent1 int ,@Group1 int, @LOI1 int,@projectid1 int				 

				set @projectid1 = (select projectid from project where projectid = (select projectid from querymaster where queryid = @QueryId))
				set @ReqN1 = (select ISNULL(ReqN,0) from querymaster where queryid = @QueryId)
				set @ExclusionCount1 = (select ISNULL(exclusioncount,0) from querymaster where queryid = @QueryId)
				SELECT @Incidence1 = Incidence,@LOI1=LOI FROM Project WHERE ProjectId=@projectid1
				set @TotalRespondent1 = (select ISNULL(totalrespondent,0) from querymaster where queryid = @QueryId)
				set @ReqN1 = (select ISNULL(ReqN,0) from querymaster where queryid = @QueryId)

				SET @SRdenominator1 = ((CONVERT(DECIMAL(18,2),@ReqN1)+CONVERT(DECIMAL(18,2),@ExclusionCount1))*(CONVERT(DECIMAL(18,2),@Incidence1)/100))
			    SET @SampleRatio1 = @TotalRespondent1 / @SRdenominator1
			    IF @SampleRatio1  < 1 
			    BEGIN
					SET @SampleRatio1 = 1
			    END
				
				SELECT @Group1 = GroupId FROM SpecialityGroup WHERE SpecialityOptionId = (select speciality from querymaster where queryid = @QueryId)



				SELECT @Reward1 = CASE  
                        WHEN LOWER(@NewHonorium) = 'a' THEN RewardA
						WHEN LOWER(@NewHonorium) = 'b' THEN RewardB
						WHEN LOWER(@NewHonorium) = 'c' THEN RewardC
						WHEN LOWER(@NewHonorium) = 'd' THEN RewardD
						end,
						@QuerySampleRatio1 = SampleRatio
				FROM Reward
				WHERE @LOI1 
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
				convert(int,@SampleRatio1) BETWEEN 
				(
					SELECT Min(Convert(int,Data))
					FROM Split(SampleRatio, '-')
				)
				AND
				(
					SELECT Max(Convert(int,Data))
					FROM Split(SampleRatio, '-')
				)
				AND CompleteGroup = @Group1

		

				update querymaster set sampleratio = @QuerySampleRatio1,reward = @Reward1,rewardlevel = case 
																										WHEN LOWER(@NewHonorium) = 'a' THEN 'RewardA' 
																										WHEN LOWER(@NewHonorium) = 'b' THEN 'RewardB'
																										WHEN LOWER(@NewHonorium) = 'c' THEN 'RewardC'
																										WHEN LOWER(@NewHonorium) = 'd' THEN 'RewardD'
																										end
																										where queryid = @QueryId 



				
				-- updating the maxremainder count by honorium is updated	
				if(@NewHonorium is not null)	
				begin		
				DECLARE @querysamplemappingid1 int
				--------------------------------------------------------
				DECLARE @MyCursor1 CURSOR
				SET @MyCursor1 = CURSOR FAST_FORWARD
				FOR
				SELECT id FROM  querysamplemapping where queryid = @QueryId
				OPEN @MyCursor1
				FETCH NEXT FROM @MyCursor1
				INTO @querysamplemappingid1
				WHILE @@FETCH_STATUS = 0
				BEGIN
					
				if((select maxremainder from querysamplemapping where id = @querysamplemappingid1) =  (select remaindercount from querysamplemapping where id = @querysamplemappingid1))
					begin
						update querysamplemapping set maxremainder = maxremainder + 1 where id = @querysamplemappingid1
					end
				 
				FETCH NEXT FROM @MyCursor1
				INTO @querysamplemappingid1
				END
				CLOSE @MyCursor1
				DEALLOCATE @MyCursor1
				end


			end
		else
			begin
		DECLARE @SRdenominator decimal(18,2)
		DECLARE @SampleRatio decimal(18,2)
		declare @projectid int		
		declare @exclusioncount int
		declare @totalrespondant int
		DECLARE @LOI int
		DECLARE @Group int
		DECLARE @Reward int
		DECLARE @QuerySampleRatio varchar(500)

		set @projectid = (select projectid from project where projectid = (select projectid from querymaster where queryid = @QueryId))
		set @exclusioncount = (select ISNULL(exclusioncount,0) from querymaster where queryid = @QueryId)
		set @totalrespondant = (select ISNULL(totalrespondent,0) from querymaster where queryid = @QueryId)
		SELECT @Group = GroupId FROM SpecialityGroup WHERE SpecialityOptionId = (select speciality from querymaster where queryid = @QueryId)

		select @LOI=LOI FROM Project WHERE ProjectId=@projectid
		if(@NewN is null)
			begin
				set @NewN = (select ISNULL(ReqN,0) from querymaster where queryid = @QueryId)
			end
		if(@NewIncidence is null)
			begin				
				SELECT @NewIncidence = Incidence,@LOI=LOI FROM Project WHERE ProjectId=@projectid
			end
		if(@NewHonorium is null)
			begin
				set @NewHonorium = (select isnull(rewardlevel,'RewardA') from querymaster where queryid = @QueryId)
			end
		


		SET @SRdenominator = ((CONVERT(DECIMAL(18,2),@NewN)+CONVERT(DECIMAL(18,2),@exclusioncount))*(CONVERT(DECIMAL(18,2),@NewIncidence)/100))
		SET @SampleRatio = @totalrespondant / @SRdenominator
		IF @SampleRatio  < 1 
			BEGIN
				SET @SampleRatio = 1
			END				

		
		SELECT @Reward = 
		case 
		when LOWER(@NewHonorium) = 'a' or @NewHonorium = 'RewardA' THEN RewardA
		when LOWER(@NewHonorium) = 'b' or @NewHonorium = 'RewardB' THEN RewardB
		when LOWER(@NewHonorium) = 'c' or @NewHonorium = 'RewardC' THEN RewardC
		when LOWER(@NewHonorium) = 'd' or @NewHonorium = 'RewardD' THEN RewardD		
		END
		,@QuerySampleRatio = SampleRatio
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



				update project set incidence = @NewIncidence where projectid = @projectid
				update querymaster set sampleratio = @QuerySampleRatio,reward = @Reward,rewardlevel = case 
																										WHEN LOWER(@NewHonorium) = 'a' THEN 'RewardA' 
																										WHEN LOWER(@NewHonorium) = 'b' THEN 'RewardB'
																										WHEN LOWER(@NewHonorium) = 'c' THEN 'RewardC'
																										WHEN LOWER(@NewHonorium) = 'd' THEN 'RewardD'
																										end,ReqN = @NewN where queryid = @QueryId



				-- updating the maxremainder count by honorium is updated	
				if(@NewHonorium is not null)	
				begin		
				DECLARE @querysamplemappingid int
				--------------------------------------------------------
				DECLARE @MyCursor CURSOR
				SET @MyCursor = CURSOR FAST_FORWARD
				FOR
				SELECT id FROM  querysamplemapping where queryid = @QueryId
				OPEN @MyCursor
				FETCH NEXT FROM @MyCursor
				INTO @querysamplemappingid
				WHILE @@FETCH_STATUS = 0
				BEGIN
					
				if((select maxremainder from querysamplemapping where id = @querysamplemappingid) =  (select remaindercount from querysamplemapping where id = @querysamplemappingid))
					begin
						update querysamplemapping set maxremainder = maxremainder + 1 where id = @querysamplemappingid
					end
				 
				FETCH NEXT FROM @MyCursor
				INTO @querysamplemappingid
				END
				CLOSE @MyCursor
				DEALLOCATE @MyCursor
				end

	end	

	end
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateRewardStatusOnSucccess]    Script Date: 09/08/2016 14:06:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[UpdateRewardStatusOnSucccess]
@successRepondentList nvarchar(2000),
@failureRespondentList nvarchar(2000)

AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;	

update respondentlist set rewardsentstatus = 1 , RewardSentDate = GETDATE() where RespondentListId in (SELECT Data FROM Split(@successRepondentList,','))

END
GO
/****** Object:  StoredProcedure [dbo].[UpdateSurveyStatus]    Script Date: 09/08/2016 14:06:46 ******/
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


		-- updating reward and reward level in reposndantlist table
		declare @queryid nvarchar(20)
        set @queryid = (select qm.queryid from querymaster qm inner join querysamplemapping qsm on qm.queryid = qsm.queryid inner join respondentlist rl on rl.fk_querysamplemappingid = qsm.id where rl.uniqueid = @UniqueId)
			if(@queryid is not null)
				begin
				    update respondentlist set reward = (select reward from querymaster where queryid = @queryid),rewardlevel = (select rewardlevel from querymaster where queryid = @queryid) where UniqueId = @UniqueId
				end
	END

	



	
	SELECT @RespondantListId = RespondentListId FROM RespondentList where UniqueId = @UniqueId
	
	UPDATE SurveyLog SET RespondentListId = @RespondantListId WHERE SurveyLogId = @SurveyLogId

	--new requirement
	update PanelistMaster set SurveyCompletionCount = (isnull(SurveyCompletionCount,0) + 1) where Identifier = (select RespondentId from RespondentList where UniqueId = @UniqueId)
	
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
USE [master]
GO
ALTER DATABASE [SCHUniversalAPITest] SET  READ_WRITE 
GO
