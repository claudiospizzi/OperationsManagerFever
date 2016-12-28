
function Resolve-SCOMWorkflowName
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, Position = 0)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true, Position = 1)]
        [Microsoft.SystemCenter.Core.Connection.Connection]
        $Connection
    )

    if (($Rule = Get-SCOMRule -Name $Name) -ne $null)
    {
        Write-Output $Rule
    }
    elseif (($Monitor = Get-SCOMMonitor -Name $Name) -ne $null)
    {
        Write-Output $Monitor
    }
    elseif (($Discovery = Get-SCOMDiscovery -Name $Name) -ne $null)
    {
        Write-Output $Discovery
    }
    else
    {
        $Exception   = New-Object -TypeName 'System.Exception' -ArgumentList ('Workflow name {0} not found as rule, monitor or discovery!' -f $Name)
        $ErrorRecord = New-Object -TypeName 'System.Management.Automation.ErrorRecord' -ArgumentList $Exception, '0', 'ObjectNotFound', $Name

        $PSCmdlet.ThrowTerminatingError($ErrorRecord)
    }
}
