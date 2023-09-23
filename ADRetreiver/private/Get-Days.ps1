<#
  .SYNOPSIS
    Returns the number of days between today and the provided date
#>
function Get-Days ([datetime] $date) {
  return ((Get-Date) - $date).Days
}