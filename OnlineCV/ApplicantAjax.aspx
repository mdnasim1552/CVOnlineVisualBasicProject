<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="ApplicantAjax.aspx.vb" Inherits="OnlineCV.ApplicantAjax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
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



                 //let i = 1;
                 //var tableBody = $("#myTable tbody");
                 //tableBody.empty(); // Clear existing rows
                 //$.each(JSON.parse(data.d), function (index, item) {
                 //    tableBody.append(
                 //        '<tr>' +

                 //        '<td scope="row">' + i + '</td>' +
                 //        '<td>' + item.id + '</td>' +
                 //        '<td>' + item.fullname + '</td>' +
                 //        //'<td>' + item.Father_Name + '</td>' +
                 //        //'<td>' + item.Email + '</td>' +
                 //        //'<td>' + item.Mobile + '</td>' +
                 //        //'<td>' + item.Address + '</td>' +
                 //        //'<td>' + item.Region + '</td>' +
                 //        //'<td>' + item.Gender + '</td>' +
                 //        //'<td>' + item.Declaration + '</td>' +
                 //        //'<td>' + item.Interest + '</td>' +
                 //        //'<td>' + item.Photo + '</td>' +
                 //        //'<td>' + item.Region + '</td>' +
                 //        '</tr>'
                 //    );
                 //    i++;
                 //});

                 var emplist = JSON.parse(data.d);
                 var table = $('#myTable').find('tbody');
                 for (var i = 0; i < emplist.length; i++) {
                     var employee = emplist[i];
                     var row = $('<tr>').appendTo(table);
                     row.append($('<td>').text(i + 1)); // Add index as the first column
                     // Add edit button column with a button
                     //var editBtn = $('<button>').addClass('btn btn-primary btn-sm').text('Edit').on('click', (function (emp) {
                     //    return function () {
                     //        // Populate modal with employee data for editing
                     //        //populateModal(emp);
                     //        console.log(emp.id);
                     //    };
                     //})(employee)); // Pass 'employee' data to the closure
                     //row.append($('<td>').append(editBtn));

                     var editBtn = $('<button>').addClass('btn btn-primary btn-sm').text('Edit').on('click', (function (employee) {
                         return function (event) {
                             event.preventDefault(); // Prevent default action of the button click

                             // Here, you can add your code to populate the modal with employee data for editing
                             // For example, logging the employee ID
                             console.log(employee.fullname);

                             // You can further populate the modal or perform any other actions here
                         };
                     })(employee));

                     row.append($('<td>').append(editBtn));
                     //row.append($('<td>').text(employee.Action));
                     //row.append($('<td>').text(employee.Print));
                     row.append($('<td>').text(employee.id));
                     row.append($('<td>').text(employee.fullname));
                     row.append($('<td>').text(employee.fathername));
                     row.append($('<td>').text(employee.email));
                     row.append($('<td>').text(employee.mobile));
                     row.append($('<td>').text(employee.address));
                     row.append($('<td>').text(employee.gender));
                     row.append($('<td>').text(employee.region));
                     row.append($('<td>').text(employee.declaration));
                     row.append($('<td>').text(employee.interest));
                     /* row.append($('<td>').text(employee.photo_url));*/                 

                    // row.append($('<td>').append($('<img>').attr('src', employee.photo_url.substring(1)).addClass('img-thumbnail').attr('alt', '...')));
                     row.append($('<td>').append($('<img>').attr({
                         'src': employee.photo_url ? employee.photo_url.substring(1) : "/User_photo.png",
                         'alt': '...',
                         'class': 'img-thumbnail',
                         'height': '40px', // Set the desired height
                         'width': '50px'   // Set the desired width
                     })));
                      //Add delete button column with a button
                     var deleteBtn = $('<button>').addClass('btn btn-danger btn-sm').text('Delete').on('click', (function (id) {
                         return function (event) {
                             event.preventDefault(); // Prevent default action of the button click
                             // Here, 'id' refers to the 'employee.id' of this row
                             console.log(id);
                             // You can perform further actions using 'id', such as sending delete request to the server
                         };
                     })(employee.id)); // Pass 'employee.id' to the closure
                     row.append($('<td>').append(deleteBtn));

                     //// Append button to get data of the row
                     //row.append($('<td>').append($('<button>').addClass('btn btn-info btn-sm').text('Get Data').on('click', function () {
                     //    var rowData = getRowData($(this).closest('tr')); // Get data of the clicked row
                     //    console.log(rowData);
                     //    // Handle action to get data of the row here
                     //})));
                 }
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
                                     <th scope="col">Action</th>
                                     <%--<th scope="col">Print</th>--%>
                                     <th scope="col">Application_ID</th>
                                     <th scope="col">Name</th>
                                     <th scope="col">Father's Name</th>
                                     <th scope="col">Email</th>
                                     <th scope="col">Mobile</th>
                                     <th scope="col">Address</th>
                                     <th scope="col">Gender</th>
                                     <th scope="col">Region</th>
                                     <th scope="col">Declaration</th>
                                     <th scope="col">Interest</th>                                                                 
                                     <th scope="col">Photo</th>
                                     <th scope="col">Delete</th>
                                 </tr>
                             </thead>
                             <tbody></tbody>

                         </table>
                     </div>
                 </div>
             </div>
         </div>
     </ContentTemplate>
    
 </asp:UpdatePanel>
</asp:Content>
