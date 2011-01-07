@echo off
setlocal enableextensions disabledelayedexpansion
cd /d %~dp0
if errorlevel 1 goto error1
set TempFile=$$$$$$$$.$$$
set Path=%PATH%;%cd%\utilis
if exist temp goto tempexists
:back
echo Figuring out our version number...
svnversion pk3 >%TempFile%

rem Read the temp file and remove it
set /p RSVer=<%TempFile%
del %TempFile%
if "%RSVer%"=="" goto NoSVNInstalled
if "%RSVer%"=="exported" goto NotSVN

rem This removes needless symbols, such as :, M, and S.
for /f "delims=: tokens=2" %%I IN ('echo %RSVer%') do set SVer=%%I
if "%SVer%"=="" for /f "delims=: tokens=1" %%I IN ('echo %RSVer%') do set SVer=%%I
for /f "delims=M tokens=1" %%I IN ('echo %SVer%') do set SVer=%%I
for /f "delims=S tokens=1" %%I IN ('echo %SVer%') do set SVer=%%I

rem Detect if it is modified...
for /f "delims=M tokens=2" %%I IN ('echo %RSVer%mod') do set IsModified=%%I
rem This is very hacky... I don't know how else to detect it.
if "%IsModified%"==" mod" set IsModified=true
if "%IsModified%"=="mod" set IsModified=true
if "%IsModified%"=="  mod" set IsModified=true

rem "Clean" the version number
set /a SVer="%SVer%+0" >nul

rem Tell the user what we found...
rem echo which is %SVer%
rem if "%IsModified%"=="true" echo It is modified too!

rem Set our file name based on that.
set filename=hpack_r%SVer%.pk3

rem If we're using a modified build, change the filename.
if "%IsModified%"=="true" set filename=hpack_r%SVer%_modified.pk3

:back2
echo Creating output file %filename%
if exist %filename% echo %filename% already exists, removing...
if exist %filename% del %filename%
echo *** Warning *** The following process may take a few minutes, and does not
echo                 produce any output. Your computer is actually doing something
echo                 when it looks like it doesn't, so be patient! :)
echo Exporting SVN...
svn export pk3/ temp
if not exist temp goto NoSVNInstalled2
pushd temp
echo Creating archive...
zip -r9 ../%filename% *
popd
echo Removing temporary folder.
rd /s /q temp
echo Done!
if exist %filename% echo %filename% written.
if not exist %filename% echo There was an error!
pause
goto :eof
:removetemp
rd /s /q temp >nul
del /a /f temp >nul
goto back
:NoSVNInstalled
set filename=hpack_data.pk3
echo It appears you do not have "svnversion" installed on your computer.
echo This file is not vital, but in order to automatically create build
echo names which match the revision number, it needs to be installed.
echo You can get this utility from http://subversion.apache.org/
echo Install "SilkSVN" from the Windows version.
echo.
echo We will use the file name "%filename%" instead.
echo.
pause
goto back2
:NoSVNInstalled2
echo "svn export" failed - most likely because SVN is not installed or because this is an exported tree.
echo Exiting.
goto :eof
:NotSVN
rem This occurs if svnversion returns "exported" - special handling will be required to take care of this.
echo Unknown error. Exiting.
goto :eof
:tempexists
echo Warning! The subdirectory or file "temp" already exists!
echo This build script uses that folder to build the pk3 file, and it must be
echo removed in order to continue. Do you wish to remove that folder/file?
echo.
set /p Confirm="Do you wish to remove this folder (Y/N)?"
if "%confirm%"=="y" goto removetemp
if "%confirm%"=="Y" goto removetemp
if "%confirm%"=="yes" goto removetemp
goto :eof
:error1
echo Fatal error! Unable to enable command extensions.
echo Build will NOT continue!
echo.
pause
goto :eof
