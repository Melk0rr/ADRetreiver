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
    $noActivity, $normalActivity, $elevatedActivity, $highActivity, $severeActivity, $criticalActivity = $ADActivityRules
    $adProps = $ADProperties.Where({ $_.type -eq $Type })
  }

  PROCESS {
    # Defining basic shared properties
    $baseProps = @(
      @{ n = 'SAN'                 ; v = ($Account.SamAccountName) },
      @{ n = 'DomainName'          ; v = ((Split-DN $Account.DistinguishedName).Domain) },
      @{ n = 'Status'              ; v = ($Account.Enabled ? "Enabled" : "Disabled") },
      @{ n = 'CreationDate'        ; v = ($Account.Created) },
      @{ n = 'LastChangeDate'      ; v = ($Account.Modified) },
      @{ n = 'IsServiceAccount'    ; v = ($Account.DistinguishedName -like "*OU=Services*") },
      @{ n = 'LastLogonDelta'      ; v = ($Account.LastLogonDate ? (Get-Days (Get-Date $Account.LastLogonDate)) : -1) },
      @{ n = 'PasswordLastSetDelta'; v = ($Account.PasswordLastSet ? (Get-Days (Get-Date $Account.PasswordLastSet)) : -1) }
    )
    
    [pscustomobject]$props = Add-Properties ([pscustomobject]$Account) $baseProps

    # Retreive password and activity rules described in the appropriate CSV file
    $pwdRule = $ADPasswordRules.Where({ ($props.PasswordLastSetDelta -ge $_.periodStart) -and ($props.PasswordLastSetDelta -lt $_.periodEnd) })
    $activityRule = $ADActivityRules.Where({ ($props.LastLogonDelta -ge $_.periodStart) -and ($props.LastLogonDelta -lt $_.periodEnd) })

    # Adding more shared properties: Activity (30d, 90d, 180d, 360d), password status, activity period
    $hasAlreadyLogged = ($props.LastLogonDelta -gt -1)
    $activityProps = @(
      @{ n = 'PasswordShouldBeReset'; v = ([bool]$pwdRule.ShouldCHange) },
      @{ n = 'ActivityPeriod'       ; v = ([int]$activityRule.periodEnd) },
      @{ n = 'ActivityRule'         ; v = ($activityRule) },
      @{ n = 'PwdRule'              ; v = ($pwdRule) }
    )

    $props = Add-Properties $props $activityProps

    foreach ($activity in @($normalActivity, $elevatedActivity, $highActivity, $severeActivity)) {
      $props = Add-Properties $props @{ n = "Active ($($activity.periodEnd)d)"; v = ($hasAlreadyLogged -and ($props.LastLogonDelta -le $activity.periodEnd)) }
    }

    # Complete properties with health and type related data
    $props = ($Type -eq "user") ? (Get-UserDetails $props) : (Get-ComputerDetails $props)
    $props = Get-Health -Account $props -Type $Type
  }

  END { return $props | select-object $adProps.final }
}