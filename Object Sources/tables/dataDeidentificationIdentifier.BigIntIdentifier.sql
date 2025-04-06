CREATE TABLE [dataDeidentificationIdentifier].[BigIntIdentifier]
(
	[ExistingIdentifier] BIGINT IDENTITY(1,1) NOT NULL
	,[NewIdentifier] INT NOT NULL
	,[SortingRandomizer] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [TempBigIntDefault] DEFAULT (NEWID()) /* Will be dropped after table is fully populated */ 
	,CONSTRAINT [PK_DataDeidentificationIdentifier_BigIntIdentifier] PRIMARY KEY ([ExistingIdentifier] ASC)
);
GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_DataDeidentificationIdentifier_BigIntIdentifier_NewIdentifier]
	ON [dataDeidentificationIdentifier].[BigIntIdentifier] ([NewIdentifier] ASC);
GO

/* Index will be rebuilt and activated once [NewIdentifier] is fully populated */
ALTER INDEX [UQ_DataDeidentificationIdentifier_BigIntIdentifier_NewIdentifier]
    ON [dataDeidentificationIdentifier].[BigIntIdentifier]
DISABLE;
GO