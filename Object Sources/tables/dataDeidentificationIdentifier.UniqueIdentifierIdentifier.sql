CREATE TABLE [dataDeidentificationIdentifier].[UniqueIdentifierIdentifier]
(
	[ExistingUniqueIdentifier] UNIQUEIDENTIFIER NOT NULL
	,[NewUniqueIdentifier] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [DF_DataDeidentificationIdentifier_UniqueIdentifierIdentifier_NewUniqueIdentifier] DEFAULT (NEWID())
	,CONSTRAINT [PK_DataDeidentificationIdentifier_UniqueIdentifierIdentifier] PRIMARY KEY ([ExistingUniqueIdentifier] ASC)
);
GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_DataDeidentificationIdentifier_UniqueIdentifierIdentifier_NewUniqueIdentifier]
	ON [dataDeidentificationIdentifier].[UniqueIdentifierIdentifier] ([NewUniqueIdentifier] ASC);
GO