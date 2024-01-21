Imports System.Data.SqlClient
Imports System.Diagnostics.Eventing
Imports System.Reflection
Imports System.Threading.Tasks

Public Class ProcessAccess
    Implements IProcessAccess
    Private ReadOnly _connectionstring As String
    Private ReadOnly _dbConnection As SqlConnection
    Public Sub New()
        _connectionstring = ConfigurationManager.ConnectionStrings("myConnectionString").ConnectionString
        _dbConnection = New SqlConnection(_connectionstring)
    End Sub

    Public Async Function GetDataSetsAsync(SQLprocName As String, ParamArray parameters As SqlParameter()) As Task(Of DataSet) Implements IProcessAccess.GetDataSetsAsync
        Try
            If TypeOf _dbConnection Is SqlConnection Then
                Dim sqlConnection As SqlConnection = DirectCast(_dbConnection, SqlConnection)

                If _dbConnection.State <> ConnectionState.Open Then
                    Await sqlConnection.OpenAsync()
                End If

                Using cmd As New SqlCommand(), adp As New SqlDataAdapter()
                    cmd.CommandText = SQLprocName
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddRange(parameters)
                    cmd.Connection = sqlConnection
                    cmd.CommandTimeout = 120
                    adp.SelectCommand = cmd

                    Dim ds As New DataSet()
                    adp.Fill(ds)
                    Return ds
                End Using
            Else
                Return Nothing
            End If
        Catch exp As Exception
            Return Nothing
        End Try
    End Function

    Public Async Function GetAllAsync(Of T As New)(SQLprocName As String, ParamArray parameters() As SqlParameter) As Task(Of List(Of T)) Implements IProcessAccess.GetAllAsync
        Try
            If TypeOf _dbConnection Is SqlConnection Then
                Dim sqlConnection As SqlConnection = DirectCast(_dbConnection, SqlConnection)
                If sqlConnection.State <> ConnectionState.Open Then
                    Await sqlConnection.OpenAsync()
                End If

                Dim resultList As List(Of T) = New List(Of T)
                Dim cmd As SqlCommand = New SqlCommand()
                cmd.CommandText = SQLprocName
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddRange(parameters)
                cmd.Connection = sqlConnection
                cmd.CommandTimeout = 120

                Using reader As SqlDataReader = Await cmd.ExecuteReaderAsync(CommandBehavior.CloseConnection)
                    If reader.HasRows Then
                        While Await reader.ReadAsync()
                            Dim instance As T = New T()

                            For inc As Integer = 0 To reader.FieldCount - 1
                                Dim type As Type = instance.GetType()
                                Dim prop As PropertyInfo = type.GetProperty(reader.GetName(inc))
                                prop.SetValue(instance, reader.GetValue(inc), Nothing)
                            Next

                            resultList.Add(instance)
                        End While
                    End If
                End Using
                Return resultList
            Else
                Return Nothing
            End If

        Catch ex As Exception
            Return Nothing
        End Try
    End Function
    'Public Async Function GetAllAsync(Of T As New)(SQLprocName As String, ParamArray parameters As SqlParameter()) As Task(Of List(Of T)) Implements IProcessAccess.GetAllAsync
    '    Try
    '        Dim resultList As New List(Of T)()
    '        Dim cmd As New SqlCommand()
    '        cmd.CommandText = SQLprocName
    '        cmd.CommandType = CommandType.StoredProcedure
    '        cmd.Parameters.AddRange(parameters)

    '        Using reader As SqlDataReader = Await ExecuteReaderAsync(cmd)
    '            If reader.HasRows Then
    '                While Await reader.ReadAsync()
    '                    Dim instance As New T()

    '                    For inc As Integer = 0 To reader.FieldCount - 1
    '                        Dim type As Type = instance.GetType()
    '                        Dim prop As PropertyInfo = type.GetProperty(reader.GetName(inc))
    '                        prop.SetValue(instance, reader.GetValue(inc), Nothing)
    '                    Next

    '                    resultList.Add(instance)
    '                End While
    '            End If
    '        End Using

    '        Return resultList
    '    Catch exp As Exception
    '        Return Nothing
    '    End Try
    'End Function

    'Public Async Function ExecuteReaderAsync(cmd As SqlCommand) As Task(Of SqlDataReader)
    '    If TypeOf _dbConnection Is SqlConnection Then
    '        Dim sqlConnection As SqlConnection = DirectCast(_dbConnection, SqlConnection)
    '        cmd.Connection = sqlConnection
    '        cmd.CommandTimeout = 120

    '        Try
    '            If sqlConnection.State <> ConnectionState.Open Then
    '                Await sqlConnection.OpenAsync()
    '            End If

    '            Dim reader As SqlDataReader = Await cmd.ExecuteReaderAsync(CommandBehavior.CloseConnection)
    '            Return reader
    '        Catch ex As Exception
    '            ' Handle exceptions
    '            Return Nothing
    '        End Try
    '    Else
    '        ' Handle the case where _dbConnection is not of type SqlConnection
    '        Return Nothing
    '    End If
    'End Function

    Public Function ExecuteTransactionalOperation(SQLprocName As String, ParamArray parameters() As SqlParameter) As Boolean Implements IProcessAccess.ExecuteTransactionalOperation
        Try
            If TypeOf _dbConnection Is SqlConnection Then
                Dim sqlConnection As SqlConnection = DirectCast(_dbConnection, SqlConnection)

                If sqlConnection.State <> ConnectionState.Open Then
                    sqlConnection.Open()
                End If

                Using transaction As SqlTransaction = sqlConnection.BeginTransaction()
                    Using cmd As New SqlCommand()
                        cmd.CommandText = SQLprocName
                        cmd.CommandType = CommandType.StoredProcedure
                        cmd.Parameters.AddRange(parameters)
                        cmd.Connection = sqlConnection
                        cmd.Transaction = transaction
                        cmd.CommandTimeout = 120

                        Try
                            Dim affectedRows As Integer = cmd.ExecuteNonQuery()

                            If affectedRows > 0 Then
                                ' If execution was successful, commit the transaction
                                transaction.Commit()
                                Return True
                            Else
                                ' If no rows were affected, rollback the transaction
                                transaction.Rollback()
                                Return False
                            End If
                        Catch exp As Exception
                            ' Handle exceptions
                            transaction.Rollback()
                            Return False
                        End Try
                    End Using
                End Using
            Else
                Return False
            End If
        Catch ex As Exception
            Return False
        End Try
    End Function

    Public Async Function ExecuteTransactionalOperationAsync(SQLprocName As String, ParamArray parameters() As SqlParameter) As Task(Of Boolean) Implements IProcessAccess.ExecuteTransactionalOperationAsync
        Try
            If TypeOf _dbConnection Is SqlConnection Then
                Dim sqlConnection As SqlConnection = DirectCast(_dbConnection, SqlConnection)

                If sqlConnection.State <> ConnectionState.Open Then
                    Await sqlConnection.OpenAsync()

                End If

                Using transaction As SqlTransaction = sqlConnection.BeginTransaction()
                    Using cmd As New SqlCommand()
                        cmd.CommandText = SQLprocName
                        cmd.CommandType = CommandType.StoredProcedure
                        cmd.Parameters.AddRange(parameters)
                        cmd.Connection = sqlConnection
                        cmd.Transaction = transaction
                        cmd.CommandTimeout = 120

                        Try
                            Dim affectedRows As Integer = Await cmd.ExecuteNonQueryAsync()

                            If affectedRows > 0 Then
                                ' If execution was successful, commit the transaction
                                transaction.Commit()
                                Return True
                            Else
                                ' If no rows were affected, rollback the transaction
                                transaction.Rollback()
                                Return False
                            End If
                        Catch exp As Exception
                            ' Handle exceptions
                            transaction.Rollback()
                            Return False
                        End Try
                    End Using
                End Using
            Else
                Return False
            End If
        Catch ex As Exception
            Return False
        End Try
    End Function



    Public Async Function GetListAsync(Of T)(SQLprocName As String, ParamArray parameters As SqlParameter()) As Task(Of List(Of T)) Implements IProcessAccess.GetListAsync
        Try
            If TypeOf _dbConnection Is SqlConnection Then
                Dim sqlConnection As SqlConnection = DirectCast(_dbConnection, SqlConnection)

                If _dbConnection.State <> ConnectionState.Open Then
                    Await sqlConnection.OpenAsync()
                End If

                Dim customList As New List(Of T)()

                Using cmd As New SqlCommand()
                    cmd.CommandText = SQLprocName
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddRange(parameters)
                    cmd.Connection = sqlConnection
                    cmd.CommandTimeout = 120

                    Using reader As SqlDataReader = Await cmd.ExecuteReaderAsync(CommandBehavior.CloseConnection)
                        While Await reader.ReadAsync()
                            Dim obj As T = Activator.CreateInstance(Of T)()
                            MapDataReaderToObject(reader, obj)
                            customList.Add(obj)
                        End While
                    End Using
                End Using

                Return customList
            Else
                Return Nothing
            End If

        Catch exp As Exception
            Return Nothing
        End Try
    End Function

    Private Sub MapDataReaderToObject(Of T)(reader As SqlDataReader, obj As T)
        If Not reader.HasRows Then
            ' No data to read, return or handle the situation accordingly.
            Return
        End If

        For i As Integer = 0 To reader.FieldCount - 1
            Dim propertyName As String = reader.GetName(i)
            Dim [property] = obj.GetType().GetProperty(propertyName)

            If [property] IsNot Nothing AndAlso Not reader.IsDBNull(i) Then
                If [property].PropertyType Is reader.GetFieldType(i) Then
                    [property].SetValue(obj, reader(i))
                Else
                    ' Handle specific type conversions, like decimal to double
                    If [property].PropertyType Is GetType(Double) AndAlso reader.GetFieldType(i) Is GetType(Decimal) Then
                        [property].SetValue(obj, Convert.ToDouble(reader(i)))
                    Else
                        [property].SetValue(obj, reader(i))
                        ' Add more specific type conversions if needed
                        ' ...
                    End If
                End If
            End If
        Next
    End Sub


    Public Async Function GetTransactionalOperationAsync(SQLprocName As String, ParamArray parameters() As SqlParameter) As Task(Of String) Implements IProcessAccess.GetTransactionalOperationAsync
        Try
            If TypeOf _dbConnection Is SqlConnection Then
                Dim sqlConnection As SqlConnection = DirectCast(_dbConnection, SqlConnection)

                If sqlConnection.State <> ConnectionState.Open Then
                    Await sqlConnection.OpenAsync()
                End If

                Using transaction As SqlTransaction = sqlConnection.BeginTransaction()
                    Using cmd As New SqlCommand()
                        cmd.CommandText = SQLprocName
                        cmd.CommandType = CommandType.StoredProcedure
                        cmd.Parameters.AddRange(parameters)
                        Dim outputParameter As New SqlParameter("@PrimaryKey", SqlDbType.NVarChar, 50) With         'set -1 instead of 50 if need nvarchar(max)
                        {
                            .Direction = ParameterDirection.Output
                        }
                        cmd.Parameters.Add(outputParameter)
                        cmd.Connection = sqlConnection
                        cmd.Transaction = transaction
                        cmd.CommandTimeout = 120

                        Try
                            ' Execute the stored procedure
                            Dim primaryKey As Object = Await cmd.ExecuteScalarAsync()

                            If primaryKey IsNot Nothing AndAlso Not Convert.IsDBNull(primaryKey) Then
                                ' If execution was successful and primary key is not null, commit the transaction
                                transaction.Commit()
                                Return primaryKey.ToString()
                            Else
                                ' If primary key is null or DBNull, rollback the transaction
                                transaction.Rollback()
                                Return Nothing
                            End If
                        Catch exp As Exception
                            ' Handle exceptions
                            transaction.Rollback()
                            Return Nothing
                        End Try
                    End Using
                End Using
            Else
                Return Nothing
            End If
        Catch ex As Exception
            Return Nothing
        End Try
    End Function


    Public Function GetTransactionalOperation(SQLprocName As String, ParamArray parameters() As SqlParameter) As String Implements IProcessAccess.GetTransactionalOperation
        Try
            If TypeOf _dbConnection Is SqlConnection Then
                Dim sqlConnection As SqlConnection = DirectCast(_dbConnection, SqlConnection)

                If sqlConnection.State <> ConnectionState.Open Then
                    sqlConnection.Open()
                End If

                Using transaction As SqlTransaction = sqlConnection.BeginTransaction()
                    Using cmd As New SqlCommand()
                        cmd.CommandText = SQLprocName
                        cmd.CommandType = CommandType.StoredProcedure
                        cmd.Parameters.AddRange(parameters)
                        Dim outputParameter As New SqlParameter("@PrimaryKey", SqlDbType.NVarChar, 50) With         'set -1 instead of 50 if need nvarchar(max)
                        {
                            .Direction = ParameterDirection.Output
                        }
                        cmd.Parameters.Add(outputParameter)
                        cmd.Connection = sqlConnection
                        cmd.Transaction = transaction
                        cmd.CommandTimeout = 120

                        Try
                            ' Execute the stored procedure
                            Dim primaryKey As Object = cmd.ExecuteScalar()

                            If primaryKey IsNot Nothing AndAlso Not Convert.IsDBNull(primaryKey) Then
                                ' If execution was successful and primary key is not null, commit the transaction
                                transaction.Commit()
                                Return primaryKey.ToString()
                            Else
                                ' If primary key is null or DBNull, rollback the transaction
                                transaction.Rollback()
                                Return Nothing
                            End If
                        Catch exp As Exception
                            ' Handle exceptions
                            transaction.Rollback()
                            Return Nothing
                        End Try
                    End Using
                End Using
            Else
                Return Nothing
            End If
        Catch ex As Exception
            Return Nothing
        End Try
    End Function


End Class