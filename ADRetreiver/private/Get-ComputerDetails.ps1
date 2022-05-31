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
    $os = (($Account.OperatingSystem -split ' ') -replace '[\W]', '') -join ' '
  }

  PROCESS {
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
        $endOfSupportDate = $extendedSupport ? (Get-Date $buildInfos.ltsEos) : (Get-Date $buildInfos.eos)

      } elseif ($os -like "*Linux*") {
        $osFamily = "Linux"
      } else {
        # Define os family
      }

    }

    # Add computer properties
    $newProps = @(
      @{ n='ComputerType'      ; v=$computerType },
      @{ n='OSFamily'          ; v=$osFamily },
      @{ n='OSShort'           ; v=$osShort },
      @{ n='OSFull'            ; v=$os },
      @{ n='OSEdition'         ; v=$osEdition },
      @{ n='OSVersion'         ; v=$buildInfos.Version },
      @{ n='OSBuild'           ; v=$osBuildNumber },
      @{ n='@IPv4'             ; v=$Account.IPV4Address },
      @{ n='HasExtendedSupport'; v=$extendedSupport },
      @{ n='Support'           ; v=$support },
      @{ n='EndOfSupportDate'  ; v=$endOfSupportDate }
    )

    $Account = Add-Properties $Account $newProps
  } 

  END { return $Account }
}