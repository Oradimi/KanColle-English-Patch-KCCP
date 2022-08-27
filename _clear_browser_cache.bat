@echo off
 
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ". 'EN-patch-manager\clear_browser_cache.ps1'"
 
TIMEOUT /T 60