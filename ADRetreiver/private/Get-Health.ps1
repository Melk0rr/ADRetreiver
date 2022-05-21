function Get-Health {
  <#
  .SYNOPSIS
    This script computes health and healthflags for a given ad account (user or computer)

  .NOTES
    Name: Get-ScriptModel
    Author: JL
    Version: 1.0
    LastUpdated: 2022-Mar-01

  .EXAMPLE

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
      Mandatory = $true,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [string]  $Type
  )

  BEGIN {
    $health = 100
    $healthFlags = @()
  }

  PROCESS {
    if ($Type -eq "computer") {
      # Remove health if os is no longer supported
      $health -= !$isSupported ? (50 + [math]::truncate((Get-Days (Get-Date $endOfSupportDate)) / 360) * 20) : 0
      $healthFlags += !$isSupported ? "NotSupported" : "Supported"

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

  END { return $Account }
}