function Split-DN ([string] $dn) {
  [array]$splitDN = $dn -split ','
  [array]$domDCs = $splitDN | where-object { $_ -like "DC=*" }
  [array]$domOUs = $splitDN | where-object { $_ -like "OU=*" }
  [array]$domCNs = $splitDN | where-object { $_ -like "CN=*" }

  return [PSCustomObject]@{
    Name   = if ($domCNs) { $domCNs[0].Trim('CN=') } else { $null }
    OUs    = if ($domOUs) { $domOUs.Trim('OU=') } else { $null }
    Domain = if ($domDCs) { $domDCs.Trim('DC=') -join '.' } else { $null }
  }
}