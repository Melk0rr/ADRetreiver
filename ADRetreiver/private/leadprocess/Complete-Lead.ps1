function Complete-Lead {
  <#
  .SYNOPSIS
    Init ADRetreiver

  .NOTES
    Name: Complete-Lead
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
    [object]  $Lead
  )

  BEGIN {
    $type = $Lead.Type
    $leadDataSize = $Lead.Data.count
    Write-Host "I'm gathering details for $leadDataSize $type(s)..."

    [int]$index = 0
    [pscustomobject[]]$res = @()
  }

  PROCESS {
    foreach ($object in $Lead.Data) {
      $props = $null
      [string]$name = ($type -eq "gpo") ? $object.DisplayName : $object.Name

      # Progress
      [float]$percent = [math]::Round($index / $leadDataSize * 100, 2)
      Write-Progress -Activity "Sniffing $type(s) details..." -Status "$percent% completed..." -CurrentOperation "Currently sniffing $name" -PercentComplete $percent

      # Calling appropriate properties formatting function depending on the object type
      try {
        $props = switch ($type) {
          "group" {
            Get-GroupDetails -Group $object -RecursiveMembers:($Lead.RecursiveMembers ?? $false)
          }
          "gpo" {
            Get-GPODetails -GPO $object
          }
          "ou" {
            Get-OUDetails -OU $object
          }
          default {
            Get-AccountDetails -Account $object -Type $type
          }
        }
      }
      catch {
        Write-Error "Something went wrong for $type n°$index $name : `n$_"
      }

      $index++
      $res += $props
    }

    Write-Progress -Activity "Sniffing $type(s) details..." -Status "100% completed..." -Completed
  }

  END {
    return $res
  }
}