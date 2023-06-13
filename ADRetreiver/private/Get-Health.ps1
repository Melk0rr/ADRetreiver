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
    # Initializing base values
    [int]$health = 100
    [string[]]$healthFlags = @()
  }

  PROCESS {
    if ($Type -eq "computer") {
      if ($Account.computerType -ne 'Unknown') {
        [bool]$isSupported = @("Ongoing", "Extended").Contains($Account.support)

        # Remove health if os is no longer supported
        $health -= !$isSupported ? (50 + [math]::truncate((Get-Days (Get-Date $Account.endOfSupportDate)) / 360) * 20) : 0
        $healthFlags += !$isSupported ? "NotSupported" : "Supported"
        
      }
      else { $health = 0; $healthFlags += 'NoOSData' }
    }

    # If the password is not required, immediately set health to 0
    if ($Account.passwordNotRequired) { $health = 0; $healthFlags += "PwdNotRequired" }
    if ($Account.passwordNeverExpires) { $health -= 50; $healthFlags += "PwdNeverExpires" }

    # Remove health if the user has not logged in a while
    [object]$activityRule = $Account.activityRule
    [object]$pwdRule = $Account.pwdRule
    
    $health -= $isAdmin ? [math]::min(100, [int]$activityRule.healthLoss * 2) : [int]$activityRule.healthLoss
    $healthFlags += $isAdmin ? "Admin$($activityRule.flag)" : $activityRule.flag

    # Remove health if password is expired
    $health -= $isAdmin ? [math]::min(100, [int]$pwdRule.healthLoss * 2) : [int]$pwdRule.healthLoss
    $healthFlags += $isAdmin ? "Admin$($pwdRule.flag)" : $pwdRule.flag

    $healthProps = @{
      Health      = ([math]::max(0, $health))
      HealthFlags = ($healthFlags -join ';')
    }

    [pscustomobject]$Account = Add-Properties $Account $healthProps
  }

  END { 
    return $Account
  }
}