function Format-Lead {
  <#
  .SYNOPSIS
    Format a lead

  .NOTES
    Name: Format-Lead
    Author: JL
    Version: 1.0
    LastUpdated: 2022-Apr-05

  .EXAMPLE

  #>

  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [object]  $Lead,

    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [int]  $LeadNumber
  )

  BEGIN { Write-Host "Investigating lead n°$LeadNumber..." }

  PROCESS {
    # Retreive data
    if (!$lead.Data) {
      $lead | add-member -MemberType NoteProperty -Name 'Data' -Value (Format-Lead -Lead $lead -Timeout $Timeout)
    }
    else { Write-Host "Oh, you already have infos for this lead !" }
    
    # Change message depending on result
    if ($lead.Data.length -eq 0) { Write-Host "Sorry, I could not find any $($lead.Type)..." -f Red }
    else {
      Write-Host "I found $($lead.Data.length) $($lead.Type)(s) !" -f Green
      Write-Host "Gathering my discoveries..."

      # Gather data
      $lead | add-member -MemberType NoteProperty -Name 'Result' -Value (Complete-Lead -Lead $lead) -Force
      $res += $lead | select-object * -ExcludeProperty 'Data'
    }

    $index++
  }

  END { return $lead }
}