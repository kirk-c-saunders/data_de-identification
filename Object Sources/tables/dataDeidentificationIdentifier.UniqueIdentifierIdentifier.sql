CREATE TABLE [dataDeidentificationIdentifier].[UniqueIdentifierIdentifier]
(
	[ExistingIdentifier] UNIQUEIDENTIFIER NOT NULL
	,[NewIdentifier] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [DF_DataDeidentificationIdentifier_UniqueIdentifierIdentifier_NewIdentifier] DEFAULT (NEWID())
	,CONSTRAINT [PK_DataDeidentificationIdentifier_UniqueIdentifierIdentifier] PRIMARY KEY ([ExistingIdentifier] ASC)
);
GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_DataDeidentificationIdentifier_UniqueIdentifierIdentifier_NewIdentifier]
	ON [dataDeidentificationIdentifier].[UniqueIdentifierIdentifier] ([NewIdentifier] ASC);
GO