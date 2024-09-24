create database DVLD;

CREATE TABLE Countries (
    CountryID INT PRIMARY KEY,
    CountryName NVARCHAR(50)
);

CREATE TABLE People (
    PersonID INT PRIMARY KEY,
    NationalNO NVARCHAR(20),
    FirstName NVARCHAR(20),
    SecondName NVARCHAR(20),
    ThirdName NVARCHAR(20),
    LastName NVARCHAR(20),
    DateOfBirth DATETIME,
    Gendor TINYINT,
    Address NVARCHAR(500),
    Phone NVARCHAR(20),
    Email NVARCHAR(50),
    NationalityCountryID INT,  -- Added the NationalityCountryID column
    FOREIGN KEY (NationalityCountryID) REFERENCES Countries(CountryID),
    ImagePath NVARCHAR(250)
);
