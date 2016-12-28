
<#
    .SYNOPSIS
    Remove an existing Management Group connection from a SCOM Agent.

    .DESCRIPTION
    Use PowerShell Remoting in combination with a local COM object query to
    remove an existing Management Group from the SCOM Agent.

    .INPUTS
    None.

    .OUTPUTS
    None.

    .EXAMPLE
    PS C:\> Remove-SCOMAgentManagementGroup -ComputerName 'PC1' -ManagementGroupName 'CONTOSO'
    Remove the CONTOSO Managemeng Group from the SCOM Agent PC1.

    .NOTES
    Author     : Claudio Spizzi
    License    : MIT License

    .LINK
    https://github.com/claudiospizzi/OperationsManagerFever
#>

function Remove-SCOMAgentManagementGroup
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    param
    (
        # Management group name.
        [Parameter(Mandatory = $true)]
        [System.String]
        $ManagementGroupName,

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

            param ($ManagementGroupName)

            try
            {
                $config = New-Object -ComObject AgentConfigManager.MgmtSvcCfg
            }
            catch
            {
                throw "No Monitoring Agent installed on $Env:ComputerName."
            }

            $groups = $config.GetManagementGroups() | Select-Object -ExpandProperty 'managementGroupName'

            if ($groups -contains $ManagementGroupName)
            {
                $config.RemoveManagementGroup($ManagementGroupName)
            }
            else
            {
                throw "Management Group $ManagementGroupName not found on Monitoring Agent $Env:ComputerName."
            }
        }
    }

    process
    {
        foreach ($computer in $ComputerName)
        {
            if ($PSCmdlet.ShouldProcess($computer, "Remove Management Group $ManagementGroupName"))
            {
                Invoke-Command -ComputerName $ComputerName -ScriptBlock $query -ArgumentList $ManagementGroupName @credentialParam -ErrorAction Continue
            }
        }
    }
}
