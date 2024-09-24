-- Create Table: Countries
create database DVLD;

use DVLD;

CREATE TABLE Countries (
    CountryID int PRIMARY KEY,
    CountryName nvarchar(50)
);


-- Create Table: People
CREATE TABLE People (
    PersonID int PRIMARY KEY,
    NationalNo nvarchar(20) NOT NULL,
    FirstName nvarchar(20) NOT NULL,
    SecondName nvarchar(20),
    ThirdName nvarchar(20),
    LastName nvarchar(20) NOT NULL,
    DateOfBirth datetime,
    Gender tinyint,
    Address nvarchar(500),
    Phone nvarchar(20),
    Email nvarchar(50),
    NationalityCountryID int,
    ImagePath nvarchar(250),
    FOREIGN KEY (NationalityCountryID) REFERENCES Countries(CountryID));

-- Create Table: Users
CREATE TABLE Users (
    UserID int PRIMARY KEY,
    PersonID int NOT NULL,
    UserName nvarchar(20) NOT NULL,
    Password nvarchar(20) NOT NULL,
    IsActive bit,
    FOREIGN KEY (PersonID) REFERENCES People(PersonID)
);

-- Create Table: Applications
CREATE TABLE Applications (
    ApplicationID int PRIMARY KEY,
    ApplicantPersonID int NOT NULL,
    ApplicationDate datetime NOT NULL,
    ApplicationTypeID int,
    ApplicationStatus tinyint,
    LastStatusDate datetime,
    PaidFees smallmoney,
    CreatedByUserID int,
    FOREIGN KEY (ApplicantPersonID) REFERENCES People(PersonID),
    FOREIGN KEY (ApplicationTypeID) REFERENCES ApplicationTypes(ApplicationTypeID),
    FOREIGN KEY (CreatedByUserID) REFERENCES Users(UserID)
);

-- Create Table: ApplicationTypes
CREATE TABLE ApplicationTypes (
    ApplicationTypeID int PRIMARY KEY,
    ApplicationTypeTitle nvarchar(150),
    ApplicationFees smallmoney
);

-- Create Table: Drivers
CREATE TABLE Drivers (
    DriverID int PRIMARY KEY,
    PersonID int NOT NULL,
    CreatedByUserID int,
    CreatedDate smalldatetime,
    FOREIGN KEY (PersonID) REFERENCES People(PersonID),
    FOREIGN KEY (CreatedByUserID) REFERENCES Users(UserID)
);

-- Create Table: Licenses
CREATE TABLE Licenses (
    LicenseID int PRIMARY KEY,
    ApplicationID int,
    DriverID int,
    LicenseClassID int,
    IssueDate datetime,
    ExpirationDate datetime,
    Notes nvarchar(500),
    PaidFees smallmoney,
    IsActive bit,
    IssueReason tinyint,
    CreatedByUserID int,
    FOREIGN KEY (ApplicationID) REFERENCES Applications(ApplicationID),
    FOREIGN KEY (DriverID) REFERENCES Drivers(DriverID),
    FOREIGN KEY (LicenseClassID) REFERENCES LicenseClasses(LicenseClassID),
    FOREIGN KEY (CreatedByUserID) REFERENCES Users(UserID)
);

-- Create Table: LicenseClasses
CREATE TABLE LicenseClasses (
    LicenseClassID int PRIMARY KEY,
    ClassName nvarchar(50),
    ClassDescription nvarchar(500),
    MinimumAllowedAge tinyint,
    DefaultValidityLength tinyint,
    ClassFees smallmoney
);

-- Create Table: DetainedLicenses
CREATE TABLE DetainedLicenses (
    DetainID int PRIMARY KEY,
    LicenseID int,
    DetainDate smalldatetime,
    FineFees smallmoney,
    CreatedByUserID int,
    IsReleased bit,
    ReleaseDate smalldatetime,
    ReleasedByUserID int,
    ReleaseApplicationID int,
    FOREIGN KEY (LicenseID) REFERENCES Licenses(LicenseID),
    FOREIGN KEY (CreatedByUserID) REFERENCES Users(UserID),
    FOREIGN KEY (ReleasedByUserID) REFERENCES Users(UserID),
    FOREIGN KEY (ReleaseApplicationID) REFERENCES Applications(ApplicationID)
);

-- Create Table: Tests
CREATE TABLE Tests (
    TestID int PRIMARY KEY,
    TestAppointmentID int,
    TestResult bit,
    Notes nvarchar(500),
    CreatedByUserID int,
    FOREIGN KEY (TestAppointmentID) REFERENCES TestAppointments(TestAppointmentID),
    FOREIGN KEY (CreatedByUserID) REFERENCES Users(UserID)
);

-- Create Table: TestAppointments
CREATE TABLE TestAppointments (
    TestAppointmentID int PRIMARY KEY,
    LocalDrivingLicenseApplicationID int,
    AppointmentDate smalldatetime,
    PaidFees smallmoney,
    CreatedByUserID int,
    IsLocked bit,
    RetakeTestApplicationID int,
    FOREIGN KEY (LocalDrivingLicenseApplicationID) REFERENCES LocalDrivingLicenseApplications(LocalDrivingLicenseApplicationID),
    FOREIGN KEY (CreatedByUserID) REFERENCES Users(UserID),
    FOREIGN KEY (RetakeTestApplicationID) REFERENCES Applications(ApplicationID)
);

-- Create Table: TestTypes
CREATE TABLE TestTypes (
    TestTypeID int PRIMARY KEY,
    TestTypeTitle nvarchar(100),
    TestTypeDescription nvarchar(500),
    TestTypeFees smallmoney
);

-- Create Table: LocalDrivingLicenseApplications
CREATE TABLE LocalDrivingLicenseApplications (
    LocalDrivingLicenseApplicationID int PRIMARY KEY,
    ApplicationID int,
    LicenseClassID int,
    FOREIGN KEY (ApplicationID) REFERENCES Applications(ApplicationID),
    FOREIGN KEY (LicenseClassID) REFERENCES LicenseClasses(LicenseClassID)
);
