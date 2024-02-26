Imports CVEntity
Imports CVLibrary
Imports Newtonsoft.Json
Imports System.Data.SqlClient
Imports System.Web.Services

Public Class ApplicantAjax
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub
    <WebMethod()>
    Public Shared Function GetApplicant() As String
        Dim _p As IProcessAccess = New ProcessAccess()
        Dim procedureName As String = "SP_UTILITY_EMPLOYEE_MGT02"
        Dim CallType = "GETJOBAPPLICATIONS"
        Dim parameters As SqlParameter() = New SqlParameter() {
        New SqlParameter("@CallType", CallType)
        }
        Dim ds = _p.GetDataSets(procedureName, parameters)
        Dim obj As New DataTableToList()
        Dim jsonData As List(Of Employee) = obj.ConvertDataTableToList(Of Employee)(ds.Tables(0))
        Dim json As String = JsonConvert.SerializeObject(jsonData)

        Return json
    End Function
End Class