<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="ApplicantAjax.aspx.vb" Inherits="OnlineCV.ApplicantAjax" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
    
 </style>

    <script type="text/javascript">
        function openUserModal() {
            /* $('#modalAddUser').modal('hide');*/
            $('.modal-backdrop').remove();
            $('#modalAddUser').modal('toggle', {
                backdrop: 'static',
                keyboard: false
            });
        }
        function closeUserModal() {
            $('.modal-backdrop').remove();
            $('#modalAddUser').modal('hide');
        }
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
                                $('#fullName').val(employee.fullname);
                                $('#txtfname').val(employee.fathername);
                                $('#txtaddress').val(employee.address);
                                $('#txtcell').val(employee.mobile);
                                $('#txtemail').val(employee.email);
                                if (employee.gender === 'Male') {
                                    $('#male').prop('checked', true);
                                } else if (employee.gender === 'Female') {
                                    $('#female').prop('checked', true);
                                }
                                var regionValue = (employee.region === "Pakistan") ? 1 :
                                    (employee.region === "Iran") ? 2 :
                                        (employee.region === "Iraq") ? 3 :
                                            (employee.region === "Turkey") ? 4 :
                                                (employee.region === "India") ? 5 :
                                                    (employee.region === "China") ? 6 : null;

                                $('#txtregion').val(regionValue);
                                var array = employee.interest.split(/[,\s]+/);
                                if (array.length === 2) {
                                    $('#FootballCheckbox').prop('checked', true);
                                    $('#CricketCheckbox').prop('checked', true);
                                } else if (array[0] === 'Football') {
                                    $('#FootballCheckbox').prop('checked', true);
                                } else if (array[0] === 'Cricket') {
                                    $('#CricketCheckbox').prop('checked', true);
                                }
                                if (employee.declaration === 'I have declared all the information are correct.') {
                                    $('#declareCheckbox').prop('checked', true);
                                }
                                //<option value="1" selected>Pakistan</option>
                                //<option value="2">Iran</option>
                                //<option value="3">Iraq</option>
                                //<option value="3">Turkey</option>
                                //<option value="3">India</option>
                                //<option value="3">China</option>
                                openUserModal();
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


            <div id="modalAddUser" class="modal animated slideInLeft " role="dialog" data-keyboard="false" data-backdrop="static">
                <div class="modal-dialog modal-xl">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title"><span class="fa fa-table"></span>&nbsp;Job Application</h5>
                            <button id="closebtnID" type="button" class="close" data-dismiss="modal" aria-hidden="true" aria-label="Close" data-bs-dismiss="modal"><i class="fas fa-times-circle"></i></button>
                        </div>
                        <div class="modal-body form-horizontal">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="fullName"><b>Full Name</b></label>
                                    <input id="fullName" type="text" class="form-control input-sm" placeholder="Full Name" />
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="txtfname"><b>Father Name</b></label>
                                    <input id="txtfname" type="text" class="form-control input-sm" placeholder="Father Name" />
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="txtregion" class="fw-bold">Region</label>
                                    <select class="form-select me-2" aria-label="Default select example" id="txtregion">
                                        <!-- <option selected>Open this select menu</option> -->
                                        <option value="1" selected>Pakistan</option>
                                        <option value="2">Iran</option>
                                        <option value="3">Iraq</option>
                                        <option value="4">Turkey</option>
                                        <option value="5">India</option>
                                        <option value="6">China</option>
                                    </select>
                                    <%--<asp:DropDownList ID="txtregion" CssClass="form-control input-sm" runat="server">
                                        <asp:ListItem Text="Pakistan" />
                                        <asp:ListItem Text="Iran" />
                                        <asp:ListItem Text="Iraq" />
                                        <asp:ListItem Text="Turkey" />
                                        <asp:ListItem Text="India" />
                                        <asp:ListItem Text="China" />
                                    </asp:DropDownList>--%>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="txtaddress"><b>Address</b></label>
                                    <input type="text" id="txtaddress" class="form-control input-sm" placeholder="Address" />
                                    <%-- <textarea Enabled="True" ID="txtaddress" cols="20" rows="2" class="form-control input-sm" placeholder=" Address "></textarea>--%>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="txtcell"><b>Mobile Number</b></label>
                                    <input type="number" id="txtcell" class="form-control input-sm" placeholder="Mobile Number" />

                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="txtemail"><b>Email</b></label>
                                    <input type="email" id="txtemail" class="form-control input-sm" placeholder="Email" />
                                </div>
                            </div>




                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label><b>Interest:</b></label>
                                        <label class="form-check-label" for="FootballCheckbox"><b>Football</b></label>
                                        <input class="form-check-input" type="checkbox" value="Football" id="FootballCheckbox">
                                        <label class="form-check-label" for="CricketCheckbox"><b>Cricket</b></label>
                                        <input class="form-check-input" type="checkbox" value="Cricket" id="CricketCheckbox">
                                    </div>
                                    <div class="mb-3">
                                        <asp:Label runat="server" AssociatedControlID="ImageUpload"><b>Upload your photo</b></asp:Label>
                                        <asp:FileUpload ID="ImageUpload" runat="server" />
                                        <asp:Label ID="ErrorMessageLabel" runat="server" ForeColor="Red" Visible="false"></asp:Label>
                                    </div>

                                </div>
                                <div class="col-md-6 mb-3">
                                    <%-- <asp:Label runat="server" AssociatedControlID="txtgender"><b>Gender</b></asp:Label><br />
                                    <asp:RadioButtonList CssClass="form-group" ID="txtgender" runat="server">
                                        <asp:ListItem Text="Male" />
                                        <asp:ListItem Text="Female" />
                                    </asp:RadioButtonList>
                                    --%>

                                    <!-- HTML code -->
                                    <div class="form-group">
                                        <label class="fw-bold">Gender:</label><br>
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="gender" id="male" value="male">
                                            <label class="form-check-label" for="male">Male</label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="gender" id="female" value="female">
                                            <label class="form-check-label" for="female">Female</label>
                                        </div>
                                    </div>
                                </div>
                            </div>


                            <div class="row">
                                <div class="col-md-12 mb-3">
                                    <input type="checkbox" ID="declareCheckbox" class="form-check-input" value="I have declared all the information are correct." />
                                    <Label for="declareCheckbox" class="form-check-label"><b>I have declared all the information are correct.</b></Label>
                                    <%--<asp:TextBox runat="server" required="required" TextMode="Number" Enabled="True" name="BrandName" ID="TextBox1" class="form-control input-sm" placeholder="Mobile Number"></asp:TextBox>--%>
                                </div>
                            </div>
                        </div>

                        <div class="modal-footer">
                            <%--<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>--%>
                            <button type="button" id="btnsave" class="btn btn-secondary" style="width: 220px;">Save</button>
                        </div>
                    </div>
                </div>
            </div>

        </ContentTemplate>

    </asp:UpdatePanel>
</asp:Content>
