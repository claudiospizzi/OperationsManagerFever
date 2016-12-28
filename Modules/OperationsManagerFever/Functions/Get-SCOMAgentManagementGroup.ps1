
<#
    .SYNOPSIS
    Get all Management Group connections of a SCOM Agent.

    .DESCRIPTION
    Use PowerShell Remoting in combination with a local COM object query to get
    the current Management Group configuration of the SCOM Agent.

    .INPUTS
    None.

    .OUTPUTS
    OperationsManagerFever.AgentManagementGroup.

    .EXAMPLE
    PS C:\> Get-SCOMAgentManagementGroup -ComputerName 'PC1', 'PC2'
    Get the registered Management Groups on the SCOM Agents PC1 and PC2.

    .NOTES
    Author     : Claudio Spizzi
    License    : MIT License

    .LINK
    https://github.com/claudiospizzi/OperationsManagerFever
#>

function Get-SCOMAgentManagementGroup
{
    [CmdletBinding()]
    param
    (
        # Computer name of the target agent.
        [Parameter(Mandatory = $false)]
        [System.String[]]
        $ComputerName = 'localhost',

        # Optional credentials to perform the action.
        [Parameter(Mandatory = $false)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = $null
    )

    begin
    {
        # Optional credential parameter
        $credentialParam = @{}
        if ($Credential -ne $null)
        {
            $credentialParam['Credential'] = $Credential
        }

        # Query script block
        $query = {

            try
            {
                $config = New-Object -ComObject AgentConfigManager.MgmtSvcCfg
            }
            catch
            {
                throw "No Monitoring Agent installed on $Env:ComputerName."
            }

            return $config.GetManagementGroups()
        }
    }

    process
    {
        foreach ($computer in $ComputerName)
        {
            $managementGroups = Invoke-Command -ComputerName $ComputerName -ScriptBlock $query @credentialParam -ErrorAction Stop

            foreach ($managementGroup in $managementGroups)
            {
                $object = New-Object -TypeName PSObject -Property @{
                    ComputerName         = $computer
                    ManagementGroupName  = $managementGroup.managementGroupName
                    ManagementServer     = $managementGroup.managementServer
                    ManagementServerPort = $managementGroup.managementServerPort
                    IsActiveDirectory    = $managementGroup.IsManagementGroupFromActiveDirectory
                    ActionAccount        = $managementGroup.ActionAccount
                }

                $object.PSTypeNames.Insert(0, 'OperationsManagerFever.AgentManagementGroup')

                Write-Output $object
            }
        }
    }
}
