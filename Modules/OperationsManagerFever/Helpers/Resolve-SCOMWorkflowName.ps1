
function Resolve-SCOMWorkflowName
{
    [CmdletBinding()]
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingCmdletAliases', '')]
    param
    (
        [Parameter(Mandatory = $true, Position = 0)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true, Position = 1)]
        [Microsoft.SystemCenter.Core.Connection.Connection]
        $Connection
    )

    if ($null -ne ($Rule = Get-SCOMRule -Name $Name))
    {
        Write-Output $Rule
    }
    elseif ($null -ne ($Monitor = Get-SCOMMonitor -Name $Name))
    {
        Write-Output $Monitor
    }
    elseif ($null -ne ($Discovery = Get-SCOMDiscovery -Name $Name))
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
