﻿Imports System.Data.SqlClient
Imports DevExpress.Web.ASPxGridView
Imports DevExpress.Web.ASPxEditors
Imports DevExpress.Web.ASPxPanel
Imports DevExpress.Web.ASPxRoundPanel
Imports System.Drawing
Imports System.Transactions
Imports DevExpress.Web.ASPxUploadControl
Imports System.IO
Imports System.Data.OleDb

Public Class UploadSuppCapacity
#Region "DECLARATION"
    Inherits System.Web.UI.Page
    Dim clsGlobal As New clsGlobal
    Dim clsMsg As New clsMessage
    Dim clsAppearance As New clsAppearance
    Dim menuID As String = "A09"
    Dim ls_AllowUpdate As Boolean = False
    Dim ls_AllowDelete As Boolean = False
    Dim log As String = ""
    Dim FilePath As String = ""
    Dim FileName As String = ""
    Dim FileExt As String = ""
    Dim Ext As String = ""
    Dim FolderPath As String = ""
#End Region

#Region "FORM EVENTS"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'ls_AllowUpdate = clsGlobal.Auth_UserUpdate(Session("UserID"), menuID)

        If (Not IsPostBack) AndAlso (Not IsCallback) Then
            'If ls_AllowUpdate = False Then
            'btnUpload.Enabled = False
            'btnClear.Enabled = False
            'btnSave.Enabled = False
            'btnDownload.Enabled = False
            'End If
            lblInfo.Text = ""
        Else
            lblInfo.Text = ""
            Ext = Server.MapPath("")
        End If

        Call clsAppearance.setAppearanceControlsDevEx13(Me.Page, clsAppearance.ShowHorizontalScrollMode.Visible, True, False, False, 1, False, clsAppearance.PagerMode.ShowAllRecord, False)
    End Sub

    Private Sub btnSubMenu_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSubMenu.Click
        Response.Redirect("~/Master/SupplierCapacity.aspx")
    End Sub

    Private Sub btnClear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnClear.Click
        Uploader.NullText = "Click here to browse files..."

        lblInfo.Text = ""

        Uploader.Enabled = True
        btnSave.Enabled = True
        btnUpload.Enabled = True

        up_GridLoadWhenEventChange()
    End Sub

    Private Sub btnUpload_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpload.Click
        up_Import()
    End Sub

    Private Sub ASPxCallback1_Callback(ByVal source As Object, ByVal e As DevExpress.Web.ASPxCallback.CallbackEventArgs) Handles ASPxCallback1.Callback
        Try
            Dim fi As New FileInfo(Server.MapPath("~\Template\TemplatePO.xlsx"))
            If Not fi.Exists Then
                lblInfo.Text = "[9999] Excel Template Not Found !"
                ASPxCallback1.JSProperties("cpMessage") = lblInfo.Text
                Exit Sub
            End If

            DevExpress.Web.ASPxClasses.ASPxWebControl.RedirectOnCallback("Template PO.xlsx")

            'lblInfo.Text = "[9998] Download template successful"
            'ASPxCallback1.JSProperties("cpMessage") = lblInfo.Text
        Catch ex As Exception
            Call clsMsg.DisplayMessage(lblInfo, Err.Number.ToString, clsMessage.MsgType.ErrorMessageFromVS, ex.Message.ToString())
            ASPxCallback1.JSProperties("cpMessage") = lblInfo.Text
        End Try

    End Sub

    Private Sub grid_HtmlDataCellPrepared(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewTableDataCellEventArgs) Handles grid.HtmlDataCellPrepared
        e.Cell.Attributes.Add("onclick", "event.cancelBubble = true")

        If e.GetValue("ErrorCls") = "" Then
        Else
            e.Cell.BackColor = Color.Red
        End If
    End Sub

    Private Sub grid_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewCustomCallbackEventArgs) Handles grid.CustomCallback
        Try
            Call clsAppearance.setAppearanceControlsDevEx13(Me.Page, clsAppearance.ShowHorizontalScrollMode.Visible, True, False, False, 1, False, clsAppearance.PagerMode.ShowAllRecord, False)
            grid.JSProperties("cpMessage") = Session("YA010IsSubmit")

            Dim pAction As String = Split(e.Parameters, "|")(0)
            Select Case pAction
                Case "save"
                    If grid.VisibleRowCount = 0 Then
                        Call clsMsg.DisplayMessage(lblInfo, "6021", clsMessage.MsgType.ErrorMessage)
                        grid.JSProperties("cpMessage") = lblInfo.Text
                    Else
                        Call up_Save()
                    End If
                Case "kosong"
                    Call up_GridLoadWhenEventChange()
            End Select

EndProcedure:
            Session("YA010IsSubmit") = ""

        Catch ex As Exception
            Call clsMsg.DisplayMessage(lblInfo, Err.Number.ToString, clsMessage.MsgType.ErrorMessageFromVS, ex.Message.ToString())
        End Try
    End Sub

#End Region

#Region "PROCEDURE"

    Private Sub bindData()
        Dim ls_SQL As String = ""
        Dim pWhereKanban As String = ""
        Dim pWhereDifference As String = ""

        Using sqlConn As New SqlConnection(clsGlobal.ConnectionString)
            sqlConn.Open()

            'ls_SQL = " select  " & vbCrLf & _
            '      " 	row_number() over (order by a.SupplierID asc) as NoUrut, " & vbCrLf & _
            '      " 	a.[SupplierID], [SupplierName], a.[PartNo], [PartName], [DailyDeliveryCapacity] DailyCapacity, [MonthlyInjectionCapacity] MontlyCapacity, [ErrorCls] "

            'ls_SQL = ls_SQL + " from [UploadSupplierCapacity] a" & vbCrLf & _
            '                " left join MS_Parts b on a.PartNo = b.PartNo " & vbCrLf & _
            '                " left join MS_Supplier c on a.SupplierID = c.SupplierID " & vbCrLf & _
            '                "order by a.SupplierID "

            ls_SQL = " select   " & vbCrLf & _
                      "  	row_number() over (order by a.SupplierID asc) as NoUrut,  " & vbCrLf & _
                      "  	a.[SupplierID], [SupplierName], a.[PartNo], b.[PartName], a.[DailyDeliveryCapacity] DailyCapacity, a.[MonthlyInjectionCapacity] MontlyCapacity, [ErrorCls], " & vbCrLf & _
                      " 	xDailyCapacity = d.DailyDeliveryCapacity, xMontlyCapacity = d.MonthlyInjectionCapacity   " & vbCrLf & _
                      " from [UploadSupplierCapacity] a " & vbCrLf & _
                      " 	left join MS_Parts b on a.PartNo = b.PartNo  " & vbCrLf & _
                      " 	left join MS_Supplier c on a.SupplierID = c.SupplierID  " & vbCrLf & _
                      " 	left join MS_SupplierCapacity d on a.SupplierID = d.SupplierID and a.PartNo = d.PartNo " & vbCrLf & _
                      " order by a.SupplierID "

            Dim sqlDA As New SqlDataAdapter(ls_SQL, sqlConn)
            Dim ds As New DataSet
            sqlDA.Fill(ds)
            With grid
                .DataSource = ds.Tables(0)
                .DataBind()
                'Call clsAppearance.setAppearanceControlsDevEx13(Me.Page, clsAppearance.ShowHorizontalScrollMode.Visible, True, False, False, 1, False, clsAppearance.PagerMode.ShowAllRecord, False)
            End With
            sqlConn.Close()

            'clsGlobal.HideColumTanggal1(Session("Period"), grid)
        End Using
    End Sub

    Private Sub up_GridLoadWhenEventChange()
        Dim ls_SQL As String = ""

        Using sqlConn As New SqlConnection(clsGlobal.ConnectionString)
            sqlConn.Open()

            ls_SQL = " select top 0 '' NoUrut, '' [SupplierID],'' [SupplierName],'' [PartNo],'' [PartName],'' [DailyCapacity],'' [MontlyCapacity],'' [ErrorCls], '' xDailyCapacity, '' xMontlyCapacity "

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

    Private Sub up_Import()
        Dim dt As New System.Data.DataTable
        Dim dtHeader As New System.Data.DataTable
        Dim dtDetail As New System.Data.DataTable
        'Dim tempDate As Date
        Dim ls_MOQ As Double = 0
        Dim ls_sql As String = ""
        Dim ls_SupplierID As String = """"

        Try
            lblInfo.ForeColor = Color.Red
            If Uploader.HasFile Then
                FileName = Uploader.PostedFile.FileName
                FileExt = Path.GetExtension(Uploader.PostedFile.FileName)
                FilePath = Ext & "\Import\" & FileName
                Dim fi As New FileInfo(Server.MapPath("~\Import\" & FileName))
                If fi.Exists Then
                    fi.Delete()
                    fi = New FileInfo(Server.MapPath("~\Import\" & FileName))
                End If
                Uploader.SaveAs(FilePath)

                Dim connStr As String = ""
                Select Case FileExt
                    Case ".xls"
                        'Excel 97-03
                        connStr = ConfigurationManager.ConnectionStrings("Excel03ConString").ConnectionString
                    Case ".xlsx"
                        'Excel 07
                        connStr = ConfigurationManager.ConnectionStrings("Excel07ConString").ConnectionString
                End Select

                connStr = String.Format(connStr, FilePath, "No")

                Dim MyConnection As New OleDbConnection(connStr)
                Dim MyCommand As New OleDbCommand
                Dim MyAdapter As New OleDbDataAdapter
                MyCommand.Connection = MyConnection
                MyConnection.Open()

                Dim dtSheets As DataTable = MyConnection.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, Nothing)
                Dim listSheet As New List(Of String)
                Dim drSheet As DataRow

                For Each drSheet In dtSheets.Rows
                    If InStr("_xlnm#_FilterDatabase", drSheet("TABLE_NAME").ToString(), CompareMethod.Text) = 0 Then
                        If InStr("_xlnm#Print_Titles", drSheet("TABLE_NAME").ToString(), CompareMethod.Text) = 0 Then
                            listSheet.Add(drSheet("TABLE_NAME").ToString())
                        End If
                    End If
                Next

                Using sqlConn As New SqlConnection(clsGlobal.ConnectionString)
                    sqlConn.Open()

                    ''==========Table EXCEL Master==========
                    Dim pTableCode As String = listSheet(0)

                    Try

                        'Get Detail Data
                        Dim dtUploadDetailList As New List(Of clsMaster)

                        MyCommand.CommandText = ("SELECT * FROM [" & pTableCode & "A3:D65536]")
                        MyAdapter.SelectCommand = MyCommand
                        MyAdapter.Fill(dtDetail)

                        If dtDetail.Rows.Count > 0 Then
                            For i = 0 To dtDetail.Rows.Count - 1
                                If IsDBNull(dtDetail.Rows(i).Item(0)) = False Then
                                    Dim dtUploadDetail As New clsMaster
                                    dtUploadDetail.SupplierID = dtDetail.Rows(i).Item(0)
                                    dtUploadDetail.PartNo = IIf(IsDBNull(dtDetail.Rows(i).Item(1)), "", dtDetail.Rows(i).Item(1))
                                    dtUploadDetail.DailyCapacity = IIf(IsDBNull(dtDetail.Rows(i).Item(2)), 0, dtDetail.Rows(i).Item(2))
                                    dtUploadDetail.MontlyCapacity = IIf(IsDBNull(dtDetail.Rows(i).Item(3)), 0, dtDetail.Rows(i).Item(3))
                                    dtUploadDetailList.Add(dtUploadDetail)
                                End If
                            Next
                        End If

                        Using sqlTran As SqlTransaction = sqlConn.BeginTransaction("uploadPO")
                            ''01.01 Delete TempoaryData
                            ls_sql = "delete UploadSupplierCapacity"
                            Dim sqlComm9 = New SqlCommand(ls_sql, sqlConn, sqlTran)
                            sqlComm9.ExecuteNonQuery()
                            sqlComm9.Dispose()


                            ''02. Check PartNo di Part Master MS_Parts dan Check Item di Part Mapping MS_PartMapping
                            For i = 0 To dtUploadDetailList.Count - 1
                                Dim ls_error As String = ""
                                Dim PO As clsMaster = dtUploadDetailList(i)

                                '02.1 Check PartNo di MS_Part
                                ls_sql = "SELECT * FROM dbo.MS_Supplier WHERE SupplierID = '" & PO.SupplierID & "' "
                                Dim sqlCmd2 As New SqlCommand(ls_sql, sqlConn, sqlTran)
                                Dim sqlDA2 As New SqlDataAdapter(sqlCmd2)
                                Dim ds2 As New DataSet
                                sqlDA2.Fill(ds2)

                                If ds2.Tables(0).Rows.Count = 0 Then
                                    ls_error = "Supplier ID not found in Supplier Master, please check again."
                                End If

                                '02.1 Check PartNo di MS_Part
                                ls_sql = "SELECT * FROM dbo.MS_Parts WHERE PartNo = '" & PO.PartNo & "' "
                                Dim sqlCmd3 As New SqlCommand(ls_sql, sqlConn, sqlTran)
                                Dim sqlDA3 As New SqlDataAdapter(sqlCmd3)
                                Dim ds3 As New DataSet
                                sqlDA3.Fill(ds3)

                                If ds3.Tables(0).Rows.Count = 0 Then
                                    If ls_error = "" Then
                                        ls_error = ls_error & "Part No not found in Part Master, please check again."
                                    Else
                                        ls_error = ls_error & "; " & "Part No not found in Part Master, please check again."
                                    End If
                                End If

                                ls_sql = " INSERT INTO [dbo].[UploadSupplierCapacity] " & vbCrLf & _
                                          "            ([SupplierID], [PartNo], [DailyDeliveryCapacity], [MonthlyInjectionCapacity],[ErrorCls]) " & vbCrLf & _
                                          "      VALUES " & vbCrLf & _
                                          "            ('" & PO.SupplierID & "'" & vbCrLf & _
                                          "            ,'" & PO.PartNo & "' " & vbCrLf & _
                                          "            ,'" & PO.DailyCapacity & "' " & vbCrLf & _
                                          "            ,'" & PO.MontlyCapacity & "' " & vbCrLf & _
                                          "            ,'" & ls_error & "') " & vbCrLf
                                Dim sqlComm = New SqlCommand(ls_sql, sqlConn, sqlTran)
                                sqlComm.ExecuteNonQuery()
                                sqlComm.Dispose()
                            Next
                            sqlTran.Commit()

                            lblInfo.Text = "[7001] Data Checking Done!"
                            lblInfo.ForeColor = Color.Blue
                            grid.JSProperties("cpMessage") = lblInfo.Text

                            Call bindData()
                        End Using
                    Catch ex As Exception
                        lblInfo.Text = ex.Message
                        Call clsMsg.DisplayMessage(lblInfo, Err.Number.ToString, clsMessage.MsgType.ErrorMessageFromVS, ex.Message.ToString())
                        MyConnection.Close()
                        Exit Sub
                    End Try
                    dt.Reset()
                    dtDetail.Reset()
                    dtHeader.Reset()
                End Using
                MyConnection.Close()
            Else
                If FileName = "" Then
                    lblInfo.Text = "[9999] Please choose the file!"
                    up_GridLoadWhenEventChange()
                    grid.JSProperties("cpMessage") = lblInfo.Text
                    Exit Sub
                End If
            End If
        Catch ex As Exception
            Call clsMsg.DisplayMessage(lblInfo, Err.Number.ToString, clsMessage.MsgType.ErrorMessageFromVS, ex.Message.ToString())
        End Try
    End Sub

    Protected Sub Uploader_FileUploadComplete(ByVal sender As Object, ByVal e As FileUploadCompleteEventArgs)
        Try
            e.CallbackData = SavePostedFiles(e.UploadedFile)
        Catch ex As Exception
            e.IsValid = False
            lblInfo.Text = ex.Message
        End Try
    End Sub

    Private Function SavePostedFiles(ByVal uploadedFile As UploadedFile) As String
        If (Not uploadedFile.IsValid) Then
            Return String.Empty
        End If

        Ext = Path.Combine(MapPath(""))
        FileName = Uploader.PostedFile.FileName
        FilePath = Ext & "\Import\" & FileName
        uploadedFile.SaveAs(FilePath)

        Return FilePath
    End Function

    Private Sub up_Save()
        Dim i As Integer ', j As Integer
        'Dim tampung As String = ""
        Dim ls_Check As Boolean = False
        'Dim ls_PONo As String = ""
        Dim ls_Sql As String
        Dim ls_MsgID As String = ""
        Dim ls_SupplierID As String = ""
        'Dim ls_Period As Date
        Dim ls_ShipBy As String = ""
        Dim ls_Detail As String = ""
        Dim shostname As String = System.Net.Dns.GetHostName
        Dim PartNo As String = ""
        Dim ls_Remarks As String = ""
        'Dim ls_DoubleSupplier As Boolean = False
        'Dim ls_TempSupplierID As String = ""
        Try
            '01. Cari ada data yg disubmit
            For i = 0 To grid.VisibleRowCount - 1
                If grid.GetRowValues(i, "ErrorCls").ToString.Trim <> "" Then
                    ls_Check = True
                    Exit For
                End If
            Next i

            If ls_Check = True Then
                lblInfo.Text = "[9999] Invalid data in this File Upload, please check the file again!"
                Session("YA010IsSubmit") = lblInfo.Text
                grid.JSProperties("cpMessage") = lblInfo.Text
                Exit Sub
            End If

            Dim SqlCon As New SqlConnection(clsGlobal.ConnectionString)
            Dim SqlTran As SqlTransaction

            SqlCon.Open()

            SqlTran = SqlCon.BeginTransaction

            Try
                '2.1 delete data 
                Dim SQLCom As SqlCommand = SqlCon.CreateCommand
                SQLCom.Connection = SqlCon
                SQLCom.Transaction = SqlTran

                '2.2 Insert New Detail Data
                Dim ls_SuppCount As Integer = 1
                For i = 0 To grid.VisibleRowCount - 1
                    If grid.GetRowValues(i, "SupplierID") <> "" Then
                        ls_Sql = " IF NOT EXISTS (select * from MS_SupplierCapacity where SupplierID = '" & grid.GetRowValues(i, "SupplierID") & "' and PartNo = '" & grid.GetRowValues(i, "PartNo") & "')" & vbCrLf & _
                                  " BEGIN" & vbCrLf & _
                                  " INSERT INTO [dbo].[MS_SupplierCapacity] " & vbCrLf & _
                                  "            ([SupplierID] " & vbCrLf & _
                                  "            ,[PartNo] " & vbCrLf & _
                                  "            ,[DailyDeliveryCapacity] " & vbCrLf & _
                                  "            ,[MonthlyInjectionCapacity] " & vbCrLf & _
                                  "            ,[EntryDate] " & vbCrLf & _
                                  "            ,[EntryUser] ) " & vbCrLf & _
                                  "      VALUES " & vbCrLf & _
                                  "            ('" & grid.GetRowValues(i, "SupplierID") & "' " & vbCrLf & _
                                  "            ,'" & grid.GetRowValues(i, "PartNo") & "' " & vbCrLf & _
                                  "            ,'" & grid.GetRowValues(i, "DailyCapacity") & "' " & vbCrLf & _
                                  "            ,'" & grid.GetRowValues(i, "MontlyCapacity") & "' " & vbCrLf

                        ls_Sql = ls_Sql + "            ,getdate() " & vbCrLf & _
                                          "            ,'UPLOAD') " & vbCrLf & _
                                          " END " & vbCrLf & _
                                          " ELSE " & vbCrLf & _
                                          " BEGIN" & vbCrLf & _
                                          "      UPDATE [dbo].[MS_SupplierCapacity] SET " & vbCrLf & _
                                          "       [DailyDeliveryCapacity] = '" & grid.GetRowValues(i, "DailyCapacity") & "' " & vbCrLf & _
                                          "       ,[MonthlyInjectionCapacity] = '" & grid.GetRowValues(i, "MontlyCapacity") & "' " & vbCrLf & _
                                          "      WHERE SupplierID = '" & grid.GetRowValues(i, "SupplierID") & "' and PartNo = '" & grid.GetRowValues(i, "PartNo") & "' " & vbCrLf & _
                                          " END"

                        SQLCom.CommandText = ls_Sql
                        SQLCom.ExecuteNonQuery()
                    End If

                    PartNo = grid.GetRowValues(i, "PartNo")

                    If (Not IsDBNull(grid.GetRowValues(i, "DailyCapacity")) And Not IsDBNull(grid.GetRowValues(i, "xDailyCapacity"))) And (grid.GetRowValues(i, "DailyCapacity").ToString <> "" And grid.GetRowValues(i, "xDailyCapacity").ToString <> "") Then
                        If (Trim(grid.GetRowValues(i, "DailyCapacity").ToString) <> Trim(grid.GetRowValues(i, "xDailyCapacity").ToString)) Then
                            ls_Remarks = ls_Remarks + "DailyCapacity " + Trim(grid.GetRowValues(i, "xDailyCapacity").ToString) & " " & "->" & " " & Trim(grid.GetRowValues(i, "DailyCapacity").ToString) & ""
                        End If
                    End If

                    If (Not IsDBNull(grid.GetRowValues(i, "MontlyCapacity")) And Not IsDBNull(grid.GetRowValues(i, "xMontlyCapacity"))) And (grid.GetRowValues(i, "MontlyCapacity").ToString <> "" And grid.GetRowValues(i, "xMontlyCapacity").ToString <> "") Then
                        If (Trim(grid.GetRowValues(i, "MontlyCapacity").ToString) <> Trim(grid.GetRowValues(i, "xMontlyCapacity").ToString)) Then
                            If ls_Remarks <> "" Then ls_Remarks = ls_Remarks + ", "
                            ls_Remarks = ls_Remarks + "MontlyCapacity " + Trim(grid.GetRowValues(i, "xMontlyCapacity").ToString) & " " & "->" & " " & Trim(grid.GetRowValues(i, "MontlyCapacity").ToString) & ""
                        End If
                    End If

                    If ls_Remarks <> "" Then
                        ls_Sql = " INSERT INTO MS_History (PCName, MenuID, OperationID, PartNo, Remarks, RegisterDate, RegisterUserID) " & vbCrLf & _
                                 "VALUES ('" & shostname & "','" & menuID & "','U','" & PartNo & "','Update [" & ls_Remarks & "]', " & vbCrLf & _
                                 "GETDATE(), '" & Session("UserID") & "')  "

                        SQLCom.CommandText = ls_Sql
                        SQLCom.ExecuteNonQuery()
                        ls_Remarks = ""
                    End If
                Next i

                '2.3.1 Habis save semua,.. delete tada di tempolary table
                ls_Sql = "delete UploadSupplierCapacity "

                SQLCom.CommandText = ls_Sql
                SQLCom.ExecuteNonQuery()

                '2.3.3 Commit transaction
                ls_MsgID = "1001"
                SqlTran.Commit()
                Call clsMsg.DisplayMessage(lblInfo, ls_MsgID, clsMessage.MsgType.InformationMessage)
                grid.JSProperties("cpMessage") = lblInfo.Text
                Session("YA010IsSubmit") = lblInfo.Text
            Catch ex As Exception
                Call clsMsg.DisplayMessage(lblInfo, Err.Number.ToString, clsMessage.MsgType.ErrorMessageFromVS, ex.Message.ToString())
                Session("YA010IsSubmit") = lblInfo.Text
                SqlTran.Rollback()
                SqlCon.Close()
                Exit Sub
            End Try

        Catch ex As Exception
            Call clsMsg.DisplayMessage(lblInfo, Err.Number.ToString, clsMessage.MsgType.ErrorMessageFromVS, ex.Message.ToString())
            Session("YA010IsSubmit") = lblInfo.Text
        End Try
    End Sub

#End Region
End Class