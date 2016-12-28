
function Invoke-SCOMTask
{
    [CmdletBinding()]
    [OutputType([Microsoft.EnterpriseManagement.Runtime.TaskResult])]
    param
    (
        [Parameter(Mandatory = $true, Position = 0)]
        [System.String]
        $TaskName,

        [Parameter(Mandatory = $true, Position = 1)]
        [Microsoft.EnterpriseManagement.Common.EnterpriseManagementObject[]]
        $Instance,

        [Parameter(Mandatory = $true, Position = 2)]
        [Microsoft.SystemCenter.Core.Connection.Connection]
        $Connection
    )

    $Task = Get-SCOMTask -Name $TaskName -SCSession $Connection -ErrorAction Stop

    $Results = Start-SCOMTask -Task $Task -Instance $Instance -ErrorAction Stop

    foreach ($Result in $Results)
    {
        # Endless while loop to wait for the current task. The loop ends as if
        # the TimeFinished porperty is not null anymore.
        while (($Result = Get-SCOMTaskResult -Id $Result.Id -SCSession $Connection).TimeFinished -eq $null)
        {
            Start-Sleep -Seconds 1
        }

        # Check if the task has finished successfully. If yes, parse the result
        # as XML and return it. If not, write an custom error to the error
        # stream.
        if ($Result.Status -eq 'Succeeded')
        {
            Write-Output $Result
        }
        else
        {
            $Exception   = New-Object -TypeName 'System.Exception' -ArgumentList ('{0}: {1}' -f $Result.ErrorId, $Result.ErrorMessage)
            $ErrorRecord = New-Object -TypeName 'System.Management.Automation.ErrorRecord' -ArgumentList $Exception, '0', 'InvalidOperation', $Result

            $PSCmdlet.ThrowTerminatingError($ErrorRecord)
        }
    }
}
