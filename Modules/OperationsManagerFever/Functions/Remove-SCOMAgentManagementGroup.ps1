
<#
    .SYNOPSIS
    Remove an existing Management Group connection from a SCOM Agent.

    .DESCRIPTION
    

    .INPUTS
    None.

    .OUTPUTS
    None.

    .EXAMPLE
    PS C:\> 


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

            try
            {
                $config = New-Object -ComObject AgentConfigManager.MgmtSvcCfg
            }
            catch
            {
                throw "No Monitoring Agent installed on $Env:ComputerName."
            }



            
	# $sb = {
	# 	param($ManagementGroup, 
	# 	  $ComputerName = "Localhost")
	# 	Try {
	# 		$OMCfg = New-Object -ComObject AgentConfigManager.MgmtSvcCfg
	# 	} catch {
	# 		throw "$ComputerName doesn't have the SCOM 2012 agent installed"
	# 	}
	# 	$mgs = $OMCfg.GetManagementGroups() | %{$_.managementGroupName}
	# 	if ($mgs -contains $ManagementGroup) {
	# 		$OMCfg.RemoveManagementGroup($ManagementGroup)
	# 		return "$ManagementGroup removed from $ComputerName"
	# 	} else {
	# 		return "$ComputerName does not report to $ManagementGroup"
	# 	}
	# }
	# Invoke-Command -ScriptBlock $sb -ComputerName $ComputerName -ArgumentList @($ManagementGroup,$ComputerName)
        }
    }

    process
    {
        foreach ($computer in $ComputerName)
        {
            if ($PSCmdlet.ShouldProcess($computer, "Remove Management Group $ManagementGroupName"))
            {
                
            }
        }
    }
}

