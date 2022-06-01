function Get-GPODetails {
  <#
  .SYNOPSIS
    This script will format gpo data

  .NOTES
    Name: Get-GPODetails
    Author: JL
    Version: 1.0
    LastUpdated: 2022-Mar-16

  .EXAMPLE
    Get-GPODetails -GPO $gpo
  #>

  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [object]  $GPO
  )

  BEGIN {
    $adProps = $ADRetreiverData.ADOProperties.Where({ $_.Type -eq "gpo" })
  }

  PROCESS {

    try {
      $ouWithLink = Get-ADOrganizationalUnit -Filter * -Properties gpLink
      $impactedOUs = $ouWithLink.Where({ $_.gpLink -like "*$($GPO.id)*" })
    }
    catch { Write-Error "Error while trying to retreive OUs impacted by GPO $($GPO.DisplayName)" }

    $props = $GPO | select-object *,` @{n='ImpactedOUs'; e={ $impactedOUs }},` @{n='ID'; e={$_.Id}},` @{n='Name'; e={$_.DisplayName}} -ExcludeProperty Id, DisplayName
  }

  END { return $props | select-object $adProps.final }
}