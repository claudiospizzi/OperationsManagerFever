
function Get-SCOMManagementGroupConnectionActive
{
    [CmdletBinding()]
    [OutputType([Microsoft.SystemCenter.Core.Connection.Connection])]
    param ()

    $ActiveConnection = Get-SCOMManagementGroupConnection | Where-Object { $_.IsActive }

    if ($null -ne $ActiveConnection)
    {
        return $ActiveConnection
    }
    else
    {
        $Exception   = New-Object -TypeName 'System.Exception' -ArgumentList 'The Data Access service is either not running or not yet initialized. Please check the Management Group connection.'
        $ErrorRecord = New-Object -TypeName 'System.Management.Automation.ErrorRecord' -ArgumentList $Exception, '0', 'ConnectionError', $null

        $PSCmdlet.ThrowTerminatingError($ErrorRecord)
    }
}
