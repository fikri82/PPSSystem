ALTER PROCEDURE [dbo].[sp_DeliverySplit_Select]
	@DeliveryFrom	As Varchar(10) = NULL,
	@DeliveryTo		As Varchar(10) = NULL,
	@ReceiptFrom	As Varchar(10) = NULL,
	@ReceiptTo		As Varchar(10) = NULL,
	@PoNo			As Varchar(20) = NULL,
	@SuratJalan		As Varchar(20) = NULL,
	@Affiliate		As Varchar(20) = NULL,
	@Supplier		As Varchar(20) = NULL,
	@Forwarder		As Varchar(20) = NULL
AS
Begin
	Select 
		coldetail = 'DeliverySplitEntry.aspx?SJNo='+SuppSuratJalan+'&Aff='+Affiliate+'&Supp='+Supplier+'&Fwd='+Forwarder+'&PoNo='+PoNo+'&OrderNo='+OrderNo+'&ColIndex='+ColIndex,
		coldetailname = 'DETAIL',
		No = ROW_NUMBER() over (Order By (select 0)),
		*
	From
	(
		Select 
			ColIndex		= Case When C.SuratJalanNo IS NULL Then '0' Else '1' End,
			Affiliate		= Trim(a.AffiliateID),
			Supplier		= Trim(a.SupplierID),
			Forwarder		= Trim(a.ForwarderID),
			PoNo			= Trim(a.PONo),
			OrderNo			= Trim(a.OrderNo1),
			DeliveryDate	= Format(b.DeliveryDate, 'dd MMM yyyy'),
			SuppSuratJalan	= Trim(b.SuratJalanNo),
			ReceivedDate	= ISNULL(Format(c.ReceiveDate, 'dd MMM yyyy'),''),
			Remark			= ISNULL(c.Remarks, ''),
			a.UpdateDate
		From 
			PO_Master_Export a Inner Join
			DOSupplier_Master_Export b on a.AffiliateID = b.AffiliateID and a.SupplierID = b.SupplierID and a.PONo = b.PONo and a.OrderNo1 = b.OrderNo Left Join
			ReceiveForwarder_Master  c on a.AffiliateID = c.AffiliateID and a.SupplierID = c.SupplierID and a.PONo = c.PONo and a.OrderNo1 = c.OrderNo and b.SuratJalanNo = c.SuratJalanNo 
		Where 
			a.EntryDate > '2023-01-01'
		And C.SuratJalanNo IS NULL
		And	1 = Case
					When @DeliveryFrom IS NULL Then 1
					When @DeliveryFrom IS NOT NULL and b.DeliveryDate between @DeliveryFrom and @DeliveryTo Then 1
					Else 0
				End
		And 1 = Case
					When @ReceiptFrom IS NULL Then 1
					When @ReceiptFrom IS NOT NULL and c.ReceiveDate between @ReceiptFrom and @ReceiptTo Then 1
					Else 0
				End
		And 1 = Case
					When @PoNo IS NULL Then 1
					When @PoNo IS NOT NULL and a.PONo = @PoNo Then 1
					Else 0
				End
		And 1 = Case
					When @SuratJalan IS NULL Then 1
					When @SuratJalan IS NOT NULL and b.SuratJalanNo like '%'+@SuratJalan+'%' Then 1
					Else 0
				End
		And 1 = Case
					When @Affiliate IS NULL Then 1
					When @Affiliate IS NOT NULL and a.AffiliateID = @Affiliate Then 1
					Else 0
				End
		And 1 = Case
					When @Supplier IS NULL Then 1
					When @Supplier IS NOT NULL and a.SupplierID = @Supplier Then 1
					Else 0
				End
		And 1 = Case
					When @Forwarder IS NULL Then 1
					When @Forwarder IS NOT NULL and a.ForwarderID = @Forwarder Then 1
					Else 0
				End
	UNION
		Select 
			ColIndex		= Case When C.SuratJalanNo IS NULL Then '0' Else '1' End,
			Affiliate		= Trim(a.AffiliateID),
			Supplier		= Trim(a.SupplierID),
			Forwarder		= Trim(a.ForwarderID),
			PoNo			= Trim(a.PONo),
			OrderNo			= Trim(a.OrderNo1),
			DeliveryDate	= Format(b.DeliveryDate, 'dd MMM yyyy'),
			SuppSuratJalan	= Trim(b.SuratJalanNo),
			ReceivedDate	= ISNULL(Format(c.ReceiveDate, 'dd MMM yyyy'),''),
			Remark			= ISNULL(c.Remarks, ''),
			a.UpdateDate
		From 
			PO_Master_Export a Inner Join
			DOSupplier_Master_Export b on a.AffiliateID = b.AffiliateID and a.SupplierID = b.SupplierID and a.PONo = b.PONo and a.OrderNo1 = b.OrderNo Left Join
			ReceiveForwarder_Master  c on a.AffiliateID = c.AffiliateID and a.SupplierID = c.SupplierID and a.PONo = c.PONo and a.OrderNo1 = c.OrderNo and b.SuratJalanNo = c.SuratJalanNo 
		Where 
			a.EntryDate > '2023-01-01'
		And c.SuratJalanNo not in (Select distinct SuratJalanNo from ShippingInstruction_Detail)
		And	1 = Case
					When @DeliveryFrom IS NULL Then 1
					When @DeliveryFrom IS NOT NULL and b.DeliveryDate between @DeliveryFrom and @DeliveryTo Then 1
					Else 0
				End
		And 1 = Case
					When @ReceiptFrom IS NULL Then 1
					When @ReceiptFrom IS NOT NULL and c.ReceiveDate between @ReceiptFrom and @ReceiptTo Then 1
					Else 0
				End
		And 1 = Case
					When @PoNo IS NULL Then 1
					When @PoNo IS NOT NULL and a.PONo = @PoNo Then 1
					Else 0
				End
		And 1 = Case
					When @SuratJalan IS NULL Then 1
					When @SuratJalan IS NOT NULL and b.SuratJalanNo like '%'+@SuratJalan+'%' Then 1
					Else 0
				End
		And 1 = Case
					When @Affiliate IS NULL Then 1
					When @Affiliate IS NOT NULL and a.AffiliateID = @Affiliate Then 1
					Else 0
				End
		And 1 = Case
					When @Supplier IS NULL Then 1
					When @Supplier IS NOT NULL and a.SupplierID = @Supplier Then 1
					Else 0
				End
		And 1 = Case
					When @Forwarder IS NULL Then 1
					When @Forwarder IS NOT NULL and a.ForwarderID = @Forwarder Then 1
					Else 0
				End
	) A
	Order By A.DeliveryDate Desc, A.UpdateDate Asc
End