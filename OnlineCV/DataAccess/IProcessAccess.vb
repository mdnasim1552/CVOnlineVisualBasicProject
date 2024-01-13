Imports System.Data.SqlClient
Imports System.Threading.Tasks
Public Interface IProcessAccess
    'Task<List<T>> GetAllAsync<T>(string SQLprocName, params SqlParameter[] parameters) where T : New();
    '    Task<bool> ExecuteTransactionalOperationAsync(string SQLprocName, params SqlParameter[] parameters);

    Function GetAllAsync(Of T As New)(SQLprocName As String, ParamArray parameters As SqlParameter()) As Task(Of List(Of T))
    Function GetListAsync(Of T)(SQLprocName As String, ParamArray parameters As SqlParameter()) As Task(Of List(Of T))
    Function ExecuteTransactionalOperationAsync(SQLprocName As String, ParamArray parameters As SqlParameter()) As Task(Of Boolean)
    Function GetTransactionalOperationAsync(SQLprocName As String, ParamArray parameters() As SqlParameter) As Task(Of String)
    Function GetDataSetsAsync(SQLprocName As String, ParamArray parameters As SqlParameter()) As Task(Of DataSet)
End Interface
