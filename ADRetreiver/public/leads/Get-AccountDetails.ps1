function Get-AccountDetails {
  <#
  .SYNOPSIS
    This script will format ad user/computer account data

  .NOTES
    Name: Get-AccountDetails
    Author: JL
    Version: 1.0
    LastUpdated: 2022-Feb-23

  .EXAMPLE
    Get-AccountDetails -Account $account

  .EXAMPLE
    Get-AccountDetails -Type computer -Account $account
  #>

  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [object]  $Account,

    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [string]  $Type = "user"
  )

  BEGIN {
    # Checking if a correct Type value has been provided
    if ("user", "computer" -notcontains $Type) { throw "$Type is not a valid account type ! Please use user, or computer" }

    # Activity rules
    $noActivity, $normalActivity, $elevatedActivity, $highActivity, $severeActivity, $criticalActivity = $ADRetreiverData.ADActivityRules
    $adProps = $ADRetreiverData.ADOProperties | where-object {($_.type -eq $Type)}

    # Various regex
    $nameReg = "^[a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð ,.'-]+$"

    # Initializing account health values
    $health, $healthFlags = 100, @()
  }

  PROCESS {
    # Defining basic shared properties
    $lastLogon, $pwdLastSet = $Account.LastLogonDate, $Account.PasswordLastSet

    $props = [PSCustomObject]@{
      DistinguishedName    = $Account.DistinguishedName
      Name                 = $Account.Name
      SAN                  = $Account.SamAccountName
      SID                  = $Account.SID
      DomainName           = (Split-DN $Account.DistinguishedName).Domain
      Status               = if ($Account.Enabled) { "Enabled" } else { "Disabled" }
      CreationDate         = $Account.Created
      LastChangeDate       = $Account.Modified
      IsServiceAccount     = $Account.DistinguishedName -like "*OU=Services*"
      LastLogonDate        = $lastLogon
      LastLogonDelta       = if ($lastLogon) { Get-Days $lastLogon } else { -1 }
      PasswordNotRequired  = $Account.PasswordNotRequired
      PasswordNeverExpires = $Account.PasswordNeverExpires
      PasswordLastSet      = $pwdLastSet
      PasswordLastSetDelta = if ($pwdLastSet) { Get-Days $pwdLastSet } else { -1 }
      Description          = $Account.Description
    }

    # Retreive password and activity rules described in the appropriate CSV file
    $pwdRule = $ADRetreiverData.ADPwdRules | where-object {($props.PasswordLastSetDelta -ge $_.periodStart) -and ($props.PasswordLastSetDelta -lt $_.periodEnd)}
    $activityRule = $ADRetreiverData.ADActivityRules | where-object {($props.LastLogonDelta -ge $_.periodStart) -and ($props.LastLogonDelta -lt $_.periodEnd)}

    # Adding more shared properties: Activity (30d, 90d, 180d, 360d), password status, activity period
    $props = $props | select-object *,`
      @{n='PasswordShouldBeReset'                   ;e={ $pwdRule.ShouldCHange }},`
      @{n='ActivityPeriod'                          ;e={ [int]$activityRule.periodEnd }},`
      @{n="Active ($($normalActivity.periodEnd)d)"  ;e={ ($_.LastLogonDelta -gt -1) -and ($_.LastLogonDelta -le $normalActivity.periodEnd) }},`
      @{n="Active ($($elevatedActivity.periodEnd)d)";e={ ($_.LastLogonDelta -gt -1) -and ($_.LastLogonDelta -le $elevatedActivity.periodEnd) }},`
      @{n="Active ($($highActivity.periodEnd)d)"    ;e={ ($_.LastLogonDelta -gt -1) -and ($_.LastLogonDelta -le $highActivity.periodEnd) }},`
      @{n="Active ($($severeActivity.periodEnd)d)"  ;e={ ($_.LastLogonDelta -gt -1) -and ($_.LastLogonDelta -le $severeActivity.periodEnd) }}

    # User specific properties
    if ($Type -eq "user") {
      # Checks if the current account is a privileged account
      $isAdmin = $ADRetreiverData.ADmins.DistinguishedName -contains $Account.DistinguishedName

      # Check if current account object is a nominative account
      $isPerson = ($Account.Surname -match $nameReg) -and ($Account.GivenName -match $nameReg) -and !$props.IsServiceAccount

      # Add user properties
      $props = $props | select-object *,`
        @{n='Surname'    ;e={ $Account.Surname }},`
        @{n='GivenName'  ;e={ $Account.GivenName }},`
        @{n='Email'      ;e={ if ($Account.EmailAddress) { $Account.EmailAddress.ToLower() } else { $null } }},`
        @{n='AccountType';e={ if ($isPerson) { "Person" } else {if ($props.IsServiceAccount) { "Service" } else { "Other" }} }},`
        @{n='Permissions';e={ if ($isAdmin) { "Admin" } else { "Default" } }},`
        @{n='Title'      ;e={ $Account.Title} }

    # Computer specific properties
    } else {
      $os = (($Account.OperatingSystem -split ' ') -replace '[\W]', '') -join ' '

      if ($os -and ($os -notmatch "^[a-zA-Z0-9_]+$")) {
        if ($os -like "*Windows*") {
          $osFamily = "Windows"
          $computerType = if (!$os) { "Server" } else { if ($os -like "*server*") { "Server" } else { "Workstation" } }

          # Retreiving OS build and version
          $osVersionInfos = $Account.OperatingSystemVersion -split ' '
          $osBuildNumber = [int]$OSVersionInfos[1].Trim('(', ')')

          # Retreiving build infos from CSV
          $buildInfos = $ADRetreiverData.WindowsBuilds | where-object {($_.build -eq $osBuildNumber) -and ($_.type -eq $computerType)}
          if (!$buildInfos) { throw "Build infos not found !" }

          $osShort = if ($computerType -eq "Server") { "Windows Server $($buildInfos.os)" } else { "Windows $($buildInfos.os)" }

          # Retreive windows editions
          $osEdition = $ADRetreiverData.WindowsEditions | where-object {($os -like $_.pattern)}
          $osEdition = if ($osEdition) { $osEdition.name } else { "Standard" }

          # Multiple checks relative to end of support
          $extendedSupport = $os -match "LTSB|LTSC"
          $support = if ((Get-Days (Get-Date $buildInfos.eos)) -le 0) { "Ongoing" }
            else { if ($extendedSupport -and (Get-Days (Get-Date $buildInfos.ltsEos)) -le 0) { "Extended" } else { "Retired" } }

          $isSupported = ($support -eq "Ongoing") -or ($support -eq "Extended")
          $endOfSupportDate = if ($extendedSupport) { Get-Date $buildInfos.ltsEos } else { Get-Date $buildInfos.eos }

        } elseif ($os -like "*Linux*") {
          $osFamily = "Linux"
        } else {
          # Define os family
        }

        # Remove health if os is no longer supported
        $health -= if (!$isSupported) { (50 + [math]::truncate((Get-Days $endOfSupportDate) / 360) * 20) } else { 0 }
        $healthFlags += if (!$isSupported) { "NotSupported" } else { "Supported" }
      } else { $computerType = "Server"; $health = 0; $healthFlags += "NoOSDataFound" }

      # Add computer properties
      $props = $props | select-object *,`
        @{n='ComputerType'      ;e={ $computerType }},`
        @{n='OSFamily'          ;e={ $osFamily }},`
        @{n='OSShort'           ;e={ $osShort}},`
        @{n='OSFull'            ;e={ $os }},`
        @{n='OSEdition'         ;e={ $osEdition }},`
        @{n='OSVersion'         ;e={ $buildInfos.Version }},`
        @{n='OSBuild'           ;e={ $osBuildNumber }},`
        @{n='@IPv4'             ;e={ $Account.IPV4Address }},`
        @{n='HasExtendedSupport';e={ $extendedSupport }},`
        @{n='Support'           ;e={ $support }}
    }

    # Health loss
    # If the password is not required immediately set health to 0
    if ($props.PasswordNotRequired) { $health = 0; $healthFlags += "PwdNotRequired" }

    # Remove health if the user has not logged in a while
    $health -= if ($isAdmin) { [math]::min(100, [int]$activityRule.healthLoss * 2) } else { [int]$activityRule.healthLoss }
    $healthFlags += if ($isAdmin) { "Admin$($activityRule.flag)" } else { $activityRule.flag }

    # Remove health if password is expired
    $health -= if ($isAdmin) { [math]::min(100, [int]$pwdRule.healthLoss * 2) } else { [int]$pwdRule.healthLoss }
    $healthFlags += if ($isAdmin) { "Admin$($pwdRule.flag)" } else { $pwdRule.flag }

    # Add health properties
    $props = $props | select-object *,` @{n='Health';e={ [math]::max(0, $health) }},` @{n='HealthFlags';e={ $healthFlags -join ';' }}
  }

  END { return $props | select-object $adProps.final }
}