Imports System.IO
Imports System.Web
Imports System.Web.Services

Public Class ApplicantControlHandler
    Implements System.Web.IHttpHandler

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        'context.Response.ContentType = "text/plain"
        'context.Response.Write("Hello World!")
        'Dim controlName As String = context.Request.QueryString("controlName")
        Dim controlPath As String = context.Server.MapPath("~/ApplicantControl.ascx")

        Dim controlHtml As String = LoadControlHtml(controlPath)
        context.Response.ContentType = "text/html"
        context.Response.Write(controlHtml)

    End Sub
    Private Function LoadControlHtml(controlPath As String) As String
        Dim controlContent As String = String.Empty
        If File.Exists(controlPath) Then
            controlContent = File.ReadAllText(controlPath)
        End If
        Return controlContent
    End Function
    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class