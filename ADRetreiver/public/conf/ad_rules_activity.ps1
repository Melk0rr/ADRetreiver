$ADActivityRules = @(
  @{
    Label       = "None";
    PeriodStart = -1;
    PeriodEnd   = 0;
    HealthLoss  = 80;
    Flag        = "NeverActive"
  },

  @{
    Label       = "Normal";
    PeriodStart = 0;
    PeriodEnd   = 30;
    HealthLoss  = 0;
    Flag        = "Active"
  },

  @{
    Label       = "Elevated";
    PeriodStart = 30;
    PeriodEnd   = 90;
    HealthLoss  = 10;
    Flag        = "Inactive30d"
  },

  @{
    Label       = "High";
    PeriodStart = 90;
    PeriodEnd   = 180;
    HealthLoss  = 20;
    Flag        = "Inactive90d"
  },

  @{
    Label       = "Severe";
    PeriodStart = 180;
    PeriodEnd   = 360;
    HealthLoss  = 40;
    Flag        = "Inactive180d"
  },

  @{
    Label       = "Critical";
    PeriodStart = 360;
    PeriodEnd   = 9999;
    HealthLoss  = 80;
    Flag        = "Inactive360d"
  }
)