
Properties {

    $ModuleNames    = 'OperationsManagerFever'

    $GalleryEnabled = $true
    $GalleryKey     = Use-VaultSecureString -TargetName 'PowerShell Gallery Key (claudiospizzi)'

    $GitHubEnabled  = $true
    $GitHubRepoName = 'claudiospizzi/OperationsManagerFever'
    $GitHubKey      = Use-VaultSecureString -TargetName 'GitHub Token (claudiospizzi)'
}
