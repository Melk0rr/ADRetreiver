# Invoke-ADRetreiver

## SYNOPSIS
Retreive more detailed AD object informations

## SYNTAX

```
Invoke-ADRetreiver [[-Leads] <Object[]>]
```

## DESCRIPTION
Gather various informations regarding AD objects based on the given parameters

## EXAMPLES

### EXAMPLE 1
```
Invoke-ADRetreiver -Leads @{Type='user'}
```

Retreive AD users and gather / compute various information about them.

### EXAMPLE 2
```
Invoke-ADRetreiver -Leads @{Type='computer'; Filter={ OperatingSystem -like "*Windows*" }}
```

Retreive AD computers where the OS contains "Windows".

## PARAMETERS

### -Leads
Type of object to retreive

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: @{Type='user'}
Accept pipeline input: True
Accept wildcard characters: False
```

<!-- ### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). -->

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
