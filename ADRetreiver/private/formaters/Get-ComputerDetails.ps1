function Get-ComputerDetails {
  <#
  .SYNOPSIS
    This script will format account data specific to an ad computer

  .NOTES
    Name: Get-ComputerDetails
    Author: JL
    Version: 1.0
    LastUpdated: 2022-May-30

  .EXAMPLE
    Get-ComputerDetails -Account $account
  #>

  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [object]  $Account
  )

  BEGIN {
    [string]$os = (($Account.OperatingSystem -split ' ') -replace '[\W]', '') -join ' '
  }

  PROCESS {
    if ($os -and ($os -notmatch "^[a-zA-Z0-9_]+$")) {

      if ($os -like "*Windows*") {
        [string]$osFamily = "Windows"
        [string]$computerType = !$os ? "Server" : ($os -like "*server*") ? "Server" : "Workstation"

        # Retreiving OS build
        [int]$osBuildNumber = (($Account.OperatingSystemVersion -split ' ')[1].Trim('(', ')'))

        # Retreiving build infos from CSV
        [object]$buildInfos = $WinBuilds.Where({ ($_.build -eq $osBuildNumber) -and ($_.type -eq $computerType) })[0]
        if (!$buildInfos) {
          Write-Host -Message "$($Account.Name) build infos not found !" -f Red
          $buildInfos = @{
            OS      = $osFamily
            Name    = $os
            Type    = ""
            Build   = $osBuildNumber
            Version = ""
            Release = ""
            EOS     = ""
            LTSEoS  = ""
          }
        }

        [string]$osShort = ($computerType -eq "Server") ? "Windows Server $($buildInfos.os)" : "Windows $($buildInfos.os)"

        # Retreive windows editions
        $osEdition = $WinEditions.Where({ ($os -like $_.pattern) })[0]
        [string]$osEdition = $osEdition ? $osEdition.name : "Standard"

        # Multiple checks relative to end of support
        [bool]$extendedSupport = $os -match "LTSB|LTSC"
        [string]$support = ((Get-Days (Get-Date $buildInfos.eos)) -le 0) ? "Ongoing" : "Retired"
        if ($extendedSupport -and (Get-Days (Get-Date $buildInfos.ltsEos))) {
          $support = "Extended"
        }

        [datetime]$endOfSupportDate = $extendedSupport ? (Get-Date $buildInfos.ltsEos) : (Get-Date $buildInfos.eos)

      }
      elseif ($os -like "*Linux*") {
        $osFamily = "Linux"
      }
      else {
        # Define os family
      }

    }
    else {
      $computerType = "Unknown"
    }

    # Add computer properties
    $newProps = @{
      ComputerType       = $computerType
      OSFamily           = $osFamily
      OSShort            = $osShort
      OSFull             = $os
      OSEdition          = $osEdition
      OSVersion          = $buildInfos.Version
      OSBuild            = $osBuildNumber
      "@IPv4"            = $Account.IPV4Address
      HasExtendedSupport = $extendedSupport
      Support            = $support
      EndOfSupportDate   = $endOfSupportDate
    }

    [pscustomobject]$Account = Add-Properties $Account $newProps
  } 

  END {
    return $Account
  }
}