# Course of Migration Windows AD to Zentyal
![](https://img.shields.io/badge/status-progress-blue)

<p align="center">
<img src=".github/logo.png">
</p>

Course about Active Directory using Windows Server 2008 R2 and Zentyal Linux.

Creator: Luciano Rodrigues

## Commands for Windows Server

```bash
# Add/remove Domain Controllers
dcpromo

# Populate AD (use PowerShell)
Set-ExecutionPolicy Unrestricted
.\import.ps1

# Check IPs of domain
nslookup mylab.lan

# Get list of all Domain Controllers
nltest /dclist:mylab.lan

# Query for DC with FSMO
netdom query fsmo
```

## Refenreces

[Playlist from SysAdminBr Channel](https://youtube.com/playlist?list=PLFajyb7NamFDqLmrUIddr_euDkRcWMgQ9&si=DSh5C1VDw9WLha-j)
