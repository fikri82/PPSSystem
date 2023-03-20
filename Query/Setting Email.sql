--<! JANGAN LUPA di COMMIT DI BAWAH !>--

Begin Tran

--Supplier
Declare @Email_1 as varchar(max) = 'fikri@tos.co.id'

--Forwarder
Declare @Email_2 as varchar(max) = 'fikri@tos.co.id'

--Affiliate
Declare @Email_3 as varchar(max) = 'fikri@tos.co.id'

--Supplier
Declare @Email_4 as varchar(max) = 'fikri@tos.co.id'

--PASI
Declare @Email_5 as varchar(max) = 'fikri@tos.co.id'

--PASI Export
Declare @Email_6 as varchar(max) = 'fikri@tos.co.id'

Update	MS_EmailSupplier_Export
SET		AffiliatePOTO			= @Email_1,
		AffiliatePOCC			= @Email_1,
		AffiliatePORevisionTO	= @Email_1,
		AffiliatePORevisionCC	= @Email_1,
		KanbanTO				= @Email_1,
		KanbanCC				= @Email_1,
		SupplierDeliveryTO		= @Email_1,
		SupplierDeliveryCC		= @Email_1,
		PASIReceivingTO			= @Email_1,
		PASIReceivingCC			= @Email_1,
		AffiliateReceivingTO	= @Email_1,
		AffiliateReceivingCC	= @Email_1,
		GoodReceiveTO			= @Email_1,
		GoodReceiveCC			= @Email_1,
		InvoiceTO				= @Email_1,
		InvoiceCC				= @Email_1,
		SummaryOutstandingTO	= @Email_1,
		SummaryOutstandingCC	= @Email_1
Update	MS_EmailForwarder				
SET		ForwarderReceivingTO	= @Email_2,
		ForwarderReceivingCC	= @Email_2,
		POExportTO				= @Email_2,
		POExportCC				= @Email_2,
		PORevisionTO			= @Email_2,
		PORevisionCC			= @Email_2,
		SupplierDeliveryTO		= @Email_2,
		SupplierDeliveryCC		= @Email_2
Update	MS_EmailAffiliate				
SET		AffiliatePOTO			= @Email_3,
		AffiliatePOCC			= @Email_3,
		AffiliatePORevisionTO	= @Email_3,
		AffiliatePORevisionCC	= @Email_3,
		KanbanTO				= @Email_3,
		KanbanCC				= @Email_3,
		SupplierDeliveryTO		= @Email_3,
		SupplierDeliveryCC		= @Email_3,
		PASIReceivingTO			= @Email_3,
		PASIReceivingCC			= @Email_3,
		AffiliateReceivingTO	= @Email_3,
		AffiliateReceivingCC	= @Email_3,
		GoodReceiveTO			= @Email_3,
		GoodReceiveCC			= @Email_3,
		InvoiceTO				= @Email_3,
		InvoiceCC				= @Email_3,
		SummaryOutstandingTO	= @Email_3,
		SummaryOutstandingCC	= @Email_3
Update	MS_EmailSupplier				
SET		AffiliatePOTO			= @Email_4,
		AffiliatePOCC			= @Email_4,
		AffiliatePORevisionTO	= @Email_4,
		AffiliatePORevisionCC	= @Email_4,
		KanbanTO				= @Email_4,
		KanbanCC				= @Email_4,
		SupplierDeliveryTO		= @Email_4,
		SupplierDeliveryCC		= @Email_4,
		PASIReceivingTO			= @Email_4,
		PASIReceivingCC			= @Email_4,
		AffiliateReceivingTO	= @Email_4,
		AffiliateReceivingCC	= @Email_4,
		GoodReceiveTO			= @Email_4,
		GoodReceiveCC			= @Email_4,
		InvoiceTO				= @Email_4,
		InvoiceCC				= @Email_4,
		SummaryOutstandingTO	= @Email_4,
		SummaryOutstandingCC	= @Email_4
Update	MS_EmailPASI					
SET		AffiliatePOTO			= @Email_5,
		AffiliatePOCC			= @Email_5,
		AffiliatePORevisionTO	= @Email_5,
		AffiliatePORevisionCC	= @Email_5,
		KanbanTO				= @Email_5,
		KanbanCC				= @Email_5,
		SupplierDeliveryTO		= @Email_5,
		SupplierDeliveryCC		= @Email_5,
		PASIReceivingTO			= @Email_5,
		PASIReceivingCC			= @Email_5,
		AffiliateReceivingTO	= @Email_5,
		AffiliateReceivingCC	= @Email_5,
		GoodReceiveTO			= @Email_5,
		GoodReceiveCC			= @Email_5,
		InvoiceTO				= @Email_5,
		InvoiceCC				= @Email_5,
		SummaryOutstandingTO	= @Email_5,
		SummaryOutstandingCC	= @Email_5
Update	MS_EmailPASI_EXPORT				
SET		AffiliatePOCC			= @Email_6,
		AffiliatePORevisionCC	= @Email_6,
		SupplierDeliveryCC		= @Email_6,
		GoodReceiveCC			= @Email_6,
		InvoiceCC				= @Email_6,
		SummaryOutstandingCC	= @Email_6

Rollback Tran