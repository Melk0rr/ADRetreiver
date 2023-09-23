$ADProperties = @(
  # User properties
  @{
    Type    = "user"
    Initial = @(
      "Created",
      "Description",
      "EmailAddress",
      "EmployeeID",
      "Title",
      "LastLogonDate",
      "Modified",
      "PasswordLastSet",
      "PasswordNotRequired",
      "PasswordNeverExpires"
    )
    Final   = @(
      "DistinguishedName",
      "SAN",
      "SID",
      "Name",
      "Surname",
      "GivenName",
      "EmployeeID",
      "Email",
      "DomainName",
      "Status",
      "AccountType",
      "Permissions",
      "CreationDate",
      "LastChangeDate",
      "PasswordNotRequired",
      "PasswordNeverExpires",
      "PasswordLastSet",
      "PasswordLastSetDelta",
      "PasswordShouldBeReset",
      "LastLogonDate",
      "LastLogonDelta",
      "ActivityPeriod",
      "Active (30d)",
      "Active (90d)",
      "Active (180d)",
      "Active (360d)",
      "Health",
      "HealthFlags",
      "Title",
      "Description"
    )
  },

  # Computer properties
  @{
    Type    = "computer"
    Initial = @(
      "LastLogonDate",
      "Created",
      "Modified",
      "OperatingSystem",
      "OperatingSystemVersion",
      "IPV4Address",
      "PasswordLastSet",
      "PasswordNotRequired",
      "PasswordNeverExpires",
      "Description"
    )
    Final   = @(
      "DistinguishedName",
      "SAN",
      "SID",
      "Name",
      "DomainName",
      "Status",
      "ComputerType",
      "OSFamily",
      "OSShort",
      "OSFull",
      "OSEdition",
      "OSVersion",
      "OSBuild",
      "@IPv4",
      "HasExtendedSupport",
      "Support",
      "CreationDate",
      "LastChangeDate",
      "PasswordNotRequired",
      "PasswordNeverExpires",
      "PasswordLastSet",
      "PasswordLastSetDelta",
      "PasswordShouldBeReset",
      "LastLogonDate",
      "LastLogonDelta",
      "ActivityPeriod",
      "Active (30d)",
      "Active (90d)",
      "Active (180d)",
      "Active (360d)",
      "Health",
      "HealthFlags",
      "Description"
    )
  },

  # Group properties
  @{
    Type    = "group"
    Initial = @(
      "CN",
      "Created",
      "Modified",
      "Description",
      "MemberOf"
    )
    Final   = @(
      "DistinguishedName",
      "Name",
      "SID",
      "DomainName",
      "Category",
      "Scope",
      "Members",
      "CreationDate",
      "LastChangeDate",
      "MemberOf",
      "Description"
    )
  },

  # GPO properties
  @{
    Type    = "gpo"
    Initial = @(

    )
    Final   = @(
      "Name",
      "Id",
      "DomainName",
      "Owner",
      "ImpactedOUs",
      "CreationTime",
      "ModificationTime",
      "Description"
    )
  },

  # OU properties
  @{
    Type    = "ou"
    Initial = @(
      "Created",
      "Modified",
      "Description",
      "GPLink"
    )
    Final   = @(
      "DistinguishedName",
      "Name",
      "DomainName",
      "Created",
      "Modified",
      "Users",
      "Computers",
      "SubOUs",
      "GPLink",
      "Description"
    )
  },

  # Object properties
  @{
    Type    = "object"
    Initial = @(
      "Created",
      "Modified",
      "Description"
    )
    Final   = @(
      "DistinguishedName",
      "Name",
      "ObjectClass",
      "DomainName",
      "CreationDate",
      "LastChangeDate",
      "Description"
    )
  }
)