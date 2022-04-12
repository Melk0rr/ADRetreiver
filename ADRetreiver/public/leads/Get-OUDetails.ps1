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

  BEGIN { $adProps = $ADRetreiverData.ADOProperties | where-object {($_.Type -eq "ou")} }

  PROCESS {
    $props = $OU | select-object *,`
      @{n='DomainName'; e={ (Split-DN $OU.DistinguishedName).Domain }}
      @{n='Users'; e={ Get-ADUser -SearchBase $OU -Filter * }},`
      @{n='Computers'; e={ Get-ADComputer -SearchBase $OU -Filter * }},`
      @{n='SubOUs'; e={ Get-ADOrganizationalUnit -SearchBase $OU -Filter * }}
  }

  END { return $props | select-object $adProps.final }
}