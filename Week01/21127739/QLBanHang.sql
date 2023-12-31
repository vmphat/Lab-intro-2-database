USE [QLBanHang]
GO
/****** Object:  Table [dbo].[SAN_PHAM]    Script Date: 06/05/2023 19:07:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SAN_PHAM](
	[masp] [varchar](10) NOT NULL,
	[tensp] [nvarchar](30) NULL,
	[ngaysx] [date] NULL,
	[dongia] [decimal](8, 2) NULL,
 CONSTRAINT [PK_SAN_PHAM] PRIMARY KEY CLUSTERED 
(
	[masp] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[SAN_PHAM] ([masp], [tensp], [ngaysx], [dongia]) VALUES (N'SP001', N'Nước muối', CAST(0x86410B00 AS Date), CAST(20000.00 AS Decimal(8, 2)))
INSERT [dbo].[SAN_PHAM] ([masp], [tensp], [ngaysx], [dongia]) VALUES (N'SP002', N'Bút mực', CAST(0x90400B00 AS Date), CAST(12000.00 AS Decimal(8, 2)))
INSERT [dbo].[SAN_PHAM] ([masp], [tensp], [ngaysx], [dongia]) VALUES (N'SP003', N'Ly nước', CAST(0xB2400B00 AS Date), CAST(6000.00 AS Decimal(8, 2)))
INSERT [dbo].[SAN_PHAM] ([masp], [tensp], [ngaysx], [dongia]) VALUES (N'SP004', N'Thước kẻ', CAST(0xCC400B00 AS Date), CAST(5000.00 AS Decimal(8, 2)))
INSERT [dbo].[SAN_PHAM] ([masp], [tensp], [ngaysx], [dongia]) VALUES (N'SP005', N'Tập trắng', CAST(0x31410B00 AS Date), CAST(4000.00 AS Decimal(8, 2)))
INSERT [dbo].[SAN_PHAM] ([masp], [tensp], [ngaysx], [dongia]) VALUES (N'SP006', N'Kẹp giấy', CAST(0xED400B00 AS Date), CAST(2000.00 AS Decimal(8, 2)))
INSERT [dbo].[SAN_PHAM] ([masp], [tensp], [ngaysx], [dongia]) VALUES (N'SP007', N'Bút chì', CAST(0xED400B00 AS Date), CAST(2500.00 AS Decimal(8, 2)))
/****** Object:  Table [dbo].[KHACH_HANG]    Script Date: 06/05/2023 19:07:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[KHACH_HANG](
	[makh] [varchar](10) NOT NULL,
	[hoten] [nvarchar](30) NULL,
	[gioitinh] [nvarchar](10) NULL,
	[dthoai] [varchar](20) NULL,
	[diachi] [nvarchar](50) NULL,
 CONSTRAINT [PK_KHACH_HANG] PRIMARY KEY CLUSTERED 
(
	[makh] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[KHACH_HANG] ([makh], [hoten], [gioitinh], [dthoai], [diachi]) VALUES (N'KH001', N'Vũ Minh Phát', N'Nam', N'0909924274', N'1/2 Vạn Lộc')
INSERT [dbo].[KHACH_HANG] ([makh], [hoten], [gioitinh], [dthoai], [diachi]) VALUES (N'KH002', N'Đình Huy', N'Nam', N'0128327421', N'24 Hoàng Xuân')
INSERT [dbo].[KHACH_HANG] ([makh], [hoten], [gioitinh], [dthoai], [diachi]) VALUES (N'KH003', N'Ngọc Hoa', N'Nữ', N'0927981332', N'93/15 Camelte')
INSERT [dbo].[KHACH_HANG] ([makh], [hoten], [gioitinh], [dthoai], [diachi]) VALUES (N'KH004', N'Như Ý', N'Nữ', N'0185891923', N'81/51 Cô Bắc')
INSERT [dbo].[KHACH_HANG] ([makh], [hoten], [gioitinh], [dthoai], [diachi]) VALUES (N'KH005', N'Thu Hạ', N'Nữ', N'0884892393', N'2 Đồng Hoa')
INSERT [dbo].[KHACH_HANG] ([makh], [hoten], [gioitinh], [dthoai], [diachi]) VALUES (N'KH006', N'Lý Thắng', N'Nam', N'0928712423', N'2/4/6/8 Lam Sơn')
/****** Object:  Table [dbo].[HOA_DON]    Script Date: 06/05/2023 19:07:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HOA_DON](
	[mahd] [varchar](10) NOT NULL,
	[ngaylap] [date] NULL,
	[makh] [varchar](10) NULL,
 CONSTRAINT [PK_HOA_DON] PRIMARY KEY CLUSTERED 
(
	[mahd] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[HOA_DON] ([mahd], [ngaylap], [makh]) VALUES (N'HD001', CAST(0xAC410B00 AS Date), N'KH001')
INSERT [dbo].[HOA_DON] ([mahd], [ngaylap], [makh]) VALUES (N'HD002', CAST(0xAD410B00 AS Date), N'KH001')
INSERT [dbo].[HOA_DON] ([mahd], [ngaylap], [makh]) VALUES (N'HD003', CAST(0xC1410B00 AS Date), N'KH003')
INSERT [dbo].[HOA_DON] ([mahd], [ngaylap], [makh]) VALUES (N'HD004', CAST(0xC3410B00 AS Date), N'KH002')
INSERT [dbo].[HOA_DON] ([mahd], [ngaylap], [makh]) VALUES (N'HD005', CAST(0xC5410B00 AS Date), N'KH004')
INSERT [dbo].[HOA_DON] ([mahd], [ngaylap], [makh]) VALUES (N'HD006', CAST(0xF6410B00 AS Date), N'KH006')
/****** Object:  Table [dbo].[CT_HOA_DON]    Script Date: 06/05/2023 19:07:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CT_HOA_DON](
	[mahd] [varchar](10) NOT NULL,
	[masp] [varchar](10) NOT NULL,
	[soluong] [int] NULL,
	[dongia] [decimal](8, 2) NULL,
 CONSTRAINT [PK_CT_HOA_DON] PRIMARY KEY CLUSTERED 
(
	[mahd] ASC,
	[masp] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[CT_HOA_DON] ([mahd], [masp], [soluong], [dongia]) VALUES (N'HD001', N'SP001', 1, CAST(20000.00 AS Decimal(8, 2)))
INSERT [dbo].[CT_HOA_DON] ([mahd], [masp], [soluong], [dongia]) VALUES (N'HD002', N'SP002', 2, CAST(24000.00 AS Decimal(8, 2)))
INSERT [dbo].[CT_HOA_DON] ([mahd], [masp], [soluong], [dongia]) VALUES (N'HD003', N'SP004', 2, CAST(10000.00 AS Decimal(8, 2)))
INSERT [dbo].[CT_HOA_DON] ([mahd], [masp], [soluong], [dongia]) VALUES (N'HD004', N'SP003', 2, CAST(12000.00 AS Decimal(8, 2)))
INSERT [dbo].[CT_HOA_DON] ([mahd], [masp], [soluong], [dongia]) VALUES (N'HD005', N'SP006', 10, CAST(20000.00 AS Decimal(8, 2)))
INSERT [dbo].[CT_HOA_DON] ([mahd], [masp], [soluong], [dongia]) VALUES (N'HD006', N'SP005', 2, CAST(8000.00 AS Decimal(8, 2)))
/****** Object:  ForeignKey [FK_CT_HOA_DON_HOA_DON]    Script Date: 06/05/2023 19:07:32 ******/
ALTER TABLE [dbo].[CT_HOA_DON]  WITH CHECK ADD  CONSTRAINT [FK_CT_HOA_DON_HOA_DON] FOREIGN KEY([mahd])
REFERENCES [dbo].[HOA_DON] ([mahd])
GO
ALTER TABLE [dbo].[CT_HOA_DON] CHECK CONSTRAINT [FK_CT_HOA_DON_HOA_DON]
GO
/****** Object:  ForeignKey [FK_CT_HOA_DON_SAN_PHAM]    Script Date: 06/05/2023 19:07:32 ******/
ALTER TABLE [dbo].[CT_HOA_DON]  WITH CHECK ADD  CONSTRAINT [FK_CT_HOA_DON_SAN_PHAM] FOREIGN KEY([masp])
REFERENCES [dbo].[SAN_PHAM] ([masp])
GO
ALTER TABLE [dbo].[CT_HOA_DON] CHECK CONSTRAINT [FK_CT_HOA_DON_SAN_PHAM]
GO
/****** Object:  ForeignKey [FK_HOA_DON_KHACH_HANG]    Script Date: 06/05/2023 19:07:32 ******/
ALTER TABLE [dbo].[HOA_DON]  WITH CHECK ADD  CONSTRAINT [FK_HOA_DON_KHACH_HANG] FOREIGN KEY([makh])
REFERENCES [dbo].[KHACH_HANG] ([makh])
GO
ALTER TABLE [dbo].[HOA_DON] CHECK CONSTRAINT [FK_HOA_DON_KHACH_HANG]
GO
