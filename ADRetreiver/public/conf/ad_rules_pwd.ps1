$ADPasswordRules = @(
  @{
    Label        = "NotSet";
    Flag         = "PwdNotSet";
    PeriodStart  = -1;
    PeriodEnd    = 0;
    HealthLoss   = 80;
    ShouldChange = $true
  },

  @{
    Label        = "Alive";
    Flag         = "PwdIsAlive";
    PeriodStart  = 0;
    PeriodEnd    = 180;
    HealthLoss   = 0;
    ShouldChange = $false
  },

  @{
    Label        = "Expired";
    Flag         = "PwdExpired";
    PeriodStart  = 180;
    PeriodEnd    = 360;
    HealthLoss   = 40;
    ShouldChange = $true
  },

  @{
    Label        = "Critical";
    Flag         = "PwdExpiredCritical";
    PeriodStart  = 360;
    PeriodEnd    = 9999;
    HealthLoss   = 80;
    ShouldChange = $true
  }
)