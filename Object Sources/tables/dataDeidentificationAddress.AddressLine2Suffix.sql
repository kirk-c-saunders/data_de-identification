CREATE TABLE [dataDeidentificationAddress].[AddressLine2Suffix]
(
	[AddressLine2SuffixId] INT IDENTITY(1,1) NOT NULL
	,[Name] VARCHAR(100) NOT NULL
	,CONSTRAINT [PK_DataDeidentificationAddress_AddressLine2Suffix] PRIMARY KEY ([AddressLine2SuffixId] ASC)
);
GO