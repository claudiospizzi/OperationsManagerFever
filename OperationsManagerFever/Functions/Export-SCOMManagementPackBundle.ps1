<#
    .SYNOPSIS
    Export all artifacts from a SCOM Management Pack Bundle (.mpb).

    .DESCRIPTION
    Use this function to export all artifacts and the module itself from a
    Management Pack Bundle file. It will use the SCOM API to perform these
    extraction, therefore a connection to a SCOM Management Group is required.

    .INPUTS
    None.

    .OUTPUTS
    None.

    .EXAMPLE
    PS C:\> Export-SCOMManagementPackBundle -BundleFile 'C:\Temp\ManagementPack.mpb'
    Export all artifacts of the the ManagementPack.mpb into the folder C:\Temp.

    .NOTES
    Author     : Claudio Spizzi
    License    : MIT License

    .LINK
    https://github.com/claudiospizzi/OperationsManagerFever
#>

function Export-SCOMManagementPackBundle
{
    [CmdletBinding()]
    param
    (
        # The full path to a Management Pack Bundle file.
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateScript({ Test-Path -Path $_ })]
        [ValidatePattern('\.mpb$')]
        [System.String]
        $BundleFile,

        # The path to the output folder. Default is the same path as the
        #  Management Pack Bundle file is located.
        [Parameter(Mandatory = $false, Position = 1)]
        [ValidateScript({ Test-Path -Path $_ })]
        [System.String]
        $OutputPath = (Split-Path -Path $BundleFile -Parent),

        # Provide a Management Group connection to use. If no connection is
        # provided, the current active connection will be used.
        [Parameter(Mandatory = $false, Position = 2)]
        [Microsoft.SystemCenter.Core.Connection.Connection]
        $Connection = (Get-SCOMManagementGroupConnectionActive)
    )

    $ManagementGroup = Get-SCOMManagementGroup -SCSession $Connection -ErrorAction Stop

    try
    {
        Write-Verbose "Open Management Pack Bundle $BundleFile"

        # Copy the bundle file to a temporary location, because the build-in
        # cmdlet Get-SCOMManagementPack does not release the file handle
        # to the target .mpb file.
        $BundleFile = Copy-Item -Path $BundleFile -Destination ([System.IO.Path]::GetTempFileName() + '.mpb') -Force -PassThru | % FullName
        $OutputPath = Resolve-Path -Path $OutputPath -ErrorAction Stop

        Get-SCOMManagementPack -BundleFile $BundleFile -ErrorAction Stop | Export-SCOMManagementPack -Path $OutputPath -ErrorAction Stop

        $Reader = [Microsoft.EnterpriseManagement.Packaging.ManagementPackBundleFactory]::CreateBundleReader()
        $Bundle = $Reader.Read($BundleFile, $ManagementGroup)

        foreach ($ManagementPack in $Bundle.ManagementPacks)
        {
            Write-Verbose "Parse Management Pack $($ManagementPack.Name)"

            $MemoryStreams = $Bundle.GetStreams($ManagementPack)

            foreach ($MemoryStream in $MemoryStreams.GetEnumerator())
            {
                Write-Verbose "Export Artifacts from Stream $($MemoryStream.Key)"

                try
                {
                    $FileStream = New-Object -TypeName 'System.IO.FileStream' -ArgumentList (Join-Path -Path $OutputPath -ChildPath $MemoryStream.Key), 'OpenOrCreate', 'Write'

                    $MemoryStream.Value.WriteTo($FileStream)
                }
                catch
                {
                    Write-Warning "Failed to export the Artifact $($MemoryStream.Key) inside $($ManagementPack.Name): $_"
                }
                finally
                {
                    $MemoryStream.Value.Dispose()
                    $FileStream.Dispose()
                }
            }
        }
    }
    catch
    {
        throw "Unable to open Management Pack Bundle $BundleFile`: $_"
    }
}
