ALTER PROCEDURE [dbo].[sp_DeliverySplitList_MovingDNSupplierReceiving]
	 @AffiliateID		As Varchar(20)
	,@SupplierID		As Varchar(20)
	,@ForwarderID		As Varchar(20)
	,@SuratJalan		As Varchar(20)
	,@PoNo				As Varchar(20)
	,@OrderNo			As Varchar(20)
	,@User				As Varchar(20)
AS
Begin
	Insert Into DOSupplier_Master_Export_History
	Select	
		*, GETDATE(), @User
	From	
		DOSupplier_Master_Export
	Where	
		AffiliateID	= @AffiliateID 
	and SupplierID	= @SupplierID
	and PONo		= @PoNo
	and OrderNo		= @OrderNo
	and SuratJalanNo= @SuratJalan

	Insert Into DOSupplier_Detail_Export_History
	Select	
		*, GETDATE(), @User
	From	
		DOSupplier_Detail_Export
	Where	
		AffiliateID	= @AffiliateID 
	and SupplierID	= @SupplierID
	and PONo		= @PoNo
	and OrderNo		= @OrderNo
	and SuratJalanNo= @SuratJalan

	Insert Into DOSupplier_DetailBox_Export_History
	Select	
		*, GETDATE(), @User
	From	
		DOSupplier_DetailBox_Export
	Where	
		AffiliateID	= @AffiliateID 
	and SupplierID	= @SupplierID
	and PONo		= @PoNo
	and OrderNo		= @OrderNo
	and SuratJalanNo= @SuratJalan

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	Insert Into ReceiveForwarder_Master_History
	Select
		*, GETDATE(), @User
	From
		ReceiveForwarder_Master
	Where
		AffiliateID	= @AffiliateID 
	and SupplierID	= @SupplierID
	and ForwarderID	= @ForwarderID
	and PONo		= @PoNo
	and OrderNo		= @OrderNo
	and SuratJalanNo= @SuratJalan

	Insert Into ReceiveForwarder_Detail_History
	Select
		*, GETDATE(), @User
	From
		ReceiveForwarder_Detail
	Where
		AffiliateID	= @AffiliateID 
	and SupplierID	= @SupplierID
	and PONo		= @PoNo
	and OrderNo		= @OrderNo
	and SuratJalanNo= @SuratJalan

	Insert Into ReceiveForwarder_DetailBox_History
	Select
		*, GETDATE(), @User
	From
		ReceiveForwarder_DetailBox
	Where
		AffiliateID	= @AffiliateID 
	and SupplierID	= @SupplierID
	and PONo		= @PoNo
	and OrderNo		= @OrderNo
	and SuratJalanNo= @SuratJalan
End