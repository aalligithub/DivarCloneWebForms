USE [master]
GO
/****** Object:  Database [DivarCloneV2]    Script Date: 12/7/2024 1:51:41 AM ******/
CREATE DATABASE [DivarCloneV2]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DivarCloneV2', FILENAME = N'D:\SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\DivarCloneV2.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'DivarCloneV2_log', FILENAME = N'D:\SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\DivarCloneV2_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [DivarCloneV2] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DivarCloneV2].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DivarCloneV2] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DivarCloneV2] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DivarCloneV2] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DivarCloneV2] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DivarCloneV2] SET ARITHABORT OFF 
GO
ALTER DATABASE [DivarCloneV2] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [DivarCloneV2] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DivarCloneV2] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DivarCloneV2] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DivarCloneV2] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [DivarCloneV2] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DivarCloneV2] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DivarCloneV2] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DivarCloneV2] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DivarCloneV2] SET  ENABLE_BROKER 
GO
ALTER DATABASE [DivarCloneV2] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DivarCloneV2] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DivarCloneV2] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DivarCloneV2] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DivarCloneV2] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DivarCloneV2] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [DivarCloneV2] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DivarCloneV2] SET RECOVERY FULL 
GO
ALTER DATABASE [DivarCloneV2] SET  MULTI_USER 
GO
ALTER DATABASE [DivarCloneV2] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [DivarCloneV2] SET DB_CHAINING OFF 
GO
ALTER DATABASE [DivarCloneV2] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [DivarCloneV2] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [DivarCloneV2] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [DivarCloneV2] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'DivarCloneV2', N'ON'
GO
ALTER DATABASE [DivarCloneV2] SET QUERY_STORE = ON
GO
ALTER DATABASE [DivarCloneV2] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [DivarCloneV2]
GO
/****** Object:  Schema [Authorize]    Script Date: 12/7/2024 1:51:41 AM ******/
CREATE SCHEMA [Authorize]
GO
/****** Object:  Schema [Enrollement]    Script Date: 12/7/2024 1:51:41 AM ******/
CREATE SCHEMA [Enrollement]
GO
/****** Object:  Schema [Listing]    Script Date: 12/7/2024 1:51:41 AM ******/
CREATE SCHEMA [Listing]
GO
/****** Object:  Table [Enrollement].[Enrollment]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Enrollement].[Enrollment](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NULL,
	[Password] [nvarchar](30) NULL,
	[Email] [nvarchar](50) NULL,
	[Phone] [varchar](15) NULL,
	[Username] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [Enrollement].[vw_UserDetails]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Enrollement].[vw_UserDetails]
AS
SELECT 
    ID,
    FirstName,
    Password,
    Email,
    Phone,
    Username
FROM Enrollment;
GO
/****** Object:  Table [Listing].[Listings]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Listing].[Listings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[Price] [int] NOT NULL,
	[Poster] [nvarchar](max) NOT NULL,
	[Category] [int] NOT NULL,
	[DateTimeOfPosting] [datetime2](7) NOT NULL,
	[IsSecret] [bit] NOT NULL,
 CONSTRAINT [PK_Listings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [Listing].[vw_Listing]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Listing].[vw_Listing]
AS
SELECT        Id, Name, Description, Price, Poster, Category, IsSecret, DateTimeOfPosting
FROM            Listing.Listings
GO
/****** Object:  Table [Listing].[Images]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Listing].[Images](
	[ImageId] [int] IDENTITY(1,1) NOT NULL,
	[ListingId] [int] NOT NULL,
	[ImagePath] [nvarchar](max) NOT NULL,
	[ImageHash] [nvarchar](64) NOT NULL,
 CONSTRAINT [PK__Images__7516F70C828BF240] PRIMARY KEY CLUSTERED 
(
	[ImageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_ListingImage] UNIQUE NONCLUSTERED 
(
	[ListingId] ASC,
	[ImageHash] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [Listing].[vw_ListingImages]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Listing].[vw_ListingImages]
AS
SELECT        ImageId, ListingId, ImagePath, ImageHash
FROM            Listing.Images
GO
/****** Object:  View [Listing].[vw_ListingsWithImages]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Listing].[vw_ListingsWithImages] AS
SELECT
    l.Id AS ListingId,
    l.Name,
    l.Description,
    l.Price,
    l.Poster,
    l.Category,
    l.DateTimeOfPosting,
    i.ImagePath
FROM
    Listings l
LEFT JOIN
    Images i ON l.Id = i.ListingId;
GO
/****** Object:  Table [Authorize].[Permissions]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Authorize].[Permissions](
	[PermissionId] [int] NOT NULL,
	[PermissionName] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[PermissionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Authorize].[RolePermissions]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Authorize].[RolePermissions](
	[RoleId] [int] NOT NULL,
	[PermissionId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC,
	[PermissionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Authorize].[Roles]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Authorize].[Roles](
	[RoleId] [int] NOT NULL,
	[RoleName] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Authorize].[SpecialPermissions]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Authorize].[SpecialPermissions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[PermissionId] [int] NOT NULL,
 CONSTRAINT [PK__SpecialP__3214EC07813EAC1E] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [uc_user_permission] UNIQUE NONCLUSTERED 
(
	[UserId] ASC,
	[PermissionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Authorize].[UserRoles]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Authorize].[UserRoles](
	[UserId] [int] NOT NULL,
	[RoleId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [uc_user_role] UNIQUE NONCLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetRoleClaims]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoleClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [nvarchar](450) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoles](
	[Id] [nvarchar](450) NOT NULL,
	[Name] [nvarchar](256) NULL,
	[NormalizedName] [nvarchar](256) NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](450) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](128) NOT NULL,
	[ProviderKey] [nvarchar](128) NOT NULL,
	[ProviderDisplayName] [nvarchar](max) NULL,
	[UserId] [nvarchar](450) NOT NULL,
 CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [nvarchar](450) NOT NULL,
	[RoleId] [nvarchar](450) NOT NULL,
 CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsers](
	[Id] [nvarchar](450) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[UserName] [nvarchar](256) NULL,
	[NormalizedUserName] [nvarchar](256) NULL,
	[Email] [nvarchar](256) NULL,
	[NormalizedEmail] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEnd] [datetimeoffset](7) NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
 CONSTRAINT [PK_AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserTokens]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserTokens](
	[UserId] [nvarchar](450) NOT NULL,
	[LoginProvider] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[LoginProvider] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OperationLogs]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OperationLogs](
	[LogId] [int] IDENTITY(1,1) NOT NULL,
	[Operation] [nvarchar](100) NULL,
	[Details] [nvarchar](max) NULL,
	[LogDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[LogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetRoleClaims_RoleId]    Script Date: 12/7/2024 1:51:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetRoleClaims_RoleId] ON [dbo].[AspNetRoleClaims]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [RoleNameIndex]    Script Date: 12/7/2024 1:51:41 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex] ON [dbo].[AspNetRoles]
(
	[NormalizedName] ASC
)
WHERE ([NormalizedName] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserClaims_UserId]    Script Date: 12/7/2024 1:51:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserClaims_UserId] ON [dbo].[AspNetUserClaims]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserLogins_UserId]    Script Date: 12/7/2024 1:51:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserLogins_UserId] ON [dbo].[AspNetUserLogins]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserRoles_RoleId]    Script Date: 12/7/2024 1:51:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserRoles_RoleId] ON [dbo].[AspNetUserRoles]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [EmailIndex]    Script Date: 12/7/2024 1:51:41 AM ******/
CREATE NONCLUSTERED INDEX [EmailIndex] ON [dbo].[AspNetUsers]
(
	[NormalizedEmail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UserNameIndex]    Script Date: 12/7/2024 1:51:41 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex] ON [dbo].[AspNetUsers]
(
	[NormalizedUserName] ASC
)
WHERE ([NormalizedUserName] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OperationLogs] ADD  DEFAULT (getdate()) FOR [LogDate]
GO
ALTER TABLE [Listing].[Listings] ADD  CONSTRAINT [DF_Listings_IsSecret]  DEFAULT ((0)) FOR [IsSecret]
GO
ALTER TABLE [Authorize].[RolePermissions]  WITH CHECK ADD FOREIGN KEY([PermissionId])
REFERENCES [Authorize].[Permissions] ([PermissionId])
GO
ALTER TABLE [Authorize].[RolePermissions]  WITH CHECK ADD FOREIGN KEY([RoleId])
REFERENCES [Authorize].[Roles] ([RoleId])
GO
ALTER TABLE [Authorize].[SpecialPermissions]  WITH CHECK ADD  CONSTRAINT [FK__SpecialPe__Permi__0C50D423] FOREIGN KEY([PermissionId])
REFERENCES [Authorize].[Permissions] ([PermissionId])
GO
ALTER TABLE [Authorize].[SpecialPermissions] CHECK CONSTRAINT [FK__SpecialPe__Permi__0C50D423]
GO
ALTER TABLE [Authorize].[UserRoles]  WITH CHECK ADD FOREIGN KEY([RoleId])
REFERENCES [Authorize].[Roles] ([RoleId])
GO
ALTER TABLE [Authorize].[UserRoles]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [Enrollement].[Enrollment] ([ID])
GO
ALTER TABLE [dbo].[AspNetRoleClaims]  WITH CHECK ADD  CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetRoleClaims] CHECK CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserLogins]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserLogins] CHECK CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserTokens]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserTokens] CHECK CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId]
GO
ALTER TABLE [Listing].[Images]  WITH CHECK ADD  CONSTRAINT [FK__Images__ListingI__2EA5EC27] FOREIGN KEY([ListingId])
REFERENCES [Listing].[Listings] ([Id])
GO
ALTER TABLE [Listing].[Images] CHECK CONSTRAINT [FK__Images__ListingI__2EA5EC27]
GO
/****** Object:  StoredProcedure [Authorize].[SP_ChangeUserRole]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Authorize].[SP_ChangeUserRole] 
@UserId int,
@Role int
AS
BEGIN

	SET NOCOUNT ON;

	 IF EXISTS (SELECT 1 FROM UserRoles WHERE UserId = @UserId)
    BEGIN
        -- If the user exists, update the role
        UPDATE UserRoles
        SET RoleId = @Role
        WHERE UserId = @UserId;
    END
    ELSE
    BEGIN
        -- If the user doesn't exist, insert the user and the new role
        INSERT INTO UserRoles (UserId, RoleId)
        VALUES (@UserId, @Role);
    END
	
END
GO
/****** Object:  StoredProcedure [Authorize].[SP_GetAllPossiblePermissions]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Authorize].[SP_GetAllPossiblePermissions]

AS
BEGIN
	SET NOCOUNT ON;

	SELECT PermissionId, PermissionName FROM Permissions
END
GO
/****** Object:  StoredProcedure [Authorize].[SP_GetAllPossibleRoles]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Authorize].[SP_GetAllPossibleRoles]

AS
BEGIN
	SET NOCOUNT ON;

	SELECT RoleId, RoleName FROM Roles
END
GO
/****** Object:  StoredProcedure [Authorize].[SP_GetRoleFromUserRoles]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Authorize].[SP_GetRoleFromUserRoles]
@UserId NVARCHAR(50)

AS
BEGIN
    SELECT Roles.RoleName 
    FROM UserRoles 
    INNER JOIN Roles ON UserRoles.RoleId = Roles.RoleId 
    WHERE UserRoles.UserId = @UserId
END
GO
/****** Object:  StoredProcedure [Authorize].[SP_GetSpecialUserPermissions]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Authorize].[SP_GetSpecialUserPermissions] 
	@UserId INT
AS
BEGIN

	SET NOCOUNT ON;

	-- Remove duplicates if the user already has permission through roles
    DELETE FROM SpecialPermissions
    WHERE UserId = @UserId
    AND PermissionId IN (
        SELECT PermissionId 
        FROM RolePermissions
        INNER JOIN UserRoles ON RolePermissions.RoleId = UserRoles.RoleId
        WHERE UserRoles.UserId = @UserId
);

	-- Now, return the remaining special permissions
	SELECT Permissions.PermissionName 
	FROM SpecialPermissions
	INNER JOIN Permissions ON SpecialPermissions.PermissionId = Permissions.PermissionId
	WHERE SpecialPermissions.UserId = @UserId;
END
GO
/****** Object:  StoredProcedure [Authorize].[SP_GetUserPermissions]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Authorize].[SP_GetUserPermissions] 
@UserId int
AS
BEGIN
SELECT 
    --e.ID, 
    --e.Username, 
    --e.Email, 
    --r.RoleName, 
    p.PermissionName
FROM 
    Enrollment e
INNER JOIN 
    UserRoles ur ON e.ID = ur.UserId
INNER JOIN 
    Roles r ON ur.RoleId = r.RoleId
INNER JOIN 
    RolePermissions rp ON r.RoleId = rp.RoleId
INNER JOIN 
    Permissions p ON rp.PermissionId = p.PermissionId
WHERE 
    e.ID = @UserId;
END
GO
/****** Object:  StoredProcedure [Authorize].[SP_GiveUserSpecialPermission]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Authorize].[SP_GiveUserSpecialPermission]
@UserId int,
@PermissionId int
AS
BEGIN

	SET NOCOUNT ON;

	INSERT INTO SpecialPermissions VALUES (@UserId,@PermissionId)
END
GO
/****** Object:  StoredProcedure [Authorize].[SP_RemoveUserSpecialPermission]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Authorize].[SP_RemoveUserSpecialPermission] 
    @UserId INT,
    @PermissionName NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @PermissionId INT;

    -- Retrieve PermissionId based on PermissionName
    SELECT TOP 1 @PermissionId = PermissionId 
    FROM Permissions 
    WHERE PermissionName = @PermissionName;

    -- If PermissionId is found, delete from SpecialPermissions
    IF @PermissionId IS NOT NULL
    BEGIN
        DELETE FROM SpecialPermissions 
        WHERE UserId = @UserId AND PermissionId = @PermissionId;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_AddLogToDb]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_AddLogToDb]
@Operation NVARCHAR(100),
@Details NVARCHAR(MAX),
@LogDate DATETIME
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO OperationLogs VALUES (@Operation, @Details, @LogDate)
END
GO
/****** Object:  StoredProcedure [Enrollement].[SP_GetAllUsers]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Enrollement].[SP_GetAllUsers]
(
    @Username NVARCHAR(MAX) = NULL,
    @Email NVARCHAR(MAX) = NULL
)
AS
BEGIN
    SELECT * 
    FROM [Enrollement].[vw_UserDetails]
    WHERE 
        (@Username IS NULL OR Username = @Username) AND
        (@Email IS NULL OR Email LIKE '%' + @Email + '%');
END
GO
/****** Object:  StoredProcedure [Enrollement].[SP_LogUserIn]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Enrollement].[SP_LogUserIn]
(
    @Password varchar(50),
    @Email nvarchar(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        e.ID,
        e.Username,
        e.Email,
        r.RoleName
    FROM 
        Enrollment e
    INNER JOIN 
        UserRoles ur ON e.ID = ur.UserId
    INNER JOIN 
        Roles r ON ur.RoleId = r.RoleId
    WHERE 
        e.Email = @Email 
        AND e.Password = @Password;


    IF @@ROWCOUNT = 0
    BEGIN

        RAISERROR ('Invalid credentials', 16, 1);
        RETURN;
    END
END
GO
/****** Object:  StoredProcedure [Enrollement].[SP_SignUserDetailsUp]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Enrollement].[SP_SignUserDetailsUp]
(
    @FirstName varchar(50),
    @Password varchar(50),
    @Email nvarchar(50),
    @Phone varchar(15),
    @Username nvarchar(20),
    @status varchar(15)
)
AS
BEGIN
	IF @status = 'Insert'
		BEGIN
			INSERT INTO Enrollment (FirstName, Password, Email, Phone, Username)
			VALUES (@FirstName, @Password, @Email, @Phone, @Username)
			INSERT INTO [dbo].[UserRoles] (UserId, RoleId) SELECT SCOPE_IDENTITY(), 3;
		END

	--ELSE IF @status = 'Update'
	--	BEGIN
	--		PRINT 'UPDATE CODE HERE'
	--	END
	--ELSE
	--	BEGIN
	--		 Handle an unknown or unsupported status
	--		PRINT 'Invalid status provided. Supported statuses are Insert and Update.'
	--	END
END
GO
/****** Object:  StoredProcedure [Listing].[SP_CreateListing]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Listing].[SP_CreateListing]
    @Name NVARCHAR(100),
    @Description NVARCHAR(MAX),
    @Price INT,
    @Poster NVARCHAR(100),
    @Category INT,
    @DateTimeOfPosting DATETIME
AS

BEGIN

	INSERT INTO Listings(Name, Description, Price, Poster, Category, DateTimeOfPosting)
	VALUES(@Name, @Description, @Price, @Poster, @Category, @DateTimeOfPosting)

	SELECT SCOPE_IDENTITY() AS ListingId

END
GO
/****** Object:  StoredProcedure [Listing].[SP_DeleteListing]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Listing].[SP_DeleteListing]  
@Id INT
AS
BEGIN
    BEGIN TRY
        -- Log start of the operation
        INSERT INTO OperationLogs (Operation, Details) 
        VALUES ('DeleteUserListing', 'Attempting to delete listing with Id = ' + CAST(@Id AS NVARCHAR(10)));

        -- Perform the deletion
		DELETE FROM Images WHERE ListingId = @Id;
        DELETE FROM Listings WHERE Listings.Id = @Id;

        -- Log successful deletion
        INSERT INTO OperationLogs (Operation, Details) 
        VALUES ('DeleteUserListing', 'Successfully deleted listing with Id = ' + CAST(@Id AS NVARCHAR(10)));
    END TRY
    BEGIN CATCH
        -- Log the error if deletion fails
        DECLARE @ErrorMessage NVARCHAR(MAX) = ERROR_MESSAGE();
        INSERT INTO OperationLogs (Operation, Details) 
        VALUES ('DeleteUserListing', 'Error deleting listing with Id = ' + CAST(@Id AS NVARCHAR(10)) + ': ' + @ErrorMessage);
    END CATCH
END

GO
/****** Object:  StoredProcedure [Listing].[SP_GetAllSecretListingsWithImages]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Listing].[SP_GetAllSecretListingsWithImages] 
@UserId int

AS
BEGIN
    IF EXISTS (SELECT 1 FROM UserRoles WHERE UserId = @UserId AND RoleId = 1)
    BEGIN
		SELECT * FROM [DivarCloneV2].[dbo].[vw_ListingWithImages]
    END
    ELSE
    BEGIN
        -- If the user is not authorized, return an error or empty result set
        RAISERROR('Unauthorized access.', 16, 1);
    END
END
GO
/****** Object:  StoredProcedure [Listing].[SP_GetListingImages]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Listing].[SP_GetListingImages] 
@listingId int = NULL

AS
BEGIN
	SELECT * FROM [DivarCloneV2].[Listing].[vw_ListingImages]
	WHERE 
		(@listingId IS NULL OR ListingId = @listingId)
END
GO
/****** Object:  StoredProcedure [Listing].[SP_GetListings]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Listing].[SP_GetListings]
    @Id INT = NULL,
    @Username NVARCHAR(100) = NULL,
	@TextToSearch NVARCHAR(MAX) = NULL,
    @category_enum INT = NULL
AS
BEGIN
    SELECT * FROM [DivarCloneV2].[Listing].[vw_Listing]
	    WHERE 
        (@Id IS NULL OR Id = @Id) AND
        (@Username IS NULL OR Poster = @Username) AND
		(@TextToSearch IS NULL OR Name LIKE '%' + @TextToSearch + '%') AND
        (@category_enum IS NULL OR Category = @category_enum)
END

GO
/****** Object:  StoredProcedure [Listing].[SP_GetListingsWithImages]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Description:	<Joins the two tables and allows for filtering, seraching and etc before they are joined>
-- =============================================
CREATE PROCEDURE [Listing].[SP_GetListingsWithImages] 
    @Id INT = NULL,
    @Username NVARCHAR(100) = NULL,
	@TextToSearch NVARCHAR(MAX) = NULL,
    @category_enum INT = NULL
AS
BEGIN
	SET NOCOUNT ON;

    -- Pre-filter the Listings table
    WITH FilteredListings AS (
        SELECT 
            l.Id,
            l.Name,
            l.Description,
            l.Price,
            l.Poster,
            l.Category,
            l.DateTimeOfPosting
        FROM Listings l
        WHERE 
			(@Id IS NULL OR Id = @Id) AND
			(@Username IS NULL OR Poster = @Username) AND
			(@TextToSearch IS NULL OR Name LIKE '%' + @TextToSearch + '%') AND
			(@category_enum IS NULL OR Category = @category_enum)
    )
    SELECT 
        fl.Id,
        fl.Name,
        fl.Description,
        fl.Price,
        fl.Poster,
        fl.Category,
        fl.DateTimeOfPosting,
        STRING_AGG(i.ImagePath, ',') AS ImagePaths
    FROM FilteredListings fl
    LEFT JOIN Images i ON fl.Id = i.ListingId
    GROUP BY 
        fl.Id,
        fl.Name,
        fl.Description,
        fl.Price,
        fl.Poster,
        fl.Category,
        fl.DateTimeOfPosting
    ORDER BY fl.DateTimeOfPosting DESC;
END
GO
/****** Object:  StoredProcedure [Listing].[SP_InsertImagePathIntoImages]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
CREATE PROCEDURE [Listing].[SP_InsertImagePathIntoImages] 
@ListingId int,
@ImageHash nvarchar(64),
@ImagePath nvarchar(MAX)

AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO Images (ListingId, ImagePath, ImageHash) VALUES (@ListingId, @ImagePath, @ImageHash)
END

GO
/****** Object:  StoredProcedure [Listing].[SP_MakeListingSecret]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Listing].[SP_MakeListingSecret] 
	@listingId int
AS
BEGIN
	UPDATE Listings SET IsSecret = 1 WHERE Id = @listingId
END
GO
/****** Object:  StoredProcedure [Listing].[SP_RemoveDeletedImagePath]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Listing].[SP_RemoveDeletedImagePath] 
@ImagePath nvarchar(max)
AS
BEGIN
	DELETE FROM Images WHERE ImagePath Like @ImagePath
END
GO
/****** Object:  StoredProcedure [Listing].[SP_UpdateListing]    Script Date: 12/7/2024 1:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Listing].[SP_UpdateListing]
@Id INT,
@Name NVARCHAR(MAX),
@Description NVARCHAR(MAX),
@Price INT,
@Poster NVARCHAR(MAX),
@Category INT,
@DateTime DATETIME2(7)

AS
BEGIN
	UPDATE Listings
	SET Name = @Name, Description = @Description, Price = @Price, Poster = @Poster, Category = @Category, DateTimeOfPosting = @DateTime
	WHERE Id = @Id;

	INSERT INTO OperationLogs VALUES ('UPDATE LISTING SUCCESS','listing updated from sp', @DateTime);
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Listings (Listing)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 230
            End
            DisplayFlags = 280
            TopColumn = 4
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'Listing', @level1type=N'VIEW',@level1name=N'vw_Listing'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'Listing', @level1type=N'VIEW',@level1name=N'vw_Listing'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -96
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Images (Listing)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'Listing', @level1type=N'VIEW',@level1name=N'vw_ListingImages'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'Listing', @level1type=N'VIEW',@level1name=N'vw_ListingImages'
GO
USE [master]
GO
ALTER DATABASE [DivarCloneV2] SET  READ_WRITE 
GO
