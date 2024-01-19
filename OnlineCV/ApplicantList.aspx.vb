﻿Imports System.Data.SqlClient
Imports System.Drawing
Imports System.IO
Imports System.Net.WebRequestMethods
Imports Microsoft.Ajax.Utilities

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
            Dim region As String = TryCast(gvrow.FindControl("lblregion"), Label).Text.Trim()
            Dim gender As String = TryCast(gvrow.FindControl("lblgender"), Label).Text.Trim()
            Dim declaration As String = TryCast(gvrow.FindControl("lbldeclaration"), Label).Text.Trim()
            Dim interest As String = TryCast(gvrow.FindControl("lblinterest"), Label).Text.Trim()
            Dim photoUrl As String = TryCast(gvrow.FindControl("lblHiddenphoto_urlID"), Label).Text.Trim()
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
    Private Function UploadUserImage(files As FileUpload, ErrorMessageLabel As Label) As String
        Dim uniqueFileName As String = String.Empty
        If (files.HasFile) Then
            Dim allowedImageExtensions As String() = New String() {".jpg", ".jpeg", ".png", ".gif"}
            Dim imageExtension = Path.GetExtension(files.FileName).ToLower()
            If Not allowedImageExtensions.Contains(imageExtension) Then
                ErrorMessageLabel.Text = "Invalid image type. Please upload a JPG, PNG, or GIF file."
                ErrorMessageLabel.Visible = True
                Return ""
            End If
            uniqueFileName = Guid.NewGuid().ToString() + imageExtension
            files.SaveAs(Server.MapPath("~/UserImage/" + uniqueFileName))
            uniqueFileName = "~/UserImage/" + uniqueFileName 'this an url to return and save into DataBase
        End If
        Return uniqueFileName
    End Function
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


        Dim fileUpload As FileUpload = TryCast(gvapplicant.Rows(e.RowIndex).FindControl("FileUpload1"), FileUpload)
        Dim ErrorMessageLabel As Label = TryCast(gvapplicant.Rows(e.RowIndex).FindControl("ErrorMessageLabel"), Label)
        Dim Hphoto_urlID As Label = TryCast(gvapplicant.Rows(e.RowIndex).FindControl("Hiddenphoto_urlID"), Label)
        Dim photoUrl As String = Me.UploadUserImage(fileUpload, ErrorMessageLabel)

        Dim rowIndex As Integer = Me.gvapplicant.PageIndex * Me.gvapplicant.PageSize + e.RowIndex
        dt.Rows(rowIndex)("fullname") = name
        dt.Rows(rowIndex)("fathername") = fatherName
        dt.Rows(rowIndex)("email") = email
        dt.Rows(rowIndex)("mobile") = mobile
        dt.Rows(rowIndex)("address") = address
        dt.Rows(rowIndex)("interest") = interestV
        dt.Rows(rowIndex)("gender") = gender
        dt.Rows(rowIndex)("region") = region
        dt.Rows(rowIndex)("photo_url") = If(photoUrl = "", Hphoto_urlID.Text(), photoUrl)
        dt.Rows(rowIndex)("declaration") = If(ddlDeclare = "1", "I have declared all the information are correct.", "N/A")
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