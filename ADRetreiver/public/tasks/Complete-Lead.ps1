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
    Write-Host "I'm gathering details for $($Lead.Data.length) $type(s)..." -f DarkYellow

    $res, $index = @(), 0
  }

  PROCESS {
    $res += foreach ($object in $Lead.Data) {
      $name = if ($type -eq "gpo") { $object.DisplayName } else { $object.Name }

      # Progress
      $percent = [math]::Round($index / $Lead.Data.length * 100, 2)
      Write-Progress -Activity "Sniffing $type(s) details..." -CurrentOperation "Currently sniffing $name" -Status "$percent% completed..." -PercentComplete $percent

      # Calling appropriate properties formatting function depending on the object type
      try {
        switch ($type) {
          "group" { Get-GroupDetails -Group $object }
          "gpo"   { Get-GPODetails -GPO $object }
          "ou"    { Get-OUDetails -OU $object }
          default { Get-AccountDetails -Account $object -Type $type }
        }
      }
      catch { Write-Error "Something went wrong for $type n°$index $name : `n$_" }

      $index++
    }

    Write-Progress -Activity "I'm done gathering $type details !" -Status "100% completed..." -PercentComplete 100
  }

  END { return $res }
}