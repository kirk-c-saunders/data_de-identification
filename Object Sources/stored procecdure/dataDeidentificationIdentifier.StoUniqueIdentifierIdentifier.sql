CREATE PROCEDURE [dataDeidentificationIdentifier].[StoUniqueIdentifierIdentifier]
(
	@ExistingUniqueIdentifier dataDeidentificationIdentifier.UdtUniqueIdentifierIdentifier READONLY
)
AS
BEGIN
	INSERT INTO dataDeidentificationIdentifier.UniqueIdentifierIdentifier
	(
		ExistingUniqueIdentifier
	)
	SELECT EUI.ExistingUniqueIdentifier
	FROM @ExistingUniqueIdentifier AS EUI
	EXCEPT /* Using EXCEPT to insert a unique list of values that are not already stored */ 
	SELECT UII.ExistingUniqueIdentifier
	FROM dataDeidentificationIdentifier.UniqueIdentifierIdentifier AS UII;
END;
GO