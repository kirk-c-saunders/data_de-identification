CREATE TABLE [dataDeidentification].[FirstName]
(
	[FirstNameId] INT IDENTITY(1,1) NOT NULL
	,[FirstName] VARCHAR(100) NOT NULL
	,[Gender] CHAR(1) NOT NULL
	,[GenderSequenceId] INT NOT NULL
	,CONSTRAINT [PK_DataDeidentification_FirstName] PRIMARY KEY ([FirstNameId] ASC)
);
GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_DataDeidentification_FirstName_Gender_GenderSequenceId]
	ON [dataDeidentification].[FirstName] ([Gender] ASC, [GenderSequenceId] ASC)
	INCLUDE ([FirstName]);
GO