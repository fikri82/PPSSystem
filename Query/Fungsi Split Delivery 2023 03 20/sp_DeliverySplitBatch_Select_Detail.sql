ALTER PROCEDURE [sp_DeliverySplitBatch_Select_Detail]
	 @AffiliateID	As Varchar(20)
	,@SupplierID	As Varchar(20)
	,@PoNo			As Varchar(20)
	,@OrderNo		As Varchar(20)
As 
Begin 
	--Exec sp_DeliverySplitBatch_Select_Detail 'YKHT', 'IKS', 'OH3051', 'OH3051-1'
	--Select * From PrintLabelExport where PONo = 'OH3051' and SupplierID = 'IKS' and OrderNo = 'OH3051-1' order by LabelNo 

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
		SeqNo		Int
	);

	IF OBJECT_ID('tempdb..#tmp') IS NOT NULL
	DROP TABLE #tmp

	Select
		No = ROW_NUMBER() Over(Order by (select 0)),
		* 
		into #tmp
	From	PrintLabelExport 
	where	PONo = @PoNo and SupplierID = @SupplierID and OrderNo = @OrderNo

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
			Select @tmpPONo, @tmpAfiliate, @tmpSupplier, @tmpPartNo, @tmpLabelNo, @tmpOrderNo, @seq

			SET @tmpLabeldue = @tmpLabelNo
			SET @row = @row + 1
		END

	select distinct 
		PartNo		= Trim(ISNULL(POD.PartNo,'')), 
		PartName	= Trim(ISNULL(MP.Partname,'')), 
		LabelNo		= PL.LabelFrom + ' - ' + pl.LabelTo,
		LabelNo1	= PL.LabelFrom, 
		LabelNo2	= PL.LabelTo, 
		UOM			= Trim(ISNULL(MUC.Description,'')),
		MOQ			= ISNULL(POD.POQtyBox,MPM.QtyBox),
		DelivQty	= PL.Jumlah * ISNULL(POD.POQtyBox,MPM.QtyBox), 
		TotalPOQty	= PL.Jumlah
    From 
		PO_Detail_Export POD INNER JOIN 
		(
			select	AffiliateID, SupplierID, PONo, OrderNo, PartNo, Count(PartNo) Jumlah, Min(LabelNo) LabelFrom, Max(LabelNo) LabelTo
			from	@tmpPrintLabel
			Group By AffiliateID, SupplierID, PONo, OrderNo, PartNo, SeqNo
		) PL ON PL.PONo = POD.PONo and PL.AffiliateID = POD.AffiliateID AND PL.SupplierID = POD.SupplierID AND PL.PartNO = POD.PartNo AND PL.orderNo = POD.OrderNo1 LEFT JOIN 
		MS_Parts MP ON MP.PartNo = POD.PartNo LEFT JOIN 
		MS_PartMapping MPM ON MPM.PartNo = POD.PartNo AND MPM.AffiliateID = POD.AffiliateID AND MPM.SupplierID = POD.SupplierID LEFT JOIN 
		MS_UnitCls MUC ON MUC.UnitCls = MP.UnitCls
    where 
		POD.AffiliateID = @AffiliateID
    AND POD.SupplierID	= @SupplierID
	AND POD.OrderNo1	= @OrderNo
	AND	POD.PONO		= @PoNo
End