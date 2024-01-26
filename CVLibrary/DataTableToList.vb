Imports System.Reflection

Public Class DataTableToList
    Public Function ConvertDataTableToList(Of T As New)(dataTable As DataTable) As List(Of T)
        If dataTable Is Nothing Then
            Throw New ArgumentNullException(NameOf(dataTable), "The input DataTable is null.")
        End If

        Dim dataList As New List(Of T)()

        For Each row As DataRow In dataTable.Rows
            Dim rowData As New T()

            For Each col As DataColumn In dataTable.Columns
                Dim propertyInfo As PropertyInfo = GetType(T).GetProperty(col.ColumnName)

                If propertyInfo IsNot Nothing AndAlso row(col) IsNot DBNull.Value Then
                    propertyInfo.SetValue(rowData, Convert.ChangeType(row(col), propertyInfo.PropertyType))
                End If
            Next

            dataList.Add(rowData)
        Next

        Return dataList
    End Function
End Class
