function Add-Properties {
  <#
  .SYNOPSIS
    This script will format account data specific to an ad user

  .NOTES
    Name: Add-Properties
    Author: JL
    Version: 1.0
    LastUpdated: 2022-May-30

  .EXAMPLE
    Add-Properties -Object $obj -Properties @{n='age'; v=27}
  #>

  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [object]  $Object,

    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [object[]]  $Properties
  )

  BEGIN {}

  PROCESS {
    foreach ($p in $Properties) { $Object | add-member -MemberType NoteProperty -Name $p.n -Value $p.v -Force }
  }

  END { return $Object }
}