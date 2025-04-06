@echo off
setlocal enabledelayedexpansion

REM Prompt for the input file path
set /p "filepath=Enter the full path to the file: "
REM Remove any quotes that may have been entered
set "filepath=%filepath:"=%"

REM Prompt for the trimming mode
echo Choose trimming mode:
echo   1) Trim from a specified time until the end
echo   2) Trim from the beginning until a specified time
echo   3) Trim from a specified start time to a specified end time
set /p "mode=Enter mode (1, 2, or 3): "

REM Extract directory, filename, and extension from the input file path
for %%a in ("%filepath%") do (
    set "dir=%%~dpa"
    set "name=%%~na"
    set "ext=%%~xa"
)

REM Build a temporary output file name (will be renamed later)
set "output=%dir%%name%_trimmed%ext%"

REM Depending on the mode, prompt for time values and build the ffmpeg command
if /i "%mode%"=="1" (
    REM Mode 1: Trim from a specified time until the end.
    set /p "startTime=Enter the start time (HH:MM:SS): "
    set "startTime=!startTime:"=!"
    echo Trimming from !startTime! to end...
    ffmpeg -i "%filepath%" -ss "!startTime!" -c copy "%output%"
) else if /i "%mode%"=="2" (
    REM Mode 2: Trim from the beginning until a specified time.
    set /p "endTime=Enter the end time (HH:MM:SS): "
    set "endTime=!endTime:"=!"
    echo Trimming from beginning until !endTime!...
    ffmpeg -i "%filepath%" -to "!endTime!" -c copy "%output%"
) else if /i "%mode%"=="3" (
    REM Mode 3: Trim from a specified start time to a specified end time.
    set /p "startTime=Enter the start time (HH:MM:SS): "
    set "startTime=!startTime:"=!"
    set /p "endTime=Enter the end time (HH:MM:SS): "
    set "endTime=!endTime:"=!"
    echo Trimming from !startTime! to !endTime!...
    ffmpeg -i "%filepath%" -ss "!startTime!" -to "!endTime!" -c copy "%output%"
) else (
    echo Invalid mode selected.
    pause
    exit /b 1
)

REM Check if ffmpeg succeeded (errorlevel 0) and that the output file exists
if errorlevel 1 (
    echo ffmpeg encountered an error. The file was not trimmed.
    pause
    exit /b 1
)
if not exist "%output%" (
    echo ffmpeg did not create the output file. Aborting file replacement.
    pause
    exit /b 1
)

echo ffmpeg succeeded and output file created.

REM Optionally, replace the original file: delete it and rename the trimmed output file
REM Uncomment the following lines if you want automatic replacement
REM del "%filepath%"
REM move /Y "%output%" "%filepath%"

echo.
echo Trim operation complete. Check the output file:
echo %output%
pause
