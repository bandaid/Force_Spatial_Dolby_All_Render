@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem =========================
rem User config
rem =========================
set "NIR=%USERPROFILE%\NirTools"
set "LOGDIR=%NIR%\Log"
set "LOG=%LOGDIR%\Force_Spatial_Dolby_All_Render.log"

rem Prefer console tool if present, fallback to GUI tool.
set "SVCL=%NIR%\svcl.exe"
set "SVV=%NIR%\SoundVolumeView.exe"

rem Spatial formats to try
set "FMT_PRIMARY=Dolby Atmos for Headphones"
set "FMT_FALLBACK=Dolby Atmos"

rem Delay to let Windows audio stack and Dolby components initialize
set "STARTUP_DELAY_SEC=25"

rem Retry behavior per target/format
set "MAX_TRIES=6"
set "TRY_PAUSE_SEC=2"

rem Targets
set "T_DEFAULT=DefaultRenderDevice"
set "T_MULTI=DefaultRenderDeviceMulti"
set "T_COMM=DefaultRenderDeviceComm"
set "T_ALL_RENDER=*\Render"

rem =========================
rem Setup
rem =========================
if not exist "%LOGDIR%" mkdir "%LOGDIR%" >nul 2>&1

call :Log INFO "Starting Force_Spatial_Dolby_All_Render"

timeout /t %STARTUP_DELAY_SEC% /nobreak >nul

if exist "%SVCL%" (
  set "TOOL=%SVCL%"
  set "TOOLNAME=svcl.exe"
) else (
  set "TOOL=%SVV%"
  set "TOOLNAME=SoundVolumeView.exe"
)

if not exist "%TOOL%" (
  call :Log ERROR "Missing tool at %TOOL%"
  exit /b 2
)

call :Log INFO "Using %TOOLNAME% at %TOOL%"

rem =========================
rem Apply passes
rem =========================
call :ApplyTarget "%T_DEFAULT%"
call :ApplyTarget "%T_MULTI%"
call :ApplyTarget "%T_COMM%"
call :ApplyTarget "%T_ALL_RENDER%"

call :Log INFO "Done"
exit /b 0

rem =========================
rem Functions
rem =========================
:ApplyTarget
set "TARGET=%~1"
call :Log INFO "Target %TARGET%"

call :TrySetSpatial "%TARGET%" "%FMT_PRIMARY%"
if errorlevel 1 call :TrySetSpatial "%TARGET%" "%FMT_FALLBACK%"

exit /b 0

:TrySetSpatial
set "TARGET=%~1"
set "FMT=%~2"

for /l %%I in (1,1,%MAX_TRIES%) do (
  rem /SaveFileEncoding is harmless here, keeps behavior consistent across Nir tools.
  rem If using svcl.exe, /Stdout will list affected items, useful for logging.
  if /I "%TOOLNAME%"=="svcl.exe" (
    "%TOOL%" /Stdout /SaveFileEncoding 1 /SetSpatial "%TARGET%" "%FMT%" >>"%LOG%" 2>&1
  ) else (
    "%TOOL%" /SaveFileEncoding 1 /SetSpatial "%TARGET%" "%FMT%" >nul 2>&1
  )

  set "RC=!errorlevel!"
  if "!RC!"=="0" (
    call :Log OK "SetSpatial OK target=%TARGET% fmt=%FMT% try=%%I"
    exit /b 0
  )

  timeout /t %TRY_PAUSE_SEC% /nobreak >nul
)

call :Log FAIL "SetSpatial FAIL target=%TARGET% fmt=%FMT%"
exit /b 1

:Log
set "LVL=%~1"
set "MSG=%~2"
>>"%LOG%" echo %DATE% %TIME% %LVL% %MSG%
exit /b 0
