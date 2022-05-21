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
    $props = $Account | select-object DistinguishedName, Name, SID, LastLogonDate, PasswordLastSet, PasswordNotRequired, PasswordNeverExpires, Description

    $props = $props | select-object *,`
      @{n='SAN';                  e = {$Account.SamAccountName}},`
      @{n='DomainName';           e={ (Split-DN $Account.DistinguishedName).Domain }},`
      @{n='Status';               e={ $Account.Enabled ? "Enabled" : "Disabled" }},`
      @{n='CreationDate';         e={ $Account.Created }},`
      @{n='LastChangeDate';       e={ $Account.Modified }},`
      @{n='IsServiceAccount';     e={ $Account.DistinguishedName -like "*OU=Services*" }},`
      @{n='LastLogonDelta';       e={ $Account.LastLogonDate ? (Get-Days (Get-Date $Account.LastLogonDate)) : -1 }},`
      @{n='PasswordLastSetDelta'; e={ $Account.PasswordLastSet ? (Get-Days (Get-Date $Account.PasswordLastSet)) : -1 }}

    # Retreive password and activity rules described in the appropriate CSV file
    $pwdRule = $ADRetreiverData.ADPwdRules | where-object {($props.PasswordLastSetDelta -ge $_.periodStart) -and ($props.PasswordLastSetDelta -lt $_.periodEnd)}
    $activityRule = $ADRetreiverData.ADActivityRules | where-object {($props.LastLogonDelta -ge $_.periodStart) -and ($props.LastLogonDelta -lt $_.periodEnd)}

    # Adding more shared properties: Activity (30d, 90d, 180d, 360d), password status, activity period
    $hasAlreadyLogged = ($props.LastLogonDelta -gt -1)
    $props = $props | select-object *,`
      @{n='PasswordShouldBeReset'; e={ [bool]$pwdRule.ShouldCHange }},`
      @{n='ActivityPeriod'       ; e={ [int]$activityRule.periodEnd }}

    foreach ($activity in @($normalActivity, $elevatedActivity, $highActivity, $severeActivity)) {
      $props = $props | select-object *,` @{n="Active ($($activity.periodEnd)d)"; e={ $hasAlreadyLogged -and ($_.LastLogonDelta -le $activity.periodEnd) }}
    }

    # User specific properties
    if ($Type -eq "user") {
      # Checks if the current account is a privileged account
      $isAdmin = $ADRetreiverData.ADAdmins.DistinguishedName -contains $Account.DistinguishedName

      # Check if current account object is a nominative account
      $isPerson = ($Account.Surname -match $nameReg) -and ($Account.GivenName -match $nameReg) -and !$props.IsServiceAccount

      # Add user properties
      $props = $props | select-object *,`
        @{n='Surname'    ;e={ $Account.Surname }},`
        @{n='GivenName'  ;e={ $Account.GivenName }},`
        @{n='Email'      ;e={ $Account.UserPrincipalName ? ($Account.UserPrincipalName.ToLower()) : $null }},`
        @{n='AccountType';e={ $isPerson ? "Person" : $props.IsServiceAccount ? "Service" : "Other" }},`
        @{n='Permissions';e={ $isAdmin ? "Admin" : "Default" }},`
        @{n='Title'      ;e={ $Account.Title} }

    # Computer specific properties
    } else {
      $os = (($Account.OperatingSystem -split ' ') -replace '[\W]', '') -join ' '

      if ($os -and ($os -notmatch "^[a-zA-Z0-9_]+$")) {
        if ($os -like "*Windows*") {
          $osFamily = "Windows"
          $computerType = !$os ? "Server" : ($os -like "*server*") ? "Server" : "Workstation"

          # Retreiving OS build
          [int]$osBuildNumber = (($Account.OperatingSystemVersion -split ' ')[1].Trim('(', ')'))

          # Retreiving build infos from CSV
          $buildInfos = $ADRetreiverData.WindowsBuilds | where-object {($_.build -eq $osBuildNumber) -and ($_.type -eq $computerType)}
          if (!$buildInfos) { throw "Build infos not found !" }

          $osShort = ($computerType -eq "Server") ? "Windows Server $($buildInfos.os)" : "Windows $($buildInfos.os)"

          # Retreive windows editions
          $osEdition = $ADRetreiverData.WindowsEditions | where-object {($os -like $_.pattern)}
          $osEdition = $osEdition ? $osEdition.name : "Standard"

          # Multiple checks relative to end of support
          $extendedSupport = $os -match "LTSB|LTSC"
          $support = ((Get-Days (Get-Date $buildInfos.eos)) -le 0) ? "Ongoing" : ($extendedSupport -and (Get-Days (Get-Date $buildInfos.ltsEos)) -le 0) ? "Extended" : "Retired"

          $isSupported = ($support -eq "Ongoing") -or ($support -eq "Extended")
          $endOfSupportDate = $extendedSupport ? (Get-Date $buildInfos.ltsEos) : (Get-Date $buildInfos.eos)

        } elseif ($os -like "*Linux*") {
          $osFamily = "Linux"
        } else {
          # Define os family
        }

        # Remove health if os is no longer supported
        $health -= !$isSupported ? (50 + [math]::truncate((Get-Days (Get-Date $endOfSupportDate)) / 360) * 20) : 0
        $healthFlags += !$isSupported ? "NotSupported" : "Supported"
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
    $health -= $isAdmin ? [math]::min(100, [int]$activityRule.healthLoss * 2) : [int]$activityRule.healthLoss
    $healthFlags += $isAdmin ? "Admin$($activityRule.flag)" : $activityRule.flag

    # Remove health if password is expired
    $health -= $isAdmin ? [math]::min(100, [int]$pwdRule.healthLoss * 2) : [int]$pwdRule.healthLoss
    $healthFlags += $isAdmin ? "Admin$($pwdRule.flag)" : $pwdRule.flag

    # Add health properties
    $props = $props | select-object *,` @{n='Health';e={ [math]::max(0, $health) }},` @{n='HealthFlags';e={ $healthFlags -join ';' }}
  }

  END { return $props | select-object $adProps.final }
}