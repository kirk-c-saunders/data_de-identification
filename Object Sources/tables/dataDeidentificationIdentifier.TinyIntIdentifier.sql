CREATE TABLE [dataDeidentificationIdentifier].[TinyIntIdentifier]
(
	[ExistingTinyInt] TINYINT IDENTITY(0, 1) NOT NULL
	,[SortingRandomizer] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [TempTinyIntDefault] DEFAULT (NEWID()) /* Column will be dropped after new identifier is created */
	,[NewTinyInt] TINYINT NULL /* Once fully populated, will be made NOT NULL */
	,CONSTRAINT [PK_DataDeidentificationIdentifier_TinyIntIdentifier] PRIMARY KEY ([ExistingTinyInt] ASC)
);
GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_DataDeidentificationIdentifier_TinyIntIdentifier_NewTinyInt]
	ON [dataDeidentificationIdentifier].[TinyIntIdentifier] ([NewTinyInt] ASC);
GO

/* Index will be dropped and recreated once [NewTinyInt] is fully populated */
ALTER INDEX [UQ_DataDeidentificationIdentifier_TinyIntIdentifier_NewTinyInt]
    ON [dataDeidentificationIdentifier].[TinyIntIdentifier]
DISABLE;