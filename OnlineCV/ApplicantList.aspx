<%@ Page Title="About" Async="true" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ApplicantList.aspx.vb" Inherits="OnlineCV.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Latest compiled and minified CSS -->

    <style>
        .SumoSelect .select-all {
            border-radius: 3px 3px 0 0;
            position: relative;
            border-bottom: 1px solid #ddd;
            background-color: #fff;
            padding: 5px 0 3px 35px;
            height: 35px;
            cursor: pointer;
        }
    </style>

    <script type="text/javascript">
        function UploadFile(rowIndex) {
            var empId = $('#<%= gvapplicant.ClientID %> tr').eq(rowIndex + 1).find('[id*=lblapplicationid]').text().trim();
            var imagepath = $('#<%= gvapplicant.ClientID %> tr').eq(rowIndex + 1).find('[id*=Hiddenphoto_urlID]').text().trim();
            //Hiddenphoto_urlID
            var FileUpload1 = $('#<%= gvapplicant.ClientID %> tr').eq(rowIndex + 1).find('[id*=FileUpload1]');
            var file = FileUpload1[0].files;
            var messageLbl = $('#<%= gvapplicant.ClientID %> tr').eq(rowIndex + 1).find('[id*=ErrorMessageLabel]');
            var imageurlforCodebehind = $('#<%= gvapplicant.ClientID %> tr').eq(rowIndex + 1).find('[id*=Hiddenphoto_urlID]');
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
                        messageLbl.text("File uploaded successfully!");
                        messageLbl.css('color', 'green');
                        FileUpload1.val('');
                        
                       <%-- $('#<%= gvapplicant.ClientID %> tr').eq(rowIndex + 1).find('[id*=Hiddenphoto_urlID]').val(response);
                        $('#<%= gvapplicant.ClientID %> tr').eq(rowIndex + 1).find('[id*=photo_urlID]').val(response);
                        $('#<%= gvapplicant.ClientID %> tr').eq(rowIndex + 1).find('[id*=aphoto_urlID]').val(response);--%>

                        // Optionally, update the hidden label text
                        //imageurlforCodebehind.text(response);
                        $("#<%= HiddenField1.ClientID %>").val(response);
                        
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
            return false;
        }
        $(document).ready(function () {
            // Now you can perform operations on specificListBoxID
            // For example, applying the Multiselect plugin
            $('#<%= ReportListBox.ClientID%>').SumoSelect({
                placeholder: 'Select Here',
                search: true,
                searchText: 'Enter here.',
                selectAll: true,
                okCancelInMulti: true
            });
            $('[id*=ListBoxID]').SumoSelect({
                placeholder: 'Select Here',
                search: true,
                searchText: 'Enter here.',
                selectAll: true,
                okCancelInMulti: true
            });

            $('.chzn-select').chosen({ search_contains: true });
            Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(pageLoaded);

        });
        function pageLoaded() {

            $('#<%= ReportListBox.ClientID%>').SumoSelect({
                placeholder: 'Select Here',
                search: true,
                searchText: 'Enter here.',
                selectAll: true,
                okCancelInMulti: true
            });

            $('[id*=ListBoxID]').SumoSelect({
                placeholder: 'Select Here',
                search: true,
                searchText: 'Enter here.',
                selectAll: true,
                okCancelInMulti: true
            });
            $('.chzn-select').chosen({ search_contains: true });
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
                        <div class="col-md-2">
                            <asp:Label ID="page_Id" runat="server" CssClass="form-label" Text="Page Size"></asp:Label>
                            <asp:DropDownList ID="ddlpagesize" runat="server" AutoPostBack="True" CssClass="form-control form-control-sm"
                                OnSelectedIndexChanged="ddlpagesize_SelectedIndexChanged">
                                <asp:ListItem>10</asp:ListItem>
                                <asp:ListItem>20</asp:ListItem>
                                <asp:ListItem>30</asp:ListItem>
                                <asp:ListItem>50</asp:ListItem>
                                <asp:ListItem>100</asp:ListItem>
                                <asp:ListItem>150</asp:ListItem>
                                <asp:ListItem>200</asp:ListItem>
                                <asp:ListItem>300</asp:ListItem>
                                <asp:ListItem>600</asp:ListItem>
                                <asp:ListItem>900</asp:ListItem>
                                <asp:ListItem>1200</asp:ListItem>
                                <asp:ListItem>1500</asp:ListItem>
                                <asp:ListItem>3000</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-4">
                            <asp:ListBox ID="ReportListBox" runat="server" CssClass="form-control form-control-sm" SelectionMode="Multiple">
                                <asp:ListItem Value="1">Appointment Letter</asp:ListItem>
                                <asp:ListItem Value="0">Application Form</asp:ListItem>
                                <asp:ListItem Value="8">Age Form</asp:ListItem>
                                <asp:ListItem Value="9">Training Letter</asp:ListItem>
                                <asp:ListItem Value="7">Nominee Form</asp:ListItem>
                                <asp:ListItem Value="2">Workers Confirm. Letter</asp:ListItem>
                                <asp:ListItem Value="3">Evaluation Form</asp:ListItem>
                                <asp:ListItem Value="4">CPF</asp:ListItem>
                                <asp:ListItem Value="5">CPF2(N Form)</asp:ListItem>
                                <asp:ListItem Value="6">CPF3</asp:ListItem>
                                <asp:ListItem Value="10">Envelope English (Permanent)</asp:ListItem>
                                <asp:ListItem Value="11">Envelope Bangla (Permanent)</asp:ListItem>
                                <asp:ListItem Value="12">Envelope English (Present)</asp:ListItem>
                                <asp:ListItem Value="13">Envelope Bangla (Present)</asp:ListItem>
                                <asp:ListItem Value="14">Office Envelope</asp:ListItem>
                                <asp:ListItem Value="15">Joining Letter</asp:ListItem>
                                <asp:ListItem Value="16">Bank Opening</asp:ListItem>
                                <asp:ListItem Value="17">Appointment Top Sheet</asp:ListItem>
                                <asp:ListItem Value="18">Salary Certificate</asp:ListItem>
                                <asp:ListItem Value="19">Probationary Evaluation Form</asp:ListItem>
                                <asp:ListItem Value="20">Suspension</asp:ListItem>
                            </asp:ListBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <asp:GridView ID="gvapplicant" runat="server" AutoGenerateColumns="False" AllowPaging="True" Width="100%"
                                ShowFooter="True" CssClass="table-striped table-hover table-bordered grvContentarea"
                                OnRowEditing="gvapplicant_RowEditing" OnRowCancelingEdit="gvapplicant_RowCancelingEdit" OnRowUpdating="gvapplicant_RowUpdating"
                                OnRowDeleting="gvapplicant_RowDeleting" OnPageIndexChanging="gvapplicant_PageIndexChanging">
                                <PagerSettings NextPageText="Next" PreviousPageText="Previous" Mode="NumericFirstLast" />
                                <PagerStyle CssClass="gvPagination" />
                                <HeaderStyle CssClass="grvHeaderNew" />
                                <FooterStyle CssClass="grvFooterNew" />
                                <RowStyle CssClass="grvRowsNew" />
                                <Columns>
                                    <asp:TemplateField HeaderText="Sl">
                                        <ItemTemplate>
                                            <asp:Label ID="slid" runat="server"
                                                Text='<%# Convert.ToString(Container.DataItemIndex + 1) + "." %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="center" />
                                        <ItemStyle HorizontalAlign="center" />
                                    </asp:TemplateField>
                                    <asp:CommandField DeleteText="" HeaderText="Edit" InsertText="" NewText=""
                                        SelectText="" ShowEditButton="True" EditText="&lt;i class=&quot;fa fa-edit&quot; aria-hidden=&quot;true&quot;&gt;&lt;/i&gt;">
                                        <HeaderStyle HorizontalAlign="center" />
                                        <ItemStyle ForeColor="#0000C0" HorizontalAlign="center" />
                                    </asp:CommandField>



                                    <asp:TemplateField HeaderText="Application_ID">

                                        <ItemTemplate>
                                            <asp:Label ID="lblapplicationid" runat="server" BackColor="Transparent"
                                                BorderStyle="None" Width="100%"
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "id")) %>'
                                                Style="text-align: left"></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="left" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Name">

                                        <ItemTemplate>
                                            <asp:Label ID="lblname" runat="server" BackColor="Transparent"
                                                BorderStyle="None" Width="100%"
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "fullname")) %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtname" runat="server"
                                                BorderStyle="None" Width="100%" Style="border-top-style: none; border-right-style: none; border-left-style: none; border-bottom-style: none; border-left-color: midnightblue; border-bottom-color: midnightblue; border-top-color: midnightblue; border-right-color: midnightblue;"
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "fullname")) %>'></asp:TextBox>
                                        </EditItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="left" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Father's Name">

                                        <ItemTemplate>
                                            <asp:Label ID="lblfathername" runat="server" BackColor="Transparent"
                                                BorderStyle="None" Width="100%"
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "fathername")) %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtfathername" runat="server"
                                                BorderStyle="None" Width="100%" Style="border-top-style: none; border-right-style: none; border-left-style: none; border-bottom-style: none; border-left-color: midnightblue; border-bottom-color: midnightblue; border-top-color: midnightblue; border-right-color: midnightblue;"
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "fathername")) %>'></asp:TextBox>
                                        </EditItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="left" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Email">

                                        <ItemTemplate>
                                            <asp:Label ID="lblemail" runat="server" BackColor="Transparent"
                                                BorderStyle="None" Width="100%"
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "email")) %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtemail" runat="server" Width="100%" Style="border-top-style: none; border-right-style: none; border-left-style: none; border-bottom-style: none; border-left-color: midnightblue; border-bottom-color: midnightblue; border-top-color: midnightblue; border-right-color: midnightblue;"
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "email")) %>'>
                                            </asp:TextBox>
                                        </EditItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="left" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Mobile">
                                        <ItemTemplate>
                                            <asp:Label ID="lblmobile" runat="server" BackColor="Transparent"
                                                BorderStyle="None" Width="100%"
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "mobile")) %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtMobile" runat="server" Width="100%" Style="border-top-style: none; border-right-style: none; border-left-style: none; border-bottom-style: none; border-left-color: midnightblue; border-bottom-color: midnightblue; border-top-color: midnightblue; border-right-color: midnightblue;"
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "mobile")) %>'>
                                            </asp:TextBox>
                                        </EditItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="left" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Address">
                                        <ItemTemplate>
                                            <asp:Label ID="lbladdress" runat="server" BackColor="Transparent" Width="100%"
                                                BorderStyle="None"
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "address")) %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtaddress" runat="server" Width="100%" Style="border-top-style: none; border-right-style: none; border-left-style: none; border-bottom-style: none; border-left-color: midnightblue; border-bottom-color: midnightblue; border-top-color: midnightblue; border-right-color: midnightblue;"
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "address")) %>'>
                                            </asp:TextBox>
                                        </EditItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="left" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Region">
                                        <ItemTemplate>
                                            <asp:Label ID="lblregion" runat="server" BackColor="Transparent" Width="100%"
                                                BorderStyle="None"
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "region")) %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <%--<asp:TextBox ID="txtregion" runat="server" Width="100%" Style="border-top-style: none; border-right-style: none; border-left-style: none; border-bottom-style: none; border-left-color: midnightblue; border-bottom-color: midnightblue; border-top-color: midnightblue; border-right-color: midnightblue;"
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "region")) %>'>
                                            </asp:TextBox>--%>
                                            <asp:DropDownList ID="ddlRegion" runat="server" Width="100%" Style="border-top-style: none; border-right-style: none; border-left-style: none; border-bottom-style: none; border-left-color: midnightblue; border-bottom-color: midnightblue; border-top-color: midnightblue; border-right-color: midnightblue;" CssClass="form-control form-control-sm">
                                                <asp:ListItem Text="Pakistan" />
                                                <asp:ListItem Text="Iran" />
                                                <asp:ListItem Text="Iraq" />
                                                <asp:ListItem Text="Turkey" />
                                                <asp:ListItem Text="India" />
                                                <asp:ListItem Text="China" />
                                            </asp:DropDownList>
                                        </EditItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="left" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Gender">
                                        <ItemTemplate>
                                            <asp:Label ID="lblgender" runat="server" BackColor="Transparent" Width="100%"
                                                BorderStyle="None"
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "gender")) %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <%-- <asp:TextBox ID="txtgender" runat="server" Width="100%" Style="border-top-style: none; border-right-style: none; border-left-style: none; border-bottom-style: none; border-left-color: midnightblue; border-bottom-color: midnightblue; border-top-color: midnightblue; border-right-color: midnightblue;"
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "gender")) %>'>
                                            </asp:TextBox>--%>
                                            <asp:DropDownList ID="ddlGender" runat="server" Width="100%" Style="border-top-style: none; border-right-style: none; border-left-style: none; border-bottom-style: none; border-left-color: midnightblue; border-bottom-color: midnightblue; border-top-color: midnightblue; border-right-color: midnightblue;" CssClass="form-control form-control-sm">
                                                <asp:ListItem Text="Male" />
                                                <asp:ListItem Text="Female" />
                                            </asp:DropDownList>
                                        </EditItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="left" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Declaration">
                                        <ItemTemplate>
                                            <asp:Label ID="lbldeclaration" runat="server" BackColor="Transparent" Width="100%"
                                                BorderStyle="None"
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "declaration")) %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <%-- <asp:TextBox ID="txtdeclaration" runat="server" Width="100%" Style="border-top-style: none; border-right-style: none; border-left-style: none; border-bottom-style: none; border-left-color: midnightblue; border-bottom-color: midnightblue; border-top-color: midnightblue; border-right-color: midnightblue;"
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "declaration")) %>'>
                                            </asp:TextBox>--%>
                                            <asp:DropDownList ID="ddlDeclare" runat="server" Width="100%" Style="border-top-style: none; border-right-style: none; border-left-style: none; border-bottom-style: none; border-left-color: midnightblue; border-bottom-color: midnightblue; border-top-color: midnightblue; border-right-color: midnightblue;" CssClass="form-control form-control-sm">
                                                <asp:ListItem Value="1" Text="Yes" />
                                                <asp:ListItem Value="0" Text="No" />
                                            </asp:DropDownList>

                                        </EditItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="left" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Interest">
                                        <ItemTemplate>
                                            <asp:Label ID="lblinterest" runat="server" BackColor="Transparent" Width="100%"
                                                BorderStyle="None"
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "interest")) %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:ListBox ID="ListBoxID" runat="server" SelectionMode="Multiple" CssClass="form-control form-control-sm">
                                                <asp:ListItem Value="1">Football</asp:ListItem>
                                                <asp:ListItem Value="0">Cricket</asp:ListItem>
                                            </asp:ListBox>
                                            <asp:Label ID="lblinteresthidden" runat="server" BackColor="Transparent" Width="100%" Visible="false"
                                                BorderStyle="None"
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "interest")) %>'></asp:Label>
                                        </EditItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="left" />
                                    </asp:TemplateField>


                                    <asp:TemplateField HeaderText="Photo">
                                        <ItemTemplate>
                                            <a id="aphoto_urlID" href='<%# If(String.IsNullOrEmpty(Convert.ToString(DataBinder.Eval(Container.DataItem, "photo_url"))), Me.ResolveUrl("/User_photo.png"), Me.ResolveUrl(Convert.ToString(DataBinder.Eval(Container.DataItem, "photo_url")))) %>' target="_blank">
                                                <asp:Image ID="photo_urlID" runat="server" CssClass="pop image img img-responsive img-thumbnail row" Height="40px" Width="50px"
                                                    ImageUrl='<%# If(String.IsNullOrEmpty(Convert.ToString(DataBinder.Eval(Container.DataItem, "photo_url"))), "/User_photo.png", Convert.ToString(DataBinder.Eval(Container.DataItem, "photo_url"))) %>' />
                                            </a>
                                            <asp:Label ID="lblHiddenphotoo_urlID" runat="server" ForeColor="Red" Style="display: none;" Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "photo_url")) %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:FileUpload ID="FileUpload1" runat="server"/>
                                            <asp:Button ID="UploadButton" runat="server" Text="Upload"  OnClientClick='<%# "return UploadFile(" + Convert.ToString(Container.DisplayIndex) + ");" %>' UseSubmitBehavior="false"></asp:Button>
                                            <asp:Label ID="ErrorMessageLabel" runat="server" ForeColor="Red"></asp:Label>
                                            <asp:Label ID="Hiddenphoto_urlID" runat="server" ForeColor="Red" Style="display: none;" Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "photo_url")) %>' ClientIDMode="Static"></asp:Label>
                                        </EditItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:TemplateField>

                                    <asp:CommandField ShowDeleteButton="True" DeleteText="&lt;i class=&quot;fa fa-trash&quot; aria-hidden=&quot;true&quot;&gt;&lt;/i&gt;" ControlStyle-Width="19px">
                                        <HeaderStyle Font-Bold="True" HorizontalAlign="Center" />
                                        <ItemStyle Font-Bold="True" ForeColor="red" HorizontalAlign="Center" />
                                    </asp:CommandField>


                                </Columns>


                            </asp:GridView>
                            <asp:HiddenField ID="HiddenField1" runat="server" ClientIDMode="Static" />
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
       <%-- <Triggers>
            <asp:PostBackTrigger ControlID="gvapplicant" />
        </Triggers>--%>
    </asp:UpdatePanel>
</asp:Content>
