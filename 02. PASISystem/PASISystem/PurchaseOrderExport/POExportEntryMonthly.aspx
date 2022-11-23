﻿<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/SiteContent.Master" CodeBehind="POExportEntryMonthly.aspx.vb" Inherits="PASISystem.POExportEntryMonthly" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxGridView.Export" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxGridView" TagPrefix="dx" %>
<%@ Register assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxEditors" tagprefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxGlobalEvents" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxPanel" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxRoundPanel" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxCallback" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxHiddenField" TagPrefix="dx" %>
<%@ Register assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxUploadControl" tagprefix="dx" %>
<%@ Register assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxHiddenField" tagprefix="dx1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .dxeHLC, .dxeHC, .dxeHFC
        {
            display: none;
        }
        .style1
        {
            width: 170px;   
        }
        .style2
        {
            width: 120px;   
        }
        .style3
        {
            width: 250px;   
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
            height = height - (height * 65 / 100)
            grid.SetHeight(height);
        }

        function OnBatchEditStartEditing(s, e) {
            currentColumnName = e.focusedColumn.fieldName;

            if (currentColumnName == "NoUrut" || currentColumnName == "PartNo" || currentColumnName == "PartName" || currentColumnName == "UnitCls"
                || currentColumnName == "MOQ" || currentColumnName == "PONo" || currentColumnName == "QtyBox"
                || currentColumnName == "PreviousForecast" || currentColumnName == "Variance" || currentColumnName == "VariancePercentage"
                 || currentColumnName == "TotalPOQty" || currentColumnName == "AffiliateID" || currentColumnName == "SupplierID" || currentColumnName == "Period") {
                e.cancel = true;

            }

            currentEditableVisibleIndex = e.visibleIndex;
        }

        function OnBatchEditEndEditing(s, e) {
            currentEditableVisibleIndex = -1;

            window.setTimeout(function () {
                var Week1 = s.batchEditApi.GetCellValue(e.visibleIndex, "Week1");
                var PreviousForecast = s.batchEditApi.GetCellValue(e.visibleIndex, "PreviousForecast");

                s.batchEditApi.SetCellValue(e.visibleIndex, "Variance", parseInt(Week1) - parseInt(PreviousForecast));

                if (PreviousForecast == "0.00") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, "VariancePercentage", parseInt(0));
                }
                else {
                    s.batchEditApi.SetCellValue(e.visibleIndex, "VariancePercentage", (parseInt(Week1) - (PreviousForecast) / (PreviousForecast)) * 100 / 100);

                    if (((parseInt(Week1) - (PreviousForecast) / (PreviousForecast)) * 100 / 100) > 30) {
                        s.GetRow(s.GetFocusedRowIndex()).style.backgroundColor = "magenta";
                    }
                    else {
                        s.GetRow(s.GetFocusedRowIndex()).style.backgroundColor = "lightyellow";
                    }
                }
            }, 10);
        }

        function validasisubmit() {
            lblInfo.GetMainElement().style.color = 'Red';

            if (cboAffiliate.GetText() == "") {
                lblInfo.SetText("[6011] Please Select Affiliate Code First !");
                cboAffiliate.Focus();
                e.ProcessOnServer = false;
                return false;
            }

            if (txtpono.GetText() == "") {
                lblInfo.SetText("[6011] Please Input PO No. First !");
                txtpono.Focus();
                e.ProcessOnServer = false;
                return false;
            }

            if (txtPartNo.GetText() == "") {
                lblInfo.SetText("[6011] Please Input Part No. First !");
                txtPartNo.Focus();
                e.ProcessOnServer = false;
                return false;
            }

            if (txtPartName.GetText() == "") {
                lblInfo.SetText("[6011] Part No. Doesn't exists !");
                txtPartNo.Focus();
                e.ProcessOnServer = false;
                return false;
            }
        }

        function up_Insert() {
            var pIsUpdate = '';

            grid.PerformCallback('additem|' + pIsUpdate + '|');
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Content" runat="server">
    <table style="width:100%;">
        <tr>
            <td colspan="16" width="100%">
                <table style="border-width: 1pt thin thin thin; border-style: ridge; border-color:#9598A1; width:100%; height: 70px;">
                    <tr>
                        <td colspan="8" height="20">
                            <table id="Table1" width="100%">
                                <tr>
                                    <td align="left" valign="middle" class="style1">
                                        <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="PERIOD"
                                            Font-Names="Tahoma" Font-Size="8pt" Width="100%">
                                        </dx:ASPxLabel>
                                    </td>
                                    <td align="left" valign="middle" colspan="2" class="style2">
                                        <dx:ASPxTimeEdit ID="dtPeriodFrom" runat="server"
                                            ClientInstanceName="dtPeriodFrom" DisplayFormatString="yyyy-MM" 
                                            EditFormat="Custom" EditFormatString="yyyy-MM" Width="75px" 
                                            Height="21px" ReadOnly="True">
                                            <ClientSideEvents DateChanged="function(s, e) {
	                                            gridPerformCallback('kosong');
                                            }" />
                                        </dx:ASPxTimeEdit>
                                    </td>
                                    <td width="15">&nbsp;</td>
                                    <td align="left" colspan="3" class="style3">
                                        <table style="width:100%;">
                                            <tr>
                                                <td width="50%">
                                                    <dx:ASPxLabel ID="ASPxLabel4" runat="server" Text="COMMERCIAL"
                                                        Font-Names="Tahoma" Font-Size="8pt" Width="100%">
                                                    </dx:ASPxLabel>
                                                </td>
                                                <td align="left" width="25%">
                                                    <dx:ASPxRadioButton ID="rdrCom1" ClientInstanceName="rdrCom1" runat="server" 
                                                        Text="YES" GroupName="Commercial" Font-Names="Tahoma" Font-Size="8pt" 
                                                        ReadOnly="True">
                                                        <ClientSideEvents LostFocus="function(s, e) {
                                                            lblInfo.SetText('');
                                                        }" />
                                                    </dx:ASPxRadioButton>
                                                </td>
                                                <td align="left" width="25%">
                                                    <dx:ASPxRadioButton ID="rdrCom2" ClientInstanceName="rdrCom2" runat="server" 
                                                        Text="NO" GroupName="Commercial" Font-Names="Tahoma" Font-Size="8pt" 
                                                        ReadOnly="True">
                                                        <ClientSideEvents LostFocus="function(s, e) {
                                                            lblInfo.SetText('');                                                         
                                                        }" />
                                                    </dx:ASPxRadioButton>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td width="15">&nbsp;</td>
                                    <td align="left" colspan="3" class="style3">
                                        <table style="width:100%;">
                                            <tr>
                                                <td align="left" valign="middle" colspan="2" width="50%">
                                                    <dx:ASPxLabel ID="ASPxLabel32" runat="server" Text="DELIVERY LOCATION"
                                                        Font-Names="Tahoma" Font-Size="8pt" width="100%">
                                                    </dx:ASPxLabel>
                                                </td>
                                                <td align="left" valign="middle" colspan="2" width="50%">
                                                    <dx:ASPxComboBox ID="cboDelLoc" width="100%" runat="server" 
                                                        Font-Size="8pt" Font-Names="Tahoma" TextFormatString="{0}" 
                                                        ClientInstanceName="cboDelLoc" TabIndex="3" ReadOnly="True">
                                                        <ClientSideEvents SelectedIndexChanged="function(s, e) {
	                                                        txtDelLoc.SetText(cboDelLoc.GetSelectedItem().GetColumnText(1));
	                                                        lblInfo.SetText('');
                                                        }" />
                                                        <LoadingPanelStyle ImageSpacing="5px">
                                                        </LoadingPanelStyle>
                                                    </dx:ASPxComboBox>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td align="left" valign="middle" colspan="3" class="style3">
                                        <dx:ASPxTextBox ID="txtDelLoc" runat="server" Width="100%" 
                                            ClientInstanceName="txtDelLoc" Font-Names="Tahoma" Font-Size="8pt"
                                            ReadOnly="True" MaxLength="100" Height="20px">
                                            <readonlystyle backcolor="#CCCCCC">
                                            </readonlystyle>
                                        </dx:ASPxTextBox>
                                    </td>
                                    <td>&nbsp;</td>
                                </tr>

                                <tr>
                                    <td align="left" valign="middle" class="style1">
                                        <dx:ASPxLabel ID="ASPxLabel5" runat="server" Text="PO MONTHLY /EMERGENCY"
                                            Font-Names="Tahoma" Font-Size="8pt" width="100%">
                                        </dx:ASPxLabel>
                                    </td>
                                    <td align="left" colspan="3" class="style2">
                                        <table style="width:100%;">
                                            <tr>
                                                <td align="left" valign="middle" height="20px" width="50%">
                                                    <dx:ASPxRadioButton ID="rdMonthly" runat="server" 
                                                        ClientInstanceName="rdMonthly" Text="M" GroupName="ME">
                                                    </dx:ASPxRadioButton>
                                                </td>
                                                <td align="left" valign="middle" height="20px" width="50%">
                                                    <dx:ASPxRadioButton ID="rdEmergency" runat="server" 
                                                        ClientInstanceName="rdEmergency" Text="E" GroupName="ME">
                                                    </dx:ASPxRadioButton>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td align="left" colspan="3" class="style3">
                                        <table style="width:100%;">
                                            <tr>
                                                <td width="50%">
                                                    <dx:ASPxLabel ID="ASPxLabel2" runat="server" Text="SHIP BY"
                                                        Font-Names="Tahoma" Font-Size="8pt" Width="100%">
                                                    </dx:ASPxLabel>
                                                </td>
                                                <td width="25%">
                                                    <dx:ASPxRadioButton ID="rdrShipBy2" ClientInstanceName="rdrShipBy2" runat="server" 
                                                        Text="BOAT" GroupName="POEm" Font-Names="Tahoma" Font-Size="8pt" 
                                                        ReadOnly="True">
                                                        <ClientSideEvents LostFocus="function(s, e) {                                                        
                                                            lblInfo.SetText('');
                                                        }" />
                                                    </dx:ASPxRadioButton>
                                                </td>   
                                                <td width="25%">
                                                    <dx:ASPxRadioButton ID="rdrShipBy3" ClientInstanceName="rdrShipBy3" runat="server" 
                                                        Text="AIR" GroupName="POEm" Font-Names="Tahoma" Font-Size="8pt" 
                                                        ReadOnly="True">
                                                        <ClientSideEvents LostFocus="function(s, e) {
                                                            lblInfo.SetText('');                                                         
                                                        }" />
                                                    </dx:ASPxRadioButton>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                </tr>
                                        
                                <tr>
                                    <td align="left" valign="middle" class="style1">
                                        <dx:ASPxLabel ID="ASPxLabel20" runat="server" Text="AFFILIATE CODE/NAME"
                                            Font-Names="Tahoma" Font-Size="8pt">
                                        </dx:ASPxLabel>
                                    </td>
                                    <td align="left" valign="middle" colspan="2" class="style2">
                                        <dx:ASPxComboBox ID="cboAffiliate" width="100%" runat="server" 
                                            Font-Size="8pt" Font-Names="Tahoma" TextFormatString="{0}" 
                                            ClientInstanceName="cboAffiliate" TabIndex="3" ReadOnly="True">
                                            <ClientSideEvents SelectedIndexChanged="function(s, e) {
	                                            txtAffiliate.SetText(cboAffiliate.GetSelectedItem().GetColumnText(1));
                                                txtconsignee.SetText(cboAffiliate.GetSelectedItem().GetColumnText(2));
	                                            lblInfo.SetText('');
                                            }" />
                                            <LoadingPanelStyle ImageSpacing="5px">
                                            </LoadingPanelStyle>
                                        </dx:ASPxComboBox>
                                    </td>
                                    <td>&nbsp;</td>
                                    <td align="left" colspan="3" class="style3">
                                        <dx:ASPxTextBox ID="txtAffiliate" runat="server" Width="100%" 
                                            ClientInstanceName="txtAffiliate" Font-Names="Tahoma" Font-Size="8pt"
                                            ReadOnly="True" MaxLength="100" Height="20px">
                                            <readonlystyle backcolor="#CCCCCC">
                                            </readonlystyle>
                                        </dx:ASPxTextBox>
                                    </td>
                                    <td>&nbsp;</td>
                                    <td align="left" valign="middle" class="style3">
                                        <dx:ASPxTextBox ID="txtconsignee" runat="server" Width="0px" 
                                            ClientInstanceName="txtconsignee" ForeColor="White">
                                            <Border BorderStyle="None" />
                                        </dx:ASPxTextBox>
                                    </td>
                                </tr>
                                
                                <tr>
                                    <td align="left" valign="middle" class="style1">
                                        <dx:ASPxLabel ID="ASPxLabel34" runat="server" Text="ORDER NO"
                                            Font-Names="Tahoma" Font-Size="8pt">
                                        </dx:ASPxLabel>
                                    </td>
                                    <td align="left" valign="middle" colspan="2" class="style2">
                                        <dx:ASPxTextBox ID="txtOrderNo" runat="server" Width="100%" 
                                            ClientInstanceName="txtOrderNo" ReadOnly="True">
                                        </dx:ASPxTextBox>
                                    </td>
                                    <td>&nbsp;</td>
                                    <td align="left" colspan="3" class="style3">
                                        <table style="width:100%;">
                                            <tr>
                                                <td align="left" valign="middle" width="50%">
                                                    <dx:ASPxLabel ID="ASPxLabel35" runat="server" Text="ETD VENDOR"
                                                        Font-Names="Tahoma" Font-Size="8pt" Width="100%">
                                                    </dx:ASPxLabel>
                                                </td>
                                                <td align="right" valign="middle" width="50%">
                                                    <dx:ASPxDateEdit ID="dtETDVendor" runat="server" Width="100%" 
                                                        ClientInstanceName="dtETDVendor" DisplayFormatString="yyyy-MM-dd" 
                                                        EditFormat="Custom" EditFormatString="yyyy-MM-dd" ReadOnly="True">
                                                    </dx:ASPxDateEdit>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td>&nbsp;</td>
                                    <td align="left" colspan="3" class="style3">
                                        <table style="width:100%;">
                                            <tr>
                                                <td align="left" width="50%">
                                                    <dx:ASPxLabel ID="ASPxLabel36" runat="server" Text="ETD PORT"
                                                        Font-Names="Tahoma" Font-Size="8pt" Width="100%">
                                                    </dx:ASPxLabel>
                                                </td>
                                                <td align="right" valign="middle" width="50%">
                                                    <dx:ASPxDateEdit ID="dtETDPort" runat="server" Width="100%" 
                                                        ClientInstanceName="dtETDPort" DisplayFormatString="yyyy-MM-dd" 
                                                        EditFormat="Custom" EditFormatString="yyyy-MM-dd" ReadOnly="True">
                                                    </dx:ASPxDateEdit>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td align="left" colspan="3" class="style3">
                                        <table style="width:100%;">
                                            <tr>
                                                <td align="left" valign="middle" width="50%">
                                                    <dx:ASPxLabel ID="ASPxLabel37" runat="server" Text="ETA PORT"
                                                        Font-Names="Tahoma" Font-Size="8pt" Width="100%">
                                                    </dx:ASPxLabel>
                                                </td>
                                                <td align="right" valign="middle" width="50%">
                                                    <dx:ASPxDateEdit ID="dtETAPort" runat="server" Width="100%" 
                                                        ClientInstanceName="dtETAPort" DisplayFormatString="yyyy-MM-dd" 
                                                        EditFormat="Custom" EditFormatString="yyyy-MM-dd" ReadOnly="True">
                                                    </dx:ASPxDateEdit>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td align="left" colspan="3" class="style3">
                                        <table style="width:100%;">
                                            <tr>
                                                <td align="left" valign="middle" width="50%">
                                                    <dx:ASPxLabel ID="ASPxLabel38" runat="server" Text="ETA FACTORY"
                                                        Font-Names="Tahoma" Font-Size="8pt" Width="100%">
                                                    </dx:ASPxLabel>
                                                </td>
                                                <td align="right" valign="middle" width="50%">
                                                    <dx:ASPxDateEdit ID="dtETAFactory" runat="server" Width="100%" 
                                                        ClientInstanceName="dtETAFactory" DisplayFormatString="yyyy-MM-dd" 
                                                        EditFormat="Custom" EditFormatString="yyyy-MM-dd" ReadOnly="True">
                                                    </dx:ASPxDateEdit>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td align="right" valign="middle">
                                        <dx:ASPxButton ID="btnClear" runat="server" Text="CLEAR"
                                            Font-Names="Tahoma" Width="100%" AutoPostBack="False" Font-Size="8pt" ImagePosition="Right" 
                                            ClientInstanceName="btnClear">
                                            <ClientSideEvents Click="function(s, e) {
                                                grid.PerformCallback('delete');
	                                            dtPeriodFrom.SetDate(new Date());
	                                            rdrCom1.SetChecked(true);
	                                            rdrShipBy2.SetChecked(true);
	                                            rdMonthly.SetChecked(true);
	                                            rdEmergency.SetChecked(false);
	                                            rdEmergency.SetVisible(true);
	                                            rdrCom2.SetChecked(false);
	                                            rdrShipBy3.SetChecked(false);
	                                            cboAffiliate.SetText('');
	                                            txtAffiliate.SetText('');
	                                            cboDelLoc.SetText('');
	                                            txtDelLoc.SetText('');
	                                            txtOrderNo.SetText('');
	                                            dtETDVendor.SetDate(new Date());
	                                            dtETDPort.SetDate(new Date());
	                                            dtETAPort.SetDate(new Date());
	                                            dtETAFactory.SetDate(new Date());
                                            }" />
                                        </dx:ASPxButton>
                                    </td>

                                </tr>
                                                                                 
                                <tr>
                                    <td align="left" valign="middle" class="style1">
                                        <dx:ASPxLabel ID="ASPxLabel39" runat="server" Text="ORIGINAL O/NO"
                                            Font-Names="Tahoma" Font-Size="8pt">
                                        </dx:ASPxLabel>
                                    </td>
                                    <td align="left" valign="middle" colspan="2" class="style2">
                                        <dx:ASPxTextBox ID="txtpono" runat="server" Width="100%" 
                                            ClientInstanceName="txtpono" ReadOnly="True">
                                        </dx:ASPxTextBox>
                                    </td>
                                </tr>                               
                            </table>
                        </td>
                    </tr>
                </table>
            </td> 
        </tr>

        <tr>
            <td colspan="16" height="15">
                <%--error message--%>
                <table id="tblMsg" style="border-width: thin; border-style: inset hidden ridge hidden; border-color:#9598A1; width:100%; height: 15px;">
                    <tr>
                        <td align="left" valign="middle" height="15px">
                            <dx:ASPxLabel ID="lblInfo" runat="server" Text="[lblinfo]" Font-Names="Tahoma" 
                                ClientInstanceName="lblInfo" Font-Bold="True" Font-Italic="True" 
                                Font-Size="8pt">
                            </dx:ASPxLabel>
                        </td>
                    </tr>         
                </table>
            </td>            
        </tr>
    </table>

    <div style="height: 1px;"></div>

    <table style="width: 100%;">
        <tr>
            <td align="right" valign="top">&nbsp;</td>
            <td align="right" valign="top">
                <table style="width:100%;">
                    <tr>
                        <td align="right">
                            <dx:ASPxButton ID="btnCheck" runat="server" Text="CHECK DATA"
                                Font-Names="Tahoma"
                                Width="80px" AutoPostBack="False" Font-Size="8pt" 
                                ClientInstanceName="btnCheck" VerticalAlign="Bottom">
                                <ClientSideEvents Click="function(s, e) {
			                        if (cboAffiliate.GetText() == &quot;&quot;) {
                                        lblInfo.GetMainElement().style.color = 'Red';
                                        lblInfo.SetText(&quot;[6011] Please Select Affiliate first!&quot;);
                                        cboAffiliateCode.Focus();
                                        e.ProcessOnServer = false;
                                        return false;
                                    }

			                        if (txtpono.GetText() == &quot;&quot;) {
				                        lblInfo.GetMainElement().style.color = 'Red';
                                        lblInfo.SetText(&quot;[6011] Please Input Order No first!&quot;);
                                        cboShippingNo.Focus();
                                        e.ProcessOnServer = false;
                                        return false;
                                    }

			                        if (grid.GetVisibleRowsOnPage() == 0){
        		                        lblInfo.GetMainElement().style.color = 'Red';
	    		                        llblInfo.SetText('[6013] No data to Check!');
        		                        e.processOnServer = false;
        		                        return;
			                        }

                                    HF.Set('hfTest', '1');
	                                grid.UpdateEdit();
                                    var millisecondsToWait = 50;

                                    setTimeout(function() {
						                grid.PerformCallback('loaddatacell');
						                ASPxCallback1.PerformCallback('');
                                    }, millisecondsToWait);

	                                ASPxCallback1.PerformCallback('');
	                                grid.CancelEdit();
                                }" />
                            </dx:ASPxButton>
                        </td>
                        <td width="87px">
                            <dx:ASPxButton ID="btnUpload" 
                                runat="server" Text="UPLOAD ERROR LIST"
                                Font-Names="Tahoma" Width="85px" Font-Size="8pt" VerticalAlign="Bottom" 
                                AutoPostBack="False">
                            </dx:ASPxButton>
                        </td>
                        <td width="87px">
                            <dx:ASPxButton ID="btnDownload" 
                                runat="server" Text="DOWNLOAD ERROR LIST"
                                Font-Names="Tahoma" Width="85px" 
                                AutoPostBack="False" Font-Size="8pt" ClientInstanceName="btnDownload" 
                                VerticalAlign="Bottom">
                                <ClientSideEvents Click="function(s, e) {grid.PerformCallback('downloadSummary');}" />
                            </dx:ASPxButton>
                        </td>
                        <td width="95px">
                            <dx:ASPxRoundPanel ID="ASPxRoundPanel1" runat="server" BackColor="#FFD2A6" 
                                Font-Names="Tahoma" Font-Size="8pt" ForeColor="Red" HeaderText="ERROR CHECK" 
                                ShowCollapseButton="true" View="GroupBox" Width="100px" Height="22px">
                                <PanelCollection>
                                    <dx:PanelContent ID="PanelContent1" runat="server">
                                        <table>
                                            <tr>
                                                <td align="left" height="15" valign="middle" width="100px">
                                                    <dx:ASPxLabel ID="ASPxLabel8" runat="server" bgcolor="#FFD2A6" 
                                                        Font-Names="Tahoma" Font-Size="8pt" ForeColor="Red" Text="NUMBER OF ROW : " 
                                                        Width="100px">
                                                    </dx:ASPxLabel>
                                                </td>
                                                <td align="left" height="15" valign="middle" width="100px">
                                                    <dx:ASPxTextBox ID="txtError" runat="server" ClientInstanceName="txtError" 
                                                        Font-Names="Tahoma" Font-Size="8pt" Width="40px">
                                                    </dx:ASPxTextBox>                                                    
                                                </td>
                                            </tr>
                                        </table>
                                    </dx:PanelContent>
                                </PanelCollection>
                            </dx:ASPxRoundPanel>
                        </td>
                    </tr>
                </table>                    
            </td>
        </tr>
    </table> 

    <div style="height: 1px;"></div>
                
    <table style="width: 100%;">
        <tr>
            <td colspan="16" align="left" valign="top" height="220">
                <%--Column : Grid--%>
                <dx:ASPxGridView ID="grid" runat="server" Width="100%"
                    Font-Names="Tahoma" KeyFieldName="NoUrut;PONo;PartNo;AffiliateID;SupplierID"
                    AutoGenerateColumns="False"
                    ClientInstanceName="grid" Font-Size="8pt">
                    <ClientSideEvents Init="OnInit" 
                        CallbackError="function(s, e) {e.handled = true;}" 
                        BatchEditEndEditing="OnBatchEditEndEditing" EndCallback="function(s, e) {
                        var pMsg = s.cpMessage;
                        if (pMsg != '') {
                            if (pMsg.substring(1,2) == '1') {
                                lblInfo.GetMainElement().style.color = 'Blue';  
                            } else {
                                lblInfo.GetMainElement().style.color = 'Red';
                            }
                            lblInfo.SetText(pMsg);
                        } else {
                            lblInfo.SetText('');
                        }
                        delete s.cpMessage;

			            var pOrderNo = s.cpOrderNo;
                        txtOrderNo.SetText(pOrderNo);
                        delete s.cpOrderNo;

                    }" RowClick="function(s, e) {
	                    lblInfo.SetText('');
                    }" BatchEditStartEditing="OnBatchEditStartEditing" />                    
                    <Columns>
                        <dx:GridViewDataCheckColumn FieldName="AllowAccess" Name="AllowAccess" VisibleIndex="0" Width="30px"
                            Caption=" ">
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                            <HeaderCaptionTemplate>
                            </HeaderCaptionTemplate>
                            <PropertiesCheckEdit ValueChecked="1" ValueType="System.Int32" ValueUnchecked="0">
                            </PropertiesCheckEdit>
                        </dx:GridViewDataCheckColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="1" Caption="NO." FieldName="NoUrut" 
                            Name="NoUrut"
                            Width="30px" HeaderStyle-HorizontalAlign="Center">                            
                            <HeaderStyle HorizontalAlign="Center" Wrap="True"></HeaderStyle>
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt" HorizontalAlign="Left">
                            </CellStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="2" Caption="PART NO." 
                            FieldName="PartNo" Width="100px" 
                        Name="PartNo" HeaderStyle-HorizontalAlign="Center">                            
                            <HeaderStyle HorizontalAlign="Center" Wrap="True"></HeaderStyle>
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt">
                            </CellStyle>
                            </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="3" Caption="PART NAME" 
                            FieldName="PartName" Width="180px" 
                        Name="PartName" HeaderStyle-HorizontalAlign="Center">                            
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt">
                            </CellStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="4" Caption="UOM" Width="40px" 
                            HeaderStyle-HorizontalAlign="Center" CellStyle-HorizontalAlign="Center" 
                            FieldName="UOM" Name="UOM">                            
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt">
                            </CellStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="5" Caption="MOQ" FieldName="MOQ" Name="MOQ"
                            Width="50px" HeaderStyle-HorizontalAlign="Center">                            
                            <PropertiesTextEdit DisplayFormatString="{0:n0}">
                            </PropertiesTextEdit>
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt">
                            </CellStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="6" Caption="QTY BOX" FieldName="QtyBox" Name="QtyBox"
                            Width="75px" HeaderStyle-HorizontalAlign="Center">                            
                            <PropertiesTextEdit DisplayFormatString="{0:n0}">
                            </PropertiesTextEdit>
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt">
                            </CellStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="7" Caption="TOTAL FIRM QTY *" 
                            FieldName="Week1" Name="Week1" Width="100px" 
                            HeaderStyle-HorizontalAlign="Center">                            
                            <PropertiesTextEdit DisplayFormatString="{0:n0}" MaxLength="18">
                            </PropertiesTextEdit>
                            <HeaderStyle Font-Names="Tahoma" Font-Size="8pt" Font-Underline="False" 
                                Wrap="True" HorizontalAlign="Center"/>
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt">
                            </CellStyle>
                            <PropertiesTextEdit DisplayFormatString="{0:n0}" MaxLength="18">
                            <MaskSettings ErrorText="Please input valid value !"
                            Mask="<0..999999g>" IncludeLiterals="DecimalSymbol" />
                            </PropertiesTextEdit>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="8" Caption="PREVIOUS FORECAST N" 
                            Width="100px" HeaderStyle-HorizontalAlign="Center" 
                            FieldName="PreviousForecast" Name="PreviousForecast">                            
                            <PropertiesTextEdit DisplayFormatString="{0:n0}">
                            </PropertiesTextEdit>
                            <HeaderStyle Font-Names="Tahoma" Font-Size="8pt" Font-Underline="False" 
                                Wrap="True" HorizontalAlign="Center"/>
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt">
                            </CellStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="9" Caption="VARIANCE" Width="100px"
                            HeaderStyle-HorizontalAlign="Center" CellStyle-HorizontalAlign="Center" 
                            FieldName="Variance" Name="Variance">
                            <PropertiesTextEdit DisplayFormatString="{0:n0}">
                            </PropertiesTextEdit>                            
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt" HorizontalAlign="Right">
                            </CellStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="10" Caption="VARIANCE %" Width="100px"
                            FieldName="VariancePercentage" Name="VariancePercentage">
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <PropertiesTextEdit DisplayFormatString="{0:n2}">
                            </PropertiesTextEdit>
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt" HorizontalAlign="Right">
                            </CellStyle>
                        </dx:GridViewDataTextColumn>
                         <dx:GridViewDataTextColumn VisibleIndex="11" Caption="FORECAST N+1" 
                            FieldName="Forecast1" Name="Forecast1" Width="75px" 
                            HeaderStyle-HorizontalAlign="Center">                            
                            <PropertiesTextEdit DisplayFormatString="{0:n0}" MaxLength="18">
                            </PropertiesTextEdit>
                            <HeaderStyle Font-Names="Tahoma" Font-Size="8pt" Font-Underline="False" 
                                Wrap="True" HorizontalAlign="Center"/>
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt">
                            </CellStyle>
                            <PropertiesTextEdit DisplayFormatString="{0:n0}" MaxLength="18">
                            <MaskSettings ErrorText="Please input valid value !"
                            Mask="<0..999999g>" IncludeLiterals="DecimalSymbol" />
                            </PropertiesTextEdit>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="12" Caption="FORECAST N+2" 
                            Width="75px" HeaderStyle-HorizontalAlign="Center" FieldName="Forecast2" 
                            Name="Forecast2">
                            <HeaderStyle Font-Names="Tahoma" Font-Size="8pt" Font-Underline="False" 
                                Wrap="True" HorizontalAlign="Center"/>
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt">
                            </CellStyle>
                            <PropertiesTextEdit DisplayFormatString="{0:n0}" MaxLength="18">
                            <MaskSettings ErrorText="Please input valid value !"
                            Mask="<0..999999g>" IncludeLiterals="DecimalSymbol" />
                            </PropertiesTextEdit>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="13" Caption="FORECAST N+3" 
                            Width="75px" HeaderStyle-HorizontalAlign="Center" FieldName="Forecast3" 
                            Name="Forecast3">
                            <HeaderStyle Font-Names="Tahoma" Font-Size="8pt" Font-Underline="False" 
                                Wrap="True" HorizontalAlign="Center"/>
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt">
                            </CellStyle>
                            <PropertiesTextEdit DisplayFormatString="{0:n0}" MaxLength="18">
                            <MaskSettings ErrorText="Please input valid value !"
                            Mask="<0..999999g>" IncludeLiterals="DecimalSymbol" />
                            </PropertiesTextEdit>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="AFFILIATE CODE" FieldName="AffiliateID" 
                        Name="AffiliateID"
                            VisibleIndex="14" Width="200px" Visible="False">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="SUPPLIER CODE" FieldName="SupplierID" 
                        Name="SupplierID"
                            VisibleIndex="15" Width="100px">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="PONo" Width="100px" Caption="PO NO." 
                        Name="PONo"
                            VisibleIndex="18" Visible="False">
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt"></CellStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="AdaData" FieldName="AdaData" 
                            Name="AdaData" VisibleIndex="21" Width="0px">
                            <HeaderStyle Font-Names="Tahoma" Font-Size="8pt" Font-Underline="False" 
                                Wrap="True" HorizontalAlign="Center"/>
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt">
                            </CellStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="REMARKS" FieldName="ErrorStatus" 
                            VisibleIndex="22" Width="200px">
                        </dx:GridViewDataTextColumn>
                    </Columns>
                    <SettingsPager Visible="False" Position="Top">
                        <Summary Text="Page {0} of {1} [{2} record(s)]" AllPagesText="Page {0} of {1} " />
                        <Summary AllPagesText="Page {0} of {1} " Text="Page {0} of {1} [{2} record(s)]">
                        </Summary>
                    </SettingsPager>
                    <SettingsEditing Mode="Batch">
                    </SettingsEditing>
                    <Settings ShowHorizontalScrollBar="True" ShowVerticalScrollBar="True" ShowGroupButtons="False"
                        ShowStatusBar="Hidden" VerticalScrollableHeight="250" />

                    <Settings ShowGroupButtons="False" ShowVerticalScrollBar="True" ShowHorizontalScrollBar="True" 
                        VerticalScrollableHeight="250" ShowStatusBar="Hidden"></Settings>
                    <Styles>
                                <Header BackColor="#FFD2A6" Font-Names="Verdana" Font-Size="8pt"></Header>
                                <Row BackColor="#FFFFE1" Font-Names="Verdana" Font-Size="8pt" Wrap="False"></Row>
                                <RowHotTrack BackColor="#E8EFFD" Font-Names="Verdana" Font-Size="8pt" Wrap="False"></RowHotTrack>
                                <SelectedRow Wrap="False">
                                </SelectedRow>
                            </Styles>
                    <StylesEditors ButtonEditCellSpacing="0">
                        <ProgressBar Height="21px">
                        </ProgressBar>
                    </StylesEditors>
                </dx:ASPxGridView>
            </td>
        </tr>
        </table>
        
    <div style="height: 8px;"></div>
    
    <table style="width: 100%;">
        <tr>
            <td height="50">
                <!-- INPUT AREA -->
                <table id="tbl1" style="border-width: 1pt thin thin thin; border-style: ridge; border-color: #9598A1;
                    width: 100%; height: 50px;">
                    <tr>
                        <td valign="middle" bgcolor="#FFD2A6" width="100px" align="center">
                            <dx:ASPxLabel ID="ASPxLabel53" runat="server" Text="PART NO." Font-Names="Tahoma"
                                Font-Size="8pt" Width="100%" Height="16px">
                            </dx:ASPxLabel>
                        </td>
                        <td valign="middle" bgcolor="#FFD2A6" align="center" width="230px">
                            <dx:ASPxLabel ID="ASPxLabel3" runat="server" Text="PART NAME" Font-Names="Tahoma"
                                Font-Size="8pt" Width="100%">
                            </dx:ASPxLabel>
                        </td>
                        <td valign="middle" bgcolor="#FFD2A6" align="center" width="36px">
                            <dx:ASPxLabel ID="ASPxLabel56" runat="server" Text="UOM" Font-Names="Tahoma"
                                Font-Size="8pt" Width="100%">
                            </dx:ASPxLabel>
                        </td>
                        <td valign="middle" bgcolor="#FFD2A6" align="center" width="46px">
                            <dx:ASPxLabel ID="ASPxLabel15" runat="server" Text="MOQ" Font-Names="Tahoma"
                                Font-Size="8pt" Width="100%">
                            </dx:ASPxLabel>
                        </td>
                        <td valign="middle" bgcolor="#FFD2A6" width="72px" align="center">
                            <dx:ASPxLabel ID="ASPxLabel6" runat="server" Text="QTY BOX" Font-Names="Tahoma"
                                Font-Size="8pt" Width="100%">
                            </dx:ASPxLabel>
                        </td>
                       <td valign="middle" bgcolor="#FFD2A6" width="95px" align="center">
                            <dx:ASPxLabel ID="ASPxLabel55" runat="server" Text="TOTAL FIRM QTY *" Font-Names="Tahoma"
                                Font-Size="8pt" Width="100%">
                            </dx:ASPxLabel>
                        </td>
                        <td valign="middle" bgcolor="#FFD2A6" width="96px" align="center">
                            <dx:ASPxLabel ID="ASPxLabel7" runat="server" Text="PREVIOUS FORECAST N" Font-Names="Tahoma"
                                Font-Size="8pt" Width="100%">
                            </dx:ASPxLabel>
                        </td>
                        <td valign="middle" bgcolor="#FFD2A6" width="96px" align="center">
                            <dx:ASPxLabel ID="ASPxLabel9" runat="server" Text="VARIANCE" Font-Names="Tahoma"
                                Font-Size="8pt" Width="100%">
                            </dx:ASPxLabel>
                        </td>
                        <td valign="middle" bgcolor="#FFD2A6" width="96 px" align="center">
                            <dx:ASPxLabel ID="ASPxLabel10" runat="server" Text="VARIANCE %" Font-Names="Tahoma" Font-Size="8pt"
                                Width="100%">
                            </dx:ASPxLabel>
                        </td>
                        <td valign="middle" bgcolor="#FFD2A6" width="72px" align="center">
                            <dx:ASPxLabel ID="ASPxLabel11" runat="server" Text="FORECAST N+1" Font-Names="Tahoma" Font-Size="8pt"
                                Width="100%">
                            </dx:ASPxLabel>
                        </td>
                        <td valign="middle" bgcolor="#FFD2A6" width="72px" align="center">
                            <dx:ASPxLabel ID="ASPxLabel12" runat="server" Text="FORECAST N+2" Font-Names="Tahoma" Font-Size="8pt"
                                Width="100%">
                            </dx:ASPxLabel>
                        </td>
                        <td valign="top" bgcolor="#FFD2A6" width="72px" align="center">
                            <dx:ASPxLabel ID="ASPxLabel13" runat="server" Text="FORECAST N+3" Font-Names="Tahoma" Font-Size="8pt"
                                Width="100%">
                            </dx:ASPxLabel>
                        </td>
                        <td valign="middle" bgcolor="#FFD2A6" width="100px" align="center">
                            <dx:ASPxLabel ID="ASPxLabel14" runat="server" Text="SUPPLIER CODE" Font-Names="Tahoma" Font-Size="8pt"
                                Width="100%">
                            </dx:ASPxLabel>
                        </td>
                        <td valign="middle" bgcolor="#FFD2A6" align="center">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td valign="middle" width="100px" align="left">
                            <dx:ASPxTextBox ID="txtPartNo" runat="server" Width="100%" Height="20px" ClientInstanceName="txtPartNo"
                                Font-Names="Tahoma" Font-Size="8pt" MaxLength="25">
                                <ClientSideEvents LostFocus="function(s, e) {
    	                            lblInfo.SetText('');
                                    HF.Set('hfTest', '0');
                                    ASPxCallback1.PerformCallback('loaditem');
                                }" TextChanged="function(s, e) {
	                                lblInfo.SetText('');
                                }" />
                            </dx:ASPxTextBox>
                        </td>
                       <td valign="middle" width="230px" align="left">
                            <dx:ASPxTextBox ID="txtPartName" runat="server" Width="100%" Height="20px" ClientInstanceName="txtPartName"
                                Font-Names="Tahoma" Font-Size="8pt" MaxLength="50" BackColor="#CCCCCC" ReadOnly="True">
                            </dx:ASPxTextBox>
                        </td>
                       <td valign="middle" width="36px" align="right">
                            <dx:ASPxTextBox ID="txtUOM" runat="server" Width="100%" Height="20px" ClientInstanceName="txtUOM"
                                Font-Names="Tahoma" Font-Size="8pt" MaxLength="50" BackColor="#CCCCCC" ReadOnly="True">
                            </dx:ASPxTextBox>
                        </td>
                       <td valign="middle" width="46px" align="right">
                            <dx:ASPxTextBox ID="txtMOQ" runat="server" Width="100%" Height="20px" ClientInstanceName="txtMOQ"
                                Font-Names="Tahoma" Font-Size="8pt" MaxLength="50" BackColor="#CCCCCC" 
                                ReadOnly="True" HorizontalAlign="Right">
                            </dx:ASPxTextBox>
                        </td>
                       <td valign="middle" width="72px" align="right">
                            <dx:ASPxTextBox ID="txtQtyBox" runat="server" Width="100%" Height="20px" ClientInstanceName="txtQtyBox"
                                Font-Names="Tahoma" Font-Size="8pt" MaxLength="50" BackColor="#CCCCCC" 
                                ReadOnly="True" HorizontalAlign="Right">
                            </dx:ASPxTextBox>
                        </td>
                        <td valign="middle" width="95px" align="left">
                            <dx:ASPxTextBox ID="txtTotFirmQty" runat="server" Width="100%" Height="20px" ClientInstanceName="txtTotFirmQty"
                                Font-Names="Tahoma" Font-Size="8pt" MaxLength="10" HorizontalAlign="Right">
                            </dx:ASPxTextBox>
                        </td>
                       <td valign="middle" width="96px" align="right">
                            <dx:ASPxTextBox ID="txtPrevForecast" runat="server" Width="100%" Height="20px" ClientInstanceName="txtPrevForecast"
                                Font-Names="Tahoma" Font-Size="8pt" MaxLength="50" BackColor="#CCCCCC" 
                                ReadOnly="True" HorizontalAlign="Right">
                            </dx:ASPxTextBox>
                        </td>
                       <td valign="middle" width="96px" align="right">
                            <dx:ASPxTextBox ID="txtVariance" runat="server" Width="100%" Height="20px" ClientInstanceName="txtVariance"
                                Font-Names="Tahoma" Font-Size="8pt" MaxLength="50" BackColor="#CCCCCC" 
                                ReadOnly="True" HorizontalAlign="Right">
                            </dx:ASPxTextBox>
                        </td>
                       <td valign="middle" width="96px" align="right">
                            <dx:ASPxTextBox ID="txtVariancePerc" runat="server" Width="100%" Height="20px" ClientInstanceName="txtVariancePerc"
                                Font-Names="Tahoma" Font-Size="8pt" MaxLength="50" BackColor="#CCCCCC" 
                                ReadOnly="True" HorizontalAlign="Right">
                            </dx:ASPxTextBox>
                        </td>
                        <td valign="middle" width="72px" align="left">
                            <dx:ASPxTextBox ID="txtForcast1" runat="server" Width="100%" Height="20px" ClientInstanceName="txtForcast1"
                                Font-Names="Tahoma" Font-Size="8pt" MaxLength="10" HorizontalAlign="Right">
                            </dx:ASPxTextBox>
                        </td>
                        <td valign="middle" width="72px" align="left">
                            <dx:ASPxTextBox ID="txtForcast2" runat="server" Width="100%" Height="20px" ClientInstanceName="txtForcast2"
                                Font-Names="Tahoma" Font-Size="8pt" MaxLength="10" HorizontalAlign="Right">
                            </dx:ASPxTextBox>
                        </td>
                        <td valign="middle" width="72px" align="left">
                            <dx:ASPxTextBox ID="txtForcast3" runat="server" Width="100%" Height="20px" ClientInstanceName="txtForcast3"
                                Font-Names="Tahoma" Font-Size="8pt" MaxLength="10" HorizontalAlign="Right">
                            </dx:ASPxTextBox>
                        </td>
                        <td valign="middle" width="100px" align="left">
                            <dx:ASPxTextBox ID="txtSupplier" runat="server" Width="100%" Height="20px" ClientInstanceName="txtSupplier"
                                Font-Names="Tahoma" Font-Size="8pt" MaxLength="25">
                            </dx:ASPxTextBox>
                        </td>
                        <td valign="middle" align="center">
                            <dx:ASPxButton ID="btnAdd" runat="server" Text="ADD"
                                Font-Names="Tahoma" Width="100%" Font-Size="8pt" 
                                HorizontalAlign="Center" VerticalAlign="Middle" AutoPostBack="False">
                                <ClientSideEvents Click="function(s, e) {
                                    validasisubmit;
                                    up_Insert();

						            ASPxCallback1.PerformCallback('');
	                                grid.PerformCallback('loaddata');
                                    var millisecondsToWait = 50;

                                    setTimeout(function() {ASPxCallback1.PerformCallback('');
                                    }, millisecondsToWait);	

                                    txtPartNo.SetText('');
                                    txtPartName.SetText('');
                                    txtUOM.SetText('');
                                    txtMOQ.SetText('');
                                    txtQtyBox.SetText('');
                                    txtTotFirmQty.SetText('');
                                    txtPrevForecast.SetText('');
                                    txtVariance.SetText('');
                                    txtVariancePerc.SetText('');
                                    txtForcast1.SetText('');
                                    txtForcast2.SetText('');
                                    txtForcast3.SetText('');
                                    txtSupplier.SetText('');
                                }" />
                            </dx:ASPxButton>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
        
    <div style="height: 8px;"></div>

    <table style="width: 100%;">
        <tr>
            <td align="left">
                <dx:ASPxButton ID="btnSubMenu" runat="server" Text="SUB MENU"
                    Font-Names="Tahoma" Width="85px" Font-Size="8pt" 
                    HorizontalAlign="Center" VerticalAlign="Bottom" AutoPostBack="False">
                </dx:ASPxButton>
            </td>
            <td>
                <dx:ASPxTextBox ID="txtHeijunka" runat="server" ClientInstanceName="txtHeijunka" 
                    Width="0px" BackColor="White" ForeColor="White">
                    <Border BorderColor="White" />
                </dx:ASPxTextBox>                          
            </td>
            <td>
                <dx:ASPxTextBox ID="txtMode" runat="server" ClientInstanceName="txtMode" 
                    Width="0px" BackColor="White" ForeColor="White">
                    <Border BorderColor="White" />
                </dx:ASPxTextBox>                          
            </td>
            <td align="right">
                <dx:ASPxTextBox ID="tampung" runat="server" ClientInstanceName="tampung" 
                    Width="0px" BackColor="White" ForeColor="White">
                    <Border BorderColor="White" />
                </dx:ASPxTextBox>                          
            </td>
            <td align="right">
                <dx:ASPxButton ID="btnRecover" runat="server" Text="RECOVERY PO SPLIT"
                    Font-Names="Tahoma"
                    Width="80px" AutoPostBack="False" Font-Size="8pt" 
                    ClientInstanceName="btnRecover" VerticalAlign="Bottom">
                    <ClientSideEvents Click="function(s, e) {
			        if (cboAffiliate.GetText() == &quot;&quot;) {
                        lblInfo.GetMainElement().style.color = 'Red';
                        lblInfo.SetText(&quot;[6011] Please Select Affiliate first!&quot;);
                        cboAffiliateCode.Focus();
                        e.ProcessOnServer = false;
                        return false;
                    }

			        if (txtpono.GetText() == &quot;&quot;) {
				        lblInfo.GetMainElement().style.color = 'Red';
                        lblInfo.SetText(&quot;[6011] Please Input Order No first!&quot;);
                        cboShippingNo.Focus();
                        e.ProcessOnServer = false;
                        return false;
                    }

    	            lblInfo.SetText('');
                    HF.Set('hfTest', '0');

                    var millisecondsToWait = 100;

                    setTimeout(function() {ASPxCallback1.PerformCallback('recoveryposplit');
                    }, millisecondsToWait);	

                    setTimeout(function() {grid.PerformCallback('recoveryposplit');
                    }, millisecondsToWait);	

                    btnRecover.SetEnabled(false);
                    }"/> 
                </dx:ASPxButton>
            </td>
            <td align="right" width="85px">
                <dx:ASPxButton ID="btnCancel" runat="server" Text="CANCEL PO"
                    Font-Names="Tahoma"
                    Width="80px" AutoPostBack="False" Font-Size="8pt" 
                    ClientInstanceName="btnCancel" VerticalAlign="Bottom">
                    <ClientSideEvents Click="function(s, e) {
			        if (cboAffiliate.GetText() == &quot;&quot;) {
                        lblInfo.GetMainElement().style.color = 'Red';
                        lblInfo.SetText(&quot;[6011] Please Select Affiliate first!&quot;);
                        cboAffiliateCode.Focus();
                        e.ProcessOnServer = false;
                        return false;
                    }

			        if (txtpono.GetText() == &quot;&quot;) {
				        lblInfo.GetMainElement().style.color = 'Red';
                        lblInfo.SetText(&quot;[6011] Please Input Order No first!&quot;);
                        cboShippingNo.Focus();
                        e.ProcessOnServer = false;
                        return false;
                    }
                    }"/> 
                </dx:ASPxButton>
            </td>
            <td align="right">
                <dx:ASPxButton ID="btnSplit" runat="server" Text="SPLIT PO"
                    Font-Names="Tahoma"
                    Width="80px" AutoPostBack="False" Font-Size="8pt" 
                    ClientInstanceName="btnSplit" VerticalAlign="Bottom">
                    <ClientSideEvents Click="function(s, e) {
			        if (cboAffiliate.GetText() == &quot;&quot;) {
                        lblInfo.GetMainElement().style.color = 'Red';
                        lblInfo.SetText(&quot;[6011] Please Select Affiliate first!&quot;);
                        cboAffiliateCode.Focus();
                        e.ProcessOnServer = false;
                        return false;
                    }

			        if (txtpono.GetText() == &quot;&quot;) {
				        lblInfo.GetMainElement().style.color = 'Red';
                        lblInfo.SetText(&quot;[6011] Please Input Order No first!&quot;);
                        cboShippingNo.Focus();
                        e.ProcessOnServer = false;
                        return false;
                    }
                    }"/> 
                </dx:ASPxButton>
            </td>
            <td align="right" width="85px">
                <dx:ASPxButton ID="btnApprove" runat="server" Text="SEND TO SUPPLIER"
                    Font-Names="Tahoma"
                    Width="80px" AutoPostBack="False" Font-Size="8pt" 
                    ClientInstanceName="btnApprove" VerticalAlign="Bottom">
                    <ClientSideEvents Click="function(s, e) {
			        if (cboAffiliate.GetText() == &quot;&quot;) {
                        lblInfo.GetMainElement().style.color = 'Red';
                        lblInfo.SetText(&quot;[6011] Please Select Affiliate first!&quot;);
                        cboAffiliateCode.Focus();
                        e.ProcessOnServer = false;
                        return false;
                    }

			        if (txtpono.GetText() == &quot;&quot;) {
				        lblInfo.GetMainElement().style.color = 'Red';
                        lblInfo.SetText(&quot;[6011] Please Input Order No first!&quot;);
                        cboShippingNo.Focus();
                        e.ProcessOnServer = false;
                        return false;
                    }

			        if (grid.GetVisibleRowsOnPage() == 0){
        		        lblInfo.GetMainElement().style.color = 'Red';
	    		        llblInfo.SetText('[6013] No data to submit!');
        		        e.processOnServer = false;
        		        return;
			        }
	
	                HF.Set('hfTest', '2');
                    grid.UpdateEdit();
	                grid.PerformCallback('gridload');

                    var millisecondsToWait = 50;
                    setTimeout(function() {ASPxCallback1.PerformCallback('');
                    }, millisecondsToWait);	
                    }"/> 
                </dx:ASPxButton>
            </td>
        </tr>
        <tr>
            <td valign="top" align="left">
            </td>
            <td valign="top" align="right" style="width: 50px;">
            </td>
            <td valign="top" align="right" style="width: 50px;">      
            </td>
            <td valign="top" align="right" style="width: 50px;">      
            </td>
            
            <td valign="top" align="right" style="width: 50px;">
            </td>
            <td valign="top" align="right" style="width: 50px;">
            </td>
            <td valign="top" align="right" style="width: 50px;">
            </td>            
            <td align="right" style="width:80px;">                                   
            </td>
        </tr>
    </table>
                    
    <dx:ASPxGlobalEvents ID="ge" runat="server" >
        <ClientSideEvents ControlsInitialized="function(s, e) {
	        OnControlsInitializedSplitter();
	        OnControlsInitializedGrid();
        }" />
    </dx:ASPxGlobalEvents>

    <dx:ASPxCallback ID="ASPxCallback1" runat="server" ClientInstanceName="ASPxCallback1">
        <ClientSideEvents EndCallback="function(s, e) {            
            if (s.cpLossFocus == 'ON'){
                txtPartNo.SetText(s.cpPartNo);
                txtPartName.SetText(s.cpPartName);
                txtUOM.SetText(s.cpUOM);
                txtMOQ.SetText(s.cpMOQ);
                txtQtyBox.SetText(s.cpQtyBox);
                txtTotFirmQty.SetText(s.cpTotalPOQty);
                txtPrevForecast.SetText(s.cpPreviousForecast);
                txtVariance.SetText(s.cpVariance);
                txtVariancePerc.SetText(s.cpVariancePercentage);
                txtForcast1.SetText(s.cpForecast1);
                txtForcast2.SetText(s.cpForecast2);
                txtForcast3.SetText(s.cpForecast3);
                txtSupplier.SetText(s.cpSupplierID);
            
                delete s.cpLossFocus

                var pMsg = s.cpMessage;

                if (pMsg != '') {
                    if (pMsg.substring(1,2) == '1') {
                        lblInfo.GetMainElement().style.color = 'Blue';
                    } else {
                        lblInfo.GetMainElement().style.color = 'Red';
                    }
                    lblInfo.SetText(pMsg);
                } else {
                    lblInfo.SetText('');
                }
        
                delete s.cpMessage;
            }
        }" />       
    </dx:ASPxCallback>

    <dx:ASPxHiddenField ID="HF" runat="server" ClientInstanceName="HF">
    </dx:ASPxHiddenField>
</asp:Content>
