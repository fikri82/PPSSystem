/****** Object:  Table [dbo].[DOSupplier_Detail_Export_History]    Script Date: 03/09/2023 11:21:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DOSupplier_Detail_Export_History]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DOSupplier_Detail_Export_History](
	[SuratJalanNo] [char](20) NOT NULL,
	[SupplierID] [char](20) NOT NULL,
	[AffiliateID] [char](20) NOT NULL,
	[PONo] [char](20) NOT NULL,
	[PartNo] [char](25) NOT NULL,
	[OrderNo] [char](20) NOT NULL,
	[SeqNo] [int] NOT NULL,
	[DOQty] [numeric](18, 2) NULL,
	[POMOQ] [numeric](18, 2) NULL,
	[POQtyBox] [numeric](18, 2) NULL,
	[Price] [numeric](18, 4) NULL,
	[DeletedDate] [datetime] NULL,
	[DeletedUser] [varchar](15) NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[DOSupplier_DetailBox_Export_History]    Script Date: 03/09/2023 11:21:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DOSupplier_DetailBox_Export_History]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DOSupplier_DetailBox_Export_History](
	[SuratJalanNo] [char](20) NOT NULL,
	[SupplierID] [char](20) NOT NULL,
	[AffiliateID] [char](20) NOT NULL,
	[PONo] [char](20) NOT NULL,
	[PartNo] [char](25) NOT NULL,
	[OrderNo] [char](20) NOT NULL,
	[BoxNo] [char](10) NOT NULL,
	[SeqNo] [int] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[DeletedUser] [varchar](15) NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[DOSupplier_Master_Export_History]    Script Date: 03/09/2023 11:21:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DOSupplier_Master_Export_History]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DOSupplier_Master_Export_History](
	[SuratJalanNo] [char](20) NOT NULL,
	[SupplierID] [char](20) NOT NULL,
	[AffiliateID] [char](20) NOT NULL,
	[PONo] [char](20) NOT NULL,
	[OrderNo] [char](20) NOT NULL,
	[DeliveryDate] [date] NULL,
	[PIC] [char](15) NULL,
	[JenisArmada] [char](15) NULL,
	[DriverName] [char](15) NULL,
	[DriverContact] [char](15) NULL,
	[NoPol] [char](10) NULL,
	[TotalBox] [numeric](18, 0) NULL,
	[EntryDate] [datetime] NULL,
	[EntryUser] [char](15) NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUser] [char](15) NULL,
	[ExcelCls] [char](1) NULL,
	[MovingList] [char](1) NULL,
	[SplitReffPONo] [char](20) NULL,
	[CommercialCls] [char](1) NULL,
	[SplitDelivery] [varchar](20) NULL,
	[SplitDeliverySeq] [int] NULL,
	[SJDeliveryOri] [varchar](20) NULL,
	[SplitCls] [char](1) NULL,
	[DeletedDate] [datetime] NULL,
	[DeletedUser] [varchar](15) NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ReceiveForwarder_Detail_History]    Script Date: 03/09/2023 11:21:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReceiveForwarder_Detail_History]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ReceiveForwarder_Detail_History](
	[SuratJalanNo] [char](20) NOT NULL,
	[SupplierID] [char](20) NOT NULL,
	[AffiliateID] [char](20) NOT NULL,
	[PONo] [char](20) NOT NULL,
	[PartNo] [char](25) NOT NULL,
	[OrderNo] [char](20) NOT NULL,
	[GoodRecQty] [numeric](18, 2) NULL,
	[DefectRecQty] [numeric](18, 2) NULL,
	[DeletedDate] [datetime] NULL,
	[DeletedUser] [varchar](15) NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ReceiveForwarder_DetailBox_History]    Script Date: 03/09/2023 11:21:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReceiveForwarder_DetailBox_History]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ReceiveForwarder_DetailBox_History](
	[SuratJalanNo] [varchar](20) NOT NULL,
	[SupplierID] [varchar](20) NOT NULL,
	[AffiliateID] [varchar](20) NOT NULL,
	[PONo] [varchar](20) NOT NULL,
	[OrderNo] [varchar](20) NOT NULL,
	[PartNo] [varchar](20) NOT NULL,
	[Label1] [varchar](20) NOT NULL,
	[Label2] [varchar](20) NOT NULL,
	[Box] [numeric](18, 0) NULL,
	[StatusDefect] [varchar](1) NOT NULL,
	[ExcelCls] [char](1) NULL,
	[DeletedDate] [datetime] NULL,
	[DeletedUser] [varchar](15) NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ReceiveForwarder_Master_History]    Script Date: 03/09/2023 11:21:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReceiveForwarder_Master_History]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ReceiveForwarder_Master_History](
	[SuratJalanNo] [char](20) NOT NULL,
	[AffiliateID] [char](20) NOT NULL,
	[SupplierID] [char](20) NOT NULL,
	[PONo] [char](20) NOT NULL,
	[ForwarderID] [char](20) NULL,
	[OrderNo] [char](20) NOT NULL,
	[ExcelCls] [char](1) NULL,
	[ReceiveDate] [datetime] NULL,
	[ReceiveBy] [char](15) NULL,
	[JenisArmada] [char](15) NULL,
	[DriverName] [char](15) NULL,
	[DriverContact] [char](15) NULL,
	[NoPol] [char](10) NULL,
	[TotalBox] [numeric](18, 2) NULL,
	[EntryDate] [datetime] NULL,
	[EntryUser] [char](15) NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUser] [char](15) NULL,
	[MovingList] [char](1) NULL,
	[SplitReffPONo] [char](20) NULL,
	[Remarks] [varchar](100) NULL,
	[DeletedDate] [datetime] NULL,
	[DeletedUser] [varchar](15) NULL
) ON [PRIMARY]
END
GO
