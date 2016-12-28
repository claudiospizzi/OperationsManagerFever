<#
    .SYNOPSIS
    Reset and recalculate the health state for target monitors.

    .DESCRIPTION
    Reset the health state for the specified or for all class instance. Before
    you can use this function, a connection to a SCOM Management Group has to be
    opened.

    .INPUTS
    None.

    .OUTPUTS
    None.

    .EXAMPLE
    PS C:\> Reset-SCOMMonitor
    Reset all monitors on all instances for the current SCOM connection. This
    will produce a high load on the connected your Management Group.

    .EXAMPLE
    PS C:\> Reset-SCOMMonitor -Class (Get-SCOMClass -Name 'Microsoft.Windows.Computer')
    Reset all monitors on all instances of the specified class
    'Microsoft.Windows.Computer'.

    .EXAMPLE
    PS C:\> Reset-SCOMMonitor -Instance (Get-SCOMClassInstance -DisplayName 'SERVER1.contoso.com')
    Reset all monitors on all instances which have the display name
    'SERVER1.contoso.com'.

    .NOTES
    Author     : Claudio Spizzi
    License    : MIT License

    .LINK
    https://github.com/claudiospizzi/OperationsManagerFever
#>

function Reset-SCOMMonitor
{
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param
    (
        # Filter the target objects with this specified classes.
        [Parameter(Mandatory = $true, ParameterSetName = 'ByClass')]
        [Microsoft.EnterpriseManagement.Configuration.ManagementPackClass[]]
        $Class,

        # Filter the target objects with this specified instances.
        [Parameter(Mandatory = $true, ParameterSetName = 'ByInstance')]
        [Microsoft.EnterpriseManagement.Monitoring.MonitoringObject[]]
        $Instance,

        # The target monitor to reset. By default reset all monitors.
        [Parameter(Mandatory = $false)]
        [AllowNull]
        [Microsoft.EnterpriseManagement.Configuration.ManagementPackMonitor]
        $Monitor = $null,

        # By default, only monitors in warning or error state will be reseted.
        # With the force option, all monitors including healthy once will be
        # reseted.
        [Parameter(Mandatory = $false)]
        [Switch]
        $Force,

        # Provide a Management Group connection to use. If no connection is
        # provided, the current active connection will be used.
        [Parameter(Mandatory = $false, Position = 2)]
        [Microsoft.SystemCenter.Core.Connection.Connection]
        $Connection = (Get-SCOMManagementGroupConnectionActive)
    )

    begin
    {
        # If no classes and no instances are specified, load all available
        # instances on the current SCOM connection.
        if ($PSCmdlet.ParameterSetName -eq 'All')
        {
            $Instnace = Get-SCOMClassInstance -ErrorAction Stop
        }

        # If the classes are specified, load all their discovered instances as
        # targets for this command.
        if ($PSCmdlet.ParameterSetName -eq 'ByClass')
        {
            $Instance = Get-SCOMClassInstance -Class $Class -ErrorAction Stop
        }
    }

    process
    {
        foreach ($CurrentInstance in $Instance)
        {
            # Verify if the current instance is unhealthy (Warning / Error) or
            # the force switch was specified.
            if ($Force.IsPresent -or
                $CurrentInstance.HealthState -eq 'Warning' -or
                $CurrentInstance.HealthState -eq 'Error')
            {
                Write-Verbose "Reset Health State for $($CurrentInstance.DisplayName) ($($CurrentInstance.Id))"

                # Verify if the whole instance or just one monitor should be reseted.
                if ($Monitor -eq $null)
                {
                    $CurrentInstance.ResetMonitoringState() | Test-SCOMMonitoringTaskResultForError
                    $CurrentInstance.RecalculateMonitoringState() | Test-SCOMMonitoringTaskResultForError
                }
                else
                {
                    $CurrentInstance.ResetMonitoringState($Monitor) | Test-SCOMMonitoringTaskResultForError
                    $CurrentInstance.RecalculateMonitoringState($Monitor) | Test-SCOMMonitoringTaskResultForError
                }
            }
        }
    }
}
