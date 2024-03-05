<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="ControlTestUsingAjax.aspx.vb" Inherits="OnlineCV.ControlTestUsingAjax"%>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div id="applicantControlContainer">
        <!-- Placeholder for dynamically loaded ApplicantControl -->
    </div>

    <asp:HiddenField ID="HiddenLabelText" runat="server" />
    <%-- <button id="loadControlButton">Load Control</button>--%>
    <asp:Button ID="loadControlButton" runat="server" Text="Load Control" OnClick="loadControlButton_Click"  OnClientClick="setLabelText(); return true;" formnovalidate />
    <div runat="server" id="sortable" visible="false">
        <!-- Placeholder for dynamically loaded control -->
    </div>

    <script type="text/javascript">
        $(document).ready(function () {
            // Define click event handler for the load control button           
           
        });
        function setLabelText() {
            $("#<%= HiddenLabelText.ClientID %>").val('nasim');
         }
        //$(document).ready(function () {
        //    // Define click event handler for the load control button
        //    $('#loadControlButton').click(function () {
        //        // Call the function to load the control
        //        loadUserControl('ApplicantControlHandler', 'ApplicantControl.ascx');
        //        return false;
        //    });
        //});

        //// Function to load user control dynamically
        //function loadUserControl(handlerName, controlName) {
        //    // Construct the URL of the handler
        //    var handlerUrl = 'ApplicantControlHandler.ashx?controlName=' + controlName;

        //    // Make AJAX request to the handler
        //    $.ajax({
        //        type: 'GET',
        //        url: handlerUrl,
        //        success: function (response) {
        //            // Append the received HTML to the sortable div
        //            $('#sortable').empty();
        //            $('#sortable').html(response);
        //        },
        //        error: function (xhr, status, error) {
        //            // Handle error
        //            console.error('Error loading control:', error);
        //        }
        //    });
        //}




    </script>

</asp:Content>
