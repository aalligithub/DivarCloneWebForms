USE [master]
GO
/****** Object:  Database [DivarCloneV2]    Script Date: 1/21/2025 2:49:20 AM ******/
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
/****** Object:  Schema [Authorize]    Script Date: 1/21/2025 2:49:20 AM ******/
CREATE SCHEMA [Authorize]
GO
/****** Object:  Schema [Enrollement]    Script Date: 1/21/2025 2:49:20 AM ******/
CREATE SCHEMA [Enrollement]
GO
/****** Object:  Schema [Listing]    Script Date: 1/21/2025 2:49:20 AM ******/
CREATE SCHEMA [Listing]
GO
/****** Object:  Table [Enrollement].[Enrollment]    Script Date: 1/21/2025 2:49:20 AM ******/
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
/****** Object:  View [Enrollement].[vw_UserDetails]    Script Date: 1/21/2025 2:49:20 AM ******/
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
/****** Object:  Table [Listing].[Listings]    Script Date: 1/21/2025 2:49:20 AM ******/
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
/****** Object:  View [Listing].[vw_Listing]    Script Date: 1/21/2025 2:49:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Listing].[vw_Listing]
AS
SELECT        Id, Name, Description, Price, Poster, Category, IsSecret, DateTimeOfPosting
FROM            Listing.Listings
GO
/****** Object:  Table [Listing].[Images]    Script Date: 1/21/2025 2:49:20 AM ******/
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
/****** Object:  View [Listing].[vw_ListingImages]    Script Date: 1/21/2025 2:49:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Listing].[vw_ListingImages]
AS
SELECT        ImageId, ListingId, ImagePath, ImageHash
FROM            Listing.Images
GO
/****** Object:  View [Listing].[vw_ListingsWithImages]    Script Date: 1/21/2025 2:49:20 AM ******/
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
/****** Object:  Table [Authorize].[Permissions]    Script Date: 1/21/2025 2:49:20 AM ******/
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
/****** Object:  Table [Authorize].[RolePermissions]    Script Date: 1/21/2025 2:49:20 AM ******/
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
/****** Object:  Table [Authorize].[Roles]    Script Date: 1/21/2025 2:49:20 AM ******/
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
/****** Object:  Table [Authorize].[SpecialPermissions]    Script Date: 1/21/2025 2:49:20 AM ******/
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
/****** Object:  Table [Authorize].[UserRoles]    Script Date: 1/21/2025 2:49:20 AM ******/
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
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 1/21/2025 2:49:20 AM ******/
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
/****** Object:  Table [dbo].[AspNetRoleClaims]    Script Date: 1/21/2025 2:49:20 AM ******/
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
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 1/21/2025 2:49:20 AM ******/
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
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 1/21/2025 2:49:20 AM ******/
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
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 1/21/2025 2:49:20 AM ******/
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
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 1/21/2025 2:49:20 AM ******/
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
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 1/21/2025 2:49:20 AM ******/
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
/****** Object:  Table [dbo].[AspNetUserTokens]    Script Date: 1/21/2025 2:49:20 AM ******/
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
/****** Object:  Table [dbo].[OperationLogs]    Script Date: 1/21/2025 2:49:20 AM ******/
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
/****** Object:  Index [IX_AspNetRoleClaims_RoleId]    Script Date: 1/21/2025 2:49:20 AM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetRoleClaims_RoleId] ON [dbo].[AspNetRoleClaims]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [RoleNameIndex]    Script Date: 1/21/2025 2:49:20 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex] ON [dbo].[AspNetRoles]
(
	[NormalizedName] ASC
)
WHERE ([NormalizedName] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserClaims_UserId]    Script Date: 1/21/2025 2:49:20 AM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserClaims_UserId] ON [dbo].[AspNetUserClaims]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserLogins_UserId]    Script Date: 1/21/2025 2:49:20 AM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserLogins_UserId] ON [dbo].[AspNetUserLogins]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserRoles_RoleId]    Script Date: 1/21/2025 2:49:20 AM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserRoles_RoleId] ON [dbo].[AspNetUserRoles]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [EmailIndex]    Script Date: 1/21/2025 2:49:20 AM ******/
CREATE NONCLUSTERED INDEX [EmailIndex] ON [dbo].[AspNetUsers]
(
	[NormalizedEmail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UserNameIndex]    Script Date: 1/21/2025 2:49:20 AM ******/
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
ALTER TABLE [Listing].[Images]  WITH CHECK ADD  CONSTRAINT [FK_Images_Listing] FOREIGN KEY([ListingId])
REFERENCES [Listing].[Listings] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Listing].[Images] CHECK CONSTRAINT [FK_Images_Listing]
GO
/****** Object:  StoredProcedure [Authorize].[SP_ChangeUserRole]    Script Date: 1/21/2025 2:49:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Authorize].[SP_ChangeUserRole] 
@UserId int,
@RoleName nvarchar(50)
AS
BEGIN

	SET NOCOUNT ON;

	 IF EXISTS (SELECT 1 FROM UserRoles WHERE UserId = @UserId)
    BEGIN
        -- If the user exists, update the role
		-- Declare a variable to store RoleId
		DECLARE @RoleId INT;

		-- Get the RoleId based on RoleName and assign it to the variable
		SELECT @RoleId = RoleId FROM [Authorize].[Roles] WHERE RoleName = @RoleName;

        UPDATE UserRoles
        SET RoleId = @RoleId
        WHERE UserId = @UserId;
    END
    ELSE
    BEGIN
		RAISERROR('No User with Id Exists', 16, 1, @UserId);
    END
	
END
GO
/****** Object:  StoredProcedure [Authorize].[SP_GetRolesAndPermissions]    Script Date: 1/21/2025 2:49:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Authorize].[SP_GetRolesAndPermissions]
    @RoleName NVARCHAR(50) = NULL,
    @PermissionName NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        r.RoleId,
        r.RoleName,
        STRING_AGG(p.PermissionName, ', ') AS Permissions
    FROM 
        [Authorize].Roles r
    LEFT JOIN 
        [Authorize].RolePermissions rp ON r.RoleId = rp.RoleId
    LEFT JOIN 
        [Authorize].Permissions p ON rp.PermissionId = p.PermissionId
    WHERE 
        (@RoleName IS NULL OR r.RoleName = @RoleName) AND
        (@PermissionName IS NULL OR p.PermissionName = @PermissionName)
    GROUP BY 
        r.RoleId, r.RoleName
    ORDER BY 
        r.RoleName;
END
GO
/****** Object:  StoredProcedure [Authorize].[SP_GiveUserRole]    Script Date: 1/21/2025 2:49:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Authorize].[SP_GiveUserRole]
@UserId int,
@RoleName nvarchar(50)

AS
BEGIN
--check if role exists
IF EXISTS (SELECT 1 FROM [Authorize].[Roles] WHERE RoleName = @RoleName) 
	BEGIN

	--check if user exists
		IF EXISTS (SELECT 1 FROM [Enrollement].[Enrollment] WHERE Id = @UserId)
		BEGIN

			--check if user has a role
			IF EXISTS (SELECT 1 FROM [Authorize].[UserRoles] WHERE UserId = @UserId)
				BEGIN
					RAISERROR('User already has a Role', 16, 1, @UserId);
				END
			ELSE
				BEGIN
				    -- Declare a variable to store RoleId
					DECLARE @RoleId INT;

					-- Get the RoleId based on RoleName and assign it to the variable
					SELECT @RoleId = RoleId FROM [Authorize].[Roles] WHERE RoleName = @RoleName;

				    INSERT INTO [Authorize].[UserRoles] (UserId, RoleId) 
					VALUES (@UserId, @RoleId);
				END
			END
		ELSE
		BEGIN
			RAISERROR('Invalid UserId', 16, 1, @UserId);
		END
	END
ELSE
	BEGIN
		RAISERROR('Invalid RoleName', 16, 1, @RoleName);
	END
END
GO
/****** Object:  StoredProcedure [Authorize].[SP_GiveUserSpecialPermission]    Script Date: 1/21/2025 2:49:20 AM ******/
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
@PermissionName nvarchar(50)
AS
BEGIN
	-- Declare a variable to store RoleId
	DECLARE @PermissionId int;

	-- Get the RoleId based on RoleName and assign it to the variable
	SELECT @PermissionId = PermissionId FROM [Authorize].[Permissions] WHERE PermissionName = @PermissionName;

	IF 
	EXISTS (SELECT * FROM SpecialPermissions WHERE UserId = @UserId AND PermissionId = @PermissionId) OR

	EXISTS (SELECT * FROM
        [Enrollement].Enrollment e
    INNER JOIN 
        [Authorize].UserRoles ur ON e.ID = ur.UserId
    INNER JOIN 
        [Authorize].Roles r ON ur.RoleId = r.RoleId
	INNER JOIN
		[Authorize].RolePermissions rp ON r.RoleId = rp.RoleId
	INNER JOIN 
		[Authorize].Permissions p ON rp.PermissionId = p.PermissionId
		
		WHERE UserId = @UserId and p.PermissionId = @PermissionId)

	BEGIN
		RAISERROR('User already has this Permission', 16, 1, @UserId);
	END

	ELSE
	BEGIN
		INSERT INTO SpecialPermissions VALUES (@UserId,@PermissionId)
	END
	
END
GO
/****** Object:  StoredProcedure [Authorize].[SP_RemoveUserSpecialPermission]    Script Date: 1/21/2025 2:49:20 AM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_AddLogToDb]    Script Date: 1/21/2025 2:49:20 AM ******/
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
/****** Object:  StoredProcedure [Enrollement].[SP_AuthenticateUser]    Script Date: 1/21/2025 2:49:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Enrollement].[SP_AuthenticateUser]
(
    @Password varchar(50),
    @Email nvarchar(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    -- CTE for Role Permissions
    WITH RolePermissionsCTE AS (
        SELECT 
            e.ID,
            STRING_AGG(ISNULL(p.PermissionName, ''), ',') AS Permissions
        FROM [Enrollement].[Enrollment] e
        INNER JOIN [Authorize].UserRoles ur ON e.ID = ur.UserId
        INNER JOIN [Authorize].Roles r ON ur.RoleId = r.RoleId
        LEFT JOIN [Authorize].RolePermissions rp ON r.RoleId = rp.RoleId
        LEFT JOIN [Authorize].Permissions p ON rp.PermissionId = p.PermissionId
        GROUP BY e.ID
    ),
    -- CTE for Special Permissions
    SpecialPermissionsCTE AS (
        SELECT 
            e.ID,
            STRING_AGG(ISNULL(sp.PermissionName, ''), ',') AS SpecialPermissions
        FROM [Enrollement].[Enrollment] e
        LEFT JOIN [Authorize].SpecialPermissions ssp ON ssp.UserId = e.ID
        LEFT JOIN [Authorize].Permissions sp ON ssp.PermissionId = sp.PermissionId
        GROUP BY e.ID
    )
    SELECT 
        e.ID,
        e.FirstName,
        e.Email,
        e.Phone,
        e.Username,
        r.RoleName,
        rp_cte.Permissions,
        sp_cte.SpecialPermissions
    FROM [Enrollement].[Enrollment] e
    INNER JOIN [Authorize].UserRoles ur ON e.ID = ur.UserId
    INNER JOIN [Authorize].Roles r ON ur.RoleId = r.RoleId
    LEFT JOIN RolePermissionsCTE rp_cte ON e.ID = rp_cte.ID
    LEFT JOIN SpecialPermissionsCTE sp_cte ON e.ID = sp_cte.ID
    WHERE
	    e.Email = @Email 
        AND e.Password = @Password
END
GO
/****** Object:  StoredProcedure [Enrollement].[SP_GetAllUsers]    Script Date: 1/21/2025 2:49:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Enrollement].[SP_GetAllUsers]
(
	@UserId INT = NULL,
    @Username NVARCHAR(MAX) = NULL,
    @Email NVARCHAR(MAX) = NULL,
    @PermissionName NVARCHAR(50) = NULL,
    @RoleName NVARCHAR(50) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- CTE for Role Permissions
    WITH RolePermissionsCTE AS (
        SELECT 
            e.ID,
            STRING_AGG(ISNULL(p.PermissionName, ''), ',') AS Permissions
        FROM [Enrollement].[Enrollment] e
        INNER JOIN [Authorize].UserRoles ur ON e.ID = ur.UserId
        INNER JOIN [Authorize].Roles r ON ur.RoleId = r.RoleId
        LEFT JOIN [Authorize].RolePermissions rp ON r.RoleId = rp.RoleId
        LEFT JOIN [Authorize].Permissions p ON rp.PermissionId = p.PermissionId
        GROUP BY e.ID
    ),
    -- CTE for Special Permissions
    SpecialPermissionsCTE AS (
        SELECT 
            e.ID,
            STRING_AGG(ISNULL(sp.PermissionName, ''), ',') AS SpecialPermissions
        FROM [Enrollement].[Enrollment] e
        LEFT JOIN [Authorize].SpecialPermissions ssp ON ssp.UserId = e.ID
        LEFT JOIN [Authorize].Permissions sp ON ssp.PermissionId = sp.PermissionId
        GROUP BY e.ID
    )
    SELECT 
        e.ID,
        e.FirstName,
        e.Email,
        e.Phone,
        e.Username,
        r.RoleName,
        rp_cte.Permissions,
        sp_cte.SpecialPermissions
    FROM [Enrollement].[Enrollment] e
    INNER JOIN [Authorize].UserRoles ur ON e.ID = ur.UserId
    INNER JOIN [Authorize].Roles r ON ur.RoleId = r.RoleId
    LEFT JOIN RolePermissionsCTE rp_cte ON e.ID = rp_cte.ID
    LEFT JOIN SpecialPermissionsCTE sp_cte ON e.ID = sp_cte.ID
    WHERE
		(@UserId IS NULL OR e.ID = @UserId) AND
        (@Username IS NULL OR e.Username LIKE '%' + @Username + '%') AND
        (@Email IS NULL OR e.Email LIKE '%' + @Email + '%') AND
        (@PermissionName IS NULL OR rp_cte.Permissions LIKE '%' + @PermissionName + '%') AND
        (@RoleName IS NULL OR r.RoleName LIKE '%' + @RoleName + '%')
END


GO
/****** Object:  StoredProcedure [Enrollement].[SP_SignUserDetailsUp]    Script Date: 1/21/2025 2:49:20 AM ******/
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
    @Username nvarchar(20)
)
AS
BEGIN
	INSERT INTO Enrollment (FirstName, Password, Email, Phone, Username)
	VALUES (@FirstName, @Password, @Email, @Phone, @Username)
	INSERT INTO [Authorize].[UserRoles] (UserId, RoleId) SELECT SCOPE_IDENTITY(), 3;

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
/****** Object:  StoredProcedure [Listing].[SP_CreateListing]    Script Date: 1/21/2025 2:49:20 AM ******/
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
/****** Object:  StoredProcedure [Listing].[SP_CreateSecretListing]    Script Date: 1/21/2025 2:49:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [Listing].[SP_CreateSecretListing]
    @Name NVARCHAR(100),
    @Description NVARCHAR(MAX),
    @Price INT,
    @Poster NVARCHAR(100),
    @Category INT,
    @DateTimeOfPosting DATETIME
AS

BEGIN

	INSERT INTO Listings(Name, Description, Price, Poster, Category, DateTimeOfPosting, IsSecret)
	VALUES(@Name, @Description, @Price, @Poster, @Category, @DateTimeOfPosting, 1)

	SELECT SCOPE_IDENTITY() AS ListingId

END
GO
/****** Object:  StoredProcedure [Listing].[SP_DeleteListing]    Script Date: 1/21/2025 2:49:20 AM ******/
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
/****** Object:  StoredProcedure [Listing].[SP_DeleteListingImage]    Script Date: 1/21/2025 2:49:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Listing].[SP_DeleteListingImage] 
@ImageId int
AS
BEGIN
	DELETE FROM Images WHERE ImageId = @ImageId
END
GO
/****** Object:  StoredProcedure [Listing].[SP_GetImageFTPpath]    Script Date: 1/21/2025 2:49:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Listing].[SP_GetImageFTPpath]
@ImageId INT

AS
BEGIN
	SELECT ImagePath FROM [Listing].[Images] WHERE ImageId = @ImageId 
END
GO
/****** Object:  StoredProcedure [Listing].[SP_GetListingImages]    Script Date: 1/21/2025 2:49:20 AM ******/
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
/****** Object:  StoredProcedure [Listing].[SP_GetListings]    Script Date: 1/21/2025 2:49:20 AM ******/
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
/****** Object:  StoredProcedure [Listing].[SP_GetListingsWithImages]    Script Date: 1/21/2025 2:49:20 AM ******/
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
    @category_enum INT = NULL,
	@isSecret BIT = 0
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
            l.DateTimeOfPosting,
			l.IsSecret
        FROM Listings l
        WHERE 
			(@Id IS NULL OR Id = @Id) AND
			(@Username IS NULL OR Poster = @Username) AND
			(@TextToSearch IS NULL OR Name LIKE '%' + @TextToSearch + '%') AND
			(@category_enum IS NULL OR Category = @category_enum) AND 
			(isSecret = @isSecret)
    )
    SELECT 
        fl.Id,
        fl.Name,
        fl.Description,
        fl.Price,
        fl.Poster,
        fl.Category,
        fl.DateTimeOfPosting,
		fl.IsSecret,
        STRING_AGG(CAST(i.ImageId AS NVARCHAR(MAX)) + '$' + i.ImagePath, ',') AS ImagePairs
		--STRING_AGG(i.ImagePath, ',') AS ImagePaths
    FROM FilteredListings fl
    LEFT JOIN Images i ON fl.Id = i.ListingId
    GROUP BY 
        fl.Id,
        fl.Name,
        fl.Description,
        fl.Price,
        fl.Poster,
        fl.Category,
        fl.DateTimeOfPosting,
		fl.IsSecret
    ORDER BY fl.DateTimeOfPosting DESC;
END
GO
/****** Object:  StoredProcedure [Listing].[SP_InsertImagePathIntoImages]    Script Date: 1/21/2025 2:49:20 AM ******/
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
/****** Object:  StoredProcedure [Listing].[SP_MakeListingSecret]    Script Date: 1/21/2025 2:49:20 AM ******/
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
/****** Object:  StoredProcedure [Listing].[SP_RemoveDeletedImagePath]    Script Date: 1/21/2025 2:49:20 AM ******/
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
/****** Object:  StoredProcedure [Listing].[SP_UpdateListing]    Script Date: 1/21/2025 2:49:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Listing].[SP_UpdateListing]
@Id INT,
@Name NVARCHAR(MAX) = null,
@Description NVARCHAR(MAX)= null,
@Price INT = null,
@Category INT = null,
@DateTime DATETIME2(7) = null

AS
BEGIN
	UPDATE Listings
	SET Name = IsNull(@Name, Name), Description = IsNull(@Description, Description), Price = IsNull(@Price, Price), Category = IsNull(@Category, Category), DateTimeOfPosting = IsNull(@DateTime, DateTimeOfPosting)
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
