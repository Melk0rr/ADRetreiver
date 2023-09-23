function Get-UserDetails {
  <#
  .SYNOPSIS
    This script will format account data specific to an ad user

  .NOTES
    Name: Get-UserDetails
    Author: JL
    Version: 1.0
    LastUpdated: 2022-May-30

  .EXAMPLE
    Get-UserDetails -Account $account
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
    # Name regex
    [regex]$nameReg = "^[a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð ,.'-]+$"
  }

  PROCESS {
    # Checks if the current account is a privileged account
    [bool]$isAdmin = $ADAdmins.DistinguishedName.Contains($Account.DistinguishedName)

    # Check if current account object is a nominative account
    [bool]$isPerson = ($Account.Surname -match $nameReg) -and ($Account.GivenName -match $nameReg) -and !$Account.IsServiceAccount

    # Add user properties
    $newProps = @{
      Email       = ($Account.EmailAddress ? $Account.EmailAddress.ToLower() : $null)
      AccountType = ($isPerson ? "Person" : $Account.IsServiceAccount ? "Service" : "Other")
      Permissions = ($isAdmin ? "Admin" : "Default")
    }

    [pscustomobject]$Account = Add-Properties $Account $newProps
  }

  END {
    return $Account
  }
}