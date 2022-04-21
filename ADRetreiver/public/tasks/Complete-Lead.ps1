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
    Write-Host "-- I'm gathering details for $(($Lead.Data -as [array]).length) $type(s)..." -f DarkYellow

    $res, $index = @(), 0
  }

  PROCESS {
    $res += foreach ($object in $Lead.Data) {
      $name = if ($type -eq "gpo") { $object.DisplayName } else { $object.Name }

      # Progress
      $percent = [math]::Round($index / ($Lead.Data -as [array]).length * 100, 2)
      Write-Progress -Activity "-- Sniffing $type(s) details..." -CurrentOperation "Currently sniffing $name" -Status "$percent% completed..." -PercentComplete $percent

      # Calling appropriate properties formatting function depending on the object type
      try {
        $props = switch ($type) {
          "group" { Get-GroupDetails -Group $object -RecursiveMembers:($Lead.RecursiveMembers ?? $false) }
          "gpo"   { Get-GPODetails -GPO $object }
          "ou"    { Get-OUDetails -OU $object }
          default { Get-AccountDetails -Account $object -Type $type }
        }
      }
      catch { Write-Error "Something went wrong for $type n°$index $name : `n$_" }

      $index++
      $props
    }

    Write-Progress -Activity "Sniffing $type(s) details..." -Status "100% completed..." -Completed
  }

  END { return $res }
}