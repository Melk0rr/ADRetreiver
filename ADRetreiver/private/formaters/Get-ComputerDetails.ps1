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
        [string]$computerType = ($os -like "*server*") ? "Server" : "Workstation"

        # Retreiving OS build
        [int]$osBuildNumber = (($Account.OperatingSystemVersion -split ' ')[1].Trim('(', ')'))
        
        [bool]$extendedSupport = $os -match "LTS"

        # Retreive windows editions
        $osEdition = $WinEditions.Where({ ($os -like $_.pattern) })[0]
        [string]$osEdition = $osEdition ? $osEdition.name : "Standard"

        # Defining Windows Edition class
        $osEditionClass = $computerType -eq "Workstation" ? "W" : "Standard"
        if (($osEdition -like "*Enterprise*") -and ($computerType -eq "Workstation")) {
          $osEditionClass = "E"
        }
        if ($extendedSupport) {
          $osEditionClass = "LTS"
        }

        # Retreiving build infos from CSV
        [object]$buildInfos = $WinBuilds[$computerType][$osBuildNumber][$osEditionClass]

        if (!$buildInfos) {
          Write-Host -Message "$($Account.Name) build infos not found !" -f Red
          $buildInfos = @{
            OS              = $os
            Version         = ""
            Release         = ""
            ActiveSupport   = ""
            SecuritySupport = ""
          }
        }

        $osShort = ($computerType -eq "Server") ? "Windows Server $($buildInfos.os)" : "Windows $($buildInfos.os)"

        # Multiple checks relative to end of support
        try {
          [datetime]$endOfSupportDate = (Get-Date $buildInfos.SecuritySupport)
          [int]$supportEndsIn = (Get-Days $endOfSupportDate -reverse)
          [string]$support = ($supportEndsIn -ge 0) ? "Ongoing" : "Retired"

          [string]$supportStatus = if ($support -eq "Ongoing") {
            "Ends in $supportEndsIn days"
          } else {
            "Ended $(-$supportEndsIn) days ago"
          }
        }
        catch {
          Write-Warning "Missing support data for $($Account.name)"
        }
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
      ComputerType        = $computerType ?? "Unknown"
      OSFamily            = $osFamily ?? "Unknown"
      OSShort             = $osShort ?? "Unknown"
      OSFull              = $os ?? "Unknown"
      OSEdition           = $osEdition ?? "Unknown"
      OSVersion           = $buildInfos.Version ?? "Unknown"
      OSBuild             = $osBuildNumber ?? "Unknown"
      "@IPv4"             = $Account.IPV4Address
      HasExtendedSupport  = $extendedSupport
      Support             = $support ?? "Unknown"
      EndOfSupportDate    = $endOfSupportDate
      SupportStatus       = $supportStatus ?? "Unknown"
    }

    [pscustomobject]$Account = Add-Properties $Account $newProps
  } 

  END {
    return $Account
  }
}