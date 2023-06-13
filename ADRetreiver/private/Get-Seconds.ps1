function Get-Seconds ([timespan] $time) {
  return $time.Minutes * 60 + $time.Seconds + $time.Milliseconds * .01
}