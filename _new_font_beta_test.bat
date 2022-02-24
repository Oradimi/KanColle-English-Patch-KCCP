@echo off
 
powershell.exe -ExecutionPolicy Unrestricted -Command ". 'EN-patch-manager\new_font_beta_test.ps1'"
powershell.exe -ExecutionPolicy Unrestricted -Command ". 'EN-patch-manager\clear_browser_cache.ps1'"
 
TIMEOUT /T 20