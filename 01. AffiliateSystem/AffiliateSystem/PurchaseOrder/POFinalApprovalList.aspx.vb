Imports System.Data.SqlClient
Imports DevExpress.Web.ASPxGridView
Imports DevExpress.Web.ASPxEditors
Imports DevExpress.Web.ASPxPanel
Imports DevExpress.Web.ASPxRoundPanel

Public Class POFinalApprovalList
#Region "DECLARATION"
    Inherits System.Web.UI.Page
    Dim clsGlobal As New clsGlobal
    Dim clsMsg As New clsMessage
    Dim clsAppearance As New clsAppearance
#End Region

#Region "FORM EVENTS"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If (Not IsPostBack) AndAlso (Not IsCallback) Then            
            dtPeriodFrom.Value = Now
            dtPeriodTo.Value = Now
            rdrAff1.Checked = True
            rdrCom1.Checked = True
            lblInfo.Text = ""
            If Session("M01Url") <> "" Then
                Call bindData()
                Session.Remove("M01Url")
            End If
        End If

        Call clsAppearance.setAppearanceControlsDevEx13(Me.Page, clsAppearance.ShowHorizontalScrollMode.Visible, True, False, False, 2, False, False)
    End Sub

    Private Sub grid_CellEditorInitialize(ByVal sender As Object, ByVal e As DevExpress.Web.ASPxGridView.ASPxGridViewEditorEventArgs) Handles grid.CellEditorInitialize
        If (e.Column.FieldName = "DetailPage" Or e.Column.FieldName = "RevisePage" Or e.Column.FieldName = "Period" _
            Or e.Column.FieldName = "PONo" Or e.Column.FieldName = "CommercialCls" Or e.Column.FieldName = "ShipCls" _
            Or e.Column.FieldName = "EntryDate" Or e.Column.FieldName = "EntryUser" _
            Or e.Column.FieldName = "POStatus1" Or e.Column.FieldName = "POStatus2" Or e.Column.FieldName = "POStatus3" _
            Or e.Column.FieldName = "POStatus4" Or e.Column.FieldName = "POStatus5" Or e.Column.FieldName = "POStatus6" _
            Or e.Column.FieldName = "POStatus7" Or e.Column.FieldName = "POStatus8") _
            And CType(sender, DevExpress.Web.ASPxGridView.ASPxGridView).IsNewRowEditing = False Then
            e.Editor.ReadOnly = True
        Else
            e.Editor.ReadOnly = False
        End If
    End Sub

    Private Sub btnSubMenu_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSubMenu.Click
        Session.Remove("M01Url")
        Response.Redirect("~/MainMenu.aspx")
    End Sub

    Private Sub grid_PageIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles grid.PageIndexChanged
        bindData()
    End Sub

    Private Sub grid_CustomCallback(ByVal sender As Object, ByVal e As DevExpress.Web.ASPxGridView.ASPxGridViewCustomCallbackEventArgs) Handles grid.CustomCallback
        Try
            Call clsAppearance.setAppearanceControlsDevEx13(Me.Page, clsAppearance.ShowHorizontalScrollMode.Visible, True, False, False, 2, False, False)
            grid.JSProperties("cpMessage") = Session("AA220Msg")

            Dim pAction As String = Split(e.Parameters, "|")(0)
            Select Case pAction
                Case "load"
                    Call bindData()

                    If grid.VisibleRowCount = 0 Then
                        Call clsMsg.DisplayMessage(lblInfo, "2001", clsMessage.MsgType.InformationMessage)
                        grid.JSProperties("cpMessage") = lblInfo.Text
                    End If
                Case "kosong"
                    Call up_GridLoadWhenEventChange()

            End Select

EndProcedure:
            Session("AA220Msg") = ""


        Catch ex As Exception
            Call clsMsg.DisplayMessage(lblInfo, Err.Number.ToString, clsMessage.MsgType.ErrorMessageFromVS, ex.Message.ToString())
        End Try
    End Sub
#End Region

#Region "PROCEDURE"
    Private Sub bindData()
        Dim ls_SQL As String = ""
        Dim pWhere As String = ""
        Dim pDateFrom As Date
        Dim pDateTo As Date

        pDateFrom = Format(dtPeriodFrom.Value, "yyyy-MM-01")
        pDateTo = DateAdd(DateInterval.Day, -1, DateAdd(DateInterval.Month, 1, CDate(Format(dtPeriodTo.Value, "yyyy-MM-01"))))

        If txtPONo.Text.Trim <> "" Then
            pWhere = pWhere + " and a.PONo like '%" & txtPONo.Text.Trim & "%' "
        End If

        If rdrAff2.Checked = True Then
            pWhere = pWhere + " and a.FinalApproveDate is not null "
        End If

        If rdrAff3.Checked = True Then
            pWhere = pWhere + " and a.FinalApproveDate is null "
        End If

        If rdrCom2.Checked = True Then
            pWhere = pWhere + " and a.CommercialCls = '1' "
        End If

        If rdrCom3.Checked = True Then
            pWhere = pWhere + " and a.CommercialCls = '0' "
        End If

        Using sqlConn As New SqlConnection(clsGlobal.ConnectionString)
            sqlConn.Open()

            ls_SQL = " select  distinct " & vbCrLf & _
                  " 	'DETAIL' DetailPage, " & vbCrLf & _
                  " 	DeliveryByPASICls, " & vbCrLf & _
                  " 	Period, " & vbCrLf & _
                  " 	RTRIM(a.PONo) PONo, " & vbCrLf & _
                  "     CASE WHEN b.KanbanCls = 0 then RTRIM(a.PONo) + '-' + RTRIM(a.SupplierID) ELSE a.PONo END POMarking, " & vbCrLf & _
                  " 	case CommercialCls when '0' then 'NO' else 'YES' end CommercialCls, " & vbCrLf & _
                  " 	RTRIM(ShipCls) ShipCls, " & vbCrLf & _
                  " 	a.EntryDate,  " & vbCrLf & _
                  " 	a.EntryUser, "

            ls_SQL = ls_SQL + " 	case ISNULL(a.EntryDate,0) when 0 then 0 else 1 end POStatus1, " & vbCrLf & _
                              " 	case ISNULL(AffiliateApproveDate,0) when 0 then 0 else 1 end POStatus2, " & vbCrLf & _
                              " 	case ISNULL(PASISendAffiliateDate,0) when 0 then 0 else 1 end POStatus3, " & vbCrLf & _
                              " 	case ISNULL(SupplierApproveDate,0) when 0 then 0 else 1 end POStatus4, " & vbCrLf & _
                              " 	case ISNULL(SupplierApprovePendingDate,0) when 0 then 0 else 1 end POStatus5, " & vbCrLf & _
                              " 	case ISNULL(SupplierUnApproveDate,0) when 0 then 0 else 1 end POStatus6, " & vbCrLf & _
                              " 	case ISNULL(PASIApproveDate,0) when 0 then 0 else 1 end POStatus7, " & vbCrLf & _
                              " 	case ISNULL(FinalApproveDate,0) when 0 then 0 else 1 end POStatus8, RTRIM(a.SupplierID) SupplierID, " & vbCrLf & _
                              " 	ISNULL(Remarks,'')Remarks " & vbCrLf & _
                              " from po_master a " & vbCrLf & _
                              " inner join PO_Detail b on a.PONo = b.PONo and a.AffiliateID = b.AffiliateID and a.SupplierID = b.SupplierID " & vbCrLf & _
                              " left join PO_MasterUpload d on d.PONo = b.PONo and d.AffiliateID = b.AffiliateID and d.SupplierID = b.SupplierID"

            ls_SQL = ls_SQL + " where PASIApproveDate is not null and a.AffiliateID = '" & Session("AffiliateID") & "' " & vbCrLf & _
                              " and Period between '" & Format(pDateFrom, "yyyy-MM-dd") & "' and '" & Format(pDateTo, "yyyy-MM-dd") & "' " & pWhere & ""

            Dim sqlDA As New SqlDataAdapter(ls_SQL, sqlConn)
            Dim ds As New DataSet
            sqlDA.Fill(ds)
            With grid
                .DataSource = ds.Tables(0)
                .DataBind()
                Call clsAppearance.setAppearanceControlsDevEx13(Me.Page, clsAppearance.ShowHorizontalScrollMode.Visible, True, False, False, 2, False, False)
            End With
            sqlConn.Close()

        End Using
    End Sub

    Private Sub up_GridLoadWhenEventChange()
        Dim ls_SQL As String = ""

        Using sqlConn As New SqlConnection(clsGlobal.ConnectionString)
            sqlConn.Open()

            ls_SQL = " select top 0  '' DetailPage, '' as RevisePage, '' Period, ''PONo, ''POMarking,''CommercialCls, ''ShipCls, '' EntryDate, ''EntryUser, '' POStatus1, ''POStatus2, ''POStatus3, ''POStatus4, ''POStatus5, ''POStatus6, ''POStatus7, ''POStatus8, ''Remarks"

            Dim sqlDA As New SqlDataAdapter(ls_SQL, sqlConn)
            Dim ds As New DataSet
            sqlDA.Fill(ds)

            With grid
                .DataSource = ds.Tables(0)
                .DataBind()

            End With

            sqlConn.Close()
        End Using
    End Sub

    Protected Function GetRowValue(ByVal container As GridViewDataItemTemplateContainer) As String
        If Not IsNothing(container.KeyValue) Then
            Return container.Grid.GetRowValuesByKeyValue(container.KeyValue, "PONo").ToString()
        End If
    End Function

    Protected Function GetAffiliateID(ByVal container As GridViewDataItemTemplateContainer) As String
        GetAffiliateID = container.Grid.GetRowValues(container.ItemIndex, "ShipCls")
    End Function

    Protected Function GetAffiliateName(ByVal container As GridViewDataItemTemplateContainer) As String
        GetAffiliateName = container.Grid.GetRowValues(container.ItemIndex, "CommercialCls")
    End Function

    Protected Function GetPeriod(ByVal container As GridViewDataItemTemplateContainer) As String
        GetPeriod = container.Grid.GetRowValues(container.ItemIndex, "Period")
    End Function

    Protected Function GetSupplierID(ByVal container As GridViewDataItemTemplateContainer) As String
        GetSupplierID = container.Grid.GetRowValues(container.ItemIndex, "SupplierID")
    End Function

    Protected Function GetRemarks(ByVal container As GridViewDataItemTemplateContainer) As String
        GetRemarks = container.Grid.GetRowValues(container.ItemIndex, "Remarks")
    End Function

    Protected Function GetFinalApproval(ByVal container As GridViewDataItemTemplateContainer) As String
        GetFinalApproval = container.Grid.GetRowValues(container.ItemIndex, "POStatus7")
    End Function

    Protected Function GetDeliveryBy(ByVal container As GridViewDataItemTemplateContainer) As String
        GetDeliveryBy = container.Grid.GetRowValues(container.ItemIndex, "DeliveryByPASICls")
    End Function

#End Region
End Class