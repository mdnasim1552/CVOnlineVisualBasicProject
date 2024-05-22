<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="UpdateControl.ascx.vb" Inherits="OnlineCV.UpdateControl" %>

<div>
     <asp:LinkButton ID="lnkbtnRefresh" ClientIDMode="Static" OnClientClick="return confirm('Do You want to Refresh?');" runat="server" CssClass="btn btn-sm btn-success" Style="margin: 0 5px;" OnClick="lnkbtnRefresh_Click"><i class="fa fa-save" aria-hidden="true"></i>&nbsp;Refresh</asp:LinkButton>
</div>
