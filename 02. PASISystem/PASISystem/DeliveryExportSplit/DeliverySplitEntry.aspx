<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/SiteContent.Master" CodeBehind="DeliverySplitEntry.aspx.vb" Inherits="PASISystem.DeliverySplitEntry" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxEditors" TagPrefix="dx1" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxGridView" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxGridView.Export" TagPrefix="dx2" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxGlobalEvents" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxHiddenField" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Content" runat="server">
    <script type="text/javascript">
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

        function OnBatchEditStartEditing(s, e) {
            currentColumnName = e.focusedColumn.fieldName;

            if (currentColumnName != "Check") {
                e.cancel = true;
            }
        }

        function OnAllCheckedChanged(s, e) {
            if (s.GetValue() == -1) s.SetValue(1);
            for (var i = 0; i < grid.GetVisibleRowsOnPage(); i++) {
                grid.batchEditApi.SetCellValue(i, "Check", s.GetValue());
            }
        }

        function Submit(s, e) {
            debugger

            var fwd = cboForwarderSplit.GetText();

            if (fwd == '') {
                lblerrmessage.SetText('[9999] Please Choose Forwarder for Split first!');
                lblerrmessage.GetMainElement().style.color = 'Red';
                alert('Please Choose Forwarder first!');
                return false;
            } else {
                grid.UpdateEdit();

                setTimeout(function () {
                    grid.PerformCallback('');
                }, 100);
            }
        }

        function Back(s, e) {
            window.close();
        }
    </script>

    <table style="width:100%">
        <tr>
            <td style="width:50%">
                <table style="width:100%">
                    <tr>
                        <td style="width:20%">
                            <dx1:ASPxLabel ID="ASPxLabel1" runat="server" Font-Names="Tahoma" Font-Size="8pt"
                                Text="DELIVERY DATE">
                            </dx1:ASPxLabel>
                        </td>

                        <td>
                            <dx1:ASPxTextBox ID="txtDeliveryDate" runat="server" Font-Names="Tahoma" Font-Size="8pt" BackColor="Silver" ClientInstanceName="txtDeliveryDate" ReadOnly="True" Text="01 December 2022"/>
                        </td>
                    </tr>
                    <tr><td></td></tr>
                    <tr>
                        <td>
                            <dx1:ASPxLabel ID="ASPxLabel2" runat="server" Font-Names="Tahoma" Font-Size="8pt"
                                Text="SUPPLIER SURAT JALAN">
                            </dx1:ASPxLabel>
                        </td>

                        <td>
                            <dx1:ASPxTextBox ID="txtSuratJalan" runat="server" Font-Names="Tahoma" Font-Size="8pt" BackColor="Silver" ClientInstanceName="txtSuratJalan" ReadOnly="True"/>
                        </td>
                    </tr>
                    <tr><td></td></tr>
                    <tr>
                        <td>
                            <dx1:ASPxLabel ID="ASPxLabel3" runat="server" Font-Names="Tahoma" Font-Size="8pt"
                                Text="PO NO">
                            </dx1:ASPxLabel>
                        </td>

                        <td>
                            <dx1:ASPxTextBox ID="txtPoNo" runat="server" Font-Names="Tahoma" Font-Size="8pt" BackColor="Silver" ClientInstanceName="txtPoNo" ReadOnly="True"/>
                        </td>
                    </tr>
                    <tr><td></td></tr>
                    <tr>
                        <td>
                            <dx1:ASPxLabel ID="ASPxLabel4" runat="server" Font-Names="Tahoma" Font-Size="8pt"
                                Text="ORDER NO">
                            </dx1:ASPxLabel>
                        </td>

                        <td>
                            <dx1:ASPxTextBox ID="txtOrderNo" runat="server" Font-Names="Tahoma" Font-Size="8pt" BackColor="Silver" ClientInstanceName="txtOrderNo" ReadOnly="True"/>
                        </td>
                    </tr>
                    <tr><td></td></tr>
                    <tr style="visibility:hidden">
                        <td>
                            <dx1:ASPxLabel ID="ASPxLabel10" runat="server" Font-Names="Tahoma" Font-Size="8pt"
                                Text="Col Index">
                            </dx1:ASPxLabel>
                        </td>

                        <td>
                            <dx1:ASPxTextBox ID="txtColIndex" runat="server" Font-Names="Tahoma" Font-Size="8pt" BackColor="Silver" ClientInstanceName="txtColIndex" ReadOnly="True"/>
                        </td>
                    </tr>
                </table>
            </td>

            <td style="width:50%">
                <table style="width:100%">
                    <tr>
                        <td style="Width:20%">
                            <dx1:ASPxLabel ID="ASPxLabel5" runat="server" Font-Names="Tahoma" Font-Size="8pt"
                                Text="AFFILIATE">
                            </dx1:ASPxLabel>
                        </td>

                        <td>
                            <dx1:ASPxTextBox ID="txtAffiliate" runat="server" Font-Names="Tahoma" Font-Size="8pt" BackColor="Silver" Width="100%" ClientInstanceName="txtAffiliate" ReadOnly="True"/>
                        </td>

                        <td>
                            <dx1:ASPxTextBox ID="txtAffiliateName" runat="server" Font-Names="Tahoma" Font-Size="8pt" BackColor="Silver" Width="100%" ClientInstanceName="txtAffiliateName" ReadOnly="True"/>
                        </td>
                    </tr>
                    <tr><td></td></tr>
                    <tr>
                        <td>
                            <dx1:ASPxLabel ID="ASPxLabel6" runat="server" Font-Names="Tahoma" Font-Size="8pt"
                                Text="SUPPLIER">
                            </dx1:ASPxLabel>
                        </td>

                        <td>
                            <dx1:ASPxTextBox ID="txtSupplier" runat="server" Font-Names="Tahoma" Font-Size="8pt" BackColor="Silver" Width="100%" ClientInstanceName="txtSupplier" ReadOnly="True"/>
                        </td>

                        <td>
                            <dx1:ASPxTextBox ID="txtSupplierName" runat="server" Font-Names="Tahoma" Font-Size="8pt" BackColor="Silver" Width="100%" ClientInstanceName="txtSupplierName" ReadOnly="True"/>
                        </td>
                    </tr>
                    <tr><td></td></tr>
                    <tr>
                        <td>
                            <dx1:ASPxLabel ID="ASPxLabel7" runat="server" Font-Names="Tahoma" Font-Size="8pt"
                                Text="FORWARDER">
                            </dx1:ASPxLabel>
                        </td>

                        <td>
                            <dx1:ASPxTextBox ID="txtForwarder" runat="server" Font-Names="Tahoma" Font-Size="8pt" BackColor="Silver" Width="100%" ClientInstanceName="txtForwarder" ReadOnly="True"/>
                        </td>

                        <td>
                            <dx1:ASPxTextBox ID="txtForwarderName" runat="server" Font-Names="Tahoma" Font-Size="8pt" BackColor="Silver" Width="100%" ClientInstanceName="txtForwarderName" ReadOnly="True"/>
                        </td>
                    </tr>
                    <tr><td></td></tr>
                    <tr>
                        <td style="background-color:#f9fd00">
                            <dx1:ASPxLabel ID="ASPxLabel8" runat="server" Font-Names="Tahoma" Font-Size="8pt"
                                Text="FORWARDER SPLIT">
                            </dx1:ASPxLabel>
                        </td>

                        <td style="width:1%">
                            <dx1:ASPxComboBox ID="cboForwarderSplit" runat="server" ClientInstanceName="cboForwarderSplit" Font-Names="Tahoma" TextFormatString="{0}" Font-Size="8pt">
                                <ClientSideEvents SelectedIndexChanged="function(s, e) {
                                        txtForwarderSplit.SetText(s.GetSelectedItem().GetColumnText(1));
                                        lblerrmessage.SetText('');
                                        lblerrmessage.GetMainElement().style.color = 'Blue';
                                    }" />
                            </dx1:ASPxComboBox>
                        </td>

                        <td>
                            <dx1:ASPxTextBox ID="txtForwarderSplit" runat="server" Font-Names="Tahoma" Font-Size="8pt" BackColor="Silver" Width="100%" ClientInstanceName="txtForwarderSplit" ReadOnly="True"/>
                        </td>
                    </tr>
                    <tr><td></td></tr>
                    <tr>
                        <td style="background-color:#f9fd00">
                            <dx1:ASPxLabel ID="ASPxLabel9" runat="server" Font-Names="Tahoma" Font-Size="8pt"
                                Text="REMARKS">
                            </dx1:ASPxLabel>
                        </td>

                        <td colspan="2">
                            <dx1:ASPxTextBox ID="txtRemarks" runat="server" Font-Names="Tahoma" Font-Size="8pt" Width="100%" ClientInstanceName="txtRemarks" MaxLength="100"/>
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
                            <dx1:ASPxLabel ID="lblerrmessage" runat="server" Font-Names="Tahoma" Font-Size="8pt" Text="ERROR MESSAGE" Width="100%" ClientInstanceName="lblerrmessage"/>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr style="height:10px"><td></td></tr>
    </table>

    <table style="width:100%">
        <tr>
            <td colspan="2">
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

                                if (pMsg.substring(1,5) == '1002'){
                                    btnSave.SetEnabled(false);
                                }
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
                        <dx:GridViewDataCheckColumn Caption=" " FieldName="Check" Name="Check" VisibleIndex="0" Width="40px">
                            <PropertiesCheckEdit ValueChecked="1" ValueType="System.Int32" ValueUnchecked="0">
                            </PropertiesCheckEdit>
                            <HeaderCaptionTemplate>
                                <dx1:ASPxCheckBox ID="chkAll" runat="server" ClientInstanceName="chkAll" ClientSideEvents-CheckedChanged="OnAllCheckedChanged"
                                    ValueType="System.Int32" ValueChecked="1" ValueUnchecked="0">
                                </dx1:ASPxCheckBox>
                            </HeaderCaptionTemplate>
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt"/>
                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle"/>
                        </dx:GridViewDataCheckColumn>
            
                        <dx:GridViewDataTextColumn Caption="NO" FieldName="No" Name="No" VisibleIndex="1" Width="30px">
                            <HeaderStyle Font-Names="Tahoma" Font-Size="8pt" Font-Underline="False" Wrap="True" HorizontalAlign="Center" />
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt" VerticalAlign="Middle" HorizontalAlign="Center"/>
                        </dx:GridViewDataTextColumn>

                        <dx:GridViewDataTextColumn Caption="PO NO" FieldName="PoNo" Name="PoNo" VisibleIndex="2" Width="150px">
                            <HeaderStyle Font-Names="Tahoma" Font-Size="8pt" Font-Underline="False" Wrap="True" HorizontalAlign="Center" />
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt" VerticalAlign="Middle" HorizontalAlign="Left"/>
                        </dx:GridViewDataTextColumn>

                        <dx:GridViewDataTextColumn Caption="ORDER NO" FieldName="OrderNo" Name="OrderNo" VisibleIndex="3" Width="200px">
                            <HeaderStyle Font-Names="Tahoma" Font-Size="8pt" Font-Underline="False" Wrap="True" HorizontalAlign="Center" />
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt" VerticalAlign="Middle" HorizontalAlign="Left"/>
                        </dx:GridViewDataTextColumn>

                        <dx:GridViewDataTextColumn Caption="PART NO" FieldName="PartNo" Name="PartNo" VisibleIndex="4" Width="150px">
                            <HeaderStyle Font-Names="Tahoma" Font-Size="8pt" Font-Underline="False" Wrap="True" HorizontalAlign="Center" />
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt" VerticalAlign="Middle" HorizontalAlign="Left"/>
                        </dx:GridViewDataTextColumn>

                        <dx:GridViewDataTextColumn Caption="LABEL BOX" FieldName="BoxNo" Name="BoxNo" VisibleIndex="5" Width="125px">
                            <HeaderStyle Font-Names="Tahoma" Font-Size="8pt" Font-Underline="False" Wrap="True" HorizontalAlign="Center" />
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt" VerticalAlign="Middle" HorizontalAlign="Left"/>
                        </dx:GridViewDataTextColumn>

                        <dx:GridViewDataTextColumn Caption="MOQ" FieldName="MOQ" Name="MOQ" VisibleIndex="6" Width="50px">
                            <HeaderStyle Font-Names="Tahoma" Font-Size="8pt" Font-Underline="False" Wrap="True" HorizontalAlign="Center" />
                            <CellStyle Font-Names="Tahoma" Font-Size="8pt" VerticalAlign="Middle" HorizontalAlign="Center"/>
                        </dx:GridViewDataTextColumn>
                        
                        <dx:GridViewDataTextColumn Caption="SUPPLIER SURAT JALAN" FieldName="PoNo" Name="PoNo" VisibleIndex="99" Width="0px">
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
                        ShowStatusBar="Hidden"/>
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
                <dx1:ASPxButton ID="btnsubmenu" runat="server" Text="BACK" Width="85px" Font-Names="Tahoma" Font-Size="8pt" ClientInstanceName="btnsubmenu" AutoPostBack="False">
                    <ClientSideEvents Click="Back" />
                </dx1:ASPxButton>
            </td>
            <td align="right">
                <dx1:ASPxButton ID="btnSave" runat="server" Text="SAVE" Width="85px" Font-Names="Tahoma" Font-Size="8pt" ClientInstanceName="btnSave" AutoPostBack="False">
                    <ClientSideEvents Click="Submit" />
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