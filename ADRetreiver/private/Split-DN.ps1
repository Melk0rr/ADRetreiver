function Split-DN ([string] $dn) {
  $ous = $dn.Split(',') | where-object { $_ -like "OU=*" }

  return @{  }
}