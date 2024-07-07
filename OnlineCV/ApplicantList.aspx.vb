Imports System.Data.SqlClient
Imports System.Drawing
Imports System.IO
Imports System.Net.WebRequestMethods
Imports System.Reflection
Imports CVEntity
Imports Microsoft.Ajax.Utilities
Imports Newtonsoft.Json
Imports CVLibrary
Imports WebGrease.Css
Imports System.Runtime.Remoting.Metadata.W3cXsd2001
Imports System.Windows.Forms.VisualStyles.VisualStyleElement.StartPanel
Imports System.Security.Policy
Imports Microsoft.Reporting.WinForms
Imports RDLCReport
Public Class About
    Inherits Page
    Private _processAccess As IProcessAccess = New ProcessAccess()
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Me.GetApplicantList()
        End If
    End Sub

    Protected Sub Page_PreInit(sender As Object, e As EventArgs)
        Dim lnkbtnSave As LinkButton = DirectCast(Me.Master.FindControl("lnkbtnSave"), LinkButton)
        lnkbtnSave.Visible = True
        AddHandler lnkbtnSave.Click, AddressOf lbtnUpdate_Click
        lnkbtnSave.Text = "Update"
    End Sub
    Protected Overrides Sub OnPreRender(e As EventArgs)
        Response.Write("sdsadasdasdad")
    End Sub

    Private Sub SaveValue()
        Dim dt As DataTable = DirectCast(ViewState("jobapplication"), DataTable)
        For Each gvrow As GridViewRow In gvapplicant.Rows
            Dim name As String = TryCast(gvrow.FindControl("lblname"), Label).Text.Trim()
            Dim email As String = TryCast(gvrow.FindControl("lblemail"), Label).Text.Trim()
            Dim mobile As String = TryCast(gvrow.FindControl("lblmobile"), Label).Text.Trim()
            Dim address As String = TryCast(gvrow.FindControl("lbladdress"), Label).Text.Trim()
            Dim region As String = TryCast(gvrow.FindControl("lblregion"), Label).Text.Trim()
            Dim gender As String = TryCast(gvrow.FindControl("lblgender"), Label).Text.Trim()
            Dim declaration As String = TryCast(gvrow.FindControl("lbldeclaration"), Label).Text.Trim()
            Dim interest As String = TryCast(gvrow.FindControl("lblinterest"), Label).Text.Trim()
            Dim photoUrl As String = TryCast(gvrow.FindControl("lblHiddenphotoo_urlID"), Label).Text.Trim()
            Dim rowIndex As Integer = Me.gvapplicant.PageIndex * Me.gvapplicant.PageSize + gvrow.RowIndex
            dt.Rows(rowIndex)("fullname") = name
            dt.Rows(rowIndex)("email") = email
            dt.Rows(rowIndex)("mobile") = mobile
            dt.Rows(rowIndex)("address") = address
            dt.Rows(rowIndex)("interest") = interest
            dt.Rows(rowIndex)("gender") = gender
            dt.Rows(rowIndex)("region") = region
            dt.Rows(rowIndex)("declaration") = declaration
            dt.Rows(rowIndex)("photo_url") = photoUrl
        Next
        ViewState("jobapplication") = dt
    End Sub
    Private Async Sub lbtnUpdate_Click(sender As Object, e As EventArgs)
        Me.SaveValue()
        Dim dt As DataTable = DirectCast(ViewState("jobapplication"), DataTable)
        Dim procedureName As String = "SP_UTILITY_EMPLOYEE_MGT02"
        Dim CallType = "UPDATEMPLOYEEINFO"

        Dim tvpParam As New SqlParameter("@jobapplicationTypes", dt)
        tvpParam.SqlDbType = SqlDbType.Structured
        tvpParam.TypeName = "dbo.jobapplicationType"

        Dim parameters As SqlParameter() = New SqlParameter() {
        New SqlParameter("@CallType", CallType),
        tvpParam
        }
        Dim result As Boolean = Await _processAccess.ExecuteTransactionalOperationAsync(procedureName, parameters)
        If result = True Then
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "CallMyFunction", "showContent('Updated successfully');", True)
        Else
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "CallMyFunction", "showContentFail('Updated Fail');", True)
        End If

        Me.GetApplicantList()
    End Sub

    Private Sub Data_Bind()
        Dim dt As DataTable = DirectCast(ViewState("jobapplication"), DataTable)
        Me.gvapplicant.PageSize = Convert.ToInt32(Me.ddlpagesize.SelectedValue.ToString())
        Me.gvapplicant.DataSource = dt
        Me.gvapplicant.DataBind()
    End Sub
    Private Async Sub GetApplicantList()
        Dim procedureName As String = "SP_UTILITY_EMPLOYEE_MGT02"
        Dim CallType = "GETJOBAPPLICATIONS"
        Dim parameters As SqlParameter() = New SqlParameter() {
        New SqlParameter("@CallType", CallType)
        }
        Dim ds = Await _processAccess.GetDataSetsAsync(procedureName, parameters)

        ViewState("jobapplication") = ds.Tables(0)
        ViewState("educational_qualification") = ds.Tables(1)
        Me.Data_Bind()
    End Sub
    Protected Sub gvapplicant_RowEditing(sender As Object, e As GridViewEditEventArgs)
        Me.gvapplicant.EditIndex = e.NewEditIndex
        Me.gvapplicant.SelectedIndex = -1
        Me.Data_Bind()
    End Sub

    Protected Sub gvapplicant_PageIndexChanging(sender As Object, e As GridViewPageEventArgs)
        Me.SaveValue()
        Me.gvapplicant.EditIndex = -1 ' No row Is In edit mode
        Me.gvapplicant.SelectedIndex = -1 ' No row Is selected
        Me.gvapplicant.PageIndex = e.NewPageIndex
        Me.Data_Bind()
    End Sub

    Protected Sub gvapplicant_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs)
        Me.gvapplicant.EditIndex = -1 ' No row Is In edit mode
        Me.gvapplicant.SelectedIndex = -1 ' No row Is selected
        Me.Data_Bind()
    End Sub
    Private Function UploadUserImage() As String
        Dim uniqueFileName As String = String.Empty
        If (ImageUpload.HasFile) Then
            Dim allowedImageExtensions As String() = New String() {".jpg", ".jpeg", ".png", ".gif"}
            Dim imageExtension = Path.GetExtension(ImageUpload.FileName).ToLower()

            If Not allowedImageExtensions.Contains(imageExtension) Then
                ErrorMessageLabel.Text = "Invalid image type. Please upload a JPG, PNG, or GIF file."
                ErrorMessageLabel.Visible = True
                Return Nothing
            End If
            uniqueFileName = Guid.NewGuid().ToString() + imageExtension
            ImageUpload.SaveAs(Server.MapPath("~/UserImage/" + uniqueFileName))
            uniqueFileName = "~/UserImage/" + uniqueFileName 'this an url to return and save into DataBase
        End If
        Return uniqueFileName
    End Function
    'Private Function UploadUserImage(files As FileUpload, ErrorMessageLabel As Label) As String
    '    Dim uniqueFileName As String = String.Empty
    '    If (files.HasFile) Then
    '        Dim allowedImageExtensions As String() = New String() {".jpg", ".jpeg", ".png", ".gif"}
    '        Dim imageExtension = Path.GetExtension(files.FileName).ToLower()
    '        If Not allowedImageExtensions.Contains(imageExtension) Then
    '            ErrorMessageLabel.Text = "Invalid image type. Please upload a JPG, PNG, or GIF file."
    '            ErrorMessageLabel.Visible = True
    '            Return ""
    '        End If
    '        uniqueFileName = Guid.NewGuid().ToString() + imageExtension
    '        files.SaveAs(Server.MapPath("~/UserImage/" + uniqueFileName))
    '        uniqueFileName = "~/UserImage/" + uniqueFileName 'this an url to return and save into DataBase
    '    End If
    '    Return uniqueFileName
    'End Function
    Private Sub DeleteImage(imagepath As String)
        If IO.File.Exists(Server.MapPath(imagepath)) Then
            IO.File.Delete(Server.MapPath(imagepath))
        End If
    End Sub
    Protected Async Sub gvapplicant_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)
        Dim dt As DataTable = DirectCast(ViewState("jobapplication"), DataTable)
        Dim applicantid As String = DirectCast(Me.gvapplicant.Rows(e.RowIndex).FindControl("lblapplicationid"), Label).Text.Trim()
        Dim Hphoto_urlID As String = TryCast(gvapplicant.Rows(e.RowIndex).FindControl("lblHiddenphotoo_urlID"), Label).Text.Trim()

        Dim procedureName As String = "SP_UTILITY_EMPLOYEE_MGT02"

        Dim jobCallType = "DELETEJOBAPPLICATION"
        Dim jobparameters As SqlParameter() = New SqlParameter() {
            New SqlParameter("@CallType", jobCallType),
            New SqlParameter("@UserID", applicantid)
        }
        Dim result As Boolean = Await _processAccess.ExecuteTransactionalOperationAsync(procedureName, jobparameters)
        If result Then
            DeleteImage(Hphoto_urlID)
            dt.Rows(Me.gvapplicant.PageIndex * Me.gvapplicant.PageSize + e.RowIndex).Delete()
            dt.AcceptChanges()
        End If

        Me.gvapplicant.EditIndex = -1 ' No row Is In edit mode
        Me.gvapplicant.SelectedIndex = -1 ' No row Is selected
        ViewState("jobapplication") = dt
        Me.Data_Bind()
    End Sub
    Protected Sub gvapplicant_RowUpdating(sender As Object, e As GridViewUpdateEventArgs)
        Dim dt As DataTable = DirectCast(ViewState("jobapplication"), DataTable)
        Dim name As String = (TryCast(Me.gvapplicant.Rows(e.RowIndex).FindControl("txtname"), TextBox)).Text.Trim()
        Dim fatherName As String = TryCast(Me.gvapplicant.Rows(e.RowIndex).FindControl("txtfathername"), TextBox).Text.Trim()
        Dim email As String = (TryCast(Me.gvapplicant.Rows(e.RowIndex).FindControl("txtemail"), TextBox)).Text.Trim()
        Dim mobile As String = (TryCast(Me.gvapplicant.Rows(e.RowIndex).FindControl("txtMobile"), TextBox)).Text.Trim()
        Dim address As String = (TryCast(Me.gvapplicant.Rows(e.RowIndex).FindControl("txtaddress"), TextBox)).Text.Trim()
        Dim gender As String = (TryCast(Me.gvapplicant.Rows(e.RowIndex).FindControl("ddlGender"), DropDownList)).SelectedValue
        Dim region As String = (TryCast(Me.gvapplicant.Rows(e.RowIndex).FindControl("ddlRegion"), DropDownList)).SelectedValue

        Dim ddlDeclare As String = (TryCast(Me.gvapplicant.Rows(e.RowIndex).FindControl("ddlDeclare"), DropDownList)).SelectedValue

        Dim interestLbl As String = TryCast(Me.gvapplicant.Rows(e.RowIndex).FindControl("lblinteresthidden"), Label).Text.Trim()
        Dim interest As ListBox = TryCast(Me.gvapplicant.Rows(e.RowIndex).FindControl("ListBoxID"), ListBox)
        Dim interestList As List(Of String) = New List(Of String)()
        For Each item As ListItem In interest.Items
            If item.Selected Then
                interestList.Add(If(item.Value = "1", "Football", "Cricket"))
            End If
        Next
        Dim interestV As String = If(interestList.Count = 0, interestLbl, String.Join(", ", interestList))


        'Dim fileUpload As FileUpload = TryCast(gvapplicant.Rows(e.RowIndex).FindControl("FileUpload1"), FileUpload)
        Dim ErrorMessageLabel As Label = TryCast(gvapplicant.Rows(e.RowIndex).FindControl("ErrorMessageLabel"), Label)
        Dim Hphoto_urlID As String = TryCast(gvapplicant.Rows(e.RowIndex).FindControl("Hiddenphoto_urlID"), Label).Text.Trim()
        'Dim photoUrl As String = Me.UploadUserImage(fileUpload, ErrorMessageLabel)
        Dim photoUrl As String = Me.HiddenField1.Value

        Dim rowIndex As Integer = Me.gvapplicant.PageIndex * Me.gvapplicant.PageSize + e.RowIndex
        dt.Rows(rowIndex)("fullname") = name
        dt.Rows(rowIndex)("fathername") = fatherName
        dt.Rows(rowIndex)("email") = email
        dt.Rows(rowIndex)("mobile") = mobile
        dt.Rows(rowIndex)("address") = address
        dt.Rows(rowIndex)("interest") = interestV
        dt.Rows(rowIndex)("gender") = gender
        dt.Rows(rowIndex)("region") = region
        dt.Rows(rowIndex)("photo_url") = If(photoUrl = "", Hphoto_urlID, photoUrl)
        dt.Rows(rowIndex)("declaration") = If(ddlDeclare = "1", "I have declared all the information are correct.", "N/A")
        ViewState("jobapplication") = dt
        Me.gvapplicant.EditIndex = -1 ' No row Is In edit mode
        Me.gvapplicant.SelectedIndex = -1 ' No row Is selected
        Me.HiddenField1.Value = ""
        Me.Data_Bind()
    End Sub

    Protected Sub ddlpagesize_SelectedIndexChanged(sender As Object, e As EventArgs)
        Me.gvapplicant.EditIndex = -1 ' No row Is In edit mode
        Me.gvapplicant.SelectedIndex = -1 ' No row Is selected
        Me.Data_Bind()
    End Sub

    Protected Sub btnsave_Click(sender As Object, e As EventArgs)
        Dim myTableData = New List(Of EducationalQualification)
        Dim jsonData = MyData.Value
        myTableData = JsonConvert.DeserializeObject(Of List(Of EducationalQualification))(jsonData)
        Dim photoUrl As String = Me.UploadUserImage()
        Dim procedureName As String = "SP_UTILITY_EMPLOYEE_MGT"

        Dim jobCallType = "InsertjobapplicationRecord"
        Dim jobparameters As SqlParameter() = New SqlParameter() {
            New SqlParameter("@CallType", jobCallType),
            New SqlParameter("@Desc1", fullName.Text),
            New SqlParameter("@Desc2", txtfname.Text),
            New SqlParameter("@Desc3", txtemail.Text),
            New SqlParameter("@Desc4", txtcell.Text),
            New SqlParameter("@Desc5", txtaddress.Text),
            New SqlParameter("@Desc6", txtgender.SelectedValue),
            New SqlParameter("@Desc7", txtregion.SelectedValue),
            New SqlParameter("@Desc8", If(declareCheckbox.Checked, "I have declared all the information are correct.", "N/A")),
            New SqlParameter("@Desc9", If(FootballCheckbox.Checked, "Football,", "") & If(CricketCheckbox.Checked, "Cricket", "")),
            New SqlParameter("@Desc10", photoUrl)
        }
        Dim primayKey As String = _processAccess.GetTransactionalOperation(procedureName, jobparameters)

        Dim CallType = "InsertEducational_QualificationRecord"
        For Each row As EducationalQualification In myTableData
            Dim eduparameters As SqlParameter() = New SqlParameter() {
                New SqlParameter("@CallType", CallType),
                New SqlParameter("@Desc1", row.exam),
                New SqlParameter("@Desc2", row.board),
                New SqlParameter("@Desc3", row.year),
                New SqlParameter("@Desc4", row.result),
                New SqlParameter("@Desc5", primayKey)
            }
            Dim result As String = _processAccess.GetTransactionalOperation(procedureName, eduparameters)
            If result Is Nothing Then
                Return
            End If
        Next
        fullName.Text = ""
        txtfname.Text = ""
        txtemail.Text = ""
        txtcell.Text = ""
        txtaddress.Text = ""
        txtgender.ClearSelection()
        declareCheckbox.Checked = False
        FootballCheckbox.Checked = False
        CricketCheckbox.Checked = False
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alert", "closeUserModal();", True)
        Me.GetApplicantList()
    End Sub

    Protected Sub printid_Click(sender As Object, e As EventArgs)

        Dim RowIndex As Integer = DirectCast(DirectCast(sender, LinkButton).NamingContainer, GridViewRow).RowIndex
        Dim applicantid As String = TryCast(Me.gvapplicant.Rows(RowIndex).FindControl("lblapplicationid"), Label).Text.Trim()
        Dim jobDt As DataTable = DirectCast(ViewState("jobapplication"), DataTable)
        Dim dv As DataView = jobDt.DefaultView
        dv.RowFilter = "id='" + applicantid + "'"
        jobDt = dv.ToTable()

        Dim eduDt As DataTable = DirectCast(ViewState("educational_qualification"), DataTable)
        Dim dv2 As DataView = eduDt.AsDataView
        dv2.RowFilter = "jobapplication_id='" + applicantid + "'"
        eduDt = dv2.ToTable
        Dim obj As DataTableToList = New DataTableToList()
        Dim jobList As List(Of Employee) = obj.ConvertDataTableToList(Of Employee)(jobDt)
        Dim eduDtList As List(Of EducationalQualification) = obj.ConvertDataTableToList(Of EducationalQualification)(eduDt)
        Dim imagepath As String = New Uri(Server.MapPath(jobDt.Rows(0)("photo_url"))).AbsoluteUri 'jobDt.Rows(0)("photo_url")'new Uri(Server.MapPath(@"~\Image\LOGO" + comcod + ".jpg")).AbsoluteUri;
        Dim robj As RPTPathClass = New RPTPathClass()
        Dim Rpt1 As New LocalReport()
        Rpt1.LoadReportDefinition(robj.GetReportFilePath("EmployeeCV"))
        Rpt1 = robj.SetRDLCReportDatasetss(Rpt1, New Dictionary(Of String, Object) From {{"DataSet1", jobList}, {"DataSet2", eduDtList}})
        Rpt1.EnableExternalImages = True

        Rpt1.SetParameters(New ReportParameter("title", "CURRICULUM VITAE"))
        Rpt1.SetParameters(New ReportParameter("imagepath", imagepath))
        Session("Report1") = Rpt1
        'String Url = "RDLC_report_demo_2.aspx?ID=" + ID;
        Dim url As String = "RDLCViewerWin.aspx?PrintOpt=PDF"
        Dim Script As String = "window.open('" + url + "', '_blank');"
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "OpenWindow", Script, True)


    End Sub

End Class