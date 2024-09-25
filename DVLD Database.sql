
create database DVLD_Project;


RESTORE DATABASE MyDatabase1
FROM DISK = 'C:\DVLD.bak';


RESTORE DATABASE MyDatabase1
FROM DISK = 'C:\DVLD.bak'
WITH MOVE 'DVLD' TO 'C:\NewLocation\MyDatabase1.mdf',
MOVE 'DVLD_log' TO 'C:\NewLocation\MyDatabase1_log.ldf';

ALTER DATABASE DVLD_Project 
SET RECOVERY SIMPLE;

ALTER DATABASE DVLD_Project 
SET RECOVERY FULL;

RESTORE DATABASE DVLD_Project
FROM DISK = 'C:\DVLD.bak'
WITH REPLACE, 
MOVE 'DVLD' TO 'C:\SQLData\DVLD_Project.mdf',
MOVE 'DVLD_log' TO 'C:\SQLData\DVLD_Project_log.ldf';


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
    TestTypeID int  PRIMARY KEY,
    TestTypeTitle nvarchar(100),
    TestTypeDescription nvarchar(500),
    TestTypeFees smallmoney
);

-- edit the TestTypes Table to make the id auto increamental
CREATE TABLE TestTypes_New (
    TestTypeID int IDENTITY(1,1) NOT NULL,
    TestTypeTitle nvarchar(100),
    TestTypeDescription nvarchar(500),
    TestTypeFees smallmoney
);

DROP TABLE TestTypes;

EXEC sp_rename 'TestTypes_New', 'TestTypes';

-- Create Table: LocalDrivingLicenseApplications
CREATE TABLE LocalDrivingLicenseApplications (
    LocalDrivingLicenseApplicationID int PRIMARY KEY,
    ApplicationID int,
    LicenseClassID int,
    FOREIGN KEY (ApplicationID) REFERENCES Applications(ApplicationID),
    FOREIGN KEY (LicenseClassID) REFERENCES LicenseClasses(LicenseClassID)
);



-- Insert into Countries (Example records)
INSERT INTO Countries (CountryID, CountryName)
VALUES 
(1, 'USA'),
(2, 'Canada'),
(3, 'Germany'),
(4, 'France'),
(5, 'Japan');

-- Insert into People (Example records)
INSERT INTO People (PersonID, NationalNo, FirstName, SecondName, ThirdName, LastName, DateOfBirth, Gender, Address, Phone, Email, NationalityCountryID, ImagePath)
VALUES 
(1, '123456789', 'John', 'A', 'B', 'Doe', '1985-07-15', 1, '123 Main St', '123-456-7890', 'john.doe@example.com', 1, '/images/john_doe.jpg'),
(2, '987654321', 'Jane', 'C', 'D', 'Smith', '1990-03-22', 2, '456 Elm St', '987-654-3210', 'jane.smith@example.com', 2, '/images/jane_smith.jpg');

-- Insert into Users (Example records)
INSERT INTO Users (UserID, PersonID, UserName, Password, IsActive)
VALUES 
(1, 1, 'johndoe', 'password123', 1),
(2, 2, 'janesmith', 'password456', 1);

-- Insert into ApplicationTypes (Example records)
INSERT INTO ApplicationTypes (ApplicationTypeID, ApplicationTypeTitle, ApplicationFees)
VALUES 
(1, 'New Driver License', 150.00),
(2, 'License Renewal', 100.00);

-- Insert into Applications (Example records)
INSERT INTO Applications (ApplicationID, ApplicantPersonID, ApplicationDate, ApplicationTypeID, ApplicationStatus, LastStatusDate, PaidFees, CreatedByUserID)
VALUES 
(1, 1, '2023-07-01', 1, 1, '2023-07-05', 150.00, 1),
(2, 2, '2023-08-01', 2, 0, '2023-08-05', 100.00, 2);

-- Insert into Drivers (Example records)
INSERT INTO Drivers (DriverID, PersonID, CreatedByUserID, CreatedDate)
VALUES 
(1, 1, 1, '2023-06-15'),
(2, 2, 2, '2023-06-20');

-- Insert into LicenseClasses (Example records)
INSERT INTO LicenseClasses (LicenseClassID, ClassName, ClassDescription, MinimumAllowedAge, DefaultValidityLength, ClassFees)
VALUES 
(1, 'Class A', 'Motorcycles', 18, 5, 50.00),
(2, 'Class B', 'Passenger cars', 18, 10, 100.00);

-- Insert into Licenses (Example records)
INSERT INTO Licenses (LicenseID, ApplicationID, DriverID, LicenseClassID, IssueDate, ExpirationDate, Notes, PaidFees, IsActive, IssueReason, CreatedByUserID)
VALUES 
(1, 1, 1, 1, '2023-07-10', '2028-07-10', 'No issues', 150.00, 1, 1, 1),
(2, 2, 2, 2, '2023-08-10', '2033-08-10', 'Renewal', 100.00, 1, 2, 2);

-- Insert into DetainedLicenses (Example records)
INSERT INTO DetainedLicenses (DetainID, LicenseID, DetainDate, FineFees, CreatedByUserID, IsReleased, ReleaseDate, ReleasedByUserID, ReleaseApplicationID)
VALUES 
(1, 1, '2023-09-01', 50.00, 1, 1, '2023-09-10', 2, 1),
(2, 2, '2023-10-01', 70.00, 2, 0, NULL, NULL, NULL);

-- Insert into Tests (Example records)
INSERT INTO Tests (TestID, TestAppointmentID, TestResult, Notes, CreatedByUserID)
VALUES 
(1, 1, 1, 'Passed', 1),
(2, 2, 0, 'Failed', 2);

-- Insert into TestAppointments (Example records)
INSERT INTO TestAppointments (TestAppointmentID, LocalDrivingLicenseApplicationID, AppointmentDate, PaidFees, CreatedByUserID, IsLocked, RetakeTestApplicationID)
VALUES 
(1, 1, '2023-09-20', 50.00, 1, 1, NULL),
(2, 2, '2023-10-20', 70.00, 2, 0, 1);

-- Insert into TestTypes (Example records)
INSERT INTO TestTypes (TestTypeID, TestTypeTitle, TestTypeDescription, TestTypeFees)
VALUES 
(1, 'Theory Test', 'Written test on driving rules', 50.00),
(2, 'Practical Test', 'On-road driving test', 100.00);

-- Insert into LocalDrivingLicenseApplications (Example records)
INSERT INTO LocalDrivingLicenseApplications (LocalDrivingLicenseApplicationID, ApplicationID, LicenseClassID)
VALUES 
(1, 1, 1),
(2, 2, 2);



-- Step 1: Insert data into LocalDrivingLicenseApplications (referenced by TestAppointments)
INSERT INTO LocalDrivingLicenseApplications (ApplicationID, LicenseClassID)
VALUES 
(1, 1),
(2, 2),
(3, 1),
(4, 2);

-- Step 2: Insert data into TestAppointments (referenced by Tests)
INSERT INTO TestAppointments (LocalDrivingLicenseApplicationID, AppointmentDate, PaidFees, CreatedByUserID, IsLocked, RetakeTestApplicationID)
VALUES 
(1, '2023-09-20', 50.00, 1, 0, NULL),
(2, '2023-09-21', 75.00, 2, 0, NULL),
(3, '2023-09-22', 60.00, 3, 1, NULL),
(4, '2023-09-23', 90.00, 4, 1, NULL);

-- Step 3: Insert data into Tests (referencing TestAppointmentID)
INSERT INTO Tests (TestAppointmentID, TestResult, Notes, CreatedByUserID)
VALUES 
(1, 1, 'Passed with flying colors', 1),
(2, 0, 'Failed at parallel parking', 2),
(3, 1, 'Good driving skills', 3),
(4, 0, 'Needs more practice', 4);

-- Step 4: Insert data into TestTypes (allowing SQL Server to auto-generate identity values)
INSERT INTO TestTypes (TestTypeTitle, TestTypeDescription, TestTypeFees)
VALUES 
('Theory Test', 'Written test on driving rules and regulations', 50.00),
('Practical Test', 'On-road driving test to assess driving skills', 100.00),
('Vision Test', 'Test to assess vision acuity for driving', 25.00),
('Medical Test', 'Medical fitness test for driving', 75.00);



select * from Users