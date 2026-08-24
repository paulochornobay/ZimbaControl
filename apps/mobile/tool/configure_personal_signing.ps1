[CmdletBinding()]
param(
    [string]$SigningDirectory = (Join-Path $env:USERPROFILE '.zimbacontrol'),
    [string]$KeyAlias = 'zimbacontrol-personal'
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($env:USERPROFILE)) {
    throw 'USERPROFILE não está disponível para armazenar a chave local.'
}

New-Item -ItemType Directory -Force -Path $SigningDirectory | Out-Null
$storePath = Join-Path $SigningDirectory 'zimbacontrol-personal-release.jks'
$storePassword = [Environment]::GetEnvironmentVariable(
    'ZIMBA_RELEASE_STORE_PASSWORD',
    'User'
)

if ((Test-Path -LiteralPath $storePath) -and
    [string]::IsNullOrWhiteSpace($storePassword)) {
    throw 'A chave já existe, mas a senha local não está configurada. Não sobrescreva a chave.'
}

if ([string]::IsNullOrWhiteSpace($storePassword)) {
    $bytes = New-Object byte[] 32
    $random = New-Object Security.Cryptography.RNGCryptoServiceProvider
    $random.GetBytes($bytes)
    $random.Dispose()
    $storePassword = -join ($bytes | ForEach-Object { $_.ToString('x2') })
}

$variables = @{
    ZIMBA_RELEASE_STORE_FILE = $storePath
    ZIMBA_RELEASE_STORE_PASSWORD = $storePassword
    ZIMBA_RELEASE_KEY_ALIAS = $KeyAlias
    ZIMBA_RELEASE_KEY_PASSWORD = $storePassword
}

foreach ($entry in $variables.GetEnumerator()) {
    [Environment]::SetEnvironmentVariable($entry.Key, $entry.Value, 'User')
    Set-Item -Path "Env:$($entry.Key)" -Value $entry.Value
}

$keytool = Join-Path $env:JAVA_HOME 'bin\keytool.exe'
if (-not (Test-Path -LiteralPath $keytool)) {
    $keytool = 'C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe'
}
if (-not (Test-Path -LiteralPath $keytool)) {
    throw 'keytool não encontrado. Instale/configure o Android Studio ou o JDK 17.'
}

if (-not (Test-Path -LiteralPath $storePath)) {
    & $keytool -genkeypair -v `
        -keystore $storePath `
        -storepass $storePassword `
        -keypass $storePassword `
        -alias $KeyAlias `
        -keyalg RSA `
        -keysize 4096 `
        -validity 10000 `
        -dname 'CN=ZimbaControl Personal Release, OU=Personal, O=ZimbaControl, C=BR'
    if ($LASTEXITCODE -ne 0) {
        throw 'Não foi possível gerar a chave pessoal de release.'
    }
}

Write-Host 'Assinatura pessoal configurada fora do Git.'
& $keytool -list -v `
    -keystore $storePath `
    -storepass $storePassword `
    -alias $KeyAlias |
    Select-String -Pattern 'SHA256:'
