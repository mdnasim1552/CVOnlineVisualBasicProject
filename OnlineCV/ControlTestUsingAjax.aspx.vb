Imports System.Web.Services

Public Class ControlTestUsingAjax
    Inherits System.Web.UI.Page
    Dim applicantControl
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then

            ' Load dynamic control only on initial page load
        End If
        'applicantControl = DirectCast(LoadControl("~/ApplicantControl.ascx"), ApplicantControl)

        'applicantControl.ID = "ApplicantControl"
        'sortable.Controls.Add(applicantControl)
        If (ViewState("Control") = "nasim") Then
            LoadAllControl()
        End If
    End Sub

    Protected Sub loadControlButton_Click(sender As Object, e As EventArgs)
        Dim x As String = HiddenLabelText.Value
        If x = "nasim" Then
            LoadAllControl()
            sortable.Visible = True
            ViewState("Control") = x
        End If
    End Sub
    Private Sub LoadAllControl()
        sortable.Controls.Remove(applicantControl)
        applicantControl = DirectCast(LoadControl("~/ApplicantControl.ascx"), ApplicantControl)

        applicantControl.ID = "ApplicantControl"
        sortable.Controls.Add(applicantControl)
    End Sub

    Protected Sub Page_PreInit(sender As Object, e As EventArgs) Handles Me.Init
        Dim lnkbtnSave As LinkButton = DirectCast(Me.Master.FindControl("lnkbtnSave"), LinkButton)
        lnkbtnSave.Visible = True
        AddHandler lnkbtnSave.Click, AddressOf lbtnUpdate_Click
        lnkbtnSave.Text = "Update"
    End Sub

    Private Sub lbtnUpdate_Click(sender As Object, e As EventArgs)
        'Dim applicantControl As ApplicantControl = DirectCast(LoadControl("~/ApplicantControl.ascx"), ApplicantControl)
        LoadAllControl()
        applicantControl.Update_Data()
    End Sub

End Class