Imports CVEntity
Imports CVLibrary
Imports Newtonsoft.Json
Imports System.Data.SqlClient
Imports System.Net
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
    <WebMethod()>
    Public Shared Function GetEducationInfo(id As String) As String
        Dim _p As IProcessAccess = New ProcessAccess()
        Dim procedureName As String = "SP_UTILITY_EMPLOYEE_MGT02"
        Dim CallType = "GETJOBAPPLICATIONS"
        Dim parameters As SqlParameter() = New SqlParameter() {
        New SqlParameter("@CallType", CallType)
        }
        Dim ds = _p.GetDataSets(procedureName, parameters)
        Dim obj As New DataTableToList()
        Dim EduList As List(Of EducationalQualification) = obj.ConvertDataTableToList(Of EducationalQualification)(ds.Tables(1))
        Dim filteredEduList = (From edu In EduList
                               Where edu.jobapplication_id = id
                               Select edu).ToList()

        Dim json As String = JsonConvert.SerializeObject(filteredEduList)

        Return json
    End Function

    <WebMethod()>
    Public Shared Function InsertEmpAndEducationInfo(jsonData As String, empData As String) As String
        Return "Inserted Successfully"
    End Function

    <WebMethod()>
    Public Shared Function UpdateEmpAndEducationInfo(jsonData As String, empData As String) As String
        Dim eduDataList = JsonConvert.DeserializeObject(Of List(Of EducationalQualification))(jsonData)
        Dim emp = JsonConvert.DeserializeObject(Of Employee)(empData)
        Dim procedureName As String = "SP_UTILITY_EMPLOYEE_MGT02"

        Dim _p As IProcessAccess = New ProcessAccess()
        Dim jobCallType = "UPDATEMPLOYEEINFOUSINGAJAX"
        Dim jobparameters As SqlParameter() = New SqlParameter() {
            New SqlParameter("@CallType", jobCallType),
            New SqlParameter("@Desc1", emp.fullname),
            New SqlParameter("@Desc2", emp.fathername),
            New SqlParameter("@Desc3", emp.email),
            New SqlParameter("@Desc4", emp.mobile),
            New SqlParameter("@Desc5", emp.address),
            New SqlParameter("@Desc6", emp.gender),
            New SqlParameter("@Desc7", emp.region),
            New SqlParameter("@Desc8", emp.declaration),
            New SqlParameter("@Desc9", emp.interest),
            New SqlParameter("@Desc10", emp.photo_url),
            New SqlParameter("@Desc11", emp.id)
        }
        Dim result As Boolean = _p.ExecuteTransactionalOperation(procedureName, jobparameters)
        If result Then
            Dim jobparameters2 As SqlParameter() = New SqlParameter() {
                 New SqlParameter("@CallType", "DeleteEducational_QualificationRecord"),
                 New SqlParameter("@Desc1", emp.id)
            }
            Dim dresult = _p.ExecuteTransactionalOperation(procedureName, jobparameters2)

            Dim CallType = "InsertEducational_QualificationRecord"
            For Each row As EducationalQualification In eduDataList
                Dim eduparameters As SqlParameter() = New SqlParameter() {
                    New SqlParameter("@CallType", CallType),
                    New SqlParameter("@Desc1", row.exam),
                    New SqlParameter("@Desc2", row.board),
                    New SqlParameter("@Desc3", row.year),
                    New SqlParameter("@Desc4", row.result),
                    New SqlParameter("@Desc5", emp.id)
                }
                Dim Eresult As String = _p.GetTransactionalOperation("SP_UTILITY_EMPLOYEE_MGT", eduparameters)
                If Eresult Is Nothing Then
                    Return "Educational QualificationRecord is not updated."
                End If
            Next
        Else
            Return "Applicant Data is not updated!"
        End If
        Return "Updated Successfully"
    End Function
    <WebMethod()>
    Public Shared Function DeleteEmpAndEducationInfo(id As String, photo_url As String) As String
        Dim procedureName As String = "SP_UTILITY_EMPLOYEE_MGT02"
        Dim jobCallType = "DELETEJOBAPPLICATION"
        Dim jobparameters As SqlParameter() = New SqlParameter() {
            New SqlParameter("@CallType", jobCallType),
            New SqlParameter("@UserID", id)
        }
        Dim _p As IProcessAccess = New ProcessAccess()
        Dim result As Boolean = _p.ExecuteTransactionalOperation(procedureName, jobparameters)
        If result Then
            If IO.File.Exists(HttpContext.Current.Server.MapPath(photo_url)) Then
                IO.File.Delete(HttpContext.Current.Server.MapPath(photo_url))
            End If
        End If
        Return "Data Deleted successfully"
    End Function

End Class