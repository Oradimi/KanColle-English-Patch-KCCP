@echo off
 
powershell.exe -ExecutionPolicy Unrestricted -Command ". 'EN-patch-manager\quick_updater.ps1'"
 
TIMEOUT /T 20
