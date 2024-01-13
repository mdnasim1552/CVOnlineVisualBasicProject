Imports System.IO
Imports System.Reflection


Public Class RPTPathClass
    Public Shared Function GetReportFilePath(path As String) As Stream
        Dim assamblyPath = Assembly.GetExecutingAssembly().CodeBase
        Dim assembly1 As Assembly = Assembly.LoadFrom(assamblyPath)
        Dim stream1 As Stream = assembly1.GetManifestResourceStream("RDLCReport." + path + ".rdlc")    '//R_24_CC.CancellationAddWork
        Return stream1
    End Function
    Public Shared Function SetRDLCReportDatasetss(report As LocalReport, Optional datasets As Dictionary(Of String, Object) = Nothing) As LocalReport
        If datasets IsNot Nothing Then
            For Each dataset In datasets
                report.DataSources.Add(New ReportDataSource(dataset.Key, dataset.Value))
            Next
        End If
        Return report
    End Function
End Class
