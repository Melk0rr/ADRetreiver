$ADRetreiverData = @{
  WindowsBuilds = Get-Content -Path "$PSScriptRoot\src\win_builds.json" | ConvertFrom-Json
  WindowsEditions = Get-Content -Path "$PSScriptRoot\src\win_editions.json" | ConvertFrom-Json
  ADAdmins = Get-ADUser -Filter {(AdminCount -eq 1) -and (Enabled -eq $true)}
  ADActivityRules = Get-Content -Path "$PSScriptRoot\src\ad_rules_activity.json" | ConvertFrom-Json
  ADPwdRules = Get-Content -Path "$PSScriptRoot\src\ad_rules_pwd.json" | ConvertFrom-Json
  ADOProperties = Get-Content -Path "$PSScriptRoot\src\ad_properties.json" | ConvertFrom-Json
}