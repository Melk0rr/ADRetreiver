function Invoke-ADRetreiver {
  <#
  .SYNOPSIS
      This script will get various informations on ad objects based on a given type

  .NOTES
      Name: Invoke-ADRetreiver
      Author: JL
      Version: 2.2
      LastUpdated: 2022-Mar-10

  .EXAMPLE
      $users = Invoke-ADRetreiver -Leads @{Type="user"}

  .EXAMPLE
      $users = Invoke-ADRetreiver -Leads @{Type="user"; Filter={Name -like "*Dupont*"}}

  .EXAMPLE
      $computers = Invoke-ADRetreiver -Leads @{Type="computer"}

  .EXAMPLE
      $gpo = Invoke-ADRetreiver -Leads @{Type="gpo"; Filter={Name -eq "MyGPO"}}

  .EXAMPLE
      $users, $computers = Invoke-ADRetreiver -Leads @{Type="user"}, @{Type="computer"}
  #>

  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [object[]]  $Leads = @{ Type="user" },

    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [int]  $Timeout = 300
  )

  BEGIN {
    Write-Host $banner -f DarkYellow

    # Retreiving domain name
    try { $domain = Get-ADDomain; $domainRoot = $domain.DNSRoot }
    catch { Write-Error "Sorry but I can't find any domain..." }

    Write-Host "If my scent is right, we are on $domainRoot domain !" -f DarkYellow

    $index, $res = 1, @()
  }

  PROCESS {
    Write-Host "I have to explore $($Leads.length) lead(s)..." -f DarkYellow

    foreach ($lead in $Leads) {
      Write-Host "- I'm on lead n°$index !" -f DarkYellow

      # Retreive data
      $adReqTime = 0
      if (!$lead.Data) {
        $adReqTime = Measure-Command {
          $lead = $lead | select-object *,` @{n='Data'; e={ Initialize-Lead -Lead $lead -Timeout $Timeout }}
        }
      } else { Write-Host "Oh, you already have infos for this lead !" -f DarkYellow }
      

      # Change message depending on result
      if (($lead.Data -as [array]).length -eq 0) { Write-Host "-- Sorry, I could not find any $($lead.Type)..." -f Red }
      else {
        Write-Host "I found $(($lead.Data -as [array]).length) $($lead.Type)(s) !" -f Green
        Write-Host "-- Inspection took $(Get-Seconds $adReqTime)s !" -f DarkYellow

        Write-Host "-- I have to gather my discoveries for lead n°$index !" -f DarkYellow

        # Gather data
        $time = Measure-Command { $lead = $lead | select-object *,` @{n='Result'; e={ Complete-Lead -Lead $lead }} }
        Write-Host "-- Gathering took $(Get-Seconds $time)s !" -f DarkYellow

        $res += $lead | select-object * -ExcludeProperty 'Data'
      }

      Write-Host ""
      $index++
    }

    Write-Host "I'm done exploring all leads !" -f Green
  }

  END {
    Write-Host @"
    ============================================================
                          Gooooood BOY !
"@ -f DarkYellow

    return $res
  }
}