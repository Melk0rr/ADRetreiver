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
    [object]$adProps = $ADProperties.Where({ $_.Type -eq "gpo" })[0]
  }

  PROCESS {

    try {
      [object[]]$ouWithLink = Get-ADOrganizationalUnit -Filter * -Properties gpLink
      [object[]]$impactedOUs = $ouWithLink.Where({ $_.gpLink -like "*$($GPO.id)*" })
    }
    catch {
      Write-Error "Error while trying to retreive OUs impacted by GPO $($GPO.DisplayName)"
    }

    $gpoProps = @{
      ImpactedOUs = $impactedOUs
      ID          = $GPO.ID
      Name        = $GPO.DisplayName
    }

    [pscustomobject]$GPO = Add-Properties $GPO $gpoProps
  }

  END {
    return $GPO | select-object $adProps.final
  }
}