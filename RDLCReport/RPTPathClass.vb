Imports System.IO
Imports System.Reflection


Public Class RPTPathClass
    Public Function GetReportFilePath(path As String) As Stream
        'Dim assembly1 As Assembly = Assembly.GetExecutingAssembly()

        '' Replace "RDLCReport" with the namespace of your project
        'Dim resourcePrefix As String = "RDLCReport."

        '' Get all resource names in the assembly
        'Dim allResourceNames As String() = assembly1.GetManifestResourceNames()

        '' Find the correct resource name based on the provided path
        'Dim resourceName As String = allResourceNames.FirstOrDefault(Function(name) name.EndsWith("." + path + ".rdlc"))

        'If resourceName IsNot Nothing Then
        '    ' Get the stream for the embedded resource
        '    Dim stream1 As Stream = assembly1.GetManifestResourceStream(resourceName)
        '    Return stream1
        'Else
        '    ' Handle the case where the resource is not found
        '    Return Nothing
        'End If



        Dim assamblyPath = Assembly.GetExecutingAssembly().CodeBase
        Dim assembly1 As Assembly = Assembly.LoadFrom(assamblyPath)
        Dim stream1 As Stream = assembly1.GetManifestResourceStream("RDLCReport." + path + ".rdlc")    '//R_24_CC.CancellationAddWork
        Return stream1
    End Function
    Public Function SetRDLCReportDatasetss(report As LocalReport, Optional datasets As Dictionary(Of String, Object) = Nothing) As LocalReport
        If datasets IsNot Nothing Then
            For Each dataset In datasets
                report.DataSources.Add(New ReportDataSource(dataset.Key, dataset.Value))
            Next
        End If
        Return report
    End Function
End Class
