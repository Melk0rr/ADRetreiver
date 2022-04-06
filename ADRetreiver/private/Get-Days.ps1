<#
  .SYNOPSIS
    Returns the number of days between today and the provided date
#>
function Get-Days ([datetime] $date) { ((Get-Date) - $date).Days }