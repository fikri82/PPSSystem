Imports Microsoft.Office.Interop
Imports Microsoft.Office.Interop.Excel
Imports System.IO
Imports System.Data
Imports System.Data.SqlClient
Imports System.Net.Mail
Imports System.Net
Imports System.Threading

Public Class clsPO

    Shared Function uf_BindPass(ByVal GB As GlobalSetting.clsGlobal, ByVal pAffCode As String) As DataSet
        Dim ls_SQL As String = ""
        ls_SQL = "SELECT UserEDI, PasswordEDI, MailBoxEDI FROM MS_Affiliate WHERE AffiliateID = '" & pAffCode & "'"

        Dim ds As New DataSet
        ds = GB.uf_GetDataSet(ls_SQL)
        Return ds
    End Function

    Shared Sub up_SendInvoiceEDI_Domestic(ByVal cfg As GlobalSetting.clsConfig,
                              ByVal log As GlobalSetting.clsLog,
                              ByVal GB As GlobalSetting.clsGlobal,
                              ByVal LogName As RichTextBox,
                              ByVal pAtttacment As String,
                              ByVal pResult As String,
                              Optional ByRef errMsg As String = "",
                              Optional ByRef ErrSummary As String = "")

        Dim xi As Integer

        Dim ds As New DataSet
        Dim dsDetail As New DataSet
        Dim dsPass As New DataSet

        Dim ls_SQL As String = ""
        Dim pAffiliate As String = ""
        Dim pInvoiceNo As String = ""
        Dim ls_AffCode As String = ""
        Dim fp As StreamWriter
        Dim namaFile As String = ""
        Dim namaINF As String = ""
        Dim namaBAT As String = ""
        Dim namaPUT As String = ""
        Dim ls_Time As Date

        Try
            log.WriteToProcessLog(Date.Now, "SendDataEDI", "Get data Invoice")

            ls_SQL = "select top 1 * from PLPASI_Master where EDICls = '1'"
            ds = GB.uf_GetDataSet(ls_SQL)

            If ds.Tables(0).Rows.Count > 0 Then
                For xi = 0 To ds.Tables(0).Rows.Count - 1
                    pAffiliate = Trim(ds.Tables(0).Rows(xi)("AffiliateID"))
                    pInvoiceNo = Trim(ds.Tables(0).Rows(xi)("InvoiceNo"))
                    ls_Time = Now

                    log.WriteToProcessLog(Date.Now, "SendDataEDI", "Create E.D.I InvoiceNo [" & pInvoiceNo & "], Affiliate [" & pAffiliate & "]")

                    dsDetail = uf_BindDataDetail_Domestic(GB, pAffiliate, pInvoiceNo)

                    If dsDetail.Tables(0).Rows.Count > 0 Then

                        If Trim(pAffiliate) = "PEMI" Then ls_AffCode = "32M8"
                        If Trim(pAffiliate) = "SAMI T" Then ls_AffCode = "32M3"
                        If Trim(pAffiliate) = "SAMI JF" Then ls_AffCode = "32CH"
                        If Trim(pAffiliate) = "SUAI" Then ls_AffCode = "32G2"
                        If Trim(pAffiliate) = "SAI B" Then ls_AffCode = "32M4"
                        If Trim(pAffiliate) = "SAI T" Then ls_AffCode = "32M4"
                        If Trim(pAffiliate) = "JAI" Then ls_AffCode = "32G7"

                        namaFile = "INVOICE_DATA_" + Trim(ls_AffCode) + "_32G8." + Left(Trim(pInvoiceNo), 10) + "." + Format(ls_Time, "yyyyMMdd") + "." + Format(ls_Time, "hhmm") + "." + Format(ls_Time, "ss") + ""
                        namaINF = Format(ls_Time, "yyyyMMdd") + "." + Format(ls_Time, "hhmm") + "." + Format(ls_Time, "ss") + ".INF"
                        namaBAT = Format(ls_Time, "yyyyMMdd") + "." + Format(ls_Time, "hhmm") + "." + Format(ls_Time, "ss") + ".BAT"

                        '01. Crate FIle
                        fp = File.CreateText(pAtttacment & namaFile)
                        For x = 0 To dsDetail.Tables(0).Rows.Count - 1
                            fp.WriteLine(dsDetail.Tables(0).Rows(x)("a") & Format(x + 1, "00000"))
                        Next
                        fp.Close()

                        clsGeneral.up_displayLog(GlobalSetting.clsGlobal.MsgTypeEnum.InformationMsg, "Create E.D.I InvoiceNo [" & pInvoiceNo & "], Affiliate [" & pAffiliate & "]", LogName)
                        LogName.Refresh()

                        dsPass = uf_BindPass(GB, pAffiliate)

                        '02. Craete INF
                        fp = File.CreateText(pAtttacment & namaINF)
                        'fp.WriteLine("o 192.244.194.171 10021")
                        fp.WriteLine("o " & cfg.IPDestination)

                        If dsPass.Tables(0).Rows.Count > 0 Then
                            fp.WriteLine("user " & Trim(dsPass.Tables(0).Rows(0)("UserEDI")))
                            fp.WriteLine(Trim(dsPass.Tables(0).Rows(0)("PasswordEDI")))

                            'namaPUT = "PUT " & pAtttacment & namaFile & " ""$$ ID=" & Trim(dsPass.Tables(0).Rows(0)("MailBoxEDI")) & " BID=" & namaFile & " XMIT=Y"""
                            namaPUT = "PUT " & pAtttacment & namaFile & " " & Trim(dsPass.Tables(0).Rows(0)("MailBoxEDI")) & "/Rcv/" & namaFile
                            fp.WriteLine(namaPUT)
                        Else
                            fp.WriteLine("user ")
                            fp.WriteLine("")
                            fp.WriteLine("")
                        End If
                        fp.WriteLine("bye")
                        fp.Close()

                        clsGeneral.up_displayLog(GlobalSetting.clsGlobal.MsgTypeEnum.InformationMsg, "Create INF InvoiceNo [" & pInvoiceNo & "], Affiliate [" & pAffiliate & "]", LogName)
                        LogName.Refresh()

                        '03. Craete BAT
                        fp = File.CreateText(pAtttacment & namaBAT)
                        fp.WriteLine("D:")
                        fp.WriteLine("ftp -v -n -s:" & pAtttacment & namaINF)
                        fp.WriteLine("COPY " & pAtttacment & namaFile & " " & pResult)
                        fp.WriteLine("DEL " & pAtttacment & namaFile)
                        fp.WriteLine("EXIT")
                        fp.Close()

                        clsGeneral.up_displayLog(GlobalSetting.clsGlobal.MsgTypeEnum.InformationMsg, "Create BAT InvoiceNo [" & pInvoiceNo & "], Affiliate [" & pAffiliate & "]", LogName)
                        LogName.Refresh()

                        Dim proc As Process = Nothing
                        proc = New Process()
                        proc.StartInfo.WorkingDirectory = pAtttacment
                        proc.StartInfo.FileName = namaBAT
                        proc.StartInfo.CreateNoWindow = True
                        proc.Start()
                        proc.WaitForExit()

                        clsGeneral.up_displayLog(GlobalSetting.clsGlobal.MsgTypeEnum.InformationMsg, "Execute BAT File Bat [" & namaBAT & "]", LogName)
                        LogName.Refresh()

                        'File.Copy(pAtttacment & namaBAT, pResult & namaBAT)
                        'Thread.Sleep(1000)
                        'If Dir(pAtttacment & namaBAT) <> "" Then
                        '    File.Delete(pAtttacment & namaBAT)
                        'End If

                        'File.Copy(pAtttacment & namaINF, pResult & namaINF)
                        'Thread.Sleep(1000)
                        'If Dir(pAtttacment & namaINF) <> "" Then
                        '    File.Delete(pAtttacment & namaINF)
                        'End If

                        'clsGeneral.up_displayLog(GlobalSetting.clsGlobal.MsgTypeEnum.InformationMsg, "Move files to archive", LogName)
                        'LogName.Refresh()

                        Call up_UpdateStatusPO_Domestic(pAffiliate, pInvoiceNo, errMsg)
                    End If

                    log.WriteToProcessLog(Date.Now, "SendDataEDI", "Finish Create E.D.I InvoiceNo [" & pInvoiceNo & "], Affiliate [" & pAffiliate & "]")
                Next
            Else
                errMsg = "-"
                ErrSummary = "-"
                Exit Try
            End If
        Catch ex As Exception
            errMsg = "InvoiceNo [" & pInvoiceNo & "] and Affiliate [" & pAffiliate & "]" & ex.Message
            ErrSummary = "InvoiceNo [" & pInvoiceNo & "] and Affiliate [" & pAffiliate & "]" & ex.Message
        End Try
    End Sub

    Shared Function uf_BindDataDetail_Domestic(ByVal GB As GlobalSetting.clsGlobal, ByVal pAffCode As String, ByVal pInvoiceNo As String) As DataSet
        Dim ls_SQL As String = ""

        ls_SQL = "EXEC sp_SendInvoiceEDI_Domestic '" & pInvoiceNo & "', '" & pAffCode & "'"

        Dim ds As New DataSet
        ds = GB.uf_GetDataSet(ls_SQL)
        Return ds
    End Function

    Shared Sub up_UpdateStatusPO_Domestic(ByVal pAffCode As String, ByVal pInvoiceNo As String, ByRef errMsg As String)
        Dim ls_SQL As String = ""
        Dim cfg As New GlobalSetting.clsConfig

        Try
            Using sqlConn As New SqlConnection(cfg.ConnectionString)
                sqlConn.Open()
                ls_SQL = " UPDATE dbo.PLPASI_Master " & vbCrLf & _
                      " SET EDICls='2'" & vbCrLf & _
                      " WHERE AffiliateID ='" & pAffCode & "' " & vbCrLf & _
                      " AND InvoiceNo ='" & pInvoiceNo & "' "
                Dim sqlComm As New SqlCommand(ls_SQL, sqlConn)
                sqlComm.ExecuteNonQuery()
                sqlComm.Dispose()
                sqlConn.Close()
            End Using
        Catch ex As Exception
            errMsg = "Process Send Global E.D.I InvoiceNo [" & pInvoiceNo & "] and AffiliateID [" & pAffCode & "] STOPPED, because " & ex.Message
        End Try
    End Sub

    Shared Sub up_SendInvoiceEDI_Export(ByVal cfg As GlobalSetting.clsConfig,
                          ByVal log As GlobalSetting.clsLog,
                          ByVal GB As GlobalSetting.clsGlobal,
                          ByVal LogName As RichTextBox,
                          ByVal pAtttacment As String,
                          ByVal pResult As String,
                          Optional ByRef errMsg As String = "",
                          Optional ByRef ErrSummary As String = "")

        Dim xi As Integer

        Dim ds As New DataSet
        Dim dsDetail As New DataSet
        Dim dsPass As New DataSet

        Dim ls_SQL As String = ""
        Dim pAffiliate As String = ""
        Dim pInvoiceNo As String = ""
        Dim ls_AffCode As String = ""
        Dim fp As StreamWriter
        Dim namaFile As String = ""
        Dim namaINF As String = ""
        Dim namaBAT As String = ""
        Dim namaPUT As String = ""
        Dim ls_Time As Date

        Try
            log.WriteToProcessLog(Date.Now, "SendDataEDI", "Get data Invoice")

            ls_SQL = "SELECT AF.ConsigneeCode, SM.AffiliateID, SM.ShippingInstructionNo " & vbCrLf & _
                "FROM ShippingInstruction_Master SM " & vbCrLf & _
                "INNER JOIN MS_Affiliate AF ON SM.AffiliateID = AF.AffiliateID " & vbCrLf & _
                "WHERE SM.EDICls = '1'"

            ds = GB.uf_GetDataSet(ls_SQL)

            If ds.Tables(0).Rows.Count > 0 Then
                For xi = 0 To ds.Tables(0).Rows.Count - 1
                    pAffiliate = Trim(ds.Tables(0).Rows(xi)("AffiliateID"))
                    pInvoiceNo = Trim(ds.Tables(0).Rows(xi)("ShippingInstructionNo"))
                    ls_Time = Now

                    log.WriteToProcessLog(Date.Now, "SendDataEDI", "Create E.D.I InvoiceNo [" & pInvoiceNo & "], Affiliate [" & pAffiliate & "]")

                    dsDetail = uf_BindDataDetail_Export(GB, pAffiliate, pInvoiceNo)

                    If dsDetail.Tables(0).Rows.Count > 0 Then

                        ls_AffCode = Trim(ds.Tables(0).Rows(xi)("ConsigneeCode"))

                        namaFile = "INVOICE_DATA_" + Trim(ls_AffCode) + "_32G8." + Left(Trim(pInvoiceNo), 10) + "." + Format(ls_Time, "yyyyMMdd") + "." + Format(ls_Time, "hhmm") + "." + Format(ls_Time, "ss") + ""
                        namaINF = Format(ls_Time, "yyyyMMdd") + "." + Format(ls_Time, "hhmm") + "." + Format(ls_Time, "ss") + ".INF"
                        namaBAT = Format(ls_Time, "yyyyMMdd") + "." + Format(ls_Time, "hhmm") + "." + Format(ls_Time, "ss") + ".BAT"

                        '01. Crate FIle
                        fp = File.CreateText(pAtttacment & namaFile)
                        For x = 0 To dsDetail.Tables(0).Rows.Count - 1
                            fp.WriteLine(dsDetail.Tables(0).Rows(x)("a") & Format(x + 1, "00000"))
                        Next
                        fp.Close()

                        clsGeneral.up_displayLog(GlobalSetting.clsGlobal.MsgTypeEnum.InformationMsg, "Create E.D.I InvoiceNo [" & pInvoiceNo & "], Affiliate [" & pAffiliate & "]", LogName)
                        LogName.Refresh()

                        dsPass = uf_BindPass(GB, pAffiliate)

                        '02. Craete INF
                        fp = File.CreateText(pAtttacment & namaINF)
                        'fp.WriteLine("o 192.244.194.171 10021")
                        fp.WriteLine("o " & cfg.IPDestination)

                        If dsPass.Tables(0).Rows.Count > 0 Then
                            fp.WriteLine("user " & Trim(dsPass.Tables(0).Rows(0)("UserEDI")))
                            fp.WriteLine(Trim(dsPass.Tables(0).Rows(0)("PasswordEDI")))

                            'namaPUT = "PUT " & pAtttacment & namaFile & " ""$$ ID=" & Trim(dsPass.Tables(0).Rows(0)("MailBoxEDI")) & " BID=" & namaFile & " XMIT=Y"""
                            namaPUT = "PUT " & pAtttacment & namaFile & " " & Trim(dsPass.Tables(0).Rows(0)("MailBoxEDI")) & "/Rcv/" & namaFile
                            fp.WriteLine(namaPUT)
                        Else
                            fp.WriteLine("user ")
                            fp.WriteLine("")
                            fp.WriteLine("")
                        End If
                        fp.WriteLine("bye")
                        fp.Close()

                        clsGeneral.up_displayLog(GlobalSetting.clsGlobal.MsgTypeEnum.InformationMsg, "Create INF InvoiceNo [" & pInvoiceNo & "], Affiliate [" & pAffiliate & "]", LogName)
                        LogName.Refresh()

                        '03. Craete BAT
                        fp = File.CreateText(pAtttacment & namaBAT)
                        fp.WriteLine("D:")
                        fp.WriteLine("ftp -v -n -s:" & pAtttacment & namaINF)
                        fp.WriteLine("COPY " & pAtttacment & namaFile & " " & pResult)
                        fp.WriteLine("DEL " & pAtttacment & namaFile)
                        fp.WriteLine("EXIT")
                        fp.Close()

                        clsGeneral.up_displayLog(GlobalSetting.clsGlobal.MsgTypeEnum.InformationMsg, "Create BAT InvoiceNo [" & pInvoiceNo & "], Affiliate [" & pAffiliate & "]", LogName)
                        LogName.Refresh()

                        Dim proc As Process = Nothing
                        proc = New Process()
                        proc.StartInfo.WorkingDirectory = pAtttacment
                        proc.StartInfo.FileName = namaBAT
                        proc.StartInfo.CreateNoWindow = True
                        proc.Start()
                        proc.WaitForExit()

                        clsGeneral.up_displayLog(GlobalSetting.clsGlobal.MsgTypeEnum.InformationMsg, "Execute BAT File Bat [" & namaBAT & "]", LogName)
                        LogName.Refresh()

                        'File.Copy(pAtttacment & namaBAT, pResult & namaBAT)
                        'Thread.Sleep(1000)
                        'If Dir(pAtttacment & namaBAT) <> "" Then
                        '    File.Delete(pAtttacment & namaBAT)
                        'End If

                        'File.Copy(pAtttacment & namaINF, pResult & namaINF)
                        'Thread.Sleep(1000)
                        'If Dir(pAtttacment & namaINF) <> "" Then
                        '    File.Delete(pAtttacment & namaINF)
                        'End If

                        'clsGeneral.up_displayLog(GlobalSetting.clsGlobal.MsgTypeEnum.InformationMsg, "Move files to archive", LogName)
                        'LogName.Refresh()

                        Call up_UpdateStatusPO_Export(pAffiliate, pInvoiceNo, errMsg)
                    End If

                    log.WriteToProcessLog(Date.Now, "SendDataEDI", "Finish Create E.D.I InvoiceNo [" & pInvoiceNo & "], Affiliate [" & pAffiliate & "]")
                Next
            Else
                errMsg = "-"
                ErrSummary = "-"
                Exit Try
            End If
        Catch ex As Exception
            errMsg = "InvoiceNo [" & pInvoiceNo & "] and Affiliate [" & pAffiliate & "]" & ex.Message
            ErrSummary = "InvoiceNo [" & pInvoiceNo & "] and Affiliate [" & pAffiliate & "]" & ex.Message
        End Try
    End Sub

    Shared Function uf_BindDataDetail_Export(ByVal GB As GlobalSetting.clsGlobal, ByVal pAffCode As String, ByVal pInvoiceNo As String) As DataSet
        Dim ls_SQL As String = ""

        ls_SQL = "EXEC sp_SendInvoiceEDI_Export '" & pInvoiceNo & "', '" & pAffCode & "'"

        Dim ds As New DataSet
        ds = GB.uf_GetDataSet(ls_SQL)
        Return ds
    End Function

    Shared Sub up_UpdateStatusPO_Export(ByVal pAffCode As String, ByVal pInvoiceNo As String, ByRef errMsg As String)
        Dim ls_SQL As String = ""
        Dim cfg As New GlobalSetting.clsConfig

        Try
            Using sqlConn As New SqlConnection(cfg.ConnectionString)
                sqlConn.Open()
                ls_SQL = " UPDATE dbo.ShippingInstruction_Master " & vbCrLf & _
                      " SET EDICls='2'" & vbCrLf & _
                      " WHERE AffiliateID ='" & pAffCode & "' " & vbCrLf & _
                      " AND ShippingInstructionNo ='" & pInvoiceNo & "' "
                Dim sqlComm As New SqlCommand(ls_SQL, sqlConn)
                sqlComm.ExecuteNonQuery()
                sqlComm.Dispose()
                sqlConn.Close()
            End Using
        Catch ex As Exception
            errMsg = "Process Send Global E.D.I InvoiceNo [" & pInvoiceNo & "] and AffiliateID [" & pAffCode & "] STOPPED, because " & ex.Message
        End Try
    End Sub
End Class
