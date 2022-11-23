﻿<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/SiteContent.Master"
    CodeBehind="PORevisionExportList.aspx.vb" Inherits="PASISystem.PORevisionExportList" %>

<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.ASPxGridView.Export" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.ASPxGridView" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.ASPxEditors" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.ASPxGlobalEvents" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.ASPxRoundPanel" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.ASPxPanel" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .dxeHLC, .dxeHC, .dxeHFC
        {
            display: none;
        }
    </style>
    <script type="text/javascript">
        function OnInit(s, e) {
            AdjustSizeGrid();
        }
        function OnControlsInitializedGrid(s, e) {
            ASPxClientUtils.AttachEventToElement(window, "resize", function (evt) {
                AdjustSizeGrid();
            });
        }
        function AdjustSizeGrid() {

            var myWidth = 0, myHeight = 0;
            if (typeof (window.innerWidth) == 'number') {
                //Non-IE
                myWidth = window.innerWidth;
                myHeight = window.innerHeight;
            } else if (document.documentElement && (document.documentElement.clientWidth || document.documentElement.clientHeight)) {
                //IE 6+ in 'standards compliant mode'
                myWidth = document.documentElement.clientWidth;
                myHeight = document.documentElement.clientHeight;
            } else if (document.body && (document.body.clientWidth || document.body.clientHeight)) {
                //IE 4 compatible
                myWidth = document.body.clientWidth;
                myHeight = document.body.clientHeight;
            }

            var height = Math.max(0, myHeight);
            height = height - (height * 60 / 100)
            grid.SetHeight(height);
        }

        function OnBatchEditStartEditing(s, e) {
            currentColumnName = e.focusedColumn.fieldName;

            if (currentColumnName == "NoUrut" || currentColumnName == "Period" || currentColumnName == "AffiliateID"
            || currentColumnName == "PONo" || currentColumnName == "PORevNo" || currentColumnName == "POEmergencyCls" || currentColumnName == "CommercialCls"
            || currentColumnName == "ShipCls" || currentColumnName == "EntryDate" || currentColumnName == "EntryUser" || currentColumnName == "POStatus1"
            || currentColumnName == "POStatus2" || currentColumnName == "POStatus3" || currentColumnName == "POStatus4" || currentColumnName == "POStatus5"
            || currentColumnName == "POStatus6") {
                e.cancel = true;
            }

            currentEditableVisibleIndex = e.visibleIndex;
        }
        function SelectedIndexChangedAff() {
            txtAffiliateName.SetText(cboAffiliateCode.GetSelectedItem().GetColumnText(1));
            lblInfo.SetText('');
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content" runat="server">
    <table style="width: 100%;">
        <tr>
            <td valign="top" width="60%">
                <table style="border-width: 1pt thin thin thin; border-style: ridge; border-color: #9598A1;
                    width: 100%;">
                    <tr>
                        <td height="30">
                            <table id="Table1">
                                <tr>
                                    <td style="width: 5px;">
                                        &nbsp;
                                    </td>
                                    <td align="left" valign="middle" width="120px">
                                        <dx:ASPxLabel ID="ASPxLabel3" runat="server" Text="PERIOD" Font-Names="Tahoma" Font-Size="8pt"
                                            Width="100%">
                                        </dx:ASPxLabel>
                                    </td>
                                    <td align="left" valign="middle" width="150px">
                                        <dx:ASPxTimeEdit ID="dtPeriodFrom" runat="server" ClientInstanceName="dtPeriodFrom"
                                            DisplayFormatString="MMM yyyy" EditFormat="Custom" EditFormatString="MMM yyyy"
                                            Width="150px" Font-Names="Tahoma" Font-Size="8pt">
                                        </dx:ASPxTimeEdit>
                                    </td>
                                    <td align="left" valign="middle" width="10px">
                                        <dx:ASPxLabel ID="ASPxLabel4" runat="server" Text="~" Font-Names="Tahoma" Font-Size="8pt"
                                            Width="10px">
                                        </dx:ASPxLabel>
                                    </td>
                                    <td align="left" valign="middle" width="150px">
                                        <dx:ASPxTimeEdit ID="dtPeriodTo" runat="server" ClientInstanceName="dtPeriodTo" DisplayFormatString="MMM yyyy"
                                            EditFormat="Custom" EditFormatString="MMM yyyy" Width="150px" Font-Names="Tahoma"
                                            Font-Size="8pt">
                                        </dx:ASPxTimeEdit>
                                    </td>
                                    <td align="left" valign="middle" width="50px">
                                        &nbsp;</td>
                                    <td align="left" valign="middle" width="165px">
                                        &nbsp;</td>
                                </tr>
                                <tr>
                                    <td style="width: 5px;">
                                    </td>
                                    <td align="left" valign="middle" width="120px">
                                        <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="AFFILIATE CODE/NAME" Font-Names="Tahoma"
                                            Font-Size="8pt" Width="150px">
                                        </dx:ASPxLabel>
                                    </td>
                                    <td align="left" valign="middle" width="150px">
                                        <dx:ASPxComboBox ID="cboAffiliateCode" runat="server" TextFormatString="{0}" DropDownStyle="DropDown"
                                            Width="150px" ClientInstanceName="cboAffiliateCode" IncrementalFilteringMode="StartsWith"
                                            Font-Names="Tahoma" Font-Size="8pt" MaxLength="10" TabIndex="4">
                                            <ClientSideEvents SelectedIndexChanged="function(s, e) {SelectedIndexChangedAff();}"
                                                LostFocus="function(s, e) { lblInfo.SetText(&quot;&quot;); }" />
                                        </dx:ASPxComboBox>
                                    </td>
                                    <td align="left" valign="middle" colspan="4" width="360px">
                                        <dx:ASPxTextBox ID="txtAffiliateName" runat="server" ClientInstanceName="txtAffiliateName"
                                            Width="370px" Height="20px" ReadOnly="True" TabIndex="5" Font-Names="Tahoma"
                                            Font-Size="8pt">
                                            <ReadOnlyStyle BackColor="#CCCCCC">
                                            </ReadOnlyStyle>
                                        </dx:ASPxTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 5px;">
                                    </td>
                                    <td align="left" valign="middle" width="80px">
                                        <dx:ASPxLabel ID="ASPxLabel6" runat="server" Text="PASI SEND TO SUPPLIER" Font-Names="Tahoma"
                                            Font-Size="8pt" Width="150px">
                                        </dx:ASPxLabel>
                                    </td>
                                    <td align="left" valign="middle" width="150px">
                                        <dx:ASPxRadioButtonList ID="rblSendTo" runat="server" RepeatDirection="Horizontal"
                                            Width="150px" ClientInstanceName="rblSendTo" SelectedIndex="0" TabIndex="8" Font-Names="Tahoma"
                                            Font-Size="8pt">
                                            <RadioButtonStyle HorizontalAlign="Left">
                                            </RadioButtonStyle>
                                            <Items>
                                                <dx:ListEditItem Text="ALL" Value="2" Selected="True" />
                                                <dx:ListEditItem Text="YES" Value="1" />
                                                <dx:ListEditItem Text="NO" Value="0" />
                                            </Items>
                                            <Border BorderStyle="None"></Border>
                                        </dx:ASPxRadioButtonList>
                                    </td>
                                    <td align="left" valign="middle" width="360px" colspan="4">
                                        &nbsp;</td>
                                </tr>
                                <tr>
                                    <td style="width: 5px;">
                                        &nbsp;
                                    </td>
                                    <td align="left" valign="middle" width="80px">
                                        <dx:ASPxLabel ID="ASPxLabel2" runat="server" Text="PASI MONTHLY / EMERGENCY" Font-Names="Tahoma"
                                            Font-Size="8pt" Width="150px">
                                        </dx:ASPxLabel>
                                    </td>
                                    <td align="left" valign="middle" width="150px">
                                        <dx:ASPxRadioButtonList ID="rblMonthlyEme" runat="server" RepeatDirection="Horizontal"
                                            Width="150px" ClientInstanceName="rblMonthlyEme" SelectedIndex="0" 
                                            TabIndex="8" Font-Names="Tahoma"
                                            Font-Size="8pt">
                                            <RadioButtonStyle HorizontalAlign="Left">
                                            </RadioButtonStyle>
                                            <Items>
                                                <dx:ListEditItem Text="ALL" Value="2" Selected="True" />
                                                <dx:ListEditItem Text="MONTHLY" Value="1" />
                                                <dx:ListEditItem Text="EMERGENCY" Value="0" />
                                            </Items>
                                            <Border BorderStyle="None"></Border>
                                        </dx:ASPxRadioButtonList>
                                    </td>
                                    <td align="left" valign="middle" width="80px" colspan="4">
                                        &nbsp;</td>
                                </tr>
                                <tr>
                                    <td style="width: 5px;">
                                        &nbsp;
                                    </td>
                                    <td align="left" valign="middle" width="80px">
                                        <dx:ASPxLabel ID="ASPxLabel7" runat="server" Text="COMMERCIAL" Font-Names="Tahoma"
                                            Font-Size="8pt" Width="100%">
                                        </dx:ASPxLabel>
                                    </td>
                                    <td align="left" valign="middle" width="150px">
                                        <dx:ASPxRadioButtonList ID="rblCommercial" runat="server" RepeatDirection="Horizontal"
                                            Width="150px" ClientInstanceName="rblCommercial" SelectedIndex="0" TabIndex="9"
                                            Font-Names="Tahoma" Font-Size="8pt">
                                            <RadioButtonStyle HorizontalAlign="Left">
                                            </RadioButtonStyle>
                                            <Items>
                                                <dx:ListEditItem Text="ALL" Value="2" Selected="True" />
                                                <dx:ListEditItem Text="YES" Value="1" />
                                                <dx:ListEditItem Text="NO" Value="0" />
                                            </Items>
                                            <Border BorderStyle="None"></Border>
                                        </dx:ASPxRadioButtonList>
                                    </td>
                                    <td align="left" valign="middle" width="80px" colspan="2">
                                        &nbsp;
                                    </td>
                                    <td align="left" valign="middle" width="120px" colspan="2">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td align="right" valign="middle">
                                                    <dx:ASPxButton ID="btnRefresh" runat="server" Text="SEARCH" Font-Names="Tahoma" Width="85px"
                                                        AutoPostBack="False" Font-Size="8pt" ClientInstanceName="btnRefresh" TabIndex="10">
                                                        <ClientSideEvents Click="function(s, e) {
                                                            var pDateFrom = dtPeriodFrom.GetText();
                                                            var pDateTo = dtPeriodTo.GetText();
                                                            var pAffCode= cboAffiliateCode.GetText();
                                                            var pSendTo = rblMonthlyEme.GetValue();
                                                            var pMonthly = rblSendTo.GetValue();
                                                            var pComm = rblCommercial.GetValue();
                                                            
                                                            grid.PerformCallback('load' + '|' + pDateFrom + '|' + pDateTo + '|' + pAffCode + '|' + pSendTo + '|' + pMonthly + '|' + pComm);
                                                            lblInfo.SetText('');
                                                        }" />
                                                    </dx:ASPxButton>
                                                </td>
                                                <td align="right" valign="middle">
                                                    <dx:ASPxButton ID="btnClear" runat="server" Text="CLEAR" Font-Names="Tahoma" Width="85px"
                                                        AutoPostBack="False" Font-Size="8pt" ClientInstanceName="btnClear" TabIndex="11">
                                                        <ClientSideEvents Click="function(s, e) {
                                                            lblInfo.SetText('');
                                                            grid.SetFocusedRowIndex(-1);
                                                            grid.PerformCallback('kosong');
                                                        }" />
                                                    </dx:ASPxButton>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
            <td valign="top" width="40%" align="left">
                <dx:ASPxRoundPanel ID="ASPxRoundPanel1" runat="server" HeaderText="PO STATUS" ShowCollapseButton="true"
                    View="GroupBox" Width="100%" Font-Size="8pt" Font-Names="Tahoma">
                    <PanelCollection>
                        <dx:PanelContent ID="PanelContent1" runat="server">
                            <table id="Table2">
                                <tr>
                                    <td align="left" height="20px" valign="middle" width="50%">
                                        <dx:ASPxLabel ID="ASPxLabel8" runat="server" Font-Names="Tahoma" Font-Size="8pt"
                                            ForeColor="#003366" Text="(1) PASI ENTRY" Width="100%">
                                        </dx:ASPxLabel>
                                    </td>
                                    <td align="left" height="20px" valign="middle" width="50%">
                                        <dx:ASPxLabel ID="ASPxLabel18" runat="server" Font-Names="Tahoma" 
                                            Font-Size="8pt" ForeColor="#003366" Text="(4) SUPPLIER APPROVAL (PARTIAL)" 
                                            Width="100%">
                                        </dx:ASPxLabel>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" height="20px" valign="middle" width="50%">
                                        <dx:ASPxLabel ID="ASPxLabel12" runat="server" Font-Names="Tahoma" 
                                            Font-Size="8pt" ForeColor="#003366" 
                                            Text="(2) PASI SEND AFFILIATE PO TO SUPPLIER" Width="100%">
                                        </dx:ASPxLabel>
                                    </td>
                                    <td align="left" height="20px" valign="middle" width="50%">
                                        <dx:ASPxLabel ID="ASPxLabel15" runat="server" Font-Names="Tahoma" Font-Size="8pt"
                                            ForeColor="#003366" Text="(5) SUPPLIER UNAPPROVE" Width="100%">
                                        </dx:ASPxLabel>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" height="20px" valign="middle" width="50%">
                                        <dx:ASPxLabel ID="ASPxLabel13" runat="server" Font-Names="Tahoma" 
                                            Font-Size="8pt" ForeColor="#003366" Text="(3) SUPPLIER APPROVAL(FULL)" 
                                            Width="100%">
                                        </dx:ASPxLabel>
                                    </td>
                                    <td align="left" height="20px" valign="middle" width="50%">
                                        <dx:ASPxLabel ID="ASPxLabel17" runat="server" Font-Names="Tahoma" 
                                            Font-Size="8pt" ForeColor="#003366" Text="(6) PASI FINAL APPROVAL" Width="100%">
                                        </dx:ASPxLabel>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" height="20px" valign="middle" width="50%">
                                        &nbsp;</td>
                                    <td align="left" height="20px" valign="middle" width="50%">
                                        &nbsp;</td>
                                </tr>
                            </table>
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxRoundPanel>
            </td>
        </tr>
    </table>
    <div style="height: 1px;">
    </div>
    <table style="width: 100%; height: 15px;">
        <tr>
            <td colspan="8" height="15">
                <%--error message--%>
                <table id="tblMsg" style="border-width: thin; border-style: inset hidden ridge hidden;
                    border-color: #9598A1; width: 100%; height: 15px;">
                    <tr>
                        <td align="left" valign="middle" height="15px">
                            <dx:ASPxLabel ID="lblInfo" runat="server" Text="[lblinfo]" Font-Names="Tahoma" ClientInstanceName="lblInfo"
                                Font-Bold="True" Font-Italic="True" Font-Size="8pt">
                            </dx:ASPxLabel>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <div style="height: 1px;">
    </div>
    <table style="width: 100%;">
        <tr>
            <td valign="top" align="right" style="width: 50px;">
            </td>
            <td valign="top" align="right" style="width: 50px;">
                &nbsp;
            </td>
        </tr>
        <tr>
            <td colspan="8" align="left" valign="top" height="220">
                <%--Column : Grid--%>
                <dx:ASPxGridView ID="grid" runat="server" Width="100%" Font-Names="Tahoma" KeyFieldName="NoUrut;AffiliateID;PONo;PORevNo"
                    AutoGenerateColumns="False" ClientInstanceName="grid" Font-Size="8pt" TabIndex="12">
                    <ClientSideEvents Init="OnInit" FocusedRowChanged="function(s, e) {OnGridFocusedRowChanged();}"
                        EndCallback="function(s, e) {
                        var pMsg = s.cpMessage;
                        if (pMsg != '') {
                            if (pMsg.substring(1,5) == '1001' || pMsg.substring(1,5) == '1002' || pMsg.substring(1,5) == '1003' || pMsg.substring(1,5) == '2001' || pMsg.substring(1,5) == '1008') {
                                lblInfo.GetMainElement().style.color = 'Blue';
                            } else {
                                lblInfo.GetMainElement().style.color = 'Red';
                            }
                            lblInfo.SetText(pMsg);
                        } else {
                            lblInfo.SetText('');
                        }
                        delete s.cpMessage;
                        }" RowClick="function(s, e) {
	                    lblInfo.SetText('');}" BatchEditStartEditing="OnBatchEditStartEditing" />
                    <Columns>
                        <dx:GridViewDataHyperLinkColumn Caption=" " FieldName="coldetail" Name="coldetail"
                            VisibleIndex="0" Width="65px">
                            <PropertiesHyperLinkEdit TextField="DetailPage">
                            </PropertiesHyperLinkEdit>
                            <HeaderStyle Font-Names="Tahoma" Font-Size="8pt" Font-Underline="False" Wrap="True" />
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt" VerticalAlign="Middle">
                            </CellStyle>
                        </dx:GridViewDataHyperLinkColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="1" Caption="NO" FieldName="NoUrut" Width="30px"
                            HeaderStyle-HorizontalAlign="Center">
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="2" Caption="PERIOD" FieldName="Period" Width="80px"
                            HeaderStyle-HorizontalAlign="Center">
                            <PropertiesTextEdit DisplayFormatString="MMM yyyy">
                            </PropertiesTextEdit>
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="3" Caption="AFFILIATE CODE" FieldName="AffiliateID"
                            Width="75px" HeaderStyle-HorizontalAlign="Center">
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="ORDER NO." VisibleIndex="4" Width="75px" FieldName="PONo"
                            HeaderStyle-HorizontalAlign="Center">
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="REV NO." VisibleIndex="5" Width="75px" FieldName="PORevNo"
                            HeaderStyle-HorizontalAlign="Center">
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="PO EMERGENCY (EMERGENCY/MONTHLY)" 
                            VisibleIndex="6" Width="150px" FieldName="EmergencyCls"
                            HeaderStyle-HorizontalAlign="Center">
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="7" Caption="COMMERCIAL" FieldName="CommercialCls"
                            Width="100px" HeaderStyle-HorizontalAlign="Center">
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="8" Caption="SHIP BY (BOAT/AIR)" FieldName="ShipCls"
                            Width="75px" HeaderStyle-HorizontalAlign="Center">
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="9" Caption="CREATED DATE" FieldName="EntryDate"
                            HeaderStyle-HorizontalAlign="Center" Width="140px">
                            <PropertiesTextEdit DisplayFormatString="yyyy-MM-dd HH:mm:ss">
                            </PropertiesTextEdit>
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="10" Caption="CREATED USER" FieldName="EntryUser"
                            HeaderStyle-HorizontalAlign="Center">
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewBandColumn Caption="PO STATUS" VisibleIndex="11">
                            <Columns>
                                <dx:GridViewDataCheckColumn Caption="1" FieldName="POStatus1" ReadOnly="True" VisibleIndex="1"
                                    Width="30px">
                                    <PropertiesCheckEdit ValueChecked="1" ValueType="System.String" ValueUnchecked="0">
                                        <DisplayImageChecked IconID="support_feature_16x16">
                                        </DisplayImageChecked>
                                        <DisplayImageUnchecked Width="0px">
                                        </DisplayImageUnchecked>
                                        <CheckBoxStyle>
                                            <Border BorderStyle="None" />
                                        </CheckBoxStyle>
                                    </PropertiesCheckEdit>
                                    <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                </dx:GridViewDataCheckColumn>
                                <dx:GridViewDataCheckColumn Caption="2" FieldName="POStatus2" ReadOnly="True" VisibleIndex="3"
                                    Width="30px">
                                    <PropertiesCheckEdit ValueChecked="1" ValueType="System.String" ValueUnchecked="0">
                                        <DisplayImageChecked IconID="support_feature_16x16">
                                        </DisplayImageChecked>
                                        <DisplayImageUnchecked Width="0px">
                                        </DisplayImageUnchecked>
                                    </PropertiesCheckEdit>
                                    <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                </dx:GridViewDataCheckColumn>
                                <dx:GridViewDataCheckColumn Caption="3" FieldName="POStatus3" ReadOnly="True" VisibleIndex="5"
                                    Width="30px">
                                    <PropertiesCheckEdit ValueChecked="1" ValueType="System.String" ValueUnchecked="0">
                                        <DisplayImageChecked IconID="support_feature_16x16">
                                        </DisplayImageChecked>
                                        <DisplayImageUnchecked Width="0px">
                                        </DisplayImageUnchecked>
                                    </PropertiesCheckEdit>
                                    <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                </dx:GridViewDataCheckColumn>
                                <dx:GridViewDataCheckColumn Caption="4" FieldName="POStatus4" ReadOnly="True" VisibleIndex="7"
                                    Width="30px">
                                    <PropertiesCheckEdit ValueChecked="1" ValueType="System.String" ValueUnchecked="0">
                                        <DisplayImageChecked IconID="support_feature_16x16">
                                        </DisplayImageChecked>
                                        <DisplayImageUnchecked Width="0px">
                                        </DisplayImageUnchecked>
                                    </PropertiesCheckEdit>
                                </dx:GridViewDataCheckColumn>
                                <dx:GridViewDataCheckColumn Caption="5" FieldName="POStatus5" ReadOnly="True" VisibleIndex="9"
                                    Width="30px">
                                    <PropertiesCheckEdit ValueChecked="1" ValueType="System.String" ValueUnchecked="0">
                                        <DisplayImageChecked IconID="support_feature_16x16">
                                        </DisplayImageChecked>
                                        <DisplayImageUnchecked Width="0px">
                                        </DisplayImageUnchecked>
                                    </PropertiesCheckEdit>
                                    <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                </dx:GridViewDataCheckColumn>
                                <dx:GridViewDataCheckColumn Caption="6" FieldName="POStatus6" ReadOnly="True" VisibleIndex="11"
                                    Width="30px">
                                    <PropertiesCheckEdit ValueChecked="1" ValueType="System.String" ValueUnchecked="0">
                                        <DisplayImageChecked IconID="support_feature_16x16">
                                        </DisplayImageChecked>
                                        <DisplayImageUnchecked Width="0px">
                                        </DisplayImageUnchecked>
                                    </PropertiesCheckEdit>
                                    <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                </dx:GridViewDataCheckColumn>
                            </Columns>
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        </dx:GridViewBandColumn>    
                    </Columns>
                    <SettingsBehavior AllowSelectByRowClick="True" AllowSort="False" ColumnResizeMode="Control"
                        EnableRowHotTrack="True" />
                    <SettingsBehavior AllowSort="False" AllowSelectByRowClick="True" ColumnResizeMode="Control"
                        EnableRowHotTrack="True"></SettingsBehavior>
                    <SettingsPager Visible="False" PageSize="13" Position="Top">
                        <Summary Text="Page {0} of {1} [{2} record(s)]" AllPagesText="Page {0} of {1} " />
                        <Summary AllPagesText="Page {0} of {1} " Text="Page {0} of {1} [{2} record(s)]">
                        </Summary>
                    </SettingsPager>
                    <SettingsEditing Mode="Batch" NewItemRowPosition="Bottom">
                        <BatchEditSettings ShowConfirmOnLosingChanges="False" />
                        <BatchEditSettings ShowConfirmOnLosingChanges="False"></BatchEditSettings>
                    </SettingsEditing>
                    <Settings ShowHorizontalScrollBar="True" ShowVerticalScrollBar="True" ShowGroupButtons="False"
                        ShowStatusBar="Hidden" VerticalScrollableHeight="190" />
                    <Settings ShowGroupButtons="False" ShowVerticalScrollBar="True" ShowHorizontalScrollBar="True"
                        VerticalScrollableHeight="190" ShowStatusBar="Hidden"></Settings>
                    <SettingsCommandButton EditButton-ButtonType="Link">
                        <EditButton Text="Detail">
                        </EditButton>
                    </SettingsCommandButton>
                    <StylesEditors ButtonEditCellSpacing="0">
                        <ProgressBar Height="21px">
                        </ProgressBar>
                    </StylesEditors>
                </dx:ASPxGridView>
            </td>
        </tr>
    </table>
    <div style="height: 8px;">
    </div>
    <table id="button" style="width: 100%;">
        <tr>
            <td valign="top" align="left">
                <dx:ASPxButton ID="btnSubMenu" runat="server" Text="SUB MENU" Font-Names="Tahoma"
                    Width="85px" Font-Size="8pt" TabIndex="13">
                </dx:ASPxButton>
            </td>
        </tr>
    </table>
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="function(s, e) {
	        OnControlsInitializedSplitter();
	        OnControlsInitializedGrid();
        }" />
    </dx:ASPxGlobalEvents>
</asp:Content>
