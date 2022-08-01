$WinBuilds = @(

  # Windows Workstation
  # Windows 11
  @{
    OS      = "11";
    Name    = "Windows 11";
    Type    = "Workstation";
    Build   = "22000";
    Version = "21H2";
    Release = "2021-12";
    EOS     = "2023-10";
    LTSEoS  = "2032-01"
  },

  # Windows 10
  @{
    OS      = "10";
    Name    = "Windows 10";
    Type    = "Workstation";
    Build   = "19044";
    Version = "21H2";
    Release = "2021-11";
    EOS     = "2024-06";
    LTSEoS  = "2032-01"
  },

  @{
    OS      = "10";
    Name    = "Windows 10";
    Type    = "Workstation";
    Build   = "19043";
    Version = "21H1";
    Release = "2021-05";
    EOS     = "2022-12";
    LTSEoS  = "2032-01"
  },

  @{
    OS      = "10";
    Name    = "Windows 10";
    Type    = "Workstation";
    Build   = "19042";
    Version = "20H2";
    Release = "2020-10";
    EOS     = "2023-05";
    LTSEoS  = "2029-01"
  },

  @{
    OS      = "10";
    Name    = "Windows 10";
    Type    = "Workstation";
    Build   = "19041";
    Version = "2004";
    Release = "2020-05";
    EOS     = "2021-12";
    LTSEoS  = "2029-01"
  },

  @{
    OS      = "10";
    Name    = "Windows 10";
    Type    = "Workstation";
    Build   = "18363";
    Version = "1909";
    Release = "2019-11";
    EOS     = "2022-05";
    LTSEoS  = "2029-01"
  },

  @{
    OS      = "10";
    Name    = "Windows 10";
    Type    = "Workstation";
    Build   = "18362";
    Version = "1903";
    Release = "2019-05";
    EOS     = "2020-12";
    LTSEoS  = "2029-01"
  },

  @{
    OS      = "10";
    Name    = "Windows 10";
    Type    = "Workstation";
    Build   = "17763";
    Version = "1809";
    Release = "2018-11";
    EOS     = "2021-05";
    LTSEoS  = "2029-01"
  },

  @{
    OS      = "10";
    Name    = "Windows 10";
    Type    = "Workstation";
    Build   = "17134";
    Version = "1803";
    Release = "2018-05";
    EOS     = "2021-05";
    LTSEoS  = "2029-01"
  },

  @{
    OS      = "10";
    Name    = "Windows 10";
    Type    = "Workstation";
    Build   = "16299";
    Version = "1709";
    Release = "2017-10";
    EOS     = "2020-10";
    LTSEoS  = "2026-10"
  },

  @{
    OS      = "10";
    Name    = "Windows 10";
    Type    = "Workstation";
    Build   = "15063";
    Version = "1703";
    Release = "2017-04";
    EOS     = "2019-10";
    LTSEoS  = "2026-10"
  },

  @{
    OS      = "10";
    Name    = "Windows 10";
    Type    = "Workstation";
    Build   = "14393";
    Version = "1607";
    Release = "2016-08";
    EOS     = "2019-04";
    LTSEoS  = "2026-10"
  },

  @{
    OS      = "10";
    Name    = "Windows 10";
    Type    = "Workstation";
    Build   = "10586";
    Version = "1511";
    Release = "2015-11";
    EOS     = "2018-04";
    LTSEoS  = "2026-10"
  },

  @{
    OS      = "10";
    Name    = "Windows 10";
    Type    = "Workstation";
    Build   = "10240";
    Version = "1507";
    Release = "2015-07";
    EOS     = "2017-05";
    LTSEoS  = "2026-10"
  },

  # Windows 8
  @{
    OS      = "8.1";
    Name    = "Windows 8.1";
    Type    = "Workstation";
    Build   = "9600";
    Version = "6.3";
    Release = "2013-10";
    EOS     = "2018-01";
    LTSEoS  = "2023-01"
  },

  @{
    OS      = "8";
    Name    = "Windows 8";
    Type    = "Workstation";
    Build   = "9200";
    Version = "6.2";
    Release = "2012-10";
    EOS     = "2016-01";
    LTSEoS  = "2023-01"
  },

  # Windows 7
  @{
    OS      = "7";
    Name    = "Windows 7";
    Type    = "Workstation";
    Build   = "7601";
    Version = "6.1";
    Release = "2009-10";
    EOS     = "2015-01";
    LTSEoS  = "2020-01"
  },

  @{
    OS      = "7";
    Name    = "Windows 7";
    Type    = "Workstation";
    Build   = "7600";
    Version = "6.1";
    Release = "2009-07";
    EOS     = "2015-01";
    LTSEoS  = "2020-01"
  },

  # Windows XP
  @{
    OS      = "XP";
    Name    = "Windows XP";
    Type    = "Workstation";
    Build   = "3790";
    Version = "5.2";
    Release = "2005-04";
    EOS     = "2009-04";
    LTSEoS  = "2014-04"
  },

  @{
    OS      = "XP";
    Name    = "Windows XP";
    Type    = "Workstation";
    Build   = "2600";
    Version = "5.1";
    Release = "2001-10";
    EOS     = "2009-04";
    LTSEoS  = "2014-04"
  },

  # Windows Server
  # Windows Server 2022
  @{
    OS      = "2022";
    Name    = "Windows Server 2022";
    Type    = "Server";
    Build   = "20348";
    Version = "2022";
    Release = "2021-08";
    EOS     = "2031-10";
    LTSEoS  = "2034-10"
  },

  # Windows Server 2019
  @{
    OS      = "2019";
    Name    = "Windows Server 2019";
    Type    = "Server";
    Build   = "17763";
    Version = "1809";
    Release = "2018-11";
    EOS     = "2029-01";
    LTSEoS  = "2032-01"
  },

  # Windows Server 2016
  @{
    OS      = "2016";
    Name    = "Windows Server 2016";
    Type    = "Server";
    Build   = "14393";
    Version = "1607";
    Release = "2016-10";
    EOS     = "2027-01";
    LTSEoS  = "2030-01"
  },

  # Windows Server 2012
  @{
    OS      = "2012 R2";
    Name    = "Windows Server 2012 R2";
    Type    = "Server";
    Build   = "9600";
    Version = "6.3";
    Release = "2013-10";
    EOS     = "2023-10";
    LTSEoS  = "2026-10"
  },

  @{
    OS      = "2012";
    Name    = "Windows Server 2012";
    Type    = "Server";
    Build   = "9200";
    Version = "6.2";
    Release = "2012-09";
    EOS     = "2023-10";
    LTSEoS  = "2026-10"
  },

  # Windows Server 2008
  @{
    OS      = "2008 R2 SP1";
    Name    = "Windows Server 2008 R2 SP1";
    Type    = "Server";
    Build   = "7601";
    Version = "6.1";
    Release = "2011-02";
    EOS     = "2020-01";
    LTSEoS  = "2023-01"
  },

  @{
    OS      = "2008 R2";
    Name    = "Windows Server 2008 R2";
    Type    = "Server";
    Build   = "7600";
    Version = "6.0";
    Release = "2009-10";
    EOS     = "2020-01";
    LTSEoS  = "2023-01"
  },

  @{
    OS      = "2008 SP2";
    Name    = "Windows Server 2008 SP2";
    Type    = "Server";
    Build   = "6003";
    Version = "6.0";
    Release = "2019-05";
    EOS     = "2020-01";
    LTSEoS  = "2023-01"
  },

  @{
    OS      = "2008 SP2";
    Name    = "Windows Server 2008 SP2";
    Type    = "Server";
    Build   = "6002";
    Version = "6.0";
    Release = "2009-05";
    EOS     = "2020-01";
    LTSEoS  = "2023-01"
  },

  @{
    OS      = "2008";
    Name    = "Windows Server 2008";
    Type    = "Server";
    Build   = "6001";
    Version = "6.0";
    Release = "2008-02";
    EOS     = "2020-01";
    LTSEoS  = "2023-01"
  },

  # Windows Server 2003
  @{
    OS      = "2003";
    Name    = "Windows Server 2003";
    Type    = "Server";
    Build   = "3790";
    Version = "5.2";
    Release = "2003-04";
    EOS     = "2015-07";
    LTSEoS  = "2015-07"
  },

  # Windows Server 2000
  @{
    OS      = "2000";
    Name    = "Windows Server 2000";
    Type    = "Server";
    Build   = "2195";
    Version = "5.0";
    Release = "2000-02";
    EOS     = "2010-07";
    LTSEoS  = "2010-07"
  }
)