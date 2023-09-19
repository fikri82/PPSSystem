Imports System.Data.SqlClient
Imports DevExpress.Web.ASPxGridView
Imports System.Drawing
Imports System.Globalization

Public Class clsDeliverySplitExport
    Public Property DeliveryDate As String
    Public Property AffiliateID As String
    Public Property SupplierID As String
    Public Property SuratJalanNo As String
    Public Property SuratJalanNoNew As String
    Public Property ForwarderID As String
    Public Property ForwarderID_Split As String
    Public Property PoNo As String
    Public Property OrderNo As String
    Public Property PartNo As String
    Public Property LabelBox As String
    Public Property Remarks As String
    Public Property Qty As Integer
    Public Property MOQ As Integer
    Public Property ColIndex As String
    Public Property User As String
End Class

Public Class clsDeliverySplitExportDB
    
    Public Shared Function GetDataDetail(ByVal constr As String, ByVal cls As clsDeliverySplitExport) As DataTable
        Dim ls_SQL As String = "sp_DeliverySplitList_Select"
        Dim dt As New DataTable
        Dim tmpTime As DateTime

        Using sqlConn As New SqlConnection(constr)
            sqlConn.Open()

            Dim cmd As New SqlCommand(ls_SQL, sqlConn)
            cmd.CommandType = CommandType.StoredProcedure

            If DateTime.TryParseExact(cls.DeliveryDate, "dd MMM yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, tmpTime) Then
                cmd.Parameters.AddWithValue("DeliveryDate", tmpTime.ToString("yyyy-MM-dd"))
            End If
            cmd.Parameters.AddWithValue("PoNo", cls.PoNo)
            cmd.Parameters.AddWithValue("OrderNo", cls.OrderNo)
            cmd.Parameters.AddWithValue("SuratJalan", cls.SuratJalanNo)
            cmd.Parameters.AddWithValue("Affiliate", cls.AffiliateID)
            cmd.Parameters.AddWithValue("Supplier", cls.SupplierID)
            cmd.Parameters.AddWithValue("Forwarder", cls.ForwarderID)
            cmd.Parameters.AddWithValue("IndexCol", cls.ColIndex)

            Dim da As New SqlDataAdapter(cmd)
            da.Fill(dt)
            sqlConn.Close()

            Return dt
        End Using
    End Function

    Public Shared Function GetInfo(constr As String, Type As String, Optional Param As String = "", Optional Param2 As String = "", Optional Param3 As String = "", Optional Param4 As String = "", Optional Param5 As String = "") As String
        Dim ls_sql As String = ""
        Dim dt As New DataTable

        ls_sql = "sp_DeliverySplit_GetInfo"
        Using sqlConn As New SqlConnection(constr)
            sqlConn.Open()

            Dim sqlcomm As New SqlCommand(ls_sql, sqlConn)
            sqlcomm.CommandType = CommandType.StoredProcedure
            sqlcomm.Parameters.AddWithValue("Type", Type)
            If Param <> "" Then sqlcomm.Parameters.AddWithValue("Param", Param)
            If Param2 <> "" Then sqlcomm.Parameters.AddWithValue("Param2", Param2)
            If Param3 <> "" Then sqlcomm.Parameters.AddWithValue("Param3", Param3)
            If Param4 <> "" Then sqlcomm.Parameters.AddWithValue("Param4", Param4)
            If Param5 <> "" Then sqlcomm.Parameters.AddWithValue("Param5", Param5)

            Dim sqlDA As New SqlDataAdapter(sqlcomm)
            sqlDA.Fill(dt)
            sqlConn.Close()

            If dt.Rows.Count = 0 Then
                Return ""
            Else
                Return dt.Rows(0)(1).ToString()
            End If
        End Using
    End Function

    Public Sub DeleteDNSupplier(constr As String, cls As clsDeliverySplitExport)
        Dim ls_sql As String = ""
        Dim dt As New DataTable

        ls_sql = "sp_DeliverySplitList_DeleteDNSupplier"
        Using sqlConn As New SqlConnection(constr)
            sqlConn.Open()

            Dim sqlcomm As New SqlCommand(ls_sql, sqlConn)
            With sqlcomm
                .CommandType = CommandType.StoredProcedure
                .Parameters.AddWithValue("AffiliateID", cls.AffiliateID)
                .Parameters.AddWithValue("SupplierID", cls.SupplierID)
                .Parameters.AddWithValue("ForwarderID", cls.ForwarderID)
                .Parameters.AddWithValue("SuratJalan", cls.SuratJalanNo)
                .Parameters.AddWithValue("PoNo", cls.PoNo)
                .Parameters.AddWithValue("OrderNo", cls.OrderNo)
                .Parameters.AddWithValue("User", cls.User)

                .ExecuteNonQuery()
            End With
        End Using
    End Sub

    Public Sub MoveDNSupplierReceiving(constr As String, cls As clsDeliverySplitExport)
        Dim ls_sql As String = ""
        Dim dt As New DataTable

        ls_sql = "sp_DeliverySplitList_MovingDNSupplierReceiving"
        Using sqlConn As New SqlConnection(constr)
            sqlConn.Open()

            Dim sqlcomm As New SqlCommand(ls_sql, sqlConn)
            With sqlcomm
                .CommandType = CommandType.StoredProcedure
                .Parameters.AddWithValue("AffiliateID", cls.AffiliateID)
                .Parameters.AddWithValue("SupplierID", cls.SupplierID)
                .Parameters.AddWithValue("ForwarderID", cls.ForwarderID)
                .Parameters.AddWithValue("SuratJalan", cls.SuratJalanNo)
                .Parameters.AddWithValue("PoNo", cls.PoNo)
                .Parameters.AddWithValue("OrderNo", cls.OrderNo)
                .Parameters.AddWithValue("User", cls.User)

                .ExecuteNonQuery()
            End With
        End Using
    End Sub

    Public Sub InsertUpdatePO(constr As String, cls As clsDeliverySplitExport, colIndex As String)
        Dim ls_sql As String = ""
        Dim dt As New DataTable

        ls_sql = "sp_DeliverySplitList_InsUpd_PO"
        Using sqlConn As New SqlConnection(constr)
            sqlConn.Open()

            Dim sqlcomm As New SqlCommand(ls_sql, sqlConn)
            With sqlcomm
                .CommandType = CommandType.StoredProcedure
                .Parameters.AddWithValue("AffiliateID", cls.AffiliateID)
                .Parameters.AddWithValue("SupplierID", cls.SupplierID)
                .Parameters.AddWithValue("ForwarderID", cls.ForwarderID)
                .Parameters.AddWithValue("ForwarderIDSplit", cls.ForwarderID_Split)
                .Parameters.AddWithValue("SuratJalan", cls.SuratJalanNo)
                .Parameters.AddWithValue("PoNo", cls.PoNo)
                .Parameters.AddWithValue("OrderNo", cls.OrderNo)
                .Parameters.AddWithValue("PartNo", cls.PartNo)
                .Parameters.AddWithValue("LabelNo", cls.LabelBox)
                .Parameters.AddWithValue("QtyMOQ", cls.MOQ)
                .Parameters.AddWithValue("User", cls.User)
                .Parameters.AddWithValue("IndexCol", colIndex)

                .ExecuteNonQuery()
            End With
        End Using
    End Sub

    Public Sub InsertUpdateDataDNReceiving(constr As String, cls As clsDeliverySplitExport)
        Dim ls_sql As String = ""
        Dim dt As New DataTable

        ls_sql = "sp_DeliverySplitList_InsUpd_DeliveryReceiving"
        Using sqlConn As New SqlConnection(constr)
            sqlConn.Open()

            Dim sqlcomm As New SqlCommand(ls_sql, sqlConn)
            With sqlcomm
                .CommandType = CommandType.StoredProcedure
                .Parameters.AddWithValue("AffiliateID", cls.AffiliateID)
                .Parameters.AddWithValue("SupplierID", cls.SupplierID)
                .Parameters.AddWithValue("ForwarderID", cls.ForwarderID)
                .Parameters.AddWithValue("ForwarderIDSplit", cls.ForwarderID_Split)
                .Parameters.AddWithValue("SuratJalan", cls.SuratJalanNo)
                .Parameters.AddWithValue("SuratJalanSplit", cls.SuratJalanNoNew)
                .Parameters.AddWithValue("PoNo", cls.PoNo)
                .Parameters.AddWithValue("OrderNo", cls.OrderNo)
                .Parameters.AddWithValue("PartNo", cls.PartNo)
                .Parameters.AddWithValue("LabelNo", cls.LabelBox)
                .Parameters.AddWithValue("Remarks", cls.Remarks)
                .Parameters.AddWithValue("QtyMOQ", cls.MOQ)
                .Parameters.AddWithValue("User", cls.User)

                .ExecuteNonQuery()
            End With
        End Using
    End Sub

    Public Sub RepairDataDNReceiving(constr As String, cls As clsDeliverySplitExport)
        Dim ls_sql As String = ""
        Dim dt As New DataTable

        ls_sql = "sp_DeliverySplitList_Repair_DeliveryReceiving"
        Using sqlConn As New SqlConnection(constr)
            sqlConn.Open()

            Dim sqlcomm As New SqlCommand(ls_sql, sqlConn)
            With sqlcomm
                .CommandType = CommandType.StoredProcedure
                .Parameters.AddWithValue("AffiliateID", cls.AffiliateID)
                .Parameters.AddWithValue("SupplierID", cls.SupplierID)
                .Parameters.AddWithValue("PoNo", cls.PoNo)
                .Parameters.AddWithValue("OrderNo", cls.OrderNo)
                .Parameters.AddWithValue("SuratJalan", cls.SuratJalanNo)

                .ExecuteNonQuery()
            End With
        End Using
    End Sub

End Class