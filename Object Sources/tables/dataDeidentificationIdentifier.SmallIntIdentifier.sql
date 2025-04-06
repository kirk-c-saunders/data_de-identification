CREATE TABLE [dataDeidentificationIdentifier].[SmallIntIdentifier]
(
	[ExistingIdentifier] SMALLINT IDENTITY(1, 1) NOT NULL
	,[NewIdentifier] SMALLINT NOT NULL
	,[SortingRandomizer] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [TempSmallIntDefault] DEFAULT (NEWID()) /* Will be dropped after table is fully populated */ 
	,CONSTRAINT [PK_DataDeidentificationIdentifier_SmallIntIdentifier] PRIMARY KEY ([ExistingIdentifier] ASC)
);
GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_DataDeidentificationIdentifier_SmallIntIdentifier_NewIdentifier]
	ON [dataDeidentificationIdentifier].[SmallIntIdentifier] ([NewIdentifier] ASC);
GO

/* Index will be rebuilt and activated once [NewIdentifier] is fully populated */
ALTER INDEX [UQ_DataDeidentificationIdentifier_SmallIntIdentifier_NewIdentifier]
    ON [dataDeidentificationIdentifier].[SmallIntIdentifier]
DISABLE;
GO