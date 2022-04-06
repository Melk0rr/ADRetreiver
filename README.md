# Powershell: ADRetreiver


```
                            .:-------------:.
                       .:::.                .:::.
                  -=-..                         .::-=.
                 **.            .       .           .=.
                .=              -.     .-        .-   -
               -=    *    -==-   -+   +-   -==-   -+   =.
              =     .@   -+*@#*  #     #  *#@*+- -%     =:
          .---       ** .:.=++:  =     =  =++-.:.@+    - ==
         .=.          %.  :-=              -=:  -#      +.+-
         -#           %    -+              -+   -*      -#:%
         --=.        -+    ..     .  .      :   *:       -+
           .:-       #.  ..     #@@@@@@#     : :*    := -:.
              .*     .*. =.     *%%@@%%*     = *:     =#
               *:      *::+      *@@@@*      * +:     ==
                ---.   =- *:     =@@@@=     :+  =.   +
                   .--=-  :*    =%%@@%%=    #.   :=-+
                          :#-:-#+-.  .-+#-:-#:
                            -#=-#*====*#-=#-

              _____    _____      _            _
        /\   |  __ \  |  __ \    | |          (_)
       /  \  | |  | | | |__) |___| |_ _ __ ___ ___   _____ _ __
      / /\ \ | |  | | |  _  // _ \ __| '__/ _ \ \ \ / / _ \ '__|
     / ____ \| |__| | | | \ \  __/ |_| | |  __/ |\ V /  __/ |
    /_/    \_\_____/  |_|  \_\___|\__|_|  \___|_| \_/ \___|_|

    ============================================================
```

This project is a Powershell tool that utilises the ActiveDirectory Module to retreive various informations from an Active Directory domain. It aims to centralize various built-in commands from the ActiveDirectory Module and to provide more detailed and useful informations at the same time.

## Requirements

This script requires Powershell 7.0 and ActiveDirectory module

## Getting Started

To install this module, you first need to download the project. You can then copy the module to your modules directory and then load it with:

`Import-Module ADRetreiver`

Alternatively, you can just import it directly from the project directory with:

`Import-Module C:\Path\To\ADRetreiver`

## Usage

1. Simple usages:
  - To retreive user informations: `$users = Invoke-ADRetreiver -Leads @{Type='user'}`
  - To retreiver computer informations: `$computers = Invoke-ADRetreiver -Leads @{Type='computer'}`
  - To retreive GPO informations: `$gpos = Invoke-ADRetreiver -Leads @{Type='gpo'}`
  - To retreive OU informations: `$ous = Invoke-ADRetreiver -Leads @{Type='ou'}`
  - To retreive Group informations: `$groups = Invoke-ADRetreiver -Leads @{Type='group'}`
2. You can also provide filter to narrow your research:
  - Get a precise user: `$myUser = Invoke-ADRetreiver -Leads @{Type='user'; Filter={Name -eq "Roy Batty"}} `
  - Get a precise GPO: `$myGPO = Invoke-ADRetreiver -Leads @{Type='gpo'; Filter={Name -eq 'MyGPO'}}`
3. You can provide multiple leads to the retreiver:
  - Retreive users and computers: `$users, $computers = Invoke-ADRetreiver -Leads @{Type='user'}, @{Type='computer'}`
  - Provide leads from pipeline: `$leads | Invoke-ADRetreiver` | `(Get-Content ./leads.json | ConvertFrom-Json) | Invoke-ADRetreiver`