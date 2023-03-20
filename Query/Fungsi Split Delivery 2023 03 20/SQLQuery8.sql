--DECLARE @AffiliateID		varchar(20)	  = 'YKHT'
--DECLARE @SupplierID			varchar(20)	  = 'IKS'
--DECLARE @ForwarderID		varchar(20)	  = 'MKT1'
--DECLARE @ForwarderIDSplit	varchar(20)	  = 'RCA1'
--DECLARE @SuratJalan			varchar(20)	  = '432/IKS-SJ/II/23'
--DECLARE @PoNo				varchar(20)	  = 'OH3051'
--DECLARE @OrderNo			varchar(20)	  = 'OH3051'
--DECLARE @OrderNoNew			varchar(20)	  = 'OH3051-1'
--DECLARE @PartNo				varchar(25)	  = '7271-1483-3W'
--DECLARE @LabelNo			varchar(20)	  = 'HB0009506'
--DECLARE @QtyMOQ				numeric(18,2) = '20'
--DECLARE @User				varchar(20)	  = 'adminse'

--Select * From PO_Master_Export				where PONo = 'OH3051' and SupplierID = 'IKS' order by OrderNo1
--Select * From PO_Detail_Export				where PONo = 'OH3051' and SupplierID = 'IKS' and PartNo = @PartNo order by OrderNo1
--Select * From PrintLabelExport				where PONo = 'OH3051' and SupplierID = 'IKS' order by LabelNo 
--Select * From PO_MasterUpload_Export		where PONo = 'OH3051' and SupplierID = 'IKS' order by OrderNo1
--Select * From PO_DetailUpload_Export		where PONo = 'OH3051' and SupplierID = 'IKS' and PartNo = @PartNo order by OrderNo1
--select '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'

--Begin Tran
--exec sp_DeliverySplitList_InsUpd_PO @AffiliateID ,@SupplierID ,@ForwarderID ,@ForwarderIDSplit ,@SuratJalan ,@PoNo ,@OrderNo ,@OrderNoNew ,@PartNo ,@LabelNo ,@QtyMOQ ,@User
--exec sp_DeliverySplitList_InsUpd_PO @AffiliateID ,@SupplierID ,@ForwarderID ,@ForwarderIDSplit ,@SuratJalan ,@PoNo ,@OrderNo ,@OrderNoNew ,@PartNo ,'HB0009507' ,@QtyMOQ ,@User
--exec sp_DeliverySplitList_InsUpd_PO @AffiliateID ,@SupplierID ,@ForwarderID ,@ForwarderIDSplit ,@SuratJalan ,@PoNo ,@OrderNo ,@OrderNoNew ,@PartNo ,'HB0009509' ,@QtyMOQ ,@User
--exec sp_DeliverySplitList_InsUpd_PO @AffiliateID ,@SupplierID ,@ForwarderID ,@ForwarderIDSplit ,@SuratJalan ,@PoNo ,@OrderNo ,@OrderNoNew ,@PartNo ,'HB0009510' ,@QtyMOQ ,@User
--exec sp_DeliverySplitList_InsUpd_PO @AffiliateID ,@SupplierID ,@ForwarderID ,@ForwarderIDSplit ,@SuratJalan ,@PoNo ,@OrderNo ,@OrderNoNew ,@PartNo ,'HB0009511' ,@QtyMOQ ,@User
--exec sp_DeliverySplitList_InsUpd_PO @AffiliateID ,@SupplierID ,@ForwarderID ,@ForwarderIDSplit ,@SuratJalan ,@PoNo ,@OrderNo ,@OrderNoNew ,@PartNo ,'HB0009512' ,@QtyMOQ ,@User
--exec sp_DeliverySplitList_InsUpd_PO @AffiliateID ,@SupplierID ,@ForwarderID ,@ForwarderIDSplit ,@SuratJalan ,@PoNo ,@OrderNo ,@OrderNoNew ,@PartNo ,'HB0009515' ,@QtyMOQ ,@User
--exec sp_DeliverySplitList_InsUpd_PO @AffiliateID ,@SupplierID ,@ForwarderID ,@ForwarderIDSplit ,@SuratJalan ,@PoNo ,@OrderNo ,@OrderNoNew ,'7271-1484-3W' ,'HB0009645' ,24 ,@User
--exec sp_DeliverySplitList_InsUpd_PO @AffiliateID ,@SupplierID ,@ForwarderID ,@ForwarderIDSplit ,@SuratJalan ,@PoNo ,@OrderNo ,@OrderNoNew ,'7271-1484-3W' ,'HB0009647' ,24,@User
--exec sp_DeliverySplitList_InsUpd_PO @AffiliateID ,@SupplierID ,@ForwarderID ,@ForwarderIDSplit ,@SuratJalan ,@PoNo ,@OrderNo ,@OrderNoNew ,'7271-1484-3W' ,'HB0009648' ,24,@User

--Exec sp_DeliverySplitBatch_Select @AffiliateID, @SupplierID, @SuratJalan, @PoNo

--Select * From PO_Master_Export				where PONo = 'OH3051' and SupplierID = 'IKS' order by OrderNo1
--Select * From PO_Detail_Export				where PONo = 'OH3051' and SupplierID = 'IKS' and PartNo = '7271-1484-3W' order by OrderNo1
--Select * From PrintLabelExport				where PONo = 'OH3051' and SupplierID = 'IKS' order by LabelNo 
--Select * From PO_MasterUpload_Export		where PONo = 'OH3051' and SupplierID = 'IKS' order by OrderNo1
--Select * From PO_DetailUpload_Export		where PONo = 'OH3051' and SupplierID = 'IKS' and PartNo = @PartNo order by OrderNo1

--Rollback Tran

--select 'K2300921PAS'  SuratJalan,NULL SplitDelivery, NULL SplitDeliverySeq
--union ALL
--select 'K2300921PAS-1'SuratJalan,'K2300921PAS' SplitDelivery, 1 SplitDeliverySeq
--union ALL
--select 'K2300921PAS-2'SuratJalan,'K2300921PAS' SplitDelivery, 2 SplitDeliverySeq

--Declare @SJOri as varchar(max) = (SELECT Trim(ISNULL(SJDeliveryOri,SuratJalanNo)) FROM DOSupplier_Master_Export Where PONo = 'OH3051' AND AffiliateID = 'YKHT' And (SuratJalanNo = '432/IKS-SJ/II/23-1' or SJDeliveryOri = '432/IKS-SJ/II/23-1'))
--SELECT DISTINCT 
--	CAST(ISNULL(Seq,0)+1 AS VARCHAR) COUNT,
--	@SJOri + '-' + CAST(ISNULL(Seq,0)+1 AS VARCHAR) OrderNo
--FROM
--	(
--		SELECT PONo, AffiliateID, OrderNo, SuratJalanNo, SJDeliveryOri, SplitDeliverySeq Seq FROM DOSupplier_Master_Export Where PONo = 'OH3051' AND AffiliateID = 'YKHT' And (SuratJalanNo = '432/IKS-SJ/II/23-1' or SJDeliveryOri = '432/IKS-SJ/II/23-1')
--	) PO


----DELETE DOSupplier_Master_Export Where SuratJalanNo like '%XXX%'
----DELETE DOSupplier_Detail_Export Where SuratJalanNo like '%XXX%'
----DELETE DOSupplier_DetailBox_Export Where SuratJalanNo like '%XXX%'

--SELECT * FROM DOSupplier_Master_Export Where SuratJalanNo like '%OH3051%'
Exec sp_DeliverySplitBatch_Select_Detail_Moving 'YKHT', 'IKS', '432/IKS-SJ/II/23-2', '432/IKS-SJ/II/23', 'OH3051', 'OH3051-1' 

select * from MS_Notification order by Cast(NotificationCode as int)

Dear Sir/Madam,

This is notification Moving Good Receieving for:

select * from MS_Parts
select * from MS_UnitCls
Select * From PO_Master_Export				where PONo = 'OH3051' and SupplierID = 'IKS' order by OrderNo1
Select * From PO_Detail_Export				where PONo = 'OH3051' and SupplierID = 'IKS' order by OrderNo1
Select * From PrintLabelExport				where PONo = 'OH3051' and SupplierID = 'IKS' order by LabelNo 
Select * From PO_MasterUpload_Export		where PONo = 'OH3051' and SupplierID = 'IKS' order by OrderNo1
Select * From PO_DetailUpload_Export		where PONo = 'OH3051' and SupplierID = 'IKS' order by OrderNo1

Select * From DOSupplier_Master_Export		where PONo = 'OH3051' and SupplierID = 'IKS' order by OrderNo
Select * From DOSupplier_Detail_Export		where PONo = 'OH3051' and SupplierID = 'IKS' order by OrderNo
Select * From DOSupplier_DetailBox_Export	where PONo = 'OH3051' and SupplierID = 'IKS' order by OrderNo, BoxNo

Select * From ReceiveForwarder_Master		where PONo = 'OH3051' and SupplierID = 'IKS' order by OrderNo
Select * From ReceiveForwarder_Detail		where PONo = 'OH3051' and SupplierID = 'IKS' order by OrderNo
Select * From ReceiveForwarder_DetailBox	where PONo = 'OH3051' and SupplierID = 'IKS' order by OrderNo

Select * From DOSupplier_DetailBox_Export	where PONo = 'OH3051' and SupplierID = 'IKS' order by OrderNo, BoxNo
Select * From ReceiveForwarder_DetailBox	where PONo = 'OH3051' and SupplierID = 'IKS' order by OrderNo,Label1

Select * From DOSupplier_Master_Export		where PONo = 'OH3051' and SupplierID = 'IKS' order by OrderNo
Select Top 1 TRIM(SuratJalanNo) SuratJalan, TRIM(AffiliateID) AffID, TRIM(SupplierID) SuppID, TRIM(PONo) PoNo, TRIM(OrderNo) OrderNo, SplitDelivery SJDelivery, SJDeliveryOri From DOSupplier_Master_Export where SplitCls = 1


select * from ReceiveForwarder_DetailSeq where SuratJalanNo like '%23%' where PONo = 'OH3051'

select * from sys.objects where name = 'ReceiveForwarder_DetailSeq'

select * from ReceiveForwarder_DetailSeq where SuratJalanNo = 'PASI2111-123'
select * from ReceiveForwarder_Detail where SuratJalanNo = 'PASI2111-123'

select * from PO_Master_Export where PONo = 'VHP1123             '

select top 100 * from ReceiveForwarder_DetailSeq a inner join PO_Master_Export b on a.PONo = b.PONo order by b.EntryDate desc