[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$requiredVariables = @(
    'ZIMBA_RELEASE_STORE_FILE',
    'ZIMBA_RELEASE_STORE_PASSWORD',
    'ZIMBA_RELEASE_KEY_ALIAS',
    'ZIMBA_RELEASE_KEY_PASSWORD'
)

foreach ($name in $requiredVariables) {
    $value = [Environment]::GetEnvironmentVariable($name, 'Process')
    if ([string]::IsNullOrWhiteSpace($value)) {
        $value = [Environment]::GetEnvironmentVariable($name, 'User')
    }
    if ([string]::IsNullOrWhiteSpace($value)) {
        throw "Variável $name ausente. Execute tool/configure_personal_signing.ps1."
    }
    Set-Item -Path "Env:$name" -Value $value
}

if (-not (Test-Path -LiteralPath $env:ZIMBA_RELEASE_STORE_FILE)) {
    throw 'Arquivo da chave pessoal não encontrado.'
}

if ([string]::IsNullOrWhiteSpace($env:JAVA_HOME)) {
    $androidStudioJdk = 'C:\Program Files\Android\Android Studio\jbr'
    if (Test-Path -LiteralPath $androidStudioJdk) {
        $env:JAVA_HOME = $androidStudioJdk
    }
}

$mobileRoot = Split-Path -Parent $PSScriptRoot
Push-Location $mobileRoot
try {
    & flutter build apk --release
    if ($LASTEXITCODE -ne 0) {
        throw 'A compilação release falhou.'
    }

    $apkPath = Join-Path $mobileRoot 'build\app\outputs\flutter-apk\app-release.apk'
    $sdkRoot = Join-Path $env:LOCALAPPDATA 'Android\Sdk'
    $apksigner = Get-ChildItem `
        -Path (Join-Path $sdkRoot 'build-tools') `
        -Filter 'apksigner.bat' `
        -Recurse `
        -File |
        Sort-Object FullName -Descending |
        Select-Object -First 1
    if ($null -eq $apksigner) {
        throw 'apksigner não encontrado no Android SDK.'
    }

    & $apksigner.FullName verify --verbose --print-certs $apkPath
    if ($LASTEXITCODE -ne 0) {
        throw 'A verificação da assinatura da APK falhou.'
    }
    Get-FileHash -Algorithm SHA256 -LiteralPath $apkPath |
        Format-List Algorithm, Hash, Path
}
finally {
    Pop-Location
}
