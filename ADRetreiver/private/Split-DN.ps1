function Split-DN ([string] $dn) {
  [array]$splitDN = $dn -split ','
  [array]$domDCs = $splitDN.Where({ $_ -like "DC=*" })
  [array]$domOUs = $splitDN.Where({ $_ -like "OU=*" })
  [array]$domCNs = $splitDN.Where({ $_ -like "CN=*" })

  return [PSCustomObject]@{
    CN     = $domCNs ? $domCNs[0].Replace("CN=", "") : $null
    OUs    = $domOUs ? $domOUs.Replace("OU=", "") : $null
    Domain = $domDCs ? ($domDCs.Replace("DC=", "") -join '.') : $null
  }
}