ALTER TRIGGER [dbo].[TraceRFM_Exp]
    ON [dbo].[ReceiveForwarder_Master]
    FOR DELETE
AS	
	SET NOCOUNT ON
	IF NOT EXISTS (SELECT * FROM  master.INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'RFM_Exp')
	BEGIN
		CREATE TABLE master.dbo.[RFM_Exp](
			[SuratJalanNo] [char](20) NULL,[AffiliateID] [char](20) NULL,[SupplierID] [char](20) NULL,[PONo] [char](20) NULL,[ForwarderID] [char](20) NULL,[OrderNo] [char](20) NULL,
			[ExcelCls] [char](1) NULL, [ReceiveDate] [datetime] NULL,[ReceiveBy] [char](15) NULL,[JenisArmada] [char](15) NULL,[DriverName] [char](15) NULL,[DriverContact] [char](15) NULL,
			[NoPol] [char](10) NULL,[TotalBox] [numeric](18, 2) NULL,[EntryDate] [datetime] NULL,[EntryUser] [char](15) NULL,[UpdateDate] [datetime] NULL,[UpdateUser] [char](15) NULL,
			[MovingList] [char](1) NULL,[SplitReffPONo] [char](20) NULL, [Remarks] [varchar](100) NULL,
			[DeleteDate] [datetime] NULL, [UserDeleted] VARCHAR(MAX))
	END
	INSERT INTO master.dbo.[RFM_Exp] SELECT *,GETDATE(),(SELECT TOP 1 rtrim(hostname) + ' - ' + APP_NAME() FROM sys.sysprocesses WHERE spid = @@SPID) FROM Deleted
	SET NOCOUNT OFF
