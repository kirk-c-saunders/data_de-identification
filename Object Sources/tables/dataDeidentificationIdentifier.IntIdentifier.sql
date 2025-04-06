CREATE TABLE [dataDeidentificationIdentifier].[IntIdentifier]
(
	[ExistingIdentifier] INT IDENTITY(1,1) NOT NULL
	,[NewIdentifier] INT NOT NULL
	,[SortingRandomizer] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [TempIntDefault] DEFAULT (NEWID()) /* Will be dropped after table is fully populated */ 
	,CONSTRAINT [PK_DataDeidentificationIdentifier_IntIdentifier] PRIMARY KEY ([ExistingIdentifier] ASC)
);
GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_DataDeidentificationIdentifier_IntIdentifier_NewIdentifier]
	ON [dataDeidentificationIdentifier].[IntIdentifier] ([NewIdentifier] ASC);
GO

/* Index will be rebuilt and activated once [NewIdentifier] is fully populated */
ALTER INDEX [UQ_DataDeidentificationIdentifier_IntIdentifier_NewIdentifier]
    ON [dataDeidentificationIdentifier].[IntIdentifier]
DISABLE;
GO