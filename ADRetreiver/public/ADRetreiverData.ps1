$ADRetreiverData = @{
  ADAdmins        = Get-ADUser -Filter {(AdminCount -eq 1) -and (Enabled -eq $true)}
  WindowsBuilds   = Get-Content -Path "$PSScriptRoot\conf\win_builds.json"        | ConvertFrom-Json
  WindowsEditions = Get-Content -Path "$PSScriptRoot\conf\win_editions.json"      | ConvertFrom-Json
  ADActivityRules = Get-Content -Path "$PSScriptRoot\conf\ad_rules_activity.json" | ConvertFrom-Json
  ADPwdRules      = Get-Content -Path "$PSScriptRoot\conf\ad_rules_pwd.json"      | ConvertFrom-Json
  ADOProperties   = Get-Content -Path "$PSScriptRoot\conf\ad_properties.json"     | ConvertFrom-Json
}