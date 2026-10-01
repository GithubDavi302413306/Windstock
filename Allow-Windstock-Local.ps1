# Run from PowerShell as Administrator. Allows only private local networks.
$ErrorActionPreference = 'Stop'
$windstockPython = Join-Path $PSScriptRoot '.venv\Scripts\python.exe'
if (-not (Test-Path -LiteralPath $windstockPython)) { throw 'Windstock Python environment is missing.' }
$windstockIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
$windstockPrincipal = New-Object Security.Principal.WindowsPrincipal($windstockIdentity)
if (-not $windstockPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw 'Open PowerShell as Administrator, then run this script again.'
}
$windstockRules = @(
    @{ Name='Windstock-Local-HTTPS'; Protocol='TCP'; Port=443 },
    @{ Name='Windstock-Local-DNS'; Protocol='UDP'; Port=53 }
)
foreach ($windstockRule in $windstockRules) {
    if (-not (Get-NetFirewallRule -Name $windstockRule.Name -ErrorAction SilentlyContinue)) {
        New-NetFirewallRule -Name $windstockRule.Name -DisplayName $windstockRule.Name -Direction Inbound -Action Allow -Profile Private -RemoteAddress LocalSubnet -Program $windstockPython -Protocol $windstockRule.Protocol -LocalPort $windstockRule.Port | Out-Null
    }
}
Write-Host 'Windstock HTTPS and DNS allowed on private local networks.'
