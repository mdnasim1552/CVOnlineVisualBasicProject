Imports System.Data.SqlClient
Imports System.IO
Imports System.Security.Cryptography
Imports CVEntity
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq

Public Class _Default
    Inherits Page
    Private _processAccess As IProcessAccess = New ProcessAccess()
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then

        End If
    End Sub
    Private Function UploadUserImage() As String
        Dim uniqueFileName As String = String.Empty
        If (ImageUpload.HasFile) Then
            Dim allowedImageExtensions As String() = New String() {".jpg", ".jpeg", ".png", ".gif"}
            Dim imageExtension = Path.GetExtension(ImageUpload.FileName)

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
    Protected Async Sub btnsave_Click(sender As Object, e As EventArgs)
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
        Dim primayKey As String = Await _processAccess.GetTransactionalOperationAsync(procedureName, jobparameters)

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
            Dim result As String = Await _processAccess.GetTransactionalOperationAsync(procedureName, eduparameters)
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


        'fullname,fathername,email,mobile,address,gender,region,declaration,interest,photo_url
        'New SqlParameter("@Desc9", String.Concat(If(FootballCheckbox.Checked, "Football,", ""), If(CricketCheckbox.Checked, "Cricket", ""))),
        'var myTableData = New List < MyTableDataClass > ();
        '    var jsonData = MyData.Value;
        '    myTableData = JsonConvert.DeserializeObject < List < MyTableDataClass >> (jsonData);

        '    String photoUrl = UploadUserImage();

        'Dim procedureName As String = "SP_UTILITY_EMPLOYEE_MGT"
        'Dim CallType = "GETJOBAPPLICATIONS"
        'Dim parameters As SqlParameter() = New SqlParameter() {
        'New SqlParameter("@CallType", CallType)
        '}
        'Dim empList As List(Of Employee) = Await _processAccess.GetAllAsync(Of Employee)(procedureName, parameters)

        ''Dim empList As List(Of Employee) = Await _processAccess.GetListAsync(Of Employee)(procedureName, parameters)

        'Dim parameters2 As SqlParameter() = New SqlParameter() {
        'New SqlParameter("@CallType", CallType)
        '}
        'Dim ds = Await _processAccess.GetDataSetsAsync(procedureName, parameters2)
    End Sub
End Class