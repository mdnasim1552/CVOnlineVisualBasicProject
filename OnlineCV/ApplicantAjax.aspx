<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="ApplicantAjax.aspx.vb" Inherits="OnlineCV.ApplicantAjax" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
    
 </style>

    <script type="text/javascript">
        var educountrow = 0;
        function UploadFile() {
            var empId = $('#applicationid').val();
            var imagepath = $('#existingImgurl').val();
            var FileUpload1 = $('#ImageUpload');
            var file = FileUpload1[0].files;
            var messageLbl = $('#ErrorMessageLabel');
            var formData = new FormData();
            formData.append("empId", empId);
            formData.append("imagepath", imagepath);
            for (var i = 0; i < file.length; i++) {
                formData.append(file[i].name, file[i]);
            }

            $.ajax({
                url: "Handler/UploadHandler.ashx",
                type: "POST",
                data: formData,
                contentType: false,
                processData: false,
                success: function (response) {
                    // Handle the server response here
                    if (response == "Error") {
                        messageLbl.text("Error: Invalid image type. Please upload a JPG, PNG, or GIF file.");
                        messageLbl.css('color', 'red');
                        FileUpload1.val('');
                    } else {
                        if (response != '') {
                            messageLbl.text("File uploaded successfully!");
                            messageLbl.css('color', 'green');
                            FileUpload1.val('');
                            $('#uploadedImage').attr({
                                'src': response.substring(1),
                                'alt': '...',
                                'class': 'img-thumbnail',
                                'height': '50px', // Set the desired height
                                'width': '50px'   // Set the desired width
                            });
                            $('#existingImgurl').val(response);
                        }
                    }


                    console.log(response);
                },
                error: function (error) {
                    // Handle errors here
                    messageLbl.text(error);
                    messageLbl.css('color', 'red !important');
                    console.log(error);
                }
            });
            // Prevent the default postback behavior
            //return false;
        }


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
            clearModal();
            LoadApplicantData();

        }
        function clearModal() {
            $('#applicationid').val("");
            $('#fullName').val("");
            $('#txtfname').val("");
            $('#txtaddress').val("");
            $('#txtcell').val("");
            $('#txtemail').val("");
            $('#male').prop('checked', false);
            $('#female').prop('checked', false);
            $('#txtregion').val(0);
            $('#FootballCheckbox').prop('checked', false);
            $('#CricketCheckbox').prop('checked', false);
            $('#declareCheckbox').prop('checked', false);

            $('#uploadedImage').attr({
                'src': "/User_photo.png",
                'alt': '...',
                'class': 'img-thumbnail',
                'height': '50px', // Set the desired height
                'width': '50px'   // Set the desired width
            });
            $('#ErrorMessageLabel').text("");

            if ($('#dynamicadd tr').length > 1) {
                // Remove all rows except the first one
                educountrow = 0;
                $('#dynamicadd tr:gt(0)').remove();
            }
        }
        $(document).ready(function () {

            LoadApplicantData();
            $('#add').click(function () {
                //alert('ok');
                educountrow++;
                $('#dynamicadd').append('<tr id="row' + educountrow + '"><td><input type="text" name="exam[]" id = "exam" class= "form-control" ></td ><td><input type="text" name="board[]" id="board" class="form-control"></td><td><input type="text" name="year[]" id="year" class="form-control"></td><td><input type="text" name="result[]" id="result" class="form-control"></td><td><button type="button" id="' + educountrow + '" class="btn btn-danger remove_row form-control">-</button></td></tr > ');
            });
            $(document).on('click', '.remove_row', function () {
                var row_id = $(this).attr("id");
                $('#row' + row_id + '').remove();
                educountrow--;
            });


            $("#btnsave").click(function () {
                var myTableData = [];
                var id = $('#applicationid').val();
                var photo_url = $('#existingImgurl').val();
                var fullName = $('#fullName').val();
                var fathername = $('#txtfname').val();
                var address = $('#txtaddress').val();
                var mobile = $('#txtcell').val();
                var email = $('#txtemail').val();
                var region = $('#txtregion option:selected').text();
                var interest = "";
                if ($('#FootballCheckbox').prop('checked') && $('#CricketCheckbox').prop('checked')) {
                    interest = "Football,Cricket";
                } else if ($('#FootballCheckbox').prop('checked')) {
                    interest = "Football";
                } else if ($('#CricketCheckbox').prop('checked')) {
                    interest = "Cricket";
                }
                var declaration = "";
                if ($('#declareCheckbox').prop('checked')) {
                    declaration = "I have declared all the information are correct.";
                }
                var gender = "";

                if ($('#male').prop('checked')) {
                    gender = "Male";
                } else if ($('#female').prop('checked')) {
                    gender = "Female";
                }

                $('#dynamicadd tr').each(function (row) {
                    //console.log('Hello');
                    myTableData[row] = {
                        "Exam": $(this).find('input[name="exam[]"]').val(),
                        "Board": $(this).find('input[name="board[]"]').val(),
                        "Year": $(this).find('input[name="year[]"]').val(),
                        "Result": $(this).find('input[name="result[]"]').val()

                    }
                });

                var emp = {
                    id: id,
                    fullName: fullName,
                    fathername: fathername,
                    email: email,
                    mobile: mobile,
                    address: address,
                    gender: gender,
                    region: region,
                    declaration: declaration,
                    interest: interest,
                    photo_url: photo_url
                };

                console.log(emp);
                console.log(myTableData);
                var jsonData = JSON.stringify(myTableData);
                var empData = JSON.stringify(emp);
                if (id != '') {
                    $.ajax({
                        type: "POST",
                        url: 'ApplicantAjax.aspx/UpdateEmpAndEducationInfo', // Update with the correct route
                        contentType: 'application/json',
                        dataType: "json",
                        data: JSON.stringify({ jsonData: jsonData, empData: empData }),
                        success: function (response) {
                            showContent('Data Updated successfully');
                        },
                        error: function (error) {
                            showContentFail('Error Updating data ' + error.responseText);
                            //console.log("Error Updating data.");
                        }
                    });
                } else {

                    $.ajax({
                        type: "POST",
                        url: 'ApplicantAjax.aspx/InsertEmpAndEducationInfo', // Update with the correct route
                        contentType: 'application/json',
                        dataType: "json",
                        data: JSON.stringify({ jsonData: jsonData, empData: empData }),
                        success: function (response) {
                            showContent('Data Inserted successfully');
                        },
                        error: function (error) {
                            showContentFail('Error Inserting data ' + error.responseText);
                            //console.log("Error Updating data.");
                        }
                    });

                }
               



            });

        });
        function LoadApplicantData() {
            $.ajax({
                type: "POST",
                url: 'ApplicantAjax.aspx/GetApplicant', // Update with the correct route
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
                    table.empty();
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

                                $.ajax({
                                    type: "POST",
                                    url: 'ApplicantAjax.aspx/GetEducationInfo', // Update with the correct route
                                    contentType: 'application/json',
                                    dataType: "json",
                                    data: JSON.stringify({ id: employee.id }),
                                    success: function (response) {
                                        var edulist = JSON.parse(response.d);
                                        if (edulist.length > 0) {
                                            var edu;
                                            for (var j = 0; j < edulist.length; j++) {

                                                if (j > 0) {
                                                    educountrow++;
                                                    edu = edulist[educountrow];
                                                    $('#dynamicadd').append('<tr id="row' + educountrow + '"><td><input type="text" name="exam[]" id = "exam" class= "form-control" value="'
                                                        + edu.exam + '"></td ><td><input type="text" name="board[]" id="board" class="form-control" value="'
                                                        + edu.board + '"></td><td><input type="text" name="year[]" id="year" class="form-control" value="'
                                                        + edu.year + '"></td><td><input type="text" name="result[]" id="result" class="form-control" value="'
                                                        + edu.result + '"></td><td><button type="button" id="'
                                                        + educountrow + '" class="btn btn-danger remove_row form-control">-</button></td></tr > ');
                                                } else {
                                                    edu = edulist[educountrow];
                                                    $('#exam').val(edu.exam);
                                                    $('#board').val(edu.board);
                                                    $('#year').val(edu.year);
                                                    $('#result').val(edu.result);
                                                }

                                            }
                                        }
                                    },
                                    error: function (error) {
                                        console.log("Error fetching data.");
                                    }
                                });


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
                                                    (employee.region === "China") ? 6 : 0;

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
                                $('#uploadedImage').attr({
                                    'src': employee.photo_url ? employee.photo_url.substring(1) : "/User_photo.png",
                                    'alt': '...',
                                    'class': 'img-thumbnail',
                                    'height': '50px', // Set the desired height
                                    'width': '50px'   // Set the desired width
                                });
                                $('#applicationid').val(employee.id);
                                $('#existingImgurl').val(employee.photo_url);
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
                        var deleteBtn = $('<button>').addClass('btn btn-danger btn-sm').text('Delete').on('click', (function (employee) {
                            return function (event) {
                                event.preventDefault(); // Prevent default action of the button click
                                // Here, 'id' refers to the 'employee.id' of this row
                                //console.log(id);
                                $.ajax({
                                    type: "POST",
                                    url: 'ApplicantAjax.aspx/DeleteEmpAndEducationInfo', // Update with the correct route
                                    contentType: 'application/json',
                                    dataType: "json",
                                    data: JSON.stringify({ id: employee.id, photo_url: employee.photo_url ? employee.photo_url : "" }),
                                    success: function (response) {
                                        showContent(response.d);
                                        LoadApplicantData();
                                    },
                                    error: function (error) {
                                        showContentFail('Error Deleting data' + error.responseText);
                                        //console.log("Error Updating data.");
                                    }
                                });

                                // You can perform further actions using 'id', such as sending delete request to the server
                            };
                        })(employee)); // Pass 'employee.id' to the closure
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
        }
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
                        <div class="col-md-11" style="margin-top: 21px;">
                            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalAddUser">
                                <i class="bi bi-plus fw-bold"></i>
                            </button>
                        </div>
                        <div class="col-md-1">
                            <label for="ddlpagesize" class="fw-bold">Page Size</label>
                            <select class="form-select me-2" aria-label="Default select example" id="ddlpagesize">
                                <option value="10" selected>10</option>
                                <option value="20">20</option>
                                <option value="30">30</option>
                                <option value="50">50</option>
                                <option value="100">100</option>
                                <option value="200">200</option>
                                <option value="5000">5000</option>
                            </select>

                        </div>
                    </div>
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
                            <button id="closebtnID" type="button" class="close" aria-hidden="true" aria-label="Close" onclick="closeUserModal()"><i class="fas fa-times-circle"></i></button>
                        </div>
                        <div class="modal-body form-horizontal">
                            <input type="hidden" id="applicationid">
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
                                        <option value="0" selected>None</option>
                                        <option value="1">Pakistan</option>
                                        <option value="2">Iran</option>
                                        <option value="3">Iraq</option>
                                        <option value="4">Turkey</option>
                                        <option value="5">India</option>
                                        <option value="6">China</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="txtaddress"><b>Address</b></label>
                                    <input type="text" id="txtaddress" class="form-control input-sm" placeholder="Address" />
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
                                    <div class="mb-3 d-flex">
                                        <div>
                                            <label for="ImageUpload"><b>Upload your photo</b></label>
                                            <input class="form-control" type="file" id="ImageUpload">
                                            <label id="ErrorMessageLabel" forecolor="Red"></label>
                                        </div>
                                        <div class="mt-4">
                                            <button type="button" id="btnupload" class="btn btn-secondary" onclick="UploadFile()">Upload</button>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <img id="uploadedImage" src="/User_photo.png" style="height: 50px; width: 50px;">
                                        <input type="hidden" id="existingImgurl">
                                    </div>

                                </div>
                                <div class="col-md-6 mb-3">
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
                                <div class="col-md-12">

                                    <table class="table table-bordered myTable">
                                        <thead>
                                            <tr>
                                                <th scope="col">Exam</th>
                                                <th scope="col">Board</th>
                                                <th scope="col">Year</th>
                                                <th scope="col">Result</th>
                                                <th scope="col">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody id="dynamicadd">
                                            <tr>
                                                <td>
                                                    <input type="text" name="exam[]" id="exam" class="form-control"></td>
                                                <td>
                                                    <input type="text" name="board[]" id="board" class="form-control"></td>
                                                <td>
                                                    <input type="text" name="year[]" id="year" class="form-control"></td>
                                                <td>
                                                    <input type="text" name="result[]" id="result" class="form-control"></td>
                                                <td>
                                                    <button type="button" id="add" class=" form-control btn btn-success">+</button></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-12 mb-3">
                                    <input type="checkbox" id="declareCheckbox" class="form-check-input" value="I have declared all the information are correct." />
                                    <label for="declareCheckbox" class="form-check-label"><b>I have declared all the information are correct.</b></label>
                                </div>
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button type="button" id="btnsave" class="btn btn-secondary" style="width: 220px;">Save</button>
                        </div>
                    </div>
                </div>
            </div>

        </ContentTemplate>

    </asp:UpdatePanel>
</asp:Content>
