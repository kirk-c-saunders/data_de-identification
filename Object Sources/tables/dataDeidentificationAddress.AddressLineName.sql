CREATE TABLE [dataDeidentificationAddress].[AddressLineName]
(
	[AddressLineNameId] INT IDENTITY(1,1) NOT NULL
	,[Name] VARCHAR(100) NOT NULL
	,CONSTRAINT [PK_DataDeidentificationAddress_AddressLineName] PRIMARY KEY ([AddressLineNameId] ASC)
);
GO