<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="ControlTest2.aspx.vb" Inherits="OnlineCV.ControlTest2" %>

<%@ Register Src="~/ApplicantControl.ascx" TagPrefix="uc1" TagName="ApplicantControl" %>
<%@ Register Src="~/UpdateControl.ascx" TagPrefix="uc1" TagName="UpdateControl" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <%--<asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>--%>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <uc1:ApplicantControl runat="server" ID="ApplicantControl" />
            <uc1:UpdateControl runat="server" ID="UpdateControl" />
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="UpdateControl" EventName="RefreshApplicantControl" />
        </Triggers>
    </asp:UpdatePanel>

    <%-- <uc1:ApplicantControl runat="server" id="ApplicantControl" />
    <uc1:UpdateControl runat="server" id="UpdateControl" />--%>
</asp:Content>
