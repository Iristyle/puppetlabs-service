[CmdletBinding()]
param(
  # NOTE: init.json cannot yet be shared, so must have windows.json / windows.ps1
  [Parameter(Mandatory = $true)]
  [String]
  $Name,

  [Parameter(Mandatory = $true)]
  [ValidateSet('start', 'stop', 'restart', 'enable_automatic', 'enable_manual', 'disable', 'status')]
  [String]
  $Action
)

$ErrorActionPreference = 'Stop'

$service = Get-Service -Name $Name
switch ($Action)
{
  'start'     { Start-Service $service }
  'stop'      { Stop-Service $service }
  'restart'   { Restart-Service $service }
  'enable_automatic' { $service | Set-Service -StartupType 'Automatic' }
  'enable_manual'    { $service | Set-Service -StartupType 'Manual' }
  'disable'          { $service | Set-Service -StartupType 'Disabled' }
  'status'    {} # no-op since status always returned
}

# TODO: could use ConvertTo-Json, but that requires PS3
# if embedding in literal, should make sure Name / Status doesn't need escaping
Write-Host @"
{
  "Name"   : "$($service.Name)",
  "Status" : "$($service.Status)",
  "StartType" : "$($service.StartType)"
}
"@
