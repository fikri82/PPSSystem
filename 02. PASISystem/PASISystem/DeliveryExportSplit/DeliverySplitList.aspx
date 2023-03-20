<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/SiteContent.Master" CodeBehind="DeliverySplitList.aspx.vb" Inherits="PASISystem.DeliverySplitList" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxEditors" TagPrefix="dx1" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxGridView" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxGridView.Export" TagPrefix="dx2" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxGlobalEvents" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxHiddenField" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">        
        .uppercase .dxeEditAreaSys
        {
            text-transform: uppercase;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Content" runat="server">
    <script type="text/javascript">
        function chkDeliveryChanged(s, e) {
            chkReceipt.SetChecked(false);
            grid.PerformCallback('gridKosong');
        }

        function chkReceiveChanged(s, e) {
            chkDelivery.SetChecked(false);
            grid.PerformCallback('gridKosong');
        }

        function OnBatchEditStartEditing(s, e) {
            e.cancel = true;
        }

        function OnInitGrid(s, e) {
            gridHeight(255);
        }

        function OnControlsInitialized(s, e) {
            ASPxClientUtils.AttachEventToElement(window, "resize", function (evt) {
                gridHeight(255);
            });
        }

        function gridHeight(pF) {
            var h1 = 49;
            var p1 = 10;
            var h2 = 34;
            var p2 = 13;

            var hAll = h1 + p1 + h2 + p2 + pF;
            /* alert(h1 + p1 + h2 + p2 + h3);*/
            var height = Math.max(0, document.documentElement.clientHeight);
            grid.SetHeight(height - hAll);
        };
    </script>
    
    <table style="width:100%">
        <tr>
            <td style="width:50%">
                <table style="width: 100%;">
                    <tr>
                        <td>
                            <dx1:ASPxLabel ID="ASPxLabel1" runat="server" Font-Names="Tahoma" Font-Size="8pt"
                                Text="SUPPLIER PLAN DELIVERY DATE">
                            </dx1:ASPxLabel>
                        </td>
                        <td style="width: 3%">
                            <dx1:ASPxCheckBox ID="chkDelivery" runat="server" CheckState="Unchecked" ClientInstanceName="chkDelivery" ClientSideEvents-CheckedChanged="chkDeliveryChanged"/>
                        </td>
                        <td style="width: 1%">
                            <dx1:ASPxDateEdit ID="dtFromDelivery" runat="server" ClientInstanceName="dtFromDelivery" Font-Names="Tahoma"
                                Font-Size="8pt" EditFormat="Custom" EditFormatString="dd MMM yyyy" CalendarProperties-ShowWeekNumbers="False">
                                <ClientSideEvents 
                                    Init="function(s, e){s.SetDate(new Date());}"
                                    DateChanged="function(s, e){grid.PerformCallback('gridKosong')}"
                                />
                            </dx1:ASPxDateEdit>
                        </td>
                        <td style="width: 1%">
                            <dx1:ASPxLabel ID="ASPxLabel2" runat="server" Font-Names="Tahoma" Font-Size="8pt"
                                Text="~">
                            </dx1:ASPxLabel>
                        </td>
                        <td>
                            <dx1:ASPxDateEdit ID="dtToDelivery" runat="server" ClientInstanceName="dtToDelivery" Font-Names="Tahoma"
                                Font-Size="8pt" EditFormat="Custom" EditFormatString="dd MMM yyyy" CalendarProperties-ShowWeekNumbers="False">
                                <ClientSideEvents 
                                    Init="function(s, e){s.SetDate(new Date());}"
                                    DateChanged="function(s, e){grid.PerformCallback('gridKosong')}"
                                />
                            </dx1:ASPxDateEdit>
                        </td>
                    </tr>
                    <tr><td></td></tr>
                    <tr>
                        <td>
                            <dx1:ASPxLabel ID="ASPxLabel4" runat="server" Font-Names="Tahoma" Font-Size="8pt"
                                Text="FORWARDER PLAN RECEIPT DATE">
                            </dx1:ASPxLabel>
                        </td>
                        <td style="width: 3%">
                            <dx1:ASPxCheckBox ID="chkReceipt" runat="server" CheckState="Unchecked" ClientInstanceName="chkReceipt" ClientSideEvents-CheckedChanged="chkReceiveChanged"/>
                        </td>
                        <td style="width: 1%">
                            <dx1:ASPxDateEdit ID="dtFromReceipt" runat="server" ClientInstanceName="dtFromReceipt" Font-Names="Tahoma"
                                Font-Size="8pt" EditFormat="Custom" EditFormatString="dd MMM yyyy">
                                <ClientSideEvents 
                                    Init="function(s, e){s.SetDate(new Date());}"
                                    DateChanged="function(s, e){grid.PerformCallback('gridKosong')}"
                                />
                            </dx1:ASPxDateEdit>
                        </td>
                        <td style="width: 1%">
                            <dx1:ASPxLabel ID="ASPxLabel5" runat="server" Font-Names="Tahoma" Font-Size="8pt"
                                Text="~">
                            </dx1:ASPxLabel>
                        </td>
                        <td>
                            <dx1:ASPxDateEdit ID="dtToReceipt" runat="server" ClientInstanceName="dtToReceipt" Font-Names="Tahoma"
                                Font-Size="8pt" EditFormat="Custom" EditFormatString="dd MMM yyyy">
                                <ClientSideEvents 
                                    Init="function(s, e){s.SetDate(new Date());}"
                                    DateChanged="function(s, e){grid.PerformCallback('gridKosong')}"
                                />
                            </dx1:ASPxDateEdit>
                        </td>
                    </tr>
                    <tr><td></td></tr>
                    <tr>
                        <td>
                            <dx1:ASPxLabel ID="ASPxLabel6" runat="server" Font-Names="Tahoma" Font-Size="8pt"
                                Text="SUPPLIER SURAT JALAN NO.">
                            </dx1:ASPxLabel>
                        </td>
                        <td></td>
                        <td colspan="3">
                            <dx1:ASPxTextBox ID="txtSuratJalan" runat="server" Font-Names="Tahoma" Font-Size="8pt" ClientInstanceName="txtSuratJalan" MaxLength="20" CssClass="uppercase">
                                <ClientSideEvents TextChanged="function(s,e) {grid.PerformCallback('gridKosong');}" />
                            </dx1:ASPxTextBox>
                        </td>
                    </tr>
                    <tr><td></td></tr>
                    <tr>
                        <td>
                            <dx1:ASPxLabel ID="ASPxLabel9" runat="server" Font-Names="Tahoma" Font-Size="8pt"
                                Text="PO NO.">
                            </dx1:ASPxLabel>
                        </td>
                        <td></td>
                        <td colspan="3">
                            <dx1:ASPxTextBox ID="txtPoNo" runat="server" Font-Names="Tahoma" Font-Size="8pt" ClientInstanceName="txtPoNo" MaxLength="20" CssClass="uppercase">
                                <ClientSideEvents TextChanged="function(s,e) {grid.PerformCallback('gridKosong');}" />
                            </dx1:ASPxTextBox>
                        </td>
                    </tr>
                    <tr style="height:5px"><td></td></tr>
                </table>
            </td>

            <td style="width:50%">
                <table style="width: 100%;">
                    <tr>
                        <td style="width: 20%">
                            <dx1:ASPxLabel ID="ASPxLabel3" runat="server" Font-Names="Tahoma" Font-Size="8pt"
                                Text="AFFILIATE CODE">
                            </dx1:ASPxLabel>
                        </td>
                        <td style="width: 1%">
                            <dx1:ASPxComboBox ID="cboaffiliate" runat="server" ClientInstanceName="cboaffiliate" Font-Names="Tahoma" TextFormatString="{0}" Font-Size="8pt">
                                <ClientSideEvents SelectedIndexChanged="function(s, e) {txtaffiliateName.SetText(s.GetSelectedItem().GetColumnText(1)); grid.PerformCallback('gridKosong');}" />
                            </dx1:ASPxComboBox>
                        </td>
                        <td>
                            <dx1:ASPxTextBox ID="txtaffiliateName" runat="server" Font-Names="Tahoma" Font-Size="8pt" Width="100%" BackColor="Silver" ClientInstanceName="txtaffiliateName" ReadOnly="True"/>
                        </td>
                    </tr>
                    <tr><td></td></tr>
                    <tr>
                        <td>
                            <dx1:ASPxLabel ID="ASPxLabel7" runat="server" Font-Names="Tahoma" Font-Size="8pt"
                                Text="SUPPLIER CODE">
                            </dx1:ASPxLabel>
                        </td>
                        <td>
                            <dx1:ASPxComboBox ID="cboSupplier" runat="server" ClientInstanceName="cboSupplier" Font-Names="Tahoma" TextFormatString="{0}" Font-Size="8pt">
                                <ClientSideEvents SelectedIndexChanged="function(s, e) {txtSupplierName.SetText(s.GetSelectedItem().GetColumnText(1)); grid.PerformCallback('gridKosong');}" />
                            </dx1:ASPxComboBox>
                        </td>
                        <td>
                            <dx1:ASPxTextBox ID="txtSupplierName" runat="server" Font-Names="Tahoma" Font-Size="8pt" Width="100%" BackColor="Silver" ClientInstanceName="txtSupplierName" ReadOnly="True"/>
                        </td>
                    </tr>
                    <tr><td></td></tr>
                    <tr>
                        <td>
                            <dx1:ASPxLabel ID="ASPxLabel8" runat="server" Font-Names="Tahoma" Font-Size="8pt"
                                Text="FORWARDER">
                            </dx1:ASPxLabel>
                        </td>
                        <td>
                            <dx1:ASPxComboBox ID="cboForwarder" runat="server" ClientInstanceName="cboForwarder" Font-Names="Tahoma" TextFormatString="{0}" Font-Size="8pt">
                                <ClientSideEvents SelectedIndexChanged="function(s, e) {txtForwarder.SetText(s.GetSelectedItem().GetColumnText(1)); grid.PerformCallback('gridKosong');}" />
                            </dx1:ASPxComboBox>
                        </td>
                        <td>
                            <dx1:ASPxTextBox ID="txtForwarder" runat="server" Font-Names="Tahoma" Font-Size="8pt" Width="100%" BackColor="Silver" ClientInstanceName="txtForwarder" ReadOnly="True"/>
                        </td>
                    </tr>
                    <tr><td></td></tr>
                    <tr>
                        <td></td>
                        <td></td>
                        <td>
                            <dx1:ASPxButton ID="btnsearch" runat="server" Text="SEARCH" Width="85px" Font-Names="Tahoma"
                                Font-Size="8pt" ClientInstanceName="btnsearch" AutoPostBack="False">
                                <ClientSideEvents Click="function(s, e){
                                    grid.PerformCallback('gridload');
                                }" />
                            </dx1:ASPxButton>
                            &nbsp;&nbsp;
                            <dx1:ASPxButton ID="btnclear" runat="server" Text="CLEAR" Width="85px" Font-Names="Tahoma"
                                Font-Size="8pt" ClientInstanceName="btnclear" AutoPostBack="False">
                                <ClientSideEvents Click="function(s, e){
                                    chkDelivery.SetChecked(false);
                                    chkReceipt.SetChecked(false);

                                    dtFromDelivery.SetDate(new Date()); dtToDelivery.SetDate(new Date());
                                    dtFromReceipt.SetDate(new Date()); dtToReceipt.SetDate(new Date());

                                    txtSuratJalan.SetText('');
                                    txtPoNo.SetText('');
                                    lblerrmessage.SetText('');

                                    cboaffiliate.SetSelectedIndex(0);
                                    cboSupplier.SetSelectedIndex(0);
                                    cboForwarder.SetSelectedIndex(0);
                                }" />
                            </dx1:ASPxButton>
                        </td>
                        
                    </tr>
                </table>
            </td>
        </tr>
    </table>

    <table style="width:100%">
        <tr style="height:10px"><td></td></tr>
        <tr>
            <td>
                <table style="width:100%;height: 15px;border-top-width: 1px;border-top-style: solid;border-bottom-style: solid;border-bottom-width: 1px;">
                    <tr>
                        <td>
                            <dx1:ASPxLabel ID="lblerrmessage" runat="server" Font-Names="Tahoma" Font-Size="8pt" Text="ERROR MESSAGE" Width="100%" ClientInstanceName="lblerrmessage">
                            <ClientSideEvents Init="function(s, e) {lblerrmessage.SetText('')}"/>
                            </dx1:ASPxLabel>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr style="height:10px"><td></td></tr>
    </table>

    <table style="width:100%">
        <tr>
            <td>
                <dx:ASPxGridView ID="grid" runat="server" AutoGenerateColumns="False" Width="100%" KeyFieldName="No" ClientInstanceName="grid">
                    <ClientSideEvents EndCallback="function(s, e) {
                    debugger
						    var pMsg = s.cpMessage;                            
                            if (typeof(pMsg) != 'undefined') {
                                if (pMsg.substring(1,5) == '1001' || pMsg.substring(1,5) == '1002' || pMsg.substring(1,5) == '1003' || pMsg.substring(1,5) == '2001') {
                                    lblerrmessage.GetMainElement().style.color = 'Blue';
                                } else {
                                    lblerrmessage.GetMainElement().style.color = 'Red';
                                }
                                lblerrmessage.SetText(pMsg);
                            } else {
                                lblerrmessage.SetText('');
                            }
                            delete s.cpMessage;
                        }" 
                        RowClick="function(s, e) {lblerrmessage.SetText('')}" 
                        CallbackError="function(s, e) {e.handled = true}" 
                        BatchEditStartEditing="OnBatchEditStartEditing"
                        Init="OnInitGrid" />
                    <Columns>
                        <dx:GridViewDataHyperLinkColumn Caption=" " FieldName="coldetail" Name="coldetail" VisibleIndex="0" Width="50px">
                            <PropertiesHyperLinkEdit TextField="coldetailname" Target="_blank"/>
                            <HeaderStyle Font-Names="Tahoma" Font-Size="8pt" Font-Underline="False" Wrap="True" />
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt" VerticalAlign="Middle" HorizontalAlign="Center"/>
                        </dx:GridViewDataHyperLinkColumn>
            
                        <dx:GridViewDataTextColumn Caption="NO" FieldName="No" Name="No" VisibleIndex="1" Width="30px">
                            <HeaderStyle Font-Names="Tahoma" Font-Size="8pt" Font-Underline="False" Wrap="True" HorizontalAlign="Center" />
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt" VerticalAlign="Middle" HorizontalAlign="Center"/>
                        </dx:GridViewDataTextColumn>

                        <dx:GridViewDataTextColumn Caption="AFFILIATE" FieldName="Affiliate" Name="Affiliate" VisibleIndex="2" Width="100px">
                            <HeaderStyle Font-Names="Tahoma" Font-Size="8pt" Font-Underline="False" Wrap="True" HorizontalAlign="Center" />
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt" VerticalAlign="Middle" HorizontalAlign="Left"/>
                        </dx:GridViewDataTextColumn>

                        <dx:GridViewDataTextColumn Caption="SUPPLIER" FieldName="Supplier" Name="Supplier" VisibleIndex="3" Width="100px">
                            <HeaderStyle Font-Names="Tahoma" Font-Size="8pt" Font-Underline="False" Wrap="True" HorizontalAlign="Center" />
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt" VerticalAlign="Middle" HorizontalAlign="Left"/>
                        </dx:GridViewDataTextColumn>

                        <dx:GridViewDataTextColumn Caption="FORWARDER" FieldName="Forwarder" Name="Forwarder" VisibleIndex="4" Width="100px">
                            <HeaderStyle Font-Names="Tahoma" Font-Size="8pt" Font-Underline="False" Wrap="True" HorizontalAlign="Center" />
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt" VerticalAlign="Middle" HorizontalAlign="Left"/>
                        </dx:GridViewDataTextColumn>

                        <dx:GridViewDataTextColumn Caption="PO NO" FieldName="PoNo" Name="PoNo" VisibleIndex="5" Width="90px">
                            <HeaderStyle Font-Names="Tahoma" Font-Size="8pt" Font-Underline="False" Wrap="True" HorizontalAlign="Center" />
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt" VerticalAlign="Middle" HorizontalAlign="Left"/>
                        </dx:GridViewDataTextColumn>

                        <dx:GridViewDataTextColumn Caption="ORDER NO" FieldName="OrderNo" Name="OrderNo" VisibleIndex="6" Width="125px">
                            <HeaderStyle Font-Names="Tahoma" Font-Size="8pt" Font-Underline="False" Wrap="True" HorizontalAlign="Center" />
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt" VerticalAlign="Middle" HorizontalAlign="Left"/>
                        </dx:GridViewDataTextColumn>
						
						<dx:GridViewDataTextColumn Caption="SUPPLIER DELIVERY DATE" FieldName="DeliveryDate" Name="DeliveryDate" VisibleIndex="7" Width="105px">
                            <HeaderStyle Font-Names="Tahoma" Font-Size="8pt" Font-Underline="False" Wrap="True" HorizontalAlign="Center" />
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt" VerticalAlign="Middle" HorizontalAlign="Center"/>
                        </dx:GridViewDataTextColumn>

                        <dx:GridViewDataTextColumn Caption="SUPPLIER SURAT JALAN NO" FieldName="SuppSuratJalan" Name="SuppSuratJalan" VisibleIndex="8" Width="150px">
                            <HeaderStyle Font-Names="Tahoma" Font-Size="8pt" Font-Underline="False" Wrap="True" HorizontalAlign="Center" />
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt" VerticalAlign="Middle" HorizontalAlign="Left"/>
                        </dx:GridViewDataTextColumn>
                                                
                        <dx:GridViewDataTextColumn Caption="FORWARDER RECEIVED DATE" FieldName="ReceivedDate" Name="ReceivedDate" VisibleIndex="9" Width="105px">
                            <HeaderStyle Font-Names="Tahoma" Font-Size="8pt" Font-Underline="False" Wrap="True" HorizontalAlign="Center" />
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt" VerticalAlign="Middle" HorizontalAlign="Center"/>
                        </dx:GridViewDataTextColumn>

                        <dx:GridViewDataTextColumn Caption="REMARKS" FieldName="Remark" Name="Remark" VisibleIndex="10" Width="105px">
                            <HeaderStyle Font-Names="Tahoma" Font-Size="8pt" Font-Underline="False" Wrap="True" HorizontalAlign="Center" />
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt" VerticalAlign="Middle" HorizontalAlign="Left"/>
                        </dx:GridViewDataTextColumn>

                        <dx:GridViewDataTextColumn Caption="SUPPLIER SURAT JALAN" FieldName="SuppSuratJalan" Name="SuppSuratJalan" VisibleIndex="99" Width="0px">
                            <HeaderStyle Font-Names="Tahoma" Font-Size="8pt" Font-Underline="False" Wrap="True" HorizontalAlign="Center" />
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt" VerticalAlign="Middle" HorizontalAlign="Left"/>
                        </dx:GridViewDataTextColumn>
                    </Columns>
                    <SettingsPager Visible="False" Position="Top">
                        <Summary Text="Page {0} of {1} [{2} record(s)]" AllPagesText="Page {0} of {1} " />
                        <Summary AllPagesText="Page {0} of {1} " Text="Page {0} of {1} [{2} record(s)]">
                        </Summary>
                    </SettingsPager>
                    <SettingsEditing Mode="Batch"/>
                    <Settings ShowHorizontalScrollBar="True" ShowVerticalScrollBar="True" ShowGroupButtons="False"
                        ShowStatusBar="Hidden" VerticalScrollableHeight="250" />
                    <Styles>
                        <SelectedRow ForeColor="Black"/>
                    </Styles>
                    <StylesEditors ButtonEditCellSpacing="0">
                        <ProgressBar Height="21px"/>
                    </StylesEditors>
                </dx:ASPxGridView>
            </td>
        </tr>
        <tr style="height:10px"><td></td></tr>
        <tr>
            <td>    
                <dx1:ASPxButton ID="btnsubmenu" runat="server" Text="SUB MENU" Width="85px" Font-Names="Tahoma" Font-Size="8pt" ClientInstanceName="btnsubmenu" AutoPostBack="False">
                </dx1:ASPxButton>
            </td>
        </tr>
    </table>

    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="function(s, e) {
	        OnControlsInitializedSplitter();
            OnControlsInitialized();
        }" />
    </dx:ASPxGlobalEvents>

    <dx:ASPxHiddenField ID="HF" runat="server" ClientInstanceName="HF">
    </dx:ASPxHiddenField>
</asp:Content>
