ALTER PROCEDURE [dbo].[sp_DeliverySplitBatch_Select]
	 @AffiliateID		As Varchar(20)
	,@SupplierID		As Varchar(20)
	,@PoNo				As Varchar(20)
	,@SuratJalan		As Varchar(20)
AS
Begin
	Select 
		OrderNo			 = Trim(A.OrderNo1),
		OldForwarderID	 = Trim(A.SplitForwarder),
		ForwarderID		 = Trim(A.ForwarderID),
		CommercialCls	 = Trim(A.CommercialCls),
		SupplierName	 = Trim(ISNULL(MS.SupplierName,'')),
		SupplierAddress	 = Trim(ISNULL(MS.Address,'')),
		ForwarderName	 = Trim(ISNULL(MF.ForwarderName,'')),
		ForwarderAddress = Trim(ISNULL(MF.Address,'')),
		attn			 = Trim(ISNULL(MF.Attn,'')),
		telp			 = Trim(ISNULL(MF.MobilePhone,'')),
		ConsigneeName	 = Trim(ISNULL(MA.ConsigneeName,'')),
		ConsigneeAddress = Trim(ISNULL(MA.ConsigneeAddress,'')),
		ETDVendor		 = A.ETDVendor1,
		A.Period
	From	
		PO_Master_Export A LEFT JOIN 
		MS_Supplier MS ON MS.SupplierID = A.SupplierID LEFT JOIN 
		MS_Forwarder MF ON MF.ForwarderID = A.ForwarderID LEFT JOIN 
		MS_Affiliate MA ON MA.AffiliateID = A.AffiliateID
	where	
		A.PONo = @PoNo 
	and	A.AffiliateID	= @AffiliateID 
	and A.SupplierID	= @SupplierID 
	and A.SplitDelivery	= @SuratJalan
End