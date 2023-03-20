ALTER PROCEDURE [dbo].[sp_DeliverySplitList_InsUpd_PO]
	 @AffiliateID		As Varchar(20)
	,@SupplierID		As Varchar(20)
	,@ForwarderID		As Varchar(20)
	,@ForwarderIDSplit	As Varchar(20)
	,@SuratJalan		As Varchar(20)
	,@PoNo				As Varchar(20)
	,@OrderNo			As Varchar(20)
	,@OrderNoNew		As Varchar(20)
	,@PartNo			As Varchar(25)
	,@LabelNo			As Varchar(20)
	,@QtyMOQ			As Numeric(18,2)
	,@User				As Varchar(20)
	,@IndexCol			As Varchar(1)
As
Begin
	--Select TOP 1 * From PO_Master_Export		where PONo = 'OH3051' and SupplierID = 'IKS'
	--Select TOP 1 * From PO_Detail_Export		where PONo = 'OH3051' and SupplierID = 'IKS'
	--Select TOP 1 * From PrintLabelExport		where PONo = 'OH3051' and SupplierID = 'IKS'
	--Select TOP 1 * From PO_MasterUpload_Export	where PONo = 'OH3051' and SupplierID = 'IKS'
	--Select TOP 1 * From PO_DetailUpload_Export	where PONo = 'OH3051' and SupplierID = 'IKS'
	Declare @ExcelCls char(1) = 1

	--    ++++INFORMATION for @IndexCol+++    --
	-- 0 Data Belum Di Receiving Perlu Kirim Ulang DN
	-- 1 Data Sudah Di Receiving TIDAK Perlu Kirim Ulang DN
	IF @IndexCol = '1'
	Begin
		SET @ExcelCls = 2
	End


--Master
	IF Not Exists(Select Top 1 PONo From PO_Master_Export Where AffiliateID = @AffiliateID and SupplierID = @SupplierID and ForwarderID = @ForwarderIDSplit and PONo = @PoNo and OrderNo1 = @OrderNoNew)
		Begin
			Insert Into PO_Master_Export
			Select 
				PONo ,AffiliateID ,SupplierID ,ForwarderID = @ForwarderIDSplit,Period ,CommercialCls ,EmergencyCls ,ShipCls ,ErrorStatus ,
				OrderNo1 = @OrderNoNew,ETDVendor1 ,ETDPort1 ,ETAPort1 ,ETAFactory1 ,
				OrderNo2 ,ETDVendor2 ,ETDPort2 ,ETAPort2 ,ETAFactory2 ,
				OrderNo3 ,ETDVendor3 ,ETDPort3 ,ETAPort3 ,ETAFactory3 ,
				OrderNo4 ,ETDVendor4 ,ETDPort4 ,ETAPort4 ,ETAFactory4 ,
				OrderNo5 ,ETDVendor5 ,ETDPort5 ,ETAPort5 ,ETAFactory5 ,
				UploadDate,UploadUser ,PASISendToSupplierDate ,PASISendToSupplierUser ,
				SupplierApproveDate ,SupplierApproveUser ,
				SupplierApprovePartialDate ,SupplierApprovePartialUser ,
				SupplierUnApproveDate ,SupplierUnApproveUser ,
				PASIApproveDate ,PASIApproveUser ,
				EntryDate = GETDATE(), EntryUser = @User,
				UpdateDate= GETDATE(), UpdateUser= @User,
				PASISendToSupplierCls ,SupplierApprovalCls ,ExcelCls ,FinalApprovalCls = @ExcelCls ,SplitReffPONo ,SplitStatus ,AcceptPONo ,
				SplitDelivery = @SuratJalan, @ForwarderID
			From
				PO_Master_Export
			Where 
				AffiliateID = @AffiliateID and SupplierID = @SupplierID and ForwarderID = @ForwarderID and PONo = @PoNo and OrderNo1 = @OrderNo

			Update	PO_Master_Export
			SET		SplitDelivery = @SuratJalan,
					SplitForwarder = @ForwarderID
			WHERE	AffiliateID = @AffiliateID and SupplierID = @SupplierID and ForwarderID = @ForwarderID and PONo = @PoNo and OrderNo1 = @OrderNo

			Insert Into PO_MasterUpload_Export
			Select
				PONo ,AffiliateID ,SupplierID ,ForwarderID = @ForwarderIDSplit ,OrderNo1 = @OrderNoNew ,ETDVendor1 ,Remarks ,EntryDate = GETDATE() ,EntryUser = @User, UpdateDate = GETDATE() ,UpdateUser = @User
			From
				PO_MasterUpload_Export
			Where 
				AffiliateID = @AffiliateID and SupplierID = @SupplierID and ForwarderID = @ForwarderID and PONo = @PoNo and OrderNo1 = @OrderNo
		End

--Detail
	IF Not Exists(Select Top 1 PONo From PO_Detail_Export Where AffiliateID = @AffiliateID and SupplierID = @SupplierID and ForwarderID = @ForwarderIDSplit and PONo = @PoNo and OrderNo1 = @OrderNoNew and PartNo = @PartNo)
		Begin
			insert into PO_Detail_Export
			Select
				PONo ,AffiliateID ,SupplierID ,ForwarderID = @ForwarderIDSplit ,PartNo ,
				OrderNo1 = @OrderNoNew ,Week1 = @QtyMOQ, Week2 ,Week3 ,Week4 ,Week5 ,TotalPOQty = @QtyMOQ,
				PreviousForecast ,Forecast1 ,Forecast2 ,Forecast3 ,Variance ,VariancePercentage ,
				EntryDate = GETDATE() ,EntryUser = @User ,UpdateDate = GETDATE(),UpdateUser = @User ,
				CloseCls ,CloseDate ,CloseSupplierPIC ,SplitReffQty ,POMOQ ,POQtyBox
			From
				PO_Detail_Export
			Where 
				AffiliateID = @AffiliateID and SupplierID = @SupplierID and ForwarderID = @ForwarderID and PONo = @PoNo and OrderNo1 = @OrderNo and PartNo = @PartNo

			Insert into PO_DetailUpload_Export
			Select
				PONo ,AffiliateID ,SupplierID ,ForwarderID = @ForwarderIDSplit ,OrderNo1 = @OrderNoNew, PartNo ,Week1 = @QtyMOQ ,Week1Old = @QtyMOQ ,TotalPOQty = @QtyMOQ ,TotalPOQtyOld = @QtyMOQ ,
				EntryDate = GETDATE() ,EntryUser = @User ,UpdateDate = GETDATE() ,UpdateUser = @User 
			From
				PO_DetailUpload_Export
			Where
				AffiliateID = @AffiliateID and SupplierID = @SupplierID and ForwarderID = @ForwarderID and PONo = @PoNo and OrderNo1 = @OrderNo and PartNo = @PartNo
		End
	Else
		Begin
			Update	PO_Detail_Export
			SET		Week1		= Week1 + @QtyMOQ,
					TotalPOQty	= TotalPOQty + @QtyMOQ,
					UpdateDate	= GETDATE()
			Where	AffiliateID	= @AffiliateID and SupplierID = @SupplierID and ForwarderID = @ForwarderIDSplit and PONo = @PoNo and OrderNo1 = @OrderNoNew and PartNo = @PartNo

			Update	PO_DetailUpload_Export
			SET		Week1		= Week1 + @QtyMOQ,
					Week1Old	= Week1Old + @QtyMOQ,
					TotalPOQty	= TotalPOQty + @QtyMOQ,
					TotalPOQtyOld = TotalPOQtyOld + @QtyMOQ,
					UpdateDate	= GETDATE()
			Where	AffiliateID	= @AffiliateID and SupplierID = @SupplierID and ForwarderID = @ForwarderIDSplit and PONo = @PoNo and OrderNo1 = @OrderNoNew and PartNo = @PartNo
		End

--Kurangin di Masing Masing Detail
	Update	PO_Detail_Export
	SET		Week1		= Week1 - @QtyMOQ,
			TotalPOQty	= TotalPOQty - @QtyMOQ
	Where	AffiliateID	= @AffiliateID and SupplierID = @SupplierID and ForwarderID = @ForwarderID and PONo = @PoNo and OrderNo1 = @OrderNo and PartNo = @PartNo

	Update	PO_DetailUpload_Export
	SET		Week1		= Week1 - @QtyMOQ,
			Week1Old	= Week1Old - @QtyMOQ,
			TotalPOQty	= TotalPOQty - @QtyMOQ,
			TotalPOQtyOld = TotalPOQtyOld - @QtyMOQ
	Where	AffiliateID	= @AffiliateID and SupplierID = @SupplierID and ForwarderID = @ForwarderID and PONo = @PoNo and OrderNo1 = @OrderNo and PartNo = @PartNo


--Box
	Update	PrintLabelExport
	SET		OrderNo = @OrderNoNew,
			updatedate = GETDATE(),
			userupdate = @User
	WHERE	AffiliateID = @AffiliateID and SupplierID = @SupplierID and PONo = @PoNo and OrderNo = @OrderNo and PartNo = @PartNo and LabelNo = @LabelNo

--Jika Sudah 0 maka di Detail di Hapus
	Delete	PO_Detail_Export 
	Where	AffiliateID	= @AffiliateID and SupplierID = @SupplierID and ForwarderID = @ForwarderID and PONo = @PoNo and OrderNo1 = @OrderNo and PartNo = @PartNo and TotalPOQty = 0

	Delete	PO_DetailUpload_Export
	Where	AffiliateID	= @AffiliateID and SupplierID = @SupplierID and ForwarderID = @ForwarderID and PONo = @PoNo and OrderNo1 = @OrderNo and PartNo = @PartNo and TotalPOQty = 0

--Jika Di Detail sudah tidak ada maka Master di hapus
	IF Not Exists(Select top 1 PONo From PO_Detail_Export where AffiliateID = @AffiliateID and SupplierID = @SupplierID and ForwarderID = @ForwarderID and PONo = @PoNo and OrderNo1 = @OrderNo)
		Begin
			Delete	PO_Master_Export
			where	AffiliateID = @AffiliateID and SupplierID = @SupplierID and ForwarderID = @ForwarderID and PONo = @PoNo and OrderNo1 = @OrderNo

			Delete	PO_MasterUpload_Export
			where	AffiliateID = @AffiliateID and SupplierID = @SupplierID and ForwarderID = @ForwarderID and PONo = @PoNo and OrderNo1 = @OrderNo
		End
End











