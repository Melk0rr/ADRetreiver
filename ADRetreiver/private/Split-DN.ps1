function Split-DN ([string] $dn) {
  [array]$splitDN = $dn -split ','
  [array]$domDCs = $splitDN.Where({ $_ -like "DC=*" })
  [array]$domOUs = $splitDN.Where({ $_ -like "OU=*" })
  [array]$domCNs = $splitDN.Where({ $_ -like "CN=*" })

  return [PSCustomObject]@{
    Name   = $domCNs ? $domCNs[0].Trim('CN=') : $null
    OUs    = $domOUs ? $domOUs.Trim('OU=') : $null
    Domain = $domDCs ? ($domDCs.Trim('DC=') -join '.') : $null
  }
}