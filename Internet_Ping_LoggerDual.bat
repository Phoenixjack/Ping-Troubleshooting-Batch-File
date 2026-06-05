@echo off
setlocal enabledelayedexpansion
set INTERVAL_SECONDS=15

REM ================================
REM Dual Ping Logger
REM Pings router and internet once per minute
REM Close this window to stop logging
REM ================================

set ROUTER=

REM Try to find the default IPv4 gateway from the Windows route table
for /f "tokens=3" %%G in ('route print 0.0.0.0 ^| findstr /R "^[ ]*0.0.0.0"') do (
    set ROUTER=%%G
    goto FOUND_GATEWAY
)

:FOUND_GATEWAY

if "%ROUTER%"=="" (
    echo Could not automatically find the router/default gateway.
    echo Router ping will be skipped.
    set ROUTER=UNKNOWN
) else (
    echo Detected router/default gateway: %ROUTER%
)

set INTERNET=8.8.8.8
set LOGFILE=%USERPROFILE%\Desktop\internet_ping_log.csv

echo Starting dual ping logger...
echo Router target: %ROUTER%
echo Internet target: %INTERNET%
echo Log file: %LOGFILE%
echo.
echo Close this window to stop logging.
echo.

if exist "%LOGFILE%" (
    echo Logfile found. Appending new data.
)

if not exist "%LOGFILE%" (
    echo Logfile NOT found. Creating new file.
    echo "%date%","%time%","%TARGET%","%STATUS%","%LATENCY%" >> "%LOGFILE%"
)

:LOOP
call :PING_AND_LOG %ROUTER%
call :PING_AND_LOG %INTERNET%

echo.
timeout /t %INTERVAL_SECONDS% /nobreak >nul
goto LOOP


:PING_AND_LOG
set TARGET=%1
set STATUS=FAIL
set LATENCY=

for /f "tokens=*" %%A in ('ping -n 1 -w 3000 %TARGET%') do (
    echo %%A | find "Reply from" >nul
    if !errorlevel! == 0 (
        set STATUS=OK
        for /f "tokens=2 delims==" %%B in ("%%A") do (
            for /f "tokens=1 delims= " %%C in ("%%B") do (
                set LATENCY=%%C
            )
        )
    )
)

set LATENCY=%LATENCY:ms=%

echo "%date%","%time%","%TARGET%","%STATUS%","%LATENCY%" >> "%LOGFILE%"
echo %date% %time%  Target: %TARGET%  Status: %STATUS%  Latency: %LATENCY% ms

exit /b