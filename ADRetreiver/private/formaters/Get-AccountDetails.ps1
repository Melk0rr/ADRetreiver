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
    [pscustomobject]  $Account,

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
    $noActivity,
    $normalActivity,
    $elevatedActivity,
    $highActivity,
    $severeActivity,
    $criticalActivity = $ADActivityRules

    $adProps = $ADProperties.Where({ $_.type -eq $Type })[0]
  }

  PROCESS {
    # Defining basic shared properties
    $baseProps = @{
      SAN                  = ($Account.SamAccountName)
      DomainName           = ((Split-DN $Account.DistinguishedName).Domain)
      Status               = ($Account.Enabled ? "Enabled" : "Disabled")
      CreationDate         = ($Account.Created)
      LastChangeDate       = ($Account.Modified)
      IsServiceAccount     = ($Account.SamAccountName -like "svc*")
      LastLogonDelta       = ($Account.LastLogonDate ? (Get-Days (Get-Date $Account.LastLogonDate)) : -1)
      PasswordLastSetDelta = ($Account.PasswordLastSet ? (Get-Days (Get-Date $Account.PasswordLastSet)) : -1)
    }
    
    [pscustomobject]$props = Add-Properties ([pscustomobject]$Account) $baseProps

    # Retreive password and activity rules described in the appropriate CSV file
    [object]$pwdRule = $ADPasswordRules.Where({ ($props.PasswordLastSetDelta -ge $_.periodStart) -and ($props.PasswordLastSetDelta -lt $_.periodEnd) })[0]
    [object]$activityRule = $ADActivityRules.Where({ ($props.LastLogonDelta -ge $_.periodStart) -and ($props.LastLogonDelta -lt $_.periodEnd) })[0]

    [bool]$passwordShouldChange = $pwdRule.ShouldChange
    [int]$activityEnd = $activityRule.periodEnd

    # Adding more shared properties: Activity (30d, 90d, 180d, 360d), password status, activity period
    $activityProps = @{
      PasswordShouldBeReset = $passwordShouldChange
      ActivityPeriod        = $activityEnd
      ActivityRule          = $activityRule
      PwdRule               = $pwdRule
      HasLoggedOnce         = ($props.LastLogonDelta -gt -1)
    }

    [pscustomobject]$props = Add-Properties $props $activityProps

    foreach ($activity in @($normalActivity, $elevatedActivity, $highActivity, $severeActivity)) {
      $activityPropName = "Active ($($activity.periodEnd)d)"
      $activityPropValue = ($props.LastLogonDelta -le $activity.periodEnd)
      $props | add-member -MemberType NoteProperty -Name $activityPropName -Value $activityPropValue -Force
    }

    # Complete properties with health and type related data
    [pscustomobject]$props = ($Type -eq "user") ? (Get-UserDetails $props) : (Get-ComputerDetails $props)
    [pscustomobject]$props = Get-Health -Account $props -Type $Type
  }

  END {
    return $props | select-object $adProps.final
  }
}