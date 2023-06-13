function Get-OUDetails {
  <#
  .SYNOPSIS
    This script will format OU data

  .NOTES
    Name: Get-OUDetails
    Author: JL
    Version: 1.0
    LastUpdated: 2022-Mar-16

  .EXAMPLE
    Get-OUDetails -GPO $gpo
  #>

  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [object]  $OU
  )

  BEGIN {
    [object]$adProps = $ADProperties.Where({ ($_.Type -eq "ou") })[0]
  }

  PROCESS {
    $ouProps = @{
      DomainName = (Split-DN $OU.DistinguishedName).Domain
      Users      = Get-ADUser -SearchBase $OU -Filter *
      Computers  = Get-ADComputer -SearchBase $OU -Filter *
      SubOUs     = Get-ADOrganizationalUnit -SearchBase $OU -Filter *
    }

    [pscustomobject]$OU = Add-Properties $OU $ouProps
  }

  END {
    return $OU | select-object $adProps.final
  }
}