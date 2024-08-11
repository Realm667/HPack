@echo off
7za a -tzip -mx0 -x!".git" -xr!"#removed" -xr!"*.dbs" -xr!"*.backup1" -xr!"*.backup2" -xr!"*.backup3" -xr!tools -xr!#PSD -x!.vscode\ -xr!"*.bat" -xr!"*.psd" -xr!"*.otf" -xr!"*.ttf"-xr!"*.rar" -xr!"*.zip" duprising_rc.pk3 .\pk3\*
