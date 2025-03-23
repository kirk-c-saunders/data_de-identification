CREATE TABLE [dataDeidentificationPersonName].[FirstName]
(
	[FirstNameId] INT IDENTITY(1,1) NOT NULL
	,[FirstName] VARCHAR(100) NOT NULL
	,[Gender] CHAR(1) NOT NULL
	,[GenderSequenceId] INT NOT NULL
	,CONSTRAINT [PK_DataDeidentificationPersonName_FirstName] PRIMARY KEY ([FirstNameId] ASC)
);
GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_DataDeidentificationPersonName_FirstName_Gender_GenderSequenceId]
	ON [dataDeidentificationPersonName].[FirstName] ([Gender] ASC, [GenderSequenceId] ASC)
	INCLUDE ([FirstName]);
GO