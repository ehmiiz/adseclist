function Get-DAEditors {
    <#
    .Synopsis
        Who can change the membership of the Domain Admins security group?
    .DESCRIPTION
        Anyone with DA Edit ACL    
    .NOTES
        Author: Emil Larsson
    #>
    
        if ( -not ( Get-Module Activedirectory -ListAvailable ) ){
            Write-Warning "Missing ActiveDirectory PS Module."
            Break
        }
        else {
            Import-Module Activedirectory
        }
    
        $Searcher = New-Object DirectoryServices.DirectorySearcher -Property @{
            Filter = '(name=Domain Admins)'
        }
        $DA = ($Searcher.FindAll())
        $DAPath = ($DA.Path).Replace("LDAP://","")
        
        $DAACL = Get-Acl "AD:\$DAPath"
        $Array = @()
        $Array += $DAACL.Access | Where-Object ObjectType -eq "bf9679c0-0de6-11d0-a285-00aa003049e2"
        $Array += $DAACL.Access | Where-Object ActiveDirectoryRights -like "*WriteOwner*"
        $Array += $DAACL.Access | Where-Object ActiveDirectoryRights -like "*GenericAll*"
        $Array += $DAACL.Access | Where-Object ActiveDirectoryRights -like "*AllExtendedRights*"
        $Array += $DAACL.Access | Where-Object ActiveDirectoryRights -like "*GenericWrite*"
    
        $Array | Select-Object -Property IdentityReference, ActiveDirectoryRights, AccessControlType | fl
    }