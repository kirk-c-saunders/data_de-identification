CREATE TABLE [dataDeidentification].[LastName]
(
	[LastNameId] INT IDENTITY(1,1) NOT NULL
	,[LastName] VARCHAR(100) NOT NULL
	,CONSTRAINT [PK_DataDeidentification_LastName] PRIMARY KEY ([LastNameId] ASC)
);
GO