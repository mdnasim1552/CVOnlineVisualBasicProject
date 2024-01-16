<%@ Page Title="About" Async="true" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ApplicantList.aspx.vb" Inherits="OnlineCV.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .customStyleOfFormControl {
            height: 1.5rem !important;
        }

        .multiselect {
            width: 274px !important;
            border: 1px solid;
            height: 29px;
            border-color: #cfd1d4;
            font-family: sans-serif;
        }

        .multiselect-container {
            overflow: scroll;
            max-height: 300px !important;
        }
        /*.multiselect {
            width: 270px !important;
            text-wrap: initial !important;
            height: 27px !important;
        }*/

        .multiselect-text {
            width: 200px !important;
        }

        /*.multiselect-container {
            height: 250px !important;
            width: 300px !important;
            overflow-y: scroll !important;
        }*/
        .caret {
            display: none !important;
        }

        span.multiselect-selected-text {
            width: 200px !important;
        }

        #ContentPlaceHolder1_divgrp {
            /*width: 395px !important;*/
        }

        .chzn-single {
            border-radius: 3px !important;
            height: 29px !important;
        }
    </style>
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
                            <asp:DropDownList ID="ddlpagesize" runat="server" AutoPostBack="True" CssClass="form-control form-control-sm " Width="70px"
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
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <asp:GridView ID="gvapplicant" runat="server" AutoGenerateColumns="False" AllowPaging="True" Width="100%"
                                ShowFooter="True" CssClass="table-striped table-hover table-bordered grvContentarea"
                                 OnRowEditing="gvapplicant_RowEditing"  OnRowCancelingEdit="gvapplicant_RowCancelingEdit" OnRowUpdating="gvapplicant_RowUpdating"
                                 OnRowDeleting="gvapplicant_RowDeleting"  OnPageIndexChanging="gvapplicant_PageIndexChanging">
                                <PagerSettings NextPageText="Next" PreviousPageText="Previous" Mode="NumericFirstLast" />
                                <PagerStyle CssClass="gvPagination" />
                                <HeaderStyle CssClass="grvHeaderNew" />
                                <FooterStyle CssClass="grvFooterNew" />
                                <RowStyle CssClass="grvRowsNew" />
                                <Columns>
                                    <asp:TemplateField HeaderText="Sl">
                                        <ItemTemplate>
                                            <asp:Label ID="slid" runat="server"
                                                Text='<%# Convert.ToString(Container.DataItemIndex + 1) + "." %>' ></asp:Label>
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
                                        <HeaderStyle HorizontalAlign="Center"  />
                                        <ItemStyle HorizontalAlign="left"  />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Name">

                                        <ItemTemplate>
                                            <asp:Label ID="lblname" runat="server" BackColor="Transparent"
                                                BorderStyle="None" Width="100%"
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "fullname")) %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtname" runat="server" 
                                                BorderStyle="None"  Width="100%" Style="border-top-style: none; border-right-style: none; border-left-style: none; border-bottom-style: none; border-left-color: midnightblue; border-bottom-color: midnightblue; border-top-color: midnightblue; border-right-color: midnightblue;"
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "fullname")) %>'></asp:TextBox>
                                        </EditItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="left"  />
                                    </asp:TemplateField>

                                     <asp:TemplateField HeaderText="Father's Name">

                                        <ItemTemplate>
                                            <asp:Label ID="lblfathername" runat="server" BackColor="Transparent"
                                                BorderStyle="None" Width="100%"
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "fathername")) %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtfathername" runat="server" 
                                                BorderStyle="None"  Width="100%" Style="border-top-style: none; border-right-style: none; border-left-style: none; border-bottom-style: none; border-left-color: midnightblue; border-bottom-color: midnightblue; border-top-color: midnightblue; border-right-color: midnightblue;"
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "fathername")) %>'></asp:TextBox>
                                        </EditItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="left"  />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Email">

                                        <ItemTemplate>
                                            <asp:Label ID="lblemail" runat="server" BackColor="Transparent"
                                                BorderStyle="None"  Width="100%"
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "email")) %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtemail" runat="server" Width="100%" Style="border-top-style: none; border-right-style: none; border-left-style: none; border-bottom-style: none; border-left-color: midnightblue; border-bottom-color: midnightblue; border-top-color: midnightblue; border-right-color: midnightblue;"
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "email")) %>' >
                                            </asp:TextBox>
                                        </EditItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"  />
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
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "mobile")) %>' >
                                            </asp:TextBox>
                                        </EditItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="left"/>
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
                                        <HeaderStyle HorizontalAlign="Center"  />
                                        <ItemStyle HorizontalAlign="left"  />
                                    </asp:TemplateField>

                                     <asp:TemplateField HeaderText="Region">
                                        <ItemTemplate>
                                            <asp:Label ID="lblregion" runat="server" BackColor="Transparent" Width="100%"
                                                BorderStyle="None" 
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "region")) %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtregion" runat="server" Width="100%" Style="border-top-style: none; border-right-style: none; border-left-style: none; border-bottom-style: none; border-left-color: midnightblue; border-bottom-color: midnightblue; border-top-color: midnightblue; border-right-color: midnightblue;"
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "region")) %>'>
                                            </asp:TextBox>
                                        </EditItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"  />
                                        <ItemStyle HorizontalAlign="left"  />
                                    </asp:TemplateField>

                                     <asp:TemplateField HeaderText="Gender">
                                        <ItemTemplate>
                                            <asp:Label ID="lblgender" runat="server" BackColor="Transparent" Width="100%"
                                                BorderStyle="None" 
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "gender")) %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtgender" runat="server" Width="100%" Style="border-top-style: none; border-right-style: none; border-left-style: none; border-bottom-style: none; border-left-color: midnightblue; border-bottom-color: midnightblue; border-top-color: midnightblue; border-right-color: midnightblue;"
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "gender")) %>'>
                                            </asp:TextBox>
                                        </EditItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"  />
                                        <ItemStyle HorizontalAlign="left"  />
                                    </asp:TemplateField>

                                     <asp:TemplateField HeaderText="Declaration">
                                        <ItemTemplate>
                                            <asp:Label ID="lbldeclaration" runat="server" BackColor="Transparent" Width="100%"
                                                BorderStyle="None" 
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "declaration")) %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtdeclaration" runat="server" Width="100%" Style="border-top-style: none; border-right-style: none; border-left-style: none; border-bottom-style: none; border-left-color: midnightblue; border-bottom-color: midnightblue; border-top-color: midnightblue; border-right-color: midnightblue;"
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "declaration")) %>'>
                                            </asp:TextBox>
                                        </EditItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"  />
                                        <ItemStyle HorizontalAlign="left"  />
                                    </asp:TemplateField>
                                     <asp:TemplateField HeaderText="Interest">
                                        <ItemTemplate>
                                            <asp:Label ID="lblinterest" runat="server" BackColor="Transparent" Width="100%"
                                                BorderStyle="None" 
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "interest")) %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtinterest" runat="server" Width="100%" Style="border-top-style: none; border-right-style: none; border-left-style: none; border-bottom-style: none; border-left-color: midnightblue; border-bottom-color: midnightblue; border-top-color: midnightblue; border-right-color: midnightblue;"
                                                Text='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "interest")) %>'>
                                            </asp:TextBox>
                                        </EditItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"  />
                                        <ItemStyle HorizontalAlign="left"  />
                                    </asp:TemplateField>

                                    <asp:CommandField ShowDeleteButton="True" DeleteText="&lt;i class=&quot;fa fa-trash&quot; aria-hidden=&quot;true&quot;&gt;&lt;/i&gt;" ControlStyle-Width="19px">
                                        <HeaderStyle Font-Bold="True" HorizontalAlign="Center"  />
                                        <ItemStyle Font-Bold="True" ForeColor="red" HorizontalAlign="Center" />
                                    </asp:CommandField>


                                </Columns>

                                
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
