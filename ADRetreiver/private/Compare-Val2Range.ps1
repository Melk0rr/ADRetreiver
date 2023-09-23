<#
  .SYNOPSIS
    Compare given integer to the provided range

  .EXAMPLE
    $inRange = Compare-Val2Range 5 "[0; 5]" => true

  .EXAMPLE
    $inRange = Compare-Val2Range 5 "[0; 5[" => false
#>
function Compare-Val2Range ([int] $value, [string] $range) {
  # Check range validity
  [regex]$inteReg = "^(?:\[|\])[0-9]+;[0-9]+(?:\[|\])$"
  if ($range -notmatch $inteReg) {
    throw "$range is not a valid range value ! Please follow the exemples: [30;90[, [30;90] or ]30;90["
  }

  # Retreive range values
  [int]$firstValue, [int]$secondValue = $range.Trim('[', ']') -split ';'

  # Check if the value is inside the given range
  [bool]$firstCondition = if ($range[0] -eq '[') { $value -ge $firstValue } else { $value -gt $firstValue }
  [bool]$secondCondition = if ($range[-1] -eq ']') { $value -le $secondValue } else { $value -lt $secondValue }

  return ($firstCondition -and $secondCondition)
}
