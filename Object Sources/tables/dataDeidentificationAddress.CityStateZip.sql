CREATE TABLE [dataDeidentificationAddress].[CityStateZip]
(
	[CityStateZipId] INT IDENTITY(1,1) NOT NULL
	,[CityName] VARCHAR(100) NOT NULL
	,[StateName] VARCHAR(100) NOT NULL
	,[StateAbbreviation] VARCHAR(2) NOT NULL /* Used VARCHAR not CHAR to avoid conversion issues in processing */
	,[ZipCode] VARCHAR(5) NOT NULL
	,CONSTRAINT [PK_DataDeidentificationAddress_CityStateZip] PRIMARY KEY ([CityStateZipId] ASC)
)