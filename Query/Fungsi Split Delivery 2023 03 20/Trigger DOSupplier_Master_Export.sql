ALTER TRIGGER [dbo].[TraceDSM_Exp]
    ON [dbo].[DOSupplier_Master_Export]
    FOR DELETE
AS	
	SET NOCOUNT ON
	IF NOT EXISTS (SELECT * FROM  master.INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DSM_Exp')
	BEGIN
		CREATE TABLE master.dbo.[DSM_Exp](
			[SuratJalanNo] [char](20) NULL,[SupplierID] [char](20) NULL,[AffiliateID] [char](20) NULL,[PONo] [char](20) NULL,[OrderNo] [char](20) NULL,[DeliveryDate] [date] NULL,[PIC] [char](15) NULL,[JenisArmada] [char](15) NULL,[DriverName] [char](15) NULL,
			[DriverContact] [char](15) NULL,[NoPol] [char](10) NULL,[TotalBox] [numeric](18, 0) NULL,[EntryDate] [datetime] NULL,[EntryUser] [char](15) NULL,[UpdateDate] [datetime] NULL,[UpdateUser] [char](15) NULL,[ExcelCls] [char](1) NULL,[MovingList] [char](1) NULL,
			[SplitReffPONo] [char](20) NULL,[CommercialCls] [char](1) NULL,[SplitDelivery] [varchar](20) NULL,[SplitDeliverySeq] [int],[SJDeliveryOri] [varchar](20) NULL,[SplitlCls] [char](1) NULL,
			[DeleteDate] [datetime] NULL, [UserDeleted] VARCHAR(MAX))
	END
	INSERT INTO master.dbo.[DSM_Exp] SELECT *,GETDATE(),(SELECT TOP 1 rtrim(hostname) + ' - ' + APP_NAME() FROM sys.sysprocesses WHERE spid = @@SPID) FROM Deleted
	SET NOCOUNT OFF
