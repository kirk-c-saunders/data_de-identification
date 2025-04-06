CREATE PROCEDURE [dataDeidentificationIdentifier].[StoUniqueIdentifierIdentifier]
(
	@ExistingUniqueIdentifier dataDeidentificationIdentifier.UdtUniqueIdentifierIdentifier READONLY
)
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO dataDeidentificationIdentifier.UniqueIdentifierIdentifier
	(
		ExistingIdentifier
	)
	SELECT EUI.ExistingIdentifier
	FROM @ExistingUniqueIdentifier AS EUI
	EXCEPT /* Using EXCEPT to insert a unique list of values that are not already stored */ 
	SELECT UII.ExistingIdentifier
	FROM dataDeidentificationIdentifier.UniqueIdentifierIdentifier AS UII;
END;
GO