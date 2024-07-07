<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="UpdateControl.ascx.vb" Inherits="OnlineCV.UpdateControl" %>


    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        function sendRequest() {
            
            $.ajax({
                url: 'ApplicantList.aspx',
                type: 'GET',
                success: function (data) {
                    alert(data);
                    // Do something with the response data
                },
                error: function (error) {
                    // Handle error
                }
            });
        }
    </script>
<div>
    <asp:Button ClientIDMode="Static" formnovalidate ID="Button1" runat="server" Text="Button" Autopostback="false" OnClientClick="sendRequest();" />
    <asp:LinkButton ID="lnkbtnRefresh" ClientIDMode="Static" OnClientClick="return confirm('Do You want to Refresh?');" runat="server" CssClass="btn btn-sm btn-success" Style="margin: 0 5px;" OnClick="lnkbtnRefresh_Click"><i class="fa fa-save" aria-hidden="true"></i>&nbsp;Refresh</asp:LinkButton>
</div>
