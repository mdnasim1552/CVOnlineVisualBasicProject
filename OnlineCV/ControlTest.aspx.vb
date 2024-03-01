Imports System.Web.Services

Public Class ControlTest
    Inherits System.Web.UI.Page
    Dim applicantControl
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then

        End If
        applicantControl = DirectCast(LoadControl("~/ApplicantControl.ascx"), ApplicantControl)
        applicantControl.ID = "ApplicantControl"

        ' Find the ContentPlaceHolder in the Master Page
        Dim contentPlaceHolder As ContentPlaceHolder = DirectCast(Master.FindControl("MainContent"), ContentPlaceHolder)

        If contentPlaceHolder IsNot Nothing Then
            'contentPlaceHolder.Controls.Add(applicantControl)
            allcontrols.Controls.Add(applicantControl)
        End If

        Dim lnkbtnSave As LinkButton = DirectCast(Me.Master.FindControl("lnkbtnSave"), LinkButton)
        lnkbtnSave.Visible = True
        AddHandler lnkbtnSave.Click, AddressOf lbtnUpdate_Click
        lnkbtnSave.Text = "Update"
    End Sub
    Protected Sub Page_PreInit(sender As Object, e As EventArgs) Handles Me.Init
        Dim lnkbtnSave As LinkButton = DirectCast(Me.Master.FindControl("lnkbtnSave"), LinkButton)
        lnkbtnSave.Visible = True
        AddHandler lnkbtnSave.Click, AddressOf lbtnUpdate_Click
        lnkbtnSave.Text = "Update"
    End Sub

    Private Sub lbtnUpdate_Click(sender As Object, e As EventArgs)
        'Dim applicantControl As ApplicantControl = DirectCast(LoadControl("~/ApplicantControl.ascx"), ApplicantControl)
        applicantControl.Update_Data()
    End Sub

End Class