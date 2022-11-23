Imports System.Data.SqlClient
Imports DevExpress.Web.ASPxGridView
Imports System.Drawing

Public Class DeliverySplitList
    Inherits System.Web.UI.Page

#Region "Declaration"
    Dim clsGlobal As New clsGlobal
    Dim clsMsg As New clsMessage
    Dim clsAppearance As New clsAppearance
#End Region

#Region "Events"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If (Not IsPostBack) AndAlso (Not IsCallback) Then
                Call up_fillcombo()
            End If

        Catch ex As Exception
            Call clsMsg.DisplayMessage(lblerrmessage, Err.Number.ToString, clsMessage.MsgType.ErrorMessageFromVS, ex.Message.ToString())
        Finally
            Call clsAppearance.setAppearanceControlsDevEx13(Me.Page, clsAppearance.ShowHorizontalScrollMode.Visible, False, False, False, 3, False, clsAppearance.PagerMode.ShowAllRecord, False, False, False, True)
        End Try
    End Sub

    Protected Sub btnsubmenu_Click(sender As Object, e As EventArgs) Handles btnsubmenu.Click
        Response.Redirect("~/MainMenu.aspx")
    End Sub

    Private Sub grid_AfterPerformCallback1(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewAfterPerformCallbackEventArgs) Handles grid.AfterPerformCallback
        If e.CallbackName <> "CANCELEDIT" And e.CallbackName <> "CUSTOMCALLBACK" Then
            up_GridLoad()
        End If
    End Sub

    Private Sub grid_CellEditorInitialize(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewEditorEventArgs) Handles grid.CellEditorInitialize
        e.Editor.ReadOnly = True
    End Sub

    Private Sub grid_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewCustomCallbackEventArgs) Handles grid.CustomCallback
        Try
            Dim pAction As String = Split(e.Parameters, "|")(0)

            Select Case pAction
                Case "gridload"
                    Call up_GridLoad()
                    If grid.VisibleRowCount = 0 Then
                        Call clsMsg.DisplayMessage(lblerrmessage, "2001", clsMessage.MsgType.InformationMessage)
                        grid.JSProperties("cpMessage") = lblerrmessage.Text
                    End If
                Case "gridKosong"
                    Call up_GridLoadKosong()
            End Select
        Catch ex As Exception
            Call clsMsg.DisplayMessage(lblerrmessage, Err.Number.ToString, clsMessage.MsgType.ErrorMessageFromVS, ex.Message.ToString())
        End Try
    End Sub
#End Region

#Region "Functions"
    Private Sub up_fillcombo()
        Dim ls_sql As String = ""
        Dim ds As New DataSet

        ls_sql = "Exec sp_DeliverySplit_FillCombo"
        Using sqlConn As New SqlConnection(clsGlobal.ConnectionString)
            sqlConn.Open()

            Dim sqlDA As New SqlDataAdapter(ls_sql, sqlConn)
            sqlDA.Fill(ds)
            sqlConn.Close()
        End Using

        'Affiliate
        With cboaffiliate
            .Items.Clear()
            .Columns.Clear()
            .DataSource = ds.Tables(0)
            .Columns.Add("Code") : .Columns(0).Width = 158
            .Columns.Add("Description") : .Columns(1).Width = 275
            .TextField = "Code" : .ValueField = "Description"
            .SelectedIndex = 0
            .DataBind()

            txtaffiliateName.Text = .SelectedItem.Value
        End With

        'Supplier
        With cboSupplier
            .Items.Clear()
            .Columns.Clear()
            .DataSource = ds.Tables(1)
            .Columns.Add("Code") : .Columns(0).Width = 158
            .Columns.Add("Description") : .Columns(1).Width = 275
            .TextField = "Code" : .ValueField = "Description"
            .SelectedIndex = 0
            .DataBind()

            txtSupplierName.Text = .SelectedItem.Value
        End With

        'Forwarder
        With cboForwarder
            .Items.Clear()
            .Columns.Clear()
            .DataSource = ds.Tables(2)
            .Columns.Add("Code") : .Columns(0).Width = 158
            .Columns.Add("Description") : .Columns(1).Width = 275
            .TextField = "Code" : .ValueField = "Description"
            .SelectedIndex = 0
            .DataBind()

            txtForwarder.Text = .SelectedItem.Value
        End With

    End Sub

    Private Sub up_GridLoad()
        Dim ls_SQL As String = "sp_DeliverySplit_Select"
        Dim dt As New DataTable

        Using sqlConn As New SqlConnection(clsGlobal.ConnectionString)
            sqlConn.Open()
            
            Dim cmd As New SqlCommand(ls_SQL, sqlConn)
            cmd.CommandType = CommandType.StoredProcedure

            If chkDelivery.Checked Then
                cmd.Parameters.AddWithValue("DeliveryFrom", Format(dtFromDelivery.Value, "yyyy-MM-dd"))
                cmd.Parameters.AddWithValue("DeliveryTo", Format(dtToDelivery.Value, "yyyy-MM-dd"))
            End If

            If chkReceipt.Checked Then
                cmd.Parameters.AddWithValue("ReceiptFrom", Format(dtFromReceipt.Value, "yyyy-MM-dd"))
                cmd.Parameters.AddWithValue("ReceiptTo", Format(dtToReceipt.Value, "yyyy-MM-dd"))
            End If

            If txtPoNo.Text.Trim <> "" Then cmd.Parameters.AddWithValue("PoNo", txtPoNo.Text.Trim)
            If txtSuratJalan.Text.Trim <> "" Then cmd.Parameters.AddWithValue("SuratJalan", txtSuratJalan.Text.Trim)
            If cboaffiliate.Text <> clsGlobal.gs_All Then cmd.Parameters.AddWithValue("Affiliate", cboaffiliate.Text)
            If cboSupplier.Text <> clsGlobal.gs_All Then cmd.Parameters.AddWithValue("Supplier", cboSupplier.Text)
            If cboForwarder.Text <> clsGlobal.gs_All Then cmd.Parameters.AddWithValue("Forwarder", cboForwarder.Text)

            Dim da As New SqlDataAdapter(cmd)
            da.Fill(dt)

            With grid
                .DataSource = dt
                .DataBind()
            End With

            sqlConn.Close()
        End Using
    End Sub

    Private Sub up_GridLoadKosong()
        Dim ls_SQL As String = "Select Top 0 coldetail = '',coldetailname	= 'Detail',No = '',Affiliate = '', Supplier	= '', Forwarder = '', PoNo = '', DeliveryDate = NULL,SuppSuratJalan	= '',ReceivedDate = NULL"
        Dim dt As New DataTable

        Using sqlConn As New SqlConnection(clsGlobal.ConnectionString)
            sqlConn.Open()

            Dim cmd As New SqlCommand(ls_SQL, sqlConn)
            cmd.CommandType = CommandType.Text

            Dim da As New SqlDataAdapter(cmd)
            da.Fill(dt)

            With grid
                .DataSource = dt
                .DataBind()
            End With

            sqlConn.Close()
        End Using
    End Sub
#End Region

End Class