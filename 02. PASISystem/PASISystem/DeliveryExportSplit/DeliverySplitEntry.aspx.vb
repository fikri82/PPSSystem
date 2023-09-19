Imports System.Data.SqlClient
Imports DevExpress.Web.ASPxGridView
Imports System.Drawing
Imports System.Globalization
Imports System.Transactions

Public Class DeliverySplitEntry
    Inherits System.Web.UI.Page

#Region "Declaration"
    Dim clsGlobal As New clsGlobal
    Dim clsMsg As New clsMessage
    Dim clsAppearance As New clsAppearance
    Dim clsData As New clsDeliverySplitExport
    Dim clsDB As New clsDeliverySplitExportDB
#End Region

#Region "Events"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If (Not IsPostBack) AndAlso (Not IsCallback) Then
                lblerrmessage.Text = ""
                lblerrmessage.ForeColor = Color.Blue

                Call up_fillcombo()
                If Request.QueryString("SJNo") IsNot Nothing Then
                    Dim SJNo = Request.QueryString("SJNo").ToString() & ""
                    Dim Aff = Request.QueryString("Aff").ToString() & ""
                    Dim Supp = Request.QueryString("Supp").ToString() & ""
                    Dim Fwd = Request.QueryString("Fwd").ToString() & ""
                    Dim PoNo = Request.QueryString("PoNo").ToString() & ""
                    Dim OrderNo = Request.QueryString("OrderNo").ToString() & ""
                    Dim Index = Request.QueryString("colIndex").ToString() & ""
                    Dim DelivDate = clsDB.GetInfo(clsGlobal.ConnectionString, "1", Aff, Supp, SJNo, PoNo, OrderNo)

                    If SJNo = "" Or Aff = "" Or Supp = "" Or Fwd = "" Or PoNo = "" Or OrderNo = "" Or Index = "" Or DelivDate = "" Then
                        lblerrmessage.Text = "Parameters Doesn't Match"
                        lblerrmessage.ForeColor = Color.Red
                        btnSave.Enabled = False
                    Else
                        txtDeliveryDate.Text = DelivDate
                        txtSuratJalan.Text = SJNo
                        txtAffiliate.Text = Aff : txtAffiliateName.Text = clsDB.GetInfo(clsGlobal.ConnectionString, "2", Aff)
                        txtSupplier.Text = Supp : txtSupplierName.Text = clsDB.GetInfo(clsGlobal.ConnectionString, "3", Supp)
                        txtForwarder.Text = Fwd : txtForwarderName.Text = clsDB.GetInfo(clsGlobal.ConnectionString, "4", Fwd)
                        txtPoNo.Text = PoNo
                        txtOrderNo.Text = OrderNo
                        txtColIndex.Text = Index
                        txtRemarks.Text = clsDB.GetInfo(clsGlobal.ConnectionString, "7", Aff, Supp, PoNo, OrderNo, SJNo)

                        up_GridLoad()
                    End If
                Else
                    Response.Redirect("~/MainMenu.aspx")
                End If
            End If
        Catch ex As Exception
            btnSave.Enabled = False
            Call clsMsg.DisplayMessage(lblerrmessage, Err.Number.ToString, clsMessage.MsgType.ErrorMessageFromVS, ex.Message.ToString())
        Finally
            Call clsAppearance.setAppearanceControlsDevEx13(Me.Page, clsAppearance.ShowHorizontalScrollMode.Visible, False, False, False, 3, False, clsAppearance.PagerMode.ShowAllRecord, False, False, False, True)
        End Try
    End Sub

    Private Sub grid_AfterPerformCallback1(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewAfterPerformCallbackEventArgs) Handles grid.AfterPerformCallback
        If e.CallbackName <> "CANCELEDIT" And e.CallbackName <> "CUSTOMCALLBACK" Then
            up_GridLoad()
        End If
    End Sub

    Private Sub grid_CellEditorInitialize(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewEditorEventArgs) Handles grid.CellEditorInitialize
        If (e.Column.FieldName <> "Check") Then
            e.Editor.ReadOnly = True
        End If
    End Sub

    Private Sub grid_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewCustomCallbackEventArgs) Handles grid.CustomCallback
        Try
            Dim pAction As String = Split(e.Parameters, "|")(0)

            If Session("SessionSPLITMsg") = "" Then
                grid.JSProperties("cpMessage") = "No data edited!"
            Else
                grid.JSProperties("cpMessage") = Session("SessionSPLITMsg")
            End If

            Select Case pAction
                Case "gridload"
                    Call up_GridLoad()
            End Select
        Catch ex As Exception
            Call clsMsg.DisplayMessage(lblerrmessage, Err.Number.ToString, clsMessage.MsgType.ErrorMessageFromVS, ex.Message.ToString())
        Finally
            Session("SessionSPLITMsg") = ""
        End Try
    End Sub

    Private Sub grid_BatchUpdate(sender As Object, e As DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs) Handles grid.BatchUpdate
        clsData = New clsDeliverySplitExport()
        With clsData
            .SuratJalanNo = txtSuratJalan.Text.Trim
            .AffiliateID = txtAffiliate.Text.Trim
            .SupplierID = txtSupplier.Text.Trim
            .ForwarderID = txtForwarder.Text.Trim
            .ForwarderID_Split = cboForwarderSplit.Text.Trim
            .PoNo = txtPoNo.Text.Trim
            .OrderNo = txtOrderNo.Text.Trim
            .Remarks = txtRemarks.Text.Trim
            .User = Session("UserID").ToString().Trim
        End With

        If grid.VisibleRowCount = 0 Then
            Call clsAppearance.setAppearanceControlsDevEx13(Me.Page, clsAppearance.ShowHorizontalScrollMode.Visible, True, False, False, 2, False, clsAppearance.PagerMode.ShowAllRecord, False, False)
            Exit Sub
        End If

        If e.UpdateValues.Count = 0 Then
            Call clsMsg.DisplayMessage(lblerrmessage, "6011", clsMessage.MsgType.ErrorMessage)
            Session("SessionSPLITMsg") = lblerrmessage.Text
            Exit Sub
        End If

        Using trans As New TransactionScope()
            Try
                'clsData.OrderNoNew = clsDB.GetInfo(clsGlobal.ConnectionString, "5", clsData.PoNo, clsData.AffiliateID)
                'If clsData.OrderNoNew = "" Then
                '    lblerrmessage.Text = "New Order No is Blank, Please Contact Your Administrator!"
                '    Session("SessionSPLITMsg") = lblerrmessage.Text
                '    Exit Sub
                'End If

                clsData.SuratJalanNoNew = clsDB.GetInfo(clsGlobal.ConnectionString, "6", clsData.PoNo, clsData.AffiliateID, clsData.SuratJalanNo)
                If clsData.SuratJalanNoNew = "" Then
                    lblerrmessage.Text = "Surat Jalan No is Blank, Please Contact Your Administrator!"
                    Session("SessionSPLITMsg") = lblerrmessage.Text
                    Exit Sub
                End If

                'Jika belum di Receiveing data DN di delete lalu pindahkan ke History
                If txtColIndex.Text = "0" Then
                    clsDB.DeleteDNSupplier(clsGlobal.ConnectionString, clsData)
                End If

                'Jika sudah di Receiveing data DN di pindahkan ke History TAPI JANGAN DI DELETE !
                If txtColIndex.Text = "1" Then
                    clsDB.MoveDNSupplierReceiving(clsGlobal.ConnectionString, clsData)
                End If

                For iLoop = 0 To e.UpdateValues.Count - 1
                    clsData.MOQ = CInt(e.UpdateValues(iLoop).NewValues("MOQ"))
                    clsData.PartNo = e.UpdateValues(iLoop).NewValues("PartNo").ToString()
                    clsData.LabelBox = e.UpdateValues(iLoop).NewValues("BoxNo").ToString()

                    'Belum di Receiving atau Sudah di receiving, SPLIT PO Lagi
                    clsDB.InsertUpdatePO(clsGlobal.ConnectionString, clsData, txtColIndex.Text)

                    'Sudah di Receiving
                    If txtColIndex.Text = "1" Then
                        clsDB.InsertUpdateDataDNReceiving(clsGlobal.ConnectionString, clsData)
                    End If
                Next

                'Sudah di Receiving Pembetulan Data Do dan Receive
                If txtColIndex.Text = "1" Then
                    clsDB.RepairDataDNReceiving(clsGlobal.ConnectionString, clsData)
                End If

                trans.Complete()
                Call clsMsg.DisplayMessage(lblerrmessage, "1002", clsMessage.MsgType.InformationMessage)
                Session("SessionSPLITMsg") = lblerrmessage.Text
            Catch ex As Exception
                lblerrmessage.Text = ex.Message.ToString()
                Session("SessionSPLITMsg") = lblerrmessage.Text
            Finally
                trans.Dispose()
            End Try
        End Using
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

        'Forwarder
        With cboForwarderSplit
            .Items.Clear()
            .Columns.Clear()
            .DataSource = ds.Tables(3)
            .Columns.Add("Code") : .Columns(0).Width = 158
            .Columns.Add("Description") : .Columns(1).Width = 275
            .TextField = "Code" : .ValueField = "Description"
            .SelectedIndex = -1
            .DataBind()
        End With
    End Sub

    Private Sub up_GridLoad()
        Dim dt As New DataTable
        clsData = New clsDeliverySplitExport
        With clsData
            .DeliveryDate = txtDeliveryDate.Text
            .PoNo = txtPoNo.Text
            .OrderNo = txtOrderNo.Text
            .SuratJalanNo = txtSuratJalan.Text
            .AffiliateID = txtAffiliate.Text
            .SupplierID = txtSupplier.Text
            .ForwarderID = txtForwarder.Text
            .ColIndex = txtColIndex.Text
        End With

        dt = clsDB.GetDataDetail(clsGlobal.ConnectionString, clsData)

        With grid
            .DataSource = dt
            .DataBind()
        End With
    End Sub
#End Region

End Class