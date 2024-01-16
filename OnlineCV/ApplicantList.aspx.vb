Imports System.Data.SqlClient

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
    Private Sub SaveValue()
        Dim dt As DataTable = DirectCast(ViewState("jobapplication"), DataTable)
        For Each gvrow As GridViewRow In gvapplicant.Rows
            Dim name As String = TryCast(gvrow.FindControl("lblname"), Label).Text.Trim()
            Dim email As String = TryCast(gvrow.FindControl("lblemail"), Label).Text.Trim()
            Dim mobile As String = TryCast(gvrow.FindControl("lblmobile"), Label).Text.Trim()
            Dim address As String = TryCast(gvrow.FindControl("lbladdress"), Label).Text.Trim()
            Dim rowIndex As Integer = Me.gvapplicant.PageIndex * Me.gvapplicant.PageSize + gvrow.RowIndex
            dt.Rows(rowIndex)("fullname") = name
            dt.Rows(rowIndex)("email") = email
            dt.Rows(rowIndex)("mobile") = mobile
            dt.Rows(rowIndex)("address") = address
        Next
        ViewState("jobapplication") = dt
    End Sub
    Private Sub lbtnUpdate_Click(sender As Object, e As EventArgs)
        Me.SaveValue()

        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "CallMyFunction", "showContent('Updated successfully');", True)
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

    Protected Sub gvapplicant_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)

    End Sub

    Protected Sub gvapplicant_PageIndexChanging(sender As Object, e As GridViewPageEventArgs)
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

    Protected Sub gvapplicant_RowUpdating(sender As Object, e As GridViewUpdateEventArgs)
        Dim dt As DataTable = DirectCast(ViewState("jobapplication"), DataTable)
        Dim name As String = (TryCast(Me.gvapplicant.Rows(e.RowIndex).FindControl("txtname"), TextBox)).Text.Trim()
        Dim email As String = (TryCast(Me.gvapplicant.Rows(e.RowIndex).FindControl("txtemail"), TextBox)).Text.Trim()
        Dim mobile As String = (TryCast(Me.gvapplicant.Rows(e.RowIndex).FindControl("txtMobile"), TextBox)).Text.Trim()
        Dim address As String = (TryCast(Me.gvapplicant.Rows(e.RowIndex).FindControl("txtaddress"), TextBox)).Text.Trim()
        Dim rowIndex As Integer = Me.gvapplicant.PageIndex * Me.gvapplicant.PageSize + e.RowIndex
        dt.Rows(rowIndex)("fullname") = name
        dt.Rows(rowIndex)("email") = email
        dt.Rows(rowIndex)("mobile") = mobile
        dt.Rows(rowIndex)("address") = address
        ViewState("jobapplication") = dt
        Me.gvapplicant.EditIndex = -1 ' No row Is In edit mode
        Me.gvapplicant.SelectedIndex = -1 ' No row Is selected
        Me.Data_Bind()
    End Sub

    Protected Sub ddlpagesize_SelectedIndexChanged(sender As Object, e As EventArgs)
        Me.gvapplicant.EditIndex = -1 ' No row Is In edit mode
        Me.gvapplicant.SelectedIndex = -1 ' No row Is selected
        Me.Data_Bind()
    End Sub
End Class