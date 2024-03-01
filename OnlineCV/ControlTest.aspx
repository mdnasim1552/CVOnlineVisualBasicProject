<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="ControlTest.aspx.vb" Inherits="OnlineCV.ControlTest" %>

<%--<%@ Register Src="~/ApplicantControl.ascx" TagPrefix="uc1" TagName="ApplicantControl" %>--%>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <%-- <uc1:ApplicantControl runat="server" id="ApplicantControl" />--%>
    <div runat="server" id="allcontrols">
        <!-- Placeholder for dynamically loaded control -->
    </div>
</asp:Content>
