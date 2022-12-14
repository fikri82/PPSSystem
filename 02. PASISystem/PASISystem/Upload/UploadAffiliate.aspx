<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/SiteContent.Master" CodeBehind="UploadAffiliate.aspx.vb" Inherits="PASISystem.UploadAffiliate" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxGridView.Export" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxGridView" TagPrefix="dx" %>
<%@ Register assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxEditors" tagprefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxGlobalEvents" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxPanel" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxRoundPanel" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxCallback" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxUploadControl" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .dxeHLC, .dxeHC, .dxeHFC
        {
            display: none;
        }
        .style1
        {
            width: 5px;
            height: 20px;
        }
        .style2
        {
            width: 100px;
            height: 20px;
        }
        .style3
        {
            height: 20px;
        }
    </style>
<script type="text/javascript">
    /*Update By Robby*/
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
        height = height - (height * 33 / 100)
        grid.SetHeight(height);
    }

    function memo_OnInit(s, e) {
        var input = memo.GetInputElement();
        if (ASPxClientUtils.opera)
            input.oncontextmenu = function () { return false; };
        else
            input.onpaste = CorrectTextWithDelay;
    }

    function CorrectTextWithDelay() {
        var maxLength = se.GetNumber();
        setTimeout(function () { memo.SetText(memo.GetText().substr(0, maxLength)); }, 0);
    }

    function Uploader_OnUploadStart() {
        btnUpload.SetEnabled(false);
    }

    function Uploader_OnFilesUploadComplete(args) {
        UpdateUploadButton();
    }

    function UpdateUploadButton() {
        btnUpload.SetEnabled(uploader.GetText(0) != "");
        var a = uploader.GetText();
        var b = filename.SetText(a);
    }

    var order;
    var pFieldName;

    function onSorting(s, e) {
        order = order == "ASC" ? "DESC" : "ASC";
        e.cancel = true;
        pFieldName = e.column.fieldName
        s.PerformCallback('sorting|' + order + '|' + pFieldName);
    }
</script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Content" runat="server">
    <table style="width:100%;">
        <tr>
            <td  width="100%" colspan="3">
                <table style="border-width: 1pt thin thin thin; border-style: ridge; border-color:#9598A1; width:100%; height: 50px;">
                    <tr>
                        <td colspan="8" height="20">
                            <table id="Table1">
                                <tr>
                                    <td style="width:5px;"></td>
                                    <td align="left" valign="middle" height="20px" width="60px">
                                        <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="FILE"
                                            Font-Names="Tahoma" Font-Size="8pt">
                                        </dx:ASPxLabel>
                                    </td>
                                    <td align="left" valign="middle" height="20px" width="380px">
                                        <dx:ASPxUploadControl ID="Uploader" runat="server"  
                                            Width="100%" Font-Names="Verdana" Font-Size="8pt"
                                            ClientInstanceName="Uploader"
                                            ShowClearFileSelectionButton="False"
                                            NullText="Click here to browse files..."
                                            OnFileUploadComplete="Uploader_FileUploadComplete">
                                            <ClientSideEvents FilesUploadComplete="function(s, e) { Uploader_OnFilesUploadComplete(e); }"
                                                FileUploadComplete="function(s, e) { Uploader_OnFileUploadComplete(e); }" 
                                                FileUploadStart="function(s, e) { Uploader_OnUploadStart(); }"
                                                TextChanged="function(s, e) { var test = uploader.GetText(); txtFileName.SetText(test); UpdateUploadButton(); }" />
                                            <ValidationSettings AllowedFileExtensions=".xls,.xlsx" MaxFileSize="4000000" />
                                            <BrowseButton Text="...">
                                            </BrowseButton> 
                                            <BrowseButtonStyle Paddings-Padding="3px" >
                                            </BrowseButtonStyle>
                                        </dx:ASPxUploadControl>
                                    </td>
                                    <td align="right" width="180px">
                                        <table style="width:100%;" align="right">
                                            <tr>
                                                <td align="right" valign="middle" style="height:25px; width:90px;">
                                                    <dx:ASPxButton ID="btnUpload" runat="server" Text="CHECK FILE" ClientInstanceName="btnUpload" 
                                                        Font-Names="Tahoma" Width="85px" AutoPostBack="False" Font-Size="8pt" >                                                        
                                                        <ClientSideEvents Click="function(s, e) {
                                                            grid.PerformCallback('checkItem');
                                                        }" />
                                                    </dx:ASPxButton>
                                                </td>
                                                <td align="right" valign="middle" style="height:25px; width:90px;">
                                                    <dx:ASPxButton ID="btnClear" runat="server" Text="CLEAR"
                                                        Font-Names="Tahoma" Width="85px" AutoPostBack="False" Font-Size="8pt">                                 
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
        </tr>

        <tr>
            <td colspan="3" height="15">
            <%--error message--%>
                <table id="tblMsg" style="border-width: thin; border-style: inset hidden ridge hidden; border-color:#9598A1; width:100%; height: 15px;">
                    <tr>
                        <td align="left" valign="middle" height="15px">
                            <dx:ASPxLabel ID="lblInfo" runat="server" Text="[lblinfo]" Font-Names="Tahoma" 
                                ClientInstanceName="lblInfo" Font-Bold="True" Font-Italic="True" 
                                Font-Size="8pt" ForeColor="Red">
                            </dx:ASPxLabel>
                        </td>
                    </tr>         
                </table>
            </td>            
        </tr>

        <tr>
            <td colspan="3" align="left" valign="top" height="220">
                <dx:ASPxGridView ID="grid" runat="server" Width="100%"
                    Font-Names="Tahoma" KeyFieldName="NoUrut"
                    AutoGenerateColumns="False"
                    ClientInstanceName="grid" Font-Size="8pt">
                    <ClientSideEvents Init="OnInit" 
                        CallbackError="function(s, e) {e.handled = true;}" EndCallback="function(s, e) {
                        
                        var pMsg = s.cpMessage;
                        if (pMsg != '') {
                            if (pMsg.substring(1,5) == '1001' || pMsg.substring(1,5) == '1002' || pMsg.substring(1,5) == '1003' || pMsg.substring(1,5) == '7001') {
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
	                    lblInfo.SetText('');
                    }" />                    
<ClientSideEvents RowClick="function(s, e) {
	                    lblInfo.SetText(&#39;&#39;);
                    }" EndCallback="function(s, e) {
                        
                        var pMsg = s.cpMessage;
                        if (pMsg != &#39;&#39;) {
                            if (pMsg.substring(1,5) == &#39;1001&#39; || pMsg.substring(1,5) == &#39;1002&#39; || pMsg.substring(1,5) == &#39;1003&#39; || pMsg.substring(1,5) == &#39;7001&#39;) {
                                lblInfo.GetMainElement().style.color = &#39;Blue&#39;;
                            } else {
                                lblInfo.GetMainElement().style.color = &#39;Red&#39;;
                            }
                            lblInfo.SetText(pMsg);
                        } else {
                            lblInfo.SetText(&#39;&#39;);
                        }
                        delete s.cpMessage;
                    }" CallbackError="function(s, e) {e.handled = true;}" Init="OnInit"></ClientSideEvents>
                    <Columns>
                        <dx:GridViewDataTextColumn VisibleIndex="1" Caption="NO." FieldName="NoUrut" Width="30px">
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt">
                            </CellStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="2" Caption="AFFILIATE ID" FieldName="AffiliateID" Width="100px">
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt">
                            </CellStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="3" Caption="CONSIGNEE CODE" FieldName="ConsigneeCode" Width="100px">
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt">
                            </CellStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="4" Caption="BUYER CODE" FieldName="BuyerCode" Width="100px">
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt">
                            </CellStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="5" Caption="AFFILIATE NAME" FieldName="AffiliateName" Width="210px" HeaderStyle-HorizontalAlign="Center">
<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="6" Caption="AFFILIATE ADDRESS" FieldName="Address" Width="290px" HeaderStyle-HorizontalAlign="Center">
<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="7" Caption="CONSIGNEE NAME" FieldName="ConsigneeName" Width="210px" HeaderStyle-HorizontalAlign="Center">
<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="8" Caption="CONSIGNEE ADDRESS" FieldName="ConsigneeAddress" Width="290px" HeaderStyle-HorizontalAlign="Center">
<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="9" Caption="BUYER NAME" FieldName="BuyerName" Width="210px" HeaderStyle-HorizontalAlign="Center">
<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="10" Caption="BUYER ADDRESS" FieldName="BuyerAddress" Width="290px" HeaderStyle-HorizontalAlign="Center">
<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="11" Caption="DESTINATION PORT" FieldName="DestinationPort" Width="100px" HeaderStyle-HorizontalAlign="Center">
<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="12" Caption="CITY" FieldName="City" Width="100px" HeaderStyle-HorizontalAlign="Center">
<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="13" Caption="POSTAL CODE" FieldName="PostalCode" Width="60px" HeaderStyle-HorizontalAlign="Center">
<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="14" Caption="PHONE 1" FieldName="Phone1" Width="105px" HeaderStyle-HorizontalAlign="Center">
<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="15" Caption="PHONE 2" FieldName="Phone2" Width="105px" HeaderStyle-HorizontalAlign="Center">
<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="16" Caption="FAX" FieldName="Fax" Width="105px" HeaderStyle-HorizontalAlign="Center">
<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="17" Caption="NPWP" FieldName="NPWP" Width="140px" HeaderStyle-HorizontalAlign="Center">
<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="18" Caption="KANTOR PABEAN" FieldName="KantorPabean" Width="110px" HeaderStyle-HorizontalAlign="Center">
<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="19" Caption="IZIN TPB" FieldName="IzinTPB" Width="100px" HeaderStyle-HorizontalAlign="Center">
<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="20" Caption="BC PERSON" FieldName="BCPerson" Width="110px" HeaderStyle-HorizontalAlign="Center">
<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="21" Caption="PO DELIVERY BY" FieldName="PODeliveryBy" Width="70px" HeaderStyle-HorizontalAlign="Center">
<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="22" Caption="OVERSEAS AFFILIATE" FieldName="OverseasCls" Width="100px" HeaderStyle-HorizontalAlign="Center">
<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="24" Caption="PATH OES FOLDER" 
                            FieldName="FolderOES" Width="300px" HeaderStyle-HorizontalAlign="Center">
<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn VisibleIndex="23" Caption="REMARK" 
                            FieldName="ErrorCls" Width="200px">
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt">
                            </CellStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="xConsigneeCode" FieldName="xConsigneeCode" 
                            VisibleIndex="25" Width="0px">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="xConsigneeName" FieldName="xConsigneeName" 
                            VisibleIndex="26" Width="0px">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="xConsigneeAddress" 
                            FieldName="xConsigneeAddress" VisibleIndex="27" Width="0px">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="xBuyerCode" FieldName="xBuyerCode" 
                            VisibleIndex="28" Width="0px">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="xBuyerName" FieldName="xBuyerName" 
                            VisibleIndex="29" Width="0px">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="xBuyerAddress" FieldName="xBuyerAddress" 
                            VisibleIndex="30" Width="0px">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="xAffiliateName" FieldName="xAffiliateName" 
                            VisibleIndex="31" Width="0px">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="xAddress" FieldName="xAddress" 
                            VisibleIndex="32" Width="0px">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="xCity" FieldName="xCity" VisibleIndex="33" 
                            Width="0px">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="xPostalCode" FieldName="xPostalCode" 
                            VisibleIndex="34" Width="0px">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="xPhone1" FieldName="xPhone1" 
                            VisibleIndex="35" Width="0px">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="xPhone2" FieldName="xPhone2" 
                            VisibleIndex="36" Width="0px">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="xFax" FieldName="xFax" VisibleIndex="37" 
                            Width="0px">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="xNPWP" FieldName="xNPWP" VisibleIndex="38" 
                            Width="0px">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="xKantorPabean" FieldName="xKantorPabean" 
                            VisibleIndex="39" Width="0px">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="xIzinTPB" FieldName="xIzinTPB" 
                            VisibleIndex="40" Width="0px">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="xBCPerson" FieldName="xBCPerson" 
                            VisibleIndex="41" Width="0px">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="xDestinationPort" 
                            FieldName="xDestinationPort" VisibleIndex="42" Width="0px">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="xFolderOES" FieldName="xFolderOES" 
                            VisibleIndex="43" Width="0px">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="xPODeliveryBy" FieldName="xPODeliveryBy" 
                            VisibleIndex="44" Width="0px">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="xOverseasCls" FieldName="xOverseasCls" 
                            VisibleIndex="45" Width="0px">
                        </dx:GridViewDataTextColumn>
                    </Columns>
                    <SettingsBehavior AllowSelectByRowClick="True" AllowSort="False"
                        ColumnResizeMode="Control" EnableRowHotTrack="True" />

<SettingsBehavior AllowSort="False" AllowSelectByRowClick="True" ColumnResizeMode="Control" 
                        EnableRowHotTrack="True"></SettingsBehavior>

                    <SettingsPager PageSize="10" Position="Top">
                        <Summary Text="Page {0} of {1} [{2} record(s)]"
                                  AllPagesText="Page {0} of {1} " />
                        <Summary AllPagesText="Page {0} of {1} " Text="Page {0} of {1} [{2} record(s)]"></Summary>
                    </SettingsPager>
                    <SettingsEditing Mode="Batch" NewItemRowPosition="Bottom">
                        <BatchEditSettings ShowConfirmOnLosingChanges="False" />
<BatchEditSettings ShowConfirmOnLosingChanges="False"></BatchEditSettings>
                    </SettingsEditing>
                    <Settings ShowHorizontalScrollBar="True" ShowVerticalScrollBar="True"
                        ShowGroupButtons="False" ShowStatusBar="Hidden"
                        VerticalScrollableHeight="220" />

<Settings ShowGroupButtons="False" ShowVerticalScrollBar="True" ShowHorizontalScrollBar="True" 
                        VerticalScrollableHeight="220" ShowStatusBar="Hidden"></Settings>

                    <Styles>
                        <SelectedRow ForeColor="Black">
                        </SelectedRow>
                    </Styles>
                    <StylesEditors ButtonEditCellSpacing="0">
                        <ProgressBar Height="21px">
                        </ProgressBar>
                    </StylesEditors>
                </dx:ASPxGridView>
            </td>
        </tr>

        <tr>
            <td valign="top" align="left">
                <dx:ASPxButton ID="btnSubMenu" runat="server" Text="BACK"
                    Font-Names="Tahoma" Width="85px" Font-Size="8pt">
                </dx:ASPxButton>
            </td>           
            <td valign="top" align="right" style="width: 50px;">
                <dx:ASPxButton ID="btnSave" runat="server" Text="SAVE" ClientInstanceName="btnSave"
                    Font-Names="Tahoma" Width="85px" AutoPostBack="False" Font-Size="8pt" >
                    <ClientSideEvents Click="function(s, e) {grid.PerformCallback('save');}" />
                </dx:ASPxButton>
            </td>
        </tr>
    </table>

    <dx:ASPxCallback ID="ASPxCallback1" runat="server" ClientInstanceName="ASPxCallback1">
        <ClientSideEvents EndCallback="function(s, e) {
            var pMsg = s.cpMessage;
            if (pMsg != '') {
                if (pMsg.substring(1,5) == '9998') {
                    lblInfo.GetMainElement().style.color = 'Blue';
                } else {
                    lblInfo.GetMainElement().style.color = 'Red';
                }
                lblInfo.SetText(pMsg);
            } else {
                lblInfo.SetText('');
            }
            delete s.cpMessage;
        }" />       
    </dx:ASPxCallback>

    <dx:ASPxGlobalEvents ID="ge" runat="server" >
        <ClientSideEvents ControlsInitialized="function(s, e) {
	        OnControlsInitializedSplitter();
	        OnControlsInitializedGrid();
        }" />
    </dx:ASPxGlobalEvents>
</asp:Content>

