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
    [object]  $Group,

    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [switch]  $RecursiveMembers
  )

  BEGIN {
    [object]$adProps = $ADProperties.Where({ $_.Type -eq "group" })[0]

    # Handle parameters
    $memberParams = @{
      Identity = $Group.DistinguishedName
    }
    if ($RecursiveMembers.IsPresent) {
      $memberParams.Add('Recursive', $RecursiveMembers)
    }
  }

  PROCESS {
    [object[]]$members = Get-ADGroupMember @memberParams

    [pscustomobject]$props = @{
      DistinguishedName = $Group.DistinguishedName
      Name              = $Group.Name
      SID               = $Group.SID
      DomainName        = (Split-DN $Group.DistinguishedName).Domain
      Category          = $Group.GroupCategory
      Scope             = $Group.GroupScope
      Members           = $members
      CreationDate      = $Group.Created
      LastChangeDate    = $Group.Modified
      MemberOf          = $Group.MemberOf
      Description       = $Group.Description
    }
  }

  END {
    return $props | select-object $adProps.final
  }
}