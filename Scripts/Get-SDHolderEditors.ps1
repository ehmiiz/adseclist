function Get-SDHolderEditors {
    <#
    .Synopsis
        Who can change security permissions on the AdminSDHolder object?
    .DESCRIPTION
        Anyone with WriteDacl in adminsdholder ACL
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
    
        $Root = [ADSI]"LDAP://RootDSE"
        $Domain = $Root.Get("rootDomainNamingContext")
        $SDHolder = "CN=AdminSDHolder,CN=System,$Domain"
        $UserACL = Get-Acl "AD:\$($SDHolder)"
        $UserACL.Access | Where-Object ActiveDirectoryRights -like "*WriteDacl*" | select IdentityReference, AccessControlType,ActiveDirectoryRights | Format-List
        # the selection and the formating can be removed if needed
    }