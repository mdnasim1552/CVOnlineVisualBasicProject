Public Class UpdateControl
    Inherits System.Web.UI.UserControl
    Public Event RefreshApplicantControl As EventHandler
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then

        End If
    End Sub

    Protected Sub lnkbtnRefresh_Click(sender As Object, e As EventArgs)
        'Dim applicantControl As ApplicantControl = DirectCast(Me.Parent.FindControl("ApplicantControl"), ApplicantControl)
        'If applicantControl IsNot Nothing Then
        '    applicantControl.GetApplicantList()
        '    applicantControl.Data_Bind()
        'End If
        RaiseEvent RefreshApplicantControl(Me, EventArgs.Empty)
    End Sub
End Class