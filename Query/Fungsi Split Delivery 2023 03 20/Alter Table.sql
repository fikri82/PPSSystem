alter table DOSupplier_Master_Export add SplitDelivery		Varchar(20)
alter table DOSupplier_Master_Export add SplitDeliverySeq	Int
alter table DOSupplier_Master_Export add SJDeliveryOri		Varchar(20)
alter table DOSupplier_Master_Export add SplitCls			Char(1)

alter table PO_Master_Export		 add SplitDelivery		Varchar(20)
alter table PO_Master_Export		 add SplitForwarder		Varchar(20)

alter table ReceiveForwarder_Master	 add Remarks			Varchar(100)