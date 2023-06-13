<#
  .SYNOPSIS
    Returns the number of days between today and the provided date
#>
function Get-Days ([datetime] $date, [switch]$reverse) {
  $sub = if ($reverse.IsPresent) {
    ($date - (Get-Date))
  } else {
    ((Get-Date) - $date)
  }
  
  return $sub.Days
}