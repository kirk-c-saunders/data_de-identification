CREATE TABLE [dataDeidentificationIdentifier].[TinyIntIdentifier]
(
	[ExistingIdentifier] TINYINT IDENTITY(1, 1) NOT NULL
	,[NewIdentifier] TINYINT NOT NULL
	,[SortingRandomizer] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [TempTinyIntDefault] DEFAULT (NEWID()) /* Will be dropped after table is fully populated */ 
	,CONSTRAINT [PK_DataDeidentificationIdentifier_TinyIntIdentifier] PRIMARY KEY ([ExistingIdentifier] ASC)
);
GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_DataDeidentificationIdentifier_TinyIntIdentifier_NewIdentifier]
	ON [dataDeidentificationIdentifier].[TinyIntIdentifier] ([NewIdentifier] ASC);
GO

/* Index will be rebuilt and activated once [NewIdentifier] is fully populated */
ALTER INDEX [UQ_DataDeidentificationIdentifier_TinyIntIdentifier_NewIdentifier]
    ON [dataDeidentificationIdentifier].[TinyIntIdentifier]
DISABLE;