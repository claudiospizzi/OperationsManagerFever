
function Test-SCOMMonitoringTaskResultForError
{
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Microsoft.EnterpriseManagement.Runtime.TaskResult]
        $Result
    )

    if ($Result.Status -ne 'Succeeded')
    {
        Write-Error "Task failed with error code $($Result.ErrorCode): $($Result.ErrorMessage)"
    }
}
