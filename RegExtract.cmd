@setlocal enableextensions
@cd /d "%~dp0
@echo off
:: ######################################################
:: VERSION 0.5.210913h - COVID19 Edition
:: SCRIPT:Registry Extraction
:: CREATION DATE: 2021-09-13
:: LAST MODIFIED: 2021-09-13
:: AUTHOR: Sgt. Mark SOUTHBY
:: EMAIL: mark@southby.ca
:: Extract All relevant registry
:: Based on the Colin Cree registry analysis method
:: TODO: - fix md5 hashing
:: ######################################################
if _%1_==_codestart_  goto :codestart
:getadmin
    echo %~nx0: ELEVATING TO ADMINISTRATOR PROMPT...
    set vbs=%temp%\getadmin.vbs
    echo Set UAC = CreateObject^("Shell.Application"^)                >> "%vbs%"
    echo UAC.ShellExecute "%~s0", "codestart %~sdp0 %*", "", "runas", 1 >> "%vbs%"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
goto :eof
:codestart
set /p filenum=File Number: 
::set filenum=2021-test1
::set exnum=001
set /p exnum=Exhibit # or 1 Word Description: 
:RegDump
mkdir %filenum%-%exnum%\REG\
::IF EXIST C:\Windows\System32\config\SAM goto Cdrive
:: NEED TO ADD CHECK FOR OTHER DRIVES
:Cdrive
extents-win64.exe  C:\Windows\System32\config\SAM %filenum%-%exnum%\REG\SAM
extents-win64.exe  C:\Windows\System32\config\SAM.LOG1 %filenum%-%exnum%\REG\SAM.LOG1
extents-win64.exe  C:\Windows\System32\config\SAM.LOG2 %filenum%-%exnum%\REG\SAM.LOG2
extents-win64.exe  C:\Windows\System32\config\SECURITY %filenum%-%exnum%\REG\SECURITY
extents-win64.exe  C:\Windows\System32\config\SECURITY.LOG1 %filenum%-%exnum%\REG\SECURITY.LOG1
extents-win64.exe  C:\Windows\System32\config\SECURITY.LOG2 %filenum%-%exnum%\REG\SECURITY.LOG2
extents-win64.exe  C:\Windows\System32\config\SOFTWARE %filenum%-%exnum%\REG\SOFTWARE
extents-win64.exe  C:\Windows\System32\config\SOFTWARE.LOG1 %filenum%-%exnum%\REG\SOFTWARE.LOG1
extents-win64.exe  C:\Windows\System32\config\SOFTWARE.LOG2 %filenum%-%exnum%\REG\SOFTWARE.LOG2
extents-win64.exe  C:\Windows\System32\config\SYSTEM %filenum%-%exnum%\REG\SYSTEM
extents-win64.exe  C:\Windows\System32\config\SYSTEM.LOG1 %filenum%-%exnum%\REG\SYSTEM.LOG1
extents-win64.exe  C:\Windows\System32\config\SYSTEM.LOG2 %filenum%-%exnum%\REG\SYSTEM.LOG2
extents-win64.exe  C:\Windows\System32\config\userdiff %filenum%-%exnum%\REG\userdiff
extents-win64.exe  C:\Windows\System32\config\userdiff %filenum%-%exnum%\REG\userdiff.LOG1
extents-win64.exe  C:\Windows\System32\config\userdiff %filenum%-%exnum%\REG\userdiff.LOG2
extents-win64.exe  C:\Windows\INF\setupapi.dev.log %filenum%-%exnum%\REG\setupapi.dev.log
:NTUSER
ECHO.
ECHO Listing NTUser.dat files...
ECHO For each user, NTUser.dat and UsrClass.dat will be copied
ECHO.
dir /a/b/s c:\users\*NTUser.dat
echo.
echo WHEN DONE, PRESS ENTER
set path1=EXIT
Set /p path1=Select FULL path to NTUSER.DAT to copy and right click, then right click to paste here:
if %path1% == EXIT goto cip
:run1
mkdir %filenum%-%exnum%\REG\%path1:~9,-10%
set path2=%path1:~0,-10%AppData\Local\Microsoft\Windows\UsrClass.dat
mkdir %filenum%-%exnum%\REG\%path2:~9,-13%
extents-win64.exe %path1% %filenum%-%exnum%\REG\%path1:~9,100%
extents-win64.exe %path1%.LOG1 %filenum%-%exnum%\REG\%path1:~9,100%.LOG1
extents-win64.exe %path1%.LOG2 %filenum%-%exnum%\REG\%path1:~9,100%.LOG2
extents-win64.exe %path2% %filenum%-%exnum%\REG\%path2:~9,100%
extents-win64.exe %path2%.LOG1 %filenum%-%exnum%\REG\%path2:~9,100%.LOG1
extents-win64.exe %path2%.LOG2 %filenum%-%exnum%\REG\%path2:~9,100%.LOG2
goto NTUSER
:cip
::md5sum.exe %filenum%-%exnum%\REG\* > %filenum%-%exnum%\REG\%filenum%-%exnum%.md5
::md5sum.exe %path1:~0,-10%* >> %filenum%-%exnum%\REG\%filenum%-%exnum%.md5
::md5sum.exe %filenum%-%exnum%\REG\%path2:~9,100%* >> %filenum%-%exnum%\REG\%filenum%-%exnum%.md5
pause