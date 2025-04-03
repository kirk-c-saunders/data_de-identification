CREATE TABLE [dataDeidentificationIdentifier].[IntIdentifier]
(
	[ExistingInt] INT IDENTITY(1,1) NOT NULL
	,[SortingRandomizer] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [TempIntDefault] DEFAULT (NEWID()) /* Column will be dropped after new identifier is created */
	,[NewInt] INT NULL /* Once fully populated, will be made NOT NULL */
	,CONSTRAINT [PK_DataDeidentificationIdentifier_IntIdentifier] PRIMARY KEY ([ExistingInt] ASC)
);
GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_DataDeidentificationIdentifier_IntIdentifier_NewInt]
	ON [dataDeidentificationIdentifier].[IntIdentifier] ([NewInt] ASC);
GO

/* Index will be dropped and recreated once [NewInt] is fully populated */
ALTER INDEX [UQ_DataDeidentificationIdentifier_IntIdentifier_NewInt]
    ON [dataDeidentificationIdentifier].[IntIdentifier]
DISABLE;
GO