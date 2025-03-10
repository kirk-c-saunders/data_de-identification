CREATE TABLE [dataDeidentificationAddress].[StreetSuffix]
(
	[StreetStuffixId] INT IDENTITY(1,1) NOT NULL
	,[FullName] VARCHAR(20) NOT NULL
	,[Abbreviation] VARCHAR(5) NOT NULL
	,CONSTRAINT [PK_DataDeidentificationAddress_StreetSuffix] PRIMARY KEY ([StreetStuffixId] ASC)
);
GO