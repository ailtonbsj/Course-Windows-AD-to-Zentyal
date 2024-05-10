@echo off
title Manual replication of Active Directory

repadmin /replicate server01 server02 DC=mylab,DC=lan /force
repadmin /replicate server01 server02 CN=Configuration,DC=mylab,DC=lan /force
repadmin /replicate server01 server02 CN=Schema,CN=Configuration,DC=mylab,DC=lan /force
repadmin /replicate server01 server02 DC=DomainDnsZones,DC=mylab,DC=lan /force
repadmin /replicate server01 server02 DC=ForestDnsZones,DC=mylab,DC=lan /force

echo "Press any key to exit"
pause >nul
