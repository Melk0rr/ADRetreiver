function Get-GroupDetails {
  <#
  .SYNOPSIS
    This script will format group data

  .NOTES
    Name: Get-GroupDetails
    Author: JL
    Version: 1.0
    LastUpdated: 2022-Apr-04

  .EXAMPLE
    Get-GroupDetails -Group $group
  #>

  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [object]  $Group
  )

  BEGIN { $adProps = $ADRetreiverData.ADOProperties | where-object {($_.Type -eq "group")} }

  PROCESS {
    $members = Get-ADGroupMember $Group -Recursive

    $props = $Group | select-object *,`
      @{n='Members'; e={  }},`
      @{n='DomainName'; e={ (Split-DN $Group.DistinguishedName).Domain }}
  }

  END { return $props | select-object $adProps.final }
}