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
    [object[]]  $Leads = @{ Type = "user" },

    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [switch]  $MinBanner,

    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [switch]  $HideBanner,

    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [int]  $Timeout = 300
  )

  BEGIN {
    $scriptBanner = $MinBanner.IsPresent ? $bannerMin : $banner
    if (!$HideBanner.IsPresent) { Write-Host $scriptBanner -f DarkYellow }

    # Retreiving domain name
    $domain = Get-ADDomain; $domainRoot = $domain.DNSRoot
    if (!$domain) { throw "Sorry but I can't find any domain..." }

    $startTime = Get-Date -Format "dddd-MM-yyyy HH:mm:ss"

    Write-Host "If my scent is right, we are on $domainRoot domain !"
    Write-Host "* Starting the work - $startTime *"

    $index, $res = 1, @()
  }

  PROCESS {
    Write-Host "Exploring $($Leads.length) lead(s)..."

    foreach ($lead in $Leads) {
      $res += Format-Lead -Lead $lead -LeadNumber $index
      $index++
    }    
  }

  END {
    $endTime = Get-Date
    Write-Host "I'm done exploring all leads !" -f Green
    Write-Host "Investigation took me $(Get-TimeDiff $startTime $endTime)"

    return $res
  }
}