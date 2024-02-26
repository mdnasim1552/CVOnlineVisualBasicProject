<%@ Page Title="Contact" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ApplicantListAjax.aspx.vb" Inherits="OnlineCV.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Latest compiled and minified CSS -->

    <style>
       
    </style>

    <script type="text/javascript">
       
        $(document).ready(function () {

            $.ajax({
                type: "POST",
                url: 'ApplicantListAjax.aspx/GetApplicant', // Update with the correct route
                contentType: 'application/json',
                dataType: "json",
                success: function (data) {



                    let i = 1;
                    var tableBody = $("#myTable tbody");
                    tableBody.empty(); // Clear existing rows
                    $.each(data, function (index, item) {
                        tableBody.append(
                            '<tr>' +

                            '<td scope="row">' + i + '</td>' +
                            '<td>' + item.Application_ID + '</td>' +
                            '<td>' + item.Name + '</td>' +
                            '<td>' + item.Father_Name + '</td>' +
                            '<td>' + item.Email + '</td>' +
                            '<td>' + item.Mobile + '</td>' +
                            '<td>' + item.Address + '</td>' +
                            '<td>' + item.Region + '</td>' +
                            '<td>' + item.Gender + '</td>' +
                            '<td>' + item.Declaration + '</td>' +
                            '<td>' + item.Interest + '</td>' +
                            '<td>' + item.Photo + '</td>' +
                            '<td>' + item.Region + '</td>' +
                            '</tr>'
                        );
                        i++;
                    });

                    //var emplist = JSON.parse(data.d);
                    //var emplist = JSON.parse(data.d);
                    //var table = $('#myTable').find('tbody');
                    //for (var i = 0; i < emplist.length; i++) {
                    //    var employee = emplist[i];
                    //    var row = $('<tr>').appendTo(table);
                    //    row.append($('<td>').text(i + 1)); // Add index as the first column
                    //    //row.append($('<td>').text(employee.Action));
                    //    //row.append($('<td>').text(employee.Print));
                    //    row.append($('<td>').text(employee.Application_ID));
                    //    row.append($('<td>').text(employee.Name));
                    //    row.append($('<td>').text(employee.Father_Name));
                    //    row.append($('<td>').text(employee.Email));
                    //    row.append($('<td>').text(employee.Mobile));
                    //    row.append($('<td>').text(employee.Address));
                    //    row.append($('<td>').text(employee.Region));
                    //    row.append($('<td>').text(employee.Gender));
                    //    row.append($('<td>').text(employee.Declaration));
                    //    row.append($('<td>').text(employee.Interest));
                    //    row.append($('<td>').text(employee.Photo));
                    //    row.append($('<td>').text(employee.Region));

                    //    // Add delete button column with a button
                    //    //var deleteBtn = $('<button>').addClass('btn btn-danger btn-sm').text('Delete').on('click', function () {
                    //    //    // Handle delete action here
                    //    //    // You may want to send a delete request to the server
                    //    //    // or perform any other action based on your requirement
                    //    //});
                    //    //row.append($('<td>').append(deleteBtn));

                    //    //// Append button to get data of the row
                    //    //row.append($('<td>').append($('<button>').addClass('btn btn-info btn-sm').text('Get Data').on('click', function () {
                    //    //    var rowData = getRowData($(this).closest('tr')); // Get data of the clicked row
                    //    //    console.log(rowData);
                    //    //    // Handle action to get data of the row here
                    //    //})));
                    //}
                },
                error: function (error) {
                    console.log("Error fetching data.");
                }
            });
            

        });
        
    </script>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="card">
                <div class="card-header">
                    <header class="panel-heading offset-1">
                        <div class=" text-center mt-4">
                            <h1 class="mb-4">Applicant List</h1>
                        </div>
                    </header>
                </div>
                <div class="card-header">
                    
                    <div class="row">
                        <div class="col-md-12">
                            <table class="table table-sm table-hover caption-top display" id="myTable">
                                <caption>List of Applicant</caption>
                                <thead class="table-info">
                                    <tr>
                                        <th scope="col">#</th>
                                       <%-- <th scope="col">Action</th>
                                        <th scope="col">Print</th>--%>
                                        <th scope="col">Application_ID</th>
                                        <th scope="col">Name</th>
                                        <th scope="col">Father's Name</th>
                                        <th scope="col">Email</th>
                                        <th scope="col">Mobile</th>
                                        <th scope="col">Address</th>
                                        <th scope="col">Region</th>
                                        <th scope="col">Gender</th>
                                        <th scope="col">Declaration</th>
                                        <th scope="col">Interest</th>
                                        <th scope="col">Photo</th>
                                        <th scope="col">Region</th>
                                       <%-- <th scope="col" style="width: 100px;">Delete</th>--%>
                                    </tr>
                                </thead>


                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
       
    </asp:UpdatePanel>
</asp:Content>
