<#
    .SYNOPSIS
    Get all active workflows on the target health services.

    .DESCRIPTION
    This function is a wrapper for the SCOM Task 'Show Running Rules and
    Monitors for this Health Service'. It will execute this task against
    all provided health services.

    .EXAMPLE
    Get-SCOMHealthServiceActiveWorkflow -DisplayName 'LON-DC1.contoso.com'
    Get all active workflows on the health service with the display name
    'LON-DC1.contoso.com'. It will use the active SCOM Management Group
    connection.

    .EXAMPLE
    Get-SCOMHealthServiceActiveWorkflow -DisplayName 'LON-DC1.contoso.com' -Connection $Connection
    Get all active workflows on the health service with the display name
    'LON-DC1.contoso.com'. It will use the provided SCOM Management Group
    connection.

    .EXAMPLE
    Get-SCOMHealthServiceActiveWorkflow -DisplayName '*'
    Get all active workflows on all available health services. Be carefull,
    this may produce a high load on your SCOM Management Servers and Agents.

    .NOTES
    Author     : Claudio Spizzi
    License    : MIT License

    .LINK
    https://github.com/claudiospizzi/OperationsManagerFever
#>

function Get-SCOMHealthServiceActiveWorkflow
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param
    (
        # Provide the display name for the target health service. Wildcard are
        # supported, to select multiple targets or for partial input.
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [System.String[]]
        $DisplayName,

        # Provide a Management Group connection to use. If no connection is
        # provided, the current active connection will be used.
        [Parameter(Mandatory = $false, Position = 1)]
        [Microsoft.SystemCenter.Core.Connection.Connection]
        $Connection = (Get-SCOMManagementGroupConnectionActive)
    )

    begin
    {
        $Class = Get-SCOMClass -Name 'Microsoft.SystemCenter.HealthService' -SCSession $Connection -ErrorAction Stop

        $HealthServices = @()
    }

    process
    {
        foreach ($DisplayNameItem in $DisplayName)
        {
            $HealthServices += Get-SCOMClassInstance -Class $Class -SCSession $Connection -ErrorAction Stop |
                                   Where-Object { $_.DisplayName -like $DisplayNameItem }
        }
    }

    end
    {
        # The SCOM tasks the get the active workflows on a target health
        # services are started in parallel, therefore it needs to be in the end
        # block of PowerShell.
        if ($HealthServices.Count -gt 0)
        {
            $Results = Invoke-SCOMTask -TaskName 'Microsoft.SystemCenter.GetAllRunningWorkflows' -Instance $HealthServices -Connection $Connection

            foreach ($Result in $Results)
            {
                $ResultXml = [Xml] $Result.Output

                $HealthService = Get-SCOMClassInstance -Id $Result.TargetObjectId -ErrorAction Stop

                foreach ($ResultInstance in $ResultXml.DataItem.Details.Instance)
                {
                    $MonitoringObject = Get-SCOMClassInstance -Id $ResultInstance.Id -ErrorAction Stop

                    foreach ($ResultWorkflow in $ResultInstance.Workflow)
                    {
                        $Workflow = Resolve-SCOMWorkflowName -Name $ResultWorkflow -Connection $Connection

                        $Object = New-Object -TypeName PSObject -Property ([Ordered] @{
                            HealthServiceId          = $HealthService.Id
                            HealthServiceDisplayName = $HealthService.DisplayName
                            ObjectId                 = $MonitoringObject.Id
                            ObjectClass              = $MonitoringObject.GetLeastDerivedNonAbstractClass().DisplayName
                            ObjectDisplayName        = $MonitoringObject.DisplayName
                            WorkflowId               = $Workflow.Id
                            WorkflowType             = $Workflow.XmlTag
                            WorkflowCategory         = $Workflow.Category
                            WorkflowName             = $Workflow.Name
                            WorkflowDisplayName      = $Workflow.DisplayName
                        })
                        $Object.PSTypeNames.Insert(0, 'OperationsManagerFever.Workflow')

                        Write-Output $Object
                    }
                }
            }
        }
    }
}
