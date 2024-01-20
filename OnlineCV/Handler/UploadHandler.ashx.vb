Imports System.Data.SqlClient
Imports System.IO
Imports System.Web
Imports System.Web.Services
Imports Microsoft.SqlServer

Public Class UploadHandler
    Implements System.Web.IHttpHandler

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        'context.Response.ContentType = "text/plain"
        'context.Response.Write("Hello World!")
        Try
            Dim _processAccess As IProcessAccess = New ProcessAccess()
            Dim uniqueFileName As String = String.Empty
            Dim empId As String = context.Request.Form("empId")
            Dim imagepath As String = context.Request.Form("imagepath")
            If IO.File.Exists(context.Server.MapPath(imagepath)) Then
                IO.File.Delete(context.Server.MapPath(imagepath))
            End If
            If (context.Request.Files.Count > 0) Then
                Dim allowedImageExtensions As String() = New String() {".jpg", ".jpeg", ".png", ".gif"}
                Dim files As HttpFileCollection = context.Request.Files
                For i As Integer = 0 To files.Count - 1
                    Dim file As HttpPostedFile = files(i)
                    Dim imageExtension = Path.GetExtension(file.FileName).ToLower()
                    If Not allowedImageExtensions.Contains(imageExtension) Then
                        context.Response.Write("Error")
                        Return
                    Else
                        uniqueFileName = "~/UserImage/" + Guid.NewGuid().ToString() + System.IO.Path.GetFileName(file.FileName) 'this an url to return and save into DataBase
                        file.SaveAs(context.Server.MapPath(uniqueFileName))

                        Dim procedureName As String = "SP_UTILITY_EMPLOYEE_MGT02"

                        Dim jobCallType = "UPDATEEMPLOYEEIMAGE"
                        Dim jobparameters As SqlParameter() = New SqlParameter() {
                            New SqlParameter("@CallType", jobCallType),
                            New SqlParameter("@Desc10", uniqueFileName),
                            New SqlParameter("@UserID", empId)
                        }
                        Dim result As Boolean = _processAccess.ExecuteTransactionalOperation(procedureName, jobparameters)
                    End If
                Next
            End If
            context.Response.Write(uniqueFileName)
        Catch ex As Exception
            context.Response.Write("Error: " + ex.Message)
        End Try

    End Sub

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property
End Class