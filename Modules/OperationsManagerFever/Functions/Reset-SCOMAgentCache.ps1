<#
    .SYNOPSIS
    Reset the Cache of an Monitoring Agent (Health Service).

    .DESCRIPTION
    Reset the cache of a Monitoring Agent (HealthSservice). The Management Group
    configuration is not reseted. To perform the the reset, this command will
    stop the Monitoring Agent Windows service, clear the Health Service Cache
    folder in the file system and start the service again.

    .INPUTS
    System.String. A list of computer names.

    .OUTPUTS
    None.

    .EXAMPLE
    PS C:\> Reset-SCOMAgentCache -ComputerName 'SERVER1', 'SERVER2'
    Reset the Health Service cache on SERVER1 and SERVER2.

    .EXAMPLE
    PS C:\> Get-Content -Path '.\server.txt' | Reset-SCOMAgentCache -Credential (Get-Credential)
    Reset the Health Service cache for all servers listed in the server.txt
    file, executed with the requested credentials.

    .NOTES
    Author     : Claudio Spizzi
    License    : MIT License

    .LINK
    https://github.com/claudiospizzi/OperationsManagerFever
#>

function Reset-SCOMAgentCache
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

            # Remove the health service state database cache
            Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Microsoft Operations Manager\3.0\Setup' -Name 'InstallDirectory' |
                Select-Object -ExpandProperty 'InstallDirectory' | Join-Path -ChildPath 'Health Service State' |
                    Where-Object { Test-Path -Path $_ } |
                        Remove-Item -Recurse -Force

            # Start the health service again
            Start-Service -Name 'HealthService'
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

        if ($PSCmdlet.ShouldProcess($ComputerName, 'Reset Agent Cache'))
        {
            Invoke-Command @InvokeCommandParam -ComputerName $ComputerName -ScriptBlock $ResetCommand
        }
    }
}
