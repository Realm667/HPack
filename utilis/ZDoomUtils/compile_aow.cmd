@echo off
setlocal enableextensions disabledelayedexpansion
cd /d %~dp0
call :processscript aow2scrp
call :processscript tgrscrpt
call :processscript sbarscrp
goto :eof
:processscript
if exist ..\..\trunk\src\acs_source\%1.o del ..\..\trunk\src\acs_source\%1.o
acc ..\..\trunk\src\acs_source\%1.acs
if exist ..\..\trunk\src\acs_source\%1.o copy ..\..\trunk\src\acs_source\%1.o ..\..\trunk\src\acs\%1.o /y
goto :eof