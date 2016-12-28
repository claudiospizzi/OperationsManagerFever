<#
    .SYNOPSIS
    Reset a Monitoring Agent (Health Service) to it's initial state as it was
    after a clean installation.

    .DESCRIPTION
    Reset a Monitoring Agent (Health Service) to it's initial state as it was
    after a clean installation. To do the reset, the command stops the Health
    Service Windows service, removes all assigend Management Groups from the
    registry and clears the Health Service Cache folder in the file system.

    .INPUTS
    System.String. A list of computer names.

    .OUTPUTS
    None.

    .EXAMPLE
    PS C:\> Reset-SCOMAgentConfig -ComputerName 'SERVER1', 'SERVER2'
    Reset the Health Service configuration on SERVER1 and SERVER2.

    .EXAMPLE
    PS C:\> Get-Content -Path '.\server.txt' | Reset-SCOMAgentConfig -Credential (Get-Credential)
    Reset the Health Service configuration for all servers listed in the
    server.txt file, executed with the requested credentials.

    .NOTES
    Author     : Claudio Spizzi
    License    : MIT License

    .LINK
    https://github.com/claudiospizzi/OperationsManagerFever
#>

function Reset-SCOMAgentConfig
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    param
    (
        # A list of computer names where the Monitoring Agent wil be reseted.
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [System.String[]]
        $ComputerName = 'localhost',

        # Optional credentials to perform the action.
        [Parameter(Mandatory = $false)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )

    begin
    {
        $ResetCommand = {

            # Stop the monitoring agent service
            Stop-Service -Name 'HealthService' -Force

            # Remove all management group informations inside the SOFTWARE key
            Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\Microsoft Operations Manager\3.0\Agent Management Groups' |
                Select-Object -ExpandProperty 'PSPath' |
                    Remove-Item -Recurse -Force

            # Remove all management group informations inside the SYSTEM\CurrentControlSet\services key
            Get-ChildItem -Path 'HKLM:\SYSTEM\CurrentControlSet\services\HealthService\Parameters\Management Groups' |
                Select-Object -ExpandProperty 'PSPath' |
                    Remove-Item -Recurse -Force

            # Remove the health service state database cache
            Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Microsoft Operations Manager\3.0\Setup' -Name 'InstallDirectory' |
                Select-Object -ExpandProperty 'InstallDirectory' | Join-Path -ChildPath 'Health Service State' |
                    Where-Object { Test-Path -Path $_ } |
                        Remove-Item -Recurse -Force

            # Remove existing SCOM agent certificates
            Get-ChildItem -Path 'Cert:\LocalMachine\Operations Manager\' -ErrorAction SilentlyContinue |
                Remove-Item -Force
        }
    }

    process
    {
        # Optional parameter credential
        $InvokeCommandParam = @{}
        if ($Credential -ne $null)
        {
            $InvokeCommandParam['Credential'] = $Credential
        }

        if ($PSCmdlet.ShouldProcess($ComputerName, 'Reset Agent Config'))
        {
            Invoke-Command @InvokeCommandParam -ComputerName $ComputerName -ScriptBlock $ResetCommand
        }
    }
}
