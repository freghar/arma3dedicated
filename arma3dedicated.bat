@echo off
setlocal enableextensions enabledelayedexpansion

REM (anything starting with REM is a comment)

REM portable folder with all the persistent data (configs, vars, etc.)
set configdir=dedicated-config
REM server profile name (used inside configdir)
set profile=server
REM temporary folder for one server run on this machine (can be deleted)
set tmpdir=dedicated-local-tmp

REM set to 1 to never write to configdir (useful for debugging; when you're
REM trying out various .vars.Arma3Profile backups and don't want server
REM startups rotating them out)
set readonly=

REM the ^ at the end of a line means it continues on the next one
REM (this assumes !Workshop folder inside Arma 3, as set up by the launcher)
set mods=^
!Workshop\@CBA_A3;^
!Workshop\@ace;^
!Workshop\@ACEX;^
!Workshop\@ACRE2;^
!Workshop\@Achilles;^
!Workshop\@Freghar's Arma Additions (Light);^
!Workshop\@ShackTac User Interface;^
!Workshop\@Overthrow;^


@echo on

if not exist "%configdir%" (
    @echo.
    @echo configdir does not exist, did you copy it over?
    pause & exit /B
)

set srcpath=%configdir%\%profile%
set dstdir=%tmpdir%\Users\%profile%
if not exist "%tmpdir%" (
    REM copy over profile from configdir, create Arma3 structure
    mkdir "%dstdir%" || (pause & exit /B)
    copy /B "%srcpath%.Arma3Profile" "%dstdir%\." || (pause & exit /B)
    if exist "%srcpath%.vars.Arma3Profile" (
        copy /B "%srcpath%.vars.Arma3Profile" "%dstdir%\."
    )
)

@echo.
@echo.
@echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo ::::: DO NOT CLOSE THIS TERMINAL, CLOSE ARMA WINDOW INSTEAD :::::
@echo :::::          (AND WAIT A FEW SECONDS AFTER THAT)          :::::
@echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

arma3server_x64.exe ^
	-port=2302 ^
	"-config=%configdir%\server.cfg" ^
	"-cfg=%configdir%\basic.cfg" ^
	"-profiles=%tmpdir%" -name=%profile% ^
	-noSplash ^
	-world=empty ^
    -enableHT ^
    -hugePages ^
    -noLogs ^
	"-mod=%mods%"

if errorlevel 1 (pause & exit /B)


set backups=%configdir%\oldvars
set oldvarprefix=%backups%\%profile%.vars.Arma3Profile
set vars=%configdir%\%profile%.vars.Arma3Profile
set tmpvars=%tmpdir%\Users\%profile%\%profile%.vars.Arma3Profile
if not defined readonly (
    if not exist "%backups%" (
        mkdir "%backups%" || (pause & exit /B)
    )
    REM rotate old backups
    for /L %%i in (3,-1,1) do (
        set /A j=%%i+1
        if exist "%oldvarprefix%.%%i" (
            move /Y "%oldvarprefix%.%%i" "%oldvarprefix%.!j!"
        )
    )
    REM move original vars from configdir into backup
    move /Y "%vars%" "%oldvarprefix%.1" || (pause & exit /B)
    REM copy new vars from tmpdir to configdir
    copy /B /Y "%tmpvars%" "%vars%" || (pause & exit /B)
)
