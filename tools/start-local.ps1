param(
  [string]$ApiDirectory = 'C:\dev\ZimbaControl\apps\api',
  [string]$WebDirectory = 'C:\dev\pixel-perfect-pixels',
  [int]$ApiPort = 3333,
  [int]$WebPort = 8080
)

$ErrorActionPreference = 'Stop'

function Test-ListeningPort([int]$Port) {
  return $null -ne (Get-NetTCPConnection -State Listen -LocalPort $Port -ErrorAction SilentlyContinue)
}

function Wait-ForApi([int]$Port) {
  $deadline = (Get-Date).AddSeconds(25)
  do {
    try {
      $health = Invoke-RestMethod -Uri "http://127.0.0.1:$Port/health" -TimeoutSec 2
      if ($health.ok -eq $true -and $health.storage -eq 'mongodb') { return }
    } catch { }
    Start-Sleep -Milliseconds 500
  } while ((Get-Date) -lt $deadline)
  throw "A API nao respondeu em http://127.0.0.1:$Port/health em 25 segundos."
}

if (-not (Test-Path -LiteralPath $ApiDirectory)) { throw "Diretorio da API nao encontrado: $ApiDirectory" }
if (-not (Test-Path -LiteralPath $WebDirectory)) { throw "Diretorio do painel Web nao encontrado: $WebDirectory" }

if (-not (Test-ListeningPort $ApiPort)) {
  Write-Host "Iniciando API MongoDB na porta $ApiPort..."
  Start-Process -FilePath 'npm.cmd' -ArgumentList 'run', 'dev' -WorkingDirectory $ApiDirectory -WindowStyle Hidden | Out-Null
} else {
  Write-Host "API ja esta escutando na porta $ApiPort."
}

Wait-ForApi $ApiPort
Write-Host "API pronta: MongoDB conectado."

if (-not (Test-ListeningPort $WebPort)) {
  Write-Host "Iniciando painel Web na porta $WebPort..."
  Start-Process -FilePath 'npm.cmd' -ArgumentList 'run', 'dev', '--', '--host', '127.0.0.1' -WorkingDirectory $WebDirectory -WindowStyle Hidden | Out-Null
} else {
  Write-Host "Painel Web ja esta escutando na porta $WebPort."
}

$webDeadline = (Get-Date).AddSeconds(25)
while (-not (Test-ListeningPort $WebPort)) {
  if ((Get-Date) -ge $webDeadline) { throw "O painel Web nao abriu a porta $WebPort em 25 segundos." }
  Start-Sleep -Milliseconds 500
}

Write-Host "Painel pronto: http://127.0.0.1:$WebPort"
