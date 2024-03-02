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


    End Sub

    Protected Sub loadControlButton_Click(sender As Object, e As EventArgs)
        Dim x As String = HiddenLabelText.Value
        If x = "nasim" Then
            LoadAllControl()
            sortable.Visible = True
        End If
    End Sub
    Private Sub LoadAllControl()
        applicantControl = DirectCast(LoadControl("~/ApplicantControl.ascx"), ApplicantControl)

        applicantControl.ID = "ApplicantControl"
        sortable.Controls.Add(applicantControl)
    End Sub

    Private Sub RecreateControl()
        ' Check if the control was previously loaded

    End Sub

End Class