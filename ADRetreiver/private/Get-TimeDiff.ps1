function Get-TimeDiff ([datetime]$t1, [datetime]$t2) {
  $rawDiff = $t2 - $t1

  # Time properties we want to retreive from the above substraction
  $timeProps = @(
    @{ name = 'Days'        ; abr = 'd' },
    @{ name = 'Hours'       ; abr = 'h' },
    @{ name = 'Minutes'     ; abr = 'm' },
    @{ name = 'Seconds'     ; abr = 's' },
    @{ name = 'Milliseconds'; abr = 'ms' }
  )

  # For each property if not zero : add it to the stack
  [string[]]$diffStack = @()
  foreach ($p in $timeProps) {
    [string]$pName, [string]$pAbr = $p.name, $p.abr
    if ($rawDiff.$pName -gt 0) { $diffStack += "$($rawDiff.$pName)$pAbr" }
  }

  return ($diffStack -join ', ')
}