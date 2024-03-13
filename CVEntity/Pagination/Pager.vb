Public Class Pager
    Public Property TotalItem As Integer
    Public Property CurrentPage As Integer
    Public Property PageSize As Integer
    Public Property TotalPages As Integer
    Public Property StartPage As Integer
    Public Property EndPage As Integer
    Public Sub New()

    End Sub
    Public Sub New(totalItems As Integer, currentPage As Integer, Optional pageSize As Integer = 10)
        Dim totalPages As Integer = Math.Ceiling(totalItems / pageSize)
        Dim startPage As Integer = currentPage - 5
        Dim endPage As Integer = currentPage + 4
        If startPage <= 0 Then
            endPage = endPage - (startPage - 1)
            startPage = 1
        End If
        If endPage > totalPages Then
            endPage = totalPages
            If endPage > 10 Then
                startPage = endPage - 9
            End If
        End If
        Me.TotalItem = totalPages
        Me.CurrentPage = currentPage
        Me.PageSize = pageSize
        Me.TotalPages = totalPages
        Me.StartPage = startPage
        Me.EndPage = endPage
    End Sub
End Class
