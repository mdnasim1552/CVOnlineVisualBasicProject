<%@ Page Title="Home Page" Async="true" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.vb" Inherits="OnlineCV._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            var i = 1;
            $('#add').click(function () {
                //alert('ok');
                i++;
                $('#dynamicadd').append('<tr id="row' + i + '"><td><input type="text" name="exam[]" id = "exam" class= "form-control" ></td ><td><input type="text" name="board[]" id="board" class="form-control"></td><td><input type="text" name="year[]" id="year" class="form-control"></td><td><input type="text" name="result[]" id="result" class="form-control"></td><td><button type="button" id="' + i + '" class="btn btn-danger remove_row form-control">-</button></td></tr > ');
            });
            $(document).on('click', '.remove_row', function () {
                var row_id = $(this).attr("id");
                $('#row' + row_id + '').remove();
            });
            var myTableData = [];

            $("#btnsave").click(function () {
                $('#dynamicadd tr').each(function (row) {
                    //console.log('Hello');
                    myTableData[row] = {
                        "Exam": $(this).find('input[name="exam[]"]').val(),
                        "Board": $(this).find('input[name="board[]"]').val(),
                        "Year": $(this).find('input[name="year[]"]').val(),
                        "Result": $(this).find('input[name="result[]"]').val()

                    }
                });
                console.log(myTableData);
                var jsonData = JSON.stringify(myTableData);
                $("#<%= MyData.ClientID %>").val(jsonData);
            });

        });


    </script>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="card">
                <div class="card-header">
                    <header class="panel-heading offset-1">
                        <div class=" text-center mt-4">
                            <h1 class="mb-4">Job Application</h1>
                        </div>
                    </header>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <asp:Label runat="server" AssociatedControlID="fullName"><b>Full Name</b></asp:Label><br />
                            <asp:TextBox runat="server" required="required" Enabled="True" name="BrandName" ID="fullName" CssClass="form-control input-sm" placeholder="Full Name"></asp:TextBox>
                        </div>
                        <div class="col-md-6 mb-3">
                            <asp:Label runat="server" AssociatedControlID="txtfname"><b>Father Name</b></asp:Label><br />
                            <asp:TextBox runat="server" required="required" Enabled="True" name="BrandName" ID="txtfname" CssClass="form-control input-sm" placeholder="Father Name"></asp:TextBox>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <asp:Label runat="server" AssociatedControlID="txtregion"><b>Region</b></asp:Label><br />
                            <asp:DropDownList ID="txtregion" CssClass="form-control input-sm" runat="server">
                                <asp:ListItem Text="Pakistan" />
                                <asp:ListItem Text="Iran" />
                                <asp:ListItem Text="Iraq" />
                                <asp:ListItem Text="Turkey" />
                                <asp:ListItem Text="India" />
                                <asp:ListItem Text="China" />
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-6 mb-3">
                            <asp:Label runat="server" AssociatedControlID="txtaddress"><b>Address</b></asp:Label><br />
                            <asp:TextBox runat="server" required="required" Enabled="True" name="BrandName" ID="txtaddress" CssClass="form-control input-sm" placeholder=" Address "></asp:TextBox>
                            <%-- <textarea Enabled="True" ID="txtaddress" cols="20" rows="2" class="form-control input-sm" placeholder=" Address "></textarea>--%>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <asp:Label runat="server" AssociatedControlID="txtcell"><b>Mobile Number</b></asp:Label><br />
                            <asp:TextBox runat="server" required="required" TextMode="Number" Enabled="True" name="BrandName" ID="txtcell" CssClass="form-control input-sm" placeholder="Mobile Number"></asp:TextBox>

                        </div>
                        <div class="col-md-6 mb-3">
                            <asp:Label runat="server" AssociatedControlID="txtemail"><b>Email</b></asp:Label><br />
                            <asp:TextBox runat="server" required="required" TextMode="Email" Enabled="True" name="BrandName" ID="txtemail" CssClass="form-control input-sm" placeholder="Email"></asp:TextBox>

                        </div>
                    </div>




                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <asp:Label runat="server"><b>Interest:</b></asp:Label>
                                <asp:Label runat="server" AssociatedControlID="FootballCheckbox"><b>Football</b></asp:Label>
                                <asp:CheckBox ID="FootballCheckbox" runat="server" />
                                <asp:Label runat="server" AssociatedControlID="CricketCheckbox"><b>Cricket</b></asp:Label>
                                <asp:CheckBox ID="CricketCheckbox" runat="server" />
                            </div>
                            <div class="mb-3">
                                <asp:Label runat="server" AssociatedControlID="ImageUpload"><b>Upload your photo</b></asp:Label>
                                <asp:FileUpload ID="ImageUpload" runat="server" />
                                <asp:Label ID="ErrorMessageLabel" runat="server" ForeColor="Red" Visible="false"></asp:Label>
                            </div>

                        </div>
                        <div class="col-md-6 mb-3">
                            <asp:Label runat="server" AssociatedControlID="txtgender"><b>Gender</b></asp:Label><br />
                            <asp:RadioButtonList CssClass="form-group" ID="txtgender" runat="server">
                                <asp:ListItem Text="Male" />
                                <asp:ListItem Text="Female" />
                            </asp:RadioButtonList>
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

                    <asp:HiddenField ID="MyData" runat="server" ClientIDMode="Static" />

                    <div class="row">
                        <div class="col-md-12 mb-3">
                            <asp:CheckBox ID="declareCheckbox" runat="server" />
                            <asp:Label runat="server" AssociatedControlID="declareCheckbox"><b>I have declared all the information are correct.</b></asp:Label>
                            <%--<asp:TextBox runat="server" required="required" TextMode="Number" Enabled="True" name="BrandName" ID="TextBox1" class="form-control input-sm" placeholder="Mobile Number"></asp:TextBox>--%>
                        </div>
                    </div>




                    <div class="row">
                        <div class="col-md-12 mb-3">
                            <asp:Button Text="Save" ID="btnsave" ClientIDMode="Static" CssClass="btn btn-primary btn-lg" Width="220px" runat="server" OnClick="btnsave_Click" />

                            <asp:Label Text="" ForeColor="Green" Font-Bold="true" ID="lblmessage" CssClass="label label-success" runat="server" />
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnsave" />
        </Triggers>
    </asp:UpdatePanel>


</asp:Content>
