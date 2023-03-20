ALTER PROCEDURE [dbo].[sp_DeliverySplitList_InsUpd_DeliveryReceiving] 
	 @AffiliateID		As Varchar(20)
	,@SupplierID		As Varchar(20)
	,@ForwarderID		As Varchar(20)
	,@ForwarderIDSplit	As Varchar(20)
	,@SuratJalan		As Varchar(20)
	,@SuratJalanSplit	As Varchar(20)
	,@PoNo				As Varchar(20)
	,@OrderNo			As Varchar(20)
	,@OrderNoNew		As Varchar(20)
	,@PartNo			As Varchar(25)
	,@LabelNo			As Varchar(20)
	,@Remarks			As Varchar(100)
	,@QtyMOQ			As Numeric(18,2)
	,@User				As Varchar(20)
As
Begin
	--select Top 1 * from DOSupplier_Master_Export	where SuratJalanNo = '432/IKS-SJ/II/23' and PONo = 'OH3051'
	--select Top 1 * from DOSupplier_Detail_Export	where SuratJalanNo = '432/IKS-SJ/II/23' and PONo = 'OH3051'
	--select Top 1 * from DOSupplier_DetailBox_Export where SuratJalanNo = '432/IKS-SJ/II/23' and PONo = 'OH3051'

	--select Top 1 * from ReceiveForwarder_Master		where SuratJalanNo = '432/IKS-SJ/II/23' and PONo = 'OH3051'
	--select Top 1 * from ReceiveForwarder_Detail		where SuratJalanNo = '432/IKS-SJ/II/23' and PONo = 'OH3051'
	--select Top 1 * from ReceiveForwarder_DetailBox	where SuratJalanNo = '432/IKS-SJ/II/23' and PONo = 'OH3051'

	--Update ke Print Label Jangan Lupa
	Update	PrintLabelExport
	SET		SuratJalanNo_FWD = @SuratJalanSplit
	Where	AffiliateID = @AffiliateID and SupplierID = @SupplierID and PONo = @PoNo and OrderNo = @OrderNoNew

	Declare @Seq as int
	Declare @OldLabelBox as varchar(max)
	DECLARE @tmpLabelBoxdue as varchar(max)

	select Top 1 
		@Seq = SeqNo,
		@OldLabelBox = BoxNo
	from	
		DOSupplier_DetailBox_Export 
	where	
		AffiliateID = @AffiliateID and SupplierID = @SupplierID and SuratJalanNo = @SuratJalanSplit and PONo = @PoNo and OrderNo = @OrderNoNew and PartNo = @PartNo 
	Order By 
		BoxNo Desc

	IF @Seq IS NULL
		Begin
			SET @Seq = 1
		End
	Else
		Begin
			SET @tmpLabelBoxdue = Left(@OldLabelBox,2) + Right(Cast(10000000 + Cast(Right(@OldLabelBox,7)as int) + 1 as varchar(max)),7)

			IF @tmpLabelBoxdue <> @LabelNo
			Begin
				SET @Seq = @Seq + 1
			End
		End

--Master
	IF Not Exists(Select Top 1 * From DOSupplier_Master_Export Where AffiliateID = @AffiliateID and SupplierID = @SupplierID and PONo = @PoNo and OrderNo = @OrderNoNew and SuratJalanNo = @SuratJalanSplit)
		Begin
			Declare @SJOri	as Varchar(Max) = (SELECT Top 1 ISNULL(SJDeliveryOri, SuratJalanNo) FROM DOSupplier_Master_Export Where PONo = @PoNo AND AffiliateID = @AffiliateID And (SuratJalanNo = @SuratJalan or SplitDelivery = @SuratJalan or SJDeliveryOri = @SuratJalan) Order By SJDeliveryOri)
			Declare @SJseq	as int			= (SELECT Top 1 ISNULL(SplitDeliverySeq,0) + 1		FROM DOSupplier_Master_Export Where PONo = @PoNo AND AffiliateID = @AffiliateID And (SuratJalanNo = @SuratJalan or SplitDelivery = @SuratJalan or SJDeliveryOri = @SJOri) Order By ISNULL(SplitDeliverySeq,0) Desc)

			Insert Into DOSupplier_Master_Export
			Select
				SuratJalanNo = @SuratJalanSplit ,SupplierID ,AffiliateID ,PONo ,OrderNo = @OrderNoNew ,DeliveryDate ,PIC ,JenisArmada ,DriverName ,DriverContact ,NoPol ,TotalBox ,
				EntryDate = GETDATE() ,EntryUser = @User ,UpdateDate = GETDATE() ,UpdateUser = @User ,ExcelCls ,MovingList ,SplitReffPONo ,CommercialCls ,
				SplitDelivery = @SuratJalan ,SplitDeliverySeq = @SJseq ,SJDeliveryOri = @SJOri, SplitCls = 1
			From
				DOSupplier_Master_Export
			Where
				AffiliateID = @AffiliateID and SupplierID = @SupplierID and PONo = @PoNo and OrderNo = @OrderNo and SuratJalanNo = @SuratJalan

			Insert Into ReceiveForwarder_Master
			Select
				SuratJalanNo = @SuratJalanSplit ,AffiliateID ,SupplierID ,PONo ,ForwarderID = @ForwarderIDSplit ,OrderNo = @OrderNoNew ,ExcelCls ,ReceiveDate ,ReceiveBy ,JenisArmada ,DriverName ,DriverContact ,NoPol ,TotalBox ,
				EntryDate = GETDATE() ,EntryUser = @User ,UpdateDate = GETDATE() ,UpdateUser = @User ,MovingList ,SplitReffPONo ,Remarks = @Remarks
			From
				ReceiveForwarder_Master
			Where
				AffiliateID = @AffiliateID and SupplierID = @SupplierID and ForwarderID = @ForwarderID and PONo = @PoNo and OrderNo = @OrderNo and SuratJalanNo = @SuratJalan
		End

--Detail DO
print @Seq
	IF Not Exists(Select Top 1 * From DOSupplier_Detail_Export Where AffiliateID = @AffiliateID and SupplierID = @SupplierID and PONo = @PoNo and OrderNo = @OrderNoNew and SuratJalanNo = @SuratJalanSplit and PartNo = @PartNo and SeqNo = @Seq)
		Begin
			Insert Into DOSupplier_Detail_Export
			Select Top 1
				SuratJalanNo = @SuratJalanSplit ,SupplierID ,AffiliateID ,PONo ,PartNo ,OrderNo = @OrderNoNew ,SeqNo = @Seq,DOQty = @QtyMOQ ,POMOQ ,POQtyBox ,Price
			From
				DOSupplier_Detail_Export
			Where
				AffiliateID = @AffiliateID and SupplierID = @SupplierID and PONo = @PoNo and OrderNo = @OrderNo and SuratJalanNo = @SuratJalan and PartNo = @PartNo
		End
	Else
		Begin
			Update	DOSupplier_Detail_Export
			SET		DOQty = DOQty + @QtyMOQ
			Where	AffiliateID = @AffiliateID and SupplierID = @SupplierID and PONo = @PoNo and OrderNo = @OrderNoNew and SuratJalanNo = @SuratJalanSplit and PartNo = @PartNo and SeqNo = @Seq
		End

--Detail Receive
	IF Not Exists(Select Top 1 * From ReceiveForwarder_Detail where AffiliateID = @AffiliateID and SupplierID = @SupplierID and PONo = @PoNo and OrderNo = @OrderNoNew and SuratJalanNo = @SuratJalanSplit and PartNo = @PartNo)
		Begin
			Insert Into ReceiveForwarder_Detail
			Select
				SuratJalanNo = @SuratJalanSplit ,SupplierID ,AffiliateID ,PONo ,PartNo ,OrderNo = @OrderNoNew ,GoodRecQty = @QtyMOQ ,DefectRecQty
			From
				ReceiveForwarder_Detail
			where 
				AffiliateID = @AffiliateID and SupplierID = @SupplierID and PONo = @PoNo and OrderNo = @OrderNo and SuratJalanNo = @SuratJalan and PartNo = @PartNo
		End
	Else
		Begin
			Update	ReceiveForwarder_Detail
			SET		GoodRecQty = GoodRecQty + @QtyMOQ
			where	AffiliateID = @AffiliateID and SupplierID = @SupplierID and PONo = @PoNo and OrderNo = @OrderNoNew and SuratJalanNo = @SuratJalanSplit and PartNo = @PartNo
		End

--Detail Box DO
	Update	DOSupplier_DetailBox_Export
	SET		OrderNo = @OrderNoNew,
			SuratJalanNo = @SuratJalanSplit, 
			SeqNo = @Seq
	Where	AffiliateID = @AffiliateID and SupplierID = @SupplierID and PONo = @PoNo and OrderNo = @OrderNo and SuratJalanNo = @SuratJalan and PartNo = @PartNo and BoxNo = @LabelNo

--Detail Box Receive
	Declare @tmpLabel1 as varchar(max) = (Select Top 1 Label1 From ReceiveForwarder_DetailBox where AffiliateID = @AffiliateID and SupplierID = @SupplierID and PONo = @PoNo and OrderNo = @OrderNoNew and SuratJalanNo = @SuratJalanSplit and PartNo = @PartNo Order By Label1 Desc)
	Declare @New As int = 0 -- 0 New Records || 1 Continue
	
	IF @tmpLabelBoxdue = @LabelNo
		Begin
			SET @New = 1
		End

	IF Not Exists(Select Top 1 * From ReceiveForwarder_DetailBox where AffiliateID = @AffiliateID and SupplierID = @SupplierID and PONo = @PoNo and OrderNo = @OrderNoNew and SuratJalanNo = @SuratJalanSplit and PartNo = @PartNo)
		Begin
			Insert Into ReceiveForwarder_DetailBox
			Select
				SuratJalanNo = @SuratJalanSplit ,SupplierID = @SupplierID ,AffiliateID = @AffiliateID ,PONo = @PoNo ,OrderNo = @OrderNoNew ,PartNo = @PartNo,
				Label1 = @LabelNo ,Label2 = @LabelNo ,Box = 1, StatusDefect = 0 ,ExcelCls = NULL
		End
	Else
		Begin
			IF @New = 0
				Begin
					Insert Into ReceiveForwarder_DetailBox
					Select
						SuratJalanNo = @SuratJalanSplit ,SupplierID = @SupplierID ,AffiliateID = @AffiliateID ,PONo = @PoNo ,OrderNo = @OrderNoNew ,PartNo = @PartNo,
						Label1 = @LabelNo ,Label2 = @LabelNo ,Box = 1, StatusDefect = 0 ,ExcelCls = NULL
				End
			Else
				Begin
					UPDATE	ReceiveForwarder_DetailBox
					SET		Label2 = @LabelNo,
							Box = Box + 1
					where	AffiliateID = @AffiliateID and SupplierID = @SupplierID and PONo = @PoNo and OrderNo = @OrderNoNew and SuratJalanNo = @SuratJalanSplit and PartNo = @PartNo and Label1 = @tmpLabel1
				End
		End
End
