ALTER PROCEDURE [dbo].[sp_DeliverySplitList_Repair_DeliveryReceiving]
	 @AffiliateID		As Varchar(20)
	,@SupplierID		As Varchar(20)
	,@PoNo				As Varchar(20)
	,@OrderNo			As Varchar(20)
	,@SuratJalan		As Varchar(20)
As
Begin
	--Exec sp_DeliverySplitBatch_Select_Detail 'YKHT', 'IKS', 'OH3051', 'OH3051-1'
	--Select * From PrintLabelExport where PONo = 'OH3051' and SupplierID = 'IKS' and OrderNo = 'OH3051-1' order by LabelNo 

	--select Top 1 * from DOSupplier_Master_Export	where SuratJalanNo = '432/IKS-SJ/II/23' and PONo = 'OH3051'
	--select Top 1 * from DOSupplier_Detail_Export	where SuratJalanNo = '432/IKS-SJ/II/23' and PONo = 'OH3051'
	--select Top 1 * from DOSupplier_DetailBox_Export where SuratJalanNo = '432/IKS-SJ/II/23' and PONo = 'OH3051'

	--select Top 1 * from ReceiveForwarder_Master		where SuratJalanNo = '432/IKS-SJ/II/23' and PONo = 'OH3051'
	--select Top 1 * from ReceiveForwarder_Detail		where SuratJalanNo = '432/IKS-SJ/II/23' and PONo = 'OH3051'
	--select Top 1 * from ReceiveForwarder_DetailBox	where SuratJalanNo = '432/IKS-SJ/II/23' and PONo = 'OH3051'

	DECLARE @row INT DECLARE @rowEnd INT
	Declare @seq as int

	declare @tmpPrintLabel TABLE 
	(	
		PONo		Varchar(20),
		AffiliateID	Varchar(20),
		SupplierID	Varchar(20),
		PartNo		Varchar(25),
		LabelNo		Varchar(10),
		OrderNo		Varchar(20),
		MOQ			Numeric(18,2),
		Price		Numeric(18,4),
		SeqNo		Int
	);

	IF OBJECT_ID('tempdb..#tmp') IS NOT NULL
	DROP TABLE #tmp

	Select
		No = ROW_NUMBER() Over(Order by (select 0)),
		PL.*,
		MOQ		= DSD.MOQ,
		Price	= DSD.Price
		into #tmp
	From	PrintLabelExport PL Inner Join
			(
				Select	AffiliateID, SupplierID, PONo, OrderNo, PartNo, POMOQ As MOQ, Price
				From	DOSupplier_Detail_Export 
				Where	SuratJalanNo = @SuratJalan
				Group By AffiliateID, SupplierID, PONo, OrderNo, PartNo, POMOQ, Price
			) DSD on PL.AffiliateID = DSD.AffiliateID and PL.SupplierID = DSD.SupplierID and PL.PONo = DSD.PONo and PL.OrderNo = DSD.OrderNo and PL.PartNo = DSD.PartNo
	where	PL.AffiliateID = @AffiliateID and PL.SupplierID = @SupplierID and PL.PONo = @PoNo and PL.OrderNo = @OrderNo

	SET @row	= (Select Top 1 No from #tmp Order By No)
	SET @rowEnd = (Select Top 1 No from #tmp Order By No Desc)

	WHILE (@row <= @rowEnd)
		BEGIN
			Declare @tmpPONo	 Varchar(20) = (Select PONo			From #tmp Where No = @row)
			Declare @tmpAfiliate Varchar(20) = (Select AffiliateID	From #tmp Where No = @row)
			Declare @tmpSupplier Varchar(20) = (Select SupplierID	From #tmp Where No = @row)
			Declare @tmpPartNo	 Varchar(25) = (Select PartNo		From #tmp Where No = @row)
			Declare @tmpLabelNo	 Varchar(10) = (Select Trim(LabelNo)From #tmp Where No = @row)
			Declare @tmpOrderNo	 Varchar(20) = (Select OrderNo		From #tmp Where No = @row)
			Declare @tmpMOQ		 Numeric(18,2)= (Select MOQ			From #tmp Where No = @row)
			Declare @tmpPrice	 Numeric(18,4)= (Select Price		From #tmp Where No = @row)

			Declare @tmpLabeldue As Varchar(10)

			IF @row = 1 
				Begin 
					SET @tmpLabeldue = @tmpLabelNo
					SET @seq = 1
				END
			ELSE
				Begin
					SET @tmpLabeldue = Left(@tmpLabeldue,2) + Right(Cast(10000000 + Cast(Right(@tmpLabeldue,7)as int) + 1 as varchar(max)),7)
				END

			IF @tmpLabeldue = @tmpLabelNo
				Begin
					SET @seq = ISNULL((Select Top 1 SeqNo From @tmpPrintLabel Where PartNo = @tmpPartNo and OrderNo = @tmpOrderNo Order By SeqNo Desc),@seq)
				End
			ELSe IF @tmpLabeldue <> @tmpLabelNo
				Begin
					SET @seq = ISNULL((Select Top 1 SeqNo From @tmpPrintLabel Where PartNo = @tmpPartNo and OrderNo = @tmpOrderNo Order By SeqNo Desc),0) + 1
				End

			--print @tmpLabelNo + ' - Due : ' + @tmpLabeldue + ' / ' + Cast(@row as varchar(max)) + ' || ' + Cast(@seq as varchar(max))
			Insert Into @tmpPrintLabel
			Select @tmpPONo, @tmpAfiliate, @tmpSupplier, @tmpPartNo, @tmpLabelNo, @tmpOrderNo, @tmpMOQ, @tmpPrice, @seq

			SET @tmpLabeldue = @tmpLabelNo
			SET @row = @row + 1
		END
	
	Delete	DOSupplier_Detail_Export
	Where	AffiliateID = @AffiliateID and SupplierID = @SupplierID and PONo = @PoNo and OrderNo = @OrderNo and SuratJalanNo = @SuratJalan

	Delete	DOSupplier_DetailBox_Export
	Where	AffiliateID = @AffiliateID and SupplierID = @SupplierID and PONo = @PoNo and OrderNo = @OrderNo and SuratJalanNo = @SuratJalan

	Delete	ReceiveForwarder_Detail
	Where	AffiliateID = @AffiliateID and SupplierID = @SupplierID and PONo = @PoNo and OrderNo = @OrderNo and SuratJalanNo = @SuratJalan

	Delete	ReceiveForwarder_DetailBox
	Where	AffiliateID = @AffiliateID and SupplierID = @SupplierID and PONo = @PoNo and OrderNo = @OrderNo and SuratJalanNo = @SuratJalan
	

--Do Supplier Detail
	Insert Into DOSupplier_Detail_Export
	Select	@SuratJalan, SupplierID, AffiliateID, PONo, PartNo, OrderNo, SeqNo, Count(*) * MOQ DoQty, MOQ, MOQ, Price Price
	From	@tmpPrintLabel
	Group By SupplierID, AffiliateID, PONo, PartNo, OrderNo, SeqNo, MOQ, Price

--Do Supplier Detail Box
	Insert Into DOSupplier_DetailBox_Export
	Select	@SuratJalan, SupplierID, AffiliateID, PONo, PartNo, OrderNo, LabelNo, SeqNo
	From	@tmpPrintLabel 

--Receive Detail
	Insert Into ReceiveForwarder_Detail
	Select	@SuratJalan, SupplierID, AffiliateID, PONo, PartNo, OrderNo, Count(*) * MOQ GoodRec, 0
	From	@tmpPrintLabel 
	Group By SupplierID, AffiliateID, PONo, PartNo, OrderNo, MOQ

--Receive Detail Box
	Insert Into ReceiveForwarder_DetailBox
	Select	@SuratJalan, SupplierID, AffiliateID, PONo, OrderNo, PartNo, Min(LabelNo) LabelFrom, Max(LabelNo) LabelTo, Count(*) Jumlah, 0, NULL
	From	@tmpPrintLabel 
	Group By SupplierID, AffiliateID, PONo, PartNo, OrderNo, SeqNo

--DELETED MASTER JIKA tidak ada di Detail
	IF Not Exists(Select top 1 * From DOSupplier_Detail_Export Where AffiliateID = @AffiliateID and SupplierID = @SupplierID and PONo = @PoNo and OrderNo = @OrderNo and SuratJalanNo = @SuratJalan)
		Begin			
			Delete DOSupplier_Master_Export Where AffiliateID = @AffiliateID and SupplierID = @SupplierID and PONo = @PoNo and OrderNo = @OrderNo and SuratJalanNo = @SuratJalan
		End
		
	IF Not Exists(Select top 1 * From ReceiveForwarder_Detail Where AffiliateID = @AffiliateID and SupplierID = @SupplierID and PONo = @PoNo and OrderNo = @OrderNo and SuratJalanNo = @SuratJalan)
		Begin
			Delete ReceiveForwarder_Master Where AffiliateID = @AffiliateID and SupplierID = @SupplierID and PONo = @PoNo and OrderNo = @OrderNo and SuratJalanNo = @SuratJalan
		End
End