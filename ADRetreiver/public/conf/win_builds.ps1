$WinBuilds = @{

  #############################################################
  ################# Windows Workstation
  Workstation = @{
    # Windows 11
    22621 = @{
      E = @{
        OS              = "11"
        Version         = "22H2"
        Release         = "2022-09-20"
        ActiveSupport   = "2025-10-14"
        SecuritySupport = "2025-10-14"
      }

      W = @{
        OS              = "11"
        Version         = "22H2"
        Release         = "2022-09-20"
        ActiveSupport   = "2024-10-08"
        SecuritySupport = "2024-10-08"
      }
    }

    22000 = @{
      E = @{
        OS              = "11"
        Version         = "21H2"
        Release         = "2021-10-04"
        ActiveSupport   = "2024-10-08"
        SecuritySupport = "2024-10-08"
      }

      W = @{
        OS              = "11"
        Version         = "21H2"
        Release         = "2021-10-04"
        ActiveSupport   = "2023-10-10"
        SecuritySupport = "2023-10-10"
      }
    }

    # Windows 10
    19045 = @{
      E = @{
        OS              = "10"
        Version         = "22H2"
        Release         = "2022-10-18"
        ActiveSupport   = "2025-10-14"
        SecuritySupport = "2025-10-14"
      }

      W = @{
        OS              = "10"
        Version         = "22H2"
        Release         = "2022-10-18"
        ActiveSupport   = "2025-10-14"
        SecuritySupport = "2025-10-14"
      }
    }
    19044 = @{
      LTS = @{
        OS              = "10"
        Version         = "21H2"
        Release         = "2021-11-16"
        ActiveSupport   = "2027-01-12"
        SecuritySupport = "2027-01-12"
      }

      E   = @{
        OS              = "10"
        Version         = "21H2"
        Release         = "2021-11-16"
        ActiveSupport   = "2024-07-11"
        SecuritySupport = "2024-07-11"
      }

      W   = @{
        OS              = "10"
        Version         = "21H2"
        Release         = "2021-11-16"
        ActiveSupport   = "2023-07-13"
        SecuritySupport = "2023-07-13"
      }
    }
    19043 = @{
      E = @{
        OS              = "10"
        Version         = "21H1"
        Release         = "2021-05-18"
        ActiveSupport   = "2022-12-13"
        SecuritySupport = "2022-12-13"
      }

      W = @{
        OS              = "10"
        Version         = "21H1"
        Release         = "2021-05-18"
        ActiveSupport   = "2022-12-13"
        SecuritySupport = "2022-12-13"
      }
    }
    19042 = @{
      E = @{
        OS              = "10"
        Version         = "20H2"
        Release         = "2020-10-20"
        ActiveSupport   = "2023-05-09"
        SecuritySupport = "2023-05-09"
      }
    
      W = @{
        OS              = "10"
        Version         = "20H2"
        Release         = "2020-10-20"
        ActiveSupport   = "2022-05-10"
        SecuritySupport = "2022-05-10"
      }
    }
    19041 = @{
      E = @{
        OS              = "10"
        Version         = "2004"
        Release         = "2020-05-27"
        ActiveSupport   = "2021-12-14"
        SecuritySupport = "2021-12-14"
      }

      W = @{
        OS              = "10"
        Version         = "2004"
        Release         = "2020-05-27"
        ActiveSupport   = "2021-12-14"
        SecuritySupport = "2021-12-14"
      }
    }
    18363 = @{
      E = @{
        OS              = "10"
        Version         = "1909"
        Release         = "2019-11-12"
        ActiveSupport   = "2022-05-10"
        SecuritySupport = "2022-05-10"
      }
    
      W = @{
        OS              = "10"
        Version         = "1909"
        Release         = "2019-11-12"
        ActiveSupport   = "2021-05-11"
        SecuritySupport = "2021-05-11"
      }
    }
    18362 = @{
      E = @{
        OS              = "10"
        Version         = "1903"
        Release         = "2019-08-29"
        ActiveSupport   = "2020-12-08"
        SecuritySupport = "2020-12-08"
      }

      W = @{
        OS              = "10"
        Version         = "1903"
        Release         = "2019-08-29"
        ActiveSupport   = "2020-12-08"
        SecuritySupport = "2020-12-08"
      }
    }

    17763 = @{
      LTS = @{
        OS              = "10"
        Version         = "1809"
        Release         = "2018-11-13"
        ActiveSupport   = "2024-01-09"
        SecuritySupport = "2029-01-09"
      }
    
      E   = @{
        OS              = "10"
        Version         = "1809"
        Release         = "2018-11-13"
        ActiveSupport   = "2021-05-11"
        SecuritySupport = "2021-05-11"
      }
    
      W   = @{
        OS              = "10"
        Version         = "1809"
        Release         = "2018-11-13"
        ActiveSupport   = "2020-11-10"
        SecuritySupport = "2020-11-10"
      }
    }
  
    17134 = @{
      E = @{
        OS              = "10"
        Version         = "1803"
        Release         = "2018-04-30"
        ActiveSupport   = "2020-05-11"
        SecuritySupport = "2021-05-11"
      }
    
      W = @{
        OS              = "10"
        Version         = "1803"
        Release         = "2018-04-30"
        ActiveSupport   = "2019-11-12"
        SecuritySupport = "2020-05-11"
      }
    }
  
    16299 = @{
      E = @{
        OS              = "10"
        Version         = "1709"
        Release         = "2017-10-17"
        ActiveSupport   = "2020-10-13"
        SecuritySupport = "2020-09-13"
      }
    
      W = @{
        OS              = "10"
        Version         = "1709"
        Release         = "2017-10-17"
        ActiveSupport   = "2019-04-09"
        SecuritySupport = "2019-04-09"
      }
    }
  
    15063 = @{
      E = @{
        OS              = "10"
        Version         = "1703"
        Release         = "2017-04-11"
        ActiveSupport   = "2019-10-08"
        SecuritySupport = "2019-10-08"
      }
    
      W = @{
        OS              = "10"
        Version         = "1703"
        Release         = "2017-04-11"
        ActiveSupport   = "2018-10-09"
        SecuritySupport = "2018-10-09"
      }
    }
  
    14393 = @{
      LTS = @{
        OS              = "10"
        Version         = "1607"
        Release         = "2016-08-02"
        ActiveSupport   = "2021-10-12"
        SecuritySupport = "2026-10-13"
      }
    
      E   = @{
        OS              = "10"
        Version         = "1607"
        Release         = "2016-08-02"
        ActiveSupport   = "2019-04-09"
        SecuritySupport = "2019-04-09"
      }
    
      W   = @{
        OS              = "10"
        Version         = "1607"
        Release         = "2016-08-02"
        ActiveSupport   = "2018-04-10"
        SecuritySupport = "2018-04-10"
      }
    }
  
    10586 = @{
      E = @{
        OS              = "10"
        Version         = "1511"
        Release         = "2015-11-10"
        ActiveSupport   = "2017-10-10"
        SecuritySupport = "2017-10-10"
      }

      W = @{
        OS              = "10"
        Version         = "1511"
        Release         = "2015-11-10"
        ActiveSupport   = "2017-10-10"
        SecuritySupport = "2017-10-10"
      }
    }
  
    10240 = @{
      LTS = @{
        OS              = "10"
        Version         = "1507"
        Release         = "2015-07-29"
        ActiveSupport   = "2020-10-13"
        SecuritySupport = "2025-10-14"
      }
    
      E   = @{
        OS              = "10"
        Version         = "1507"
        Release         = "2015-07-29"
        ActiveSupport   = "2017-05-09"
        SecuritySupport = "2017-05-09"
      }

      W   = @{
        OS              = "10"
        Version         = "1507"
        Release         = "2015-07-29"
        ActiveSupport   = "2017-05-09"
        SecuritySupport = "2017-05-09"
      }
    }
  
    # Windows 8
    9600  = @{
      E = @{
        OS              = "8.1"
        Version         = "6.3"
        Release         = "2013-11-13"
        ActiveSupport   = "2018-01-10"
        SecuritySupport = "2023-01-10"
      }

      W = @{
        OS              = "8.1"
        Version         = "6.3"
        Release         = "2013-11-13"
        ActiveSupport   = "2018-01-10"
        SecuritySupport = "2023-01-10"
      }
    }
  
    9200  = @{
      E = @{
        OS              = "8"
        Version         = "6.2"
        Release         = "2012-10-30"
        ActiveSupport   = "2016-01-12"
        SecuritySupport = "2016-01-12"
      }

      W = @{
        OS              = "8"
        Version         = "6.2"
        Release         = "2012-10-30"
        ActiveSupport   = "2016-01-12"
        SecuritySupport = "2016-01-12"
      }
    }
  
    # Windows 7
    7601  = @{
      E = @{
        OS              = "7"
        Version         = "6.1"
        Release         = "2011-02-22"
        ActiveSupport   = "2015-01-13"
        SecuritySupport = "2020-01-14"
      }

      W = @{
        OS              = "7"
        Version         = "6.1"
        Release         = "2011-02-22"
        ActiveSupport   = "2015-01-13"
        SecuritySupport = "2020-01-14"
      }
    }
  
    7600  = @{
      E = @{
        OS              = "7"
        Version         = "6.1"
        Release         = "2009-10-22"
        ActiveSupport   = "2013-04-09"
        SecuritySupport = "2013-04-09"
      }

      W = @{
        OS              = "7"
        Version         = "6.1"
        Release         = "2009-10-22"
        ActiveSupport   = "2013-04-09"
        SecuritySupport = "2013-04-09"
      }
    }
  
    # Windows XP
    2600  = @{
      E = @{
        OS              = "XP"
        Version         = "5.1"
        Release         = "2008-04-21"
        ActiveSupport   = "2009-04-14"
        SecuritySupport = "2014-04-08"
      }

      W = @{
        OS              = "XP"
        Version         = "5.1"
        Release         = "2008-04-21"
        ActiveSupport   = "2009-04-14"
        SecuritySupport = "2014-04-08"
      }
    }
  }

  #############################################################
  ################# Windows Server
  Server      = @{
    # Windows Server 2022
    20348 = @{
      LTS      = @{
        OS              = "2022"
        Version         = "2022"
        Release         = "2021-08-18"
        ActiveSupport   = "2026-10-13"
        SecuritySupport = "2031-10-14"
      }

      Standard = @{
        OS              = "2022"
        Version         = "2022"
        Release         = "2021-08-18"
        ActiveSupport   = "2026-10-13"
        SecuritySupport = "2031-10-14"
      }
    }

    # Windows Server 2019
    17763 = @{
      LTS      = @{
        OS              = "2019"
        Version         = "1809"
        Release         = "2018-11-13"
        ActiveSupport   = "2024-01-09"
        SecuritySupport = "2029-01-09"
      }

      Standard = @{
        OS              = "2019"
        Version         = "1809"
        Release         = "2018-11-13"
        ActiveSupport   = "2024-01-09"
        SecuritySupport = "2029-01-09"
      }
    }

    # Windows Server 2016
    14393 = @{
      LTS      = @{
        OS              = "2016"
        Version         = "1607"
        Release         = "2016-10-15"
        ActiveSupport   = "2022-01-11"
        SecuritySupport = "2027-01-12"
      }

      Standard = @{
        OS              = "2016"
        Version         = "1607"
        Release         = "2016-10-15"
        ActiveSupport   = "2022-01-11"
        SecuritySupport = "2027-01-12"
      }
    }

    # Windows Server 2012
    9600  = @{
      LTS      = @{
        OS              = "2012 R2"
        Version         = "6.3"
        Release         = "2013-11-25"
        ActiveSupport   = "2023-10-10"
        SecuritySupport = "2026-10-13"
      }

      Standard = @{
        OS              = "2012 R2"
        Version         = "6.3"
        Release         = "2013-11-25"
        ActiveSupport   = "2023-10-10"
        SecuritySupport = "2026-10-13"
      }
    }

    9200  = @{
      LTS      = @{
        OS              = "2012"
        Version         = "6.2"
        Release         = "2012-10-30"
        ActiveSupport   = "2023-10-10"
        SecuritySupport = "2026-10-13"
      }

      Standard = @{
        OS              = "2012"
        Version         = "6.2"
        Release         = "2012-10-30"
        ActiveSupport   = "2023-10-10"
        SecuritySupport = "2026-10-13"
      }
    }

    # Windows Server 2008
    7601  = @{
      LTS      = @{
        OS              = "2008 R2 SP1"
        Version         = "6.1"
        Release         = "2011-02-22"
        ActiveSupport   = "2020-01-14"
        SecuritySupport = "2020-01-14"
      }

      Standard = @{
        OS              = "2008 R2 SP1"
        Version         = "6.1"
        Release         = "2011-02-22"
        ActiveSupport   = "2020-01-14"
        SecuritySupport = "2020-01-14"
      }
    }

    7600  = @{
      LTS      = @{
        OS              = "2008 R2"
        Version         = "6.0"
        Release         = "2009-10-22"
        ActiveSupport   = "2013-04-09"
        SecuritySupport = "2013-04-09"
      }

      Standard = @{
        OS              = "2008 R2"
        Version         = "6.0"
        Release         = "2009-10-22"
        ActiveSupport   = "2013-04-09"
        SecuritySupport = "2013-04-09"
      }
    }

    6003  = @{
      LTS      = @{
        OS              = "2008 SP2"
        Version         = "6.0"
        Release         = "2019-04-29"
        ActiveSupport   = "2020-01-14"
        SecuritySupport = "2020-01-14"
      }

      Standard = @{
        OS              = "2008 SP2"
        Version         = "6.0"
        Release         = "2019-04-29"
        ActiveSupport   = "2020-01-14"
        SecuritySupport = "2020-01-14"
      }
    }

    6001  = @{
      LTS      = @{
        OS              = "2008"
        Version         = "6.0"
        Release         = "2008-05-06"
        ActiveSupport   = "2011-07-12"
        SecuritySupport = "2011-07-12"
      }

      Standard = @{
        OS              = "2008"
        Version         = "6.0"
        Release         = "2008-05-06"
        ActiveSupport   = "2011-07-12"
        SecuritySupport = "2011-07-12"
      }
    }

    # Windows Server 2003
    3790  = @{
      LTS      = @{
        OS              = "2003"
        Version         = "5.2"
        Release         = "2003-04-24"
        ActiveSupport   = "2010-07-13"
        SecuritySupport = "2015-07-14"
      }

      Standard = @{
        OS              = "2003"
        Version         = "5.2"
        Release         = "2003-04-24"
        ActiveSupport   = "2010-07-13"
        SecuritySupport = "2015-07-14"
      }
    }

    # Windows Server 2000
    2195  = @{
      LTS      = @{
        OS              = "2000"
        Version         = "5.0"
        Release         = "2000-02-17"
        ActiveSupport   = "2005-06-30"
        SecuritySupport = "2010-07-13"
      }

      Standard = @{
        OS              = "2000"
        Version         = "5.0"
        Release         = "2000-02-17"
        ActiveSupport   = "2005-06-30"
        SecuritySupport = "2010-07-13"
      }
    }
  } 
}