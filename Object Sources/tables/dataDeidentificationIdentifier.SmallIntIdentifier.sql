CREATE TABLE [dataDeidentificationIdentifier].[SmallIntIdentifier]
(
	[ExistingSmallInt] SMALLINT IDENTITY(1, 1) NOT NULL
	,[SortingRandomizer] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [TempSmallIntDefault] DEFAULT (NEWID()) /* Column will be dropped after new identifier is created */
	,[NewSmallInt] SMALLINT NULL /* Once fully populated, will be made NOT NULL */
	,CONSTRAINT [PK_DataDeidentificationIdentifier_SmallIntIdentifier] PRIMARY KEY ([ExistingSmallInt] ASC)
);
GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_DataDeidentificationIdentifier_SmallIntIdentifier_NewSmallInt]
	ON [dataDeidentificationIdentifier].[SmallIntIdentifier] ([NewSmallInt] ASC);
GO

/* Index will be dropped and recreated once [NewSmallInt] is fully populated */
ALTER INDEX [UQ_DataDeidentificationIdentifier_SmallIntIdentifier_NewSmallInt]
    ON [dataDeidentificationIdentifier].[SmallIntIdentifier]
DISABLE;
GO