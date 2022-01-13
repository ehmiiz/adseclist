function Get-ADDSMachineAccountQuota {
    Get-ADObject -Identity ((Get-ADDomain).distinguishedname) -Properties ms-ds-machineaccountquota
}