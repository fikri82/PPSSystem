ALTER PROCEDURE [dbo].[sp_DeliverySplitList_Select]
	 @DeliveryDate	As Varchar(10)
	,@PoNo			As Varchar(20)
	,@OrderNo		As Varchar(20)
	,@SuratJalan	As Varchar(20)
	,@Affiliate		As Varchar(20)
	,@Supplier		As Varchar(20)
	,@Forwarder		As Varchar(20)
	,@IndexCol		As Varchar(1)
AS
Begin
	--select * from PO_Master_Export where PONo = 'OH3051' and AffiliateID = 'YKHT'
	--select * from PO_Detail_Export where PONo = 'OH3051' and AffiliateID = 'YKHT' order by OrderNo1
	--select * from PrintLabelExport where PONo = 'OH3051' and AffiliateID = 'YKHT' and SuratJalanNo_FWD = '432/IKS-SJ/II/23' order by OrderNo

	--select top 1 * from DOSupplier_Master_Export where SuratJalanNo = '432/IKS-SJ/II/23' order by OrderNo
	--select top 1 * from DOSupplier_Detail_Export where SuratJalanNo = '432/IKS-SJ/II/23' order by OrderNo
	--select top 1 * from DOSupplier_DetailBox_Export where SuratJalanNo = '432/IKS-SJ/II/23'  order by OrderNo

	--select top 1 * from ReceiveForwarder_Master where SuratJalanNo = '432/IKS-SJ/II/23' order by OrderNo
	--select top 1 * from ReceiveForwarder_Detail where SuratJalanNo = '432/IKS-SJ/II/23' order by OrderNo
	--select top 1 * from ReceiveForwarder_DetailBox where SuratJalanNo = '432/IKS-SJ/II/23' order by OrderNo

	IF @IndexCol = '0'
		Begin
			Select 
				[Check] = 0,
				No		= ROW_NUMBER() over (Order By (select 0)),
				PoNo	= Trim(a.PONo),
				OrderNo	= Trim(a.OrderNo),
				PartNo	= Trim(b.PartNo),
				BoxNo	= Trim(c.BoxNo),
				MOQ		= b.POMOQ
			From
				DOSupplier_Master_Export	a Inner Join
				DOSupplier_Detail_Export	b on a.AffiliateID = b.AffiliateID and a.SupplierID = b.SupplierID and a.PONo = b.PONo and a.OrderNo = b.OrderNo and a.SuratJalanNo = b.SuratJalanNo Inner Join
				DOSupplier_DetailBox_Export	c on a.AffiliateID = c.AffiliateID and a.SupplierID = c.SupplierID and a.PONo = c.PONo and a.OrderNo = c.OrderNo and a.SuratJalanNo = c.SuratJalanNo and b.PartNo = c.PartNo and b.SeqNo = c.SeqNo 
			Where
				a.PONo			= @PoNo
			And	a.OrderNo		= @OrderNo
			And a.AffiliateID	= @Affiliate
			And a.SupplierID	= @Supplier			
			And a.SuratJalanNo	= @SuratJalan
			And a.DeliveryDate	= @DeliveryDate
			Order By
				c.BoxNo
		End

	IF @IndexCol = '1'
		Begin
			Select 
				[Check] = 0,
				No		= ROW_NUMBER() over (Order By (select 0)),
				PoNo	= Trim(a.PONo),
				OrderNo	= Trim(a.OrderNo),
				PartNo	= Trim(b.PartNo),
				BoxNo	= Trim(c.BoxNo),
				MOQ		= b.POMOQ
			From
				DOSupplier_Master_Export	a Inner Join
				DOSupplier_Detail_Export	b on a.AffiliateID = b.AffiliateID and a.SupplierID = b.SupplierID and a.PONo = b.PONo and a.OrderNo = b.OrderNo and a.SuratJalanNo = b.SuratJalanNo Inner Join
				DOSupplier_DetailBox_Export c on a.AffiliateID = c.AffiliateID and a.SupplierID = c.SupplierID and a.PONo = c.PONo and a.OrderNo = c.OrderNo and a.SuratJalanNo = c.SuratJalanNo and b.PartNo = c.PartNo and b.SeqNo = c.SeqNo Inner Join
				ReceiveForwarder_Master		d on a.AffiliateID = d.AffiliateID and a.SupplierID = d.SupplierID and a.PONo = d.PONo and a.OrderNo = d.OrderNo and a.SuratJalanNo = d.SuratJalanNo Inner Join
				ReceiveForwarder_Detail		e on a.AffiliateID = e.AffiliateID and a.SupplierID = e.SupplierID and a.PONo = e.PONo and a.OrderNo = e.OrderNo and a.SuratJalanNo = e.SuratJalanNo and b.PartNo = e.PartNo
			Where
				a.PONo			= @PoNo
			And	a.OrderNo		= @OrderNo
			And a.AffiliateID	= @Affiliate
			And a.SupplierID	= @Supplier
			And d.ForwarderID	= @Forwarder
			And a.SuratJalanNo	= @SuratJalan
			And a.DeliveryDate	= @DeliveryDate
			Order By
				c.BoxNo
		End
End