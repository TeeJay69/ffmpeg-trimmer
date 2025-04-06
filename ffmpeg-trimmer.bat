@echo off
setlocal enabledelayedexpansion

REM Prompt for the input file path
set /p "filepath=Enter the full path to the file: "

REM Prompt for the cut time (format: HH:MM:SS)
set /p "cutTime=Enter the time to cut the file (HH:MM:SS): "

REM Extract directory, filename, and extension from the input file path
for %%a in ("%filepath%") do (
    set "dir=%%~dpa"
    set "name=%%~na"
    set "ext=%%~xa"
)

REM Build the output file name (appending _trimmed to the original file name)
set "output=!dir!!name!_trimmed!ext!"

REM Use ffmpeg to trim the file starting from the specified time
ffmpeg -i "%filepath%" -ss %cutTime% -c copy "%output%"

echo.
echo File trimmed successfully!
echo Output file: %output%
pause
