ALTER PROCEDURE [dbo].[sp_DeliverySplitBatch_Select_Detail_Moving] 
	 @AffiliateID		As Varchar(20)
	,@SupplierID		As Varchar(20)
	,@SuratJalan		As Varchar(20)
	,@SuratJalanOld		As Varchar(20)
	,@PoNo				As Varchar(20)
	,@OrderNo			As Varchar(20)
As
Begin
	--select Top 5 * from DOSupplier_Master_Export	where PONo = 'OH3051' and SupplierID = 'IKS'
	--select Top 1 * from DOSupplier_DetailBox_Export where SuratJalanNo = '432/IKS-SJ/II/23-1' and PONo = 'OH3051'

	--select Top 1 * from ReceiveForwarder_Master		where SuratJalanNo = '432/IKS-SJ/II/23-1' and PONo = 'OH3051'
	--select Top 1 * from ReceiveForwarder_Detail		where SuratJalanNo = '432/IKS-SJ/II/23-1' and PONo = 'OH3051'
	--select Top 1 * from ReceiveForwarder_DetailBox	where SuratJalanNo = '432/IKS-SJ/II/23-1' and PONo = 'OH3051'

-- Untuk ke Forwarder Lama
	Select 
		No			= ROW_NUMBER() Over(Order by (c.BoxNo)),
		Affiliate	= Trim(a.AffiliateID),
		Supplier	= Trim(a.SupplierID),
		Forwarder	= Trim(d.ForwarderID),
		PoNo		= Trim(a.PONo),
		OrderNo		= Trim(a.OrderNo),
		SuratJalan	= Trim(a.SuratJalanNo),
		PartNo		= Trim(b.PartNo),
		BoxNo		= Trim(c.BoxNo),
		Consignee	= Trim(ISNULL(f.ConsigneeCode,'')),
		ReceiveDate = Cast(d.ReceiveDate as date),
		UOM			= Trim(ISNULL(h.Description,'')),
		MOQ			= b.POMOQ,
		StatusGR	= Case When a.SuratJalanNo = @SuratJalan Then 'SPLIT' Else 'ORIGINAL GR' End,
		PIC			= Trim(a.EntryUser),
		PlanUpdate	= Cast(a.EntryDate as date),
		Status		= Case When a.SuratJalanNo = @SuratJalan Then '1' Else '0' End,
		Remarks		= Case When a.SuratJalanNo = @SuratJalan Then d.Remarks Else '' End,
		OldForwarder = Trim(ISNULL(e.SplitForwarder, e.ForwarderID))
	From
		DOSupplier_Master_Export	a	Inner Join
		DOSupplier_Detail_Export	b	on a.AffiliateID = b.AffiliateID and a.SupplierID = b.SupplierID and a.PONo = b.PONo and a.OrderNo = b.OrderNo  and a.SuratJalanNo = b.SuratJalanNo Inner Join
		DOSupplier_DetailBox_Export c	on a.AffiliateID = c.AffiliateID and a.SupplierID = c.SupplierID and a.PONo = c.PONo and a.OrderNo = c.OrderNo  and a.SuratJalanNo = c.SuratJalanNo and b.PartNo = c.PartNo and b.SeqNo = c.SeqNo Inner Join
		ReceiveForwarder_Master		d	on a.AffiliateID = d.AffiliateID and a.SupplierID = d.SupplierID and a.PONo = d.PONo and a.OrderNo = d.OrderNo  and a.SuratJalanNo = d.SuratJalanNo Inner Join
		PO_Master_Export			e	on a.AffiliateID = e.AffiliateID and a.SupplierID = e.SupplierID and a.PONo = e.PONo and a.OrderNo = e.OrderNo1 and d.ForwarderID  = e.ForwarderID  Left Join
		MS_Affiliate				f	on a.AffiliateID = f.AffiliateID Left Join
		MS_Parts					g	on b.PartNo		 = g.PartNo		 Left Join
		MS_UnitCls					h	on g.UnitCls	 = h.UnitCls
	Where
		(a.SuratJalanNo = @SuratJalan or a.SuratJalanNo = @SuratJalanOld)
	and	a.AffiliateID	= @AffiliateID
	and	a.SupplierID	= @SupplierID
	and	a.PONo			= @PoNo
	Order By
		c.BoxNo

-- Untuk ke Forwarder Baru
	Select 
		No			= ROW_NUMBER() Over(Order by (c.BoxNo)),
		Affiliate	= Trim(a.AffiliateID),
		Supplier	= Trim(a.SupplierID),
		Forwarder	= Trim(d.ForwarderID),
		PoNo		= Trim(a.PONo),
		OrderNo		= Trim(a.OrderNo),
		SuratJalan	= Trim(a.SuratJalanNo),
		PartNo		= Trim(b.PartNo),
		BoxNo		= Trim(c.BoxNo),
		Consignee	= Trim(ISNULL(f.ConsigneeCode,'')),
		ReceiveDate = Cast(d.ReceiveDate as date),
		UOM			= Trim(ISNULL(h.Description,'')),
		MOQ			= b.POMOQ,
		StatusGR	= Case When a.SuratJalanNo = @SuratJalan Then 'SPLIT' Else 'ORIGINAL GR' End,
		PIC			= Trim(a.EntryUser),
		PlanUpdate	= Cast(a.EntryDate as date),
		Status		= Case When a.SuratJalanNo = @SuratJalan Then '1' Else '0' End,
		Remarks		= Case When a.SuratJalanNo = @SuratJalan Then d.Remarks Else '' End,
		OldForwarder = Trim(ISNULL(e.SplitForwarder, e.ForwarderID))
	From
		DOSupplier_Master_Export	a	Inner Join
		DOSupplier_Detail_Export	b	on a.AffiliateID = b.AffiliateID and a.SupplierID = b.SupplierID and a.PONo = b.PONo and a.OrderNo = b.OrderNo  and a.SuratJalanNo = b.SuratJalanNo Inner Join
		DOSupplier_DetailBox_Export c	on a.AffiliateID = c.AffiliateID and a.SupplierID = c.SupplierID and a.PONo = c.PONo and a.OrderNo = c.OrderNo  and a.SuratJalanNo = c.SuratJalanNo and b.PartNo = c.PartNo and b.SeqNo = c.SeqNo Inner Join
		ReceiveForwarder_Master		d	on a.AffiliateID = d.AffiliateID and a.SupplierID = d.SupplierID and a.PONo = d.PONo and a.OrderNo = d.OrderNo  and a.SuratJalanNo = d.SuratJalanNo Inner Join
		PO_Master_Export			e	on a.AffiliateID = e.AffiliateID and a.SupplierID = e.SupplierID and a.PONo = e.PONo and a.OrderNo = e.OrderNo1 and d.ForwarderID  = e.ForwarderID  Left Join
		MS_Affiliate				f	on a.AffiliateID = f.AffiliateID Left Join
		MS_Parts					g	on b.PartNo		 = g.PartNo		 Left Join
		MS_UnitCls					h	on g.UnitCls	 = h.UnitCls
	Where
		a.SuratJalanNo	= @SuratJalan
	and	a.AffiliateID	= @AffiliateID
	and	a.SupplierID	= @SupplierID
	and	a.PONo			= @PoNo
	Order By
		c.BoxNo

End
