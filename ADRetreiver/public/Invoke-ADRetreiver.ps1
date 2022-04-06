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
    [object[]]  $Leads = @{ Type="user" }
  )

  BEGIN {
    Write-Host $banner -ForegroundColor DarkYellow

    # Retreiving domain name
    try { $domain = Get-ADDomain; $domainRoot = $domain.DNSRoot }
    catch { Write-Error "Sorry but I can't find any domain..." }

    Write-Host "If my scent is right, we are on $domainRoot domain !" -f DarkYellow
  }

  PROCESS {
    Write-Host "I have to inspect $($Leads.length) lead(s)..." -f DarkYellow

    # Retreive data
    $exploredLeads = @()
    foreach ($lead in $Leads) {
      $time = Measure-Command { $exploredLeads += Initialize-Lead -Lead $lead -Domain $domainRoot }
      Write-Host "Inspection took $($time.Minutes * 60 + $time.Seconds).$($time.Milliseconds)s !" -f DarkYellow
    }

    Write-Host "I have to gather my discoveries for $($exploredLeads.length) lead(s)..." -f DarkYellow

    # Gather data
    $completedLeads = @()
    foreach ($lead in $exploredLeads) {
      $time = Measure-Command { $completedLeads += Complete-Lead -Lead $lead }
      Write-Host "Gathering took $($time.Minutes * 60 + $time.Seconds).$($time.Milliseconds)s !" -f DarkYellow
    }

    Write-Host "I'm done exploring all leads !" -f Green
  }

  END {
    Write-Host @"
    ============================================================
                          Gooooood BOY !
"@ -ForegroundColor DarkYellow

    return $completedLeads
  }
}