--<! JANGAN LUPA DI COMMIT DI BAWAH !>---

begin tran
	Delete ReceiveForwarder_Master		where PONo = 'OH3051'
	Delete ReceiveForwarder_Detail		where PONo = 'OH3051'
	Delete ReceiveForwarder_DetailBox	where PONo = 'OH3051'
	Delete DOSupplier_Master_Export		where PONo = 'OH3051'
	Delete DOSupplier_Detail_Export		where PONo = 'OH3051'
	Delete DOSupplier_DetailBox_Export	where PONo = 'OH3051'
	Delete PO_Master_Export				where PONo = 'OH3051'
	Delete PO_Detail_Export				where PONo = 'OH3051'
	Delete PrintLabelExport				where PONo = 'OH3051'
	Delete PO_MasterUpload_Export		where PONo = 'OH3051'
	Delete PO_DetailUpload_Export		where PONo = 'OH3051'

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	Insert into	ReceiveForwarder_Master
	Select * From xReceiveForwarder_Master where PONo = 'OH3051'

	Insert into	ReceiveForwarder_Detail
	Select * From xReceiveForwarder_Detail where PONo = 'OH3051'

	Insert into	ReceiveForwarder_DetailBox
	Select * From xReceiveForwarder_DetailBox where PONo = 'OH3051'
	
	Insert into	DOSupplier_Master_Export
	Select * From xDOSupplier_Master_Export where PONo = 'OH3051'

	Insert into	DOSupplier_Detail_Export
	Select * From xDOSupplier_Detail_Export where PONo = 'OH3051'

	Insert into	DOSupplier_DetailBox_Export
	Select * From xDOSupplier_DetailBox_Export where PONo = 'OH3051'

	Insert into	PO_Master_Export
	Select * From xPO_Master_Export where PONo = 'OH3051'

	Insert into	PO_Detail_Export
	Select * From xPO_Detail_Export where PONo = 'OH3051'

	Insert into	PrintLabelExport
	Select * From xPrintLabelExport where PONo = 'OH3051'

	Insert into	PO_MasterUpload_Export
	Select * From xPO_MasterUpload_Export where PONo = 'OH3051'

	Insert into	PO_DetailUpload_Export
	Select * From xPO_DetailUpload_Export where PONo = 'OH3051'

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	--Insert into	xDOSupplier_Master_Export
	--Select * From DOSupplier_Master_Export where PONo = 'OH3051'

	--Insert into	xDOSupplier_Detail_Export
	--Select * From DOSupplier_Detail_Export where PONo = 'OH3051'

	--Insert into	xDOSupplier_DetailBox_Export
	--Select * From DOSupplier_DetailBox_Export where PONo = 'OH3051'

	--Insert into	xPO_Master_Export
	--Select * From PO_Master_Export where PONo = 'OH3051'

	--Insert into	xPO_Detail_Export
	--Select * From PO_Detail_Export where PONo = 'OH3051'

	--Insert into	xPrintLabelExport
	--Select * From PrintLabelExport where PONo = 'OH3051'

	--Insert into	xPO_MasterUpload_Export
	--Select * From PO_MasterUpload_Export where PONo = 'OH3051'

	--Insert into	xPO_DetailUpload_Export
	--Select * From PO_DetailUpload_Export where PONo = 'OH3051'
commit tran



Begin Tran

DELETE PO_Master_Export				where PONo = 'NPX53054' and SupplierID = 'NIFCO'
DELETE PO_Detail_Export				where PONo = 'NPX53054' and SupplierID = 'NIFCO'
DELETE PrintLabelExport				where PONo = 'NPX53054' and SupplierID = 'NIFCO'

DELETE PO_MasterUpload_Export		where PONo = 'NPX53054' and SupplierID = 'NIFCO'
DELETE PO_DetailUpload_Export		where PONo = 'NPX53054' and SupplierID = 'NIFCO'

DELETE DOSupplier_Master_Export		where PONo = 'NPX53054' and SupplierID = 'NIFCO'
DELETE DOSupplier_Detail_Export		where PONo = 'NPX53054' and SupplierID = 'NIFCO'
DELETE DOSupplier_DetailBox_Export	where PONo = 'NPX53054' and SupplierID = 'NIFCO'
											  
DELETE ReceiveForwarder_Master		where PONo = 'NPX53054' and SupplierID = 'NIFCO'
DELETE ReceiveForwarder_Detail		where PONo = 'NPX53054' and SupplierID = 'NIFCO'
DELETE ReceiveForwarder_DetailBox	where PONo = 'NPX53054' and SupplierID = 'NIFCO'

Insert Into PO_Master_Export
Select * From Pasi_EBWEB2.dbo.PO_Master_Export				where PONo = 'NPX53054' and SupplierID = 'NIFCO'

Insert Into PO_Detail_Export
Select * From Pasi_EBWEB2.dbo.PO_Detail_Export				where PONo = 'NPX53054' and SupplierID = 'NIFCO'

Insert Into PrintLabelExport
Select * From Pasi_EBWEB2.dbo.PrintLabelExport				where PONo = 'NPX53054' and SupplierID = 'NIFCO'

Insert Into PO_MasterUpload_Export
Select * From Pasi_EBWEB2.dbo.PO_MasterUpload_Export		where PONo = 'NPX53054' and SupplierID = 'NIFCO'

Insert Into PO_DetailUpload_Export
Select * From Pasi_EBWEB2.dbo.PO_DetailUpload_Export		where PONo = 'NPX53054' and SupplierID = 'NIFCO'

Insert Into DOSupplier_Master_Export
Select * From Pasi_EBWEB2.dbo.DOSupplier_Master_Export		where PONo = 'NPX53054' and SupplierID = 'NIFCO'

Insert Into DOSupplier_Detail_Export
Select * From Pasi_EBWEB2.dbo.DOSupplier_Detail_Export		where PONo = 'NPX53054' and SupplierID = 'NIFCO'

Insert Into DOSupplier_DetailBox_Export
Select * From Pasi_EBWEB2.dbo.DOSupplier_DetailBox_Export	where PONo = 'NPX53054' and SupplierID = 'NIFCO'

Insert Into ReceiveForwarder_Master
Select * From Pasi_EBWEB2.dbo.ReceiveForwarder_Master		where PONo = 'NPX53054' and SupplierID = 'NIFCO'

Insert Into ReceiveForwarder_Detail
Select * From Pasi_EBWEB2.dbo.ReceiveForwarder_Detail		where PONo = 'NPX53054' and SupplierID = 'NIFCO'

Insert Into ReceiveForwarder_DetailBox
Select * From Pasi_EBWEB2.dbo.ReceiveForwarder_DetailBox	where PONo = 'NPX53054' and SupplierID = 'NIFCO'

commit Tran