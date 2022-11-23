<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/SiteContent.Master" CodeBehind="DeliverySplitEntry.aspx.vb" Inherits="PASISystem.DeliverySplitEntry" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxEditors" TagPrefix="dx1" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxGridView" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxGridView.Export" TagPrefix="dx2" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxGlobalEvents" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxHiddenField" TagPrefix="dx" %>

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
    </script>

    <table style="width:100%">
        <tr>
            <td style="width:50%">
                <table style="width:100%">
                    <tr>
                        <td>
                            <dx1:ASPxLabel ID="ASPxLabel1" runat="server" Font-Names="Tahoma" Font-Size="8pt"
                                Text="DELIVERY DATE">
                            </dx1:ASPxLabel>
                        </td>

                        <td>
                            <dx1:ASPxTextBox ID="txtDeliveryDate" runat="server" Font-Names="Tahoma" Font-Size="8pt" Width="100%" BackColor="Silver" ClientInstanceName="txtDeliveryDate" ReadOnly="True"/>
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
                            <dx1:ASPxTextBox ID="txtSuratJalan" runat="server" Font-Names="Tahoma" Font-Size="8pt" Width="100%" BackColor="Silver" ClientInstanceName="txtSuratJalan" ReadOnly="True"/>
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
                            <dx1:ASPxTextBox ID="txtPoNo" runat="server" Font-Names="Tahoma" Font-Size="8pt" Width="100%" BackColor="Silver" ClientInstanceName="txtPoNo" ReadOnly="True"/>
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
                            <dx1:ASPxTextBox ID="txtOrderNo" runat="server" Font-Names="Tahoma" Font-Size="8pt" Width="100%" BackColor="Silver" ClientInstanceName="txtOrderNo" ReadOnly="True"/>
                        </td>
                    </tr>
                </table>
            </td>

            <td style="width:50%">
                <table style="width:100%">
                
                </table>
            </td>
        </tr>
    </table>

</asp:Content>