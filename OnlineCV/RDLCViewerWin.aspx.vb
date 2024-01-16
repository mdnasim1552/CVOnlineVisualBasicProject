Imports FxResources.System
Imports Microsoft.Ajax.Utilities
Imports Microsoft.Reporting.WinForms

Public Class RDLCViewerWin
    Inherits System.Web.UI.Page
    Private rt As LocalReport
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            If Request.QueryString("PrintOpt") = Nothing Then
                Return
            End If
            Dim PrtOpt As String = Request.QueryString("PrintOpt").ToString()
            Dim date1 As String = System.DateTime.Today.ToString("dd-MMM-yyyy")
            Dim rptTitle As String = If(Me.Request.QueryString("rptTitle"), "Export_Data_" + date1)
            Page.Title = rptTitle
            Select Case PrtOpt
                Case "PDF"
                    Me.RptRDLCPDF(rptTitle)
                    Exit Select
                Case "BANGLAPDF"
                    Me.RptRDLCBanglaPDF(rptTitle)
                    Exit Select
                Case "WORD"
                    Me.RptMSWord()
                    Exit Select
                Case "EXCEL"
                    Me.RptMSExcel(rptTitle)
                    Exit Select
                Case "GRIDTOEXCEL"
                    Me.ExportGridToExcel()
                    Exit Select
                Case "GRIDTOEXCELNEW"
                    Me.ExportGridToExcel2()
                    Exit Select
            End Select
        End If
    End Sub

    Protected Sub LoadReportSceleton()
        rt = New LocalReport()
        rt = DirectCast(Session("Report1"), LocalReport)
    End Sub
    Private Sub ExportGridToExcel2()
        Throw New NotImplementedException()
    End Sub

    Private Sub ExportGridToExcel()
        Throw New NotImplementedException()
    End Sub

    Private Sub RptMSExcel(rptTitle As String)
        Throw New NotImplementedException()
    End Sub

    Private Sub RptMSWord()
        Throw New NotImplementedException()
    End Sub

    Private Sub RptRDLCPDF(rptTitle As String)
        LoadReportSceleton()
        Dim reportType As String = "PDF"
        Dim deviceInfo As String = "<DeviceInfo><EmbedFonts>None</EmbedFonts>" &
                               "  <OutputFormat>" & reportType & "</OutputFormat>" &
                               "</DeviceInfo>"
        Dim warnings As Warning()
        Dim streamids As String()
        Dim mimeType As String
        Dim encoding As String
        Dim filenameExtension As String = String.Empty

        Dim bytes As Byte() = rt.Render(reportType, deviceInfo, mimeType, encoding, filenameExtension, streamids, warnings)
        Response.Clear()
        Response.Buffer = True
        Response.ContentType = "Application/pdf"
        Response.AddHeader("content-disposition", "filename=" & rptTitle & "." & filenameExtension)

        Response.BinaryWrite(bytes)
    End Sub

    Private Sub RptRDLCBanglaPDF(rptTitle As String)
        LoadReportSceleton()
        Dim reportType As String = "PDF"
        Dim deviceInfo As String = "<DeviceInfo>" &
                               "  <OutputFormat>" & reportType & "</OutputFormat>" &
                               "</DeviceInfo>"
        Dim warnings As Warning()
        Dim streamids As String()
        Dim mimeType As String
        Dim encoding As String
        Dim filenameExtension As String = String.Empty

        Dim bytes As Byte() = rt.Render(reportType, deviceInfo, mimeType, encoding, filenameExtension, streamids, warnings)
        Response.Clear()
        Response.Buffer = True
        Response.ContentType = "Application/pdf"
        Response.AddHeader("content-disposition", "filename=" & rptTitle & "." & filenameExtension)

        Response.BinaryWrite(bytes)
    End Sub
End Class