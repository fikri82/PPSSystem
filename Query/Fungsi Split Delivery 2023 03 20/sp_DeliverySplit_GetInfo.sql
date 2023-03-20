ALTER PROCEDURE [dbo].[sp_DeliverySplit_GetInfo]
	@Type	As Varchar(2) = NULL,
	@Param	As Varchar(MAX) = NULL,
	@Param2	As Varchar(MAX) = NULL,
	@Param3	As Varchar(MAX) = NULL,
	@Param4	As Varchar(MAX) = NULL,
	@Param5	As Varchar(MAX) = NULL
AS
Begin
	Declare @error as varchar(max) 

--Get Delivery Date
	IF @Type = '1'
	Begin
		Select	
			'Get Delivery Date', 
			Format(DeliveryDate, 'dd MMM yyyy')
		from
			DOSupplier_Master_Export 
		where
			AffiliateID	 = @Param
		And	SupplierID	 = @Param2
		And	SuratJalanNo = @Param3
		And	PONo		 = @Param4
		And	OrderNo		 = @Param5
	End

--Get Affiliate Name
	IF @Type = '2'
	Begin
		Select	
			'Get Affiliate Name', 
			Trim(AffiliateName)
		from
			MS_Affiliate
		where
			AffiliateID	 = @Param
	End

--Get Supplier Name
	IF @Type = '3'
	Begin
		Select	
			'Get Supplier Name', 
			Trim(SupplierName)
		from
			MS_Supplier
		where
			SupplierID	= @Param
	End

--Get Forwarder Name
	IF @Type = '4'
	Begin
		Select	
			'Get Forwarder Name', 
			Trim(ForwarderName)
		from	
			MS_Forwarder
		where
			ForwarderID	= @Param
	End

--Get Split Order No
	IF @Type = '5'
	Begin
		IF OBJECT_ID('tempdb..#tmp') IS NOT NULL
		DROP TABLE #tmp

		SELECT DISTINCT 
			ISNULL(COUNT (OrderNo1), 0) + 1 PO_COUNT,
			@Param + '-' + CAST(ISNULL(COUNT (OrderNo1), 0) + 1 AS VARCHAR) OrderNo
			into #tmp
		FROM
		(
			SELECT PONo, AffiliateID, OrderNo1 FROM PO_Master_Export
			UNION
			SELECT PONo, AffiliateID, OrderNo1 FROM PO_Master_ExportRecoverySplit
		)PO
		WHERE 
			PONo = @Param
		AND AffiliateID = @Param2
		AND OrderNo1 <> PONo

		IF Exists(Select * from PO_Master_Export a inner join #tmp b on a.OrderNo1 = b.OrderNo and a.AffiliateID = @Param2)
			Begin
				Update #tmp Set OrderNo = @Param + '-' + (Select Cast((PO_COUNT + 1) as varchar(max)) from #tmp)
			End

		IF Exists(Select * from PO_Master_Export a inner join #tmp b on a.OrderNo1 = b.OrderNo and a.AffiliateID = @Param2)
			Begin
				SET @error = (Select 'Split Order No ' + OrderNo + ' Already, Please Contact Your Administrator' From #tmp)
				Raiserror(@error, 16,1)
			End

		Select * From #tmp
	End

--Get Split Surat Jalan No
	IF @Type = '6'
	Begin
		Declare @SJOri as varchar(max) = (SELECT Top 1 Trim(ISNULL(SJDeliveryOri,SuratJalanNo)) FROM DOSupplier_Master_Export Where PONo = @Param AND AffiliateID = @Param2 And (SuratJalanNo = @Param3 or SplitDelivery = @Param3 or SJDeliveryOri = @Param3) order by SJDeliveryOri)
		
		IF Exists(SELECT Top 1 PONo, AffiliateID, OrderNo, SuratJalanNo, SJDeliveryOri, SplitDeliverySeq Seq FROM DOSupplier_Master_Export Where PONo = @Param AND AffiliateID = @Param2 And (SuratJalanNo = @Param3 or SplitDelivery = @Param3 or SJDeliveryOri = @SJOri) and SplitCls = 1)
		Begin
			SET @error = 'Split Order is Processing Another Surat Jalan Delivery. Please Wait some More Time ....'
			Raiserror(@error, 16,1)
		End

		IF OBJECT_ID('tempdb..#tmp2') IS NOT NULL
		DROP TABLE #tmp2

		SELECT DISTINCT 
			CAST(ISNULL(Seq,0)+1 AS VARCHAR) COUNT,
			@SJOri + '-' + CAST(ISNULL(Seq,0)+1 AS VARCHAR) SuratJalan
			into #tmp2
		FROM
			(
				SELECT Top 1 PONo, AffiliateID, OrderNo, SuratJalanNo, SJDeliveryOri, SplitDeliverySeq Seq FROM DOSupplier_Master_Export Where PONo = @Param AND AffiliateID = @Param2 And (SuratJalanNo = @Param3 or SplitDelivery = @Param3 or SJDeliveryOri = @SJOri) Order By Seq Desc
			) DO

		IF Exists(Select * from DOSupplier_Master_Export a inner join #tmp2 b on a.SuratJalanNo = b.SuratJalan)
			Begin
				SET @error = (Select 'Split Order No ' + SuratJalan + ' Already, Please Contact Your Administrator' From #tmp2)
				Raiserror(@error, 16,1)
			End

		Select * From #tmp2
	End

--Get Remarks
	IF @Type = '7'
	Begin
		Select 1 Type, Remarks = ISNULL(Remarks,'') From ReceiveForwarder_Master Where AffiliateID = @Param and SupplierID = @Param2 and PONo = @Param3 and OrderNo = @Param4 and SuratJalanNo = @Param5
	End
End