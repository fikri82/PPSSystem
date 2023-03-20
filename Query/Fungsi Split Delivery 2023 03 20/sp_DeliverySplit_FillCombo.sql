ALTER PROCEDURE [dbo].[sp_DeliverySplit_FillCombo]
AS
Begin
--For Affiliate
	Select '== ALL ==' Code, '== ALL ==' Description
	Union ALL
	Select 
		Trim(AffiliateID) Code,
		Trim(AffiliateName) Description
	from MS_Affiliate

--For Supplier
	Select '== ALL ==' Code, '== ALL ==' Description
	Union ALL
	Select 
		Trim(SupplierID) Code,
		Trim(SupplierName) Description
	from MS_Supplier

--For Forwarder	
	Select '== ALL ==' Code, '== ALL ==' Description
	Union ALL
	Select 
		Trim(ForwarderID) Code,
		Trim(ForwarderName) Description
	from MS_Forwarder

--For Forwarder Split
	Select 
		Trim(ForwarderID) Code,
		Trim(ForwarderName) Description
	from MS_Forwarder
End