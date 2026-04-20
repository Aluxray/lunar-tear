@echo off
setlocal enabledelayedexpansion
setlocal

:: Usage
if /i "%~1"=="--help" goto usage
goto parse

:usage
echo.
echo  USAGE: launch-server.bat [OPTIONS]
echo.
echo  OPTIONS:
echo    --host, -h          ^<ip^>      Host IP passed to apk                           (default: 10.0.2.2)
echo    --port, -p          ^<port^>    HTTP port passed to apk                         (default: 8080)
echo    --scene, -s         ^<scene^>   Scene to load (defaults to last scene saved)    (default: last scene in snaphot)
echo    --server-path, -sp  ^<path^>    Path to server folder                           (default: .\server)
echo    --help                        Show this help message
echo.
echo  EXAMPLES:
echo    launch-serve.bat
echo    launch-serve.bat -sp .\server -h 100.x.x.x -p 4242 -s 0
echo    launch-serve.bat --host 100.x.x.x --port 4242 --scene 0
echo    launch-serve.bat --server-path .\server
echo.
exit /b 0

:: Parse arguments
:parse
set "HOST=100.100.160.68"
set "PORT=8080"
set "SERVER_PATH=.\server"
set "SCENE="

:parse_args
if "%~1"=="" goto done_args
if /i "%~1"=="--host"           ( set "HOST=%~2"        & shift & shift & goto parse_args )
if /i "%~1"=="-h"               ( set "HOST=%~2"        & shift & shift & goto parse_args )
if /i "%~1"=="--port"           ( set "PORT=%~2"        & shift & shift & goto parse_args )
if /i "%~1"=="-p"               ( set "PORT=%~2"        & shift & shift & goto parse_args )
if /i "%~1"=="--scene"          ( set "SCENE=%~2"       & shift & shift & goto parse_args )
if /i "%~1"=="-s"               ( set "SCENE=%~2"       & shift & shift & goto parse_args )
if /i "%~1"=="--server-path"    ( set "SERVER_PATH=%~2" & shift & shift & goto parse_args )
if /i "%~1"=="-sp"              ( set "SERVER_PATH=%~2" & shift & shift & goto parse_args )
shift
goto parse_args
:done_args

:: Strip trailing backslash from SERVER_PATH
if "%SERVER_PATH:~-1%"=="\" set "SERVER_PATH=%SERVER_PATH:~0,-1%"

:: Recover last scene created in snaphots
@REM if "%SCENE%"=="" (
@REM     for /f "tokens=2 delims=_." %%N in ('dir /b /o-d %SERVER_PATH%\snapshots\scene_*.json') do (
@REM         set "SCENE=%%N"
@REM         goto :end_loop
@REM     )
@REM     :end_loop
@REM     echo [i] Loaded scene !SCENE!.
@REM )

:: Launch server
cd %SERVER_PATH%
:: go run .\cmd\lunar-tear --host %HOST% --http-port %PORT% --scene %SCENE%
go run .\cmd\lunar-tear --host %HOST% --http-port %PORT%
if errorlevel 1 ( echo ERROR: couldn't launch server & exit /b 1 )

endlocal
