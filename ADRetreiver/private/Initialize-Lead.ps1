function Initialize-Lead {
  <#
  .SYNOPSIS
    Init ADRetreiver

  .NOTES
    Name: Initialize-Lead
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
      Mandatory = $false,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [int]  $Timeout = 300,

    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [int]  $WaitStep = 5
  )

  BEGIN {

    # Checking if a correct Type value has been provided
    if (!$Lead.Type) { throw "I don't know what I'm looking for..." }

    # Retreiving domain name
    $domain = (Get-ADDomain).DNSRoot

    if ("object", "user", "computer", "group", "gpo", "ou" -notcontains $Lead.Type) {
      throw "I don't recognize $($Lead.Type) lead... I can only investigate the following types: object, user, group, computer, ou."
    }

    # Set initial parameters. If searchbase is set : add it to parameters
    $params = @{
      Properties = ($ADRetreiverData.ADOProperties | where-object { $_.type -eq $Lead.Type }).initial
      Filter = $Lead.Filter ?? "*"
    }
    if ($Lead.SearchBase) { $params.SearchBase = $Lead.SearchBase }
  }

  PROCESS {

    Write-Host "-- I'm looking for $($Lead.Type)(s) $(if ($Lead.SearchBase) { "from $($Lead.SearchBase) " })in $domain" -f DarkYellow -NoNewline

    # Retreiving data from AD can take a while : we create a thread and show a waiting indicator in the meantime
    $job = Start-ThreadJob -ScriptBlock {
      param($l, $p)

      try {
        # Type dependent AD requests
        switch ($l.Type) {
          "user"     { Get-ADUser @p }
          "computer" { Get-ADComputer @p }
          "group"    { Get-ADGroup @p }
          "ou"       { Get-ADOrganizationalUnit @p }
          "gpo" {
            # Get-GPO is semantically different from other Get-ADxx functions
            if ($l.Filter -ne "*") {
              $prop, $val = $l.Filter -split ' -eq '
              if (!$val) { throw "GPO name must be precise: use '-eq' operator !" }; if ($prop -ne "Name") { throw "I can only search GPOs by Name !" }

              Get-GPO ($val.Trim('"', "'"))
            } else { Get-GPO -All }
          }
          default { Get-ADObject @p }
        }
      }
      catch { Write-Host "`n-- Something went wrong. I could not retreive the informations I was supposed to: `n$_" -f Red}

    } -ArgumentList $Lead, $params -Name ADReq

    # Waiting indicator
    while ("Completed", "Failed" -notcontains $job.State) {
      Write-Host '.' -NoNewline -f DarkYellow

      # If timeout is reached, cancel
      $Timeout -= $WaitStep
      if ($Timeout -le 0) { Write-Host "Uhh it's taking me too much time... Better continue." -f Red }

      Start-Sleep -Seconds $waitStep
    }

    [array]$res = Receive-Job $job -Wait
  }

  END { return $res }
}